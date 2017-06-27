#' Gelman-Rubin criterion for convergence
#' @param object JointAI object
#' @inheritParams coda::gelman.diag
#' @param start the first iteration of interest
#' @param end the last iteration of interest
#' @param thin the required interval between successive samples
#' @param subset subset of monitored nodes (columns in the MCMC sample) to use.
#'               Can be specified as a numeric vector of columns,  a vector of
#'               column names, as \code{subset = "main"} or \code{NULL}.
#'               If \code{NULL}, all monitored nodes will be plotted.
#'               \code{subset = "main"} (default) the main parameters of the
#'               analysis model will be plotted (regression coefficients,
#'               standard deviation of the residual, random effects covariance
#'               matrix).
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
                    thin = NULL) {

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
#' @param object JointAI object
#' @param subset subset of monitored nodes (columns in the MCMC sample) to use.
#'               Can be specified as a numeric vector of columns,  a vector of
#'               column names, as \code{subset = "main"} or \code{NULL}.
#'               If \code{NULL}, all monitored nodes will be plotted.
#'               \code{subset = "main"} (default) the main parameters of the
#'               analysis model will be plotted (regression coefficients,
#'               standard deviation of the residual, random effects covariance
#'               matrix).
#' @param start the first iteration of interest
#' @param end the last iteration of interest
#' @param thin the required interval between successive samples
#' @inheritDotParams mcmcse::mcse.mat
#'
#' @references
#' Lesaffre, E., & Lawson, A. B. (2012).
#' \emph{Bayesian biostatistics}.
#' John Wiley & Sons.
#'
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' GR_crit(mod1)
#' }
#'
#' @export
MC_error <- function(object, subset = "main", start = NULL, end = NULL, thin = NULL, ...) {

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


  MCMC <- do.call(rbind, window(object$sample, start = start, end = end, thin = thin))
  coefs <- get_coef_names(object$Mlist, object$K)
  colnames(MCMC)[match(coefs[, 1], colnames(MCMC))] <- coefs[, 2]

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, object)
  }

  res1 <- mcmcse::mcse.mat(x = MCMC, ...)

  scale_pars <- object$scale_pars
  if (!is.null(scale_pars)) {
    # re-scale parameters
    MCMC <- sapply(colnames(MCMC), rescale, object$Mlist$fixed2, scale_pars,
                   MCMC, object$Mlist$refs, object$Mlist$X2_names)
  }

  res2 <- mcmcse::mcse.mat(x = MCMC, ...)

  summary_obj <- summary(object)
  res1 <- cbind(res1,
                SD = summary_obj$stats[match(row.names(summary_obj$stats),
                                             row.names(res1)), "SD"]
  )
  res1 <- cbind(res1,
                'se/SD' = res1[, "se"]/res1[, "SD"])
  res2 <- cbind(res2,
                SD = summary_obj$stats[match(row.names(summary_obj$stats),
                                             row.names(res1)), "SD"]
  )
  res2 <- cbind(res2,
                'se/SD' = res2[, "se"]/res2[, "SD"])

  return(list(unscaled = res1, scaled = res2))
}

