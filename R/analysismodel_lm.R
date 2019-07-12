# Linear regression model ------------------------------------------------------
lm_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)
  indent <- 4 + 10 + nchar(y_name)

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = indent))
  }

  paste_ppc <- if (Mlist$ppc) {
    paste0(
      tab(4), y_name, "_ppc[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n"
    )
  }

  paste0(tab(4), "# Linear model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n",
         paste_ppc,
         tab(4), "mu_", y_name, "[j] <- ",
         paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xc',
                         parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = indent),
         paste_Xic
  )
}



# priors for linear regression model -------------------------------------------
lm_priors <- function(K_list, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste_ppc <- NULL # if (Mlist$ppc) {
  #   paste0('\n',
  #     tab(), '# Posterior predictive check for the model for ', y_name, '\n',
  #     tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
  #     tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
  #     tab(), 'ppc_', y_name, " <- mean(step(ppc_", y_name, "_o - ppc_", y_name, "_e)) - 0.5", "\n"
  #   )
  # }


  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_norm, tau_reg_norm_ridge[k])", "\n",
                    tab(4), "tau_reg_norm_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_norm, tau_reg_norm)", "\n")
  }


  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    paste_regcoef_prior(K_list, distr, 'beta'),
    if (any(rownames(K_list) == "uni")) {
      paste0(
        tab(), "tau_", y_name ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
        tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")", "\n"
      )
    },
    paste_ppc, "\n")
}

