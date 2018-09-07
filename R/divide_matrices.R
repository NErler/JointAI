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

divide_matrices <- function(data, fixed, random = NULL, auxvars = NULL,
                            scale_vars = NULL, refcats = NULL, meth, warn = TRUE,
                            mess = TRUE, ...) {
  id <- extract_id(random, warn = warn)

  groups <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }

  y <- data[, extract_y(fixed), drop = FALSE]

  # preliminary design matrix
  X <- model.matrix(fixed, model.frame(fixed, data, na.action = na.pass))

  # variables that do not have a main effect in fixed are added to the auxiliary variables
  trafosX <- extract_fcts(fixed, data, complete = TRUE)
  add_to_aux <- trafosX$var[which(!trafosX$var %in% c(colnames(X), auxvars))]
  if(length(add_to_aux) > 0)
    auxvars <- c(auxvars, unique(add_to_aux))

  # remove grouping specification from random effects formula
  random2 <- remove_grouping(random)

  # random effects design matrix
  Z <- if (!is.null(random)) {
    model.matrix(as.formula(random2), data)
  }

  # fixed effects design matrices
  fixed2 <- as.formula(paste(c(sub(":", "*", deparse(fixed), fixed = TRUE),
                               auxvars), collapse = " + "))

  refs <- get_refs(fixed2, data, refcats)
  for (i in names(refs)) {
    data[, i] <- relevel(factor(data[, i], ordered = FALSE), as.character(refs[[i]]))
  }

  if (!is.null(auxvars)) {
    for (x in auxvars) {
      if (x %in% names(refs)) {
        dummies <- paste0(x, levels(refs[[x]])[levels(refs[[x]]) != refs[[x]]])
        attr(refs[[x]], "dummies") <- dummies
      }
    }
  }


  X2 <- model.matrix(fixed2,
                     model.frame(fixed2, data, na.action = na.pass))

  X2[is.nan(X2)] <- NA

  tvar <- apply(X2, 2, check_tvar, groups)

  # time-constant part of X
  Xcross <- X2[match(unique(groups), groups), !tvar, drop = FALSE]
  interact <- grep(":", colnames(Xcross), fixed = TRUE, value = TRUE)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = FALSE]
  # Xc <- Xc[, order(colSums(is.na(Xc))), drop = FALSE]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = FALSE]
  }
  if (!is.null(Xic)) {
    Xic <- Xic * NA
    Xic[is.na(Xic)] <- NA # to overwrite possible NaN's
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
    if (!any(sapply(data[, all.vars(fmla_trafo), drop = FALSE], is.factor)))
      contr <- NULL
    model.matrix(fmla_trafo,
                 model.frame(fmla_trafo, data, na.action = na.pass),
                 contrasts.arg = contr
    )[match(unique(groups), groups), -1, drop = FALSE]
  }
  if (!is.null(Xtrafo)) {
    if (any(!trafos$Xc_var %in% colnames(Xc)))
      stop(gettextf("%s is not a column of the design matrix Xc.",
                    paste(dQuote(trafos$Xc_var[!trafos$Xc_var %in% colnames(Xc)]),
                          collapse = ", ")),
                    "\nAre you using a transformation that results in multiple columns, e.g., splines?")
    Xc[, as.character(trafos$Xc_var)] <- NA
  }

  # re-order columns in Xc
  colnams = colnames(Xc)
  # names that need replacement
  repl <- meth[!names(meth) %in% colnams & names(meth) %in% trafos$var]
  colnams[colnams == trafos$Xc_var[trafos$var == names(repl)]] <-
    trafos$var[trafos$var == names(repl)]

  Xc_seq <- c(which(colSums(is.na(Xc)) == 0 &
                      (!gsub("[[:digit:]]*$", "", colnames(Xc)) %in% fcts$Xc_var |
                         colnames(Xc) %in% auxvars)),
              unlist(lapply(names(meth), match_positions, data, colnams))
  )

  Xc_seq <- c(Xc_seq, which(!1:ncol(Xc) %in% Xc_seq))

  Xc <- Xc[, Xc_seq, drop = FALSE]

  # * categorical covariates -----------------------------------------------------
  # variable relevant?
  infmla <- names(data) %in% all.vars (fixed2)
  # variabe incomplete?
  misvar <- colSums(is.na(data)) > 0
  # variabe categorical with >2 categories?
  catvars <- sapply(data, function(i) is.factor(i) && length(levels(i)) > 2)

  cat_vars <- names(data)[infmla & misvar & catvars]
  cat_vars <- sapply(cat_vars, match_positions, data, colnames(Xc), simplify = FALSE)


  Xcat <- if (length(cat_vars) > 0) {
    data[match(unique(groups), groups), names(cat_vars), drop = FALSE]
  }
  if (!is.null(Xcat)) {
    Xc[, unlist(sapply(cat_vars, names))] <- NA
  }



  # Xlong ----------------------------------------------------------------------
  Xlong <- if (sum(!names(tvar)[tvar] %in% colnames(Z)) > 0) {
    X2[, which(tvar & !names(tvar) %in% colnames(Z)), drop = FALSE]
  }

  hc_list <- if (!is.null(random)) get_hc_list(X2, Xc, Xic, Z, Xlong)


  if (!is.null(Xlong)) {
    linteract <- if (any(grepl(":", colnames(Xlong), fixed = TRUE))) {
      grep(":", colnames(Xlong), fixed = TRUE, value = TRUE)
    }

    Xl <- if (any(!colnames(Xlong) %in% linteract)) {
      Xlong[, !colnames(Xlong) %in% linteract, drop = FALSE]
    }

    hc_interact <- unlist(sapply(hc_list, function(x) {
      names(which(attr(x, "matrix") == "Xc"))
    }))
    Xil <- if (!is.null(linteract) & any(!linteract %in% hc_interact)) {
      Xlong[, linteract[!linteract %in% hc_interact], drop = FALSE]
    }

    if (!is.null(Xil)) {
      Xil <- Xil * NA
    }

    if (!is.null(Xl)) {
      if (sum(is.na(Xl)) > 0) {
        stop("Missing values in the longitudinal variables are not allowed.")
      }
    }
  } else {
    Xl <- Xil <- NULL
  }

  if (is.null(scale_vars)) {
    scale_vars <- find_continuous_main(fixed2, data)
    # fcts <- extract_fcts(fixed2, data, complete = TRUE)
    compl_fcts_vars <- fcts$Xc_var[fcts$type != "identity" &
                                     colSums(is.na(data[, fcts$var, drop = FALSE])) == 0]

    excl <- grep("[[:alpha:]]*\\(", scale_vars, value = TRUE)
    excl <- c(excl, unique(trafos$Xc_var))
    excl <- excl[!excl %in% compl_fcts_vars]

    # if (!is.null(trafos)) {
    #   qdrtrafos <- unlist(sapply(split(trafos, trafos$var), function(x) {
    #     if (all(x$Xc_var %in% c(x$var, paste0("I(", x$var, "^2)")))) x$Xc_var
    #   }))
    #   excl <- excl[!excl %in% qdrtrafos]
    # }

    scale_vars <- scale_vars[which(!scale_vars %in% excl)]
    if (length(scale_vars) == 0) scale_vars <- NULL
  }


  return(list(y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat,
              Xtrafo = Xtrafo, Z = Z,
              trafos = trafos, hc_list = hc_list, refs = refs,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars,
              fixed2 = fixed2, X2_names = colnames(X2)))
}
