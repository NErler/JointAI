#' List model details
#'
#' This function prints information on all models, those explicitly specified
#' by the user and those specified automatically by JointAI for (incomplete)
#' covariates in a JointAI object.
#'
#' @md
#' @inheritParams summary.JointAI
#' @param predvars logical; should information on the predictor variables be
#'                 printed? (default is \code{TRUE})
#' @param regcoef logical; should information on the regression coefficients
#'                be printed? (default is \code{TRUE})
#' @param otherpars logical; should information on other parameters be printed?
#'                  (default is \code{TRUE})
#' @param priors logical; should information on the priors
#'               (and hyper-parameters) be printed? (default is \code{TRUE})
#' @param refcat logical; should information on the reference category be
#'               printed? (default is \code{TRUE})
#'
#' @return Called for its side effect: the information is printed and
#'         \code{NULL} is returned invisibly.
#'
#' @section Note:
#' The models listed by this function are not the actual imputation models,
#' but the conditional models that are part of the specification of the joint
#' distribution.
#' Briefly, the joint distribution is specified as a sequence of conditional
#' models
#'
#' \loadmathjax
#'
#' \mjdeqn{p(y | x_1, x_2, x_3, ..., \theta) p(x_1|x_2, x_3, ..., \theta)
#' p(x_2|x_3, ..., \theta) ...}{ascii}
#' The actual imputation models are the full conditional distributions
#' \mjeqn{p(x_1 | \cdot)}{ascii} derived from this joint distribution.
#' Even though the conditional distributions do not contain the outcome and all
#' other covariates in their linear predictor, outcome and other covariates are
#' taken into account implicitly, since imputations are sampled
#' from the full conditional distributions.
#' For more details, see Erler et al. (2016) and Erler et al. (2019).
#'
#' The function \code{list_models} prints information on the conditional
#' distributions of the covariates (since they are what is specified;
#' the full-conditionals are automatically derived within JAGS). The outcome
#' is, thus, not part of the printed linear predictor, but is still included
#' during imputation.
#'
#'
#'
#' @references Erler, N.S., Rizopoulos, D., Rosmalen, J.V., Jaddoe,
#' V.W., Franco, O.H., & Lesaffre, E.M.E.H. (2016).
#' Dealing with missing covariates in epidemiologic studies: A comparison
#' between multiple imputation and a full Bayesian approach.
#' \emph{Statistics in Medicine}, 35(17), 2955-2974.
#'
#' Erler NS, Rizopoulos D, Lesaffre EMEH (2021).
#' "JointAI: Joint Analysis and Imputation of Incomplete Data in R."
#' _Journal of Statistical Software_, *100*(20), 1-56.
#' \doi{10.18637/jss.v100.i20}.
#'
#'
#' @examples
#' # (set n.adapt = 0 and n.iter = 0 to prevent MCMC sampling to save time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0,
#'                n.iter = 0, mess = FALSE)
#'
#' list_models(mod1)
#'
#' @export

