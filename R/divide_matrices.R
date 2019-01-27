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
  fixed2 <- as.formula(paste(c(sub(":", "*", deparse(fixed), fixed = TRUE),
                               auxvars), collapse = " + "))

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
  # remove grouping specification from random effects formula
  random2 <- remove_grouping(random)

  # random effects design matrix
  Z <- if (!is.null(random)) {
    model.matrix(as.formula(random2), model.frame(as.formula(random2), data, na.action = na.pass))
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


  # Xtrafo ---------------------------------------------------------------------
  trafos <- extract_fcts(fixed2, data)

  if (any(trafos$type %in% c('ns', 'bs')))
    stop("Splines are currently not implemented for incomplete variables.")

  fcts <- extract_fcts(fixed2, data, complete = TRUE)

  Xtrafo <- if (!is.null(trafos)) {
    fmla_trafo <- as.formula(
      paste("~", paste0(unique(trafos$var), collapse = " + "))
    )
    model.matrix(fmla_trafo,
                 model.frame(fmla_trafo, data, na.action = na.pass)
    )[match(unique(groups), groups), -1, drop = FALSE]
  }

  if (!is.null(Xtrafo)) {
    if (any(!trafos$X_var %in% colnames(Xc)))
      stop(gettextf("%s is not a column of the design matrix Xc.",
                    paste(dQuote(trafos$X_var[!trafos$X_var %in% colnames(Xc)]),
                          collapse = ", ")),
                    "\nAre you using a transformation that results in multiple columns, e.g., splines?")
    Xc[, as.character(trafos$X_var)] <- NA
  }


  # re-order columns in Xc -----------------------------------------------------
  colnams = colnames(Xc)
  # names that need replacement
  repl <- models[!names(models) %in% colnams & names(models) %in% trafos$var]
  colnams[colnams == trafos$X_var[trafos$var == names(repl)]] <-
    trafos$var[trafos$var == names(repl)]

  Xc_seq <- c(which(colSums(is.na(Xc)) == 0 &
                      (!gsub("[[:digit:]]*$", "", colnames(Xc)) %in% fcts$X_var |
                         colnames(Xc) %in% auxvars)),
              unlist(lapply(names(models), match_positions, data, colnams))
  )

  Xc_seq <- c(Xc_seq, which(!1:ncol(Xc) %in% Xc_seq))

  Xc <- Xc[, Xc_seq, drop = FALSE]
  # * update Z -------------------------------------------------
  Z2 <- Z
  if(!is.null(Z)) {
    Z[, na.omit(match(colnames(Xc)[-1], colnames(Z)))] <- 1
    colnames(Z)[na.omit(match(colnames(Xc)[-1], colnames(Z)))] <- 'placeholder'
  }

  # Xcat -----------------------------------------------------------------------
  # make filter variables:
  # - variable relevant?
  infmla <- names(data) %in% all.vars(fixed2)
  # - variabe incomplete?
  misvar <- colSums(is.na(data)) > 0
  # - variabe categorical with >2 categories?
  catvars <- sapply(data, function(i) is.factor(i) && length(levels(i)) > 2)

  # select names of relevant variables
  cat_vars <- names(data)[infmla & misvar & catvars]

  # match them to the position in Xc
  cat_vars <- sapply(cat_vars, match_positions,
                     data, colnames(Xc), simplify = FALSE)

  Xcat <- if (length(cat_vars) > 0) {
    data[match(unique(groups), groups), names(cat_vars), drop = FALSE]
  }

  if (!is.null(Xcat)) {
    Xc[, unlist(sapply(cat_vars, names))] <- NA
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
      Xl[, order(colSums(is.na(Xl))), drop = FALSE]
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

  # scaling --------------------------------------------------------------------
  if (is.null(scale_vars)) {
    scale_vars <- find_continuous_main(fixed2, data)

    compl_fcts_vars <- fcts$X_var[fcts$type != "identity" &
                                     colSums(is.na(data[, fcts$var, drop = FALSE])) == 0]

    excl <- grep("[[:alpha:]]*\\(", scale_vars, value = TRUE)
    excl <- c(excl, unique(trafos$X_var))
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

  return(list(y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat,
              Xtrafo = Xtrafo, Z = Z, cens = cens, cols_main = cols_main,
              trafos = trafos, hc_list = hc_list, refs = refs,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars,
              fixed2 = fixed2, names_main = names_main, ncat = ncat,
              N = N, ppc = ppc, ridge = ridge, nranef = ncol(Z2)))
}
