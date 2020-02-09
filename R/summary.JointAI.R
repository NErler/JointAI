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
#' mod1 <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
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
                            exclude_chains = NULL,
                            warn = TRUE, mess = TRUE, ...) {

  if (is.null(object$MCMC))
    stop("There is no MCMC sample.")

  cl <- as.list(match.call())[-1]
  autoburnin <- if (is.null(cl$autoburnin)) FALSE else eval(cl$autoburnin)

  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                    subset = subset, exclude_chains = exclude_chains,
                    warn = warn, mess = mess, ...)

  # create results matrices
  statnames <- c("Mean", "SD", paste0(quantiles * 100, "%"), "tail-prob.", "GR-crit")

  res_list <- sapply(names(object$coef_list), function(varname) {
    MCMCsub <- MCMC[, intersect(colnames(MCMC),
                                c(object$coef_list[[varname]]$coef,
                                  grep(paste0('_', object$info_list[[varname]]$varname, '\\b'),
                                       colnames(MCMC), value = TRUE)))]



    if (ncol(MCMCsub) > 0) {

      grcrit <- if (length(object$MCMC) - length(exclude_chains) > 1) {
        GR_crit(object = object, start = start, end = end, thin = thin,
                warn = warn, mess = FALSE, multivariate = FALSE,
                exclude_chains = exclude_chains,
                subset = list(other = colnames(MCMCsub)),
                autoburnin = autoburnin)[[1]][, "Upper C.I."]
      }

      colnames(MCMCsub)[na.omit(match(object$coef_list[[varname]]$coef,
                                      colnames(MCMCsub)))] <-
        object$coef_list[[varname]]$varname

      stats <- matrix(nrow = length(colnames(MCMCsub)),
                      ncol = length(statnames),
                      dimnames = list(colnames(MCMCsub), statnames))

      stats[, "Mean"] <- apply(MCMCsub, 2, mean)
      stats[, "SD"] <- apply(MCMCsub, 2, sd)
      stats[, paste0(quantiles * 100, "%")] <- t(apply(MCMCsub, 2, quantile, quantiles))
      stats[, "tail-prob."] <- apply(MCMCsub, 2, computeP)

      if (length(object$MCMC) - length(exclude_chains) > 1)
        stats[, "GR-crit"] <- grcrit


      regcoef <- stats[object$coef_list[[varname]]$varname, ]

      sigma <- if (object$info_list[[varname]]$family %in% c('gaussian', 'Gamma') &&
                   !is.null(object$info_list[[varname]]$family))
        stats[grep(paste0("sigma_", varname), rownames(stats)),
              -which(colnames(stats) == 'tail-prob.'), drop = FALSE]


      intercepts <- if (object$info_list[[varname]]$modeltype %in% c('clm', 'clmm'))
        get_intercepts(stats, varname, levels(object$Mlist$refs[[varname]]))


      rd_vcov <- if (object$info_list[[varname]]$modeltype %in%
                     c("glmm", "clmm", "mlogitmm")) {
        Ds <- stats[grep(paste0("^D_", varname, "\\[[[:digit:]]+,[[:digit:]]+\\]"),
                         rownames(stats), value = TRUE), , drop = FALSE]
        if (nrow(Ds) > 0) {

          Ddiag <- sapply(strsplit(sub("\\]", '',
                                       sub("^[[:print:]]*\\[", '', rownames(Ds))
          ), ","),
          function(i) length(unique(i)) == 1)

          Ds[Ddiag, 'tail-prob.'] <- NA
          Ds
        }
      }

      assoc_type <- if (object$info_list[[varname]]$modeltype %in% "JM") {
        object$info_list[[which(sapply(object$info_list,
                                       "[[", "modeltype") == "JM")]]$assoc_type
      }

      wb_shape <- if (object$info_list[[varname]]$modeltype %in% c('survreg')) {
        stats[c(paste0("shape_", object$info_list[[varname]]$varname)),
              -which(colnames(stats) == 'tail-prob.'), drop = FALSE]
      }

      list(modeltype = object$info_list[[varname]]$modeltype,
           regcoef = regcoef, sigma = sigma, intercepts = intercepts,
           rd_vcov = rd_vcov, wb_shape = wb_shape, assoc_type = assoc_type,
           grcrit = grcrit)
    }
  }, simplify = FALSE)


  out <- list()
  out$call <- object$call
  out$start <- ifelse(is.null(start), start(object$MCMC), max(start, start(object$MCMC)))
  out$end <- ifelse(is.null(end), end(object$MCMC), min(end, end(object$MCMC)))
  out$thin <- thin(object$MCMC)
  out$nchain <- nchain(object$MCMC) - sum(exclude_chains %in% seq_along(object$MCMC))
  out$res <- res_list


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

  cat("\n")
  cat(print_type(x$analysis_type), 'fitted with JointAI', "\n")
  cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n", sep = "")

  for (k in seq_along(x$res)) {
    if (!is.null(x$res[[k]])) {
      cat("\n\n")
      if (sum(!sapply(x$res, is.null)) > 1)
      cat(paste0(
        '# ', paste0(c(rep('-', 59)), collapse = ''), ' #\n',
        '  ', print_type(x$res[[k]]$modeltype), ' for ', dQuote(names(x$res)[k]), '\n',
        '# ', paste0(c(rep('-', 30)), collapse = ' '), ' #\n\n'
      ))


      if (!is.null(x$res[[k]]$regcoef)) {
        cat("Posterior summary:\n")
        print(x$res[[k]]$regcoef, digits = digits)
      }

      if (!is.null(x$res[[k]]$intercepts)) {
        cat("\nPosterior summary of the intercepts:\n")
        print(x$res[[k]]$intercepts, digits = digits)
      }

      if (!is.null(x$res[[k]]$rd_vcov)) {
        cat("\nPosterior summary of random effects covariance matrix:\n")
        print(x$res[[k]]$rd_vcov, digits = digits, na.print = "")
      }

      if (!is.null(x$res[[k]]$sigma)) {
        cat("\nPosterior summary of residual std. deviation:\n")
        print(x$res[[k]]$sigma, digits = digits)
      }

      if (!is.null(x$res[[k]]$wb_shape)) {
        cat("\nPosterior summary of the shape of the Weibull distribution:\n")
        print(x$res[[k]]$wb_shape, digits = digits)
      }

      if (!is.null(x$res[[k]]$assoc_type)) {
        cat("\nAssociation types:\n")
        cat(paste0(names(x$res[[k]]$assoc_type), ": ",
               sapply(x$res[[k]]$assoc_type, function(i)
                 switch(i,
                      'underl.value' = "underlying value",
                      'obs.value' = 'observed value')
               ), collapse = "\n"))

      }
    }
  }

  cat('\n\n')
  if (sum(!sapply(x$res, is.null)) > 1)
    cat('#', paste0(c(rep('-', 59)), collapse = ''), '#\n\n')

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
                         subset = NULL, exclude_chains = NULL,
                         warn = TRUE, mess = TRUE, ...) {

  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(object$MCMC)) {
    stop("There is no MCMC sample.\n")
  }

  MCMC <- prep_MCMC(object, start, end, thin, subset, exclude_chains = exclude_chains,
                    mess = mess, warn = warn)


  coefs <- sapply(names(object$fixed), function(k) {
    x <- object$coef_list[[k]]

    c(
      if (object$info_list[[k]]$modeltype %in% c('clm', 'clmm')) {
        interc <- colMeans(MCMC)[grep(paste0('gamma_', k, "\\["), colnames(MCMC))]

        lvl <- levels(object$Mlist$refs[[k]])
        names(interc) <- paste(k, "\u2264", lvl[-length(lvl)])
      },
      if (length(intersect(colnames(MCMC), x$coef)))
        setNames(colMeans(MCMC[, intersect(colnames(MCMC), x$coef), drop = FALSE]),
                 x$varname[match(x$coef, intersect(colnames(MCMC), x$coef))]
        )
    )
  }, simplify = FALSE)

  return(coefs)
}

