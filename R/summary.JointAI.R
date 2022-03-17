#' Summarize the results from an object of class JointAI
#'
#' Obtain and print the \code{summary}, (fixed effects) coefficients
#' (\code{coef}) and credible interval (\code{confint}) for an object of
#' class 'JointAI'.
#'
#' @param digits the minimum number of significant digits to be printed in
#'               values.
#' @param quantiles posterior quantiles
#' @inheritParams sharedParams
#' @param outcome optional; vector identifying for which outcomes the summary
#'                should be given, either by specifying their indices, or their
#'                names (LHS of the respective model formulas as character
#'                string).
#' @param missinfo logical; should information on the number and proportion of
#'                 missing values be included in the summary?
#' @param \dots currently not used
#'
#' @examples
#'
#' \dontrun{
#' mod1 <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' summary(mod1, missinfo = TRUE)
#' coef(mod1)
#' confint(mod1)
#' }
#'
#' @seealso The model fitting functions \code{\link{lm_imp}},
#'          \code{\link{glm_imp}}, \code{\link{clm_imp}}, \code{\link{lme_imp}},
#'          \code{\link{glme_imp}}, \code{\link{survreg_imp}} and
#'          \code{\link{coxph_imp}},
#'          and the vignette
#'          \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#'          for examples how to specify the parameter \code{subset}.
#'
#' @export
summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                            quantiles = c(0.025, 0.975), subset = NULL,
                            exclude_chains = NULL, outcome = NULL,
                            missinfo = FALSE,
                            warn = TRUE, mess = TRUE, ...) {

  if (is.null(object$MCMC)) errormsg("There is no MCMC sample.")

  cl <- as.list(match.call())[-1]
  autoburnin <- if (is.null(cl$autoburnin)) FALSE else eval(cl$autoburnin)

  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                    subset = subset, exclude_chains = exclude_chains,
                    warn = warn, mess = mess, ...)

  # create results matrices
  statnames <- c("Mean", "SD", paste0(quantiles * 100, "%"), "tail-prob.",
                 "GR-crit", "MCE/SD")

  vars <- if (is.null(outcome)) {
    names(object$coef_list)
  } else {
    names(object$fixed[outcome])
  }
  res_list <- sapply(vars, function(varname) {

    rdnam <- nlapply(names(object$info_list[[varname]]$rd_vcov),
              function(lvl) {
                if (isTRUE(object$info_list[[varname]]$rd_vcov[[lvl]] ==
                           "full")) {
                  paste0("^", c("b", "D", "invD", "RinvD", "KinvD"),
                         attr(object$info_list[[varname]]$rd_vcov[[lvl]],
                              "name"),
                         "_", lvl, "\\b")
                }
              })


    MCMCsub <- MCMC[, intersect(
      colnames(MCMC),
      c(
        object$coef_list[[varname]]$coef,
        grep(paste0("_", object$info_list[[varname]]$varname, "\\b"),
             colnames(MCMC),
             value = TRUE
        ),
        grep(paste0("_", object$info_list[[varname]]$varname, "_"),
             colnames(MCMC),
             value = TRUE
        ),
        unlist(lapply(unlist(rdnam), grep, colnames(MCMC), value = TRUE))
      )
    ), drop = FALSE]



    if (ncol(MCMCsub) > 0) {

      grcrit <- if (length(object$MCMC) - length(exclude_chains) > 1) {
        GR_crit(object = object, start = start, end = end, thin = thin,
                warn = warn, mess = FALSE, multivariate = FALSE,
                exclude_chains = exclude_chains,
                subset = list(other = colnames(MCMCsub), analysis_main = FALSE),
                autoburnin = autoburnin)[[1]][, "Upper C.I."]
      }

      mcerror <- if (length(object$MCMC) - length(exclude_chains) > 1) {
        try(MC_error(object,
                     subset = list(other = colnames(MCMCsub),
                                   analysis_main = FALSE),
                     exclude_chains = exclude_chains,
                     start = start, end = end, thin = thin,
                     digits = 2, warn = FALSE, mess = FALSE))
      }

      colnames(MCMCsub)[na.omit(match(object$coef_list[[varname]]$coef,
                                      colnames(MCMCsub)))] <-
        object$coef_list[[varname]]$varnam_print

      stats <- matrix(nrow = length(colnames(MCMCsub)),
                      ncol = length(statnames),
                      dimnames = list(colnames(MCMCsub), statnames))

      stats[, "Mean"] <- apply(MCMCsub, 2, mean)
      stats[, "SD"] <- apply(MCMCsub, 2, sd)
      stats[, paste0(quantiles * 100, "%")] <- t(apply(MCMCsub, 2,
                                                       quantile, quantiles))
      stats[, "tail-prob."] <- apply(MCMCsub, 2, computeP)

      if (length(object$MCMC) - length(exclude_chains) > 1)
        stats[, "GR-crit"] <- grcrit

      if (length(object$MCMC) - length(exclude_chains) > 1) {
        if (!inherits(mcerror, "try-error"))
          stats[, "MCE/SD"] <- mcerror$data_scale[, "MCSE/SD"]
      }

      regcoef <- stats[intersect(rownames(stats),
                                 object$coef_list[[varname]]$varnam_print), ,
                       drop = FALSE]


      sigma <- if (object$info_list[[varname]]$family %in%
                   c("gaussian", "Gamma", "lognorm") &&
                   !is.null(object$info_list[[varname]]$family)) {
        sig <- grep(paste0("sigma_", varname), rownames(stats))

        if (length(sig) > 0) {
          stats[sig, -which(colnames(stats) == "tail-prob."), drop = FALSE]
        }
      }

      intercepts <- if (object$info_list[[varname]]$modeltype %in%
                        c("clm", "clmm"))
        get_intercepts(stats, varname, levels(object$Mlist$refs[[varname]]),
                       rev = object$info_list[[varname]]$rev)


      rd_vcov <- if (!is.null(object$info_list[[varname]]$hc_list)) {
        Dpat <- nlapply(object$Mlist$idvar, function(lvl) {
          if (isTRUE(object$info_list[[varname]]$nranef[lvl] > 0L)) {
            if (isTRUE(object$info_list[[varname]]$rd_vcov[[lvl]] == "full")) {
              paste0("^D[[:digit:]]*_", lvl, "\\[[[:digit:]]+,[[:digit:]]+\\]")
            } else {
              paste0("^D_", object$info_list[[varname]]$varname, "_", lvl,
                     "\\[[[:digit:]]+,[[:digit:]]+\\]")
            }
          }
        })

        Dpat <- Filter(Negate(is.null), Dpat)

        Ds <- nlapply(names(Dpat), function(lvl) {
          D <- stats[grep(Dpat[[lvl]], rownames(stats), value = TRUE), ,
                     drop = FALSE]

          if (nrow(D) > 0) {
            Ddiag <- sapply(strsplit(sub("\\]", "",
                                         sub("^[[:print:]]*\\[", "",
                                             rownames(D))
            ), ","),
            function(i) length(unique(i)) == 1)

            D[Ddiag, "tail-prob."] <- NA
            attr(D, "warnings") <- attr(object$info_list[[varname]]$hc_list,
                                         "warnings")
            attr(D, "rd_vcov") <- object$info_list[[varname]]$rd_vcov[[lvl]]

            for (k in which(names(object$Mlist$rd_vcov[[lvl]]) == "full")) {
              if (varname %in% object$Mlist$rd_vcov[[lvl]][[k]]) {
                attr(D, "ranef_index") <- attr(object$Mlist$rd_vcov[[lvl]][[k]],
                                               "ranef_index")
              }
            }
          }
          D
        })
      }

      assoc_type <- if (object$info_list[[varname]]$modeltype %in% "JM") {
        object$info_list[[which(sapply(object$info_list,
                                       "[[", "modeltype") == "JM")]]$assoc_type
      }

      wb_shape <- if (object$info_list[[varname]]$modeltype %in% c("survreg")) {
        stats[c(paste0("shape_", object$info_list[[varname]]$varname)),
              -which(colnames(stats) == "tail-prob."), drop = FALSE]
      }

      events <- if (object$info_list[[varname]]$modeltype %in%
                    c("survreg", "coxph", "JM")) {
        mat <- object$info_list[[1]]$resp_mat[2]
        col <- object$info_list[[1]]$resp_col[2]
        sum(object$data_list[[mat]][, col])
      }

      other <- setdiff(rownames(stats),
                       c(rownames(regcoef),
                         rownames(sigma),
                         attr(intercepts, "rownames_orig"),
                         if (is.list(rd_vcov)) {
                           rownames(do.call(rbind, rd_vcov))
                         } else {
                           rownames(rd_vcov)
                         },
                         rownames(wb_shape))
      )

      otherpars <- if (length(other) > 0)
        stats[other, , drop = FALSE]


      list(modeltype = object$info_list[[varname]]$modeltype,
           family = object$info_list[[varname]]$family,
           regcoef = regcoef, sigma = sigma, intercepts = intercepts,
           rd_vcov = rd_vcov, wb_shape = wb_shape, assoc_type = assoc_type,
           events = events,
           grcrit = grcrit, otherpars = otherpars)
    }
  }, simplify = FALSE)


  out <- list()
  out$call <- object$call
  out$start <- ifelse(is.null(start), start(object$MCMC),
                      max(start, start(object$MCMC)))
  out$end <- ifelse(is.null(end), end(object$MCMC), min(end, end(object$MCMC)))
  out$thin <- coda::thin(object$MCMC)
  out$nchain <- coda::nchain(object$MCMC) - sum(exclude_chains %in%
                                                  seq_along(object$MCMC))
  out$res <- res_list
  out$outcome <- outcome
  out$missinfo <- if (missinfo) get_missinfo(object)


  out$analysis_type <- object$analysis_type
  out$size <- object$Mlist$N

  class(out) <- "summary.JointAI"
  return(out)
}


