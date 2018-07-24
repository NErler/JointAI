#' Missing data pattern
#'
#' Plot the pattern of missing data.
#' @param data data frame
#' @param color vector of length 2, that specifies the color used to indicate
#'              observed and missing  (in that order)
#' @param border color of the grid
#' @param plot logical; should the missing data pattern be plotted?
#' @param pattern logical; should the missing data pattern be returned as matrix?
#' @param print_xaxis,print_yaxis logical; should the x-axis (below the plot) and
#'                              y-axis (on the right) be printed?
#' @param ylab y-axis label
#' @inheritParams ggplot2::theme
#' @param ... optional additional parameters, currently not used
#' @export
#'
#' @examples
#' md_pattern(wideDF)
#'
#' par(mar = c(3, 1, 1.5, 1.5), mgp = c(2, 0.6, 0))
#' md_pattern(longDF, print_ylab = F)
#'
md_pattern <- function(data, color = c(grey(0.1), grey(0.7)), border = grey(0.5),
                       plot = TRUE, pattern = FALSE, print_xaxis = TRUE,
                       ylab = 'Number of observations per pattern',
                       print_yaxis = TRUE, legend.position = 'bottom', ...) {

  naX <- ifelse(is.na(data), 0, 1)
  unaX <- unique(naX)

  NApat <- apply(naX, 1, paste, collapse = "")
  NAupat <- apply(unaX, 1, paste, collapse = "")

  Nmis <- colSums(naX == 0)

  tab <- table(NApat)
  Npat <- tab[match(NAupat, names(tab))]

  unaX <- unaX[order(Npat, decreasing = T), ]
  Npat <- sort(Npat, decreasing = T)
  rownames(unaX) <- nrow(unaX):1

  vars <- colnames(unaX)[order(Nmis)]
  unaX <- unaX[, order(Nmis)]
  colnames(unaX) <- 1:ncol(unaX)
  Nmis <- sort(Nmis)

  if (plot) {
    if (all(!c("ggplot2", "reshape2") %in% rownames(installed.packages())))
      stop("This function requires the packages 'ggplot2' and 'reshape2' to be installed.")

    if (!"ggplot2" %in% rownames(installed.packages()))
      stop("This function requires the 'ggplot2' package to be installed.")

    if (!"reshape2" %in% rownames(installed.packages()))
      stop("This function requires the 'ggplot2' package to be installed.")

    library(ggplot2)

    if (print_yaxis == FALSE) {
      ylab <- ''
    }

    p <- ggplot(reshape2::melt(unaX), aes(Var2, Var1, fill = as.character(value))) +
      geom_tile(color = border) +
      scale_y_continuous(position = 'right',
                         breaks = length(Npat):1,
                         labels = if (print_yaxis) Npat else rep('', length(Npat)),
                         expand = c(0,0)) +
      scale_x_continuous(position = 'top',
                         breaks = 1:ncol(unaX),
                         labels = vars,
                         sec.axis = if (print_xaxis)
                           sec_axis(~.,
                                    name = 'Number of missing values',
                                    breaks = 1:ncol(unaX),
                                    labels = Nmis) else waiver(),
                         expand = c(0, 0)) +
      scale_fill_manual(name = '',
                        limits = c(1, 0),
                        values = color,
                        labels = c('observed', 'missing')) +
      theme(legend.position = legend.position,
            panel.background = element_blank(),
            panel.grid = element_blank(),
            axis.ticks = element_blank(),
            axis.text.x.top = element_text(angle = -90, hjust = 1)) +
      ylab(ylab) +
      xlab('')
    print(p)
  }

  if (pattern) {
    rownames(unaX) <- 1:nrow(unaX)
    colnames(unaX) <- vars
    rbind(cbind(unaX, Npat = Npat),
          Nmis = c(Nmis, sum(Nmis)))
  }
}

# md_pattern <- function(data, plot = TRUE, xlab = "", ylab = "",
#                       xaxis_pars = list(), yaxis_pars = list(), printN = TRUE,
#                       print = TRUE, ...) {
#   if (!"mice" %in% rownames(installed.packages()))
#     stop("This function requires the 'mice' package to be installed.")
#
#
#   if (packageVersion("mice") > "2.46.0") {
#     MDP <- mice::md.pattern(data, plot = FALSE)
#   } else {
#     MDP <- mice::md.pattern(data)
#   }
#
#   M <- t(MDP[-nrow(MDP), -ncol(MDP)])
#
#   if (plot == TRUE) {
#     image(1:nrow(M), 1:ncol(M), M[, ncol(M):1], col = grDevices::grey(c(0.7, 0.1)),
#           xaxt = "n", yaxt = "n", xlab = xlab, ylab = ylab, cex.lab = 1, ...)
#
#     if (is.null(yaxis_pars$side)) yaxis_pars$side <- 4
#     if (is.null(yaxis_pars$at)) yaxis_pars$at <- ncol(M):1
#     if (is.null(yaxis_pars$labels)) yaxis_pars$labels <- colnames(M)
#     if (is.null(yaxis_pars$las)) yaxis_pars$las <- 2
#     if (is.null(yaxis_pars$tck)) yaxis_pars$tck <- 0
#     if (is.null(yaxis_pars$hadj)) yaxis_pars$hadj <- 1
#     if (is.null(yaxis_pars$line))
#       yaxis_pars$line <- (nchar(max(colnames(M))) - 1)/2
#     if (is.null(yaxis_pars$lty)) yaxis_pars$lty <- 0
#     do.call(axis, yaxis_pars)
#
#     if (printN) {
#       cex_mtext <- ifelse(!is.null(yaxis_pars$cex.axis), yaxis_pars$cex.axis, 1)
#       mtext("N", side = 4, line = (nchar(max(colnames(M))) - 1)/2 + par("mgp")[2] - 0.6,
#             at = ncol(M) + 1, las = 2, cex = cex_mtext)
#     }
#
#     if (is.null(xaxis_pars$side)) xaxis_pars$side <- 1
#     if (is.null(xaxis_pars$at)) xaxis_pars$at <- 1:nrow(M)
#     if (is.null(xaxis_pars$labels)) xaxis_pars$labels <- rownames(M)
#     if (is.null(xaxis_pars$las)) xaxis_pars$las <- 2
#     if (is.null(xaxis_pars$tck)) xaxis_pars$tck <- 0
#     do.call(axis, xaxis_pars)
#
#     abline(v = c(0:nrow(M)) + 0.5, col = grDevices::grey(0.5))
#     abline(h = c(0:ncol(M)) + 0.5, col = grDevices::grey(0.5))
#     p <- grDevices::recordPlot()
#     # print(p)
#   }
#   if (print)
#     return(MDP)
# }
