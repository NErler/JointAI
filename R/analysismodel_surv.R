# parametric survival model ---------------------------------------------------
survreg_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)
  indent <- 4 + 9 + nchar(y_name) + 8

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = indent))
  }


  paste_ppc <- NULL # if (Mlist$ppc) {
  #   paste0(
  #     tab(4), y_name, "_ppc[j] ~ dgen.gamma(1, rate_", y_name, "[j], shape_", y_name, ")", "\n",
  #     tab(4), 'mu_', y_name, '[j] <- 1/rate_', y_name, '[j] * exp(loggam(1 + 1/shape_', y_name, '))', "\n"
  #   )
  # }


  paste0(tab(4), "# Weibull survival model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dgen.gamma(1, rate_", y_name, "[j], shape_", y_name, ")", "\n",
         paste_ppc,
         tab(4), "cens[j] ~ dinterval(", y_name, "[j], ctime[j])", "\n",
         tab(4), "log(rate_", y_name, "[j]) <- -1 * (",
         paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xc',
                         parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = indent),
         paste_Xic, ")"
  )
}

# priors for parametric survival model -----------------------------------------
survreg_priors <- function(K, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste_ppc <- NULL # if (Mlist$ppc) {
  #   paste0('\n',
  #          tab(), '# Posterior predictive check for the model for ', y_name, '\n',
  #          tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
  #          tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
  #          tab(), 'ppc_', y_name, " <- mean(step(ppc_", y_name, "_o - ppc_", y_name, "_e)) - 0.5", "\n"
  #   )
  # }

  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])", "\n",
                    tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }

  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    distr,
    tab(), "}", "\n",
    tab(), "shape_", y_name ," ~ dexp(0.01)", "\n",
    paste_ppc,
    "\n")
}




# Cox PH model -----------------------------------------------------------------
coxph_count_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)
  indent <- 4 + 10 + 4

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'subj[j]', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = indent))
  }


  paste0(tab(4), "# Cox PH model for ", y_name, "\n",
         tab(4), "dN[j] ~ dpois(Idt[j])", "\n",
         tab(4), "Idt[j] <- exp(",
         paste_predictor(parnam = 'beta', parindex = 'subj[j]', matnam = 'Xc',
                         parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = indent),
         paste_Xic, ") * dL0[time[j]] * RiskSet[j]", "\n",
         tab(), "}", "\n",
         tab(4), "for (j in 1:(nt-1)) {", "\n",
         tab(6), "dL0[j] ~ dgamma(priorhaz[j], c)"
  )
}


coxph_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)
  indent <- 4 + 10 + 4

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = indent))
  }


  paste0(tab(4), "# Cox PH model for ", y_name, "\n",
         tab(4), "etaBaseline[j] <- ",
         if (any(is.na(K["Xc", ]))) '0'
         else
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xc',
                           parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = indent),
         paste_Xic, "\n",
         tab(4), "log.h0.T[j] <- inprod(Bs.gammas[], Bmat_h0[j, ])", "\n",
         tab(4), "log.hazard[j] <- log.h0.T[j] + etaBaseline[j]", "\n",
         tab(4), "for (k in 1:15) {", "\n",
         tab(6), "log.h0.s[j, k] <- inprod(Bs.gammas[], Bmat_h0s[15 * (j - 1) + k, ])", "\n",
         tab(6), "SurvLong[j, k] <- gkw[k] * exp(log.h0.s[j, k])", "\n",
         tab(4), "}", "\n\n",
         tab(4), "log.survival[j] <- -exp(etaBaseline[j]) * ", y_name ,"[j]/2 * sum(SurvLong[j, ])", "\n",
         tab(4), "phi[j] <- 5000 - ((status[j] * log.hazard[j])) - (log.survival[j])", "\n",
         tab(4), "zeros[j] ~ dpois(phi[j])"
  )
}



# priors for Cox PH model ------------------------------------------------------
coxph_count_priors <- function(K, Mlist, ...){
  # y_name <- colnames(Mlist$y)

  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])", "\n",
                    tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }


  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    distr,
    tab(), "}"
  )
}




coxph_priors <- function(K, Mlist, ...){
  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])", "\n",
                    tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }


  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    if (!all(is.na(K))) {
      paste0(
      tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
      distr,
      tab(), "}", "\n")
    },
    tab(), "for (k in 1:6) {", "\n",
    tab(4), "Bs.gammas[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n",
    tab(), "}"
    # tab(), "Bs.gammas[1:5] ~ dmnorm(priorMean.Bs.gammas[], tau_reg_surv * priorTau.Bs.gammas[, ])"
  )
}


