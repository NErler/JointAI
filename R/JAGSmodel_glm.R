JAGSmodel_glm <- function(info) {
  # * settings for families & links -------------------------------------------

  index <- info$index[gsub('M_', '', info$resp_mat)]
  N <- info$N[gsub("M_", '', info$resp_mat)]

  distr <- get_distr(family = info$family, varname = info$varname,
                     index = index)

  linkfun <- get_linkfun(info$link)

  repar <- get_repar(family = info$family, varname = info$varname,
                     index = index)

  secndpar <- get_secndpar(family = info$family, varname = info$varname)

  linkindent <- get_linkindent(info$link)

  indent <- switch(info$family,
                   gaussian = nchar(info$varname) + 14 + linkindent,
                   binomial = nchar(info$varname) + 14 + linkindent,
                   Gamma = nchar(info$varname) + 14 + linkindent,
                   poisson = nchar(info$varname) + 14 + linkindent,
                   lognorm = nchar(info$varname) + 14 + linkindent,
                   beta = 4 + 3 + nchar(info$varname) + 7 + linkindent
  )

  modelname <- get_GLM_modelname(info$family)

  # * truncation ---------------------------------------------------------------
  trunc <- if (!is.null(info$trunc))
    paste0("T(", paste0(info$trunc, collapse = ", "), ")")


  # * lin. predictor of baseline covariates (including interaction terms) ------
  Mc_predictor <- paste_linpred(info$parname,
                                info$parelmts[[info$resp_mat]],
                                matnam = info$resp_mat,
                                index = index,
                                cols = info$lp[[info$resp_mat]],
                                scale_pars = info$scale_pars[[info$resp_mat]])


  # * dummy variables ----------------------------------------------------------
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n',
           paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                         dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                         index = index), collapse = "\n")
  }

  # * posterior predictive check -----------------------------------------------
  paste_ppc <- if (info$ppc) {
    if (info$family == 'gaussian') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4), info$varname, "_ppc[", index, "] ~ dnorm(mu_", info$varname,
        "[", index, "], tau_", info$varname,")", info$trunc, "\n"
      )
    } else if (info$family == 'lognorm') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4), info$varname, "_ppc[", index, "] ~ dlnorm(mu_", info$varname,
        "[", index, "], tau_", info$varname,")", "\n"
      )
    } else if (info$family == 'beta') {
      paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
        tab(4),  info$varname, "_ppc[", index, "]] ~ dbeta(shape1_", info$varname,
        "[", index, "], shape2_",
        info$varname, "[", index, "])T(1e-15, 1 - 1e-15)", "\n"
      )
    }
  }

  # * paste model --------------------------------------------------------------
  paste0(tab(), "# ", modelname, " model for ", info$varname, "\n",
         tab(), "for (", index, " in 1:", N, ") {", "\n",
         tab(4), info$resp_mat, "[", index,", ", info$resp_col,
         "] ~ ", distr, trunc, "\n",
         paste_ppc,
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", index, "]")), " <- ",
         add_linebreaks(Mc_predictor, indent = indent),
         dummies,
         info$trafos,
         "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(unlist(info$parelmts)), ":", max(unlist(info$parelmts)), ") {", "\n",
         get_priordistr(info$shrinkage, info$family, info$link, info$parname),
         tab(), "}",
         secndpar,
         # paste_ppc_prior,
         "\n"
  )
}
