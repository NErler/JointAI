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
#' @param outcome optional; vector identifying the sub-models whose parameters
#'                are included, either by their indices (in the order of the
#'                list of model formulas) or their names (LHS of the respective
#'                model formula as character string). If \code{NULL} (default),
#'                all monitored parameters are included. With parameters from
#'                several sub-models, the coefficients are named
#'                \code{"outcome: variable"}, otherwise by the variable only.
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
#' auto_corr(fit)
#' auto_corr_plot(fit)
#'
#TODO: add unit tests
#TODO: refactor to make use of a general MCMC preparation function
#TODO: include cross- and autocorrelation in vignettes
auto_corr <- function(
  object,
  lags = 0:30,
  by_chain = TRUE,
  outcome = NULL,
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
  nodes <- get_corr_nodes(object, outcome)
  MCMC <- window(object$MCMC[, nodes, drop = FALSE], start, end, thin)

  MCMC <- lapply(MCMC, function(mcmc) {
    colnames(mcmc) <- get_plotmain(object, nodes, ylab = TRUE)
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


#' @rdname auto_corr
#' @export
auto_corr_plot <- function(
  object,
  lags = 0:30,
  by_chain = TRUE,
  outcome = NULL,
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

  auto_corr <- auto_corr(
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
#' @param outcome optional; vector identifying the sub-models whose parameters
#'                are included, either by their indices (in the order of the
#'                list of model formulas) or their names (LHS of the respective
#'                model formula as character string). If \code{NULL} (default),
#'                all monitored parameters are included. With parameters from
#'                several sub-models, the coefficients are named
#'                \code{"outcome: variable"}, otherwise by the variable only.
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
#' cross_corr(fit)
#' cross_corr_plot(fit, type = "coda")

#TODO: add unit tests
cross_corr <- function(
  object,
  outcome = NULL,
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

  nodes <- get_corr_nodes(object, outcome)
  MCMC <- window(object$MCMC[, nodes, drop = FALSE], start, end, thin)

  mcmc <- coda::as.mcmc(do.call(rbind, MCMC))
  colnames(mcmc) <- get_plotmain(object, nodes, ylab = TRUE)

  coda::crosscorr(mcmc)
}


#' @rdname cross_corr
#' @export
cross_corr_plot <- function(
  object,
  outcome = NULL,
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

  nodes <- get_corr_nodes(object, outcome)
  MCMC <- window(object$MCMC[, nodes, drop = FALSE], start, end, thin)

  mcmc <- coda::as.mcmc(do.call(rbind, MCMC))
  colnames(mcmc) <- get_plotmain(object, nodes, ylab = TRUE)

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


#' Parameters to include in the auto- and cross-correlation of MCMC samples
#'
#' @param object an object of class JointAI
#' @param outcome optional; vector of indices or names of the sub-models whose
#'                parameters are selected; \code{NULL} selects all monitored
#'                parameters
#'
#' @returns a character vector with the names of the selected columns of the
#'          MCMC sample, in the order of the MCMC sample
#' @keywords internal
get_corr_nodes <- function(object, outcome) {
  nodes <- colnames(object$MCMC[[1L]])

  if (is.null(outcome)) {
    return(nodes)
  }

  outcome_names <- names(object$fixed[outcome])
  if (anyNA(outcome_names)) {
    errormsg(
      "The value given for %s does not match the sub-models of this
             model.",
      dQuote("outcome")
    )
  }

  # the sub-model each parameter belongs to is given by parameters()
  params <- parameters(object, expand_ranef = TRUE)
  in_outcome <- params$outcome %in% internal_clean_survname(outcome_names)
  selected <- nodes[nodes %in% params$coef[in_outcome]]

  if (length(selected) == 0L) {
    errormsg("No parameters of the selected sub-model(s) are monitored.")
  }
  selected
}
