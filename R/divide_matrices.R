# Create data matrices for time constant and time-varying variables
# @param DF a dataframe
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

divide_matrices <- function(DF, fixed, random = NULL, auxvars = NULL,
                            scale_vars = NULL, refcats = NULL, meth) {
  id <- extract_id(random)

  groups <- if (!is.null(id)) {
    DF[, id]
  } else {
    1:nrow(DF)
  }

  y <- DF[, extract_y(fixed), drop = F]

  # remove grouping specification from random effects formula
  random2 <- remove_grouping(random)

  # random effects design matrix
  Z <- if (!is.null(random)) {
    model.matrix(as.formula(random2), DF)
  }

  # fixed effects design matrices
  fixed2 <- as.formula(paste(c(sub(":", "*", deparse(fixed), fixed = T),
                               auxvars), collapse = " + "))


  ord <- names(which(sapply(DF[, all.vars(fixed2)], is.ordered)))
  contr <- as.list(rep("contr.treatment", length(ord)))
  names(contr) <- ord

  covars <- all.vars(fixed2)[all.vars(fixed2) != extract_y(fixed2)]
  factors <- covars[sapply(DF[, covars, drop = F], is.factor)]

  refs <- get_refs(factors, refcats, DF)
  for (i in names(refs)) {
    DF[, i] <- relevel(factor(DF[, i], ordered = F), as.character(refs[[i]]))
  }

  if (!is.null(auxvars)) {
    for (x in auxvars) {
      if (x %in% names(refs)) {
        dummies <- paste0(x, levels(refs[[x]])[levels(refs[[x]]) != refs[[x]]])
        attr(refs[[x]], "dummies") <- dummies
      }
    }
  }


  X <- model.matrix(fixed,
                    model.frame(fixed, DF, na.action = na.pass),
                    contrasts.arg = contr)

  X2 <- model.matrix(fixed2,
                     model.frame(fixed2, DF, na.action = na.pass),
                     contrasts.arg = contr)

  tvar <- apply(X2, 2, check_tvar, groups)

  # time-constant part of X
  Xcross <- X2[match(unique(groups), groups), !tvar, drop = F]
  interact <- grep(":", colnames(Xcross), fixed = T, value = T)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = F]
  Xc <- Xc[, order(colSums(is.na(Xc))), drop = F]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = F]
  }
  if (!is.null(Xic)) {
    Xic <- Xic * NA
    Xic[is.na(Xic)] <- NA # to overwrite possible NaN's
  }


  cat_vars <- names(which(lapply(
    lapply(DF[, colSums(is.na(DF)) > 0 & names(DF) %in% all.vars(fixed2), drop = F], levels),
    length) > 2))
  cat_vars <- sapply(cat_vars, match_positions, DF, colnames(Xc), simplify = F)

  Xcat <- if (length(cat_vars) > 0) {
    DF[match(unique(groups), groups), names(cat_vars), drop = F]
  }
  if (!is.null(Xcat)) {
    Xc[, unlist(sapply(cat_vars, names))] <- NA
  }

  # Xtrafo ---------------------------------------------------------------------
  trafos <- extract_fcts(fixed, DF)
  Xtrafo <- if (!is.null(trafos)) {
    fmla_trafo <- as.formula(
      paste("~", paste0(unique(trafos$var), collapse = " + "))
    )
    if (!any(sapply(DF[, all.vars(fmla_trafo), drop = F], is.factor)))
      contr <- NULL
    model.matrix(fmla_trafo,
                 model.frame(fmla_trafo, DF, na.action = na.pass),
                 contrasts.arg = contr
    )[match(unique(groups), groups), -1, drop = F]
  }
  if (!is.null(Xtrafo)) {
    Xc[, as.character(trafos$Xc_var)] <- NA
  }



  # Xlong ----------------------------------------------------------------------
  Xlong <- if (sum(!names(tvar)[tvar] %in% colnames(Z)) > 0) {
    X2[, which(tvar & !names(tvar) %in% colnames(Z)), drop = F]
  }

  hc_list <- if (!is.null(random)) get_hc_list(X2, Xc, Xic, Z, Xlong)


  if (!is.null(Xlong)) {
    linteract <- if (any(grepl(":", colnames(Xlong), fixed = T))) {
      grep(":", colnames(Xlong), fixed = T, value = T)
    }

    Xl <- if (any(!colnames(Xlong) %in% linteract)) {
      Xlong[, !colnames(Xlong) %in% linteract, drop = F]
    }

    hc_interact <- unlist(sapply(hc_list, function(x) {
      names(which(attr(x, "matrix") == "Xc"))
    }))
    Xil <- if (!is.null(linteract) & any(!linteract %in% hc_interact)) {
      Xlong[, linteract[!linteract %in% hc_interact], drop = F]
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
    scale_vars <- find_continuous_main(fixed2, DF)
    fcts <- extract_fcts(fixed2, DF, complete = T)
    compl_fcts_vars <- fcts$Xc_var[fcts$type != "identity" &
                                     colSums(is.na(DF[, fcts$var, drop = F])) == 0]

    excl <- grep("[[:alpha:]]*\\(", scale_vars, value = T)
    excl <- c(excl, unique(trafos$Xc_var))
    excl <- excl[!excl %in% compl_fcts_vars]
    scale_vars <- scale_vars[which(!scale_vars %in% excl)]
  }


  return(list(y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat,
              Xtrafo = Xtrafo, trafos = trafos,
              Z = Z, hc_list = hc_list, cat_vars = cat_vars, refs = refs,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars,
              fixed2 = fixed2, X2_names = colnames(X2)))
}
