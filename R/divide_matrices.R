#' Create data matrices for time constant and time-varying variables
#' @param DF a dataframe
#' @param fixed a formula describing the mean structure
#' @param random an optional formula describing the random effects (check this!)
#' @param auxvars vector containing the names of auxiliary variables
#' @inheritParams base::scale
#' @return a list containing the matrices
#' @export

divide_matrices <- function(DF, fixed, random = NULL, auxvars = NULL, scale_vars = NULL) {
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


  if (is.null(scale_vars)) scale_vars <- find_continuous_main(fixed2, DF)


  X <- model.matrix(fixed,
                    model.frame(fixed, DF, na.action = na.pass),
                    contrasts.arg = contr)

  X2 <- model.matrix(fixed2,
                     model.frame(fixed2, DF, na.action = na.pass),
                     contrasts.arg = contr)

  auxvars <- if (any(is.na(match(colnames(X2), colnames(X))))) {
    colnames(X2)[!colnames(X2) %in% colnames(X)]
  }

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
    Xic[, colSums(is.na(Xic)) > 0] <- NA
  }

  cat_vars <- names(which(lapply(
    lapply(DF[, colSums(is.na(DF)) > 0 & names(DF) %in% all.vars(fixed2)], levels),
    # lapply(DF[, all.vars(fixed2)], levels),
    length) > 2))
  cat_vars <- sapply(cat_vars, match_positions, DF, colnames(Xc), simplify = F)

  Xcat <- if (length(cat_vars) > 0) {
    DF[match(unique(groups), groups), names(cat_vars), drop = F]
  }
  if (!is.null(Xcat)) {
    Xc[, sapply(cat_vars, names)] <- NA
  }

  # hc_list <- get_hc_list(colnames(X2), colnames(Xc), colnames(Z))

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

    if (!is.null(Xl)) {
      if (sum(is.na(Xl)) > 0) {
        stop("Missing values in the longitudinal variables are not allowed.")
      }
    }
  } else {
    Xl <- Xil <- NULL
  }


  return(list(y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat,
              Z = Z, hc_list = hc_list, cat_vars = cat_vars,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars))
}