#' Summary of an object of class JointAI
#'
#' Obtain and print the \code{summary}, (fixed effects) coefficients (\code{coef})
#' and credible interval (\code{confint}) for an object of class 'JointAI'.
#'
#' @inheritParams base::print
#' @param quantiles posterior quantiles
#' @inheritParams sharedParams
#' @param \dots currently not used
#'
#' @examples
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' summary(mod1)
#' coef(mod1)
#' confint(mod1)
#'
#'
#' @seealso The model fitting functions \code{\link{lm_imp}},
#'          \code{\link{glm_imp}}, \code{\link{clm_imp}}, \code{\link{lme_imp}},
#'          \code{\link{glme_imp}}, \code{\link{survreg_imp}} and \code{\link{coxph_imp}},
#'          and the vignette
#'          \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#'          for examples how to specify the parameter \code{subset}.
#'
#' @export
summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                            quantiles = c(0.025, 0.975), subset = NULL,
                            warn = TRUE, mess = TRUE, ...) {

  if (is.null(object$MCMC))
    stop("There is no MCMC sample.")

  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin, subset = subset, warn = warn, ...)

  # create results matrix
  statnames <- c("Mean", "SD", paste0(quantiles * 100, "%"), "tail-prob.", "GR-crit")
  stats <- matrix(nrow = length(colnames(MCMC)),
                  ncol = length(statnames),
                  dimnames = list(colnames(MCMC), statnames))

  stats[, "Mean"] <- apply(MCMC, 2, mean)
  stats[, "SD"] <- apply(MCMC, 2, sd)
  stats[, paste0(quantiles * 100, "%")] <- t(apply(MCMC, 2, quantile, quantiles))
  stats[, "tail-prob."] <- apply(MCMC, 2, computeP)
  stats[, "GR-crit"] <- GR_crit(object = object, start = start, end = end, thin = thin,
                                warn = warn, subset = subset, ...)[[1]][, "Upper C.I."]

  out <- list()
  out$call <- object$call
  out$start <- ifelse(is.null(start), start(object$MCMC), max(start, start(object$MCMC)))
  out$end <- ifelse(is.null(end), end(object$MCMC), max(end, end(object$MCMC)))
  out$thin <- thin(object$MCMC)
  out$nchain <- nchain(object$MCMC)
  out$stats <- stats

  out$ranefvar <- if (object$analysis_type %in% c("lme", "glme", "clmm")) {
    Ds <- stats[grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]",
                     rownames(stats), value = TRUE), , drop = FALSE]
    if (nrow(Ds) > 0) {
      Ddiag <- sapply(regmatches(rownames(Ds), gregexpr('[[:digit:]]*', rownames(Ds))),
                      function(k) {
                        length(unique(grep('[[:digit:]]+', k, value = T))) == 1
                      })
      Ds[Ddiag, 'tail-prob.'] <- NA
    Ds
    }
  }
  out$sigma <- if (attr(object$analysis_type, "family") == "gaussian" &
                   any(grepl(paste0("sigma_", names(object$Mlist$y)), rownames(stats))))
    stats[grep(paste0("sigma_", names(object$Mlist$y)), rownames(stats), value = TRUE),
          -which(colnames(stats) == 'tail-prob.'), drop = FALSE]

  if (object$analysis_type %in% c('clm', 'clmm')) {
    out$intercepts <- get_intercepts(stats, colnames(object$Mlist$y))
    out$yname <- colnames(object$Mlist$y)
    out$ylvl <- levels(object$data[, colnames(object$Mlist$y)])
  } else {
    out$intercepts <- NULL
  }

  out$main <- stats[!rownames(stats) %in% c(rownames(out$ranefvar),
                                            rownames(out$intercepts),
                                            get_aux(object),
                                            rownames(out$sigma),
                                            paste0("tau_", names(object$Mlist$y))), , drop = FALSE]

  out$analysis_type <- object$analysis_type
  out$size <- nrow(object$data)
  out$groups <- length(unique(object$Mlist$groups))

  class(out) <- "summary.JointAI"
  return(out)
}


