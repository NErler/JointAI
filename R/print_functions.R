#' List covariate models
#'
#' This function prints information on models specified for (incomplete)
#' covariates in a JointAI object, including the model type, names of the
#' parameters used and hyperparameters.
#'
#' @inheritParams sharedParams
#' @param predvars logical; should information on the predictor variables be
#'                 printed? (default is \code{TRUE})
#' @param regcoef logical; should information on the regression coefficients
#'                be printed? (default is \code{TRUE})
#' @param otherpars logical; should information on other parameters be printed?
#'                  (default is \code{TRUE})
#' @param priors logical; should information on the priors (and hyperparameters)
#'               be printed? (default is \code{TRUE})
#' @param refcat logical; should information on the reference category be
#'               printed? (default is \code{TRUE})
#'
#' @section Note:
#' The models listed by this function are not the actual imputation models,
#' but the conditional models that are part of the specification of the joint
#' distribution.
#' Briefly, the joint distribution is specified as a sequence of conditional
#' models
#' \deqn{p(y | x_1, x_2, x_3, ..., \theta) p(x_1|x_2, x_3, ..., \theta) p(x_2|x_3, ..., \theta) ...}
#' The actual imputation models are the full conditional distributions
#' \eqn{p(x_1 | \cdot)} derived from this joint distribution.
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
#' Erler, N.S., Rizopoulos D. and Lesaffre E.M.E.H. (2019).
#' JointAI: Joint Analysis and Imputation of Incomplete Data in R.
#' \emph{arXiv e-prints}, arXiv:1907.10867.
#' URL https://arxiv.org/abs/1907.10867.
#'
#'
#' @examples
#' # (set n.adapt = 0 and n.iter = 0 to prevent MCMC sampling to save time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0, n.iter = 0, mess = FALSE)
#'
#' list_models(mod1)
#'
#' @export


