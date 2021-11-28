#' List model details
#'
#' This function prints information on all models, those explicitly specified
#' by the user and those specified automatically by JointAI for (incomplete)
#' covariates in a JointAI object.
#'
#' @md
#' @inheritParams sharedParams
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


list_models <- function(object, predvars = TRUE, regcoef = TRUE,
                        otherpars = TRUE, priors = TRUE, refcat = TRUE) {

  if (!inherits(object, "JointAI") & !inherits(object, "JointAI_errored"))
    errormsg("Use only with 'JointAI' objects.\n")

  for (i in object$info_list) {
    if (!is.null(i$custom)) {
      cat("Custom model for", dQuote(i$varname), '\n')
      cat(i$custom, "\n")
    } else {

      cat(print_type(i$modeltype, i$family, upper = TRUE), "for",
          dQuote(i$varname), '\n')
      if (!is.null(i$family))
        cat(tab(), "family:", i$family, "\n")
      if (!is.null(i$link))
        cat(tab(), "link:", i$link, "\n")

      # * parametrization --------------------------------------------------------
      if (i$family %in% c('Gamma', 'beta') && !is.null(i$family)) {
        cat("* Parametrization:\n")

        if (i$family %in% 'beta')
          cat(paste0(tab(), "- shape 1: shape1_", i$varname,
                     " = mu_", i$varname, " * tau_", i$varname, "\n",
                     tab(), "- shape 2: shape2_", i$varname,
                     " = (1 - mu_", i$varname, ") * tau_", i$varname, "\n")
          )
        if (i$family %in% 'Gamma')
          cat(paste0(
            tab(), "- shape: shape_", i$varname,
            " = mu_", i$varname, "^2 * tau_", i$varname, "\n",
            tab(), "- rate: rate_", i$varname,
            " = mu_", i$varname, " * tau_", i$varname, "\n")
          )
      }

      # refcat -------------------------------------------------------------------
      if (refcat & i$varname %in% names(object$Mlist$refs)) {
        print_refcat(object$Mlist$refs[[i$varname]])
      }

      # * predvars ---------------------------------------------------------------
      if (predvars) {
        cat("* Predictor variables:\n")
        if (length(unlist(i$lp)) > 0)
          cat(strwrap(paste0(names(unlist(unname(i$lp))), collapse = ", "),
                      prefix = "\n", initial = '', exdent = 2, indent = 2),
              "\n")
        else
          cat(' (no predictor variables)', '\n')
      }

      # * regcoef ---------------------------------------------------------------
      if (regcoef & any(!sapply(i$parelmts, is.null))) {
        cat("* Regression coefficients:\n")
        if (i$modeltype %in% c('mlogit', 'mlogitmm')) {
          cat(
            paste0(tab(), attr(object$Mlist$refs[[i$varname]], "dummies"), ": ",
                   i$parname, "[",
                   sapply(unlist(i$parelmts, recursive = FALSE), function(x) {
                     print_seq(min(x), max(x))
                   }),
                   "]", collapse = "\n"),
            if (priors) {
              paste_regcoef_prior(object$data_list, i$modeltype, i$family)
            }, "\n")
        } else {
          cat(paste0(tab(),
                     i$parname, "[", print_seq(min(unlist(i$parelmts)),
                                               max(unlist(i$parelmts))),
                     "]"),
              if (priors) {
                paste_regcoef_prior(object$data_list, i$modeltype, i$family)
              }, "\n")
        }
      }

      # * opar -------------------------------------------------------------------
      if (otherpars) {
        if (i$family %in% c('gaussian', 'lognorm', 'Gamma') &&
            !is.null(i$family)) {
          cat("* Precision of ", dQuote(i$varname), ":\n")
          cat(paste0(tab(), "tau_", i$varname, " ",

                     if (priors) {
                       paste0("(Gamma prior with shape parameter ",
                              object$data_list[[paste0("shape_tau_",
                                                       get_priortype(i$modeltype,
                                                                     i$family))]],
                              " and rate parameter ",
                              object$data_list[[paste0("rate_tau_",
                                                       get_priortype(i$modeltype,
                                                                     i$family))]],
                              ")")
                     }, "\n"))
        }
        if (i$modeltype %in% c('clm', 'clmm')) {
          cat(paste0("* Intercepts:\n",
                     tab(), "- ", levels(object$Mlist$refs[[i$varname]])[1],
                     ": gamma_", i$varname,
                     "[1] ",
                     if (priors) {
                       paste0("(normal prior with mean ",
                              object$data_list$mu_delta_ordinal,
                              " and precision ",
                              object$data_list$tau_delta_ordinal, ")")
                     }, "\n"))
          for (j in 2:length(attr(object$Mlist$refs[[i$varname]], "dummies"))) {
            cat(paste0(tab(), "- ", levels(object$Mlist$refs[[i$varname]])[j],
                       ": gamma_", i$varname, "[", j, "] = gamma_",
                       i$varname, "[", j - 1, "] + exp(delta_",
                       i$varname, "[", j - 1, "])\n"))
          }
          cat(paste0("* Increments:\n",
                     tab(), "delta_", i$varname,
                     "[",print_seq(1,
                                   length(
                                     levels(object$Mlist$refs[[i$varname]])) - 2),
                     "] ",
                     if (priors) {
                       paste0("(normal prior(s) with mean ",
                              object$data_list$mu_delta_ordinal,
                              " and precision ",
                              object$data_list$tau_delta_ordinal, ")")
                     }, "\n"))
        }
        if (i$modeltype %in% c('survreg')) {
          cat(paste0('* Shape parameter:\n',
                     tab(), 'shape_', i$varname,
                     if (priors) {
                       ' (exponential prior with rate 0.01)'
                     }, "\n"))
        }
        if (i$modeltype %in% c('coxph', 'JM')) {
          cat(paste0('* Regression coefficients of the baseline hazard:\n',
                     tab(), 'beta_Bh0_', i$varname, "[",
                     print_seq(1, i$df_basehaz),
                     "]",
                     if (priors) {
                       paste0(" (normal priors with mean ", object$data_list$mu_reg_surv,
                              " and precision ", object$data_list$tau_reg_surv, ")")
                     }, "\n"))
          if (i$modeltype %in% 'JM') {
            cat(paste0("* association types:\n",
                       paste0(tab(), "- ", names(i$assoc_type), ": ",
                              i$assoc_type, collapse = "\n")
            ))
          }
        }
      }
      cat("\n\n")
    }
  }
}




