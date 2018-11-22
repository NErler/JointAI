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
    stop("There is no MCMC sample.")


  # if (is.null(start)) {
  #   start <- start(object$sample)
  # } else {
  #   start <- max(start, start(object$sample))
  # }
  #
  # if (is.null(end)) {
  #   end <- end(object$sample)
  # } else {
  #   end <- min(end, end(object$sample))
  # }
  #
  # if (is.null(thin))
  #   thin <- thin(object$sample)
  #
  # MCMC <- get_subset(object, subset, as.list(match.call()), warn = warn)
  #
  # MCMC <- do.call(rbind,
  #                 window(MCMC,
  #                        start = start,
  #                        end = end,
  #                        thin = thin))


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
  out$start <- ifelse(is.null(start), start(object$sample), max(start, start(object$sample)))
  out$end <- ifelse(is.null(end), end(object$sample), max(end, end(object$sample)))
  out$thin <- thin(object$sample)
  out$nchain <- nchain(object$sample)
  out$stats <- stats

  out$ranefvar <- if (object$analysis_type %in% c("lme", "glme")) {
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
  out$main <- stats[!rownames(stats) %in% c(rownames(out$ranefvar),
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
              lme = "Linear mixed model",
              glme = 'Generalized linear mixed model',
              coxph = 'Cox proportional hazards model',
              survreg = 'Weibul survival model')
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
  if (nrow(x$main > 0)) {
    cat("Posterior summary:\n")
    print(x$main, digits = digits)
  }
  if (x$analysis_type %in% c("lme", "glme") & !is.null(x$ranefvar)) {
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
  if (x$analysis_type %in% c("lme", "glme"))
    cat("Number of groups:", x$groups)
  invisible(x)
}



#' @export
coef.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                         subset = NULL, warn = TRUE, mess = TRUE, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(object$sample)) {
    stop("There is no MCMC sample.\n")
  }

  MCMC <- prep_MCMC(object, start, end, thin, subset)

  coefs <- colMeans(MCMC)[intersect(colnames(MCMC),
                                    get_coef_names(object$Mlist, object$K)[, 2])]

  return(coefs)
}



#' @export
print.JointAI <- function(x, digits = max(4, getOption("digits") - 4), ...) {
  if (!inherits(x, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")


  MCMC <- if (!is.null(x$sample))
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



prep_MCMC <- function(object, start = NULL, end = NULL, thin = NULL, subset = NULL, warn = warn, ...) {

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

  return(MCMC)
}


get_Dmat <- function(x) {
  MCMC <- prep_MCMC(x, start = NULL, end = NULL, thin = NULL, subset = NULL)

  Ds <- grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = TRUE)
  Dpos <- t(sapply(strsplit(gsub('D|\\[|\\]', '', Ds), ","), as.numeric))

  term <- terms(remove_grouping(x$random))

  dimnam <- c(if (attr(term, 'intercept') == 1) "(Intercept)",
              attr(term, 'term.labels'))

  Dmat <- matrix(nrow = length(dimnam), ncol = length(dimnam),
                 dimnames = list(dimnam, dimnam))
  for (k in seq_along(Ds)) {
    Dmat[Dpos[k, 1], Dpos[k, 2]] <- mean(MCMC[, Ds[k]])
  }

  Dmat
}
