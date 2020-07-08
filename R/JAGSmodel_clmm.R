JAGSmodel_clmm <- function(info) {

  # specify indent width and index character to be used
  indent <- 4 + 4 + nchar(info$varname) + 7
  index <- info$index[gsub("M_", "", info$resp_mat)]

  # main model elements --------------------------------------------------------

  # linear predictor of baseline covariates (including interaction terms)
  rdintercept <- paste_rdintercept_lp(info)
  rdslopes <- paste_rdslope_lp(info)
  Z_predictor <- paste_lp_Zpart(info)

  # syntax for probabilities, using min-max-trick for numeric stability
  # i.e., "p_O2[i, 2] <- psum_O2[i, 2] - psum_O2[i, 1]"
  probs <- sapply(2:(info$ncat - 1), function(k) {
    paste0(tab(4), "p_", info$varname, "[", index, ", ", k,
           "] <- max(1e-7, min(1-1e-10, psum_",
           info$varname, "[", index, ", ", k,"] - psum_", info$varname, "[",
           index, ", ", k - 1, "]))")})

  # syntax for logits, e.g., "logit(psum_O2[i, 1]) <- gamma_O2[1] + eta_O2[i]"
  logits <- sapply(1:(info$ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", info$varname, "[", index, ", ", k,
           "]) <- gamma_", info$varname,
           "[", k, "]", " + eta_", info$varname,"[", index, "]")
  })

  # syntax to set values of dummy variables,
  # e.g. "M_lvlone[i, 8] <- ifelse(M_lvlone[i, 4] == 2, 1, 0)"
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n', paste0(
      paste_dummies(resp_mat = info$resp_mat,
                    resp_col = info$resp_col, dummy_cols = info$dummy_cols,
                    index = index, refs = info$refs), collapse = "\n"), "\n")
  }


  # priors ---------------------------------------------------------------------
  deltas <- sapply(1:(info$ncat - 2), function(k) {
    paste0(tab(), "delta_", info$varname, "[", k,
           "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
  })

  gammas <- sapply(1:(info$ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", info$varname, "[", k,
             "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
    } else {
      paste0(tab(), "gamma_", info$varname, "[", k, "] <- gamma_",
             info$varname, "[", k - 1,
             "] + exp(delta_", info$varname, "[", k - 1, "])")
    }
  })



  # posterior predictive check -------------------------------------------------
  # currently not used !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  paste_ppc <- if (info$ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), info$varname, "_ppc[", index, "] ~ dcat(p_",
           info$varname, "[", index, ", 1:", info$ncat, "])", "\n"
    )
  }

  # paste_ppc_prior <- if (info$ppc) {
  #   paste0('\n',
  #          tab(), '# Posterior predictive check for the model for
  #           ', info$varname, '\n',
  #          tab(), 'ppc_', info$varname, "_o <- pow(", info$varname,
  #           "[] - mu_", info$varname, "[], 2)", "\n",
  #          tab(), 'ppc_', info$varname, "_e <- pow(", info$varname,
  #           "_ppc[] - mu_", info$varname, "[], 2)", "\n",
  #          tab(), 'ppc_', info$varname, " <- mean(step(ppc_",
  #          info$varname, "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
  #   )
  # }


  # write model ----------------------------------------------------------------
  paste0('\r',
         tab(), add_dashes(paste0("# Cumulative logit mixed effects model for ",
                                  info$varname)), "\n",
         tab(), "for (", index, " in 1:", info$N[gsub("M_", "", info$resp_mat)],
         ") {", "\n",
         tab(4), info$resp_mat, "[", index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", index, ", 1:", info$ncat, "])", "\n",

         tab(4), 'eta_', info$varname, "[", index, "] <- ",
         add_linebreaks(Z_predictor, indent = indent),
         "\n\n",
         write_probs(info, index), "\n\n",
         write_logits(info, index), "\n",
         dummies,
         info$trafos,
         "\n",
         paste_ppc,
         tab(), "}", "\n",
         "\n",
         paste0(sapply(names(rdintercept), write_ranefs, info = info,
                       rdintercept = rdintercept, rdslopes = rdslopes),
                collapse = ''),
         "\n\n",

         # priors
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (any(!sapply(info$parelmts, is.null))) {
           paste0(tab(), "for (k in ", min(unlist(info$parelmts)), ":",
                  max(unlist(info$parelmts)), ") {", "\n",
                  get_priordistr(info$shrinkage, type = 'ordinal',
                                 parname = info$parname),
                  tab(), "}")
         },
         write_priors_clm(info),
         # paste_ppc_prior,
         "\n",
         paste0(
           sapply(names(info$hc_list$hcvars), function(x) {
             ranef_priors(info$nranef[x], paste0(info$varname, "_", x))
           }), collapse = "\n")
  )
}


clmm_in_JM <- function(info) {

  # specify indent width and index character to be used
  index <- info$index[info$surv_lvl]
  indent <- 4 + 4 + nchar(info$varname) + 7

  # main model parts -----------------------------------------------------------
  Z_predictor <- paste_lp_Zpart(info, isgk = TRUE)

  # syntax to set values of dummy variables,
  # e.g. "M_lvlone[i, 8] <- ifelse(M_lvlone[i, 4] == 2, 1, 0)"
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0(tab(),
           paste_dummies(resp_mat = paste0(info$resp_mat, "gk"),
                         resp_col = paste0(info$resp_col, ', k'),
                         dummy_cols = paste0(info$dummy_cols, ', k'),
                         index = index, refs = info$refs),
           collapse = "\n")
  }

  # write model ----------------------------------------------------------------
  paste0(tab(6), info$resp_mat, "gk[", index, ", ", info$resp_col,
         ", k] ~ dcat(pgk_", info$varname, "[", index, ", 1:", info$ncat,
         ", k])", "\n",

         tab(6), 'etagk_', info$varname, "[", index, ", k] <- ",
         add_linebreaks(Z_predictor, indent = 12 + nchar(info$varname) + 10),
         "\n\n",
         write_probs(info, index, isgk = TRUE, indent = 6), "\n\n",
         write_logits(info, index, isgk = TRUE, indent = 6), "\n\n",
         dummies,
         "\n"
  )
}

