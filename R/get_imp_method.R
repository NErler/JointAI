# Set default imputation methods
# @param DF a dataframe
# @param fixed a formula
# @param random a formula specifying a random effects structure
# @param auxvars vector of variable names as auxiliary variables
# @return a named vector containing those variables in DF
#         (check what happens if DF doesn't match fixed) that have missing
#         values and their assigned default imputation methods, sorted by
#         proportion of missing values (first cross-sectional variables,
#         then longitudinal variables)
# @export
get_imp_meth <- function(DF, fixed = NULL, random = NULL, auxvars = NULL){

  random2 <- remove_grouping(random)

  # try to extract id variable from random
  id <- extract_id(random)
  idvar <- if (!is.null(id)) {
    DF[, id]
  } else {
    1:nrow(DF)
  }

  allvars <- unique(c(all.vars(fixed[[3]]), all.vars(random2[2]), auxvars))

  tvar <- sapply(DF[, allvars, drop = F], check_tvar, idvar)

  # find predictor variables with missing values
  misvar <- names(DF[, allvars, drop = F])[colSums(is.na(DF[, allvars, drop = F])) > 0]
  # crossectional incomplete variables:
  misvar_c <- misvar[misvar %in% names(tvar)[!tvar]]

  # time-varying incomplete variables
  misvar_l <- misvar[misvar %in% names(tvar)[tvar]]

  # sort by number of missing values
  misvar <- c(misvar_c[order(colSums(is.na(DF[, misvar_c, drop = F])))],
              misvar_l[order(colSums(is.na(DF[, misvar_l, drop = F])))]
  )


  # named vector to assign imputation model types
  meth <- rep("", length(misvar))
  names(meth) <- misvar

  nlevel <- sapply(sapply(DF[, misvar, drop = F], levels, simplify = F), length)

  if (length(nlevel) > 0) {
    meth[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
    # meth[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
    meth[nlevel == 2] <- "logit"
    meth[nlevel  > 2] <- "multinomial"
    meth[sapply(DF[, names(nlevel), drop = F], is.ordered)] <- "ordinal"
  }

  if (length(meth) == 0)
    meth <- NULL

  return(meth = meth)
}
