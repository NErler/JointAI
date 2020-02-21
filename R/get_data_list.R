

get_data_list <- function(Mlist, info_list, data) {
  modeltypes <- sapply(info_list, "[[", 'modeltype')

  l <- Mlist[c('Mc', 'Ml')]


  # scaling parameters
  if (any(!is.na(Mlist$scale_pars$Mc[
    unique(unlist(lapply(info_list, function(x) x$lp$Mc))), ])))
    l$spMc <- Mlist$scale_pars$Mc
  if (any(!is.na(Mlist$scale_pars$Ml[
    unique(unlist(lapply(info_list, function(x) x$lp$Ml))), ])))
    l$spMl <- Mlist$scale_pars$Ml

  l <- c(l, unlist(unname(default_hyperpars()[c(
    if (any(sapply(info_list, "[[", 'family') %in% c('gaussian', 'lognorm'))) 'norm',
    if (any(sapply(info_list, "[[", 'family') %in% c('Gamma'))) 'gamma',
    if (any(sapply(info_list, "[[", 'family') %in% c('beta'))) 'beta',
    if (any(sapply(info_list, "[[", 'link') %in% c('logit'))) 'logit',
    if (any(sapply(info_list, "[[", 'family') %in% c('poisson'))) 'poisson',
    if (any(sapply(info_list, "[[", 'link') %in% c('probit'))) 'probit',
    if (any(modeltypes %in% c('mlogit', 'mlogitmm'))) 'multinomial',
    if (any(modeltypes %in% c('clm', 'clmm'))) 'ordinal',
    if (any(modeltypes %in% c('survreg', 'coxph', 'JM'))) 'surv'
  )])))

  # priors for mixed models
  if (any(modeltypes %in% c('glmm', 'clmm', 'mlogitmm'))) {
    l <- c(l, default_hyperpars()$ranef[c('shape_diag_RinvD', 'rate_diag_RinvD')])
    l$group <- Mlist$groups

    l <- c(l,
           unlist(unname(
             lapply(info_list[modeltypes %in% c('glmm', 'clmm', 'mlogitmm')],
                    function(x) {
                      setNames(default_hyperpars()$ranef$wish(nranef = max(1, length(x$hc_list))),
                               paste(c("RinvD", "KinvD"), x$varname, sep = "_")
                      )
                    })), recursive = FALSE)
    )
  }

  # censoring indicator and true (unobserved) survival time for survreg models
  if (any(modeltypes %in% c('survreg'))) {
    for (x in info_list[modeltypes %in% c('survreg')]) {
      l[[paste0('cens_', x$varname)]] <- 1 - Mlist[[x$resp_mat[2]]][, x$resp_col[2]]
      l[[x$varname]] <- ifelse(Mlist[[x$resp_mat[2]]][, x$resp_col[2]] == 1,
                               Mlist[[x$resp_mat[1]]][, x$resp_col[1]],
                               NA)
    }
  }

  if (any(modeltypes %in% c('coxph', 'JM'))) {
    x <- info_list[[which(modeltypes %in% c('coxph', 'JM'))]]

    timevariable <- Mlist[[x$resp_mat[1]]][, x$resp_col[1]]
    eventvariable <- Mlist[[x$resp_mat[2]]][, x$resp_col[2]]
    timevar <- colnames(Mlist[[x$resp_mat[1]]])[x$resp_col[1]]


    # spline specification for the baseline hazard
    gkw <- gauss_kronrod()$gkw
    gkx <- gauss_kronrod()$gkx

    ordgkx <- order(gkx)
    gkx <- gkx[ordgkx]

    l$gkw <- gkw[ordgkx]

    h0knots <- get_knots_h0(nkn = 2, Time = timevariable,
                            event = eventvariable, gkx = gkx)

    l$Bh0 <- splines::splineDesign(h0knots, timevariable, ord = 4)
    l$Bsh0 <- splines::splineDesign(h0knots,
                                    c(t(outer(timevariable/2, gkx + 1))),
                                    ord = 4)

    l$zeros <- numeric(length(timevariable))

    if (x$modeltype == "JM") {
      # find row with largest time (= row for survival analysis)
      l$survrow <- sapply(
        split(data.frame(nr = 1:nrow(Mlist[[x$resp_mat[1]]]),
                         timevar = timevariable),
              Mlist$groups),
        function(k) {
          k$nr[which.max(k$timevar)]
        })


      if (length(l$survrow) != length(unique(Mlist$groups)))
        stop("The number of observations for survival differs from the number of subjects.")

      gk_data <- data[rep(NA, length(l$survrow) * length(gkx)), ]

      gk_data[, timevar] <- c(t(outer(Mlist$Ml[l$survrow, timevar]/2, gkx + 1)))

      X <- model.matrix_combi(fmla = c(Mlist$fixed, Mlist$auxvars),
                              data = gk_data,
                              terms_list = Mlist$terms_list)

      Xnew <- matrix(nrow = length(l$survrow) * length(gkx),
                     ncol = ncol(Mlist$Ml),
                     dimnames = list(c(), colnames(Mlist$Ml)))

      Xnew[, colnames(X)[colnames(X) %in% colnames(Xnew)]] <-
        X[, colnames(X)[colnames(X) %in% colnames(Xnew)]]

      Mlgk <- lapply(1:length(gkx), function(k) {
        Xnew[length(gkx) * ((1:length(l$survrow)) - 1) + k, ]
      })

      l$Mlgk <- array(data = unlist(Mlgk),
                      dim = c(length(l$survrow), ncol(Mlgk[[1]]), length(gkx)),
                      dimnames = list(c(), colnames(Mlist$Ml), c())
      )
    }
  }

  return(l[!sapply(l, is.null)])
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



    ranef = list(shape_diag_RinvD = 0.5,
                 rate_diag_RinvD = 0.001,
                 wish = function(nranef) {
                   if (nranef > 1) {
                     RinvD <- diag(as.numeric(rep(NA, nranef)))
                     KinvD <- nranef + 1
                   } else {
                     RinvD <- KinvD <- NULL
                   }

                   list(
                     RinvD = RinvD,
                     KinvD = KinvD
                   )
                 }),

    surv = c(mu_reg_surv = 0,
             tau_reg_surv = 0.001),

    JM = function(nBh0) {
      # nBh0 is the number of columns in the design matrix for the baseline hazard Bmat_h0
      list(mu_reg_Bh0 = rep(0, nBh0),
           tau_reg_Bh0 = diag(nBh0) * 0.1)
    }

    # # only needed for counting process version of the cox model
    # coxph = c(c = 0.001,
    #           r = 0.1,
    #           eps = 1e-10
    #           )
  )
}

