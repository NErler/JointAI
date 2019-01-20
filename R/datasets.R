#' Longitudinal example dataset
#'
#' A simulated longitudinal dataset.
#'
#' @docType data
#'
#' @usage data(longDF)
#'
#' @format A simulated data frame with 341 rows and 17 variables with data from 100 subjects:
#' \describe{
#'   \item{C1}{continuous, complete baseline variable}
#'   \item{C2}{continuous, incomplete baseline variable}
#'   \item{B1}{binary, complete baseline variable}
#'   \item{B2}{binary, incomplete baseline variable}
#'   \item{M1}{unordered factor; complete baseline variable}
#'   \item{M2}{unordered factor; incomplete baseline variable}
#'   \item{O1}{ordered factor; complete baseline variable}
#'   \item{O2}{ordered factor; incomplete baseline variable}
#'   \item{c1}{continuous, complete longitudinal variable}
#'   \item{c2}{continuous incomplete longitudinal variable}
#'   \item{b1}{binary, complete longitudinal variable}
#'   \item{b2}{binary incomplete longitudinal variable}
#'   \item{c1}{ordered factor; complete longitudinal variable}
#'   \item{c2}{ordered factor; incomplete longitudinal variable}
#'   \item{id}{id (grouping) variable}
#'   \item{time}{continuous complete longitudinal variable}
#'   \item{y}{continuous, longitudinal (outcome) variable}
#'}
#'
#' @keywords datasets
#'
#'
"longDF"

# longDF <- sim_data(N = 100, norm = c("C1", "C2"), bin = c("B1", "B2"),
#                    multi = c('M1', "M2"), ord = c("O1", "O2"),
#                    longnorm = c('c1', "c2"), longbin = c("b1", 'b2'),
#                    longord = c('o1', 'o2'),
#                    misvar = c('C2', 'B2', "M2", 'O2', 'c2', "b2", 'o2'),
#                    seed = 2019)[[2]]

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