list_models <- function(
  object,
  predvars = TRUE,
  regcoef = TRUE,
  otherpars = TRUE,
  priors = TRUE,
  refcat = TRUE
) {
  if (!inherits(object, "JointAI") & !inherits(object, "JointAI_errored")) {
    errormsg("Use only with 'JointAI' objects.\n")
  }

  for (i in object$info_list) {
    if (!is.null(i$custom)) {
      cat("Custom model for", dQuote(i$varname), '\n')
      cat(i$custom, "\n")
    } else {
      cat(
        print_type(i$modeltype, i$family, upper = TRUE),
        "for",
        dQuote(i$varname),
        '\n'
      )
      if (!is.null(i$family)) {
        cat(tab(), "family:", i$family, "\n")
      }
      if (!is.null(i$link)) {
        cat(tab(), "link:", i$link, "\n")
      }
      if (!is.null(i$trunc)) {
        print_trunc(i$trunc)
      }

      # * parametrization --------------------------------------------------------
      if (i$family %in% c('Gamma', 'beta') && !is.null(i$family)) {
        cat("* Parametrization:\n")

        if (i$family %in% 'beta') {
          cat(paste0(
            tab(),
            "- shape 1: shape1_",
            i$varname,
            " = mu_",
            i$varname,
            " * tau_",
            i$varname,
            "\n",
            tab(),
            "- shape 2: shape2_",
            i$varname,
            " = (1 - mu_",
            i$varname,
            ") * tau_",
            i$varname,
            "\n"
          ))
        }
        if (i$family %in% 'Gamma') {
          cat(paste0(
            tab(),
            "- shape: shape_",
            i$varname,
            " = mu_",
            i$varname,
            "^2 * tau_",
            i$varname,
            "\n",
            tab(),
            "- rate: rate_",
            i$varname,
            " = mu_",
            i$varname,
            " * tau_",
            i$varname,
            "\n"
          ))
        }
      }

      # refcat -------------------------------------------------------------------
      if (refcat & i$varname %in% names(object$Mlist$refs)) {
        print_refcat(object$Mlist$refs[[i$varname]])
      }

      # * predvars ---------------------------------------------------------------
      if (predvars) {
        cat("* Predictor variables:\n")
        if (length(unlist(i$lp)) > 0) {
          cat(
            strwrap(
              paste0(names(unlist(unname(i$lp))), collapse = ", "),
              prefix = "\n",
              initial = '',
              exdent = 2,
              indent = 2
            ),
            "\n"
          )
        } else {
          cat(' (no predictor variables)', '\n')
        }
        print_nonprop_predvars(i)
      }

      # * regcoef ---------------------------------------------------------------
      if (regcoef) {
        print_regcoef(i, object$data_list, priors)
        print_nonprop_regcoef(i, object$data_list, priors)
      }

      # * opar -------------------------------------------------------------------
      if (otherpars) {
        if (
          i$family %in%
            c('gaussian', 'lognorm', 'Gamma') &&
            !is.null(i$family) &&
            is.null(i$logsd_var) &&
            !isTRUE(i$is_logsd)
        ) {
          cat(paste0("* Precision of ", dQuote(i$varname), ":\n"))
          cat(paste0(
            tab(),
            "tau_",
            i$varname,
            " ",

            if (priors) {
              paste0(
                "(Gamma prior with shape parameter ",
                object$data_list[[paste0(
                  "shape_tau_",
                  get_priortype(i$modeltype, i$family)
                )]],
                " and rate parameter ",
                object$data_list[[paste0(
                  "rate_tau_",
                  get_priortype(i$modeltype, i$family)
                )]],
                ")"
              )
            },
            "\n"
          ))
        }
        if (i$modeltype %in% c('clm', 'clmm')) {
          cat(paste0(
            "* Intercepts:\n",
            tab(),
            "- ",
            levels(object$Mlist$refs[[i$varname]])[1],
            ": gamma_",
            i$varname,
            "[1] ",
            if (priors) {
              paste0(
                "(normal prior with mean ",
                object$data_list$mu_delta_ordinal,
                " and precision ",
                object$data_list$tau_delta_ordinal,
                ")"
              )
            },
            "\n"
          ))
          for (j in 2:length(attr(object$Mlist$refs[[i$varname]], "dummies"))) {
            cat(paste0(
              tab(),
              "- ",
              levels(object$Mlist$refs[[i$varname]])[j],
              ": gamma_",
              i$varname,
              "[",
              j,
              "] = gamma_",
              i$varname,
              "[",
              j - 1,
              "] + exp(delta_",
              i$varname,
              "[",
              j - 1,
              "])\n"
            ))
          }
          cat(paste0(
            "* Increments:\n",
            tab(),
            "delta_",
            i$varname,
            "[",
            print_seq(
              1,
              length(
                levels(object$Mlist$refs[[i$varname]])
              ) -
                2
            ),
            "] ",
            if (priors) {
              paste0(
                "(normal prior(s) with mean ",
                object$data_list$mu_delta_ordinal,
                " and precision ",
                object$data_list$tau_delta_ordinal,
                ")"
              )
            },
            "\n"
          ))
        }
        if (i$modeltype %in% c('survreg')) {
          cat(paste0(
            '* Shape parameter:\n',
            tab(),
            'shape_',
            i$varname,
            if (priors) {
              ' (exponential prior with rate 0.01)'
            },
            "\n"
          ))
        }
        if (i$modeltype %in% c('coxph', 'JM')) {
          cat(paste0(
            '* Regression coefficients of the baseline hazard:\n',
            tab(),
            'beta_Bh0_',
            i$varname,
            "[",
            print_seq(1, i$df_basehaz),
            "]",
            if (priors) {
              paste0(
                " (normal priors with mean ",
                object$data_list$mu_reg_surv,
                " and precision ",
                object$data_list$tau_reg_surv,
                ")"
              )
            },
            "\n"
          ))
          if (i$modeltype %in% 'JM' && length(i$assoc_type) > 0L) {
            cat(paste0(
              "* Association types:\n",
              paste0(
                tab(),
                "- ",
                names(i$assoc_type),
                ": ",
                i$assoc_type,
                collapse = "\n"
              ),
              "\n"
            ))
          }
        }
      }

      # * random effects ----------------------------------------------------------
      if (otherpars) {
        print_ranefs(i, object$data_list, priors)
      }
      cat("\n\n")
    }
  }
}


