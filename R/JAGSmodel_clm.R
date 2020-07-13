# Cumulative logit model
JAGSmodel_clm <- function(info) {

  if (info$ncat < 3) {
    errormsg("A cumulative logit mixed model is supposed to be fitted for the
             variable %s but %s only has %s categories.",
             dQuote(info$varname), dQuote(info$varname), info$ncat)
  }

  if (!is.null(info$hc_list)) {
    errormsg("I found a random effects structure. Did you mean to use %s
             instead of %s?", dQuote("clmm"), dQuote("clm"))
  }

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



  # syntax to set values of dummy variables,
  # e.g. "M_lvlone[i, 8] <- ifelse(M_lvlone[i, 4] == 2, 1, 0)"
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n', paste0(
      paste_dummies(resp_mat = info$resp_mat,
                    resp_col = info$resp_col, dummy_cols = info$dummy_cols,
                    index = index, refs = info$refs), collapse = "\n"), "\n")
  }


  # posterior predictive check -------------------------------------------------
  # currently not used !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  paste_ppc <- if (info$ppc) {
    paste0(
      tab(4), info$varname, "_ppc[", index, "] ~ dcat(p_", info$varname,
      "[", index, ", 1:", info$ncat, "])", "\n"
    )
  }


  paste_ppc_prior <- if (info$ppc) {
    paste0(
      "\n\n",
      tab(), "# Posterior predictive check for the model for ",
      info$varname, "\n",
      tab(), "for (", index, " in 1:",
      info$N[gsub("M_", "", info$resp_mat)], ") {", "\n",
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
      "ifelse(ppc_", info$varname, "_o == ppc_", info$varname,
      "_e, 0.5, 0)) - 0.5", "\n"
    )
  }






  paste0(
    "\r", tab(),
    add_dashes(paste0("# Cumulative logit model for ", info$varname)),
    "\n",
    tab(), "for (", index, " in 1:", info$N[gsub("M_", "",
                                                 info$resp_mat)], ") {", "\n",
    tab(4), info$resp_mat, "[", index, ", ", info$resp_col,
    "] ~ dcat(p_", info$varname, "[", index, ", 1:", info$ncat, "])", "\n",
    paste_ppc,
    tab(4), "eta_", info$varname, "[", index, "] <- ",
    add_linebreaks(linpred, indent = indent),
    "\n\n",
    write_probs(info, index), "\n\n",
    write_logits(info, index), "\n",
    dummies,
    info$trafos,
    tab(), "}", "\n\n",

    # Priors
    tab(), "# Priors for the model for ", info$varname, "\n",
    if (!is.null(info$lp[[info$resp_mat]])) {
      paste0(
        tab(), "for (k in ", min(unlist(info$parelmts)), ":",
        max(unlist(info$parelmts)), ") {", "\n",
        get_priordistr(info$shrinkage, type = "ordinal",
                       parname = info$parname),
        tab(), "}", "\n\n"
      )
    },
    write_priors_clm(info),
    paste_ppc_prior
  )
}

