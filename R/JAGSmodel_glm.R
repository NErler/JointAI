JAGSmodel_glm <- function(info) {
  # * settings for families & links -------------------------------------------
  distr <- get_distr(family = info$family, varname = info$varname,
                     index = info$index)

  linkfun <- get_linkfun(info$link)

  repar <- get_repar(family = info$family, varname = info$varname,
                     index = info$index)

  secndpar <- get_secndpar(family = info$family, varname = info$varname)

  linkindent <- get_linkindent(info$link)

  indent <- switch(info$family,
                   gaussian = nchar(info$varname) + 14 + linkindent,
                   binomial = nchar(info$varname) + 14 + linkindent,
                   Gamma = nchar(info$varname) + 14 + linkindent,
                   poisson = nchar(info$varname) + 14 + linkindent,
                   lognorm = nchar(info$varname) + 14 + linkindent,
                   beta = 4 + 9 + nchar(info$varname) + 8 + linkindent
  )

  modelname <- get_GLM_modelname(info$family)

  # * truncation ---------------------------------------------------------------
  trunc <- if (!is.null(info$trunc))
    paste0("T(", paste0(info$trunc, collapse = ", "), ")")


  # * lin. predictor of baseline covariates (including interaction terms) ------
  Mc_predictor <- paste_linpred(info$parname, info$parelmts$Mc, matnam = "Mc",
                                index = info$index, cols = info$lp$Mc,
                                scale_pars = info$scale_pars$Mc)


  # * dummy variables ----------------------------------------------------------
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n',
           paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                         dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                         index = info$index), collapse = "\n")
  }

  # * posterior predictive check -----------------------------------------------
  paste_ppc <- if (info$ppc) {
    if (info$family == 'gaussian') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4), info$varname, "_ppc[", info$index, "] ~ dnorm(mu_", info$varname,
        "[", info$index, "], tau_", info$varname,")", info$trunc, "\n"
      )
    } else if (info$family == 'lognorm') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4), info$varname, "_ppc[", info$index, "] ~ dlnorm(mu_", info$varname,
        "[", info$index, "], tau_", info$varname,")", "\n"
      )
    } else if (info$family == 'beta') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4),  info$varname, "_ppc[", info$index, "]] ~ dbeta(shape1_", info$varname,
        "[", info$index, "], shape2_",
        info$varname, "[", info$index, "])T(1e-15, 1 - 1e-15)", "\n"
      )
    }
  }

  # * paste model --------------------------------------------------------------
  paste0(tab(), "# ", modelname, " model for ", info$varname, "\n",
         tab(), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index,", ", info$resp_col,
         "] ~ ", distr, trunc, "\n",
         paste_ppc,
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", info$index, "]")), " <- ",
         add_linebreaks(Mc_predictor, indent = indent),
         dummies,
         info$trafos,
         "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(info$parelmts$Mc), ":", max(info$parelmts$Mc), ") {", "\n",
         get_priordistr(info$shrinkage, info$family, info$link, info$parname),
         tab(), "}",
         secndpar,
         # paste_ppc_prior,
         "\n"
  )
}