#' @rdname summary.JointAI
#' @param x an object of class \code{summary.JointAI} or \code{JointAI}
#' @export
print.summary.JointAI <- function(x, digits = max(3, .Options$digits - 4),
                                  ...) {

  if (!inherits(x, "summary.JointAI"))
    errormsg("Use only with objects.", sQuote("summary.JointAI"))

  cat("\n")

  if (sum(!sapply(x$res, is.null)) > 1 | !is.null(x$outcome))
    cat("Bayesian joint model fitted with JointAI", "\n")
  else
    cat("Bayesian", print_type(x$res[[1]]$modeltype, x$res[[1]]$family),
        "fitted with JointAI\n")

  cat("\nCall:\n", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n", sep = "")

  for (k in seq_along(x$res)) {
    if (!is.null(x$res[[k]])) {
      cat("\n\n")
      if (sum(!sapply(x$res, is.null)) > 1 | !is.null(x$outcome))
        cat(paste0(
          "# ", paste0(c(rep("-", 69)), collapse = ""), " #\n",
          "  ", "Bayesian ",
          print_type(x$res[[k]]$modeltype, x$res[[k]]$family), " for ",
          dQuote(names(x$res)[k]), "\n",
          "# ", paste0(c(rep("-", 35)), collapse = " "), " #\n\n"
        ))


      if (!is.null(x$res[[k]]$events))
        cat("Number of events:", x$res[[k]]$events, "\n\n")


      if (!is.null(x$res[[k]]$regcoef)) {
        cat("Posterior summary:\n")
        print(x$res[[k]]$regcoef, digits = digits, na.print = "")
      }

      if (!is.null(x$res[[k]]$intercepts)) {
        # remove the attributes to avoid printing them
        attr(x$res[[k]]$intercepts, "rownames_orig") <- NULL

        cat("\nPosterior summary of the intercepts:\n")
        print(x$res[[k]]$intercepts, digits = digits, na.print = "")
      }

      if (!is.null(x$res[[k]]$rd_vcov)) {
        cat("\n\nPosterior summary of random effects covariance matrix:\n")
        for (lvl in names(x$res[[k]]$rd_vcov)) {
          warnings <- attr(x$res[[k]]$rd_vcov[[lvl]], "warnings")
          rd_vcov <- attr(x$res[[k]]$rd_vcov[[lvl]], "rd_vcov")
          ranef_index <- attr(x$res[[k]]$rd_vcov[[lvl]], "ranef_index")
          attr(x$res[[k]]$rd_vcov[[lvl]], "warnings") <- NULL
          attr(x$res[[k]]$rd_vcov[[lvl]], "rd_vcov") <- NULL
          attr(x$res[[k]]$rd_vcov[[lvl]], "ranef_index") <- NULL

          if (length(names(x$res[[k]]$rd_vcov)) > 1) {
            cat(paste0("\n* For level ", dQuote(lvl), ":", "\n"))
          }

          w <- if (isTRUE(rd_vcov == "full")) {
            which(names(x$res)[k] == names(ranef_index))
          }

          print_d <- isTRUE(rd_vcov == "full") &&
            (w == 1 || if (w > 1) {
               all(lvapply(x$res[names(ranef_index
               )[seq_len(w - 1)]], is.null))}
            )

          if (print_d || isTRUE(rd_vcov != "full")) {
            if (!is.null(ranef_index)) {
              ranef_index <- lapply(ranef_index, function(nr)
                eval(parse(text = nr)))

              cat(paste0("\r", tab(), "Indices:"),
                  paste0(names(ranef_index), ": ",
                         paste0(ranef_index), collapse = "; "),
                  "\n"
              )
            }
            print(x$res[[k]]$rd_vcov[[lvl]], digits = digits, na.print = "")

            if (!is.null(unlist(warnings))) {
              warnmsg(warnings)
            }
          } else {
            w_ref <- min(which(!lvapply(x$res[names(ranef_index
            )[seq_len(w - 1)]], is.null)))
            cat(paste0(tab(), "(see model for ",
                       dQuote(names(ranef_index)[w_ref]), ")"))
          }
        }
        cat("\n")
      }

      if (!is.null(x$res[[k]]$sigma))  {
        cat("\nPosterior summary of residual std. deviation:\n")
        print(x$res[[k]]$sigma, digits = digits, na.print = "")
      }

      if (!is.null(x$res[[k]]$wb_shape)) {
        cat("\nPosterior summary of the shape of the Weibull distribution:\n")
        print(x$res[[k]]$wb_shape, digits = digits, na.print = "")
      }

      if (!is.null(x$res[[k]]$assoc_type)) {
        cat("\nAssociation types:\n")
        cat(paste0(names(x$res[[k]]$assoc_type), ": ",
                   sapply(x$res[[k]]$assoc_type, function(i)
                     switch(i,
                            "underl.value" = "underlying value",
                            "obs.value" = "observed value")
                   ), collapse = "\n"), "\n")

      }

      if (!is.null(x$res[[k]]$otherpars)) {
        cat("\nPosterior summary of other parameters:\n")
        print(x$res[[k]]$otherpars, digits = digits, na.print = "")
      }
    }
  }

  cat("\n\n")
  if (sum(!sapply(x$res, is.null)) > 1)
    cat("#", paste0(c(rep("-", 59)), collapse = ""), "#\n\n")

  cat("MCMC settings:\n")
  cat("Iterations = ", x$start, ":", x$end, "\n", sep = "")
  cat("Sample size per chain =", (x$end - x$start) / x$thin +
        1, "\n")
  cat("Thinning interval =", x$thin, "\n")
  cat("Number of chains =", x$nchain, "\n")
  cat("\n")
  cat("Number of observations:", x$size["lvlone"], "\n")
  if (length(x$size) > 1) {
    i <- which(!names(x$size) %in% "lvlone")
    cat("Number of groups:\n",
        paste0("- ", names(x$size)[i], ": ", x$size[i], "\n")
    )
  }

  if (!is.null(x$missinfo)) {
    cat("\n\n")
    cat("Number and proportion of complete cases:\n")
    print(x$missinfo$complete_cases, digits = digits)
    cat("\nNumber and proportion of missing values:\n")
    for (k in seq_along(x$missinfo$miss_list)) {
      print(x$missinfo$miss_list[[k]], digits = digits)
      cat("\n")
    }
  }

  invisible(x)
}


#' @export
formula.JointAI <- function(x, ...) {

  if (!(inherits(x, "JointAI") | inherits(x, "JointAI_errored")))
    errormsg("Use only %s with objects.", sQuote("JointAI"))

  x$formula

  #   if (inherits(x$call, "call")) {
  #   if (is.null(x$call$formula)) {
  #     as.formula(x$call$fixed)
  #   } else {
  #     fmla <- eval(x$call$formula)
  #     if (inherits(eval(x$call$formula), "list")) {
  #       x$call$formula
  #     } else {
  #       as.formula(x$call$formula)
  #     }
  #   }
  # } else if (inherits(x$call, "list")) {
  #   fmla_list <- lapply(x$call, function(k) {
  #     if (!is.null(k$formula)) {
  #       k$formula
  #     } else {
  #       k$fixed
  #     }
  #   })
  #   fmla_list <- lapply(fmla_list[lvapply(fmla_list, inherits, "call")], as.formula)
  #   if (length(fmla_list) == 1L) {
  #     fmla_list[[1]]
  #   } else {
  #     fmla_list
  #   }
  # }
}



#' @rdname summary.JointAI
#' @export
coef.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                         subset = NULL, exclude_chains = NULL,
                         warn = TRUE, mess = TRUE, ...) {

  if (!inherits(object, "JointAI")) {
    errormsg("Use only with %s objects.", sQuote("JointAI"))
  }

  if (is.null(object$MCMC)) errormsg("There is no MCMC sample.")


  MCMC <- prep_MCMC(object, start, end, thin, subset,
                    exclude_chains = exclude_chains, mess = mess, warn = warn)

  params <- parameters(object)

  nlapply(names(object$fixed), function(k) {
    x <- params[params$outcome == clean_survname(k), , drop = FALSE]
    rev <- object$info_list[[k]]$rev


    cols <- unlist(
      lapply(x$coef, function(var) {
        grep(paste0(glob2rx(var), "|^",
                    gsub("\\[", "\\\\[", var), "\\[[[:digit:]]+\\]$"),
             colnames(MCMC), value = TRUE)
      })
    )

    cfs <- colMeans(MCMC[, cols, drop = FALSE])

    # replace the regression coefficient parameters with the corresponding
    # variable names
    reg_coefs <- intersect(names(cfs), x$coef[!is.na(x$varname)])
    names(cfs)[match(reg_coefs, names(cfs))] <- x$varname[match(reg_coefs, x$coef)]



    if (object$info_list[[k]]$modeltype %in% c("clm", "clmm")) {
      interc <- grep(paste0("gamma_", k, "\\["), names(cfs))

      lvl <- levels(object$Mlist$refs[[k]])
      if (isTRUE(rev)) {
        names(cfs)[interc] <- paste(k, "\u2264", lvl[-length(lvl)])
      } else {
        names(cfs)[interc] <- paste(k, ">", lvl[-length(lvl)])
      }
    }
    cfs
  })
}