#' @export
coef.summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                         subset = NULL, exclude_chains = NULL,
                         warn = TRUE, mess = TRUE, ...) {
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
                            subset = NULL, exclude_chains = NULL,
                            warn = TRUE, mess = TRUE, ...) {
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

  MCMC <- prep_MCMC(object, start, end, thin, subset, exclude_chains = exclude_chains,
                    mess = mess, warn = warn)

  cis <- t(apply(MCMC, 2, quantile, quantiles))

  return(cis)
}


#' @rdname summary.JointAI
#' @export
print.JointAI <- function(x, digits = max(4, getOption("digits") - 4), ...) {
  if (!inherits(x, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")


  MCMC <- if (!is.null(x$MCMC))
    prep_MCMC(x, start = NULL, end = NULL, thin = NULL, subset = NULL,
              exclude_chains = NULL,
              mess = TRUE, warn = TRUE, ...)


  cat("\nCall:\n")
  print(x$call)

  if (!is.null(MCMC)) {
    coefs <- coef(x)

    for (k in seq_along(coefs)) {
      varname <- names(coefs)[k]
      cat("\n",
          print_type(x$info_list[[varname]]$modeltype), "for", dQuote(varname), '\n')
      if (x$info_list[[names(coefs)[k]]]$modeltype %in% c('glmm', 'clmm', 'mlogitmm')) {
        cat("\nFixed effects:\n")
        print(coefs[[k]], digits = digits)

        cat("\n\nRandom effects covariance matrix:\n")
        print(get_Dmat(x, varname = varname), digits = digits)

      } else {
        if (length(coefs[[k]] > 0)) {
          cat("\n\nCoefficients:\n")
          print(coefs[[k]], digits = digits)
        }
      }

      if (paste0("sigma_", varname) %in% colnames(MCMC)) {
        cat("\n\nResidual standard deviation:\n")
        print(colMeans(MCMC[, paste0("sigma_", names(coefs)[k]), drop = FALSE]),
              digits = digits)
      }
    }
  } else {
    cat("\n(The object does not contain an MCMC sample.)")
  }

  invisible(x)
}