# help functions ---------------------------------------------------------------

# used in list_models and helpfunctions for rd_vcov (2020-08-13)
print_seq <- function(min, max) {
  m <- Map(
    function(min, max) {
      if (min == max) {
        max
      } else {
        paste0(min, ":", max)
      }
    },
    min = min,
    max = max
  )

  unlist(m)
}


# used in list_models()
print_refcat <- function(rc) {
  cat(paste0("* Reference category: ", dQuote(rc), "\n"))
}


get_priortype <- function(modeltype, family) {
  switch(
    modeltype,
    'glm' = switch(
      family,
      'gaussian' = 'norm',
      'lognorm' = 'norm',
      'Gamma' = 'gamma',
      'beta' = 'beta',
      'poisson' = 'poisson',
      'binomial' = 'binom'
    ),
    'glmm' = switch(
      family,
      'gaussian' = 'norm',
      'lognorm' = 'norm',
      'Gamma' = 'gamma',
      'beta' = 'beta',
      'poisson' = 'poisson',
      'binomial' = 'binom'
    ),
    'clm' = 'ordinal',
    'clmm' = 'ordinal',
    'mlogit' = 'multinomial',
    'mlogitmm' = 'multinomial',
    'survreg' = 'surv',
    'coxph' = 'surv',
    'JM' = 'surv'
  )
}


paste_regcoef_prior <- function(data_list, modeltype, family) {
  paste0(
    "(normal prior(s) with mean ",
    data_list[[paste0('mu_reg_', get_priortype(modeltype, family))]],
    " and precision ",
    data_list[[paste0('tau_reg_', get_priortype(modeltype, family))]],
    ")"
  )
}


#' Print the truncation of a sub-model (used in `list_models()`)
#'
#' @param trunc numeric vector of length two with the lower and upper limit of
#'   the truncation (`NA` if there is no limit), as in the element `trunc` of
#'   the model information.
#'
#' @returns `NULL`, invisibly; called for the printed output.
#' @keywords internal
print_trunc <- function(trunc) {
  limits <- c(
    if (!is.na(trunc[1L])) paste("lower limit", trunc[1L]),
    if (!is.na(trunc[2L])) paste("upper limit", trunc[2L])
  )
  cat(paste0("* Truncation:\n", tab(), paste(limits, collapse = ", "), "\n"))
  invisible(NULL)
}