#' @export
coef.summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                                 subset = NULL, exclude_chains = NULL,
                                 warn = TRUE, mess = TRUE, ...) {

  if (!inherits(object, "summary.JointAI"))
    errormsg("Use only with %s objects.", sQuote("summary.JointAI"))

  Filter(Negate(is.null),
         lapply(object$res, "[[", "regcoef")
  )
}



#' @rdname summary.JointAI
#' @param parm same as \code{subset} (for consistency with \code{confint}
#'             method for other types of objects)
#' @param level confidence level (default is 0.95)
#' @export
confint.JointAI <- function(object, parm = NULL, level = 0.95,
                            quantiles = NULL,
                            start = NULL, end = NULL, thin = NULL,
                            subset = NULL, exclude_chains = NULL,
                            warn = TRUE, mess = TRUE, ...) {

  if (!inherits(object, "JointAI")) {
    errormsg("Use only with %s objects.", sQuote("JointAI"))
  }

  if (is.null(object$MCMC)) errormsg("There is no MCMC sample.")


  if (is.null(subset) & !is.null(parm)) subset <- parm

  if (!is.null(subset) & !is.null(parm))
    errormsg("At least one of %s and should be NULL.",
             dQuote("parm"), dQuote("subset"))

  if (is.null(quantiles) & !is.null(level))
    quantiles <- c((1 - level) / 2, 1 - (1 - level) / 2)

  MCMC <- prep_MCMC(object, start, end, thin, subset,
                    exclude_chains = exclude_chains,
                    mess = mess, warn = warn)

  params <- parameters(object)

  nlapply(names(object$fixed), function(k) {
    x <- params[params$outcome == clean_survname(k), , drop = FALSE]
    rev <- object$info_list[[k]]$rev

    cols <- unlist(
      lapply(x$coef, function(var) {
        grep(paste0(glob2rx(var), "|^",
                    gsub("\\[", "\\\\[", var), "\\[[[:digit:]]+\\]$"),
             colnames(MCMC), value = TRUE)
      })
    )

    MCMC_sub <- MCMC[, cols, drop = FALSE]

    quants <- t(apply(MCMC_sub, 2, quantile, quantiles))

    # replace the regression coefficient parameters with the corresponding
    # variable names
    reg_coefs <- intersect(rownames(quants), x$coef[!is.na(x$varname)])
    rownames(quants)[match(reg_coefs, rownames(quants))] <-
      x$varname[match(reg_coefs, x$coef)]

    if (object$info_list[[k]]$modeltype %in% c("clm", "clmm")) {
      lvl <- levels(object$Mlist$refs[[k]])
      interc <- grep(paste0("gamma_", k, "\\["), rownames(quants))

      if (isTRUE(rev)) {
        rownames(quants)[interc] <- paste(k, "\u2264", lvl[-length(lvl)])
      } else {
        rownames(quants)[interc] <- paste(k, ">", lvl[-length(lvl)])
      }
    }
    quants
  })
}


