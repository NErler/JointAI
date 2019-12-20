# Cumulative logit model
JAGSmodel_clm <- function(info) {
  indent <- 4 + 4 + nchar(info$varname) + 7

  probs <- sapply(2:(info$ncat - 1), function(k) {
    paste0(tab(4), "p_", info$varname, "[", info$index, ", ", k,
           "] <- max(1e-7, min(1-1e-10, psum_",
           info$varname, "[", info$index, ", ", k,"] - psum_", info$varname,
           "[", info$index, ", ", k - 1, "]))")})

  logits <- sapply(1:(info$ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", info$varname, "[", info$index, ", ", k,
           "]) <- gamma_", info$varname,
           "[", k, "]", " + eta_", info$varname,"[", info$index, "]")
  })

  paste_ppc <- if (info$ppc) {
    paste0(
      tab(4), info$varname, "_ppc[", info$index, "] ~ dcat(p_", info$varname,
      "[", info$index, ", 1:", info$ncat, "])", "\n"
    )
  }


  dummies <- if (!is.null(info$dummy_cols)) {
    paste0(c('\n', paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                                 dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                                 index = info$index)), collapse = "\n")
  }

  paste_ppc_prior <- if (info$ppc) {
  paste0("\n\n",
         tab(), "# Posterior predictive check for the model for ", info$varname, "\n",
         tab(), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), "for (k in 1:", info$ncat, ") {", "\n",
         tab(6), info$varname, "_dummies[", info$index, ", k] <- ifelse(",
         info$varname, "[", info$index, "] == k, 1, 0)", "\n",
         tab(6), info$varname, "_ppc_dummies[", info$index, ", k] <- ifelse(",
         info$varname, "_ppc[", info$index, "] == k, 1, 0)", "\n",
         tab(4), "}", "\n",
         tab(4), "ppc_", info$varname, "_o[", info$index, "] <- sum(pow(",
         info$varname, "_dummies[", info$index, ", ] - p_", info$varname, "[",
         info$index, ", ], 2))", "\n",
         tab(4), "ppc_", info$varname, "_e[", info$index, "] <- sum(pow(",
         info$varname, "_ppc_dummies[", info$index, ", ] - p_", info$varname,
         "[", info$index, ", ], 2))", "\n",
         tab(), "}", "\n",
         tab(), "ppc_", info$varname, " <- mean(ifelse(ppc_", info$varname,
         "_o > ppc_", info$varname, "_e, 1, 0) + ",
         "ifelse(ppc_", info$varname, "_o == ppc_", info$varname, "_e, 0.5, 0)) - 0.5", "\n"
  )
  }

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

  # linear predictor of baseline covariates (including interaction terms)
  Mc_predictor <- if (!is.null(info$lp$Mc)) {
    paste_predictor(parnam = info$parname, parindex = info$index,
                                  matnam = 'Mc',
                                  cols = info$lp$Mc,
                                  parelmts = info$parelmts$Mc,
                                  scale_pars = info$scale_pars$Mc,
                                  indent = indent)
  } else {"0"}


  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    distr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal_ridge[k])", "\n",
                    tab(4), "tau_reg_ordinal_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n")
  }



  paste0(tab(2), "# Cumulative logit mixed effects model for ", info$varname, "\n",
         tab(), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", info$index, ", 1:", info$ncat, "])", "\n",
         paste_ppc,
         tab(4), 'eta_', info$varname, "[", info$index, "] <- ",
         Mc_predictor,
         "\n\n",
         tab(4), "p_", info$varname, "[", info$index, ", 1] <- max(1e-10, min(1-1e-7, psum_",
         info$varname, "[", info$index, ", 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", info$varname, "[", info$index, ", ", info$ncat,
         "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         info$varname, "[", info$index, ", 1:", info$ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n",
         paste(dummies, collapse = "\n"), "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (!is.null(info$lp$Mc)) {
           paste0(
             tab(), "for (k in ", min(info$parelmts$Mc), ":", max(info$parelmts$Mc), ") {", "\n",
             distr,
             tab(), "}", "\n\n")
         },
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"),
         paste_ppc_prior
  )
}


