#' Traceplot of a JointAI model
#'
#' Creates a set of traceplots from the MCMC sample of an object of class "JointAI".
#'
#' @inheritParams sharedParams
#' @inheritDotParams graphics::matplot -x -y -type -xlab -ylab -pch -log
#' @name traceplot
#'
#' @seealso \code{\link{summary.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'          \code{\link{lm_imp}}, \code{\link{densplot}}
#'          The vignette \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#'          contains some examples how to specify the parameter \code{subset}.
#'
#' @examples
#' # fit a JointAI model
#' mod <- lm_imp(y ~ C1 + C2 + M1, data = wideDF, n.iter = 100)
#'
#'
#' # Example 1: simple traceplot
#' traceplot(mod)
#'
#'
#' # Example 2: ggplot version of traceplot
#' traceplot(mod, use_ggplot = TRUE)
#'
#'
#' # Example 5: changing how the ggplot version looks (using standard ggplot syntax)
#' library(ggplot2)
#'
#' traceplot(mod, use_ggplot = TRUE) +
#'   theme(legend.position = 'botto') +
#'   xlab('iteration') +
#'   ylab('value') +
#'   scale_color_discrete(name = 'chain')
#'
#'
#' @export
traceplot <- function(object, ...) {
  UseMethod("traceplot")
}


#' @rdname traceplot
#' @export
traceplot.mcmc.list <- function(object, start = NULL, end = NULL, thin = NULL, ...) {

  if (is.null(start))
    start <- start(object)

  if (is.null(end))
    end <- end(object)

  if (is.null(thin))
    thin <- thin(object)

  coda::traceplot(window(object, start = start, end = end, thin = thin), ...)
}


#' @rdname traceplot
#' @export
traceplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                              subset = c(analysis_main = TRUE),
                              exclude_chains = NULL,
                              nrow = NULL, ncol = NULL, keep_aux = FALSE,
                              use_ggplot = FALSE, warn = TRUE, mess = TRUE,
                              ...) {

  prep <- plot_prep(object, start = start, end = end, thin = thin, subset = subset,
                    exclude_chains = exclude_chains,
                    nrow = nrow, ncol = ncol, warn = warn, mess = mess,
                    keep_aux = keep_aux)


  if (use_ggplot) {
    meltMCMC <- melt_matrix_list(lapply(prep$MCMC, as.matrix),
                                 varnames = c('iteration', 'variable'))
    meltMCMC$chain <- factor(meltMCMC$L1)


    ggplot2::ggplot(meltMCMC,
                    ggplot2::aes(iteration, value, color = chain)) +
      ggplot2::geom_line() +
      ggplot2::facet_wrap('variable', scales = 'free',
                          ncol = prep$ncol, nrow = prep$nrow)
  } else {
    op <- par(mfrow = c(prep$nrow, prep$ncol), mar = c(3.2, 2.5, 2, 1),
              mgp = c(2, 0.6, 0))

    for (i in 1:nvar(prep$MCMC)) {
      matplot(x = prep$time, as.array(prep$MCMC, drop = FALSE)[, i, ], type = "l",
              xlab = "Iterations", ylab = "",
              main = colnames(prep$MCMC[[1]])[i], ...)
    }
    on.exit(par(op))
  }
}



