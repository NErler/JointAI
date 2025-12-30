#' Autocorrelation of MCMC samples
#'
#' This function obtains the autocorrelation of the MCMC samples in an JointAI
#' object via `coda::autocorr.diag()`. `autocorr_plot()` visualizes the results
#' using **ggplot2**.
#'
#'
#' @param object an object of class JointAI
#' @param lags a numeric vector indicating the lags to consider
#' @param by_chain logical; should the autocorrelation be computed for each
#'                 chain separately?
#' @param outcome integer; index of the outcome model for which the
#'               autocorrelation should be plotted
#' @param start the first iteration of interest
#'              (see \code{\link[coda]{window.mcmc}})
#' @param end the last iteration of interest
#'            (see \code{\link[coda]{window.mcmc}})
#' @param thin thinning interval (integer; see \code{\link[coda]{window.mcmc}}).
#'             For example, \code{thin = 1} (default) will keep the MCMC samples
#'             from all iterations; \code{thin = 5} would only keep every 5th
#'             iteration.
#'
#' @returns a `matrix` or a `list` of `matrix` objects if `by_chain = TRUE`, or
#'          a `ggplot()` object for `autocorr_plot()`.
#' @export
#' @examples
#' fit <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 200)
#' autocorr(fit)
#' autocorr_plot(fit)
#'
#TODO: add unit tests
#TODO: refactor to make use of a general MCMC preparation function
#TODO: include cross- and autocorrelation in vignettes
autocorr <- function(
  object,
  lags = 0:30,
  by_chain = TRUE,
  outcome = 1L,
  start = NULL,
  end = NULL,
  thin = NULL
) {
  if (!inherits(object, "JointAI")) {
    stop("object must be of class 'JointAI'")
  }

  if (is.null(object$MCMC)) {
    errormsg("There is no MCMC sample.")
  }

  if (is.null(start)) {
    start <- start(object$MCMC)
  }
  if (is.null(end)) {
    end <- end(object$MCMC)
  }
  if (is.null(thin)) {
    thin <- coda::thin(object$MCMC)
  }

  #TODO add validation of input to "outcome" to avoid unclear error messages
  coefs <- with(object$coef_list[[outcome]], setNames(varnam_print, coef))

  MCMC <- window(object$MCMC, start = start, end = end, thin = thin)

  MCMC <- lapply(MCMC, function(mcmc) {
    colnames(mcmc) <- ifelse(
      colnames(mcmc) %in% names(coefs),
      coefs[colnames(mcmc)],
      colnames(mcmc)
    )
    mcmc
  })
  MCMC <- coda::as.mcmc.list(MCMC)

  auto_corr <- if (by_chain) {
    lapply(MCMC, coda::autocorr.diag, lags = lags)
  } else {
    coda::autocorr.diag(MCMC, lags = lags)
  }
  auto_corr
}


#' @rdname autocorr
#' @export
autocorr_plot <- function(
  object,
  lags = 0:30,
  by_chain = TRUE,
  outcome = 1L,
  start = NULL,
  end = NULL,
  thin = NULL
) {
  if (!inherits(object, "JointAI")) {
    stop("object must be of class 'JointAI'")
  }

  if (!requireNamespace('ggplot2', quietly = TRUE)) {
    errormsg("This function requires the 'ggplot2' package to be installed.")
  }

  auto_corr <- autocorr(
    object,
    lags = lags,
    by_chain = by_chain,
    outcome = outcome,
    start = start,
    end = end,
    thin = thin
  )

  long_df <- if (by_chain) {
    melt_matrix_list(auto_corr)
  } else {
    melt_matrix(auto_corr)
  }

  long_df$lag <- as.numeric(gsub("Lag ", "", long_df$V1))

  p0 <- ggplot2::ggplot(long_df, ggplot2::aes(x = lag, y = value)) +
    ggplot2::facet_wrap("V2") +
    ggplot2::ylab("Auto-correlation") +
    ggplot2::xlab("Lag") +
    ggplot2::coord_cartesian(ylim = c(-1, 1))

  if (by_chain) {
    p0 +
      ggplot2::geom_line(ggplot2::aes(color = as.factor(L1))) +
      ggplot2::geom_point(ggplot2::aes(color = as.factor(L1)), size = 0.5) +
      ggplot2::scale_color_discrete(guide = "none")
  } else {
    p0 +
      ggplot2::geom_col()
  }
}


