# Function to write linear regression model as analysis model
# @param N number of subjects / random intercepts
# @param y y
# @param Z random effects design matrix
# @param Xic design matrix of cross-sectional interaction effects
# @param Xl design matrix of longitudinal covariates
# @param hc_list hierarchical centering specification
# @param K matrix specifying the number of parameters for each component of the
#        fixed effects
# @export
lm_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)
  indent <- 4 + 10 + nchar(y_name)

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(nchar(y_name) + 17),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = indent))
  }

  paste_ppc <- NULL #if (Mlist$ppc) {
  #   paste0(
  #     tab(4), y_name, "_ppc[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n"
  #   )
  # }

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



# Write priors for the regression coefficients of the linear model
# @param K K
# @param y_name character string, name of outcome
# @export
lm_priors <- function(K, Mlist, ...){
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
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main[k])", "\n",
                    tab(4), "tau_reg_main[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n")
  }


  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    distr,
    tab(), "}", "\n",
    tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
    tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")", "\n",
    paste_ppc, "\n")
}
