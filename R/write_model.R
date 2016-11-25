#' Write model syntax to file
#' @param type analysis model type (character string)
#' @param meth named vector specifying imputation methods and ordering
#' @param Ntot number of observations
#' @param N number of individuals
#' @param y_name name of outcome variable
#' @param Mlist list of design matrices
#' @param Z random effects design matrix
#' @param Xic design matrix of time-constant interactions
#' @param Xl design matrix of time-varying covariates
#' @param Xil design matrix of interactions involving time-varying covariates
#' @param hc_list list specifying hierarchical centring structure
#' @param K matrix specifying range of regression coefficients used for each
#' component of the analysis model
#' @param file path and file name
#' @param package currently only JAGS is implemented
#' @export
write_model <- function(type, meth = NULL, Ntot, N, y_name,  Mlist = NULL,
                        Z = NULL, Xic = NULL, Xl = NULL, Xil = NULL,
                        hc_list = NULL, K, imp_par_list, file = NULL,
                        package = "JAGS") {

  arglist <- as.list(match.call())[-1]

  build_model <- switch(package,
                           "JAGS" = build_JAGS)


  cat(build_model(arglist), file = file)
}