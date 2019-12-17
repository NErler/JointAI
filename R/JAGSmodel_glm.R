# model specification ----------------------------------------------------------
JAGSmodel_glm <- function(info) {

  distr <- switch(info$family,
                  "gaussian" = paste0("dnorm(mu_", info$varname, "[",
                                      info$index, "], tau_", info$varname, ")"),
                  "binomial" = paste0("dbern(mu_", info$varname, "[",
                                      info$index, "])"),
                  "Gamma" = paste0("dgamma(shape_", info$varname, "[",
                                   info$index, "], rate_", info$varname, "[",
                                   info$index, "])"),
                  "poisson" = paste0("dpois(max(1e-10, mu_", info$varname, "[",
                                     info$index, "]))"),
                  "lognorm" = paste0("dlnorm(mu_", info$varname, "[",
                                     info$index, "], tau_", info$varname, ")"),
                  "beta" = paste0('dbeta(shape1_', info$varname, "[",
                                  info$index, "], shape2_", info$varname, "[",
                                  info$index, "])T(1e-15, 1 - 1e-15)")
  )

  repar <- switch(info$family,
                  "gaussian" = NULL,
                  "binomial" = NULL,
                  "Gamma" = paste0(tab(4), "shape_", info$varname, "[", info$index, "] <- pow(mu_", info$varname,
                                   "[", info$index, "], 2) / pow(sigma_", info$varname, ", 2)",
                                   "\n",
                                   tab(4), "rate_", info$varname, "[", info$index, "]  <- mu_", info$varname,
                                   "[", info$index, "] / pow(sigma_", info$varname, ", 2)", "\n"),
                  "Poisson" = NULL,
                  'lognorm' = NULL,
                  'beta' = paste0(tab(4), "shape1_", info$varname,"[", info$index, "] <- mu_",
                                  info$varname, "[", info$index, "] * tau_", info$varname, "\n",
                                  tab(4), "shape2_", info$varname, "[", info$index, "] <- (1 - mu_",
                                  info$varname, "[", info$index, "]) * tau_", info$varname),
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


  linkfun <- switch(info$link,
                    "identity" = function(x) x,
                    "logit"    = function(x) paste0("logit(", x, ")"),
                    "probit"   = function(x) paste0("probit(", x, ")"),
                    "log"      = function(x) paste0("log(", x, ")"),
                    "cloglog"  = function(x) paste0("cloglog(", x, ")"),
                    # "sqrt": JAGS does not have this link function
                    "inverse"  = function(x)
                      paste0(x, " <- 1/max(1e-10, inv_", x, ")", "\n",
                             tab(4), "inv_", x)
  )

  linkindent <- switch(info$link,
                       identity = 0,
                       logit = 7,
                       probit = 8,
                       log = 5,
                       cloglog = 9,
                       inverse = 4)

  indent <- switch(info$family,
                   gaussian = nchar(info$varname) + 14 + linkindent,
                   binomial = nchar(info$varname) + 14 + linkindent,
                   Gamma = nchar(info$varname) + 14 + linkindent,
                   poisson = nchar(info$varname) + 14 + linkindent,
                   lognorm = nchar(info$varname) + 14 + linkindent,
                   beta = 4 + 9 + nchar(info$varname) + 8 + linkindent
  )

  modelname <- switch(info$family,
                      "gaussian" = 'Normal',
                      "binomial" = 'Binomial',
                      "Gamma" = 'Gamma',
                      "poisson" = 'Poisson',
                      "lognorm" = 'Log-normal',
                      "beta" = 'Beta'
  )

  trunc <- if (!is.null(info$trunc))
    paste0("T(", paste0(info$trunc, collapse = ", "), ")")

  # linear predictor of baseline covariates (including interaction terms)
  Mc_predictor <- paste_predictor(parnam = info$parname, parindex = info$index,
                                  matnam = 'Mc',
                                  cols = info$lp$Mc,
                                  parelmts = info$parelmts$Mc,
                                  scale_pars = info$scale_pars$Mc,
                                  indent = indent)


  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n', paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                         dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                         index = info$index), collapse = "\n")
  }

  paste_ppc <- if (info$ppc) {
    if (type == 'norm') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4), info$varname, "_ppc[", info$index, "] ~ dnorm(mu_", info$varname,
        "[", info$index, "], tau_", info$varname,")", info$trunc, "\n"
      )
    } else if (type == 'lognorm') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4), info$varname, "_ppc[", info$index, "] ~ dlnorm(mu_", info$varname,
        "[", info$index, "], tau_", info$varname,")", "\n"
      )
    } else if (type == 'beta') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4),  info$varname, "_ppc[", info$index, "]] ~ dbeta(shape1_", info$varname,
        "[", info$index, "], shape2_",
        info$varname, "[", info$index, "])T(1e-15, 1 - 1e-15)", "\n"
      )
    }
  }

  priorset <- switch(info$family,
                     gaussian = 'norm',
                     binomial = info$link,
                     Gamma = 'gamma',
                     poisson = 'poisson',
                     lognorm = 'norm',
                     beta = 'beta'
  )


  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_", priorset, ", tau_reg_", priorset , "_ridge[k])", "\n",
                    tab(4), "tau_reg_", priorset, "_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_", priorset, ", tau_reg_", priorset, ")", "\n")
  }


  paste0(tab(), "# ", modelname, " model for ", info$varname, "\n",
         tab(), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index,", ", info$resp_col,
         "] ~ ", distr, trunc, "\n",
         paste_ppc,
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", info$index, "]")), " <- ",
         Mc_predictor,
         dummies,
         info$trafos,
         "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(info$parelmts$Mc), ":", max(info$parelmts$Mc), ") {", "\n",
         priordistr,
         tab(), "}",
         secndpar,
         # paste_ppc_prior,
         "\n"
  )
}
