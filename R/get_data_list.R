
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
    l$cens <- as.numeric(unlist(Mlist$event == 0))
    l$ctime <- as.numeric(unlist(Mlist$y))
    l[[names(Mlist$y)]][Mlist$event == 0] <- NA
    l <- c(l, defs$surv)

    if (Mlist$ridge)
      tau_reg_surv <- NULL
  }

  # outcome specification for Cox PH models
  if (analysis_type %in% c('coxph', 'JM')) {

    l$event <- as.numeric(unlist(Mlist$event))

    gkw <- gauss_kronrod()$gkw
    gkx <- gauss_kronrod()$gkx

    ordgkx <- order(gkx)
    gkx <- gkx[ordgkx]

    l$gkw <- gkw[ordgkx]

    h0knots <- get_knots_h0(nkn = 5, Time = l[[Mlist$timevar]],
                            event = Mlist$event, gkx = gkx)

    l$Bmat_h0 <- splines::splineDesign(h0knots, l[[Mlist$timevar]], ord = 4)
    l$Bmat_h0s <- splines::splineDesign(h0knots,
                                        c(t(outer(l[[Mlist$timevar]]/2, gkx + 1))),
                                        ord = 4)
    l$zeros <- numeric(length(l[[Mlist$timevar]]))
    # l$priorTau.Bs.gammas <- diag(1, ncol(l$Bmat_h0))
    # l$priorMean.Bs.gammas = rep(0, ncol(l$Bmat_h0))
    l <- c(l, defs$surv)

    if (Mlist$ridge)
      tau_reg_surv <- NULL
  }

