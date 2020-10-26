#' Identify the data matrix containing a given response variable
#'
#' @param resp character string; name of the response variable
#' @param Mlvls named vector where the names are all column names of all data
#'              matrices, and the values are the names of the corresponding
#'              data matrices
#' @param outnames character vector; names of the columns in the data matrices
#'                 that contain the response variable (or multiple columns in
#'                 case of a survival outcome)
#'
#' @return character string; the name(s) of the data matrix/matrices of the
#'         response variable(s)
#'
#' @noRd

get_resp_mat <- function(resp, Mlvls, outnames) {
  if (resp %in% names(Mlvls)) {
    # if the variable is a column of one of the design matrices, use the level
    # of that matrix
    Mlvls[resp]
  } else if (grepl("^Surv\\(", resp)) {
    # if the model is a survival model (variable name is the survival expression
    # and not a single variable name) get the levels of the separate variables
    # involved in the survival expression
    if (all(outnames %in% names(Mlvls))) {
      Mlvls[outnames]
    } else {
      errormsg("I have identified %s as a survival outcome, but I cannot find
               some of its elements in any of the data matrices.",
               dQuote(resp))
    }
  } else {
    errormsg("I cannot find the variable %s in any of the data matrices.",
             dQuote(resp))
  }
}
