#' Create data matrices for time constant and time-varying variables
#' @param DF a dataframe
#' @param fixed a formula describing the mean structure
#' @param random an optional formula describing the random effects (check this!)
#' @param auxvars vector containing the names of auxiliary variables
#' @return a list containing the matrices
#' @export

divide_matrices <- function(DF, fixed, random = NULL, auxvars = NULL){
  id <- extract_id(random)

  idvar <- if (!is.null(id)) {
    DF[, id]
  } else {
    1:nrow(DF)
  }

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


  X <- model.matrix(fixed,
                    model.frame(fixed, DF, na.action = na.pass),
                    contrasts.arg = contr)

  X2 <- model.matrix(fixed2,
                     model.frame(fixed2, DF, na.action = na.pass),
                     contrasts.arg = contr)

  auxvars <- if (any(is.na(match(colnames(X2), colnames(X))))) {
    colnames(X2)[!colnames(X2) %in% colnames(X)]
  }

  tvar <- apply(X2, 2, check_tvar, idvar)

  # time-constant part of X
  Xcross <- X2[match(unique(idvar), idvar), !tvar, drop = F]
  interact <- grep(":", colnames(Xcross), fixed = T, value = T)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = F]
  Xc <- Xc[, order(colSums(is.na(Xc))), drop = F]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = F]
  }

  cat_vars <- names(which(lapply(lapply(DF[, all.vars(fixed2)], levels),
                                 length) > 2))
  cat_vars <- sapply(cat_vars, match_positions, DF, colnames(Xc), simplify = F)

  Xcat <- if (length(cat_vars) > 0) {
    DF[match(unique(idvar), idvar), names(cat_vars)]
  }

  hc_list <- get_hc_list(colnames(X2), colnames(Xc), colnames(Z))


  Xlong <- if (sum(!names(tvar)[tvar] %in% colnames(Z)) > 0) {
    X2[, which(tvar & !names(tvar) %in% colnames(Z)), drop = F]
  }

  if (!is.null(Xlong)) {
    linteract <- if (any(grepl(":", colnames(Xlong), fixed = T))) {
      grep(":", colnames(Xlong), fixed = T, value = T)
    }

    Xl <- if (any(!colnames(Xlong) %in% linteract)) {
      Xlong[, !colnames(Xlong) %in% linteract, drop = F]
    }

    Xcinteract <- unlist(sapply(hc_list, function(x) {
      names(x)[na.omit(match("Xc", attr(x, "matrix")))]
    }))
    Xil <- if (!is.null(linteract) & any(!linteract %in% Xcinteract)) {
      Xlong[, linteract[!linteract %in% Xcinteract], drop = F]
    }

    if (!is.null(Xl)) {
      if (sum(is.na(Xl)) > 0) {
        stop("Missing values in the longitudinal variables are not allowed.")
      }
    }
  } else {
    Xl <- Xil <- NULL
  }

  return(list(Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat,
              Z = Z, hc_list = hc_list, cat_vars = cat_vars,
              auxvars = auxvars))
}