#' Plot the posterior density from object of class JointAI
#'
#' The function plots a set of densities (per chain and coefficient) from
#' the MCMC sample of an object of class "JointAI".
#' @inheritParams traceplot
#' @param vlines list, where each element is a named list of parameters that
#'               can be passed to \code{\link[graphics]{abline}} to create
#'               vertical lines.
#'               Each of the list elements needs to contain at least
#'               \code{v = <x location>}, where <x location> is a vector of the
#'               same length as the number of plots (see examples).
#' @param joined logical; should the chains be combined before plotting?
#' @param ... additional parameters passed to \code{\link[graphics]{plot}}
#' @examples
#'
#' # fit a JointAI object:
#' mod <- lm_imp(y ~ C1 + C2 + M1, data = wideDF, n.iter = 100)
#'
#' # Example 1: basic densityplot
#' densplot(mod)
#' densplot(mod, exclude_chains = 2)
#'
#'
#' # Example 2: use vlines to mark zero
#' densplot(mod, col = c("darkred", "darkblue", "darkgreen"),
#'          vlines = list(list(v = rep(0, nrow(summary(mod)$stats)),
#'                             col = grey(0.8))))
#'
#'
#' # Example 3: use vlines to visualize the posterior mean and 2.5% and 97.5% quantiles
#' densplot(mod, vlines = list(list(v = summary(mod)$stats[, "Mean"], lty = 1, lwd = 2),
#'                             list(v = summary(mod)$stats[, "2.5%"], lty = 2),
#'                             list(v = summary(mod)$stats[, "97.5%"], lty = 2)))
#'
#'
#' # Example 4: ggplot version
#' densplot(mod, use_ggplot = TRUE)
#'
#'
#' # Example 5: changing how the ggplot version looks (using standard ggplot syntax)
#' library(ggplot2)
#'
#' densplot(mod, use_ggplot = TRUE) +
#'   xlab("value") +
#'   theme(legend.position = 'bottom') +
#'   scale_color_brewer(palette = 'Dark2', name = 'chain')
#'
#'
#' @seealso
#' The vignette \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' contains some examples how to specify the argument \code{subset}.
#'
#'
#' @export
densplot <- function(object, ...) {
  UseMethod("densplot")
}


#' @rdname densplot
#' @export
densplot.mcmc.list <- function(object, start = NULL, end = NULL, thin = NULL, ...) {

  if (is.null(start))
    start <- start(object)

  if (is.null(end))
    end <- end(object)

  if (is.null(thin))
    thin <- thin(object)

  coda::densplot(window(object, start = start, end = end, thin = thin), ...)
}


#' @rdname densplot
#' @export
densplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                             subset = c(analysis_main = TRUE),
                             exclude_chains = NULL, vlines = NULL, nrow = NULL,
                             ncol = NULL, joined = FALSE, use_ggplot = FALSE,
                             keep_aux = FALSE, warn = TRUE, mess = TRUE, ...) {

  prep <- plot_prep(object, start = start, end = end, thin = thin,
                    subset = subset, exclude_chains = exclude_chains,
                    nrow = nrow, ncol = ncol, warn = warn,
                    mess = mess, keep_aux = keep_aux)

  if (joined)
    prep$MCMC <- as.mcmc.list(as.mcmc(do.call(rbind, prep$MCMC)))


  if (use_ggplot) {
    meltMCMC <- melt_matrix_list(lapply(prep$MCMC, as.matrix),
                                 varnames = c('iteration', 'variable'))
    meltMCMC$chain <- factor(meltMCMC$L1)

    if (joined)
      p <- ggplot2::ggplot(meltMCMC, ggplot2::aes(value))
    else
      p <- ggplot2::ggplot(meltMCMC, ggplot2::aes(value, color = chain))

    p + ggplot2::geom_density() +
      ggplot2::facet_wrap('variable', scales = 'free', ncol = prep$ncol,
                          nrow = prep$nrow)
  } else {
    args <- as.list(match.call())
    if (!is.null(args$col)) {
      col <- eval(args$col)
      args <- args[-which(names(args) == "col")]
    } else {
      col <- 1:length(prep$MCMC)
    }

    op <- par(mfrow = c(prep$nrow, prep$ncol), mar = c(3, 3, 2, 1),
              mgp = c(2, 0.6, 0))
    for (i in 1:ncol(prep$MCMC[[1]])) {
      dens <- lapply(prep$MCMC[, i], density)
      vline_range <- if (is.list(vlines[[1]])) {
        lapply(lapply(vlines, "[[", "v"), "[", i)
      }else{
        vlines$v
      }
      plot(NULL,
           xlim = range(lapply(dens, "[[", "x"), vline_range, na.rm = TRUE),
           ylim = range(lapply(dens, "[[", "y"), na.rm = TRUE),
           main = colnames(prep$MCMC[[1]])[i],
           xlab = "", ylab = "density", ...
      )

      for (j in 1:length(prep$MCMC)) {
        args_lines <- c(list(x = dens[[j]]$x,
                             y = dens[[j]]$y,
                             type = 'l',
                             col = col[j]),
                        args[names(args) %in% names(formals(plot.xy))]
        )
        do.call(lines, args_lines)
      }

      if (!is.null(vlines)) {
        for (l in 1:length(vlines)) {
          args_vline <- if (is.list(vlines[[l]])) vlines[[l]] else vlines
          if (length(args_vline$v) > 1) {
            args_vline$v <- args_vline$v[i]
          }
          do.call(abline, args_vline)
        }
      }
    }
    on.exit(par(op))
  }
}


