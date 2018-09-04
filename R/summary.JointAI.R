#' Summary of an object of class JointAI
#'
#' \code{summary} method for class "JointAI".
#' @inheritParams base::print
#' @param quantiles posterior quantiles
#' @inheritParams sharedParams
#' @param \dots currently not used
#'
#' @examples
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' summary(mod1)
#'
#'
#' @seealso The model fitting functions \code{\link{lm_imp}},
#'          \code{\link{glm_imp}}, \code{\link{lme_imp}} and the
#'          vignette \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#'           for examples how to specify the parameter \code{subset}.
#'
#' @export
summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                            quantiles = c(0.025, 0.975), subset = NULL,
                            warn = TRUE, mess = TRUE, ...) {

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

  MCMC <- get_subset(object, subset, as.list(match.call()), warn = warn)

  MCMC <- do.call(rbind,
                  window(MCMC,
                         start = start,
                         end = end,
                         thin = thin))


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

  out$ranefvar <- if (object$analysis_type == "lme") {
    Ds <- stats[grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]",
                     rownames(stats), value = TRUE), , drop = FALSE]
    Ddiag <- sapply(regmatches(rownames(Ds), gregexpr('[[:digit:]]*', rownames(Ds))),
                    function(k) {
                      length(unique(grep('[[:digit:]]+', k, value = T))) == 1
                    })
    Ds[Ddiag, 'tail-prob.'] <- NA
    Ds
  }
  out$sigma <- if (attr(object$analysis_type, "family") == "gaussian" &
                   any(grepl(paste0("sigma_", names(object$Mlist$y)), rownames(stats))))
    stats[grep(paste0("sigma_", names(object$Mlist$y)), rownames(stats), value = TRUE),
          -which(colnames(stats) == 'tail-prob.'), drop = FALSE]
  out$stats <- stats[!rownames(stats) %in% c(rownames(out$ranefvar),
                                             get_aux(object),
                                             rownames(out$sigma),
                                             paste0("tau_", names(object$Mlist$y))), , drop = FALSE]

  out$analysis_type <- object$analysis_type
  out$size <- nrow(object$data)
  out$groups <- length(unique(object$Mlist$groups))

  class(out) <- "summary.JointAI"
  return(out)
}

get_aux <- function(object) {
  aux <- object$Mlist$auxvars
  unlist(sapply(aux, function(x)
    if (x %in% names(object$Mlist$refs))
      attr(object$Mlist$refs[[x]], 'dummies')
    else x
  ))
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
    x$ranefvar <- as.data.frame(x$ranefvar)
    x$ranefvar[is.na(x$ranefvar[, 'tail-prob.']), 'tail-prob.'] <- ''
    print(x$ranefvar, digits = digits)
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
  if (x$analysis_type == "lme")
    cat("Number of groups:", x$groups)
  invisible(x)
}
