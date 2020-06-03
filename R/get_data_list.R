

get_data_list <- function(Mlist, info_list) {
  modeltypes <- sapply(info_list, "[[", 'modeltype')

  l <- Mlist$M

  # scaling parameters
  incl_sp <- sapply(Mlist$scale_pars, function(x) {
    predvars <- unique(c(unlist(sapply(Mlist$lp_cols, sapply, names)),
                         all_vars(remove_grouping(Mlist$random))))
    any(!is.na(x[rownames(x) %in% predvars, ]))
  })

  if (any(incl_sp)) {
    spM <- Mlist$scale_pars[incl_sp]
    names(spM) <- paste0("sp", names(spM))
    l <- c(l, spM)
  }


  l <- c(l, unlist(unname(default_hyperpars()[c(
    if (any(sapply(info_list, "[[", 'family') %in% c('gaussian', 'lognorm'))) 'norm',
    if (any(sapply(info_list, "[[", 'family') %in% c('Gamma'))) 'gamma',
    if (any(sapply(info_list, "[[", 'family') %in% c('beta'))) 'beta',
    if (any(sapply(info_list, "[[", 'family') %in% c('binomial') &
            sapply(info_list, "[[", 'link') %in% c('logit'))) 'logit',
    if (any(sapply(info_list, "[[", 'family') %in% c('poisson'))) 'poisson',
    if (any(sapply(info_list, "[[", 'link') %in% c('probit'))) 'probit',
    if (any(modeltypes %in% c('mlogit', 'mlogitmm'))) 'multinomial',
    if (any(modeltypes %in% c('clm', 'clmm'))) 'ordinal',
    if (any(modeltypes %in% c('survreg', 'coxph', 'JM'))) 'surv'
  )])))


  # if there are no regression coefficients in the ordinal models, remove the
  # hyperpars for regr. coefs in ordinal models
  if (length(unlist(sapply(info_list[modeltypes %in% c('clm', 'clmm')],
                           "[[", 'parelmts'))) == 0) {
    l[c('mu_reg_ordinal', 'tau_reg_ordinal')] <- NULL
  }


  # prior for mixed models ----------------------------------------------------
  if (length(Mlist$groups) > 1) {
    groups <- Mlist$groups[!names(Mlist$groups) %in% 'levelone']

    pos <- sapply(groups[!names(groups) %in% names(which.max(Mlist$group_lvls))],
                  function(x) {
                    match(unique(x), x)
                  }, simplify = FALSE)

    names(groups) <- paste0("group_", names(groups))
    names(pos) <- if (length(pos) > 0) paste0('pos_', names(pos))

    l <- c(l,
           groups,
           if (length(pos)) pos,
           default_hyperpars()$ranef[c('shape_diag_RinvD', 'rate_diag_RinvD')]
    )

    l <- c(l,
           unlist(unname(
             lapply(info_list[modeltypes %in% c('coxph', 'glmm', 'clmm', 'mlogitmm')],
                    function(x) {
                      unlist(unname(
                        lapply(names(x$hc_list$hcvars), function(k) {
                          nranef = x$nranef[k]
                          setNames(default_hyperpars()$ranef$wish(nranef = nranef),
                                   paste(c("RinvD", "KinvD"), x$varname, k, sep = "_")
                          )
                        })), recursive = FALSE)
                    })
           ), recursive = FALSE)
    )
  }

  # survreg models -------------------------------------------------------------
  if (any(modeltypes %in% c('survreg'))) {
    for (x in info_list[modeltypes %in% c('survreg')]) {
      l[[paste0('cens_', x$varname)]] <- 1 - Mlist$M[[x$resp_mat[2]]][, x$resp_col[2]]
      l[[x$varname]] <- ifelse(Mlist$M[[x$resp_mat[2]]][, x$resp_col[2]] == 1,
                               Mlist$M[[x$resp_mat[1]]][, x$resp_col[1]],
                               NA)
    }
  }

  # coxph & JM -----------------------------------------------------------------
  if (any(modeltypes %in% c('coxph', 'JM'))) {
    # spline specification for the baseline hazard
    gkw <- gauss_kronrod()$gkw
    gkx <- gauss_kronrod()$gkx

    ordgkx <- order(gkx)
    gkx <- gkx[ordgkx]

    l$gkw <- gkw[ordgkx]

    survinfo <- get_survinfo(info_list, Mlist)

    for (x in survinfo) {
      if (x$haslong) {
        survrow <- which(Mlist$M$M_levelone[, Mlist$timevar] ==
                           x$survtime[l[[paste0('group_', x$surv_lvl)]]])

        if (length(survrow) != length(unique(Mlist$groups[[x$surv_lvl]])))
          stop("The number of observations for survival differs from the number of subjects.")

        l[[paste0('survrow_', x$varname)]] <- survrow
      }


      h0knots <- get_knots_h0(nkn = Mlist$df_basehaz - 4, Time = x$survtime,
                              event = x$survevent, gkx = gkx)


      l[[paste0("Bh0_", x$varname)]] <- splines::splineDesign(h0knots,
                                                              x$survtime, ord = 4)
      l[[paste0("Bsh0_", x$varname)]] <-
        splines::splineDesign(h0knots, c(t(outer(x$survtime/2, gkx + 1))), ord = 4)

      l[[paste0("zeros_", x$varname)]] <- numeric(length(x$survtime))
    }


    if (any(sapply(survinfo, "[[", "haslong"))) {
      surv_lvl <- unique(sapply(survinfo, "[[", "surv_lvl"))

      if (length(surv_lvl) > 1)
        stop("It is not possible to fit survival models on different levels of the data.")
      if (length(unique(sapply(survinfo, "[[", "time_name"))) > 1)
        stop("It is currently not possible to fit multiple survival
             models with different event time variables.")
      if (length(unique(sapply(survinfo, "[[", "modeltype"))) > 1)
        stop("It is not possible to simultaneously fit coxph and JM models.")


      Mgk <- get_Mgk(Mlist, gkx, surv_lvl, survinfo, data = Mlist$data,
                     td_cox = unique(sapply(survinfo, "[[", "modeltype")) == 'coxph')

      l$M_levelonegk <- array(data = unlist(Mgk),
                              dim = c(nrow(Mgk[[1]]), ncol(Mgk[[1]]), length(gkx)),
                              dimnames = list(c(), dimnames(Mgk)[[2]], c())
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



    ranef = list(shape_diag_RinvD = 0.01,
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

