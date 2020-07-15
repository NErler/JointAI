JAGSmodel_glm <- function(info) {

  index <- info$index[gsub('M_', '', info$resp_mat)]
  N <- info$N[gsub("M_", '', info$resp_mat)]

  # * settings for families & links -------------------------------------------
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
                   beta = nchar(info$varname) + 14 + linkindent
  )

  modelname <- get_GLM_modelname(info$family)

  # * truncation ---------------------------------------------------------------
  trunc <- if (!is.null(info$trunc)) {
    paste0('T(', if (!is.na(info$trunc[1])) info$trunc[1], ', ',
           if (!is.na(info$trunc[2])) info$trunc[2], ")")
  }

  # * linear predictor of baseline covariates (including interaction terms) ----
  linpred <- paste_linpred(info$parname,
                           info$parelmts[[info$resp_mat]],
                           matnam = info$resp_mat,
                           index = index,
                           cols = info$lp[[info$resp_mat]],
                           scale_pars = info$scale_pars[[info$resp_mat]])


  # * dummy variables ----------------------------------------------------------
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n\n', paste0(
           paste_dummies(resp_mat = info$resp_mat,
                         resp_col = info$resp_col, dummy_cols = info$dummy_cols,
                         index = index, refs = info$refs), collapse = "\n"),
           "\n")
  }


  # * posterior predictive check -----------------------------------------------
  # paste_ppc <- if (info$ppc) {
  #   if (info$family == 'gaussian') {
  #     paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
  #       tab(4), info$varname, "_ppc[", index, "] ~ dnorm(mu_", info$varname,
  #       "[", index, "], tau_", info$varname,")", info$trunc, "\n"
  #     )
  #   } else if (info$family == 'lognorm') {
  #     paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
  #       tab(4), info$varname, "_ppc[", index, "] ~ dlnorm(mu_", info$varname,
  #       "[", index, "], tau_", info$varname,")", "\n"
  #     )
  #   } else if (info$family == 'beta') {
  #     paste0(tab(4), '# Posterior predictive check for ', info$varname, '\n',
  #       tab(4),  info$varname, "_ppc[", index, "]] ~ dbeta(shape1_",
  #       info$varname,
  #       "[", index, "], shape2_",
  #       info$varname, "[", index, "])T(1e-15, 1 - 1e-15)", "\n"
  #     )
  #   }
  # }

  # * paste model --------------------------------------------------------------
  paste0('\r',
         tab(), add_dashes(paste0("# ", modelname, " model for ",
                                  info$varname)), "\n",
         tab(), "for (", index, " in 1:", N, ") {", "\n",
         tab(4), info$resp_mat, "[", index,", ", info$resp_col,
         "] ~ ", distr, trunc, "\n",
         # paste_ppc,
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", index, "]")), " <- ",
         add_linebreaks(linpred, indent = indent),
         dummies,
         info$trafos,
         "\n",
         tab(), "}", "\n\n",

         # priors
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(unlist(info$parelmts)), ":",
         max(unlist(info$parelmts)), ") {", "\n",
         get_priordistr(info$shrinkage, type = 'glm', info$family, info$link,
                        info$parname),
         tab(), "}",
         secndpar,
         # paste_ppc_prior,
         "\n"
  )
}