#' Cross-correlation of MCMC samples
#'
#' These functions compute the cross-correlations of the MCMC samples in an
#' JointAI object via `coda::crosscorr()` and plot them using either the
#' **corrplot** package or `coda::crosscorr.plot()`.
#'
#' @param object an object of class JointAI
#' @param outcome integer; index of the outcome model for which the
#'                correlations should be plotted
#' @param start the first iteration of interest
#'              (see \code{\link[coda]{window.mcmc}})
#' @param end the last iteration of interest
#'            (see \code{\link[coda]{window.mcmc}})
#' @param thin thinning interval (integer; see \code{\link[coda]{window.mcmc}}).
#'             For example, \code{thin = 1} (default) will keep the MCMC samples
#'             from all iterations; \code{thin = 5} would only keep every 5th
#'             iteration.
#' @param type character; type of plot to be produced. Either "corrplot"
#'             (default) or "coda".
#'
#' @returns a matrix (or a plot)
#' @export
#' @examples
#' fit <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 200)
#' crosscorr(fit)
#' crosscorr_plot(fit, type = "coda")

#TODO: add unit tests
crosscorr <- function(
  object,
  outcome = 1L,
  start = NULL,
  end = NULL,
  thin = NULL
) {
  if (!inherits(object, "JointAI")) {
    stop("object must be of class 'JointAI'")
  }

  if (is.null(object$MCMC)) {
    errormsg("There is no MCMC sample.")
  }

  if (is.null(start)) {
    start <- start(object$MCMC)
  }
  if (is.null(end)) {
    end <- end(object$MCMC)
  }
  if (is.null(thin)) {
    thin <- coda::thin(object$MCMC)
  }

  MCMC <- window(object$MCMC, start = start, end = end, thin = thin)

  mcmc <- coda::as.mcmc(do.call(rbind, MCMC))
  coefs <- with(object$coef_list[[outcome]], setNames(varnam_print, coef))

  colnames(mcmc) <- ifelse(
    colnames(mcmc) %in% names(coefs),
    coefs[colnames(mcmc)],
    colnames(mcmc)
  )

  coda::crosscorr(mcmc)
}


#' @rdname crosscorr
#' @export
crosscorr_plot <- function(
  object,
  outcome = 1L,
  start = NULL,
  end = NULL,
  thin = NULL,
  type = "corrplot"
) {
  if (!inherits(object, "JointAI")) {
    stop("object must be of class 'JointAI'")
  }

  if (is.null(object$MCMC)) {
    errormsg("There is no MCMC sample.")
  }

  if (is.null(start)) {
    start <- start(object$MCMC)
  }
  if (is.null(end)) {
    end <- end(object$MCMC)
  }
  if (is.null(thin)) {
    thin <- coda::thin(object$MCMC)
  }

  MCMC <- window(object$MCMC, start = start, end = end, thin = thin)

  mcmc <- coda::as.mcmc(do.call(rbind, MCMC))
  coefs <- with(object$coef_list[[outcome]], setNames(varnam_print, coef))

  colnames(mcmc) <- ifelse(
    colnames(mcmc) %in% names(coefs),
    coefs[colnames(mcmc)],
    colnames(mcmc)
  )

  corrmat <- coda::crosscorr(mcmc)

  if (type == "corrplot") {
    if (!requireNamespace("corrplot", quietly = TRUE)) {
      stop("The 'corrplot' package is required but not installed.")
    }

    corrplot::corrplot(
      corrmat,
      method = "square",
      addCoef.col = grDevices::grey(0.2),
      type = "lower",
      diag = FALSE,
      tl.col = "black"
    )
  } else {
    xpos <- rep(1:ncol(mcmc), each = ncol(mcmc)) - 0.5
    ypos <- rep(ncol(mcmc):1, times = ncol(mcmc)) - 0.5

    coda::crosscorr.plot(mcmc)

    text(
      xpos[lower.tri(corrmat)],
      ypos[lower.tri(corrmat)],
      label = sprintf("%.2f", corrmat[lower.tri(corrmat)])
    )
  }
}
