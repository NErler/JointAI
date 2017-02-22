#' Traceplots
#' @export
traceplot.JointAI <- function(x) {
# traceplot.JointAI <- function(x, burnin = 0, subset = colnames(x$sample[[1]])){
  MCMC <- x$sample

  if (ncol(MCMC[[1]]) > 30) ask <- T

  nrow <- floor(sqrt(ncol(MCMC[[1]])))
  ncol <- ceiling(ncol(MCMC[[1]])/nrow)

  par(mfrow = c(nrow, ncol), mar = c(3, 3, 2, 1), mgp = c(2, 0.6, 0))
  coda::traceplot(MCMC)
}


#' Traceplot
#' @export
traceplot <- function(x, ...) {
  UseMethod("traceplot", x)
}

