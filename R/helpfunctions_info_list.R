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
#' @keywords internal

get_resp_mat <- function(resp, Mlvls, outnames) {
  if (any(!outnames %in% names(Mlvls))) {
    errormsg("I cannot find the variable(s) %s in any of the data matrices.",
             paste_and(dQuote(outnames[!outnames %in% names(Mlvls)])))
  } else {
      Mlvls[outnames]
  }
}