# Helpfunction for densityplot and traceplot
plot_prep <- function(object, start = NULL, end = NULL, thin = NULL, subset = NULL,
                      exclude_chains = NULL,
                      nrow = NULL, ncol = NULL, warn = TRUE, mess = TRUE,
                      keep_aux = FALSE, ...) {
  if (is.null(object$MCMC))
    stop("There is no MCMC sample.")

  if (is.null(start))
    start <- start(object$MCMC)

  if (is.null(end))
    end <- end(object$MCMC)

  if (is.null(thin))
    thin <- thin(object$MCMC)

  MCMC <- get_subset(object, subset, keep_aux = keep_aux,
                     warn = warn, mess = mess)

  chains <- seq_along(MCMC)
  if (!is.null(exclude_chains)) {
    chains <- chains[-exclude_chains]
  }

  MCMC <- window(MCMC[chains],
                 start = start,
                 end = end,
                 thin = thin)

  time <- time(MCMC)

  # get number of rows and columns of plots
  if (is.null(nrow) & is.null(ncol)) {
    dims <- if (ncol(MCMC[[1]]) > 64) {
      grDevices::n2mfrow(49)
    } else {
      grDevices::n2mfrow(ncol(MCMC[[1]]))
    }
  } else if (is.null(nrow) & !is.null(ncol)) {
    dims <- c(ceiling(ncol(MCMC[[1]])/ncol), ncol)
  } else if (is.null(ncol) & !is.null(nrow)) {
    dims <- c(nrow, ceiling(ncol(MCMC[[1]])/nrow))
  } else {
    dims <- c(nrow, ncol)
  }

  return(list(MCMC = MCMC, nrow = dims[1], ncol = dims[2],
              thin = thin, time = time, subset = subset))
}


#' Visualize the distribution of all variables in the dataset
#'
#' This function plots a grid of histograms (for continuous variables) and barplots (for
#' categorical variables) and labels it with the proportion of missing values in
#' each variable.
#' @param data a \code{data.frame} (or a \code{matrix})
#' @param fill color the histograms and bars are filled with
#' @param border color of the borders of the histograms and bars
#' @param allNA logical; if \code{FALSE} (default) the proportion of missing
#'              values is only given for variables that have missing values,
#'              if \code{TRUE} it is given for all variables
#' @inheritParams sharedParams
#' @param ... additional parameters passed to \code{\link[graphics]{barplot}}
#'            and \code{\link[graphics]{hist}}
#'
#' @seealso Vignette: \href{https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html}{Visualizing Incomplete Data}
#' @examples
#' op <- par(mar = c(2,2,3,1), mgp = c(2, 0.6, 0))
#' plot_all(wideDF)
#' par(op)
#'
#' @export

