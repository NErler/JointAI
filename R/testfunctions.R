

#' ## Tests for get_imp_method
#' Test that get_imp_method extracts all the incomplete variables and none of
#' the complete
test_get_imp_method <- function(meth, fixed, random = NULL, DF, auxvars = NULL) {
  # Are there missing values in the variables in meth?
  mis_correct <- all(colSums(is.na(DF[, names(meth)]) > 0))

  # Are all other variables complete?
  random2 <- remove_grouping(random)
  allvars <- unique(c(all.vars(fixed[[3]]), all.vars(random2[2]), auxvars))
  compl_correct <- all(colSums(is.na(DF[, !names(DF) %in% names(meth) &
                                          names(DF) %in% allvars])) == 0)

  return(c(mis_correct = mis_correct, compl_correct = compl_correct))
}


