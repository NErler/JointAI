#' List imputation models
#'
#' Print a information on all imputation models used in a JointAI object,
#' including the model type, names of the parameters used and hyperparameters.
#'
#' @inheritParams sharedParams
#' @param predvars logical; should information on the predictor variables be printed?
#' @param regcoef logical; should information on the regression coefficients be printed?
#' @param otherpars logical; should information on other parameters be printed?
#' @param priors logical; should information on the priors be printed?
#' @param refcat logical; should information on the reference category be printed?
#'
#' @examples
#' # (set n.adapt = 0 and n.iter = 0 to prevent MCMC sampling to save computational time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0, n.iter = 0)
#' list_impmodels(mod1)
#' @export

list_impmodels <- function(object, predvars = TRUE, regcoef = TRUE,
                           otherpars = TRUE, priors = TRUE, refcat = TRUE) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  for (i in seq_along(object$meth)) {
    if (i > 1) cat("\n")
    if (object$meth[i] %in% c("norm", "lognorm")) {
      type <- switch(object$meth[i],
                     norm = list(lab = 'norm', name = "Normal"),
                     lognorm = list(lab = 'lognorm', name = "Log-normal"))

      cat(paste0(type$name, " imputation model for '", names(object$meth)[i], "'\n"))
      if (predvars)
        cat(paste0("* Predictor variables: \n",
                   tab(), paste(colnames(object$data_list$Xc)[
                     object$imp_par_list[[names(object$meth[i])]]$Xc_cols],
                     collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$meth)[i], "start"],
                             object$K_imp[names(object$meth)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ",
                            object$data_list[[paste0("mu_reg_", type$lab)]],
                            " and precision ",
                            object$data_list[[paste0("tau_reg_", type$lab)]], ")")
                   }, "\n"))
      if (otherpars)
        cat(paste0("* Pecision of '", names(object$meth)[i], "':\n",
                   tab(), "tau_", names(object$meth)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with scale parameter ",
                            object$data_list[[paste0("a_tau_", type$lab)]], " and rate parameter ",
                            object$data_list[[paste0("b_tau_", type$lab)]], ")")
                   }, "\n"))
    }

    # Gamma imputation model ----------------------------------------------------
    if (object$meth[i] %in% c("gamma")) {
      cat(paste0("Gamma imputation model for '", names(object$meth)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape: shape_", names(object$meth)[i],
                 " = mu_", names(object$meth)[i], "^2 * tau_", names(object$meth)[i], "\n",
                 tab(), "- rate: rate_", names(object$meth)[i],
                 " = mu_", names(object$meth)[i], " * tau_", names(object$meth)[i], "\n"))
      if (predvars)
        cat(paste0("* Predictor variables: \n",
                 tab(), paste(colnames(object$data_list$Xc)[
                   object$imp_par_list[[names(object$meth[i])]]$Xc_cols],
                   collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$meth)[i], "start"],
                             object$K_imp[names(object$meth)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_gamma,
                   " and precision ", object$data_list$tau_reg_gamma, ")")
                   }, "\n"))
      if (otherpars)
        cat(paste0("* Pecision of '", names(object$meth)[i], "':\n",
                   tab(), "tau_", names(object$meth)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with scale parameter ",
                         object$data_list$a_tau_gamma, " and rate parameter ",
                         object$data_list$b_tau_gamma, ")")
                 }, "\n"))
    }

    # beta imputation model ----------------------------------------------------
    if (object$meth[i] %in% c("beta")) {
      cat(paste0("Beta imputation model for '", names(object$meth)[i], "'\n"))
      cat(paste0("* Parametrization:\n",
                 tab(), "- shape 1: shape1_", names(object$meth)[i],
                 " = mu_", names(object$meth)[i], " * tau_", names(object$meth)[i], "\n",
                 tab(), "- shape 2: shape2_", names(object$meth)[i],
                 " = (1 - mu_", names(object$meth)[i], ") * tau_", names(object$meth)[i], "\n"))
      if (predvars)
        cat(paste0("* Predictor variables: \n",
                 tab(), paste(colnames(object$data_list$Xc)[
                   object$imp_par_list[[names(object$meth[i])]]$Xc_cols],
                   collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$meth)[i], "start"],
                             object$K_imp[names(object$meth)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_beta,
                            " and precision ", object$data_list$tau_reg_beta, ")")
                   }, "\n"))
      if (otherpars)
        cat(paste0("* tau_", names(object$meth)[i], " ",
                   if (priors) {
                     paste0("(Gamma prior with scale parameter ",
                            object$data_list$a_tau_beta, " and rate parameter ",
                            object$data_list$b_tau_beta, ")")
                   }, "\n"))
    }

    if (object$meth[i] == "logit") {
      cat(paste0("Logistic imputation model for '", names(object$meth)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$refcats[[names(object$meth)[i]]], "'\n"))
      if (predvars)
        cat(paste0("* Predictor variables: \n",
                 tab(), paste(colnames(object$data_list$Xc)[
                   object$imp_par_list[[names(object$meth[i])]]$Xc_cols],
                   collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients: \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$meth)[i], "start"],
                             object$K_imp[names(object$meth)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_logit,
                            " and precision ", object$data_list$tau_reg_logit, ")")
                   }, "\n"))
    }
    if (object$meth[i] == "multilogit") {
      cat(paste0("Multinomial logit imputation model for '", names(object$meth)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$refcats[[names(object$meth)[i]]], "'\n"))
      if (predvars)
        cat(paste0("* Predictor variables: \n",
                 tab(), paste(colnames(object$data_list$Xc)[
                   object$imp_par_list[[names(object$meth[i])]]$Xc_cols],
                   collapse = ", "), "\n"))
      if (regcoef) {
        cat(paste0("* Regression coefficients: \n"))
        for (j in seq_along(attr(object$refcats[[names(object$meth)[i]]], "dummies"))) {
          cat(paste0(tab(), "- '",
                     attr(object$refcats[[names(object$meth)[i]]], "dummies")[j],
                     "': alpha[",
                     print_seq(object$K_imp[attr(object$refcats[[names(object$meth)[i]]],
                                                 "dummies")[j], "start"],
                               object$K_imp[attr(object$refcats[[names(object$meth)[i]]],
                                                 "dummies")[j],  "end"]),
                     "] ",
                     if (priors) {
                       paste0("(normal prior(s) with mean ", object$data_list$mu_reg_multinomial,
                              " and precision ", object$data_list$tau_reg_multinomial, ")")
                     }, "\n"))
        }
      }
    }
    if (object$meth[i] == "cumlogit") {
      cat(paste0("Cumulative logit imputation model for '", names(object$meth)[i], "'\n"))
      if (refcat)
        cat(paste0("* Reference category: '", object$refcats[[names(object$meth)[i]]], "'\n"))
      if (predvars)
        cat(paste0("* Predictor variables: \n",
                   tab(), paste(colnames(object$data_list$Xc)[
                     object$imp_par_list[[names(object$meth[i])]]$Xc_cols],
                     collapse = ", "), "\n"))
      if (regcoef)
        cat(paste0("* Regression coefficients (with",
                   if (!object$imp_par_list[[names(object$meth[i])]]$intercept) "out",
                   " intercept): \n",
                   tab(), "alpha[",
                   print_seq(object$K_imp[names(object$meth)[i], "start"],
                             object$K_imp[names(object$meth)[i], "end"]),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ", object$data_list$mu_reg_ordinal,
                            " and precision ", object$data_list$tau_reg_ordinal, ")")
                   }, "\n"))
      if (otherpars) {
        cat(paste0("* Intercepts:\n",
                   tab(), "- ", levels(object$refcats[[names(object$meth)[i]]])[1],
                   ": gamma_", names(object$meth)[i],
                   "[1] ",
                   if (priors) {
                     paste0("(normal prior with mean ",  object$data_list$mu_delta_ordinal,
                            " and precision ", object$data_list$tau_delta_ordinal, ")")
                   }, "\n"))
        for (j in 2:length(attr(object$refcats[[names(object$meth)[i]]], "dummies"))) {
          cat(paste0(tab(), "- ", levels(object$refcats[[names(object$meth)[i]]])[j],
                     ": gamma_", names(object$meth)[i], "[", j, "] = gamma_",
                     names(object$meth)[i], "[", j-1, "] + exp(delta_",
                     names(object$meth)[i], "[", j-1, "])\n"))
        }
        cat(paste0("* Increments:\n",
                   tab(), "delta_", names(object$meth)[i],
                   "[",print_seq(1, length(levels(object$refcats[[names(object$meth)[i]]])) - 2),
                   "] ",
                   if (priors) {
                     paste0("(normal prior(s) with mean ",  object$data_list$mu_delta_ordinal,
                            " and precision ", object$data_list$tau_delta_ordinal, ")")
                   }, "\n"))
      }
    }
  }
}

print_seq <- function(min, max) {
  if (min == max)
    max
  else
    paste0(min, ":", max)
}


#' Parameter names of an JointAI object
#'
#' Returns the names of the parameters/nodes of an object of class JointAI.
#' If the object does not contain any MCMC samples, the parameters/nodes for
#' which a monitor is set is returned
#'
#' @inheritParams sharedParams
#' @param ... currently not used
#'
#' @examples
#' # (does not need MCMC samples to work, so we will set n.adapt = 0 and
#' # n.iter = 0 to save computational time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0, n.iter = 0)
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