plot_all <- function(data, nrow = NULL, ncol = NULL, fill = grDevices::grey(0.8),
                     border = 'black', allNA = FALSE, use_level = FALSE, idvar,
                     xlab = '', ylab = 'frequency', ...) {

  args <- as.list(match.call())
  args <- args[!names(args) %in% names(formals(plot_all))]
  args_hist <- unlist(args[names(args) %in% names(formals(hist.default))])
  args_barplot <- unlist(args[names(args) %in% names(formals(barplot.default))])

  # get number of rows and columns of plots
  if (is.null(nrow) & is.null(ncol)) {
    dims <- if (ncol(data) > 49) {
      grDevices::n2mfrow(36)
    } else {
      grDevices::n2mfrow(ncol(data))
    }
  } else if (is.null(nrow) & !is.null(ncol)) {
    dims <- c(ceiling(ncol(data)/ncol), ncol)
  } else if (is.null(ncol) & !is.null(nrow)) {
    dims <- c(nrow, ceiling(ncol(data)/nrow))
  } else {
    dims <- c(nrow, ncol)
  }


  op <- par(mfrow = dims)
  for (i in 1:ncol(data)) {
    # specify plot title, including % missing values for incomplete variables

    if (use_level) {
      if (missing(idvar))
        stop("'idvar' must be specified when 'use_level = TRUE'.")

      istvar <- check_tvar(data[, i], data[, idvar])
      if (!istvar)
        x <- data[match(unique(data[, idvar]), data[, idvar]), i]
      else x <- data[, i]
    } else {
      x <- data[, i]
    }

    pNA <- round(mean(is.na(x))*100, 1)

    main <- if (any(is.na(data[, i])) | allNA) {
      paste0(names(data)[i], " (", pNA, "% NA)")
    } else {
      names(data)[i]
    }

    if (use_level)
      main <- paste0(main, "\n", ifelse(istvar, "level-1", "level-2"))


    if (is.factor(x)) {
      if (any(is.na(x))) {
        x <- factor(x, levels = c(levels(x), "NA"), ordered = T)
        x[is.na(x)] <- "NA"
      }
      if (is.null(args_barplot)) {
        barplot(table(x), ylab = ylab, main = main, col = fill,
                border = border, xlab = xlab)
      } else {
        barplot(table(x), ylab = ylab, main = main, col = fill,
                border = border, xlab = xlab, args_barplot)
      }
    } else if (is.character(x)) {
      plot(0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "",
           main = main, bty = 'n')
      text(1, 0, paste0(names(data)[i], " \nis coded as character\nand cannot be plotted."), xpd = TRUE)
    } else if (class(x) %in% c('Date', 'POSIXt')) {
      if (is.null(args_hist)) {
        breaks <-  seq(min(x, na.rm  = TRUE), max(x, na.rm = TRUE), length.out = 10 + 1)
        hist(as.numeric(x), ylab = ylab, main = main, xaxt = 'n',
             col = fill, border = border, xlab = xlab,
             breaks = as.numeric(breaks))
        axis(side = 1, at = as.numeric(breaks), labels = breaks)
      } else {
        nclass <- ifelse(is.na(args_hist['nclass']), 10, args_hist['nclass'])
        breaks <- seq(min(x, na.rm  = TRUE),
                      max(x, na.rm = TRUE),
                      length.out = nclass + 1)

        hist(as.numeric(x), ylab = ylab, main = main, xaxt = 'n',
             col = fill, border = border, xlab = xlab, args_hist,
             breaks = as.numeric(breaks))
        axis(side = 1, at = as.numeric(breaks), labels = breaks, args_hist)
      }
    } else {
      if (is.null(args_hist)) {
        hist(x, ylab = ylab, main = main,
             col = fill, border = border, xlab = xlab)
      } else {
        hist(x, ylab = ylab, main = main,
             col = fill, border = border, xlab = xlab, args_hist)
      }
    }
  }

  on.exit(par(op))
}