# Joint model ------------------------------------------------------------------
JM_model <- function(Mlist, K, imp_par_list_long, ...){

  K <- K[[which(sapply(Mlist$outnam, 'attr', 'type') == 'survival')]]
  cols_main <- Mlist$cols_main[[which(sapply(Mlist$outnam, 'attr', 'type') == 'survival')]]

  y_name <- colnames(Mlist$y)
  indent <- 4 + 13 + 4

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = cols_main$Xic, indent = indent))
  }

  paste_Xl <- if (length(cols_main$Xl) > 0) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'survrow[j]',
                           matnam = paste0('mu_', Mlist$names_main[[
                             which(sapply(Mlist$outnam, 'attr', 'type') == 'survival')]]$Xl),
                           parelmts = K["Xl", 1]:K["Xl", 2],
                           cols = NULL, indent = indent, breakafter = 2)
    )
  }


  paste_Xil <- if (length(cols_main$Xil) > 0) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xil',
                           parelmts = K["Xil", 1]:K["Xil", 2],
                           cols = cols_main$Xil, indent = indent)
    )
  }



  paste_mu_gk <- if (length(cols_main$Xl) > 0) {
    paste0(" + \n", tab(indent + 3),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'mu_gk',
                           parelmts = K["Xl", 1]:K["Xl", 2],
                           cols = cols_main$Xl, indent = indent + 3,
                           isgk = TRUE, breakafter = 2)
    )
  }




  # paste_mu_gk <- if (!is.null(Xl_cols)) {
  #   paste0(" + \n", tab(indent),
  #          paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xl',
  #                          parelmts = par_elmts["Xl", 1]:par_elmts["Xl", 2],
  #                          cols = Xl_cols, indent = indent)
  #   )
  # }


  fit_mu_gk <- if (length(cols_main$Xl) > 0) {
    paste(
      sapply(seq_along(imp_par_list_long), function(x) {
        Xlpart <- if (!is.null(imp_par_list_long[[x]]$Xl_cols)) {
        pe <- imp_par_list_long[[x]]$par_elmts
        paste0(" +\n", tab(indent + 3),
               paste_predictor(parnam = imp_par_list_long[[x]]$parname,
                               parindex = 'j', matnam = 'Xlgk',
                               parelmts = pe["Xl", 1]:pe["Xl", 2], isgk = TRUE,
                               cols = imp_par_list_long[[x]]$Xl_cols,
                               indent = indent + 3, breakafter = 1)
        )}

      paste0(tab(6), "mu_gk[j, ", x, ", k] <- ",
             paste_ranef_predictor_gk(parnam = paste0("b_", imp_par_list_long[[x]]$varname),
                                      parindex1 = '15 * (j - 1) + k',
                                      parindex2 = 'j',
                                      matnam = 'Zgk',
                                      parelmts = 1:imp_par_list_long[[x]]$nranef,
                                      cols = imp_par_list_long[[x]]$Z_cols,
                                      indent = indent + 3, breakafter = 1),
             Xlpart)
    }), collapse = "\n")
  }



  fit_Xlgk <- if (length(cols_main$Xl) > 0) {
    paste(
      sapply(seq_along(imp_par_list_long), function(x) {

        distr <- switch(imp_par_list_long[[x]]$impmeth,
                        "lmm" = function(varname) {
                          paste0("dnorm(mu_gk[j, ", x, ", k], tau_", varname, ")")
                        },
                        "glmm_lognorm" = function(varname) {
                          paste0("dlnorm(mu_gk[j, ", x, ", k], tau_", varname, ")")
                        }
                        # "binomial" =  function(varname) {
                        #   paste0("dbern(mu_", varname, "[j])")
                        # },
                        # "Gamma" =  function(varname) {
                        #   paste0("dgamma(shape_", varname, "[j], rate_", varname, "[j])")
                        # },
                        # "poisson" = function(varname) {
                        #   paste0("dpois(mu_", varname, "[j])")
                        # }
        )

        paste0(tab(6), "Xlgk[j, ", x, ", k] ~ ", distr(imp_par_list_long[[x]]$varname))
      }), collapse = "\n")
  }

  paste0(tab(4), "# Cox PH model for ", y_name, "\n",
         tab(4), "etaBaseline[j] <- ",
         if (any(is.na(K["Xc", ]))) '0'
         else
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xc',
                           parelmts = K["Xc", 1]:K["Xc", 2],
                           cols = cols_main$Xc, indent = indent),
         paste_Xic, "\n",
         tab(4), "log.h0.T[j] <- inprod(Bs.gammas[], Bmat_h0[j, ])", "\n",
         tab(4), "log.hazard[j] <- log.h0.T[j] + etaBaseline[j]",
         paste_Xl, "\n\n",
         tab(4), "for (k in 1:15) {", "\n",
         tab(6), "log.h0.s[j, k] <- inprod(Bs.gammas[], Bmat_h0s[15 * (j - 1) + k, ])", "\n",
         tab(6), "SurvLong[j, k] <- gkw[k] * exp(log.h0.s[j, k]",
         paste_mu_gk,
         ")\n\n",
         fit_mu_gk, "\n\n",
         fit_Xlgk, "\n",
         tab(4), "}", "\n\n",
         tab(4), "log.survival[j] <- -exp(etaBaseline[j]) * ", y_name ,"[j]/2 * sum(SurvLong[j, ])", "\n",
         tab(4), "phi[j] <- 5000 - ((status[j] * log.hazard[j])) - (log.survival[j])", "\n",
         tab(4), "zeros[j] ~ dpois(phi[j])"
  )
}

JM_priors <- function(K, Mlist, ...){
  K <- K[[which(sapply(Mlist$outnam, 'attr', 'type') == 'survival')]]


  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])", "\n",
                    tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }


  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    if (!all(is.na(K))) {
      paste0(
        tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
        distr,
        tab(), "}", "\n")
    },
    tab(), "Bs.gammas[1:9] ~ dmnorm(mu_reg_Bh0, tau_reg_Bh0)"
    # tab(), "Bs.gammas[1:5] ~ dmnorm(priorMean.Bs.gammas[], tau_reg_surv * priorTau.Bs.gammas[, ])"
  )
}
