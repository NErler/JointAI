JAGSmodel_mlogitmm <- function(info) {

  # specify indent width and index character to be used
  indent <- 4 + 8 + nchar(info$varname) + 11
  index <- info$index[gsub("M_", "", info$resp_mat)]

  # main model elements --------------------------------------------------------

  # linear predictor of baseline covariates (including interaction terms)
  rdintercept <- paste_rdintercept_lp(info)
  rdslopes <- paste_rdslope_lp(info)
  Z_predictor <- paste_lp_Zpart(info)

  # syntax for probabilities, using min-max-trick for numeric stability
  # i.e.,
  # "p_M2[ii, 1] <- min(1-1e-7, max(1e-7, phi_M2[ii, 1] / sum(phi_M2[ii, ])))"
  probs <- sapply(1:info$ncat, function(k){
    paste0(tab(4), "p_", info$varname, "[", index, ", ", k,
           "] <- min(1-1e-7, max(1e-7, phi_", info$varname, "[", index, ", ", k,
           "] / sum(phi_", info$varname, "[", index, ", ])))")
  })



  # syntax for logs, e.g., "log(phi_M2[ii, 2]) <- M_id[ii, 3] * alpha[8] + ..."
  logs <- paste0(tab(4), paste0("log(phi_", info$varname, "[", index, ", ",
                                1:info$ncat, "]) <- "),
                 c("0", Z_predictor)
  )


  # syntax to set values of dummy variables,
  # e.g. "M_lvlone[i, 8] <- ifelse(M_lvlone[i, 4] == 2, 1, 0)"
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n\n', paste0(
      paste_dummies(resp_mat = info$resp_mat,
                    resp_col = info$resp_col, dummy_cols = info$dummy_cols,
                    index = index, refs = info$refs), collapse = "\n"), "\n")
  }



  paste0(tab(2), add_dashes(paste0("# Multinomial logit mixed model for ",
                                   info$varname)), "\n",
         tab(2), "for (", index, " in 1:",
         info$N[[gsub("M_", "", info$resp_mat)]], ") {", "\n",
         tab(4), info$resp_mat, "[", index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", index, ", 1:", info$ncat, "])",
         "\n\n",

         paste(probs, collapse = "\n"), "\n\n",
         paste0(sapply(logs, add_linebreaks, indent = indent), collapse = "\n"),
         dummies, "\n",
         info$trafos,
         tab(), "}", "\n\n",

         paste0(sapply(names(rdintercept), write_ranefs, info = info,
                       rdintercept = rdintercept, rdslopes = rdslopes),
                collapse = ''),
         "\n\n",
         # priors
         tab(), "# Priors for the model for ", info$varname,"\n",
         tab(), "for (k in ", min(unlist(info$parelmts)), ":",
         max(unlist(info$parelmts)), ") {", "\n",
         get_priordistr(info$shrinkage, type = 'multinomial',
                        parname = info$parname),
         tab(), "}", "\n",
         paste0(
           sapply(names(info$hc_list$hcvars), function(x) {
             ranef_priors(info$nranef[x], paste0(info$varname, "_", x))
           }), collapse = "\n")
  )
}
