#' Longitudinal example dataset
#'
#' A simulated longitudinal dataset.
#'
#' @docType data
#'
#' @usage data(longDF)
#'
#' @format A simulated data frame with 318 rows and 13 variables with data from 100 subjects:
#' \describe{
#'   \item{C1}{continuous, complete baseline variable}
#'   \item{C2}{continuous, incomplete baseline variable}
#'   \item{B1}{binary, complete baseline variable}
#'   \item{B2}{binary, incomplete baseline variable}
#'   \item{M1}{unordered factor; complete baseline variable}
#'   \item{M2}{unordered factor; incomplete baseline variable}
#'   \item{O1}{ordered factor; complete baseline variable}
#'   \item{O2}{ordered factor; incomplete baseline variable}
#'   \item{L1}{continuous, complete longitudinal variable}
#'   \item{L2}{continuous incomplete longitudinal variable}
#'   \item{id}{id (grouping) variable}
#'   \item{time}{continuous complete longitudinal variable}
#'   \item{y}{continuous, longitudinal (outcome) variable}
#'}
#'
#' @keywords datasets
#'
#'
"longDF"



#' Cross-sectional example dataset
#'
#' A simulated cross-sectional dataset.
#'
#' @docType data
#'
#' @usage data(wideDF)
#'
#' @format A simulated data frame with 100 rows and 13 variables:
#' \describe{
#'   \item{C1}{continuous, complete variable}
#'   \item{C2}{continuous, incomplete variable}
#'   \item{B1}{binary, complete variable}
#'   \item{B2}{binary, incomplete variable}
#'   \item{M1}{unordered factor; complete variable}
#'   \item{M2}{unordered factor; incomplete variable}
#'   \item{O1}{ordered factor; complete variable}
#'   \item{O2}{ordered factor; incomplete variable}
#'   \item{L1}{continuous, complete variable}
#'   \item{L2}{continuous incomplete variable}
#'   \item{id}{id (grouping) variable}
#'   \item{time}{continuous complete variable}
#'   \item{y}{continuous, complete variable}
#'}
#' @keywords datasets
#'
#'
#'
"wideDF"