#' @rdname summary.JointAI
#' @param x an object of class \code{summary.JointAI} or \code{JointAI}
#' @export
print.summary.JointAI <- function(x, digits = max(3, .Options$digits - 4), ...) {
  if (!inherits(x, "summary.JointAI"))
    stop("Use only with 'summary.JointAI' objects.\n")

  cat("\n", print_type(x$analysis_type), "\n")
  cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n\n", sep = "")
  if (nrow(x$main > 0)) {
    cat("Posterior summary:\n")
    print(x$main, digits = digits)
  }

  if (!is.null(x$intercepts)) {
    cat("\n")
    cat("Posterior summary of the intercepts:\n")
    print(print_intercepts(x$intercepts, x$ynam, x$ylvl), digits = digits)
  }

  if (x$analysis_type %in% c("lme", "glme", "clmm") & !is.null(x$ranefvar)) {
    cat("\n")
    cat("Posterior summary of random effects covariance matrix:\n")
    print(x$ranefvar, digits = digits, na.print = "")
  }
  if (!is.null(x$sigma)) {
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
  cat("\n")
  cat("Number of observations:", x$size, "\n")
  if (x$analysis_type %in% c("lme", "glme"))
    cat("Number of groups:", x$groups)
  invisible(x)
}



#' @rdname summary.JointAI
#' @export
coef.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                         subset = NULL, warn = TRUE, mess = TRUE, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(object$MCMC)) {
    stop("There is no MCMC sample.\n")
  }

  MCMC <- prep_MCMC(object, start, end, thin, subset)

  coefs <- colMeans(MCMC)[intersect(colnames(MCMC),
                                    get_coef_names(object$Mlist, object$K)[, 2])]

  if (object$analysis_type %in% c('clm', 'clmm')) {
    interc <- colMeans(MCMC)[grep(paste0('gamma_', colnames(object$Mlist$y), "\\["),
                                  colnames(MCMC))]

    lvl <- levels(object$data[, colnames(object$Mlist$y)])
    names(interc) <- paste(colnames(object$Mlist$y), "\u2264",
                                    lvl[-length(lvl)])

    coefs <- c(interc, coefs)
  }

  return(coefs)
}

#' @export
coef.summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                         subset = NULL, warn = TRUE, mess = TRUE, ...) {
  if (!inherits(object, "summary.JointAI"))
    stop("Use only with 'summary.JointAI' objects.\n")

  return(object$stats)
}



#' @rdname summary.JointAI
#' @param parm same as \code{subset}
#' @param level confidence level (default is 0.95)
#' @export
confint.JointAI <- function(object, parm = NULL, level = 0.95,
                            quantiles = NULL,
                            start = NULL, end = NULL, thin = NULL,
                         subset = NULL, warn = TRUE, mess = TRUE, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(object$MCMC)) {
    stop("There is no MCMC sample.\n")
  }

  if (is.null(subset) & !is.null(parm))
    subset <- parm

  if (!is.null(subset) & !is.null(parm))
    stop('At least one of "parm" and "subset" should be NULL.')

  if (is.null(quantiles) & !is.null(level))
    quantiles <- c((1 - level)/2, 1 - (1 - level)/2)

  MCMC <- prep_MCMC(object, start, end, thin, subset)

  cis <- t(apply(MCMC, 2, quantile, quantiles))

  return(cis)
}


#' @rdname summary.JointAI
#' @export
print.JointAI <- function(x, digits = max(4, getOption("digits") - 4), ...) {
  if (!inherits(x, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")


  MCMC <- if (!is.null(x$MCMC))
    prep_MCMC(x, start = NULL, end = NULL, thin = NULL, subset = NULL)


  cat("\nCall:\n")
  print(x$call)

  if (!is.null(MCMC)) {
    if (x$analysis_type != "lme")
      cat("\n\nCoefficients:\n")
    else
      cat("\n\nFixed effects:\n")
    print(coef(x), digits = digits)

    if (x$analysis_type == 'lme') {
      cat("\n\nRandom effects covariance matrix:\n")
      print(get_Dmat(x), digits = digits)
    }

    if (paste0("sigma_", names(x$Mlist$y)) %in% colnames(MCMC)) {
      cat("\n\nResidual standard deviation:\n")
      print(colMeans(MCMC[, paste0("sigma_", names(x$Mlist$y)), drop = FALSE]),
            digits = digits)
    }
  } else {
    cat("\n(The object does not contain an MCMC sample.)")
  }

  invisible(x)
}