# help functions ---------------------------------------------------------------

# used in list_models and helpfunctions for rd_vcov (2020-08-13)
print_seq <- function(min, max) {

  m <- Map(function(min, max) {
    if (min == max) {
      max
    } else {
      paste0(min, ":", max)
    }
  }, min = min, max = max)

  unlist(m)
}


# used in list_models()
print_refcat <- function(rc) {
  cat(paste0("* Reference category: ", dQuote(rc), "\n"))
}


get_priortype <- function(modeltype, family) {
  switch(modeltype,
         'glm' = switch(family,
                        'gaussian' = 'norm',
                        'lognorm' = 'norm',
                        'Gamma' = 'gamma',
                        'beta' = 'beta',
                        'poisson' = 'poisson',
                        'binomial' = 'binom'),
         'glmm' = switch(family,
                         'gaussian' = 'norm',
                         'lognorm' = 'norm',
                         'Gamma' = 'gamma',
                         'beta' = 'beta',
                         'poisson' = 'poisson',
                         'binomial' = 'binom'),
         'clm' = 'ordinal',
         'clmm' = 'ordinal',
         'mlogit' = 'multinomial',
         'mlogitmm' = 'multinomial',
         'survreg' = 'surv',
         'coxph' = 'surv',
         'JM' = 'surv')
}



paste_regcoef_prior <- function(data_list, modeltype, family) {
  paste0("(normal prior(s) with mean ",
         data_list[[paste0('mu_reg_', get_priortype(modeltype, family))]],
         " and precision ",
         data_list[[paste0('tau_reg_', get_priortype(modeltype, family))]],
         ")")
}

