# Create list of data passed to JAGS
# @param analysis_type analysis model type
# @param meth vector of imputation methods
# @param Mlist list of data matrices etc.
# @export
get_data_list <- function(analysis_type, family, link, meth, Mlist, K, auxvars,
                          scale_pars = NULL, hyperpars = NULL, data) {

  scaled <- get_scaling(Mlist, scale_pars, meth, data)
  if (is.null(hyperpars)) {
    defs <- default_hyperpars(family, link, ncol(Mlist$Z))
  } else {
    defs <- hyperpars
  }

  l <- list()
  l[[names(Mlist$y)]] <- if (any(sapply(Mlist$y, is.factor))) {
    c(sapply(Mlist$y, as.numeric) - 1)
  } else {
    unname(unlist(Mlist$y))
  }
  l <- c(l,
         scaled$scaled_matrices[!sapply(scaled$scaled_matrices, is.null)]
  )
  if (!is.null(Mlist$Xcat))  l$Xcat <- data.matrix(Mlist$Xcat)
  if (!is.null(Mlist$Xic)) l$Xic <- data.matrix(Mlist$Xic)
  if (!is.null(Mlist$Xil)) l$Xil <- data.matrix(Mlist$Xil)
  if (!is.null(Mlist$Xtrafo)) l$Xtrafo <- data.matrix(Mlist$Xtrafo)


  # hyperparameters analysis model
  l$mu_reg_main <- defs$analysis_model["mu_reg_main"]
  l$tau_reg_main <- defs$analysis_model["tau_reg_main"]
  if (!family %in% c("binomial", "poisson")) {
    l$a_tau_main <- defs$analysis_model["a_tau_main"]
    l$b_tau_main <- defs$analysis_model["b_tau_main"]
  }


  if (analysis_type == "lme") {
    l$groups <- match(Mlist$groups, unique(Mlist$groups))
    if (ncol(Mlist$Z) > 1) {
      l$RinvD <- defs$Z$RinvD
      l$KinvD <- defs$Z$KinvD
    }
    l$a_diag_RinvD <- defs$Z$a_diag_RinvD
    l$b_diag_RinvD <- defs$Z$b_diag_RinvD
  }

  # hyperparameters imputation models
  if (any(meth %in% c("norm", "lognorm"))) {
    l$mu_reg_norm <- defs$norm["mu_reg_norm"]
    l$tau_reg_norm <- defs$norm["tau_reg_norm"]
    l$a_tau_norm <- defs$norm["a_tau_norm"]
    l$b_tau_norm <- defs$norm["b_tau_norm"]
  }

  if (any(meth == "logit")) {
    l$mu_reg_logit <- defs$logit["mu_reg_logit"]
    l$tau_reg_logit <- defs$logit["tau_reg_logit"]
  }

  if (any(meth == "multilogit")) {
    l$mu_reg_multinomial <- defs$multinomial["mu_reg_multinomial"]
    l$tau_reg_multinomial <- defs$multinomial["tau_reg_multinomial"]
  }

  if (any(meth == "cumlogit")) {
    l$mu_reg_ordinal <- defs$ordinal["mu_reg_ordinal"]
    l$tau_reg_ordinal <- defs$ordinal["tau_reg_ordinal"]
    l$mu_delta_ordinal <- defs$ordinal["mu_delta_ordinal"]
    l$tau_delta_ordinal <- defs$ordinal["tau_delta_ordinal"]
  }

  if (!is.null(Mlist$auxvars)) {
    l$beta <- setNames(rep(NA, max(K, na.rm = T)), get_coef_names(Mlist, K)[, 2])
    nams <- sapply(Mlist$auxvars, function(x) {
      if (x %in% names(Mlist$refs)) {
        paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) !=
                                            Mlist$refs[[x]]])
      } else {
        x
      }
    })
    l$beta[unlist(nams)] <- 0
  }

  return(list(data_list = l,
              scale_pars = scaled$scale_pars))
}