#
#   if (analysis_type == 'coxph_count') {
#     l[[names(Mlist$y)]] <- NULL
#
#     y <- unlist(Mlist$y)
#     etimes <- c(sort(unique(y[Mlist$event == 1])), max(y))
#     Y <- dN <- matrix(nrow = length(y), ncol = length(etimes) - 1,
#                       dimnames = list(subj = c(), time = c()))
#     for (j in 1:(length(etimes) - 1)) {
#       Y[, j] <- ifelse(y - etimes[j] + defs$coxph['eps'] > 0, 1, 0)
#       dN[, j] <- Y[, j] * ifelse(etimes[j + 1] - y - defs$coxph['eps'] > 0, 1, 0) * unlist(Mlist$event)
#     }
#
#     priorhaz <- numeric(length(etimes) - 1)
#     for (j in 1:(length(etimes) - 1)) {
#       priorhaz[j] <- defs$coxph['r'] * max(1e-10, etimes[j + 1] - etimes[j]) * defs$coxph['c']
#     }
#
#     Ylong <- melt_matrix(Y)
#     Ylong$dN <- melt_matrix(dN)$value
#
#     Ylong <- Ylong[order(Ylong$value, decreasing = T), ]
#
#     l$priorhaz <- priorhaz
#     l$subj <- Ylong$subj
#     l$time <- Ylong$time
#     l$RiskSet <- Ylong$value
#     l$dN <- Ylong$dN
#     l$nt <- length(etimes)
#     l$Idt <- ifelse(l$RiskSet == 0, 0, NA)
#     l$c <- defs$coxph["c"]
#     l <- c(l, defs$surv)
#
#     if (Mlist$ridge)
#       tau_reg_surv <- NULL
#   }


  # scaled versions of Xc, Xtrafo, Xl and Z
  l <- c(l,
         scaled$scaled_matrices[!sapply(scaled$scaled_matrices, is.null)]
  )

  if (is.null(models) & all(sapply(Mlist$cols_main, is.null)))
    l$Xc <- NULL

  if (!is.null(Mlist$Xcat)) l$Xcat <- data.matrix(Mlist$Xcat)
  if (!is.null(Mlist$Xlcat)) l$Xlcat <- data.matrix(Mlist$Xlcat)
  if (!is.null(Mlist$Xic)) l$Xic <- data.matrix(Mlist$Xic)
  if (!is.null(Mlist$Xil)) l$Xil <- data.matrix(Mlist$Xil)

  if (all(is.null(Mlist$cols_main$Xl),
          is.null(unlist(sapply(imp_par_list, '[[', 'Xl_cols'))))) {
    l$Xl <- NULL
  }

  if (any(models %in% c('norm', 'lognorm', 'lme', 'lmm', 'glmm_lognorm')) | (family == 'gaussian' & !Mlist$ridge))
    l <- c(l, defs$norm)
  else if (family == 'gaussian' & Mlist$ridge)
    l <- c(l, defs$norm[c("mu_reg_norm", "shape_tau_norm", "rate_tau_norm")])


  if ((family == 'binomial' & link == 'logit' & !Mlist$ridge) | any(models %in% c('logit', 'glmm_logit')))
    l <- c(l, defs$logit)
  else if (family == 'binomial' & link == 'logit' & Mlist$ridge)
    l <- c(l, defs$logit['mu_reg_logit'])


  if ((family == 'binomial' & link == "probit" & !Mlist$ridge) | any(models %in% c('probit')))
    l <- c(l, defs$probit)
  else if (family == 'binomial' & link == "probit" & !Mlist$ridge)
    l <- c(l, defs$probit["mu_reg_probit"])


  if ((family == 'Gamma' & !Mlist$ridge) | any(models %in% c('gamma', 'glmm_gamma')))
    l <- c(l, defs$gamma)
  else if (family == 'Gamma' & Mlist$ridge)
    l <- c(l, defs$gamma[c("mu_reg_gamma", "shape_tau_gamma", "rate_tau_gamma")])


  if ((family == 'poisson' & !Mlist$ridge) | any(models %in% c('glmm_poisson')))
    l <- c(l, defs$poisson)
  else if (family == 'poisson' & !Mlist$ridge)
    l <- c(l, defs$probit["mu_reg_poisson"])


  if (family == 'ordinal' & !Mlist$ridge | any(models %in% c('clmm', "cumlogit")))
    l <- c(l, defs$ordinal)
  else if (family == 'ordinal' & Mlist$ridge)
    l <- c(l, defs$ordinal[c("mu_reg_ordinal", "mu_delta_ordinal", "tau_delta_ordinal")])
  if (family == 'ordinal' & is.null(models) & all(sapply(Mlist$cols_main, is.null)))
    l$mu_reg_ordinal <- l$tau_reg_ordinal <- NULL


  if (any(models %in% c('beta')))
    l <- c(l, defs$beta)


  if (any(models %in% c('multilogit')))
    l <- c(l, defs$multinomial)


  if (analysis_type %in% c("lme", 'glme', 'clmm', 'JM') |
      any(models %in% c('lmm', "glmm_lognorm", 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm'))) {
    l <- c(l, defs$Z(Mlist$nranef))
    l$groups <- match(Mlist$groups, unique(Mlist$groups)) # can this be just Mlist$groups???
  }

  # Random effects hyperparameters for longitudinal covariates
  if (any(models %in% c('lmm', "glmm_lognorm", 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm'))) {
    nam <- names(models)[models %in% c('lmm',  'glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')]

    for (k in nam) {
      pars <- defs$Z(imp_par_list[[k]]$nranef)[c('RinvD', 'KinvD')]
      names(pars) <- paste0(names(pars), '_', k)
      l <- c(l, pars)
    }
  }

  if (analysis_type == 'JM') {
    l$Zgk <- l$Z[match(unique(l$groups), l$groups), , drop = FALSE]
    l$Zgk <- l$Zgk[rep(1:nrow(l$Zgk), each = length(gkw)), , drop = FALSE]

    if (Mlist$timevar %in% colnames(l$Zgk))
      l$Zgk[, Mlist$timevar] <- c(t(outer(l[[Mlist$timevar]]/2, gkx + 1)))

    l$survrow <- Mlist$survrow
  }


  return(list(data_list = Filter(Negate(is.null), l),
              scale_pars = scaled$scale_pars,
              hyperpars = defs)
  )
}



#' Get the default values for hyperparameters
#'
#' This function returns a list of default values for the hyperparameters.
#'
#' \strong{norm:} hyperparameters for normal and lognormal models
#' \tabular{ll}{
#' \code{mu_reg_norm} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_norm} \tab precision in the priors for regression coefficients\cr
#' \code{shape_tau_norm} \tab shape parameter in Gamma prior for precision of an imputed variable\cr
#' \code{rate_tau_norm} \tab rate parameter in Gamma prior for precision of an imputed variable
#' }
#'
#' \strong{gamma:} hyperparameters for Gamma models
#' \tabular{ll}{
#' \code{mu_reg_gamma} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_gamma} \tab precision in the priors for regression coefficients\cr
#' \code{shape_tau_gamma} \tab shape parameter in Gamma prior for precision of an imputed variable\cr
#' \code{rate_tau_gamma} \tab rate parameter in Gamma prior for precision of an imputed variable
#' }
#'
#' \strong{beta:} hyperparameters for beta models
#' \tabular{ll}{
#' \code{mu_reg_beta} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_beta} \tab precision in the priors for regression coefficients\cr
#' \code{shape_tau_beta} \tab shape parameter in Gamma prior for precision of imputed variable\cr
#' \code{rate_tau_beta} \tab rate parameter in Gamma prior for precision of imputed variable
#' }
#'
#' \strong{logit:} hyperparameters for logistic models
#' \tabular{ll}{
#' \code{mu_reg_logit} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_logit} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{probit:} hyperparameters for probit models
#' \tabular{ll}{
#' \code{mu_reg_logit} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_logit} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{multinomial:} hyperparameters for multinomial models
#' \tabular{ll}{
#' \code{mu_reg_multinomial} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_multinomial} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{ordinal:} hyperparameters for ordinal models
#' \tabular{ll}{
#' \code{mu_reg_ordinal} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_ordinal} \tab precision in the priors for regression coefficients\cr
#' \code{mu_delta_ordinal} \tab mean in the prior for the intercepts\cr
#' \code{tau_delta_ordinal} \tab precision in the priors for the intercepts
#' }
#'
#' \strong{Z:} function creating hyperparameters for the random effects in mixed models,
#' with output elements
#' \tabular{ll}{
#' \code{RinvD} \tab scale matrix in Wishart prior (*) for random effects covariance matrix\cr
#' \code{KinvD} \tab degrees of freedom in Wishart prior for random effects covariance matrix\cr
#' \code{shape_diag_RinvD} \tab shape parameter in Gamma prior for the diagonal elements of \code{RinvD}\cr
#' \code{rate_diag_RinvD} \tab rate parameter in Gamma prior for the diagonal elements of \code{RinvD}
#' }
#' (*) when there is only one random effect a Gamma distribution is used instead
#'     of the Wishart and \code{RinvD} and \code{KinvD} are \code{NULL}
#'
#' \strong{surv:} parameters for survival models (parametric and proportional hazard)
#' \tabular{ll}{
#' \code{mu_reg_surv} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_surv} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{coxph:} parameters for Cox proportional hazards models
#' \tabular{ll}{
#' \code{c} confidence in prior guess for the hazard function\tab \cr
#' \code{r} failure rate per unit time\tab \cr
#' \code{eps} time increment\tab
#' }
#'
#' @examples
#' default_hyperpars()
#'
#' # To change the hyperparameters:
#' hyp <- default_hyperpars()
#' hyp$norm['rate_tau_norm'] <- 1e-3
#' mod <- lm_imp(y ~ C1 + C2 + B1, data = wideDF, hyperpars = hyp, mess = FALSE)
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

    poisson = c(
      mu_reg_poisson = 0,
      tau_reg_poisson = 0.0001
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

    surv = c(mu_reg_surv = 0,
             tau_reg_surv = 0.001)#,

    # # only needed for counting process version of the cox model
    # coxph = c(c = 0.001,
    #           r = 0.1,
    #           eps = 1e-10
    #           )
  )
}

