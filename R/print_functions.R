#' List covariate models
#'
#' This function prints information on models specified for (incomplete) covariates in a JointAI object,
#' including the model type, names of the parameters used and hyperparameters.
#'
#' @inheritParams sharedParams
#' @param predvars logical; should information on the predictor variables be printed? (default is \code{TRUE})
#' @param regcoef logical; should information on the regression coefficients be printed? (default is \code{TRUE})
#' @param otherpars logical; should information on other parameters be printed? (default is \code{TRUE})
#' @param priors logical; should information on the priors (and hyperparameters)
#'               be printed? (default is \code{TRUE})
#' @param refcat logical; should information on the reference category be printed? (default is \code{TRUE})
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
    stop("Use only with 'JointAI' objects.\n")

  for (i in seq_along(object$models)) {
    pars <- switch(object$models[i],
                   norm = list(name = 'Linear regression', pars = 'norm'),
                   logit = list(name = 'Logistic regression', pars = 'logit'),
                   gamma = list(name = 'Gamma regression', pars = 'gamma'),
                   lognorm = list(name = "Log-normal regression", pars = 'norm'),
                   beta = list(name = "Beta regression", pars = 'beta'),
                   lmm = list(name = "Linear mixed model", pars = 'norm'),
                   glmm_lognorm = list(name = 'Log-normal mixed model', pars = 'norm'),
                   glmm_logit = list(name = "Logistic mixed model", pars = 'logit'),
                   glmm_gamma = list(name = "Gamma mixed model", pars = 'gamma'),
                   cumlogit = list(name = 'Cumulative logit model', pars = 'ordinal'),
                   clmm = list(name = "Cumulative logit mixed model", pars = 'ordinal')
    )

    pv <- paste0("* Predictor variables: \n",
             tab(), add_breaks(
               paste(
                 c(colnames(object$data_list$Xc)[object$imp_par_list[[names(object$models[i])]]$Xc_cols],
                   colnames(object$data_list$Xl)[object$imp_par_list[[names(object$models[i])]]$Xl_cols],
                   colnames(object$data_list$Z)[object$imp_par_list[[names(object$models[i])]]$Z_cols[-1]]),
                 collapse = ", ")), "\n")

    rc <- paste0(if (object$models[i] %in% c('cumlog', 'clmm')) {
      paste0("* Regression coefficients (with",
             if (!object$imp_par_list[[names(object$models[i])]]$intercept) "out",
             " intercept): \n")
    } else {
      paste0("* Regression coefficients: \n")
    },
    tab(), "alpha[",
    if (object$models[i] == 'multilogit') {
      NULL
    } else {
      print_seq(object$K_imp[names(object$models)[i], "start"],
                object$K_imp[names(object$models)[i], "end"])
    },
    "] ",
    if (priors) {
      paste0("(normal prior(s) with mean ",
             object$data_list[[paste0("mu_reg_", pars$pars)]],
             " and precision ",
             object$data_list[[paste0("tau_reg_", pars$pars)]], ")")
    }, "\n")


    opar <- paste0("* Precision of '", names(object$models)[i], "':\n",
                   tab(), "tau_", names(object$models)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with shape parameter ",
                            object$data_list[[paste0("shape_tau_", pars$pars)]],
                            " and rate parameter ",
                            object$data_list[[paste0("rate_tau_", pars$pars)]], ")")
                   }, "\n")


    if (i > 1) cat("\n")

    # norm & lognorm ----------------------------------------------------------
    if (object$models[i] %in% c("norm", "lognorm")) {
      type <- switch(object$models[i],
                     norm = list(lab = 'norm', name = "Normal"),
                     lognorm = list(lab = 'lognorm', name = "Log-normal"))

      cat(paste0(type$name, " imputation model for '", names(object$models)[i], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) cat(opar)
    }

    # Gamma imputation model ----------------------------------------------------
    if (object$models[i] %in% c("gamma")) {
      cat(paste0("Gamma imputation model for '", names(object$models)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape: shape_", names(object$models)[i],
                 " = mu_", names(object$models)[i], "^2 * tau_", names(object$models)[i], "\n",
                 tab(), "- rate: rate_", names(object$models)[i],
                 " = mu_", names(object$models)[i], " * tau_", names(object$models)[i], "\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) cat(opar)
    }

    # beta imputation model ----------------------------------------------------
    if (object$models[i] %in% c("beta")) {
      cat(paste0("Beta imputation model for '", names(object$models)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape 1: shape1_", names(object$models)[i],
                 " = mu_", names(object$models)[i], " * tau_", names(object$models)[i], "\n",
                 tab(), "- shape 2: shape2_", names(object$models)[i],
                 " = (1 - mu_", names(object$models)[i], ") * tau_", names(object$models)[i], "\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) cat(opar)
    }

    # logit imputation model ---------------------------------------------------
    if (object$models[i] == "logit") {
      cat(paste0("Logistic imputation model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
    }

    # multinomial logit imputation model ---------------------------------------
    if (object$models[i] == "multilogit") {
      cat(paste0("Multinomial logit imputation model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) {
        cat(paste0("* Regression coefficients: \n"))
        for (j in seq_along(attr(object$Mlist$refs[[names(object$models)[i]]], "dummies"))) {
          cat(paste0(tab(), "- '",
                     attr(object$Mlist$refs[[names(object$models)[i]]], "dummies")[j],
                     "': alpha[",
                     print_seq(object$K_imp[attr(object$Mlist$refs[[names(object$models)[i]]],
                                                 "dummies")[j], "start"],
                               object$K_imp[attr(object$Mlist$refs[[names(object$models)[i]]],
                                                 "dummies")[j],  "end"]),
                     "] ",
                     if (priors) {
                       paste0("(normal prior(s) with mean ", object$data_list$mu_reg_multinomial,
                              " and precision ", object$data_list$tau_reg_multinomial, ")")
                     }, "\n"))
        }
      }
    }

    # cumlogit -----------------------------------------------------------------
    if (object$models[i] == "cumlogit") {
      cat(paste0("Cumulative logit imputation model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) {
        cat(paste0("* Intercepts:\n",
                   tab(), "- ", levels(object$Mlist$refs[[names(object$models)[i]]])[1],
                   ": gamma_", names(object$models)[i],
                   "[1] ",
                   if (priors) {
                     paste0("(normal prior with mean ",  object$data_list$mu_delta_ordinal,
                            " and precision ", object$data_list$tau_delta_ordinal, ")")
                   }, "\n"))
        for (j in 2:length(attr(object$Mlist$refs[[names(object$models)[i]]], "dummies"))) {
          cat(paste0(tab(), "- ", levels(object$Mlist$refs[[names(object$models)[i]]])[j],
                     ": gamma_", names(object$models)[i], "[", j, "] = gamma_",
                     names(object$models)[i], "[", j - 1, "] + exp(delta_",
                     names(object$models)[i], "[", j - 1, "])\n"))
        }
        cat(paste0("* Increments:\n",
                   tab(), "delta_", names(object$models)[i],
                   "[",print_seq(1, length(levels(object$Mlist$refs[[names(object$models)[i]]])) - 2),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ",  object$data_list$mu_delta_ordinal,
                            " and precision ", object$data_list$tau_delta_ordinal, ")")
                   }, "\n"))
      }
    }

    # lmm ----------------------------------------------------------------------
    if (object$models[i] == 'lmm') {
      cat(paste0("Linear mixed model for '", names(object$models)[i], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) cat(opar)
    }

    # glmm_lognorm -------------------------------------------------------------
    if (object$models[i] == 'glmm_lognorm') {
      cat(paste0("Log-normal mixed model for '", names(object$models)[i], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) cat(opar)
    }

    # glmm_logit ---------------------------------------------------------------
    if (object$models[i] == 'glmm_logit') {
      cat(paste0("Logistic mixed model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
    }

    # glmm_gamma ---------------------------------------------------------------
    if (object$models[i] == 'glmm_gamma') {
      cat(paste0("Gamma mixed model for '", names(object$models)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape: shape_", names(object$models)[i],
                 " = mu_", names(object$models)[i], "^2 * tau_", names(object$models)[i], "\n",
                 tab(), "- rate: rate_", names(object$models)[i],
                 " = mu_", names(object$models)[i], " * tau_", names(object$models)[i], "\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
      if (otherpars) cat(opar)
    }

    # glmm_poisson -------------------------------------------------------------
    if (object$models[i] == 'glmm_poisson') {
      cat(paste0("Poisson mixed model for '", names(object$models)[i], "'\n"))
    }

    # clmm ---------------------------------------------------------------------
    if (object$models[i] == 'clmm') {
      cat(paste0("Cumulative logit mixed model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars) cat(pv)
      if (regcoef) cat(rc)
    }
  }
}

#' @name list_models
#' @export
list_impmodels <- list_models



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
parameters <- function(object, mess = TRUE, warn = TRUE) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  args <- as.list(match.call())

  if (is.null(object$MCMC)) {
    if (mess)
    message(paste0("Note: '", args$object, "' does not contain MCMC samples."))
  }

  vnam <- object$mcmc_settings$variable.names
  if ('beta' %in% vnam) {
    pos <- grep('beta', vnam)
    vnam <- append(vnam, unique(c(colnames(object$data_list$Xc)[object$Mlist$cols_main$Xc],
                                  colnames(object$data_list$Xl)[object$Mlist$cols_main$Xl],
                                  colnames(object$data_list$Xic)[object$Mlist$cols_main$Xic],
                                  colnames(object$data_list$Xil)[object$Mlist$cols_main$Xil],
                                  colnames(object$data_list$Z)[object$Mlist$cols_main$Z])),
                   after = pos)[-pos]
  }

  return(vnam)
}
