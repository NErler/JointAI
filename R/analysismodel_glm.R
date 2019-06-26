# Generalized linear model
glm_model <- function(family, link, Mlist, K, ...){

  y_name <- colnames(Mlist$y)
  indent <- 4 + nchar(link) + 12 + nchar(y_name)


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
                  "Gamma" = paste0(tab(4), "shape_", y_name, "[j] <- pow(mu_", y_name,
                                   "[j], 2) / pow(sigma_", y_name, ", 2)",
                                   "\n",
                                   tab(4), "rate_", y_name, "[j]  <- mu_", y_name,
                                   "[j] / pow(sigma_", y_name, ", 2)", "\n"),
                  "Poisson" = NULL)



  linkfun <- switch(link,
                    "identity" = function(x) x,
                    "logit"    = function(x) paste0("logit(", x, ")"),
                    "probit"   = function(x) paste0("probit(", x, ")"),
                    "log"      = function(x) paste0("log(", x, ")"),
                    "cloglog"  = function(x) paste0("cloglog(", x, ")"),
                    # "sqrt": JAGS does not have this link function
                    "inverse"  = function(x) paste0("1/", x)
  )

  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(indent),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = indent))
  }

  paste_ppc <- NULL #if (Mlist$ppc) {
  #   paste0(
  #     tab(4), y_name, "_ppc[j] ~ ", distr(y_name), "\n"
  #   )
  # }


  paste0(tab(4), "# ", capitalize(family), " model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ ", distr(y_name), "\n",
         paste_ppc,
         repar,
         tab(4), linkfun(paste0("mu_", y_name, "[j]")), " <- ",
         paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xc',
                         parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = indent),
         paste_Xic
  )
}



# priors for GLM analysis model
glm_priors <- function(family, link, K_list, Mlist, ...){
  y_name <- colnames(Mlist$y)

  secndpar <- switch(family,
                     "gaussian" = paste0("\n",
                                         tab(), "tau_", y_name ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
                                         tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")"),
                     "binomial" = NULL,
                     "Gamma" = paste0("\n",
                                      tab(), "tau_", y_name ," ~ dgamma(shape_tau_gamma, rate_tau_gamma)", "\n",
                                      tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")"),
                     "poisson" = NULL)

  paste_ppc <- NULL #if (Mlist$ppc) {
  #   paste0('\n\n',
  #          tab(), '# Posterior predictive check for the model for ', y_name, '\n',
  #          tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
  #          tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
  #          tab(), 'ppc_', y_name, " <- mean(ifelse(ppc_", y_name, "_o > ppc_", y_name, "_e, 1, 0) + ",
  #                                          "ifelse(ppc_", y_name, "_o == ppc_", y_name, "_e, 0.5, 0)) - 0.5"
  #   )
  # }

  type <- switch(family,
                 gaussian = 'norm',
                 binomial = link,
                 Gamma = 'gamma',
                 poisson = 'poisson'
  )


  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_", type, ", tau_reg_", type , "_ridge[k])", "\n",
                    tab(4), "tau_reg_", type, "_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_", type, ", tau_reg_", type, ")", "\n")
  }


  paste0(
    paste_regcoef_prior(K_list, distr, 'beta'),
    if (any(rownames(K_list) == "uni")) {
      paste0(
        tab(), "tau_", y_name ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
        tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")", "\n"
      )
    },
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    # tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    # distr,
    # tab(), "}",
    secndpar,
    paste_ppc, "\n\n")
}

