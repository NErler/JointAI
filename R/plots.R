#' Traceplot of a JointAI model
#'
#' Creates a set of traceplots from the MCMC sample of an object of class JointAI
#'
#' @param object object inheriting from class \code{JointAI}
#' @param subset subset of monitored parameters (columns in the MCMC sample).
#'               Can be specified as a numeric vector of columns, a vector of
#'               column names, as \code{subset = "main"} or \code{NULL}.
#'               If \code{NULL}, all monitored nodes will be plotted.
#'               \code{subset = "main"} (default) the main parameters of the
#'               analysis model will be plotted (regression coefficients/fixed
#'               effects, and, if available, standard deviation of the residual
#'               and random effects covariance matrix).
#' @param start the first iteration of interest (see \code{\link[coda]{window.mcmc}})
#' @param end the last iteration of interest (see \code{\link[coda]{window.mcmc}})
#' @param thin thinning interval (see \code{\link[coda]{window.mcmc}})
#' @param nrow optional; number of rows in the plotting layout
#'             (determined automatically if not specified)
#' @param ncol optional; number of columns in the plotting layout
#'             (determined automatically if not specified)
#' @inheritDotParams graphics::matplot -x -y -type -xlab -ylab -pch
#' @name traceplot
#'
#' @seealso \code{\link{summary.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'           \code{\link{lm_imp}}
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' traceplot(mod1)
#' }
#' @export
traceplot <- function(object, ...) {
  UseMethod("traceplot")
}

#' @rdname traceplot
#' @export
traceplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                              subset = "main", nrow = NULL, ncol = NULL, ...) {

  prep <- plot_prep(object, start = start, end = end, thin = thin, subset = subset,
                    nrow = nrow, ncol = ncol)

  op <- par(mfrow = c(prep$nrow, prep$ncol), mar = c(3.2, 2.5, 2, 1),
            mgp = c(2, 0.6, 0), ask = prep$ask)

  for (i in 1:nvar(prep$MCMC)) {
    matplot(x = prep$time, as.array(prep$MCMC)[, i, ], type = "l", xlab = "Iterations", ylab = "",
            main = colnames(prep$MCMC[[1]])[i], ...)
  }
  par(op)
}



#' Plot posterior density from JointAI model
#'
#' Plots a set of densities (per MC chain and coefficient) from the MCMC sample
#' of an object of class JointAI
#' @inheritParams traceplot
#' @param vlines list, where each element is a named list of parameters that
#'               can be passed to \code{\link[graphics]{abline}} to create
#'               vertical lines.
#'               Each of the list elements needs to contain at least
#'               \code{v = <x location>}, where <x location> is a vector of the
#'               same length as the number of plots (see examples).
#' @param ... additional parameters passed to \code{\link[graphics]{plot}}
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # densplot without vertical lines
#' densplot(mod1)
#'
#' # use vlines to mark zero
#' densplot(mod1, col = c("darkred", "darkblue", "darkgreen"),
#'          vlines = list(list(v = rep(0, nrow(summary(mod1)$stats)),
#'                             col = grey(0.8)))
#'         )
#'
#' # use vlines to visualize the posterior mean and 2.5% and 97.5% quantiles
#' densplot(mod1, vlines = list(list(v = summary(mod1)$stats[, "Mean"], lty = 1, lwd = 2),
#'                              list(v = summary(mod1)$stats[, "2.5%"], lty = 2),
#'                              list(v = summary(mod1)$stats[, "97.5%"], lty = 2))
#'         )
#' }
#' @export
densplot <- function(object, ...) {
  UseMethod("densplot")
}


#' @rdname densplot
#' @export
densplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                             subset = "main", vlines = NULL, nrow = NULL,
                             ncol = NULL, ...) {

  prep <- plot_prep(object, start = start, end = end, thin = thin,
                    subset = subset, nrow = nrow, ncol = ncol)


  op <- par(mfrow = c(prep$nrow, prep$ncol), mar = c(3, 3, 2, 1),
            mgp = c(2, 0.6, 0), ask = prep$ask)
  for (i in 1:ncol(prep$MCMC[[1]])) {
    dens <- lapply(prep$MCMC[, i], density)
    vline_range <- if (is.list(vlines[[1]])) {
      lapply(lapply(vlines, "[[", "v"), "[", i)
    }else{
      vlines$v
    }
    plot(NULL,
         xlim = range(lapply(dens, "[[", "x"), vline_range, na.rm = T),
         ylim = range(lapply(dens, "[[", "y"), na.rm = T),
         main = colnames(prep$MCMC[[1]])[i],
         xlab = "", ylab = "density", ...
    )

    for (j in 1:length(prep$MCMC)) {
      lines(dens[[j]], col = j)
    }
    if (!is.null(vlines)) {
      for (l in 1:length(vlines)) {
        args <- if (is.list(vlines[[l]])) vlines[[l]] else vlines
        args$v <- args$v[i]
        do.call(abline, args)
      }
    }
  }
  par(op)
}






plot_prep <- function(object, start = NULL, end = NULL, thin = NULL, subset = NULL,
                      nrow = NULL, ncol = NULL) {
  if (is.null(start))
    start <- start(object$sample)

  if (is.null(end))
    end <- end(object$sample)

  if (is.null(thin))
    thin <- thin(object$sample)

  MCMC <- window(object$sample, start = start, end = end, thin = thin)
  time <- time(MCMC)

  coefs <- get_coef_names(object$Mlist, object$K)
  nams <- colnames(MCMC[[1]])
  nams[match(coefs[, 1], nams)] <- coefs[, 2]

  for (i in 1:length(MCMC)) {
    colnames(MCMC[[i]]) <- nams
  }

  scale_pars <- object$scale_pars
  if (!is.null(scale_pars)) {
    # re-scale parameters
    MCMC <- as.mcmc.list(lapply(MCMC, function(i) {
      as.mcmc(sapply(colnames(i), rescale, fixed2 = object$Mlist$fixed2, scale_pars = scale_pars,
                     MCMC = i, refs = object$Mlist$refs, object$Mlist$X2_names))
    }))
  }

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, object)
  }



  ask <- ncol(MCMC[[1]]) > 30

  if (is.null(nrow)) {
    if (is.null(ncol)) {
      nrow <- floor(sqrt(ncol(MCMC[[1]])))
    } else {
      nrow <- ceiling(ncol(MCMC[[1]])/ncol)
    }
  }

  if (is.null(ncol))
    ncol <- ceiling(ncol(MCMC[[1]])/nrow)

  if (ask) {
    nrow = 5
    ncol = 6
  }

  return(list(MCMC = MCMC, ask = ask, nrow = nrow, ncol = ncol,
              thin = thin, time = time, subset = subset))
}