#' Print the regression coefficients of a sub-model (used in `list_models()`)
#'
#' Multinomial models have a set of coefficients per category (except the
#' reference category); they are listed per category, also when they are in
#' several design matrices (mixed models).
#'
#' @param info the model information of the sub-model (an element of
#'   `info_list`).
#' @param data_list the data list passed to JAGS (for the hyper-parameters of
#'   the prior).
#' @param priors logical; should the prior be printed?
#'
#' @returns `NULL`, invisibly; called for the printed output.
#' @keywords internal
print_regcoef <- function(info, data_list, priors) {
  coefs <- unlist(info$parelmts)
  if (length(coefs) == 0L) {
    return(invisible(NULL))
  }

  prior <- if (priors) {
    paste_regcoef_prior(data_list, info$modeltype, info$family)
  }

  cat("* Regression coefficients:\n")
  if (info$modeltype %in% c("mlogit", "mlogitmm")) {
    # info$parelmts: one list per design matrix, with an element per category
    categories <- unique(unlist(lapply(info$parelmts, names)))
    lines <- character(0L)
    for (category in categories) {
      ranges <- character(0L)
      for (elmts in info$parelmts) {
        if (!is.null(elmts[[category]])) {
          ranges <- c(
            ranges,
            print_seq(min(elmts[[category]]), max(elmts[[category]]))
          )
        }
      }
      lines <- c(
        lines,
        paste0(
          tab(),
          category,
          ": ",
          paste0(info$parname, "[", ranges, "]", collapse = ", ")
        )
      )
    }
    cat(paste0(lines, collapse = "\n"), prior, "\n")
  } else {
    cat(
      paste0(tab(), info$parname, "[", print_seq(min(coefs), max(coefs)), "]"),
      prior,
      "\n"
    )
  }
  invisible(NULL)
}


#' Print the variables with non-proportional effects (used in `list_models()`)
#'
#' In cumulative logit models, the effects of the variables given in
#' `nonprop` differ between the categories of the outcome.
#'
#' @param info the model information of the sub-model (an element of
#'   `info_list`); the variables are in the attribute `nonprop` of `info$lp`.
#'
#' @returns `NULL`, invisibly; called for the printed output.
#' @keywords internal
print_nonprop_predvars <- function(info) {
  vars <- names(unlist(unname(attr(info$lp, "nonprop"))))
  if (length(vars) == 0L) {
    return(invisible(NULL))
  }

  cat("* Predictor variables with non-proportional effects:\n")
  cat(
    strwrap(
      paste0(vars, collapse = ", "),
      prefix = "\n",
      initial = "",
      exdent = 2,
      indent = 2
    ),
    "\n"
  )
  invisible(NULL)
}


#' Print the coefficients of non-proportional effects (used in `list_models()`)
#'
#' @param info the model information of the sub-model (an element of
#'   `info_list`); the coefficients are in the attribute `nonprop` of the
#'   elements of `info$parelmts`, with one element per category of the outcome
#'   (except the first).
#' @param data_list the data list passed to JAGS (for the hyper-parameters of
#'   the prior).
#' @param priors logical; should the prior be printed?
#'
#' @returns `NULL`, invisibly; called for the printed output.
#' @keywords internal
print_nonprop_regcoef <- function(info, data_list, priors) {
  nonprop <- lapply(info$parelmts, attr, "nonprop")
  nonprop <- nonprop[!vapply(nonprop, is.null, logical(1L))]
  if (length(nonprop) == 0L) {
    return(invisible(NULL))
  }

  categories <- unique(unlist(lapply(nonprop, names)))
  lines <- character(0L)
  for (category in categories) {
    ranges <- character(0L)
    for (elmts in nonprop) {
      if (length(elmts[[category]]) > 0L) {
        ranges <- c(
          ranges,
          print_seq(min(elmts[[category]]), max(elmts[[category]]))
        )
      }
    }
    lines <- c(
      lines,
      paste0(
        tab(),
        category,
        ": ",
        paste0(info$parname, "[", ranges, "]", collapse = ", ")
      )
    )
  }

  prior <- if (priors) {
    paste_regcoef_prior(data_list, info$modeltype, info$family)
  }
  cat("* Regression coefficients of the non-proportional effects:\n")
  cat(paste0(lines, collapse = "\n"), prior, "\n")
  invisible(NULL)
}


