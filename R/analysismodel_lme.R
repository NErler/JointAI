# Linear mixed model -----------------------------------------------------------
lme_model <- function(Mlist, K, ...){
  y_name <- colnames(Mlist$y)
  indent <- nchar(y_name) + 4 + 10

  norm.distr  <- if (ncol(Mlist$Z) < 2) {"dnorm"} else {"dmnorm"}

  paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
    paste0(" + \n", tab(18),
           paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = 18))
  }

  paste_Xl <- if (length(Mlist$cols_main$Xl) > 0) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xl',
                           parelmts = K["Xl", 1]:K["Xl", 2],
                           cols = Mlist$cols_main$Xl, indent = indent)
    )
  }

  paste_Xil <- if (length(Mlist$cols_main$Xil) > 0) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xil',
                           parelmts = K["Xil", 1]:K["Xil", 2],
                           cols = Mlist$cols_main$Xil, indent = indent)
    )
  }


  paste_ppc <- NULL # if (Mlist$ppc) {
  #   paste0(
  #     tab(4), y_name, "_ppc[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n"
  #   )
  # }

  paste0(tab(4), "# Linear mixed effects model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n",
         paste_ppc,
         tab(4), "mu_", y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
         paste_Xl,
         paste_Xil, "\n",
         tab(2), "}", "\n\n",
         tab(2), "for (i in 1:", Mlist$N, ") {", "\n",
         tab(4), "b[i, 1:", Mlist$nranef, "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
         tab(4), "mu_b[i, 1] <- ",
         paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xc',
                         parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = 18),
         paste_Xic, "\n",
         paste_rdslopes(Mlist$nranef, Mlist$hc_list, K)
  )
}



# priors for linear mixed model
lme_priors <- function(K_list, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste_ppc <- NULL #if (Mlist$ppc) {
  #   paste0('\n',
  #          tab(), '# Posterior predictive check for the model for ', y_name, '\n',
  #          tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
  #          tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
  #          tab(), 'ppc_', y_name, " <- mean(step(ppc_", y_name, "_o - ppc_", y_name, "_e)) - 0.5", "\n"
  #   )
  # }

  paste0(c(ranef_priors(Mlist$nranef),
           lmereg_priors(K_list, y_name, Mlist),
           paste_ppc), collapse = "\n\n")
}


lmereg_priors <- function(K_list, y_name, Mlist){

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

    # tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    # distr,
    # tab(), "}", "\n",
    # tab(), "tau_", y_name ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
    # tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")",
    "\n")
}

