#' List imputation models
#'
#' Print information on all models for incomplete covariates used in a JointAI object,
#' including the model type, names of the parameters used and hyperparameters.
#'
#' @inheritParams sharedParams
#' @param predvars logical; should information on the predictor variables be printed?
#' @param regcoef logical; should information on the regression coefficients be printed?
#' @param otherpars logical; should information on other parameters be printed?
#' @param priors logical; should information on the priors be printed?
#' @param refcat logical; should information on the reference category be printed?
#'
#' @section Note:
#' The models listed by this function are not the actual imputation models,
#' but the conditional models that are part of the specification of the joint
#' distribution of the data.
#' Briefly, the joint distribution is specified as a sequence of conditional
#' models
#' \deqn{p(y | x_1, x_2, x_3, ..., \theta) p(x_1|x_2, x_3, ..., \theta) p(x_2|x_3, ..., \theta) ...}
#' The actual imputation models are the full conditional distributions derived
#' from this joint distribution \eqn{p(x_1 | \cdot)}.
#' Even though the conditional distributions do not contain the outcome and all
#' other covariates in their linear predictor, since imputations are sampled
#' from the full conditional distributions, outcome and other covariates are
#' taken into account implicitly. For more details, see Erler et al. (2016).
#'
#' The function \code{list_impmodels} prints information on the conditional
#' distributions of the incomplete covariates (since they are what is specified;
#' the full-conditionals are automatically derived within JAGS). The outcome
#' is, thus, not part of the printed linear predictor, but is still included
#' during imputation.
#'
#'
#'
#' @references Erler, N. S., Rizopoulos, D., Rosmalen, J. V., Jaddoe,
#' V. W., Franco, O. H., & Lesaffre, E. M. (2016).
#' Dealing with missing covariates in epidemiologic studies: A comparison
#' between multiple imputation and a full Bayesian approach.
#' \emph{Statistics in Medicine}, 35(17), 2955-2974.
#'
#' @examples
#' # (set n.adapt = 0 and n.iter = 0 to prevent MCMC sampling to save computational time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0, n.iter = 0)
#'
#' list_impmodels(mod1)
#'
#'
#' @export