#' Get default values for hyperparameters
#' Prints the list of default values for the hyperparameters
#' @param family distribution family of the analysis model
#'               (\code{gaussian}, \code{binomial}, \code{poisson} or \code{Gamma})
#' @param link link function (if the link is already given in the family,
#'             e.g. \code{family = binomial("logit"))} this argument does not
#'             need to be specified
#' @param nranef number of random effects
#'
#' @section Value:
#' A list containing the default hyperparameters for JointAI models. The elements
#' of the list are
#'
#' \strong{analysis_model:} hyperparameters for the analysis model
#' \tabular{ll}{
#' \code{mu_reg_main} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_main} \tab precision in the priors for regression coefficients\cr
#' \code{a_tau_main} \tab scale parameter in gamma prior for precision of outcome\cr
#' \code{b_tau_main} \tab rate parameter in gamma prior for precision of outcome\cr
#' }
#'
#' \strong{Z:} hyperparameters for the random effects in mixed models
#' \tabular{ll}{
#' \code{RinvD} \tab scale matrix in Wishart prior (*) for random effects covariance matrix\cr
#' \code{KinvD} \tab degrees of freedom in Wishart prior for random effects covariance matrix\cr
#' \code{a_diag_RinvD} \tab scale parameter in gamma prior for the diagonal elements of \code{RinvD}\cr
#' \code{b_diag_RinvD} \tab rate parameter in gamma prior for the diagonal elements of \code{RinvD}\cr
#' }
#' (*) when there is only one random effect a gamma distribution is used instead of the Wishart
#'
#' \strong{norm:} hyperparameters for normal and lognormal imputation models
#' \tabular{ll}{
#' \code{mu_reg_norm} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_norm} \tab precision in the priors for regression coefficients\cr
#' \code{a_tau_norm} \tab scale parameter in gamma prior for precision of imputed variable\cr
#' \code{b_tau_norm} \tab rate parameter in gamma prior for precision of imputed variable\cr
#' }
#'
#' \strong{logit:} hyperparameters for logistic imputation models
#' \tabular{ll}{
#' \code{mu_reg_logit} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_logit} \tab precision in the priors for regression coefficients\cr
#' }
#'
#' \strong{multinomial:} hyperparameters for multinomial imputation models
#' \tabular{ll}{
#' \code{mu_reg_multinomial} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_multinomial} \tab precision in the priors for regression coefficients\cr
#' }
#'
#' \strong{ordinal:} hyperparameters for ordinal imputation models
#' \tabular{ll}{
#' \code{mu_reg_ordinal} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_ordinal} \tab precision in the priors for regression coefficients\cr
#' \code{mu_delta_ordinal} \tab mean in the prior for the intercepts\cr
#' \code{tau_delta_ordinal} \tab precision in the priors for the intercepts\cr
#' }
#'

#' @export

default_hyperpars <- function(family = 'gaussian', link = "identity", nranef = NULL) {

  if (is.character(family)) {
    family <- get(family, mode = "function", envir = parent.frame())
    thefamily <- family()$family
    thelink <- family()$link
  }

  if (is.function(family)) {
    thefamily <- family()$family
    thelink <- family()$link
  }

  if (inherits(family, "family")) {
    thefamily <- family$family
    thelink <- family$link
  }


  # hyperparameters analysis model
  if (thefamily == "binomial" & thelink == "logit") {
    tau_reg_main <- 4/9
  } else if (thefamily == "binomial" & thelink == "probit") {
    tau_reg_main <- 1
  } else {
    tau_reg_main <- 0.0001
  }

  analysis_model <- c(
    mu_reg_main = 0,
    tau_reg_main = tau_reg_main,
    a_tau_main = 0.01,
    b_tau_main = 0.001
  )


  # hyperparameters for random effects
  Z <- if (!is.null(nranef)) {
    if (nranef > 1) {
      RinvD <- diag(as.numeric(rep(NA, nranef)))
      KinvD <- nranef
    } else {
      RinvD <- matrix(ncol = 1, nrow = 1, NA)
      KinvD <- NULL
    }

    list(
      RinvD = RinvD,
      KinvD = KinvD,
      a_diag_RinvD = 0.1,
      b_diag_RinvD = 0.01
    )
  }

  # hyperparameters imputation models
  norm <- c(
    mu_reg_norm = 0,
    tau_reg_norm = 0.0001,
    a_tau_norm = 0.01,
    b_tau_norm = 0.01
  )

  logit <- c(
    mu_reg_logit = 0,
    tau_reg_logit = 4/9
  )

  multinomial <- c(
    mu_reg_multinomial = 0,
    tau_reg_multinomial = 4/9
  )

  ordinal <- c(
    mu_reg_ordinal = 0,
    tau_reg_ordinal = 4/9,
    mu_delta_ordinal = 0,
    tau_delta_ordinal = 4/9
  )


  hyperpars <- list(
    analysis_model = analysis_model,
    Z = Z,
    norm = norm,
    logit = logit,
    multinomial = multinomial,
    ordinal = ordinal
  )

  hyperpars
}
