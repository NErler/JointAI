#' Summary of an JointAI object
#' @param object an object of class JointAIObject
#' @param start the first iteration of interest (see \code{\link[coda]{window.mcmc}})
#' @param end the last iteration of interest (see \code{\link[coda]{window.mcmc}})
#' @param thin thinning interval (see \code{\link[coda]{window.mcmc}})
#' @inheritParams coda::window.mcmc
#' @inheritParams base::print
#' @param quantiles posterior quantiles
#' @param subset subset of monitored parameters (columns in the MCMC sample).
#'               Can be specified as a numeric vector of columns, a vector of
#'               column names, as \code{subset = "main"} or \code{NULL}.
#'               If \code{NULL}, all monitored nodes will be plotted.
#'               \code{subset = "main"} (default) the main parameters of the
#'               analysis model will be plotted (regression coefficients/fixed
#'               effects, and, if available, standard deviation of the residual
#'               and random effects covariance matrix).
#' @export
summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                            quantiles = c(0.025, 0.975), subset = "main",
                            ...) {

  if (is.null(object$sample))
    stop("No mcmc sample.")


  if (is.null(start)) {
    start <- start(object$sample)
  } else {
    start <- max(start, start(object$sample))
  }

  if (is.null(end)) {
    end <- end(object$sample)
  } else {
    end <- min(end, end(object$sample))
  }

  if (is.null(thin))
    thin <- thin(object$sample)

  MCMC <- do.call(rbind,
                  window(object$sample,
                         start = start,
                         end = end,
                         thin = thin))

  # hc_list <- object$Mlist$hc_list

  coefs <- get_coef_names(object$Mlist, object$K)

  colnames(MCMC)[match(coefs[, 1], colnames(MCMC))] <- coefs[, 2]

  scale_pars <- object$scale_pars
  if (!is.null(scale_pars)) {
    # re-scale parameters
    MCMC <- sapply(colnames(MCMC), rescale, object$Mlist$fixed2, scale_pars,
                   MCMC, object$Mlist$refs, object$Mlist$X2_names)
  }

  #   scale_pars <- cbind(scale_pars,
  #                       sapply(colnames(MCMC)[!colnames(MCMC) %in%
  #                                               colnames(scale_pars)],
  #                              function(x) scale_pars[, x] <- c(0,1)
  #                       )
  #   )

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, object)
    # if (any(subset == "main")) {
    #   subset <- coefs[, 2]
    #   if (object$analysis_type == "lm" |
    #       (object$analysis_type == "glm" &
    #        attr(object$analysis_type, "family") %in% c("Gamma", "gaussian"))) {
    #     subset <- c(subset, paste0("sigma_", names(object$Mlist$y)))
    #   }
    #   if (object$analysis_type == "lme") {
    #     subset <- c(subset,
    #                 paste0("sigma_", names(object$Mlist$y)),
    #                 grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = T))
    #   }
    # }
    # MCMC <- MCMC[, subset]
  }



  # create results matrix
  statnames <- c("Mean", "SD", paste0(quantiles * 100, "%"), "tail-prob.")
  stats <- matrix(nrow = length(colnames(MCMC)),
                  ncol = length(statnames),
                  dimnames = list(colnames(MCMC), statnames))

  stats[, "Mean"] <- apply(MCMC, 2, mean)
  stats[,  "SD"] <- apply(MCMC, 2, sd)
  stats[, -c(1,2, ncol(stats))] <- t(apply(MCMC, 2, quantile, quantiles))
  stats[, ncol(stats)] <- apply(MCMC, 2, computeP)

  out <- list()
  out$call <- object$call
  out$start <- start
  out$end <- end
  out$thin <- thin
  out$nchain <- nchain(object$sample)
  out$stats <- stats

  class(out) <- "summary.JointAI"
  return(out)
}


#' @rdname summary.JointAI
#' @export
print.summary.JointAI <- function(x, digits = max(3, .Options$digits - 3), ...) {
  if (!inherits(x, "summary.JointAI"))
    stop("Use only with 'summary.JointAI' objects.\n")

  cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n\n", sep = "")
  cat("Posterior summary:\n")
  print(x$stats, digits = digits)
  cat("\n\n")
  cat("MCMC settings:\n")
  cat("Iterations = ", x$start, ":", x$end, "\n", sep = "")
  cat("Sample size per chain =", (x$end - x$start)/x$thin +
        1, "\n")
  cat("Thinning interval =", x$thin, "\n")
  cat("Number of chains =", x$nchain, "\n")
  # cat("\n1. Empirical mean and standard deviation for each variable,")
  # cat("\n   plus standard error of the mean:\n\n")
  cat("\n")
  invisible(x)
}
