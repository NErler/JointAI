#' Gelman-Rubin criterion for convergence
#' @param object JointAI object
#' @inheritParams coda::gelman.diag
#' @export
gr_crit <- function(object, confidence = 0.95, transform = FALSE, autoburnin = TRUE,
                    multivariate = TRUE, subset = "main", start = NULL, end = NULL,
                    thin = NULL) {

  if (!inherits(object, "JointAI"))
    error("Object must be of class JointAI.")

  if (is.null(object$sample))
    error("No mcmc sample.")


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
#' @param ... parameters passed to \code{\link[mcmcse]{mcmc.mat}}
#' @export
MC_error <- function(object, subset = "main", start = NULL, end = NULL, thin = NULL, ...) {

  if (!inherits(object, "JointAI"))
    error("Object must be of class JointAI.")

  if (is.null(object$sample))
    error("No mcmc sample.")

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
                   MCMC, object$Mlist$refs)
  }

  res2 <- mcmcse::mcse.mat(x = MCMC, ...)
  return(list(unscaled = res1, scaled = res2))
}

