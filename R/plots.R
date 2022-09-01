#' Create traceplots for a MCMC sample
#'
#' Creates a set of traceplots from the MCMC sample of an object of class
#' 'JointAI'.
#'
#' @inheritParams sharedParams
#' @inheritDotParams graphics::matplot -x -y -type -xlab -ylab -pch -log -xlim -ylim
#' @inheritParams base::plot
#' @param outcome optional; vector identifying a subset of sub-models included
#'                in the output, either by specifying their indices (using the
#'                order used in the list of model formulas), or their
#'                names (LHS of the respective model formula as character
#'                string)
#' @name traceplot
#'
#' @seealso \code{\link{summary.JointAI}},
#'          \code{\link[JointAI:model_imp]{*_imp}},
#'          \code{\link{densplot}}\cr
#'          The vignette
#'          \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
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
#' # Example 5: changing how the ggplot version looks (using ggplot syntax)
#' library(ggplot2)
#'
#' traceplot(mod, use_ggplot = TRUE) +
#'   theme(legend.position = 'bottom') +
#'   xlab('iteration') +
#'   ylab('value') +
#'   scale_color_discrete(name = 'chain')
#'
#'
#' @export
traceplot <- function(object, ...) {
  UseMethod("traceplot", object)
}


#' @export
#' @keywords internal
traceplot.mcmc.list <- function(object, start = NULL, end = NULL,
                                thin = NULL, ...) {

  if (is.null(start)) start <- start(object)
  if (is.null(end)) end <- end(object)
  if (is.null(thin)) thin <- coda::thin(object)

  coda::traceplot(window(object, start = start, end = end,
                         thin = thin), ...)
}


