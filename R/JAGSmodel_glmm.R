
JAGSmodel_glmm <- function(info) {

  index <- info$index[gsub('M_', '', info$resp_mat)]

  # settings for different types -----------------------------------------------
  distr <- get_distr(family = info$family, varname = info$varname,
                     index = index)

  linkfun <- get_linkfun(info$link)

  repar <- get_repar(family = info$family, varname = info$varname,
                     index = index)

  secndpar <- get_secndpar(family = info$family, varname = info$varname)

  modelname <- get_GLM_modelname(info$family)

  linkindent <- get_linkindent(info$link)

  indent <- switch(info$family,
                   gaussian = nchar(info$varname) + 14 + linkindent,
                   binomial = nchar(info$varname) + 14 + linkindent,
                   Gamma = nchar(info$varname) + 14 + linkindent,
                   poisson = nchar(info$varname) + 14 + linkindent,
                   lognorm = nchar(info$varname) + 14 + linkindent,
                   beta = nchar(info$varname) + 14 + linkindent
  )


  # model parts ----------------------------------------------------------------
  rdintercept <- paste_rdintercept_lp(info)
  rdslopes <- paste_rdslope_lp(info)
  Z_predictor <- paste_lp_Zpart(info)

  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n\n', paste0(
      paste_dummies(resp_mat = info$resp_mat,
                    resp_col = info$resp_col, dummy_cols = info$dummy_cols,
                    index = index, refs = info$refs), collapse = "\n"), "\n")
  }


  trunc <- if (!is.null(info$trunc)) {
    paste0('T(', if (!is.na(info$trunc[1])) info$trunc[1], ', ',
           if (!is.na(info$trunc[2])) info$trunc[2], ")")
  }



  # posterior predictive check -------------------------------------------------
  paste_ppc <- if (info$ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), info$varname, "_ppc[", index, "] ~ ", distr(info$varname),
           trunc, "\n"
    )
  }

  paste_ppc_prior <- if (info$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ',
           info$varname, '\n',
           tab(), 'ppc_', info$varname, "_o <- pow(", info$varname, "[] - mu_",
           info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, "_e <- pow(", info$varname,
           "_ppc[] - mu_",
           info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, " <- mean(step(ppc_", info$varname,
           "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
    )
  }


  # write model ----------------------------------------------------------------
  paste0(tab(), add_dashes(paste0("# ", modelname, " mixed effects model for ",
                                  info$varname)), "\n",
         tab(), "for (", index, " in 1:", info$N[gsub("M_", "", info$resp_mat)],
         ") {", "\n",
         tab(4), info$resp_mat, "[", index, ", ", info$resp_col, "] ~ ",
         distr, trunc, "\n",
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", index, "]")), " <- ",
         add_linebreaks(paste0(Z_predictor, collapse = " + "), indent = indent),
         "\n",
         paste_ppc,
         dummies,
         info$trafos,
         tab(), "}", "\n",
         "\n",
         paste0(sapply(names(rdintercept), write_ranefs, info = info,
                       rdintercept = rdintercept, rdslopes = rdslopes),
                collapse = ''),
         tab(), "# Priors for the model for ", info$varname, "\n",
         tab(), "for (k in ", min(unlist(info$parelmts)), ":",
         max(unlist(info$parelmts)), ") {", "\n",
         get_priordistr(info$shrinkage, type = 'glmm', info$family,
                        info$link, info$parname),
         tab(), "}",
         secndpar,
         paste_ppc_prior,
         "\n",
         paste0(
           sapply(names(info$hc_list$hcvars), function(x) {
             ranef_priors(info$nranef[x], paste0(info$varname, "_", x))
           }), collapse = "\n")
  )
}



glmm_in_JM <- function(info) {
  index <- info$index[info$surv_lvl]


  # settings for different types -----------------------------------------------
  distr <- get_distr(family = info$family,
                     varname = info$varname,
                     index = index, isgk = TRUE)

  linkfun <- get_linkfun(info$link)

  repar <- get_repar(family = info$family,
                     varname = info$varname,
                     index = index,
                     isgk = TRUE)

  linkindent <- get_linkindent(info$link)


  # model parts ----------------------------------------------------------------
  Z_predictor <- paste_lp_Zpart(info, isgk = TRUE)

  trunc <- if (!is.null(info$trunc)) {
    paste0('T(', if (!is.na(info$trunc[1])) info$trunc[1], ', ',
           if (!is.na(info$trunc[2])) info$trunc[2], ")")
  }

  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n',tab(),
           paste_dummies(resp_mat = paste0(info$resp_mat, "gk"),
                         resp_col = paste0(info$resp_col, ', k'),
                         dummy_cols = paste0(info$dummy_cols, ', k'),
                         index = index, refs = info$refs), collapse = "\n")
  }


  # write model ----------------------------------------------------------------
  paste0(tab(6), info$resp_mat, "gk[", index, ", ", info$resp_col, ", k] ~ ",
         distr, trunc, "\n",
         repar,
         tab(6), linkfun(paste0("mugk_", info$varname, "[", index, ", k]")),
         " <- ",
         add_linebreaks(Z_predictor, indent = linkindent + 11 +
                          nchar(info$varname) + 9 + nchar(index)),
         "\n",
         dummies,
         info$trafos,
         "\n"
  )
}