#' @rdname summary.JointAI
#' @export
print.JointAI <- function(x, digits = max(4, getOption("digits") - 4), ...) {

  if (!inherits(x, "JointAI")) {
    errormsg("Use only with %s objects.", sQuote("JointAI"))
  }


  MCMC <- if (!is.null(x$MCMC)) {
    prep_MCMC(x,
              start = NULL, end = NULL, thin = NULL, subset = NULL,
              exclude_chains = NULL,
              mess = TRUE, warn = TRUE, ...
    )
  }


  cat("\nCall:\n")
  print(x$call)

  if (!is.null(MCMC)) {
    coefs <- coef(x)

    for (k in seq_along(coefs)) {
      varname <- names(coefs)[k]

      intercepts <- if (x$info_list[[varname]]$modeltype %in%
                        c("clm", "clmm")) {
        stats <- t(t(colMeans(MCMC[, grep(paste0("gamma_", varname),
                                          colnames(MCMC))])))
        get_intercepts(stats, varname,
                       lvls = levels(x$Mlist$refs[[varname]]),
                       rev = x$info_list[[varname]]$rev)
      }

      cat("\n", "Bayesian",
          print_type(x$info_list[[varname]]$modeltype,
                     x$info_list[[varname]]$family), "for",
          dQuote(varname), "\n")
      if (x$info_list[[names(coefs)[k]]]$modeltype %in%
          c("glmm", "clmm", "mlogitmm")) {

        if (!is.null(intercepts) |
            length(coefs[[k]][x$coef_list[[varname]]$varname]) > 0) {
          cat("\nFixed effects:\n")
          print(c(setNames(c(intercepts), rownames(intercepts)),
                  coefs[[k]][x$coef_list[[varname]]$varname]),
                digits = digits)
        }

        cat("\n\nRandom effects covariance matrix:\n")
        print(get_Dmat(object = x, varname = varname), digits = digits)

      } else {
        if (length(coefs[[k]][x$coef_list[[varname]]$varname] > 0) |
            !is.null(intercepts)) {
          cat("\n\nCoefficients:\n")
          print(c(setNames(c(intercepts), rownames(intercepts)),
                  coefs[[k]][x$coef_list[[varname]]$varname]),
                digits = digits)        }
      }

      if (paste0("sigma_", varname) %in% colnames(MCMC)) {
        cat("\n\nResidual standard deviation:\n")
        print(colMeans(MCMC[, paste0("sigma_", names(coefs)[k]),
                            drop = FALSE]),
              digits = digits)
      }
    }
  } else {
    cat("\n(The object does not contain an MCMC sample.)")
  }

  invisible(x)
}


