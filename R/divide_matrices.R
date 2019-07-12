# split the data into matrices and obtain other relevant info for the further steps

divide_matrices <- function(data, fixed, analysis_type, random = NULL, auxvars = NULL,
                            scale_vars = NULL, refcats = NULL, models, warn = TRUE,
                            mess = TRUE, ppc = TRUE, ridge = FALSE, ...) {

  # general design matrix ------------------------------------------------------

  # extract the id variable from the random effects formula
  id <- extract_id(random, warn = warn)

  # define/identify groups/clusters in the data
  groups <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }


  # extract the outcome from the fixed effects formula
  outnam <- extract_outcome(fixed)
  if (analysis_type %in% c('survreg', 'coxph')) {
    if (length(outnam) == 2) {
      y <- data[, outnam[1], drop = FALSE]
      cens <- sapply(data[, outnam[2], drop = FALSE],
                     function(x) {
                       if (is.factor(x)) {
                         as.numeric(x) - 1
                       } else if (is.logical(x)) {
                         as.numeric(x)
                       } else  x
                     })
    } else {
      stop("Expected two outcome variables.")
    }
  } else {
    y <- data[, outnam, drop = FALSE]
    cens <- NULL
  }

  # * preliminary design matrix ------------------------------------------------
  X <- model.matrix(fixed, model.frame(fixed, data, na.action = na.pass))

  # variables that do not have a main effect in fixed are added to the auxiliary variables
  trafosX <- extract_fcts(fixed, data, random = random, complete = TRUE)
  add_to_aux <- trafosX$var[which(!trafosX$var %in% c(colnames(X), auxvars))]

  if (length(add_to_aux) > 0 & !is.null(models))
    auxvars <- c(auxvars, unique(add_to_aux))

  # fixed effects design matrices
  fixed2 <- as.formula(paste(c(sub(":", "*", deparse(fixed, width.cutoff = 500),
                                   fixed = TRUE),
                               auxvars), collapse = " + "))
  fcts_all <- extract_fcts(fixed2, data, random = random, complete = TRUE)


  # Give a message about coding of ordinal factors if there are any in the predictor
  if (any(unlist(sapply(data[, all.vars(fixed2[c(1,3)])],
                        class)) == 'ordered') & mess)
    message("Note: ordered factors are included as dummy variables into the linear predictor (not as orthogonal polynomials).")



  # * reference categories -----------------------------------------------------
  refs <- get_refs(fixed2, data, refcats)

  for (i in names(refs)) {
    data[, i] <- relevel(factor(data[, i], ordered = FALSE),
                         as.character(refs[[i]]))
  }


  # * final design matrix ------------------------------------------------------
  X2 <- model.matrix(fixed2,
                     model.frame(fixed2, data, na.action = na.pass))

  X2[is.nan(X2)] <- NA


  # Z --------------------------------------------------------------------------
  # random effects design matrix
  Z <- if (!is.null(random)) {
    model.matrix(as.formula(remove_grouping(random)),
                 model.frame(as.formula(remove_grouping(random)),
                             data, na.action = na.pass))
  }


  # Xc and Xic -----------------------------------------------------------------
  tvar <- apply(X2, 2, check_tvar, groups)

  # make sure that interactions where at least one partner is time-varying
  # are also recognized as time-varying
  inter <- grep(":", names(tvar), fixed = TRUE, value = TRUE)
  if (length(inter) > 0)
    tvar[inter[sapply(strsplit(inter, ':'), function(k) any(tvar[k]))]] <- TRUE


  # time-constant part of X
  Xcross <- X2[match(unique(groups), groups), !tvar, drop = FALSE]
  interact <- grep(":", colnames(Xcross), fixed = TRUE, value = TRUE)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = FALSE]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = FALSE]
  }

  if (!is.null(Xic)) Xic <- Xic * NA

  # re-order columns in Xc -----------------------------------------------------
  Xc <- Xc[, sort_cols(Xc, fcts_all, auxvars), drop = FALSE]

  # * update Z -------------------------------------------------
  Z2 <- Z
  if (!is.null(Z)) {
    Z[, na.omit(match(colnames(Xc)[-1], colnames(Z)))] <- 1
    colnames(Z)[na.omit(match(colnames(Xc)[-1], colnames(Z)))] <- 'placeholder'
  }

  # Xl and Xil -----------------------------------------------------------------
  Xlong <- if (sum(!names(tvar)[tvar] %in% colnames(Z)) > 0) {
    X2[, which(tvar & !names(tvar) %in% colnames(Z)), drop = FALSE]
  }

  # * hc_list -------------------------------------------------------
  hc_list <- if (!is.null(random))
    get_hc_list(X2, Xc, Xic, Z, Z2, Xlong)

  # * Xlong --------------------------------------------------------------------
  if (!is.null(Xlong)) {
    linteract <- if (any(grepl(":", colnames(Xlong), fixed = TRUE))) {
      grep(":", colnames(Xlong), fixed = TRUE, value = TRUE)
    }

    Xl <- if (any(!colnames(Xlong) %in% linteract)) {
      Xl <- Xlong[, !colnames(Xlong) %in% linteract, drop = FALSE]
      Xl <- Xl[, sort_cols(Xl, fcts_all, auxvars), drop = FALSE]
    }

    hc_interact <- unlist(sapply(hc_list, function(x) {
      names(x)[sapply(x, attr, 'matrix') == 'Xc']
    }))

    Xil <- if (!is.null(linteract) & any(!linteract %in% hc_interact)) {
      Xlong[, linteract[!linteract %in% hc_interact], drop = FALSE]
    }

    if (!is.null(Xil)) Xil <- Xil * NA

  } else {
    Xl <- Xil <- NULL
  }


  # Xtrafo ---------------------------------------------------------------------
  fcts_mis <- extract_fcts(fixed2, data, random = random, complete = FALSE)

  if (any(fcts_mis$type %in% c('ns', 'bs')))
    stop("Splines are currently not implemented for incomplete variables.",
         call. = FALSE)

  # if (any(fcts_mis$type %in% c('ns')))
  #   stop(paste0("Natural cubic splines are not implemented for incomplete variables. ",
  #               "Please use B-splines (using ", dQuote("bs()"), ") instead."),
  #        call. = FALSE)

  if (!is.null(fcts_mis)) {
    fmla_trafo <- as.formula(
      paste("~", paste0(unique(fcts_mis$var), collapse = " + "))
    )

    Xt <- model.matrix(fmla_trafo,
                       model.frame(fmla_trafo, data, na.action = na.pass)
    )[, -1, drop = FALSE]

    Xtrafo_tvar <- apply(Xt, 2, check_tvar, groups)

    Xtrafo <- if (any(!Xtrafo_tvar)) Xt[match(unique(groups), groups), !Xtrafo_tvar, drop = FALSE]
    Xltrafo <- if (any(Xtrafo_tvar)) Xt[, Xtrafo_tvar, drop = FALSE]
  } else {
    Xtrafo <- Xltrafo <- NULL
  }

  if (!is.null(Xtrafo)) {
    Xc[, match(as.character(fcts_mis$X_var), colnames(Xc))] <- NA
  }

  if (!is.null(Xltrafo)) {
    Xl[, match(as.character(fcts_mis$X_var), colnames(Xl))] <- NA
    Z[, match(as.character(fcts_mis$X_var), colnames(Z))] <- NA
  }



  # Xcat & Xlcat ---------------------------------------------------------------
  # make filter variables:
  # - variable relevant?
  infmla <- names(data) %in% all.vars(fixed2)
  # - variabe incomplete?
  misvar <- colSums(is.na(data)) > 0
  # - variabe categorical with >2 categories?
  catvars <- sapply(colnames(data), function(i) i %in% names(refs) && length(levels(refs[[i]])) > 2)

  misvar_long <- if (any(infmla & !sapply(data, check_tvar, groups) & misvar)) TRUE else misvar

  # select names of relevant variables
  cat_vars_base <- names(data)[infmla & misvar & catvars & !sapply(data, check_tvar, groups)]
  cat_vars_long <- names(data)[infmla & misvar_long & catvars & sapply(data, check_tvar, groups)]

  # match them to the position in Xc
  cat_vars_base <- sapply(cat_vars_base, match_positions,
                          data, colnames(Xc), simplify = FALSE)


  Xcat <- if (length(cat_vars_base) > 0) {
    data[match(unique(groups), groups), names(cat_vars_base), drop = FALSE]
  }

  if (!is.null(Xcat)) {
    Xc[, unlist(sapply(cat_vars_base, names))] <- NA
  }

  Xlcat <- if (length(cat_vars_long) > 0) {
    data[, cat_vars_long, drop = FALSE]
  }

  if (!is.null(Xlcat)) {
    Xl[, match(unlist(lapply(refs[cat_vars_long], attr, 'dummies')), colnames(Xl))] <- NA
    Z[, match(unlist(lapply(refs[cat_vars_long], attr, 'dummies')), colnames(Z))] <- NA
  }


  # scaling --------------------------------------------------------------------
  if (is.null(scale_vars)) {
    scale_vars <- find_continuous_main(fixed2, data)

    compl_fcts_vars <- fcts_all$X_var[fcts_all$type != "identity" &
                                        colSums(is.na(data[, fcts_all$var, drop = FALSE])) == 0]

    excl <- grep("[[:alpha:]]*\\(", scale_vars, value = TRUE)
    excl <- c(excl, unique(fcts_mis$X_var))
    excl <- excl[!excl %in% compl_fcts_vars]

    scale_vars <- scale_vars[which(!scale_vars %in% excl)]
    if (length(scale_vars) == 0) scale_vars <- NULL
  }


  ncat <- if (analysis_type %in% c('clmm', 'clm'))
    length(unique(unlist(y)))

  N <- length(unique(groups))


  XXnam <- colnames(model.matrix(fixed, data))
  if (analysis_type %in% c('clm', 'clmm', 'coxph'))
    XXnam <- XXnam[-1]

  cols_main <- list(Xc = c(na.omit(match(XXnam[!XXnam %in% names(hc_list)], colnames(Xc)))),
                    Xl = if (!is.null(Xl)) c(na.omit(match(XXnam, colnames(Xl)))),
                    Xic = if (!is.null(Xic)) c(na.omit(match(XXnam, colnames(Xic)))),
                    Xil = if (!is.null(Xil)) c(na.omit(match(XXnam, colnames(Xil)))),
                    Z = if (!is.null(Z)) c(na.omit(match(XXnam, colnames(Z))))
  )
  cols_main <- sapply(cols_main, function(x) if (length(x) > 0) x)

  names_main <- mapply(function(cols, mat) {
    colnames(mat)[cols]
  }, cols = cols_main,
  mat = list(Xc, Xl, Xic, Xil, Z))

  return(list(y = y, cens = cens,
              Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat, Xlcat = Xlcat,
              Xtrafo = Xtrafo, Xltrafo = Xltrafo,
              Z = Z, cols_main = cols_main, names_main = names_main,
              trafos = fcts_all, hc_list = hc_list, refs = refs,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars,
              fixed2 = fixed2, ncat = ncat,
              N = N, ppc = ppc, ridge = ridge, nranef = ncol(Z2)))
}
