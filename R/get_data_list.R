# Create list of data passed to JAGS
# @param analysis_type analysis model type
# @param models vector of imputation modelsods
# @param Mlist list of data matrices etc.
# @export
# get_data_list_old <- function(analysis_type, family, link, models, Mlist, auxvars,
#                           scale_pars = NULL, hyperpars = NULL, data, imp_par_list) {
#
#   scaled <- get_scaling(Mlist, scale_pars, models, data)
#   if (is.null(hyperpars)) {
#     defs <- default_hyperpars_old(family, link, Mlist$nranef)
#   } else {
#     defs <- hyperpars
#   }
#
#   l <- list()
#   l[[names(Mlist$y)]] <- if (any(sapply(Mlist$y, is.factor))) {
#     if (analysis_type %in% c('clmm', 'clm')) {
#       c(sapply(Mlist$y, as.numeric))
#     } else {
#       c(sapply(Mlist$y, as.numeric) - 1)
#     }
#   } else {
#     unname(unlist(Mlist$y))
#   }
#   l <- c(l,
#          scaled$scaled_matrices[!sapply(scaled$scaled_matrices, is.null)]
#   )
#   if (!is.null(Mlist$Xcat))  l$Xcat <- data.matrix(Mlist$Xcat)
#   if (!is.null(Mlist$Xic)) l$Xic <- data.matrix(Mlist$Xic)
#   if (!is.null(Mlist$Xil)) l$Xil <- data.matrix(Mlist$Xil)
#   # if (!is.null(Mlist$Xtrafo)) l$Xtrafo <- data.matrix(Mlist$Xtrafo)
#
#
#   # hyperparameters analysis model
#   l$mu_reg_main <- defs$analysis_model["mu_reg_main"]
#   l$tau_reg_main <- if (!Mlist$ridge) defs$analysis_model["tau_reg_main"]
#   if (family %in% c('gaussian', 'Gamma')) {
#     l$a_tau_main <- defs$analysis_model["a_tau_main"]
#     l$b_tau_main <- defs$analysis_model["b_tau_main"]
#   }
#   if (family == 'ordinal') {
#     l$mu_delta_main <- defs$analysis_model["mu_delta_main"]
#     l$tau_delta_main <- defs$analysis_model["tau_delta_main"]
#   }
#
#
#   if (analysis_type %in% c("lme", "glme", "clmm")) {
#     l$groups <- match(Mlist$groups, unique(Mlist$groups))
#     if (Mlist$nranef > 1) {
#       l$RinvD <- defs$Z$RinvD
#       l$KinvD <- defs$Z$KinvD
#     }
#     l$a_diag_RinvD <- defs$Z$a_diag_RinvD
#     l$b_diag_RinvD <- defs$Z$b_diag_RinvD
#   }
#
#   if (analysis_type == "survreg") {
#     l$cens <- as.numeric(unlist(Mlist$cens == 0))
#     l$ctime <- as.numeric(unlist(Mlist$y))
#     # l$ctime[Mlist$cens == 0] <- Mlist$y[Mlist$cens == 0]
#     l[[names(Mlist$y)]][Mlist$cens == 0] <- NA
#   }
#
#   if (analysis_type == 'coxph') {
#     l[[names(Mlist$y)]] <- NULL
#     l$c <- defs$analysis_model[['c']]
#
#     y <- unlist(Mlist$y)
#     ts <- sort(unique(y))
#     Y <- dN <- matrix(nrow = length(y), ncol = length(ts) - 1,
#                       dimnames = list(subj = c(), time = c()))
#
#     for (i in seq_along(y)) {
#       for (j in 1:(length(ts) - 1)) {
#         Y[i, j] <- ifelse(y[i] - ts[j] + defs$analysis_model[['eps']] > 0, 1, 0)
#         dN[i, j] <- Y[i, j] * ifelse(ts[j + 1] - y[i] - defs$analysis_model[['eps']] > 0, 1, 0) * unlist(Mlist$cens)[i]
#       }
#     }
#
#     dL0.star <- priorhaz <- numeric(length(ts) - 1)
#     for (j in 1:(length(ts) - 1)) {
#       dL0.star[j] <- defs$analysis_model[['r']] * (ts[j + 1] - ts[j])
#       priorhaz[j] <- dL0.star[j] * l$c
#     }
#     Ylong <- reshape2::melt(Y)
#     Ylong$dN <- reshape2::melt(dN)$value
#
#     Ylong <- Ylong[order(Ylong$value, decreasing = T), ]
#
#     l$priorhaz <- priorhaz
#     l$subj <- Ylong$subj
#     l$time <- Ylong$time
#     l$RiskSet <- Ylong$value
#     l$dN <- Ylong$dN
#     l$nt <- length(ts)
#     l$Idt <- ifelse(l$RiskSet == 0, 0, NA)
#   }
#
#   # hyperparameters imputation models
#   if (any(models %in% c("norm"))) {
#     l$mu_reg_norm <- defs$norm["mu_reg_norm"]
#     l$tau_reg_norm <- defs$norm["tau_reg_norm"]
#     l$a_tau_norm <- defs$norm["a_tau_norm"]
#     l$b_tau_norm <- defs$norm["b_tau_norm"]
#   }
#
#   if (any(models %in% c("lognorm"))) {
#     l$mu_reg_lognorm <- defs$norm["mu_reg_norm"]
#     l$tau_reg_lognorm <- defs$norm["tau_reg_norm"]
#     l$a_tau_lognorm <- defs$norm["a_tau_norm"]
#     l$b_tau_lognorm <- defs$norm["b_tau_norm"]
#   }
#
#   if (any(models %in% c("gamma"))) {
#     l$mu_reg_gamma <- defs$gamma["mu_reg_gamma"]
#     l$tau_reg_gamma <- defs$gamma["tau_reg_gamma"]
#     l$a_tau_gamma <- defs$gamma["a_tau_gamma"]
#     l$b_tau_gamma <- defs$gamma["b_tau_gamma"]
#   }
#
#   if (any(models %in% c("beta"))) {
#     l$mu_reg_beta <- defs$beta["mu_reg_beta"]
#     l$tau_reg_beta <- defs$beta["tau_reg_beta"]
#     l$a_tau_beta <- defs$beta["a_tau_beta"]
#     l$b_tau_beta <- defs$beta["b_tau_beta"]
#   }
#
#   if (any(models == "logit")) {
#     l$mu_reg_logit <- defs$logit["mu_reg_logit"]
#     l$tau_reg_logit <- defs$logit["tau_reg_logit"]
#   }
#
#   if (any(models == "multilogit")) {
#     l$mu_reg_multinomial <- defs$multinomial["mu_reg_multinomial"]
#     l$tau_reg_multinomial <- defs$multinomial["tau_reg_multinomial"]
#   }
#
#   if (any(models == "cumlogit")) {
#     l$mu_reg_ordinal <- defs$ordinal["mu_reg_ordinal"]
#     l$tau_reg_ordinal <- defs$ordinal["tau_reg_ordinal"]
#     l$mu_delta_ordinal <- defs$ordinal["mu_delta_ordinal"]
#     l$tau_delta_ordinal <- defs$ordinal["tau_delta_ordinal"]
#   }
#
#   if (any(models %in% c('lmm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm'))) {
#     nam <- names(models)[models %in% c('lmm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')]
#     for (k in nam) {
#       l[[paste0('RinvD_', k)]] <- if (imp_par_list[[k]]$nranef > 1) {
#         diag(as.numeric(rep(NA, imp_par_list[[k]]$nranef)))
#       } else {
#         NULL#matrix(ncol = 1, nrow = 1, NA)
#       }
#       l[[paste0('KinvD_', k)]] <- if (imp_par_list[[k]]$nranef > 1) imp_par_list[[k]]$nranef
#     }
#   }
#
#   # if (!is.null(Mlist$auxvars)) {
#   #   # l$beta <- setNames(rep(NA, max(K, na.rm = TRUE)), get_coef_names(Mlist, K)[, 2])
#   #   l$beta <- rep(NA, max(K, na.rm = T))
#   #   names(l$beta)[min(K, na.rm = T) : max(K, na.rm = T)] <- get_coef_names(Mlist, K)[, 2]
#   #   nams <- sapply(Mlist$auxvars, function(x) {
#   #     if (x %in% names(Mlist$refs)) {
#   #       paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) !=
#   #                                           Mlist$refs[[x]]])
#   #     } else {
#   #       x
#   #     }
#   #   })
#   #   l$beta[unlist(nams)] <- 0
#   # }
#
#   return(list(data_list = l,
#               scale_pars = scaled$scale_pars,
#               hyperpars = defs))
# }




