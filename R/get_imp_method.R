#' Find default imputation methods and order
#' @inheritParams model_imp
# @param auxvars vector of variable names that should be used as predictors in
#                the imputation procedure (and will be imputed if necessary)
#                but are not part of the analysis model
#' @return A named vector containing those variables in \code{data}
#'         that have missing values and their assigned default imputation methods,
#'         sorted by proportion of missing values.
#'
#'
#' @examples
#' get_imp_meth(y ~ C1 + C2 + B2 + O2 + M2, data = wideDF)
#'
#'
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

  allvars <- unique(c(all.vars(fixed[[3]]),
                      all.vars(random2[2]),
                      if (!is.null(auxvars))
                        all.vars(as.formula(paste('~',
                                                  paste(auxvars, collapse = "+")))
                        )
  ))

  if (any(!allvars %in% names(data))) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
        paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", "))
    )
  }

  tvar <- sapply(data[, allvars, drop = FALSE], check_tvar, idvar)

  # find predictor variables with missing values
  misvar <- names(data[, allvars, drop = FALSE])[colSums(is.na(data[, allvars, drop = FALSE])) > 0]
  # crossectional incomplete variables:
  misvar_c <- misvar[misvar %in% names(tvar)[!tvar]]

  # time-varying incomplete variables (not yet used)
  misvar_l <- misvar[misvar %in% names(tvar)[tvar]]

  # sort by number of missing values
  misvar <- c(misvar_c[order(colSums(is.na(data[, misvar_c, drop = FALSE])))],
              misvar_l[order(colSums(is.na(data[, misvar_l, drop = FALSE])))]
  )


  # named vector to assign imputation model types
  meth <- rep("", length(misvar))
  names(meth) <- misvar

  nlevel <- sapply(misvar, function(k) {
      if (!is.factor(data[, k])) {
        if (length(unique(na.omit(data[, k]))) == 2) {
          2
        } else {
          0
        }} else {
          length(levels(data[, k]))
        }
  })

  if (length(nlevel) > 0) {
    meth[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
    # meth[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
    meth[nlevel == 2] <- "logit"
    meth[nlevel  > 2] <- "multilogit"
    meth[sapply(data[, names(nlevel), drop = FALSE], is.ordered)] <- "cumlogit"
  }

  if (length(meth) == 0)
    meth <- NULL

  return(meth = meth)
}