list_models <- function(object, predvars = TRUE, regcoef = TRUE,
                        otherpars = TRUE, priors = TRUE, refcat = TRUE) {

  if (!inherits(object, "JointAI"))
    errormsg("Use only with 'JointAI' objects.\n")

  for (i in object$info_list) {
    cat(print_type(i$modeltype), "for", dQuote(i$varname), '\n')
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
        cat(' ', add_breaks(paste0(names(unlist(unname(i$lp))), collapse = ", ")),
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
            paste0("(normal prior(s) with mean ",
                   object$data_list[[paste0('mu_reg_',
                                            get_priortype(i$modeltype, i$family, i$link))]],
                   " and precision ",
                   object$data_list[[paste0('tau_reg_',
                                            get_priortype(i$modeltype, i$family, i$link))]],
                   ")")
          }, "\n")
      } else {
        cat(paste0(tab(),
                   i$parname, "[", print_seq(min(unlist(i$parelmts)),
                                             max(unlist(i$parelmts))),
                   "]"),
            if (priors) {
              paste0("(normal prior(s) with mean ",
                     object$data_list[[paste0('mu_reg_',
                                              get_priortype(i$modeltype, i$family, i$link))]],
                     " and precision ",
                     object$data_list[[paste0('tau_reg_',
                                              get_priortype(i$modeltype, i$family, i$link))]],
                     ")")
            }, "\n")
      }
    }

    # * opar -------------------------------------------------------------------
    if (otherpars) {
      if (i$family %in% c('gaussian', 'lognorm', 'Gamma') && !is.null(i$family)) {
        cat("* Precision of ", dQuote(i$varname), ":\n")
        cat(paste0(tab(), "tau_", i$varname, " ",

            if (priors) {
              paste0("(Gamma prior with shape parameter ",
                     object$data_list[[paste0("shape_tau_",
                                              get_priortype(i$modeltype, i$family, i$link))]],
                    " and rate parameter ",
                    object$data_list[[paste0("rate_tau_",
                                             get_priortype(i$modeltype, i$family, i$link))]],
                    ")")
           }, "\n"))
      }
      if (i$modeltype %in% c('clm', 'clmm')) {
        cat(paste0("* Intercepts:\n",
                   tab(), "- ", levels(object$Mlist$refs[[i$varname]])[1],
                   ": gamma_", i$varname,
                   "[1] ",
                   if (priors) {
                     paste0("(normal prior with mean ",  object$data_list$mu_delta_ordinal,
                            " and precision ", object$data_list$tau_delta_ordinal, ")")
                   }, "\n"))
        for (j in 2:length(attr(object$Mlist$refs[[i$varname]], "dummies"))) {
          cat(paste0(tab(), "- ", levels(object$Mlist$refs[[i$varname]])[j],
                     ": gamma_", i$varname, "[", j, "] = gamma_",
                     i$varname, "[", j - 1, "] + exp(delta_",
                       i$varname, "[", j - 1, "])\n"))
          }
        cat(paste0("* Increments:\n",
                   tab(), "delta_", i$varname,
                   "[",print_seq(1, length(levels(object$Mlist$refs[[i$varname]])) - 2),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ",  object$data_list$mu_delta_ordinal,
                            " and precision ", object$data_list$tau_delta_ordinal, ")")
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
                   tab(), 'beta_Bh0_', i$varname, "[", print_seq(1, i$df_basehaz),
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



#' Parameter names of an JointAI object
#'
#' Returns the names of the parameters/nodes of an object of class 'JointAI' for
#' which a monitor is set.
#'
#' @inheritParams sharedParams
#' @param ... currently not used
#'
#' @examples
#' # (does not need MCMC samples to work, so we will set n.adapt = 0 and
#' # n.iter = 0 to reduce computational time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0, n.iter = 0, mess = FALSE)
#'
#' parameters(mod1)
#'
#' @export
#'
parameters <- function(object, mess = TRUE, warn = TRUE, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  args <- as.list(match.call())

  if (is.null(object$MCMC)) {
    if (mess)
    message(paste0("Note: '", args$object, "' does not contain MCMC samples."))
  }

  vnam <- object$mcmc_settings$variable.names
  if ('beta' %in% vnam) {
    pos <- grep('\\bbeta\\b', vnam)
    vnam <- append(vnam,
                   unlist(sapply(object$coef_list, function(x)
                     grep("^beta\\b", x$coef, value = TRUE)
                   )),
                   after = pos)[-pos]
  }
  if ('alpha' %in% vnam) {
    pos <- grep('\\balpha\\b', vnam)
    vnam <- append(vnam,
                   unlist(sapply(object$coef_list, function(x)
                     grep("^alpha\\b", x$coef, value = TRUE)
                   )),
                   after = pos)[-pos]
  }
  return(unname(vnam))
}


# helpfunctions ---------------------------------------------------------------

# used in print_functions.R
print_seq <- function(min, max) {
  if (min == max)
    max
  else
    paste0(min, ":", max)
}


# add linebreaks when printing a string
add_breaks <- function(string) {
  m <- gregexpr(", ", string)[[1]]
  br <- ifelse(c(0, diff(as.numeric(m) %/% getOption('width'))) > 0, "\n", "")
  gsub("\n, ", ",\n  ", paste0(strsplit(string, ", ")[[1]], br, collapse = ", "))
}


# used in print_functions.R
print_title <- function(name, var) {
  cat(paste0(name, " model for ", dQuote(var), "\n"))
}

# used in print_functions.R
print_refcat <- function(rc) {
  cat(paste0("* Reference category: ", dQuote(rc), "\n"))
}


get_priortype <- function(modeltype, family, link) {
  switch(modeltype,
         'glm' = switch(family,
                        'gaussian' = 'norm',
                        'lognorm' = 'norm',
                        'Gamma' = 'gamma',
                        'beta' = 'beta',
                        'poisson' = 'poisson',
                        'binomial' = link),
         'glmm' = switch(family,
                         'gaussian' = 'norm',
                         'lognorm' = 'norm',
                         'Gamma' = 'gamma',
                         'beta' = 'beta',
                         'poisson' = 'poisson',
                         'binomial' = link),
         'clm' = 'ordinal',
         'clmm' = 'ordinal',
         'mlogit' = 'multinomial',
         'mlogitmm' = 'multinomial',
        'survreg' = 'surv',
        'coxph' = 'surv',
        'JM' = 'surv')
}