#' Print the random effects of a sub-model (used in `list_models()`)
#'
#' For each grouping level with random effects: the random effects with their
#' variables, and their covariance matrix with its prior, as in the JAGS model
#' (`ranef_priors()`): a Gamma prior for the precision of a single random
#' effect, Gamma priors for the diagonal precision matrix with
#' `rd_vcov = "indep"`, and otherwise a Wishart prior for the precision matrix,
#' with Gamma priors for the diagonal of its scale matrix. With
#' `rd_vcov = "full"`, the random effects of several sub-models have one
#' covariance matrix; the sub-models that share it are named.
#'
#' @param info the model information of the sub-model (an element of
#'   `info_list`).
#' @param data_list the data list passed to JAGS (for the hyper-parameters of
#'   the priors).
#' @param priors logical; should the priors be printed?
#'
#' @returns `NULL`, invisibly; called for the printed output.
#' @keywords internal
print_ranefs <- function(info, data_list, priors) {
  for (lvl in names(info$hc_list$hcvars)) {
    z_names <- attr(info$hc_list$hcvars[[lvl]], "z_names")
    rd_vcov <- info$rd_vcov[[lvl]]
    shared <- identical(as.character(rd_vcov), "full")

    # name of the random effects and their covariance matrix, the columns of
    # this sub-model, and the dimension of the covariance matrix
    if (shared) {
      name <- lvl
      ranef_index <- attr(rd_vcov, "ranef_index")
      cols <- ranef_index[[info$varname]]
      nranef <- max(unlist(lapply(ranef_index, function(x) eval(str2lang(x)))))
    } else {
      name <- paste0(info$varname, "_", lvl)
      cols <- print_seq(1L, info$nranef[[lvl]])
      nranef <- info$nranef[[lvl]]
    }

    cat(paste0(
      "* Random effects on the level of ",
      dQuote(lvl),
      ":\n",
      tab(),
      "b_",
      name,
      "[, ",
      cols,
      "]: ",
      paste(z_names, collapse = ", "),
      "\n"
    ))

    cat(paste0(
      "* Covariance matrix of the random effects on the level of ",
      dQuote(lvl),
      ":\n"
    ))
    if (shared) {
      cat(paste0(
        tab(),
        "(shared by the random effects of ",
        paste_and(names(ranef_index), dQ = TRUE),
        ")\n"
      ))
    }

    dims <- paste0("[", print_seq(1L, nranef), ", ", print_seq(1L, nranef), "]")
    gamma_prior <- paste0(
      if (nranef == 1L) "Gamma prior" else "Gamma priors",
      " with shape parameter ",
      data_list$shape_diag_RinvD,
      " and rate parameter ",
      data_list$rate_diag_RinvD
    )

    if (nranef == 1L) {
      cat(paste0(tab(), "D_", name, "[1, 1] = 1 / invD_", name, "[1, 1]\n"))
      if (priors) {
        cat(paste0(tab(), "invD_", name, "[1, 1] (", gamma_prior, ")\n"))
      }
    } else if (identical(as.character(rd_vcov), "indep")) {
      cat(paste0(
        tab(),
        "D_",
        name,
        dims,
        " = inverse(invD_",
        name,
        ") (diagonal)\n"
      ))
      if (priors) {
        cat(paste0(
          tab(),
          "invD_",
          name,
          dims,
          " (diagonal; ",
          gamma_prior,
          ")\n"
        ))
      }
    } else {
      cat(paste0(tab(), "D_", name, dims, " = inverse(invD_", name, ")\n"))
      if (priors) {
        cat(paste0(
          tab(),
          "invD_",
          name,
          dims,
          " (Wishart prior with scale matrix RinvD_",
          name,
          " and ",
          unname(data_list[[paste0("KinvD_", name)]]),
          " degrees of freedom)\n",
          tab(),
          "RinvD_",
          name,
          dims,
          " (diagonal; ",
          gamma_prior,
          ")\n"
        ))
      }
    }
  }
  invisible(NULL)
}