get_data_list <- function(analysis_type, family, link, models, Mlist,
                          scale_pars = NULL, hyperpars = NULL, data, imp_par_list) {

  # scale the data
  scaled <- get_scaling(Mlist, scale_pars, models, data)

  # get hyperparameters
  if (is.null(hyperpars)) {
    defs <- default_hyperpars()
  } else {
    defs <- hyperpars
  }

  l <- list()

  # outcome variable
  l[[names(Mlist$y)]] <- if (any(sapply(Mlist$y, is.factor))) {
    if (analysis_type %in% c('clmm', 'clm')) {
      # ordinal variables have values 1, 2, 3, ...
      c(sapply(Mlist$y, as.numeric))
    } else {
      # binary variables have values 0, 1
      c(sapply(Mlist$y, as.numeric) - 1)
    }
  } else {
    # continuous outcomes
    unname(unlist(Mlist$y))
  }


  # outcome specification for parametric survival models
  if (analysis_type == "survreg") {
    l$cens <- as.numeric(unlist(Mlist$cens == 0))
    l$ctime <- as.numeric(unlist(Mlist$y))
    l[[names(Mlist$y)]][Mlist$cens == 0] <- NA
  }

  # outcome specification for Cox PH models
  if (analysis_type == 'coxph') {
    l[[names(Mlist$y)]] <- NULL
    l$c <- defs$coxph['c']

    y <- unlist(Mlist$y)
    ts <- sort(unique(y))
    Y <- dN <- matrix(nrow = length(y), ncol = length(ts) - 1,
                      dimnames = list(subj = c(), time = c()))

    for (i in seq_along(y)) {
      for (j in 1:(length(ts) - 1)) {
        Y[i, j] <- ifelse(y[i] - ts[j] + defs$coxph['eps'] > 0, 1, 0)
        dN[i, j] <- Y[i, j] * ifelse(ts[j + 1] - y[i] - defs$coxph['eps'] > 0, 1, 0) * unlist(Mlist$cens)[i]
      }
    }

    dL0.star <- priorhaz <- numeric(length(ts) - 1)
    for (j in 1:(length(ts) - 1)) {
      dL0.star[j] <- defs$coxph['r'] * (ts[j + 1] - ts[j])
      priorhaz[j] <- dL0.star[j] * l$c
    }
    Ylong <- reshape2::melt(Y)
    Ylong$dN <- reshape2::melt(dN)$value

    Ylong <- Ylong[order(Ylong$value, decreasing = T), ]

    l$priorhaz <- priorhaz
    l$subj <- Ylong$subj
    l$time <- Ylong$time
    l$RiskSet <- Ylong$value
    l$dN <- Ylong$dN
    l$nt <- length(ts)
    l$Idt <- ifelse(l$RiskSet == 0, 0, NA)
  }


  # scaled versions of Xc, Xtrafo, Xl and Z
  l <- c(l,
         scaled$scaled_matrices[!sapply(scaled$scaled_matrices, is.null)]
  )

  if (is.null(models) & family == 'ordinal')
    l$Xc <- NULL

  if (!is.null(Mlist$Xcat)) l$Xcat <- data.matrix(Mlist$Xcat)
  if (!is.null(Mlist$Xic)) l$Xic <- data.matrix(Mlist$Xic)
  if (!is.null(Mlist$Xil)) l$Xil <- data.matrix(Mlist$Xil)


  if (any(models %in% c('norm', 'lognorm', 'lme', 'lmm')) | (family == 'gaussian' & !Mlist$ridge))
    l <- c(l, defs$norm)
  else if(family == 'gaussian' & Mlist$ridge)
    l <- c(l, defs$norm["mu_reg_norm", "shape_tau_norm", "rate_tau_norm"])


  if ((family == 'binomial' & link == 'logit' & !Mlist$ridge) | any(models %in% c('logit', 'glmm_logit')))
    l <- c(l, defs$logit)
  else if(family == 'binomial' & link == 'logit' & Mlist$ridge)
    l <- c(l, defs$logit['mu_reg_logit'])


  if ((family == 'binomial' & link == "probit" & !Mlist$ridge) | any(models %in% c('probit')))
    l <- c(l, defs$probit)
  else if (family == 'binomial' & link == "probit" & !Mlist$ridge)
    l <- c(l, defs$probit["mu_reg_probit"])


  if ((family == 'Gamma' & !Mlist$ridge) | any(models %in% c('gamma')))
    l <- c(l, defs$gamma)
  else if (family == 'Gamma' & Mlist$ridge)
    l <- c(l, defs$gamma["mu_reg_gamma", "shape_tau_gamma", "rate_tau_gamma"])


  if (family == 'ordinal' & !Mlist$ridge | any(models %in% c('clmm', "cumlogit")))
    l <- c(l, defs$ordinal)
  else if (family == 'ordinal' & Mlist$ridge)
    l <- c(l, defs$ordinal["mu_reg_ordinal", "mu_delta_ordinal", "tau_delta_ordinal"])
  if (family == 'ordinal' & is.null(models))
    l$mu_reg_ordinal <- l$tau_reg_ordinal <- NULL


  if (any(models %in% c('beta')))
    l <- c(l, defs$beta)


  if (any(models %in% c('multilogit')))
    l <- c(l, defs$multinomial)


  if (analysis_type %in% c("lme", 'glme', 'clmm')) {
    l <- c(l, defs$Z(Mlist$nranef))
    l$groups <- match(Mlist$groups, unique(Mlist$groups)) # can this be just Mlist$groups???
  }

  # Random effects hyperparameters for longitudinal covariates
  if (any(models %in% c('lmm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm'))) {
    nam <- names(models)[models %in% c('lmm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')]

    for (k in nam) {
      pars <- defs$Z(imp_par_list[[k]]$nranef)[c('RinvD', 'KinvD')]
      names(pars) <- paste0(names(pars), '_', k)
      l <- c(l, pars)
    }
  }
  return(list(data_list = Filter(Negate(is.null), l),
              scale_pars = scaled$scale_pars,
              hyperpars = defs)
  )
}



