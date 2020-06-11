# Cumulative logit model
JAGSmodel_clm <- function(info) {

  # specify indent width and index character to be used
  indent <- 4 + 4 + nchar(info$varname) + 7
  index <- info$index[gsub("M_", "", info$resp_mat)]


  # main model elements --------------------------------------------------------

  # linear predictor of baseline covariates (including interaction terms)
  linpred <- if (!is.null(info$lp[[info$resp_mat]])) {
    paste_linpred(info$parname,
                  info$parelmts[[info$resp_mat]],
                  matnam = info$resp_mat,
                  index = index,
                  cols = info$lp[[info$resp_mat]],
                  scale_pars = info$scale_pars[[info$resp_mat]])
  } else {"0"}

  # syntax for probabilities, using min-max-trick for numeric stability
  # i.e., "p_O2[i, 2] <- psum_O2[i, 2] - psum_O2[i, 1]"
  probs <- sapply(2:(info$ncat - 1), function(k) {
    paste0(tab(4), "p_", info$varname, "[", index, ", ", k,
           "] <- max(1e-7, min(1-1e-10, psum_",
           info$varname, "[", index, ", ", k,"] - psum_", info$varname,
           "[", index, ", ", k - 1, "]))")})


  # syntax for logits, e.g., "logit(psum_O2[i, 1]) <- gamma_O2[1] + eta_O2[i]"
  logits <- sapply(1:(info$ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", info$varname, "[", index, ", ", k,
           "]) <- gamma_", info$varname,
           "[", k, "]", " + eta_", info$varname,"[", index, "]")
  })


  # syntax to set values of dummy variables,
  # e.g. "M_levelone[i, 8] <- ifelse(M_levelone[i, 4] == 2, 1, 0)"
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n', paste0(paste_dummies(categories = info$categories,
                                      dest_mat = info$resp_mat,
                                      dest_col = info$resp_col,
                                      dummy_cols = info$dummy_cols,
                                      index = index), collapse = "\n"), "\n")
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
             info$varname, "[", k - 1, "] + exp(delta_", info$varname,
             "[", k - 1, "])")
    }
  })


  # posterior predictive check -------------------------------------------------
  # currently not used !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  paste_ppc <- if (info$ppc) {
    paste0(
      tab(4), info$varname, "_ppc[", index, "] ~ dcat(p_", info$varname,
      "[", index, ", 1:", info$ncat, "])", "\n"
    )
  }


  paste_ppc_prior <- if (info$ppc) {
    paste0("\n\n",
           tab(), "# Posterior predictive check for the model for ", info$varname, "\n",
           tab(), "for (", index, " in 1:", info$N[gsub("M_", "", info$resp_mat)], ") {", "\n",
           tab(4), "for (k in 1:", info$ncat, ") {", "\n",
           tab(6), info$varname, "_dummies[", index, ", k] <- ifelse(",
           info$varname, "[", index, "] == k, 1, 0)", "\n",
           tab(6), info$varname, "_ppc_dummies[", index, ", k] <- ifelse(",
           info$varname, "_ppc[", index, "] == k, 1, 0)", "\n",
           tab(4), "}", "\n",
           tab(4), "ppc_", info$varname, "_o[", index, "] <- sum(pow(",
           info$varname, "_dummies[", index, ", ] - p_", info$varname, "[",
           index, ", ], 2))", "\n",
           tab(4), "ppc_", info$varname, "_e[", index, "] <- sum(pow(",
           info$varname, "_ppc_dummies[", index, ", ] - p_", info$varname,
           "[", index, ", ], 2))", "\n",
           tab(), "}", "\n",
           tab(), "ppc_", info$varname, " <- mean(ifelse(ppc_", info$varname,
           "_o > ppc_", info$varname, "_e, 1, 0) + ",
           "ifelse(ppc_", info$varname, "_o == ppc_", info$varname, "_e, 0.5, 0)) - 0.5", "\n"
    )
  }






  paste0('\r',
         tab(), add_dashes(paste0("# Cumulative logit model for ", info$varname)), "\n",
         tab(), "for (", index, " in 1:", info$N[gsub("M_", "", info$resp_mat)], ") {", "\n",
         tab(4), info$resp_mat, "[", index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", index, ", 1:", info$ncat, "])", "\n",
         paste_ppc,
         tab(4), 'eta_', info$varname, "[", index, "] <- ",
         add_linebreaks(linpred, indent = indent),
         "\n\n",
         tab(4), "p_", info$varname, "[", index, ", 1] <- max(1e-10, min(1-1e-7, psum_",
         info$varname, "[", index, ", 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", info$varname, "[", index, ", ", info$ncat,
         "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         info$varname, "[", index, ", 1:", info$ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n",
         dummies,
         info$trafos,
         tab(), "}", "\n\n",

         # Priors
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (!is.null(info$lp[[info$resp_mat]])) {
           paste0(
             tab(), "for (k in ", min(unlist(info$parelmts)), ":", max(unlist(info$parelmts)), ") {", "\n",
             get_priordistr(info$shrinkage, type = 'ordinal', parname = info$parname),
             tab(), "}", "\n\n")
         },
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"),
         paste_ppc_prior
  )
}

