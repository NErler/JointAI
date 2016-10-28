#' Extract id variable from fixed effects formula
#' @param fixed a formula describing fixed effects structure
#' @return a character string, giving the name of the id variable or NULL
extract_id <- function(fixed) {
  idmatch <- regexpr(pattern = "[[:print:]]*\\|[[:space:]]*",
                     deparse(fixed, width.cutoff = 500))
  if (idmatch > 0) {
    id <- unlist(regmatches(deparse(fixed, width.cutoff = 500),
                            idmatch, invert = T))
    id <- id[id != ""]
  } else {
    id <- NULL
  }
  return(id)
}



#' Check if a variable is time-dependent
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @return a logical value
#' @export
check_td <- function(x, idvar) {
  !all(sapply(split(x, idvar),
              function(z) all(z == z[1], na.rm = T)
  )
  )
}


find_positions <- function(nams1, nams2) {
  nams1 <- gsub("^", "\\^", nams1, fixed = TRUE)
  vals <- c(glob2rx(nams1), glob2rx(paste0(nams1, ":*")),
            glob2rx(paste0("*:", nams1)))
  out <- sort(unique(unlist(lapply(vals, grep, x = nams2))))
  out
}


#' Set default imputation methods
#' @param DF a dataframe
#' @param fixed a formula
#' @param id a character string identifying the id variable if there is a
#'           grouping, otherwise NULL
#' @return a named vector containing those variables in DF
#'         (check what happens if DF doesn't match fixed) that have missing
#'         values and their assigned default imputation methods, sorted by
#'         proportion of missing values (first cross-sectional variables,
#'         then longitudinal variables)
#' @export
get_mis_meth <- function(DF, fixed, id = NULL){

  # remove grouping specification from fixed effects formula
  fixed2 <- as.formula(sub("\\|[[:print:]]*", "",
                           deparse(fixed, width.cutoff = 500)))

  idvar <- if (!is.null(id)) {
    DF[, id]
  } else {
    1:nrow(DF)
  }

  tvar <- sapply(DF, check_td, idvar)

  # find predictor variables with missing values
  misvar <- names(DF)[colSums(is.na(DF)) > 0 &
                        names(DF) %in% attr(terms(fixed2), "term.labels")]
  # crossectional incomplete variables:
  misvar.c <- misvar[misvar %in% names(tvar)[!tvar]]

  # time-varying incomplete variables
  misvar.l <- misvar[misvar %in% names(tvar)[tvar]]

  # sort by number of missing values
  misvar <- c(misvar.c[order(colSums(is.na(DF[, misvar.c, drop = F])))],
              misvar.l[order(colSums(is.na(DF[, misvar.l, drop = F])))]
  )


  # named vector to assign imputation model types
  meth <- rep("", length(misvar))
  names(meth) <- misvar

  nlevel <- sapply(sapply(DF[, misvar, drop = F], levels), length)

  meth[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
  meth[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
  meth[nlevel == 2] <- "binary"
  meth[nlevel  > 2] <- "multinomial"
  meth[sapply(DF[, names(nlevel), drop = F], is.ordered)] <- "ordinal"

  if (length(meth) == 0)
    meth <- NULL

  return(meth = meth)
}


#' Create data matrices for time constant and time-varying variables
#' @param DF a dataframe
#' @param fixed a formula describing the mean structure
#' @param random an optional formula describing the random effects (check this!)
#' @param id a character string identifying the id variable if there is a
#'           grouping, otherwise NULL
#' @return a list containing the matrices
#' @export

get_X <- function(DF, fixed, random, id){
  idvar <- if (!is.null(id)) {
    DF[, id]
  } else {
    1:nrow(DF)
  }

  # remove grouping specification from fixed effects formula
  fixed2 <- sub("\\|[[:print:]]*", "", deparse(fixed, width.cutoff = 500))


  # random effects design matrix
  Z <- if (!is.null(random)) {
    model.matrix(random, DF)
  } else {
    NULL
  }


  # fixed effects design matrices
  ord <- names(which(sapply(DF, is.ordered)))
  contr <- as.list(rep("contr.treatment", length(ord)))
  names(contr) <- ord

  X <- model.matrix(as.formula(fixed2),
                    model.frame(fixed2, DF, na.action = na.pass),
                    contrasts.arg = contr)
  tvar <- apply(X, 2, check_td, idvar)

  # time-constant part of X
  Xcross <- X[match(unique(idvar), idvar), !tvar, drop = F] # check if this works when no id is given
  interact <- grep(":", colnames(Xcross), fixed = T)

  Xc <- Xcross[, -interact, drop = F]
  Xc <- Xc[, order(colSums(is.na(Xc))), drop = F]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = F]
  }

  # variables involved in the random effects structure:
  time.hc <- sapply(colnames(Z)[-1L], find_positions, nams2 = colnames(X))

  # part of X that is time-varying but not involved with the random effects
  Xlong <- if (sum(tvar) > 0) {
    X[, which(tvar & !names(tvar) %in% attr(terms(random), "term.labels")),
      drop = F]
  }

  linteract <- grep(":", colnames(Xlong), fixed = T)
  Xil <- if (length(linteract) > 0 & !is.null(Xlong)) {
    Xlong[, linteract, drop = F]
  }
  Xl <- if (length(linteract) < ncol(Xlong) & !is.null(Xlong)) {
    Xlong[, seq_len(ncol(Xlong))[-linteract], drop = F]
  }

  return(list(Xc = Xc, Xic = Xic, Z = Z, Xl = Xl, Xil = Xil, time.hc = time.hc))

}