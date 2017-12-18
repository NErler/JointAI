#' Find default imputation methods and order
#' @param fixed a two sided (fixed effects) model formula (see \code{\link[stats]{formula}}).
#' @inheritParams model_imp
# @param auxvars vector of variable names that should be used as predictors in
#                the imputation procedure (and will be imputed if necessary)
#                but are not part of the analysis model
#' @return a named vector containing those variables in \code{data}
#'         that have missing values and their assigned default imputation methods,
#'         sorted by proportion of missing values
#' @examples
#' get_imp_meth(y ~ C1 + C2 + B2 + O2 + M2, data = wideDF)
#' @export
get_imp_meth <- function(fixed, random = NULL, data,
                         auxvars = NULL){

  if (missing(fixed))
    stop("No formula specified.")

  if (missing(data))
    stop("No dataset given.")


  random2 <- remove_grouping(random)

  # try to extract id variable from random
  id <- extract_id(random)
  idvar <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }

  allvars <- unique(c(all.vars(fixed[[3]]), all.vars(random2[2]), auxvars))

  if (any(!allvars %in% names(data))) {
    stop(paste0("Variable(s)" ,
                paste0(allvars[!allvars %in% names(data)], collapse = ", "),
                " were not found in the data."))
  }

  tvar <- sapply(data[, allvars, drop = F], check_tvar, idvar)

  # find predictor variables with missing values
  misvar <- names(data[, allvars, drop = F])[colSums(is.na(data[, allvars, drop = F])) > 0]
  # crossectional incomplete variables:
  misvar_c <- misvar[misvar %in% names(tvar)[!tvar]]

  # time-varying incomplete variables (not yet used)
  misvar_l <- misvar[misvar %in% names(tvar)[tvar]]

  # sort by number of missing values
  misvar <- c(misvar_c[order(colSums(is.na(data[, misvar_c, drop = F])))],
              misvar_l[order(colSums(is.na(data[, misvar_l, drop = F])))]
  )


  # named vector to assign imputation model types
  meth <- rep("", length(misvar))
  names(meth) <- misvar

  nlevel <- sapply(sapply(data[, misvar, drop = F], levels, simplify = F), length)

  if (length(nlevel) > 0) {
    meth[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
    # meth[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
    meth[nlevel == 2] <- "logit"
    meth[nlevel  > 2] <- "multilogit"
    meth[sapply(data[, names(nlevel), drop = F], is.ordered)] <- "cumlogit"
  }

  if (length(meth) == 0)
    meth <- NULL

  return(meth = meth)
}