list_impmodels <- function(object, predvars = TRUE, regcoef = TRUE,
                           otherpars = TRUE, priors = TRUE, refcat = TRUE) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")


  for (i in seq_along(object$models)) {
    pv <- if (predvars)
      paste0("* Predictor variables: \n",
             tab(), add_breaks(paste(colnames(object$data_list$Xc)[
               object$imp_par_list[[names(object$models[i])]]$Xc_cols],
               collapse = ", ")), "\n")

    if (i > 1) cat("\n")
    if (object$models[i] %in% c("norm", "lognorm")) {
      type <- switch(object$models[i],
                     norm = list(lab = 'norm', name = "Normal"),
                     lognorm = list(lab = 'lognorm', name = "Log-normal"))

      cat(paste0(type$name, " imputation model for '", names(object$models)[i], "'\n"))
      if (predvars)
        cat(pv)
        # cat(paste0("* Predictor variables: \n",
        #            tab(), paste(colnames(object$data_list$Xc)[
        #              object$imp_par_list[[names(object$models[i])]]$Xc_cols],
        #              collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$models)[i], "start"],
                             object$K_imp[names(object$models)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ",
                            object$data_list[[paste0("mu_reg_", type$lab)]],
                            " and precision ",
                            object$data_list[[paste0("tau_reg_", type$lab)]], ")")
                   }, "\n"))
      if (otherpars)
        cat(paste0("* Pecision of '", names(object$models)[i], "':\n",
                   tab(), "tau_", names(object$models)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with scale parameter ",
                            object$data_list[[paste0("shape_tau_", type$lab)]], " and rate parameter ",
                            object$data_list[[paste0("rate_tau_", type$lab)]], ")")
                   }, "\n"))
    }

    # Gamma imputation model ----------------------------------------------------
    if (object$models[i] %in% c("gamma")) {
      cat(paste0("Gamma imputation model for '", names(object$models)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape: shape_", names(object$models)[i],
                 " = mu_", names(object$models)[i], "^2 * tau_", names(object$models)[i], "\n",
                 tab(), "- rate: rate_", names(object$models)[i],
                 " = mu_", names(object$models)[i], " * tau_", names(object$models)[i], "\n"))
      if (predvars)
        cat(pv)
        # cat(paste0("* Predictor variables: \n",
        #          tab(), paste(colnames(object$data_list$Xc)[
        #            object$imp_par_list[[names(object$models[i])]]$Xc_cols],
        #            collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$models)[i], "start"],
                             object$K_imp[names(object$models)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_gamma,
                   " and precision ", object$data_list$tau_reg_gamma, ")")
                   }, "\n"))
      if (otherpars)
        cat(paste0("* Pecision of '", names(object$models)[i], "':\n",
                   tab(), "tau_", names(object$models)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with scale parameter ",
                         object$data_list$shape_tau_gamma, " and rate parameter ",
                         object$data_list$rate_tau_gamma, ")")
                 }, "\n"))
    }

    # beta imputation model ----------------------------------------------------
    if (object$models[i] %in% c("beta")) {
      cat(paste0("Beta imputation model for '", names(object$models)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape 1: shape1_", names(object$models)[i],
                 " = mu_", names(object$models)[i], " * tau_", names(object$models)[i], "\n",
                 tab(), "- shape 2: shape2_", names(object$models)[i],
                 " = (1 - mu_", names(object$models)[i], ") * tau_", names(object$models)[i], "\n"))
      if (predvars)
        cat(pv)
        # cat(paste0("* Predictor variables: \n",
        #          tab(), paste(colnames(object$data_list$Xc)[
        #            object$imp_par_list[[names(object$models[i])]]$Xc_cols],
        #            collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$models)[i], "start"],
                             object$K_imp[names(object$models)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_beta,
                            " and precision ", object$data_list$tau_reg_beta, ")")
                   }, "\n"))
      if (otherpars)
        cat(paste0("* tau_", names(object$models)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with scale parameter ",
                            object$data_list$shape_tau_beta, " and rate parameter ",
                            object$data_list$rate_tau_beta, ")")
                   }, "\n"))
    }

    if (object$models[i] == "logit") {
      cat(paste0("Logistic imputation model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars)
        cat(pv)
        # cat(paste0("* Predictor variables: \n",
        #          tab(), add_breaks(paste(colnames(object$data_list$Xc)[
        #            object$imp_par_list[[names(object$models[i])]]$Xc_cols],
        #            collapse = ", ")), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$models)[i], "start"],
                             object$K_imp[names(object$models)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_logit,
                            " and precision ", object$data_list$tau_reg_logit, ")")
                   }, "\n"))
    }
    if (object$models[i] == "multilogit") {
      cat(paste0("Multinomial logit imputation model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars)
        cat(pv)
        # cat(paste0("* Predictor variables: \n",
        #            tab(), paste(colnames(object$data_list$Xc)[
        #              object$imp_par_list[[names(object$models[i])]]$Xc_cols],
        #              collapse = ", "), "\n"))
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
    if (object$models[i] == "cumlogit") {
      cat(paste0("Cumulative logit imputation model for '", names(object$models)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$Mlist$refs[[names(object$models)[i]]], "'\n"))
      if (predvars)
        cat(pv)
        # cat(paste0("* Predictor variables: \n",
        #            tab(), add_breaks(paste(colnames(object$data_list$Xc)[
        #              object$imp_par_list[[names(object$models[i])]]$Xc_cols],
        #              collapse = ", ")), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients (with",
                   if (!object$imp_par_list[[names(object$models[i])]]$intercept) "out",
                   " intercept): \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$models)[i], "start"],
                             object$K_imp[names(object$models)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_ordinal,
                            " and precision ", object$data_list$tau_reg_ordinal, ")")
                   }, "\n"))
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

    # longitudinal models
    if (object$models[i] == 'lmm') {
      cat(paste0("Linear mixed model for '", names(object$models)[i], "'\n"))
    }
    if (object$models[i] == 'glmm_logit') {
      cat(paste0("Logistic mixed model for '", names(object$models)[i], "'\n"))
    }
    if (object$models[i] == 'glmm_gamma') {
      cat(paste0("Gamma mixed model for '", names(object$models)[i], "'\n"))
    }
    if (object$models[i] == 'glmm_poisson') {
      cat(paste0("Poisson mixed model for '", names(object$models)[i], "'\n"))
    }
    if (object$models[i] == 'clmm') {
      cat(paste0("Ordinal mixed model for '", names(object$models)[i], "'\n"))
    }
  }
}

print_seq <- function(min, max) {
  if (min == max)
    max
  else
    paste0(min, ":", max)
}

add_breaks <- function(string) {
  m <- gregexpr(", ", string)[[1]]
  br <- ifelse(c(0, diff(as.numeric(m) %/% getOption('width'))) > 0, "\n", "")
  gsub("\n, ", ",\n  ", paste0(strsplit(string, ", ")[[1]], br, collapse = ", "))
}


#' Parameter names of an JointAI object
#'
#' Returns the names of the parameters/nodes of an object of class "JointAI" for
#' which a monitor is set.
#'
#' @inheritParams sharedParams
#' @param ... currently not used
#'
#' @examples
#' # (does not need MCMC samples to work, so we will set n.adapt = 0 and
#' # n.iter = 0 to reduce computational time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0, n.iter = 0)
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
    message(paste0("'", args$object, "' does not contain MCMC samples."))
  }

  vnam <- object$mcmc_settings$variable.names
  if ('beta' %in% vnam) {
    pos <- grep('beta', vnam)
    vnam <- append(vnam, unique(c(colnames(object$data_list$Xc),
                                  colnames(object$data_list$Xl),
                                  colnames(object$data_list$Xic),
                                  colnames(object$data_list$Xil),
                                  colnames(object$data_list$Z))),
                   after = pos)[-pos]
  }

  # if (!is.null(object$MCMC) & !setequal(vnam, colnames(object$MCMC[[1]])))
  #   stop('Difference beetween MCMC and vnam.')

  return(vnam)
}
