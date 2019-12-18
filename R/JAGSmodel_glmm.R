
JAGSmodel_glmm <- function(info) {
  # settings for different types -----------------------------------------------
  distr <- switch(info$family,
                  "gaussian" = paste0("dnorm(mu_", info$varname, "[", info$index[1], "], tau_", info$varname, ")"),
                  "binomial" = paste0("dbern(mu_", info$varname, "[", info$index[1], "])"),
                  "Gamma" = paste0("dgamma(shape_", info$varname, "[", info$index[1],
                                   "], rate_", info$varname, "[", info$index[1], "])"),
                  "poisson" = paste0("dpois(mu_", info$varname, "[", info$index[1], "])"),
                  "lognorm" = paste0("dlnorm(mu_", info$varname, "[", info$index[1], "], tau_", info$varname, ")"),
                  "beta" = paste0('dbeta(shape1_', info$varname, "[",
                                  info$index[1], "], shape2_", info$varname, "[",
                                  info$index[1], "])T(1e-15, 1 - 1e-15)")

  )

  linkfun <- switch(info$link,
                    "identity" = function(x) x,
                    "logit"    = function(x) paste0("logit(", x, ")"),
                    "probit"   = function(x) paste0("probit(", x, ")"),
                    "log"      = function(x) paste0("log(", x, ")"),
                    "cloglog"  = function(x) paste0("cloglog(", x, ")"),
                    # "sqrt"     = function(x) paste0("sqrt(", x, ")"),
                    # "cauchit is not available in JAGS
                    "inverse"  = function(x) paste0("1/", x)
  )



  indent <- switch(info$family,
                   gaussian = nchar(info$varname) + 14 + linkindent(info$link),
                   binomial = nchar(info$varname) + 14 + linkindent(info$link),
                   Gamma = nchar(info$varname) + 14 + linkindent(info$link),
                   poisson = nchar(info$varname) + 14 + linkindent(info$link),
                   lognorm = nchar(info$varname) + 14 + linkindent(info$link),
                   beta = 4 + 9 + nchar(info$varname) + 8 + linkindent(info$link)
  )


  modelname <- switch(info$family,
                      "gaussian" = 'Normal',
                      "binomial" = 'Binomial',
                      "Gamma" = 'Gamma',
                      "poisson" = 'Poisson',
                      "lognorm" = 'Log-normal',
                      "beta" = 'Beta'
  )


  repar <- switch(info$family,
                  "gaussian" = NULL,
                  "binomial" = NULL,
                  "Gamma" = paste0(tab(4), "shape_", info$varname, "[", info$index[1], "] <- pow(mu_", info$varname,
                                   "[", info$index[1], "], 2) / pow(sigma_", info$varname, ", 2)",
                                   "\n",
                                   tab(4), "rate_", info$varname, "[", info$index[1], "]  <- mu_", info$varname,
                                   "[", info$index[1], "] / pow(sigma_", info$varname, ", 2)", "\n"),
                  "Poisson" = NULL,
                  'lognorm' = NULL,
                  'beta' = paste0(tab(4), "shape1_", info$varname,"[", info$index[1], "] <- mu_",
                                  info$varname, "[", info$index[1], "] * tau_", info$varname, "\n",
                                  tab(4), "shape2_", info$varname, "[", info$index[1], "] <- (1 - mu_",
                                  info$varname, "[", info$index[1], "]) * tau_", info$varname),
  )


  secndpar <- switch(info$family,
                     "gaussian" = paste0("\n",
                                         tab(), "tau_", info$varname ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
                                         tab(), "sigma_", info$varname," <- sqrt(1/tau_", info$varname, ")"),
                     "binomial" = NULL,
                     "Gamma" = paste0("\n",
                                      tab(), "tau_", info$varname ," ~ dgamma(shape_tau_gamma, rate_tau_gamma)", "\n",
                                      tab(), "sigma_", info$varname," <- sqrt(1/tau_", info$varname, ")"),
                     "poisson" = NULL,
                     "lognorm" = paste0("\n",
                                        tab(), "tau_", info$varname ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
                                        tab(), "sigma_", info$varname," <- sqrt(1/tau_", info$varname, ")")
  )

  priorset <- switch(info$family,
                     gaussian = 'norm',
                     binomial = info$link,
                     Gamma = 'gamma',
                     poisson = 'poisson',
                     lognorm = 'norm',
                     beta = 'beta'
  )


  # model parts ----------------------------------------------------------------
  rd_predictor <- get_ranefpreds(info)

  norm.distr  <- if (length(info$hc_list) < 2) {"dnorm"} else {"dmnorm"}

  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n', paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                               dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                               index = info$index[1]), collapse = "\n")
  }


  trunc <- if (!is.null(info$trunc))
    paste0("T(", paste0(info$trunc, collapse = ", "), ")")



  # posterior predictive check -------------------------------------------------
  paste_ppc <- if (info$ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), info$varname, "_ppc[", info$index[1], "] ~ ", distr(info$varname), trunct, "\n"
    )
  }

  paste_ppc_prior <- if (info$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', info$varname, '\n',
           tab(), 'ppc_', info$varname, "_o <- pow(", info$varname, "[] - mu_", info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, "_e <- pow(", info$varname, "_ppc[] - mu_", info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, " <- mean(step(ppc_", info$varname, "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
    )
  }


  # shrinkage ------------------------------------------------------------------
  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_", priorset, ", tau_reg_", priorset , "_ridge[k])", "\n",
                         tab(4), "tau_reg_", priorset, "_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_", priorset, ", tau_reg_", priorset, ")", "\n")
  }


  # write model ----------------------------------------------------------------
  paste0(tab(), "# ", modelname, " mixed effects model for ", info$varname, "\n",
         tab(), "for (", info$index[1], " in 1:", info$Ntot, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index[1], ", ", info$resp_col, "] ~ ",
         distr, trunc, "\n",
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", info$index[1], "]")), " <- ",
         paste0(c(rd_predictor$Z_predictor, rd_predictor$Ml_predictor), collapse = " +\n"),
         "\n",
         paste_ppc,
         dummies,
         "\n",
         tab(), "}", "\n",
         "\n",
         tab(), "for (", info$index[2], " in 1:", info$N, ") {", "\n",
         tab(4), "b_", info$varname, "[", info$index[2], ", 1:", max(1, length(info$hc_list)), "] ~ ", norm.distr,
         "(mu_b_", info$varname, "[", info$index[2], ", ], invD_", info$varname, "[ , ])", "\n",
         rd_predictor$ranefpreds, "\n",
         info$trafos,
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(info$parelmts$Mc, info$parelmts$Ml), ":",
         max(info$parelmts$Mc, info$parelmts$Ml), ") {", "\n",
         priordistr,
         tab(), "}",
         secndpar,
         paste_ppc_prior,
         "\n",
         ranef_priors(max(1, length(info$hc_list)), info$varname)
  )
}
