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
lm_model <- function(N, y_name, Z = NULL, Xic = NULL, Xl = NULL,
                      Xil = NULL, hc_list = NULL, Mlist = NULL, K, ...){

  if (!is.null(Mlist)) {
    for (i in 1:length(Mlist)) {
      assign(names(Mlist)[i], Mlist[[i]])
    }
  }

  paste_Xic <- if (!is.null(Xic)) {
    paste0(" + \n", tab(12 + nchar(y_name)),
           "inprod(Xic[j, ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }



  paste0(tab(), "# Linear model for ", y_name, "\n",
         tab(), y_name, "[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n",
         tab(), "mu_", y_name, "[j] <- inprod(Xc[j, ], beta[", K['Xc', 1], ":", K['Xc', 2], "])",
         paste_Xic
  )
}



# Write priors for the regression coefficients of the linear model
# @param K K
# @param y_name character string, name of outcome
# @export
lm_priors <- function(K, y_name, ...){
  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}", "\n",
    tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
    tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")", "\n\n")
}
