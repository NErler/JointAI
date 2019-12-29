JAGSmodel_clmm <- function(info) {
  indent <- 4 + 4 + nchar(info$varname) + 7

  # model parts ----------------------------------------------------------------
  probs <- sapply(2:(info$ncat - 1), function(k) {
    paste0(tab(4), "p_", info$varname, "[", info$index[1], ", ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           info$varname, "[", info$index[1], ", ", k,"] - psum_", info$varname, "[", info$index[1], ", ", k - 1, "]))")})

  logits <- sapply(1:(info$ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", info$varname, "[", info$index[1], ", ", k, "])  <- gamma_", info$varname,
           "[", k, "]", " + eta_", info$varname,"[", info$index[1], "]")
  })


  deltas <- sapply(1:(info$ncat - 2), function(k) {
    paste0(tab(), "delta_", info$varname, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
  })

  gammas <- sapply(1:(info$ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", info$varname, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
    } else {
      paste0(tab(), "gamma_", info$varname, "[", k, "] <- gamma_", info$varname, "[", k - 1,
             "] + exp(delta_", info$varname, "[", k - 1, "])")
    }
  })


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

  # posterior predictive check -------------------------------------------------
  paste_ppc <- if (info$ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), info$varname, "_ppc[", info$index[1], "] ~ dcat(p_",
           info$varname, "[", info$index[1], ", 1:", info$ncat, "])", "\n"
    )
  }

  # paste_ppc_prior <- if (info$ppc) {
  #   paste0('\n',
  #          tab(), '# Posterior predictive check for the model for ', info$varname, '\n',
  #          tab(), 'ppc_', info$varname, "_o <- pow(", info$varname, "[] - mu_", info$varname, "[], 2)", "\n",
  #          tab(), 'ppc_', info$varname, "_e <- pow(", info$varname, "_ppc[] - mu_", info$varname, "[], 2)", "\n",
  #          tab(), 'ppc_', info$varname, " <- mean(step(ppc_", info$varname, "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
  #   )
  # }


  # shrinkage ------------------------------------------------------------------
  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal_ridge[k])", "\n",
                    tab(4), "tau_reg_ordinal_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n")
  }

  # write model ----------------------------------------------------------------
  paste0(tab(), "# Cumulative logit mixed effects model for ", info$varname, "\n",
         tab(), "for (", info$index[1], " in 1:", info$Ntot, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index[1], ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", info$index[1], ", 1:", info$ncat, "])", "\n",

         tab(4), 'eta_', info$varname, "[", info$index[1], "] <- ",
         add_linebreaks(Z_predictor, indent = indent),
         "\n\n",
         tab(4), "p_", info$varname, "[", info$index[1], ", 1] <- max(1e-10, min(1-1e-7, psum_",
         info$varname, "[", info$index[1], ", 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", info$varname, "[", info$index[1], ", ", info$ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         info$varname, "[", info$index[1], ", 1:", info$ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"),
         paste(dummies, collapse = "\n"),
         "\n",
         paste_ppc,
         tab(), "}", "\n",
         "\n",
         tab(), "for (", info$index[2], " in 1:", info$N, ") {", "\n",
         tab(4), "b_", info$varname, "[", info$index[2], ", 1:", max(1, length(info$hc_list)), "] ~ ", norm.distr,
         "(mu_b_", info$varname, "[", info$index[2], ", ], invD_", info$varname, "[ , ])", "\n",
         paste_mu_b(rdintercept, rdslopes, info$varname, info$index[2]),
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (any(!sapply(info$parelmts, is.null))) {
           paste0(tab(), "for (k in ", min(info$parelmts$Mc, info$parelmts$Ml), ":",
                  max(info$parelmts$Mc, info$parelmts$Ml), ") {", "\n",
                  priordistr,
                  tab(), "}")
         },
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"),
         # paste_ppc_prior,
         "\n",
         ranef_priors(max(1, length(info$hc_list)), info$varname)
  )
}


clmm_in_JM <- function(info) {
  indent <- 4 + 4 + nchar(info$varname) + 7

  # model parts ----------------------------------------------------------------
  probs <- sapply(2:(info$ncat - 1), function(k) {
    paste0(tab(6), "pgk_", info$varname, "[", info$index[2], ", ", k,
           ", k] <- max(1e-7, min(1-1e-10, psumgk_",
           info$varname, "[", info$index[2], ", ", k,", k] - psumgk_",
           info$varname, "[", info$index[2], ", ", k - 1, ", k]))"
           )
    })

  logits <- sapply(1:(info$ncat - 1), function(k) {
    paste0(tab(6), "logit(psumgk_", info$varname, "[", info$index[2], ", ", k,
           ", k])  <- gamma_", info$varname,
           "[", k, "]", " + etagk_", info$varname,"[", info$index[2], ", k]")
  })

  hc_info <- get_hc_info(info)
  hc_parelmts <- organize_hc_parelmts(hc_info, info = info)

  Z_predictor <- paste_Zpart(info, index = info$index[2], hc_info,
                             notin_b = hc_parelmts$notin_b, isgk = TRUE)


  dummies <- if (!is.null(info$dummy_cols)) {
    paste0(tab(),
           paste_dummies(categories = info$categories,
                         dest_mat = paste0(info$resp_mat, "gk"),
                         dest_col = paste0(info$resp_col, ', k'),
                         dummy_cols = paste0(info$dummy_cols, ', k'),
                         index = info$index[2]),
           collapse = "\n")
  }


  # write model ----------------------------------------------------------------
  paste0(tab(6), info$resp_mat, "gk[", info$index[2], ", ", info$resp_col,
         ", k] ~ dcat(pgk_", info$varname, "[", info$index[2], ", 1:", info$ncat, ", k])", "\n",

         tab(6), 'etagk_', info$varname, "[", info$index[2], ", k] <- ",
         add_linebreaks(Z_predictor, indent = 12 + nchar(info$varname) + 10),
         "\n\n",
         tab(6), "pgk_", info$varname, "[", info$index[2], ", 1, k] <- max(1e-10, min(1-1e-7, psumgk_",
         info$varname, "[", info$index[2], ", 1, k]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(6), "pgk_", info$varname, "[", info$index[2], ", ", info$ncat,
         ", k] <- 1 - max(1e-10, min(1-1e-7, sum(pgk_",
         info$varname, "[", info$index[2], ", 1:", info$ncat - 1,", k])))", "\n\n",
         paste0(logits, collapse = "\n"),
         "\n\n",
         dummies,
         "\n"
  )
}

