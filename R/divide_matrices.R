# Create data matrices for time constant and time-varying variables
# @param data a dataframe
# @param fixed a formula describing the mean structure
# @param random an optional formula describing the random effects (check this!)
# @param auxvars vector containing the names of auxiliary variables
# @param scale_vars vector naming which variables should be scaled.
#      If \code{NULL} (default) all continuous variables will be scaled during
#        the MCMC sampling, except when a transformed version of them is used.
#        If \code{FALSE} no scaling will be done.
# @param refcats specification of reference categories. If \code{NULL}, defaults will be used.
# @return a list containing matrices and other objects needed for other functions
# @export

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
      cens <- data[, outnam[2], drop = FALSE]
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
  trafosX <- extract_fcts(fixed, data, complete = TRUE)
  add_to_aux <- trafosX$var[which(!trafosX$var %in% c(colnames(X), auxvars))]
  add_to_aux <- add_to_aux[!sapply(data[add_to_aux], check_tvar, groups)]
  if (length(add_to_aux) > 0)
    auxvars <- c(auxvars, unique(add_to_aux))

  # fixed effects design matrices
  fixed2 <- as.formula(paste(c(sub(":", "*", deparse(fixed, width.cutoff = 500),
                                   fixed = TRUE),
                               auxvars), collapse = " + "))
  fcts_all <- extract_fcts(fixed2, data, complete = TRUE)


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

  # this can probably be deleted
  #
  # if (!is.null(auxvars)) {
  #   for (x in auxvars) {
  #     if (x %in% names(refs)) {
  #       dummies <- paste0(x, levels(refs[[x]])[levels(refs[[x]]) != refs[[x]]])
  #       attr(refs[[x]], "dummies") <- dummies
  #     }
  #   }
  # }


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

  # time-constant part of X
  Xcross <- X2[match(unique(groups), groups), !tvar, drop = FALSE]
  interact <- grep(":", colnames(Xcross), fixed = TRUE, value = TRUE)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = FALSE]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = FALSE]
  }

  if (!is.null(Xic)) {
    Xic <- Xic * NA
    # can probably deleted, since X2 should not include NAN's any more
    # Xic[is.na(Xic)] <- NA # to overwrite possible NaN's
  }




  # re-order columns in Xc -----------------------------------------------------
  # complete covariates first, then incomplete main effects, then fcts_mis/fcts
  # colnams <- colnames(Xc)
  # # names that need replacement
  # repl <- models[!names(models) %in% colnams & names(models) %in% fcts_mis$var]
  # colnams[colnams == fcts_mis$X_var[fcts_mis$var == names(repl)]] <-
  #   fcts_mis$var[fcts_mis$var == names(repl)]
  #
  # Xc_seq <- c(which(colSums(is.na(Xc)) == 0 &
  #                     (!gsub("[[:digit:]]*$", "", colnames(Xc)) %in% fcts_all$X_var |
  #                        colnames(Xc) %in% auxvars)),
  #             unlist(lapply(names(models), match_positions, data, colnams))
  # )
  #
  # Xc_seq <- c(Xc_seq, which(!1:ncol(Xc) %in% Xc_seq))

  # Xc <- Xc[, Xc_seq, drop = FALSE]
  Xc <- Xc[, sort_cols(Xc, fcts_all), drop = FALSE]

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

  # * Xlong --------------------
  if (!is.null(Xlong)) {
    linteract <- if (any(grepl(":", colnames(Xlong), fixed = TRUE))) {
      grep(":", colnames(Xlong), fixed = TRUE, value = TRUE)
    }

    Xl <- if (any(!colnames(Xlong) %in% linteract)) {
      Xl <- Xlong[, !colnames(Xlong) %in% linteract, drop = FALSE]
      Xl <- Xl[, sort_cols(Xl, fcts_all), drop = FALSE]
      #
      # Xl[, order(colSums(is.na(Xl))), drop = FALSE]
    }

    hc_interact <- unlist(sapply(hc_list, function(x) {
      names(x)[sapply(x, attr, 'matrix') == 'Xc']
      # names(which(attr(x, "matrix") == "Xc"))
    }))
    Xil <- if (!is.null(linteract) & any(!linteract %in% hc_interact)) {
      Xlong[, linteract[!linteract %in% hc_interact], drop = FALSE]
    }

    if (!is.null(Xil)) {
      Xil <- Xil * NA
    }

    # if (!is.null(Xl)) {
    #   if (sum(is.na(Xl)) > 0) {
    #     stop("Missing values in the longitudinal variables are not allowed.")
    #   }
    # }
  } else {
    Xl <- Xil <- NULL
  }


  # Xtrafo ---------------------------------------------------------------------
  fcts_mis <- extract_fcts(fixed2, data, complete = FALSE)

  if (any(fcts_mis$type %in% c('ns', 'bs')))
    stop("Splines are currently not implemented for incomplete variables.")


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
    #   if (any(!fcts_mis$X_var %in% c(colnames(Xc), colnames(Xl), colnames(Z))))
    #     stop(gettextf("%s is not a column of the design matrix Xc.",
    #                   paste(dQuote(fcts_mis$X_var[!fcts_mis$X_var %in% colnames(Xc)]),
    #                         collapse = ", ")),
    #                   "\nAre you using a transformation that results in multiple columns, e.g., splines?")
    Xc[, match(as.character(fcts_mis$X_var), colnames(Xc))] <- NA
  }

  if (!is.null(Xltrafo)) {
    #   if (any(!fcts_mis$X_var %in% c(colnames(Xc), colnames(Xl), colnames(Z))))
    #     stop(gettextf("%s is not a column of the design matrix Xc.",
    #                   paste(dQuote(fcts_mis$X_var[!fcts_mis$X_var %in% colnames(Xc)]),
    #                         collapse = ", ")),
    #                   "\nAre you using a transformation that results in multiple columns, e.g., splines?")
    Xl[, match(as.character(fcts_mis$X_var), colnames(Xl))] <- NA
  }



  # Xcat & Xlcat ---------------------------------------------------------------
  # make filter variables:
  # - variable relevant?
  infmla <- names(data) %in% all.vars(fixed2)
  # - variabe incomplete?
  misvar <- colSums(is.na(data)) > 0
  # - variabe categorical with >2 categories?
  catvars <- sapply(colnames(data), function(i) i %in% names(refs) && length(levels(refs[[i]])) > 2)


  # select names of relevant variables
  cat_vars_base <- names(data)[infmla & misvar & catvars & !sapply(data, check_tvar, groups)]
  cat_vars_long <- names(data)[infmla & catvars & sapply(data, check_tvar, groups)]

  # match them to the position in Xc
  cat_vars_base <- sapply(cat_vars_base, match_positions,
                          data, colnames(Xc), simplify = FALSE)

  # cat_vars_long <- sapply(cat_vars_long, match_positions,
  #                         data, colnames(Xl), simplify = FALSE)

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
    # Xl[, unlist(sapply(cat_vars_long[names(cat_vars_long) %in% names(models)], names))] <- NA
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
              trafos = fcts_mis, hc_list = hc_list, refs = refs,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars,
              fixed2 = fixed2, ncat = ncat,
              N = N, ppc = ppc, ridge = ridge, nranef = ncol(Z2)))
}