#' Get default values for hyperparameters
#'
#' Prints the list of default values for the hyperparameters.
# @param family distribution family of the analysis model
#               (\code{gaussian}, \code{binomial}, \code{poisson} or \code{Gamma})
# @param link link function (if the link is already given in the family,
#             e.g. \code{family = binomial("logit"))} this argument does not
#             need to be specified
# @param nranef number of random effects
#
# @section Value:
# A list containing the default hyperparameters for JointAI models. The elements
# of the list are
#'
#' \strong{analysis_model:} hyperparameters for the analysis model
#' \tabular{ll}{
#' \code{mu_reg_main} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_main} \tab precision in the priors for regression coefficients\cr
#' \code{a_tau_main} \tab scale parameter in Gamma prior for precision of outcome\cr
#' \code{b_tau_main} \tab rate parameter in Gamma prior for precision of outcome
#' }
#'
#' \strong{Z:} hyperparameters for the random effects in mixed models
#' \tabular{ll}{
#' \code{RinvD} \tab scale matrix in Wishart prior (*) for random effects covariance matrix\cr
#' \code{KinvD} \tab degrees of freedom in Wishart prior for random effects covariance matrix\cr
#' \code{a_diag_RinvD} \tab scale parameter in Gamma prior for the diagonal elements of \code{RinvD}\cr
#' \code{b_diag_RinvD} \tab rate parameter in Gamma prior for the diagonal elements of \code{RinvD}
#' }
#' (*) when there is only one random effect a Gamma distribution is used instead of the Wishart
#'
#' \strong{norm:} hyperparameters for normal and lognormal imputation models
#' \tabular{ll}{
#' \code{mu_reg_norm} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_norm} \tab precision in the priors for regression coefficients\cr
#' \code{a_tau_norm} \tab scale parameter in Gamma prior for precision of imputed variable\cr
#' \code{b_tau_norm} \tab rate parameter in Gamma prior for precision of imputed variable
#' }
#'
#' \strong{gamma:} hyperparameters for Gamma imputation models
#' \tabular{ll}{
#' \code{mu_reg_gamma} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_gamma} \tab precision in the priors for regression coefficients\cr
#' \code{a_tau_gamma} \tab scale parameter in Gamma prior for precision of imputed variable\cr
#' \code{b_tau_gamma} \tab rate parameter in Gamma prior for precision of imputed variable
#' }
#'
#' \strong{beta:} hyperparameters for beta imputation models
#' \tabular{ll}{
#' \code{mu_reg_beta} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_beta} \tab precision in the priors for regression coefficients\cr
#' \code{a_tau_beta} \tab scale parameter in Gamma prior for precision of imputed variable\cr
#' \code{b_tau_beta} \tab rate parameter in Gamma prior for precision of imputed variable
#' }
#'
#' \strong{logit:} hyperparameters for logistic imputation models
#' \tabular{ll}{
#' \code{mu_reg_logit} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_logit} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{multinomial:} hyperparameters for multinomial imputation models
#' \tabular{ll}{
#' \code{mu_reg_multinomial} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_multinomial} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{ordinal:} hyperparameters for ordinal imputation models
#' \tabular{ll}{
#' \code{mu_reg_ordinal} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_ordinal} \tab precision in the priors for regression coefficients\cr
#' \code{mu_delta_ordinal} \tab mean in the prior for the intercepts\cr
#' \code{tau_delta_ordinal} \tab precision in the priors for the intercepts
#' }
#'
#'
#' @examples
#' default_hyperpars()
#'
#'
#' @export


