#' Summary of an object of class JointAI
#' @inheritParams base::print
#' @param quantiles posterior quantiles
#' @inheritParams sharedParams
#' @param \dots currently not used
#'
#' @examples
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' summary(mod1)
#'
#'
#' @seealso The model fitting functions \code{\link{lm_imp}},
#'          \code{\link{glm_imp}}, \code{\link{lme_imp}}
#'
#' @export
summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                            quantiles = c(0.025, 0.975), subset = "main", ...) {

  if (is.null(object$sample))
    stop("There is no mcmc sample.")


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
                  window(object$MCMC,
                         start = start,
                         end = end,
                         thin = thin))

  # coefs <- get_coef_names(object$Mlist, object$K)
  #
  # colnames(MCMC)[match(coefs[, 1], colnames(MCMC))] <- coefs[, 2]
  #
  # scale_pars <- object$scale_pars
  # if (!is.null(scale_pars)) {
  #   # re-scale parameters
  #   MCMC <- sapply(colnames(MCMC), rescale, object$Mlist$fixed2, scale_pars,
  #                  MCMC, object$Mlist$refs, object$Mlist$X2_names)
  # }

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, object)
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

  out$ranefvar <- if (object$analysis_type == "lme")
    stats[grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", rownames(stats), value = TRUE), -5, drop = FALSE]
  out$sigma <- if (attr(object$analysis_type, "family") == "gaussian")
    stats[grep(paste0("sigma_", names(object$Mlist$y)), rownames(stats), value = TRUE), -5, drop = FALSE]
  out$stats <- stats[!rownames(stats) %in% c(rownames(out$ranefvar), rownames(out$sigma)), ]

  out$analysis_type <- object$analysis_type
  out$size <- nrow(object$data)
  out$groups <- length(unique(object$Mlist$groups))

  class(out) <- "summary.JointAI"
  return(out)
}


print_type <- function(x) {
  a <- switch(x,
              lm = "Linear model",
              glm = "Generalized linear model",
              lme = "Linear mixed model")
  paste0(a, " fitted with JointAI")
}

#' @rdname summary.JointAI
#' @param x an object of class \code{summary.JointAI}
#' @export
print.summary.JointAI <- function(x, digits = max(3, .Options$digits - 3), ...) {
  if (!inherits(x, "summary.JointAI"))
    stop("Use only with 'summary.JointAI' objects.\n")

  cat("\n", print_type(x$analysis_type), "\n")
  cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n\n", sep = "")
  cat("Posterior summary:\n")
  print(x$stats, digits = digits)
  if (x$analysis_type == "lme") {
    cat("\n")
    cat("Posterior summary of random effects covariance matrix:\n")
    print(x$ranefvar, digits = digits)
  }
  if (attr(x$analysis_type, "family") %in% c("gaussian", "Gamma")) {
    cat("\n")
    cat("Posterior summary of residual std. deviation:\n")
    print(x$sigma, digits = digits)
  }
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
  cat("Number of observations:", x$size, "\n")
  if (x$analysis_type == "lme")
    cat("Number of groups:", x$groups)
  invisible(x)
}
