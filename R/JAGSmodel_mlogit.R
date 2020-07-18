
JAGSmodel_mlogit <- function(info) {

  # specify indent width and index character to be used
  index <- info$index[gsub("M_", "", info$resp_mat)]
  indent <- nchar(info$varname) + 23

  # main model elements --------------------------------------------------------

  # linear predictor of baseline covariates (including interaction terms)
  linpred <- mapply(function(k, par_elmts) {
    paste0(tab(4), "log(phi_", info$varname, "[", index, ", ", k, "]) <- ",
           add_linebreaks(
             paste_linpred(info$parname,
                           par_elmts,
                           matnam = info$resp_mat,
                           index = index, cols = info$lp[[info$resp_mat]],
                           scale_pars = info$scale_pars[[info$resp_mat]]),
             indent = indent)
    )
  }, k = 2:info$ncat, par_elmts = info$parelmts[[info$resp_mat]])


  # syntax for probabilities, using min-max-trick for numeric stability
  # i.e.,
  # "p_M2[ii, 1] <- min(1-1e-7, max(1e-7, phi_M2[ii, 1] / sum(phi_M2[ii, ])))"
  probs <- sapply(1:info$ncat, function(k){
    paste0(tab(4), "p_", info$varname, "[", index, ", ", k,
           "] <- min(1-1e-7, max(1e-7, phi_", info$varname, "[", index, ", ", k,
           "] / sum(phi_", info$varname, "[", index, ", ])))")
    })



  # syntax for logs, e.g., "log(phi_M2[ii, 2]) <- M_id[ii, 3] * alpha[8] + ..."
  logs <- c(paste0(tab(4), "log(phi_", info$varname, "[", index, ", 1]) <- 0"),
            linpred)


  # syntax to set values of dummy variables,
  # e.g. "M_lvlone[i, 8] <- ifelse(M_lvlone[i, 4] == 2, 1, 0)"
  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n\n', paste0(
      paste_dummies(resp_mat = info$resp_mat,
                    resp_col = info$resp_col, dummy_cols = info$dummy_cols,
                    index = index, refs = info$refs), collapse = "\n"), "\n")
  }

  paste0(tab(2), add_dashes(paste0("# Multinomial logit model for ",
                                   info$varname)), "\n",
         tab(2), "for (", index, " in 1:", info$N[[gsub("M_", "",
                                                        info$resp_mat)]],
         ") {", "\n",
         tab(4), info$resp_mat, "[", index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", index, ", 1:", info$ncat, "])",
         "\n\n",
         paste(probs, collapse = "\n"), "\n\n",
         paste0(logs, collapse = "\n"),
         dummies, "\n",
         info$trafos,
         tab(), "}", "\n\n",

         # priors
         tab(), "# Priors for the model for ", info$varname,"\n",
         tab(), "for (k in ", min(unlist(info$parelmts)), ":",
         max(unlist(info$parelmts)), ") {", "\n",
         get_priordistr(info$shrinkage, type = 'multinomial',
                        parname = info$parname),
         tab(), "}", "\n")
}