default_hyperpars <- function() {
  list(
    norm = c(
      mu_reg_norm = 0,
      tau_reg_norm = 0.0001,
      shape_tau_norm = 0.01,
      rate_tau_norm = 0.01
    ),

    gamma = c(
      mu_reg_gamma = 0,
      tau_reg_gamma = 0.0001,
      shape_tau_gamma = 0.01,
      rate_tau_gamma = 0.01
    ),

    beta = c(
      mu_reg_beta = 0,
      tau_reg_beta = 0.0001,
      shape_tau_beta = 0.01,
      rate_tau_beta = 0.01
    ),

    logit = c(
      mu_reg_logit = 0,
      tau_reg_logit = 0.0001
    ),

    probit = c(
      mu_reg_probit = 0,
      tau_reg_probit = 0.0001
    ),

    multinomial = c(
      mu_reg_multinomial = 0,
      tau_reg_multinomial = 0.0001
    ),

    ordinal = c(
      mu_reg_ordinal = 0,
      tau_reg_ordinal = 0.0001,
      mu_delta_ordinal = 0,
      tau_delta_ordinal = 0.0001
    ),


    Z = function(nranef) {
      if (nranef > 1) {
        RinvD <- diag(as.numeric(rep(NA, nranef)))
        KinvD <- nranef
      } else {
        RinvD <- KinvD <- NULL
      }

      list(
        RinvD = RinvD,
        KinvD = KinvD,
        shape_diag_RinvD = 0.1,
        rate_diag_RinvD = 0.01
      )
    },

    coxph = c(c = 0.001,
              r = 0.1,
              eps = 1e-10)
  )
}

