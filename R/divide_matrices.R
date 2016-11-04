#' Create data matrices for time constant and time-varying variables
#' @param DF a dataframe
#' @param fixed a formula describing the mean structure
#' @param random an optional formula describing the random effects (check this!)
#' @param auxvars vector containing the names of auxiliary variables
#' @param id a character string identifying the id variable if there is a
#'           grouping, otherwise NULL
#' @return a list containing the matrices
#' @export

divide_matrices <- function(DF, fixed, random = NULL, auxvars = NULL, id = NULL){
  if (is.null(id)) {
    id <- extract_id(random)
  }

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

  auxvars <- colnames(X2)[!colnames(X2) %in% colnames(X)]

  tvar <- apply(X2, 2, check_tvar, idvar)

  # time-constant part of X
  Xcross <- X2[match(unique(idvar), idvar), !tvar, drop = F]
  interact <- grep(":", colnames(Xcross), fixed = T, value = T)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = F]
  Xc <- Xc[, order(colSums(is.na(Xc))), drop = F]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = F]
  }

  # variables involved in the random effects structure:
  # time_hc <- if (ncol(Z) > 1) {
  #   sapply(colnames(Z), find_positions, nams2 = colnames(X2))
  # }

  hc_list <- if (ncol(Z) > 1) {
    sapply(colnames(Z), grep, colnames(X2), value = T)[-1L]
  }
  for (i in 1:length(hc_list)) {
    matchvars <- match(sub(paste0("[:]*", names(hc_list)[i], "[:]*"),
                           "", hc_list[[i]]), colnames(Xc))
    names(matchvars) <- hc_list[[i]]
    hc_list[[i]] <- matchvars
  }
  # make a class hc_list with attribute corss-sectional or longitudinal in order
  # to distinguish if an interaction should be part of Xil


  # part of X that is time-varying but not involved with the random effects
  Xlong <- if (sum(tvar) > 0) {
    X2[, which(tvar & !names(tvar) %in% attr(terms(random), "term.labels")),
      drop = F]
  }

  linteract <- grep(":", colnames(Xlong), fixed = T, value = T)
  Xil <- if (length(linteract) > 0 & !is.null(Xlong)) {
    Xlong[, linteract[linteract %in% ], drop = F]
  }
  Xl <- if (!is.null(Xlong)) {
    Xlong[, !colnames(Xlong) %in% c(linteract, names(hc_list)), drop = F]
  }

  if (!is.null(Xl)) {
    if (sum(is.na(Xl)) > 0) {
      stop("Missing values in the longitudinal variables are not allowed.")
    }
  }

  return(list(Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil,
              Z = Z, hc_list = hc_list,
              auxvars = auxvars))
}