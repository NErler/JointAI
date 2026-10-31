#' Gelman-Rubin criterion for convergence
#'
#' Calculates the Gelman-Rubin criterion for convergence
#' (uses \code{\link[coda]{gelman.diag}} from package \strong{coda}).
#' @inheritParams coda::gelman.diag
#' @inheritParams summary.JointAI
#' @references
#' Gelman, A and Rubin, DB (1992) Inference from iterative simulation using
#' multiple sequences, \emph{Statistical Science}, \strong{7}, 457-511.
#'
#' Brooks, SP. and Gelman, A. (1998) General methods for monitoring convergence
#' of iterative simulations.
#' \emph{Journal of Computational and Graphical Statistics}, \strong{7}, 434-455.
#'
#' @seealso
#' The vignette
#' \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' contains some examples how to specify the argument \code{subset}.
#'
#'
#' @examples
#' mod1 <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
#' GR_crit(mod1)
#'
#'
#'
#' @export
GR_crit <- function(
  object,
  confidence = 0.95,
  transform = FALSE,
  autoburnin = TRUE,
  multivariate = TRUE,
  subset = NULL,
  exclude_chains = NULL,
  start = NULL,
  end = NULL,
  thin = NULL,
  warn = TRUE,
  mess = TRUE,
  ...
) {
  if (!inherits(object, "JointAI")) {
    errormsg('Object must be of class "JointAI".')
  }

  if (is.null(object$MCMC)) {
    errormsg("No MCMC sample.")
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

  MCMC <- get_subset(object, subset, warn = warn, mess = mess)

  chains <- seq_along(MCMC)
  if (!is.null(exclude_chains)) {
    chains <- chains[-exclude_chains]
  }

  MCMC <- window(MCMC[chains], start = start, end = end, thin = thin)
  plotnams <- get_plotmain(object, colnames(MCMC[[1]]), ylab = TRUE)

  for (i in seq_len(length(MCMC))) {
    colnames(MCMC[[i]]) <- plotnams
  }

  coda::gelman.diag(
    x = MCMC,
    confidence = confidence,
    transform = transform,
    autoburnin = autoburnin,
    multivariate = multivariate
  )
}


#' Calculate and plot the Monte Carlo error
#'
#' Calculate, print and plot the Monte Carlo error of the samples from a
#' 'JointAI' model, combining the samples from all MCMC chains.
#' @param x object inheriting from class 'JointAI'
#' @param digits number of digits for the printed output
#' @inheritParams summary.JointAI
#' @inheritDotParams mcmcse::mcse.mat -x
#'
#' @return An object of class \code{MCElist} with elements
#'         \code{data_scale}, \code{sampling_scale} and \code{digits}. The
#'         first two are matrices with one row per selected node and columns
#'         \code{est} (posterior mean), \code{MCSE} (Monte Carlo error),
#'         \code{SD} (posterior standard deviation) and \code{MCSE/SD}
#'         (Monte Carlo error divided by post. standard deviation), for the
#'         MCMC sample transformed back to the scale of the data and for the
#'         sample on the scale used in JAGS. \code{sampling_scale} is
#'         \code{NULL} unless the model was fitted with
#'         \code{keep_scaled_mcmc = TRUE}.
#'
#' @note Lesaffre & Lawson (2012; p. 195) suggest the Monte Carlo error of a
#'       parameter should not be more than 5% of the posterior standard
#'       deviation of this parameter (i.e., \eqn{MCSE/SD \le 0.05}).
#'
#' \strong{Long variable names:}\cr
#' The default plot margins may not be wide enough when variable names are
#' longer than a few characters. The plot margin can be adjusted (globally)
#' using the argument \code{"mar"} in \code{\link[graphics]{par}}.
#'
#'
#' @references
#' Lesaffre, E., & Lawson, A. B. (2012).
#' \emph{Bayesian Biostatistics}.
#' John Wiley & Sons.
#'
#' @seealso
#' The vignette
#' \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' provides some examples how to specify the argument \code{subset}.
#'
#' @examples
#'
#' \dontrun{
#'
#' mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' MC_error(mod)
#'
#' plot(MC_error(mod), ablinepars = list(lty = 2),
#'      plotpars = list(pch = 19, col = 'blue'))
#' }
#'
#' @export
MC_error <- function(
  x,
  subset = NULL,
  exclude_chains = NULL,
  start = NULL,
  end = NULL,
  thin = NULL,
  digits = 2,
  warn = TRUE,
  mess = TRUE,
  ...
) {
  if (!inherits(x, "JointAI")) {
    errormsg("%s must be of class %s.", dQuote("x"), sQuote("JointAI"))
  }

  if (is.null(x$MCMC)) {
    errormsg("No MCMC sample.")
  }

  if (!"mcmcse" %in% installed.packages()[, "Package"]) {
    errormsg(
      "The package 'mcmcse' needs to be installed to use the function
             %s.",
      dQuote("MC_error()")
    )
  }

  if (is.null(start)) {
    start <- start(x$MCMC)
  }

  if (is.null(end)) {
    end <- end(x$MCMC)
  }

  if (is.null(thin)) {
    thin <- coda::thin(x$MCMC)
  }

  # selected nodes (columns of the MCMC sample)
  MCMC <- get_subset(object = x, subset = subset, warn = warn, mess = mess)

  chains <- seq_along(MCMC)
  if (!is.null(exclude_chains)) {
    chains <- chains[-exclude_chains]
  }

  MCMC <- do.call(
    rbind,
    window(MCMC[chains], start = start, end = end, thin = thin)
  )
  nodes <- colnames(MCMC)
  plotnams <- get_plotmain(x, nodes, ylab = TRUE)

  # MC error for the MCMC sample transformed back to the data scale
  MCE1 <- mce_matrix(MCMC, plotnams, ...)

  # MC error for the sample on the scale used in JAGS (only kept when the
  # model was fitted with keep_scaled_mcmc = TRUE), for the same nodes, chains
  # and iterations
  if (!is.null(x$sample)) {
    mcmc <- do.call(
      rbind,
      window(x$sample[chains], start = start, end = end, thin = thin)
    )
    MCE2 <- mce_matrix(mcmc[, nodes, drop = FALSE], plotnams, ...)
  } else {
    MCE2 <- NULL
  }

  out <- list(data_scale = MCE1, sampling_scale = MCE2, digits = digits)
  class(out) <- "MCElist"
  return(out)
}


#' Monte Carlo error of each column of an MCMC sample
#'
#' Used by `MC_error()`, for the sample on the data scale and on the scale used
#' in JAGS.
#'
#' @param mcmc matrix of MCMC samples (all chains combined), one column per
#'   node.
#' @param names character vector; names of the nodes (as printed), used as
#'   row names.
#' @param ... optional arguments passed to `mcmcse::mcse()`.
#'
#' @return Matrix with one row per node and columns `est` (posterior mean),
#'   `MCSE` (Monte Carlo error), `SD` (posterior standard deviation) and
#'   `MCSE/SD`. If `mcmcse::mcse()` fails for a node, `est` and `MCSE` are
#'   `NA`.
#' @keywords internal
mce_matrix <- function(mcmc, names, ...) {
  colnames(mcmc) <- names

  mce <- t(apply(mcmc, 2, function(k) {
    res <- try(mcmcse::mcse(k, ...), silent = TRUE)
    if (inherits(res, "try-error")) {
      c(NA, NA)
    } else {
      unlist(res)
    }
  }))
  colnames(mce) <- c("est", "MCSE")

  mce <- cbind(
    mce,
    SD = apply(mcmc, 2, sd)[match(colnames(mcmc), row.names(mce))]
  )
  cbind(mce, "MCSE/SD" = mce[, "MCSE"] / mce[, "SD"])
}


#' @export
print.MCElist <- function(x, ...) {
  print(x$data_scale, digits = x$digits)
}


# Plot Monte Carlo error
#' @param data_scale logical; show the Monte Carlo error of the sample
#'                   transformed back to the scale of the data (\code{TRUE}) or
#'                   on the sampling scale (this requires the argument
#'                   \code{keep_scaled_mcmc = TRUE} to be set when fitting the
#'                   model)
#' @param plotpars optional; list of parameters passed to
#'                 \code{plot()}
#' @param ablinepars optional; list of parameters passed to
#'                   \code{\link[graphics]{abline}()}
#' @param minlength number of characters the variable names are abbreviated to
#' @describeIn MC_error plot Monte Carlo error
#' @export

plot.MCElist <- function(
  x,
  data_scale = TRUE,
  plotpars = NULL,
  ablinepars = list(v = 0.05),
  minlength = 20,
  ...
) {
  mce <- if (data_scale == TRUE) {
    x$data_scale
  } else {
    x$sampling_scale
  }

  if (is.null(mce)) {
    errormsg(
      "The Monte Carlo error on the sampling scale is only available when the
      model was fitted with %s.",
      dQuote("keep_scaled_mcmc = TRUE")
    )
  }

  theaxis <- NULL
  names <- rownames(mce)
  names <- abbreviate(names, minlength = minlength)

  plotpars$x <- mce[, 4]
  plotpars$y <- rev(seq_len(nrow(mce)))

  if (is.null(plotpars$xlim)) {
    plotpars$xlim <- range(
      0,
      plotpars$x[!is.infinite(plotpars$x)],
      na.rm = TRUE
    )
  }
  if (is.null(plotpars$xlab)) {
    plotpars$xlab <- "MCE/SD"
  }
  if (is.null(plotpars$ylab)) {
    plotpars$ylab <- ""
  }
  if (is.null(plotpars$yaxt)) {
    plotpars$yaxt <- "n"
    theaxis <- expression(axis(
      side = 2,
      at = rev(seq_len(nrow(mce))),
      labels = names,
      las = 2,
      cex.axis = 0.8
    ))
  }
  if (is.null(ablinepars$v)) {
    ablinepars$v <- 0.05
  }

  do.call(plot, plotpars)
  eval(theaxis)
  do.call(abline, ablinepars)
}