#' @export
print.modelstring <- function(x, ...) {

  if (!inherits(x, "modelstring"))
    errormsg("Use only with %s objects.", sQuote("modelstring"))

  cat(x)
}





#' Obtain a summary of the missing values involved in an object of class JointAI
#'
#' This function returns a \code{data.frame} or a \code{list} of
#' \code{data.frame}s per grouping level. Each of the \code{data.frames}
#' has columns \code{variable}, \code{#NA} (number of missing values) and
#' \code{%NA} (proportion of missing values in percent).
#'
#' @param object object inheriting from class JointAI
#'
#' @export
#'
#' @examples
#' mod <-  lm_imp(y ~ C1 + B2 + C2, data = wideDF, n.iter = 100)
#' get_missinfo(mod)
#'
#'
get_missinfo <- function(object) {

  if (!(inherits(object, "JointAI") | inherits(object, "JointAI_errored")))
    errormsg("Use only with 'JointAI' objects.")


  allvars <- unique(
    c(all_vars(c(object$fixed, object$random, object$Mlist$auxvars)),
      object$Mlist$timevar))

  groups <- object$Mlist$groups

  # data_lvls <- cvapply(object$data[, allvars], check_varlevel, groups = groups)
  data_lvls <- get_datlvls(object$data[, allvars, drop = FALSE], groups)

  complcases <- lapply(names(groups), function(k) {
    cc <- complete.cases(object$data[match(unique(groups[[k]]), groups[[k]]),
                                     names(data_lvls[data_lvls == k])])

    as.data.frame(
      Filter(Negate(is.null),
             list(
               level = if (length(object$Mlist$groups) > 1) k,
               "#" = sum(cc),
               "%" = mean(cc) * 100
             )
      ), check.names = FALSE, row.names = k)
  })

  # dat_lvls <- sapply(object$data[allvars], check_varlevel,
  #                    groups = object$Mlist$groups)
  dat_lvls <- get_datlvls(object$data[allvars], object$Mlist$groups)

  miss_list <- sapply(unique(dat_lvls), function(lvl) {
    subdat <- object$data[match(unique(object$Mlist$groups[[lvl]]),
                                object$Mlist$groups[[lvl]]),
                          names(dat_lvls)[dat_lvls == lvl], drop = FALSE]
    missinfo <- as.data.frame(
      Filter(Negate(is.null),
             list(
               level = if (length(unique(dat_lvls)) > 1) lvl,
               "# NA" = colSums(is.na(subdat)),
               "% NA" = colMeans(is.na(subdat)) * 100
             )
      ),
      check.names = FALSE
    )
    missinfo[order(missinfo$`# NA`), ]
  }, simplify = FALSE)

  list("complete_cases" = do.call(rbind, complcases),
       miss_list = miss_list
  )
}