default_hyperpars_old <- function(family = 'gaussian', link = "identity", nranef = NULL) {

  if (is.character(family)) {
    # family <- get(family, mode = "function", envir = parent.frame())
    family <- get(family, mode = "function", envir = .getNamespace("JointAI"))
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
    tau_reg_main <- 0.001
  } else if (thefamily == "binomial" & thelink == "probit") {
    tau_reg_main <- 1
  } else {
    tau_reg_main <- 0.0001
  }

  if (thefamily == 'prophaz') {
    c <- 0.001
    r <- 0.1
    eps <- 1e-10
  } else {
    c <- r <- eps <- NULL
  }

  analysis_model <- c(
    mu_reg_main = 0,
    tau_reg_main = tau_reg_main,
    a_tau_main = 0.01,
    b_tau_main = 0.001,
    mu_delta_main = 0,
    tau_delta_main = 0.001,
    c = c,
    r = r,
    eps = eps
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

  gamma <- c(
    mu_reg_gamma = 0,
    tau_reg_gamma = 0.0001,
    a_tau_gamma = 0.01,
    b_tau_gamma = 0.01
  )

  beta <- c(
    mu_reg_beta = 0,
    tau_reg_beta = 0.0001,
    a_tau_beta = 0.01,
    b_tau_beta = 0.01
  )


  logit <- c(
    mu_reg_logit = 0,
    tau_reg_logit = 0.001
  )

  multinomial <- c(
    mu_reg_multinomial = 0,
    tau_reg_multinomial = 0.001
  )

  ordinal <- c(
    mu_reg_ordinal = 0,
    tau_reg_ordinal = 0.001,
    mu_delta_ordinal = 0,
    tau_delta_ordinal = 0.001
  )


  hyperpars <- list(
    analysis_model = analysis_model,
    Z = Z,
    norm = norm,
    gamma = gamma,
    beta = beta,
    logit = logit,
    multinomial = multinomial,
    ordinal = ordinal
  )

  hyperpars
}