#' @rdname traceplot
#' @export
traceplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                              subset = c(analysis_main = TRUE),
                              outcome = NULL, exclude_chains = NULL,
                              nrow = NULL, ncol = NULL, use_ggplot = FALSE,
                              warn = TRUE, mess = TRUE, ...) {


  # prepare the MCMC sample and obtain plotting parameters
  prep <- plot_prep(object, start = start, end = end, thin = thin,
                    subset = subset, outcome = outcome,
                    exclude_chains = exclude_chains,
                    nrow = nrow, ncol = ncol, warn = warn, mess = mess)

  # get the variable names to use for each sub-plot
  plotnams <- get_plotmain(object, colnames(prep$MCMC[[1]]))


  # if ggplot is used, the data needs to be converted to long format and
  # variable names are used as facet labels
  if (use_ggplot) {
    meltMCMC <- melt_matrix_list(lapply(prep$MCMC, as.matrix),
                                 varnames = c('iteration', 'variable'))
    meltMCMC$chain <- factor(meltMCMC$L1)

    labels <- setNames(plotnams, colnames(prep$MCMC[[1]]))

    ggplot2::ggplot(meltMCMC,
                    ggplot2::aes(iteration, value, color = chain)) +
      ggplot2::geom_line() +
      ggplot2::facet_wrap('variable', scales = 'free',
                          ncol = prep$ncol, nrow = prep$nrow,
                          labeller = ggplot2::as_labeller(labels))
  } else {
    # for base plots, set graphics parameters
    op <- par(mfrow = c(prep$nrow, prep$ncol),
              mar = c(3.2, 2.5, ifelse(length(object$fixed) == 1, 2, 3), 1),
              mgp = c(2, 0.6, 0))

    for (i in seq_len(coda::nvar(prep$MCMC))) {
      matplot(x = as.numeric(prep$time),
              y = as.array(prep$MCMC, drop = FALSE)[, i, ], type = "l",
              xlab = "Iterations", ylab = "",
              main = plotnams[i], ...)
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
#'               can be passed to \code{graphics::abline()} to create
#'               vertical lines.
#'               Each of the list elements needs to contain at least
#'               \code{v = <x location>} where <x location> is a vector of the
#'               same length as the number of plots (see examples).
#' @param joined logical; should the chains be combined before plotting?
#' @param ... additional parameters passed to \code{plot()}
#' @examples
#'
#' \dontrun{
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
#'          vlines = list(list(v = rep(0, nrow(summary(mod)$res$y$regcoef)),
#'                             col = grey(0.8))))
#'
#'
#' # Example 3: use vlines to visualize posterior mean and 2.5%/97.5% quantiles
#' res <- rbind(summary(mod)$res$y$regcoef[, c('Mean', '2.5%', '97.5%')],
#'              summary(mod)$res$y$sigma[, c('Mean', '2.5%', '97.5%'),
#'              drop = FALSE]
#'              )
#' densplot(mod, vlines = list(list(v = res[, "Mean"], lty = 1, lwd = 2),
#'                             list(v = res[, "2.5%"], lty = 2),
#'                             list(v = res[, "97.5%"], lty = 2)))
#'
#'
#' # Example 4: ggplot version
#' densplot(mod, use_ggplot = TRUE)
#'
#'
#' # Example 5: change how the ggplot version looks
#' library(ggplot2)
#'
#' densplot(mod, use_ggplot = TRUE) +
#'   xlab("value") +
#'   theme(legend.position = 'bottom') +
#'   scale_color_brewer(palette = 'Dark2', name = 'chain')
#' }
#'
#' @seealso
#' The vignette
#' \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' contains some examples how to specify the argument \code{subset}.
#'
#'
#' @export
densplot <- function(object, ...) {
  UseMethod("densplot", object)
}


#' @export
#' @keywords internal
densplot.mcmc.list <- function(object, start = NULL, end = NULL,
                               thin = NULL, ...) {

  if (is.null(start)) start <- start(object)
  if (is.null(end)) end <- end(object)
  if (is.null(thin)) thin <- coda::thin(object)

  coda::densplot(window(object, start = start, end = end,
                        thin = thin), ...)
}


#' @rdname densplot
#' @export
densplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                             subset = c(analysis_main = TRUE),
                             outcome = NULL,
                             exclude_chains = NULL, vlines = NULL, nrow = NULL,
                             ncol = NULL, joined = FALSE, use_ggplot = FALSE,
                             warn = TRUE, mess = TRUE, ...) {

  # prepare the MCMC sample and obtain plotting parameters
  prep <- plot_prep(object, start = start, end = end, thin = thin,
                    subset = subset, outcome = outcome,
                    exclude_chains = exclude_chains,
                    nrow = nrow, ncol = ncol, warn = warn,
                    mess = mess)

  # if MCMC chains should be combined, combine the samples of the chains.
  # Set the resulting object as mcmc.list so that the rest of the syntax
  # works for either case
  if (joined)
    prep$MCMC <- coda::as.mcmc.list(coda::as.mcmc(do.call(rbind, prep$MCMC)))


  # obtain the variable names to be used as names for the sub-plots
  plotnams <- get_plotmain(object, colnames(prep$MCMC[[1]]))
  for (k in seq_along(prep$MCMC)) {
    colnames(prep$MCMC[[k]]) <- plotnams
  }


  if (use_ggplot) {
    # if ggplot is used, the data needs to be converted to long format and
    # variable names are used as facet labels

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
      col <- seq_len(length(prep$MCMC))
    }


    op <- par(mfrow = c(prep$nrow, prep$ncol),
              mar = c(2, 3, ifelse(length(object$fixed) == 1, 2, 3), 1),
              mgp = c(2, 0.6, 0))

    for (i in seq_len(ncol(prep$MCMC[[1]]))) {
      dens <- lapply(prep$MCMC[, i], density)
      vline_range <- if (is.list(vlines[[1]])) {
        lapply(lapply(vlines, "[[", "v"), "[", i)
      }else{
        vlines$v
      }

      plot(NULL,
           xlim = range(lapply(dens, "[[", "x"), vline_range, na.rm = TRUE),
           ylim = range(lapply(dens, "[[", "y"), na.rm = TRUE),
           main = plotnams[i],
           xlab = "", ylab = "density", ...
      )

      for (j in seq_len(length(prep$MCMC))) {
        args_lines <- c(list(x = dens[[j]]$x,
                             y = dens[[j]]$y,
                             type = 'l',
                             col = col[j]),
                        args[names(args) %in% names(formals(plot.xy))]
        )
        do.call(lines, args_lines)
      }

      if (!is.null(vlines)) {
        for (l in seq_len(length(vlines))) {
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


# used in traceplot and densplot (2020-06-13)
plot_prep <- function(object, start = NULL, end = NULL, thin = NULL,
                      subset = NULL, outcome = NULL, exclude_chains = NULL,
                      nrow = NULL, ncol = NULL, warn = TRUE, mess = TRUE,
                      ...) {

  # Help function for densityplot and traceplot


  if (is.null(object$MCMC)) errormsg("There is no MCMC sample.")

  # set first and last iteration to be used and thinning interval
  if (is.null(start)) start <- start(object$MCMC)
  if (is.null(end)) end <- end(object$MCMC)
  if (is.null(thin)) thin <- coda::thin(object$MCMC)

  # create a subset of the MCMC sample based on the user-selected set of
  # parameters
  MCMC <- get_subset(object, subset, warn = warn, mess = mess)

  if (!is.null(outcome)) {
    outcomes <- clean_survname(names(object$fixed)[outcome])
    params <- parameters(object, expand_ranef = TRUE)
    selected_params <- params$coef[lvapply(params$outcome,
                                           function(x) any(outcomes %in% x))]

    if (any(!selected_params %in% colnames(object$MCMC[[1]]))) {
      errormsg("Not all of the parameters that were selected are present in the
                MCMC sample (%s). Please contact the package maintainer.",
               paste_and(dQuote(
                 selected_params[!selected_params %in% colnames(MCMC[[1]])]
               ))
      )
    } else {
      MCMC <- MCMC[, intersect(selected_params, colnames(MCMC[[1]])),
                   drop = FALSE]
    }
  }

  # set MCMC chains to be excluded from the output
  chains <- seq_along(MCMC)
  if (!is.null(exclude_chains)) {
    chains <- chains[-exclude_chains]
  }

  # reduce the MCMC sample to the selected chains and iterations
  MCMC <- window(MCMC[chains], start = start, end = end, thin = thin)

  # obtain the iteration numbers from the MCMC sample to use as x-axis in
  # the traceplot
  time <- time(MCMC)

  # get number of rows and columns of plots.
  # If there are more than 36 plots and the number of rows and columns is
  # determined automatically, create multiple pages of plots with max. 36
  # plots per page
  if (is.null(nrow) & is.null(ncol)) {
    dims <- if (ncol(MCMC[[1]]) > 36) {
      grDevices::n2mfrow(36)
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



get_plotmain <- function(object, plotnams, ylab = FALSE) {
  # match variable names with the column names to get the titles of the
  # sub-plots
  # - object: an object of class JointAI
  # - plotnams: names of the columns of the subset of the MCMC sample
  # - ylab: logical; if TRUE, names are outcome: variable, otherwise they use
  #         two rows variable\n(outcome)

  # get the list of coefficient names from the JointAI object
  coefs <- do.call(rbind, object$coef_list)

  coef_set <- coefs[na.omit(match(plotnams, coefs$coef)), ]


  if (length(unique(coef_set$outcome)) == 1) {
    plotnams[na.omit(match(coefs$coef, plotnams))] <-
      coefs$varnam_print[na.omit(match(plotnams, coefs$coef))]
  } else {
    if (ylab) {
      plotnams[na.omit(match(coefs$coef, plotnams))] <-
        paste0(coefs$outcome[sort(na.omit(match(plotnams, coefs$coef)))], ": ",
               coefs$varnam_print[sort(na.omit(match(plotnams, coefs$coef)))])
    } else {
      plotnams[na.omit(match(coefs$coef, plotnams))] <-
        paste0(coefs$varnam_print[sort(na.omit(match(plotnams, coefs$coef)))],
               "\n",
               "(", coefs$outcome[sort(na.omit(match(plotnams, coefs$coef)))],
               ")")
    }
  }
  plotnams
}



#' Visualize the distribution of all variables in the dataset
#'
#' This function plots a grid of histograms (for continuous variables) and
#' bar plots (for categorical variables) and labels it with the proportion of
#' missing values in each variable.
#' @param data a \code{data.frame} (or a \code{matrix})
#' @param fill colour the histograms and bars are filled with
#' @param border colour of the borders of the histograms and bars
#' @param allNA logical; if \code{FALSE} (default) the proportion of missing
#'              values is only given for variables that have missing values,
#'              if \code{TRUE} it is given for all variables
#' @inheritParams sharedParams
#' @param ... additional parameters passed to \code{\link[graphics]{barplot}}
#'            and \code{\link[graphics]{hist}}
#'
#' @seealso Vignette: \href{https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html}{Visualizing Incomplete Data}
#'
#' @examples
#' op <- par(mar = c(2,2,3,1), mgp = c(2, 0.6, 0))
#' plot_all(wideDF)
#' par(op)
#'
#' @export

plot_all <- function(data, nrow = NULL, ncol = NULL,
                     fill = grDevices::grey(0.8),
                     border = 'black', allNA = FALSE, idvars = NULL,
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
  if (!is.null(idvars)) {
    groups <- data[, idvars, drop = FALSE]
    groups$lvlone <- seq_len(nrow(groups))
    varlvls <- get_datlvls(data, groups)
    # varlvls <- sapply(data, check_varlevel, groups = groups)
  }

  for (i in names(data)) {
    if (!is.null(idvars)) {
      x <- data[match(unique(groups[, varlvls[i]]), groups[, varlvls[i]]), i]
    } else x <- data[, i]

    pNA <- round(mean(is.na(x))*100, 1)

    main <- if (any(is.na(data[, i])) | allNA) {
      paste0(i, " (", pNA, "% NA)")
    } else {
      i
    }

    if (!is.null(idvars))
      main <- paste0(main, "\n", "(", varlvls[i], ")")


    if (is.factor(x) | is.logical(x)) {
      if (any(is.na(x))) {
        x <- factor(x, levels = c(levels(x), "NA"), ordered = TRUE)
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
      text(1, 0, paste0(i,
                        " \nis coded as character\nand cannot be plotted."),
           xpd = TRUE)
    } else if (class(x) %in% c('Date', 'POSIXt')) {
      if (is.null(args_hist)) {
        breaks <-  seq(min(x, na.rm  = TRUE), max(x, na.rm = TRUE),
                       length.out = 10 + 1)
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
