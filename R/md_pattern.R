#' Missing data pattern
#' Plot the pattern of missing data. The missing data pattern is determined
#' using the function \code{link[mice]{md.pattern}} from the \code{mice} package.
#' @param data data frame
#' @param plot logical; should the missing data pattern be plotted?
#' @param xlab label for the x-axis
#' @param ylab label for the y-axis
#' @param xaxis_pars list of optional parameters for the x-axis
#' @param yaxis_pars list of optional parameters for the y-axis
#' @param printN logical; should the title "N" of the y-axis be printed?
#' @param print should the missing data pattern be returned as a matrix?
#' @param ... optional additional parameters passed to \code{\link[graphics]{image}()}
#' @export
#'
#' @examples
#' md_pattern(wideDF)
#' par(mar = c(3, 1, 1.5, 1.5), mgp = c(2, 0.6, 0))
#' md_pattern(longDF, yaxis_pars = list(cex.axis = 0.8))
#'
md_pattern <- function(data, plot = TRUE, xlab = "", ylab = "",
                      xaxis_pars = list(), yaxis_pars = list(), printN = TRUE,
                      print = TRUE, ...) {
  if (!"mice" %in% rownames(installed.packages()))
    stop("This function requires the 'mice' package to be installed.")

  MDP <- mice::md.pattern(data)
  M <- t(MDP[-nrow(MDP), -ncol(MDP)])

  if (plot == TRUE) {
    image(1:nrow(M), 1:ncol(M), M[, ncol(M):1], col = grDevices::grey(c(0.7, 0.1)),
          xaxt = "n", yaxt = "n", xlab = xlab, ylab = ylab, cex.lab = 1, ...)

    if (is.null(yaxis_pars$side)) yaxis_pars$side <- 4
    if (is.null(yaxis_pars$at)) yaxis_pars$at <- ncol(M):1
    if (is.null(yaxis_pars$labels)) yaxis_pars$labels <- colnames(M)
    if (is.null(yaxis_pars$las)) yaxis_pars$las <- 2
    if (is.null(yaxis_pars$tck)) yaxis_pars$tck <- 0
    if (is.null(yaxis_pars$hadj)) yaxis_pars$hadj <- 1
    if (is.null(yaxis_pars$line))
      yaxis_pars$line <- (nchar(max(colnames(M))) - 1)/2
    if (is.null(yaxis_pars$lty)) yaxis_pars$lty <- 0
    do.call(axis, yaxis_pars)

    if (printN) {
      cex_mtext <- ifelse(!is.null(yaxis_pars$cex.axis), yaxis_pars$cex.axis, 1)
      mtext("N", side = 4, line = (nchar(max(colnames(M))) - 1)/2 + par("mgp")[2] - 0.6,
            at = ncol(M) + 1, las = 2, cex = cex_mtext)
    }

    if (is.null(xaxis_pars$side)) xaxis_pars$side <- 1
    if (is.null(xaxis_pars$at)) xaxis_pars$at <- 1:nrow(M)
    if (is.null(xaxis_pars$labels)) xaxis_pars$labels <- rownames(M)
    if (is.null(xaxis_pars$las)) xaxis_pars$las <- 2
    if (is.null(xaxis_pars$tck)) xaxis_pars$tck <- 0
    do.call(axis, xaxis_pars)

    abline(v = c(0:nrow(M)) + 0.5, col = grDevices::grey(0.5))
    abline(h = c(0:ncol(M)) + 0.5, col = grDevices::grey(0.5))
    p <- grDevices::recordPlot()
    print(p)
  }
  if (print)
    return(MDP)
}
