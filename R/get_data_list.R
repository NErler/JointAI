# # # # # # # # # # # # # # # # # # # # #
# get list of data to be passed to JAGS #
# # # # # # # # # # # # # # # # # # # # #

get_data_list <- function(Mlist, info_list) {
  modeltypes <- sapply(info_list, "[[", 'modeltype')

  # data matrices --------------------------------------------------------------
  l <- Mlist$M

  # scaling parameters ---------------------------------------------------------
  incl_sp <- sapply(Mlist$scale_pars, function(x) {
    # identify all variables on the RHS of any formula
    predvars <- unique(c(unlist(sapply(Mlist$lp_cols, sapply, names)),
                         all_vars(remove_grouping(Mlist$random))))

    # check if there are scaling parameters available for these predictor variables
    any(!is.na(x[rownames(x) %in% predvars, ]))
  })

  # include only those scaling matrices that contain scaling parameters that are
  # actually used, to prevent warning message from JAGS
  if (any(incl_sp)) {
    spM <- Mlist$scale_pars[incl_sp]
    names(spM) <- paste0("sp", names(spM))
    l <- c(l, spM)
  }


  # hyperpars ------------------------------------------------------------------
  l <- c(l, unlist(unname(default_hyperpars()[
    c(
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
    )
  ])))


  # if there are no regression coefficients in the ordinal models, remove the
  # hyperpars for regression coefficients in ordinal models to prevent warning
  # message from JAGS
  if (length(unlist(sapply(info_list[modeltypes %in% c('clm', 'clmm')],
                           "[[", 'parelmts'))) == 0) {
    l[c('mu_reg_ordinal', 'tau_reg_ordinal')] <- NULL
  }


  # random effects groupings ---------------------------------------------------
  if (length(Mlist$groups) > 1) {

    # Obtain groups from Mlist, except for the group 'levelone' (never used).
    # The groups are vectors of length nrow(data) that indicate which rows
    # belong together on a given grouping level.
    groups <- Mlist$groups[!names(Mlist$groups) %in% 'levelone']

    # get the position (row) of a given observation
    # - to identify the correct rows between different sub-levels
    # - pos is only needed when there are multiple grouping levels
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


    # Include RinvD and KinvD for all grouping levels.
    # This is done for all models that could contain time-varying covariates /
    # multi-level models. In case of a JM, there will always also be a mixed
    # model, so it does not be mentioned in the list of models separately.
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

    # Gauss-Kronrod quadrature points
    gkw <- gauss_kronrod()$gkw
    gkx <- gauss_kronrod()$gkx

    ordgkx <- order(gkx)
    gkx <- gkx[ordgkx]

    l$gkw <- gkw[ordgkx]


    # extract the relevant information on survival models
    # (to simplify the following syntax)
    survinfo <- get_survinfo(info_list, Mlist)

    for (x in survinfo) {
    # if there are time-varying covariates, identify the rows of the longitudinal
    # variable that correspond to the event times
      if (x$haslong) {
        survrow <- which(Mlist$M$M_levelone[, Mlist$timevar] ==
                           x$survtime[l[[paste0('group_', x$surv_lvl)]]])

        if (length(survrow) != length(unique(Mlist$groups[[x$surv_lvl]])))
          errormsg("The number of observations for survival differs from the
                   number of subjects.")

        l[[paste0('survrow_', x$varname)]] <- survrow
      }


      # B-spline specification for the baseline hazard
      h0knots <- get_knots_h0(nkn = Mlist$df_basehaz - 4, Time = x$survtime,
                              event = x$survevent, gkx = gkx)


      l[[paste0("Bh0_", x$varname)]] <- splines::splineDesign(h0knots,
                                                              x$survtime, ord = 4)
      l[[paste0("Bsh0_", x$varname)]] <-
        splines::splineDesign(h0knots, c(t(outer(x$survtime/2, gkx + 1))), ord = 4)

      # vector of zeros for the "zeros trick" in JAGS
      l[[paste0("zeros_", x$varname)]] <- numeric(length(x$survtime))
    }


    if (any(sapply(survinfo, "[[", "haslong"))) {

      # what is the level of the survival outome?
      surv_lvl <- unique(sapply(survinfo, "[[", "surv_lvl"))

      if (length(surv_lvl) > 1)
        errormsg("It is not possible to fit survival models on different
                 levels of the data.")

      if (length(unique(sapply(survinfo, "[[", "time_name"))) > 1)
        errormsg("It is currently not possible to fit multiple survival
                  models with different event time variables.")

      if (length(unique(sapply(survinfo, "[[", "modeltype"))) > 1)
        errormsg("It is not possible to simultaneously fit coxph and JM models.")


      # create the design matrix of time-varying data using the Gauss-Kronrod
      # quadrature points for time
      Mgk <- get_Mgk(Mlist, gkx, surv_lvl, survinfo, data = Mlist$data,
                     td_cox = unique(sapply(survinfo, "[[", "modeltype")) == 'coxph')

      # for survival models, there can only be one level below the level of the
      # survival outcome (i.e., time-varying variables have level 1, survival
      # outcome has level 2)
      l$M_levelonegk <- array(data = unlist(Mgk),
                              dim = c(nrow(Mgk[[1]]), ncol(Mgk[[1]]), length(gkx)),
                              dimnames = list(c(), dimnames(Mgk)[[2]], c())
      )
    }

  }  # end of if (any(modeltypes %in% c('coxph', 'JM')))

  return(l[!sapply(l, is.null)])
}




#' Get the default values for hyper-parameters
#'
#' This function returns a list of default values for the hyper-parameters.
#'
#' \strong{norm:} hyper-parameters for normal and log-normal models
#' \tabular{ll}{
#' \code{mu_reg_norm} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_norm} \tab precision in the priors for regression coefficients\cr
#' \code{shape_tau_norm} \tab shape parameter in Gamma prior for the precision
#'                            of the (log-)normal distribution\cr
#' \code{rate_tau_norm} \tab rate parameter in Gamma prior for the precision
#'                           of the (log-)normal distribution\cr
#' }
#'
#' \strong{gamma:} hyper-parameters for Gamma models
#' \tabular{ll}{
#' \code{mu_reg_gamma} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_gamma} \tab precision in the priors for regression coefficients\cr
#' \code{shape_tau_gamma} \tab shape parameter in Gamma prior for the precision
#'                             of the Gamma distribution\cr
#' \code{rate_tau_gamma} \tab rate parameter in Gamma prior for the precision
#'                            of the Gamma distribution
#' }
#'
#' \strong{beta:} hyper-parameters for beta models
#' \tabular{ll}{
#' \code{mu_reg_beta} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_beta} \tab precision in the priors for regression coefficients\cr
#' \code{shape_tau_beta} \tab shape parameter in Gamma prior for the precision
#'                            of the beta distribution\cr
#' \code{rate_tau_beta} \tab rate parameter in Gamma prior for precision of the
#'                           of the beta distribution
#' }
#'
#' \strong{logit:} hyper-parameters for logistic models
#' \tabular{ll}{
#' \code{mu_reg_logit} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_logit} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{probit:} hyper-parameters for probit models
#' \tabular{ll}{
#' \code{mu_reg_logit} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_logit} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{multinomial:} hyper-parameters for multinomial models
#' \tabular{ll}{
#' \code{mu_reg_multinomial} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_multinomial} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{ordinal:} hyper-parameters for ordinal models
#' \tabular{ll}{
#' \code{mu_reg_ordinal} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_ordinal} \tab precision in the priors for regression coefficients\cr
#' \code{mu_delta_ordinal} \tab mean in the prior for the intercepts\cr
#' \code{tau_delta_ordinal} \tab precision in the priors for the intercepts
#' }
#'
#' \strong{Z:} function creating hyper-parameters for the random effects in
#'             mixed models, with output elements
#' \tabular{ll}{
#' \code{RinvD} \tab scale matrix in the Wishart prior (*) for the random
#'                   effects covariance matrix\cr
#' \code{KinvD} \tab degrees of freedom in the Wishart prior for random
#'                   effects covariance matrix\cr
#' \code{shape_diag_RinvD} \tab shape parameter in Gamma prior for the diagonal
#'                              elements of \code{RinvD}\cr
#' \code{rate_diag_RinvD} \tab rate parameter in Gamma prior for the diagonal
#'                             elements of \code{RinvD}
#' }
#' (*) when there is only one random effect a Gamma distribution is used instead
#'     of the Wishart and \code{RinvD} and \code{KinvD} are \code{NULL}
#'
#' \strong{surv:} parameters for survival models (\code{survreg}, \code{coxph}
#'                and \code{JM})
#' \tabular{ll}{
#' \code{mu_reg_surv} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_surv} \tab precision in the priors for regression coefficients
#' }
#'
#' @note
#' \strong{From the
#' \href{https://sourceforge.net/projects/mcmc-jags/files/Manuals/}{JAGS user manual}
#' on the specification of the Wishart distribution:}\cr
#' For \code{KinvD} larger than the dimension of the variance-covariance matrix
#' the prior on the correlation between the random effects is concentrated
#' around 0, so that larger values of \code{KinvD} indicate stronger prior
#' belief that the elements of the multivariate normal distribution are independent.
#' For \code{KinvD} equal to the number of random effects the Wishart prior
#' puts most weight on the extreme values (correlation 1 or −1).
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
             tau_reg_surv = 0.001)
  )
}

