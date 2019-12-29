
JAGSmodel_glmm <- function(info) {
  # settings for different types -----------------------------------------------
  distr <- get_distr(family = info$family, varname = info$varname,
                     index = info$index[1])

  linkfun <- get_linkfun(info$link)

  repar <- get_repar(family = info$family, varname = info$varname,
                     index = info$index)

  secndpar <- get_secndpar(family = info$family, varname = info$varname)

  modelname <- get_GLM_modelname(info$family)

  linkindent <- get_linkindent(info$link)

  indent <- switch(info$family,
                   gaussian = nchar(info$varname) + 14 + linkindent,
                   binomial = nchar(info$varname) + 14 + linkindent,
                   Gamma = nchar(info$varname) + 14 + linkindent,
                   poisson = nchar(info$varname) + 14 + linkindent,
                   lognorm = nchar(info$varname) + 14 + linkindent,
                   beta = 4 + 9 + nchar(info$varname) + 8 + linkindent
  )

  # model parts ----------------------------------------------------------------
  hc_info <- get_hc_info(info)
  hc_parelmts <- organize_hc_parelmts(hc_info, info = info)
  rdslopes <- paste_rdslope_lp(hc_info, info)
  rdintercept <- paste_rdintercept_lp(info, hc_parelmts$in_b0)

  Z_predictor <- paste_Zpart(info, index = info$index[1], hc_info,
                             notin_b = hc_parelmts$notin_b, isgk = FALSE)

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
           tab(4), info$varname, "_ppc[", info$index[1], "] ~ ", distr(info$varname), trunc, "\n"
    )
  }

  paste_ppc_prior <- if (info$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', info$varname, '\n',
           tab(), 'ppc_', info$varname, "_o <- pow(", info$varname, "[] - mu_",
           info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, "_e <- pow(", info$varname, "_ppc[] - mu_",
           info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, " <- mean(step(ppc_", info$varname,
           "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
    )
  }


  # write model ----------------------------------------------------------------
  paste0(tab(), "# ", modelname, " mixed effects model for ", info$varname, "\n",
         tab(), "for (", info$index[1], " in 1:", info$Ntot, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index[1], ", ", info$resp_col, "] ~ ",
         distr, trunc, "\n",
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", info$index[1], "]")), " <- ",
         add_linebreaks(Z_predictor, indent = indent),
         "\n",
         paste_ppc,
         dummies,
         info$trafos,
         "\n",
         tab(), "}", "\n",
         "\n",
         tab(), "for (", info$index[2], " in 1:", info$N, ") {", "\n",
         tab(4), "b_", info$varname, "[", info$index[2], ", 1:",
         max(1, length(info$hc_list)), "] ~ ", norm.distr,
         "(mu_b_", info$varname, "[", info$index[2], ", ], invD_", info$varname, "[ , ])", "\n",
         paste_mu_b(rdintercept, rdslopes, info$varname, info$index[2]),
         "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(info$parelmts$Mc, info$parelmts$Ml), ":",
         max(info$parelmts$Mc, info$parelmts$Ml), ") {", "\n",
         get_priordistr(info$shrinkage, info$family, info$link, info$parname),
         tab(), "}",
         secndpar,
         paste_ppc_prior,
         "\n",
         ranef_priors(max(1, length(info$hc_list)), info$varname)
  )
}



glmm_in_JM <- function(info) {
  # settings for different types -----------------------------------------------
  distr <- get_distr(family = info$family,
                     varname = info$varname,
                     index = info$index[2], isgk = TRUE)

  linkfun <- get_linkfun(info$link)

  repar <- get_repar(family = info$family,
                     varname = info$varname,
                     index = info$index[2],
                     isgk = TRUE)

  linkindent <- get_linkindent(info$link)


  # model parts ----------------------------------------------------------------
  hc_info <- get_hc_info(info)
  hc_parelmts <- organize_hc_parelmts(hc_info, info = info)
  # rdslopes <- paste_rdslope_lp(hc_info, info)
  # rdintercept <- paste_rdintercept_lp(info, hc_parelmts$in_b0)

  Z_predictor <- paste_Zpart(info, index = info$index[2], hc_info,
                             notin_b = hc_parelmts$notin_b, isgk = TRUE)


  trunc <- if (!is.null(info$trunc))
    paste0("T(", paste0(info$trunc, collapse = ", "), ")")

  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n',tab(),
           paste_dummies(categories = info$categories,
                         dest_mat = paste0(info$resp_mat, "gk"),
                         dest_col = paste0(info$resp_col, ', k'),
                         dummy_cols = paste0(info$dummy_cols, ', k'),
                         index = info$index[2]), collapse = "\n")
  }


  # write model ----------------------------------------------------------------
  paste0(tab(6), info$resp_mat, "gk[", info$index[2], ", ", info$resp_col, ", k] ~ ",
         distr, trunc, "\n",
         repar,
         tab(6), linkfun(paste0("mugk_", info$varname, "[", info$index[2], ", k]")), " <- ",
         add_linebreaks(Z_predictor, indent = linkindent + 11 + nchar(info$varname) + 10),
         "\n",
         dummies,
         info$trafos,
         "\n"
  )
}

