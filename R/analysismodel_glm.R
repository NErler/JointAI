# Function to write generalized linear regression model as analysis model
# @param N number of subjects / random intercepts
# @param y y
# @param Z random effects design matrix
# @param Xic design matrix of cross-sectional interaction effects
# @param Xl design matrix of longitudinal covariates
# @param hc_list hierarchical centering specification
# @param K matrix specifying the number of parameters for each component of the
#        fixed effects
#
# @export
glm_model <- function(family, link, Mlist, K, ...){

  y_name <- colnames(Mlist$y)

  distr <- switch(family,
                  "gaussian" = function(y_name) {
                    paste0("dnorm(mu_", y_name, "[j], tau_", y_name, ")")
                  },
                  "binomial" =  function(y_name) {
                    paste0("dbern(mu_", y_name, "[j])")
                  },
                  "Gamma" =  function(y_name) {
                    paste0("dgamma(shape_", y_name, "[j], rate_", y_name, "[j])")
                  },
                  "poisson" = function(y_name) {
                    paste0("dpois(mu_", y_name, "[j])")
                  }
  )

  repar <- switch(family,
                  "gaussian" = NULL,
                  "binomial" = NULL,
                  "Gamma" = paste0(tab(), "shape_", y_name, "[j] <- pow(mu_", y_name,
                                   "[j], 2) / pow(sigma_", y_name, ", 2)",
                                   "\n",
                                   tab(), "rate_", y_name, "[j]  <- mu_", y_name,
                                   "[j] / pow(sigma_", y_name, ", 2)", "\n"),
                  "Poisson" = NULL)


  linkfun <- switch(link,
                    "identity" = function(x) x,
                    "logit"    = function(x) paste0("logit(", x, ")"),
                    "probit"   = function(x) paste0("probit(", x, ")"),
                    "log"      = function(x) paste0("log(", x, ")"),
                    "cloglog"  = function(x) paste0("cloglog(", x, ")"),
                    # "sqrt"     = function(x) paste0("sqrt(", x, ")"),
                    "inverse"  = function(x) paste0("1/", x)
  )


  paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
    paste0(" + \n", tab(12 + nchar(y_name)),
           "inprod(Xic[j, ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }


  paste_ppc <- if (Mlist$ppc) {
    paste0(
      tab(4), y_name, "_ppc[j] ~ ", distr(y_name), "\n"
    )
  }


  paste0(tab(), "# ", capitalize(family), " model for ", y_name, "\n",
         tab(), y_name, "[j] ~ ", distr(y_name), "\n",
         paste_ppc,
         repar,
         tab(), linkfun(paste0("mu_", y_name, "[j]")),
         " <- inprod(Xc[j, ], beta[", K['Xc', 1], ":", K['Xc', 2], "])",
         paste_Xic
  )
}



# Write priors for the regression coefficients of the linear model
# @param K K
# @param y_name character string, name of outcome
# @export
glm_priors <- function(family, K, Mlist, ...){
  y_name <- colnames(Mlist$y)

  secndpar <- switch(family,
                     "gaussian" = paste0("\n",
                                         tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
                                         tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")"),
                     "binomial" = NULL,
                     "Gamma" = paste0("\n",
                                      tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
                                      tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")"),
                     "Poisson" = NULL)

  paste_ppc <- if (Mlist$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', y_name, '\n',
           tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
           tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
           tab(), 'ppc_', y_name, " <- mean(ifelse(ppc_", y_name, "_o > ppc_", y_name, "_e, 1, 0) + ",
                                           "ifelse(ppc_", y_name, "_o == ppc_", y_name, "_e, 0.5, 0)) - 0.5", "\n"
    )
  }


  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}",
    secndpar,
    paste_ppc, "\n\n")
}

