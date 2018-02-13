#' Gelman-Rubin criterion for convergence
#'
#' Gelman-Rubin criterion for convergence (uses \code{\link[coda]{gelman.diag}})
#' @param object inheriting from class \code{JointAI}
#' @inheritParams coda::gelman.diag
#' @inheritParams summary.JointAI
#' @references
#' Gelman, A., Meng, X. L., & Stern, H. (1996).
#' Posterior predictive assessment of model fitness via realized discrepancies.
#' \emph{Statistica Sinica}, 733-760.
#'
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' GR_crit(mod1)
#' }
#'
#' @export
GR_crit <- function(object, confidence = 0.95, transform = FALSE, autoburnin = TRUE,
                    multivariate = TRUE, subset = "main", start = NULL, end = NULL,
                    thin = NULL, ...) {

  if (!inherits(object, "JointAI"))
    stop("Object must be of class JointAI.")

  if (is.null(object$sample))
    stop("No mcmc sample.")


  if (is.null(start))
    start <- start(object$sample)

  if (is.null(end))
    end <- end(object$sample)

  if (is.null(thin))
    thin <- thin(object$sample)


  MCMC <- window(object$sample, start = start, end = end, thin = thin)
  coefs <- get_coef_names(object$Mlist, object$K)
  nams <- colnames(MCMC[[1]])
  nams[match(coefs[, 1], nams)] <- coefs[, 2]

  for (i in 1:length(MCMC)) {
    colnames(MCMC[[i]]) <- nams
  }

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, object)
  }

  gelman.diag(x = MCMC, confidence = confidence, transform = transform,
              autoburnin = autoburnin, multivariate = multivariate)
}



#' Monte Carlo error
#'
#' Calculate and plot the Monte Carlo error of the samples from a JointAI model
#' @param x object inheriting from class \code{JointAI}
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
#' @param digits number of digits for output
#' @inheritDotParams mcmcse::mcse.mat -x
#'
#' @return an object of class \code{MCElist} with elements \code{unscaled},
#'         \code{scaled} and \code{digits}. The first two are matrices with
#'         columns \code{est} (posterior mean), \code{MCSE} (Monte Carlo error),
#'         \code{SD} (posterior standard deviation) and \code{MCSE/SD}
#'         (Monte Carlo error divided by post. standard deviation.)
#'
#' @note Lesaffre & Lawson (2012) [p. 195] suggest the Monte Carlo error of a
#'       parameter should not be more than 5\% of the posterior standard
#'       deviation of this parameter (i.e., \eqn{MCSE/SD \le 0.05}).
#'
#'
#' @references
#' Lesaffre, E., & Lawson, A. B. (2012).
#' \emph{Bayesian biostatistics}.
#' John Wiley & Sons.
#'
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' MC_error(mod1)
#' }
#'
#' @export
MC_error <- function(x, subset = "main", start = NULL, end = NULL, thin = NULL,
                     digits = 2, ...) {

  if (!inherits(x, "JointAI"))
    stop("x must be of class JointAI.")

  if (is.null(x$sample))
    stop("No mcmc sample.")

  if (is.null(start))
    start <- start(x$sample)

  if (is.null(end))
    end <- end(x$sample)

  if (is.null(thin))
    thin <- thin(x$sample)


  MCMC <- do.call(rbind, window(x$sample, start = start, end = end, thin = thin))
  coefs <- get_coef_names(x$Mlist, x$K)
  colnames(MCMC)[match(coefs[, 1], colnames(MCMC))] <- coefs[, 2]

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, x)
  }

  res1 <- mcmcse::mcse.mat(x = MCMC, ...)
  colnames(res1) <- gsub("se", "MCSE", colnames(res1))

  scale_pars <- x$scale_pars
  if (!is.null(scale_pars)) {
    # re-scale parameters
    MCMC <- sapply(colnames(MCMC), rescale, x$Mlist$fixed2, scale_pars,
                   MCMC, x$Mlist$refs, x$Mlist$X2_names)
  }

  res2 <- mcmcse::mcse.mat(x = MCMC, ...)
  colnames(res2) <- gsub("se", "MCSE", colnames(res2))

  res1 <- cbind(res1,
                SD = apply(MCMC, 2, sd)[match(colnames(MCMC), row.names(res1))]
  )
  res1 <- cbind(res1,
                'MCSE/SD' = res1[, "MCSE"]/res1[, "SD"])
  res2 <- cbind(res2,
                SD = apply(MCMC, 2, sd)[match(colnames(MCMC), row.names(res2))]
  )
  res2 <- cbind(res2,
                'MCSE/SD' = res2[, "MCSE"]/res2[, "SD"])

  out <- list(unscaled = res1, scaled = res2, digits = digits)
  class(out) <- "MCElist"
  return(out)
}


#' @export
print.MCElist <- function(x, ...) {
  print(x$scaled, digits = x$digits)
}


# plot Monte Carlo error
#' @param scaled use the scaled or unscaled version, default is \code{TRUE}
#' @param plotpars optional; list of parameters passed to \code{\link[graphics]{plot}()}
#' @param ablinepars optional; list of parameters passed to \code{\link[graphics]{abline}()}
#' @describeIn MC_error plot Monte Carlo error
#' @export

plot.MCElist <- function(x, scaled = T, plotpars = NULL,
                         ablinepars = list(v = 0.05), ...) {

  theaxis <- NULL
  names <- rownames(x$scaled)
  names <- abbreviate(names, minlength = 12)

  plotpars$x <- x$scaled[, 4]
  plotpars$y <- nrow(x$scaled):1

  if (is.null(plotpars$xlim))
    plotpars$xlim <- range(0, plotpars$x)
  if (is.null(plotpars$xlab))
    plotpars$xlab <- "MCE/SD"
  if (is.null(plotpars$ylab))
    plotpars$ylab <- ""
  if (is.null(plotpars$yaxt)) {
    plotpars$yaxt <- "n"
    theaxis <- expression(axis(side = 2, at = nrow(x$scaled):1, labels = names,
                               las = 2, cex.axis = 0.8))
  }
  if (is.null(ablinepars$v))
    ablinepars$v <- 0.05

  do.call(plot, plotpars)
  eval(theaxis)
  do.call(abline, ablinepars)

  # plot(x$scaled[, 4], nrow(x$scaled):1, xlab = "MCE/SD", ylab = "",
  #      yaxt = "n", ...)
  # axis(side = 2, at = nrow(x$scaled):1, labels = names, las = 2, cex.axis = 0.8)
  # abline(v = abline, ...)
}
