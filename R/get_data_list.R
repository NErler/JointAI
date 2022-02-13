# # # # # # # # # # # # # # # # # # # # #
# get list of data to be passed to JAGS #
# # # # # # # # # # # # # # # # # # # # #

get_data_list <- function(Mlist, info_list, hyperpars,
                          append_data_list = NULL) {
  modeltypes <- cvapply(info_list, "[[", "modeltype")
  families <- unlist(nlapply(info_list, "[[", "family"))


  # data matrices --------------------------------------------------------------
  l <- Mlist$M[nvapply(Mlist$M, ncol) > 0]

  # scaling parameters ---------------------------------------------------------
  incl_sp <- lvapply(Mlist$scale_pars, function(x) {
    # identify all variables on the RHS of any formula
    predvars <- unique(c(unlist(lapply(Mlist$lp_cols, nlapply, names)),
                         all_vars(remove_grouping(Mlist$random))))

    # check if there are scaling parameters available for these predictor
    # variables
    any(!is.na(x[rownames(x) %in% predvars, ]))
  })

  # include only those scaling matrices that contain scaling parameters that are
  # actually used, to prevent warning message from JAGS
  if (any(incl_sp)) {
    sp <- Mlist$scale_pars[incl_sp]
    names(sp) <- paste0("sp", names(sp))
    l <- c(l, sp)
  }


  # hyperpars ------------------------------------------------------------------

  hyp <- if (is.null(hyperpars)) {
    default_hyperpars()
  } else {
    hyperpars
  }



  l <- c(l, unlist(unname(hyp[
    c(
      if (any(families %in% c("gaussian", "lognorm"))) "norm",
      if (any(families %in% "Gamma")) "gamma",
      if (any(families %in% "beta")) "beta",
      if (any(families %in% "binomial")) "binom",
      if (any(families %in% "poisson")) "poisson",
      if (any(modeltypes %in% c("mlogit", "mlogitmm"))) "multinomial",
      if (any(modeltypes %in% c("clm", "clmm"))) "ordinal",
      if (any(modeltypes %in% c("survreg", "coxph", "JM"))) "surv"
    )
  ])))


  # if there are no regression coefficients in the ordinal models, remove the
  # hyperpars for regression coefficients in ordinal models to prevent warning
  # message from JAGS
  clm_parelmts <- nlapply(info_list[modeltypes %in% c("clm", "clmm")],
                          "[[", "parelmts")

  if (length(
    unlist(c(clm_parelmts, lapply(clm_parelmts, lapply, "attr", "nonprop")))
  ) == 0L) {
    l[c("mu_reg_ordinal", "tau_reg_ordinal")] <- NULL
  }


  # random effects groupings ---------------------------------------------------
  if (sum(unlist(lapply(info_list, "[[", "nranef"))) > 0L) {

    # Obtain groups from Mlist, except for the group "lvlone" (never used).
    # The groups are vectors of length nrow(data) that indicate which rows
    # belong together on a given grouping level.
    groups <- Mlist$groups[!names(Mlist$groups) %in% "lvlone"]

    # get the position (row) of a given observation
    # - to identify the correct rows between different sub-levels
    # - pos is only needed when there are multiple grouping levels
    pos <- nlapply(groups[!names(groups) %in%
                            names(which(Mlist$group_lvls ==
                                          max(Mlist$group_lvls)))],
                   function(x) {
                     match(unique(x), x)
                   })

    names(groups) <- paste0("group_", names(groups))
    names(pos) <- if (length(pos) > 0L) paste0("pos_", names(pos))

    l <- c(l,
           groups,
           if (length(pos)) pos,
           hyp$ranef[c("shape_diag_RinvD", "rate_diag_RinvD")]
    )


    # Include RinvD and KinvD for all grouping levels.
    # This is done for all models that could contain time-varying covariates /
    # multi-level models. In case of a JM, there will always also be a mixed
    # model, so it does not be mentioned in the list of models separately.
    rd_hyp_pars <- lapply(
      info_list[modeltypes %in% c("coxph", "glmm", "clmm", "mlogitmm")],
      function(info) {
        rd_hyp <- lapply(names(info$hc_list$hcvars), function(lvl) {
          if (isTRUE(info$rd_vcov[[lvl]] == "blockdiag")) {
            get_RinvD(info$nranef[lvl],
                      hyp$ranef["KinvD_expr"],
                      names = paste(c("RinvD", "KinvD"),
                                    info$varname, lvl, sep = "_")
            )
          } else if (isTRUE(info$rd_vcov[[lvl]] == "indep") &
                     info$nranef[lvl] > 1) {
            get_invD_indep(nranef = info$nranef[lvl],
                           name = paste("invD", info$varname, lvl,
                                                         sep = "_"))
          }
        })
        unlist(rd_hyp, recursive = FALSE)
      })
    l <- c(l, unlist(unname(rd_hyp_pars), recursive = FALSE))

    rd_hyp_full <- lapply(names(Mlist$rd_vcov), function(lvl) {
      if (any(names(Mlist$rd_vcov[[lvl]]) == "full")) {
        k <- which(names(Mlist$rd_vcov[[lvl]]) == "full")

        rd_hyp_full_lvl <- lapply(
          which(names(Mlist$rd_vcov[[lvl]]) == "full"),
          function(k) {

            nranef <- sapply(attr(Mlist$rd_vcov[[lvl]][[k]], "ranef_index"),
                             function(nr) eval(parse(text = nr)))
            nam <- attr(Mlist$rd_vcov[[lvl]][[k]], "name")

            get_RinvD(max(unlist(nranef)),
                      hyp$ranef["KinvD_expr"],
                      paste0(c("RinvD", "KinvD"), nam, "_", lvl))
          })
        unlist(rd_hyp_full_lvl, recursive = FALSE)
      }
    })

    l <- c(l, unlist(rd_hyp_full, recursive = FALSE))

  }


  # survreg models -------------------------------------------------------------
  if (any(modeltypes %in% "survreg")) {
    for (x in info_list[modeltypes %in% "survreg"]) {

      l[[paste0("cens_", x$varname)]] <-
        1L - Mlist$M[[x$resp_mat[2L]]][, x$resp_col[2L]]

      if (any(!Mlist$M[[x$resp_mat[2L]]][, x$resp_col[2L]] %in% c(0L, 1L))) {
        errormsg("The event indicator should only contain 2 distinct values
                 but I found %s. Note that it is currently not possible to fit
                 survival models with competing risks.",
                 length(unique(Mlist$M[[x$resp_mat[2L]]][, x$resp_col[2L]]))
        )
      }

      l[[x$varname]] <- nvapply(
        seq.int(nrow(Mlist$M[[x$resp_mat[2L]]])),
        function(k) {
          if (Mlist$M[[x$resp_mat[2L]]][, x$resp_col[2L]][k] == 1L) {
            Mlist$M[[x$resp_mat[1L]]][, x$resp_col[1L]][k]
          } else {
            NA
          }
        })
    }
  }

  # coxph & JM -----------------------------------------------------------------
  if (any(modeltypes %in% c("coxph", "JM"))) {

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
      # if there are time-varying covariates, identify the rows of the
      # longitudinal variable that correspond to the event times
      if (x$haslong) {
        srow <- which(Mlist$M$M_lvlone[, Mlist$timevar] ==
                        x$survtime[Mlist$groups[[x$surv_lvl]]])

        if (length(srow) != length(unique(Mlist$groups[[x$surv_lvl]])))
          errormsg("The number of observations for survival differs from the
                   number of subjects.")

        l[[paste0("srow_", x$varname)]] <- srow
      }


      # B-spline specification for the baseline hazard
      h0knots <- get_knots_h0(nkn = Mlist$df_basehaz - 4L, Time = x$survtime,
                              event = x$survevent, gkx = gkx)


      l[[paste0("Bh0_", x$varname)]] <-
        splines::splineDesign(h0knots, x$survtime, ord = 4L)

      Bsh0 <- splines::splineDesign(h0knots, c(t(outer(x$survtime / 2L, gkx + 1L))),
                                    ord = 4L)
      l[[paste0("Bsh0_", x$varname)]] <- array(
        dim = c(15, nrow(Bsh0)/15, ncol(Bsh0)),
        data = Bsh0)


      # vector of zeros for the "zeros trick" in JAGS
      l[[paste0("zeros_", x$varname)]] <- numeric(length(x$survtime))
    }


    if (any(lvapply(survinfo, "[[", "haslong"))) {

      # what is the level of the survival outcome?
      surv_lvl <- unique(cvapply(survinfo, "[[", "surv_lvl"))

      if (length(surv_lvl) > 1L)
        errormsg("It is not possible to fit survival models on different
                 levels of the data.")

      if (length(unique(cvapply(survinfo, "[[", "time_name"))) > 1L)
        errormsg("It is currently not possible to fit multiple survival
                  models with different event time variables.")

      if (length(unique(cvapply(survinfo, "[[", "modeltype"))) > 1L)
        errormsg("It is not possible to simultaneously fit coxph and JM
                 models.")


      # create the design matrix of time-varying data using the Gauss-Kronrod
      # quadrature points for time
      mat_gk <- get_matgk(Mlist, gkx, surv_lvl, survinfo, data = Mlist$data,
                          td_cox = unique(cvapply(survinfo, "[[",
                                                  "modeltype")) == "coxph")

      # for survival models, there can only be one level below the level of the
      # survival outcome (i.e., time-varying variables have level 1, survival
      # outcome has level 2)
      l$M_lvlonegk <- array(data = unlist(mat_gk),
                            dim = c(nrow(mat_gk[[1L]]), ncol(mat_gk[[1L]]),
                                    length(gkx)),
                            dimnames = list(NULL, dimnames(mat_gk)[[2L]], NULL)
      )
    }

  }  # end of if (any(modeltypes %in% c("coxph", "JM")))



  # splines --------------------------------------------------------------------

  # if (any(Mlist$fcts_all$type %in% c("bs", "ps"))) {
  #   trafo_sub <-
  #     unique(Mlist$fcts_all[which(Mlist$fcts_all$type %in% c("bs", "ps")),
  #                           c("var", "fct", "type", "dupl")])
  #
  #   for (k in seq_len(nrow(trafo_sub))) {
  #     sB <- eval(parse(text = trafo_sub$fct[k]), envir = Mlist$data)
  #
  #     l[[paste0("kn_", trafo_sub$var[k])]] <- attr(sB, "knots")
  #
  #     sD <- diff(diag(length(attr(sB, "knots"))),
  #                diff = attr(sB, "degree") + 1L) /
  #       (gamma(attr(sB, "degree") + 1L) * attr(sB, "dx")^attr(sB, "degree"))
  #
  #     l[[paste0("sD_", trafo_sub$var[k])]] <- sD
  #
  #     if (trafo_sub$type == "ps") {
  #       DDal <- diag(ncol(sB))
  #       l[[paste0("priorTau_", trafo_sub$var[k])]] <-
  #         crossprod(diff(DDal, diff = 2)) + 1e-06 * DDal
  #       l[[paste0("priorMean_", trafo_sub$var[k])]] <- rep(0, ncol(sB))
  #
  #       l <- c(l,  shape_ps = 1.0, rate_ps = 0.0005)
  #     }
  #   }
  # }


  if (!is.null(append_data_list)) {
    l <- c(l, append_data_list)
  }

  l[!lvapply(l, is.null)]
}




#' Get the default values for hyper-parameters
#'
#' This function returns a list of default values for the hyper-parameters.
#'
#' \strong{norm:} hyper-parameters for normal and log-normal models
#' \tabular{ll}{
#' \code{mu_reg_norm} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_norm} \tab precision in the priors for regression
#'                          coefficients\cr
#' \code{shape_tau_norm} \tab shape parameter in Gamma prior for the precision
#'                            of the (log-)normal distribution\cr
#' \code{rate_tau_norm} \tab rate parameter in Gamma prior for the precision
#'                           of the (log-)normal distribution\cr
#' }
#'
#' \strong{gamma:} hyper-parameters for Gamma models
#' \tabular{ll}{
#' \code{mu_reg_gamma} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_gamma} \tab precision in the priors for regression
#'                           coefficients\cr
#' \code{shape_tau_gamma} \tab shape parameter in Gamma prior for the precision
#'                             of the Gamma distribution\cr
#' \code{rate_tau_gamma} \tab rate parameter in Gamma prior for the precision
#'                            of the Gamma distribution
#' }
#'
#' \strong{beta:} hyper-parameters for beta models
#' \tabular{ll}{
#' \code{mu_reg_beta} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_beta} \tab precision in the priors for regression
#'                          coefficients\cr
#' \code{shape_tau_beta} \tab shape parameter in Gamma prior for the precision
#'                            of the beta distribution\cr
#' \code{rate_tau_beta} \tab rate parameter in Gamma prior for precision of the
#'                           of the beta distribution
#' }
#'
#' \strong{binom:} hyper-parameters for binomial models
#' \tabular{ll}{
#' \code{mu_reg_binom} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_binom} \tab precision in the priors for regression coefficients
#' }
#'
#' \strong{poisson:} hyper-parameters for poisson models
#' \tabular{ll}{
#' \code{mu_reg_poisson} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_poisson} \tab precision in the priors for regression
#' coefficients
#' }
#'
#' \strong{multinomial:} hyper-parameters for multinomial models
#' \tabular{ll}{
#' \code{mu_reg_multinomial} \tab mean in the priors for regression
#'                                coefficients\cr
#' \code{tau_reg_multinomial} \tab precision in the priors for regression
#'                                 coefficients
#' }
#'
#' \strong{ordinal:} hyper-parameters for ordinal models
#' \tabular{ll}{
#' \code{mu_reg_ordinal} \tab mean in the priors for regression coefficients\cr
#' \code{tau_reg_ordinal} \tab precision in the priors for regression
#'                             coefficients\cr
#' \code{mu_delta_ordinal} \tab mean in the prior for the intercepts\cr
#' \code{tau_delta_ordinal} \tab precision in the priors for the intercepts
#' }
#'
#' \strong{ranef:} hyper-parameters for the random effects variance-covariance
#' matrices (when there is only one random effect a Gamma distribution is used
#' instead of the Wishart distribution)
#' \tabular{ll}{
#' \code{shape_diag_RinvD} \tab shape parameter in Gamma prior for the diagonal
#'                              elements of \code{RinvD}\cr
#' \code{rate_diag_RinvD} \tab rate parameter in Gamma prior for the diagonal
#'                             elements of \code{RinvD}\cr
#' \code{KinvD_expr} \tab a character string that can be evaluated to calculate
#'                        the number of degrees of freedom in the Wishart
#'                        distribution used for the inverse of the
#'                        variance-covariance matrix for random effects,
#'                        depending on the number of random effects
#'                        \code{nranef}
#' }
#'
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
#' \href{https://sourceforge.net/projects/mcmc-jags/files/Manuals/}{JAGS user
#' manual}
#' on the specification of the Wishart distribution:}\cr
#' For \code{KinvD} larger than the dimension of the variance-covariance matrix
#' the prior on the correlation between the random effects is concentrated
#' around 0, so that larger values of \code{KinvD} indicate stronger prior
#' belief that the elements of the multivariate normal distribution are
#' independent.
#' For \code{KinvD} equal to the number of random effects the Wishart prior
#' puts most weight on the extreme values (correlation 1 or -1).
#'
#' @examples
#' default_hyperpars()
#'
#' # To change the hyper-parameters:
#' hyp <- default_hyperpars()
#' hyp$norm['rate_tau_norm'] <- 1e-3
#' mod <- lm_imp(y ~ C1 + C2 + B1, data = wideDF, hyperpars = hyp, mess = FALSE)
#'
#'
#' @export


default_hyperpars <- function() {
  list(
    norm = c(
      mu_reg_norm = 0.0,
      tau_reg_norm = 0.0001,
      shape_tau_norm = 0.01,
      rate_tau_norm = 0.01
    ),

    gamma = c(
      mu_reg_gamma = 0.0,
      tau_reg_gamma = 0.0001,
      shape_tau_gamma = 0.01,
      rate_tau_gamma = 0.01
    ),

    beta = c(
      mu_reg_beta = 0.0,
      tau_reg_beta = 0.0001,
      shape_tau_beta = 0.01,
      rate_tau_beta = 0.01
    ),

    binom = c(
      mu_reg_binom = 0.0,
      tau_reg_binom = 0.0001
    ),


    poisson = c(
      mu_reg_poisson = 0.0,
      tau_reg_poisson = 0.0001
    ),


    multinomial = c(
      mu_reg_multinomial = 0.0,
      tau_reg_multinomial = 0.0001
    ),

    ordinal = c(
      mu_reg_ordinal = 0.0,
      tau_reg_ordinal = 0.0001,
      mu_delta_ordinal = 0.0,
      tau_delta_ordinal = 0.0001
    ),



    ranef = c(shape_diag_RinvD = 0.01,
              rate_diag_RinvD = 0.001,
              KinvD_expr = "nranef + 1.0"
    ),

    surv = c(mu_reg_surv = 0.0,
             tau_reg_surv = 0.001)
  )
}


get_RinvD <- function(nranef, KinvD_expr = "nranef + 1.0", names) {
  if (nranef > 1L) {
    RinvD <- diag(as.numeric(rep(NA, nranef)))
    KinvD <- eval(parse(text = KinvD_expr))
  } else {
    RinvD <- KinvD <- NULL
  }

  setNames(
    list(
      RinvD = RinvD,
      KinvD = KinvD
    ), names)
}

get_invD_indep <- function(nranef, name) {
  setNames(list(diag(as.numeric(rep(NA, nranef)))),
           name)
}
