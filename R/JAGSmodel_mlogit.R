
JAGSmodel_mlogit <- function(info) {
  index <- info$index[gsub("M_", "", info$resp_mat)]
  indent <- nchar(info$varname) + 23

  probs <- sapply(1:info$ncat, function(k){
    paste0(tab(4), "p_", info$varname, "[", index, ", ", k,
           "] <- min(1-1e-7, max(1e-7, phi_", info$varname, "[", index, ", ", k,
           "] / sum(phi_", info$varname, "[", index, ", ])))")
    })



  # Mc_predictor <- mapply(function(k, par_elmts) {
  #   paste0(tab(4), "log(phi_", info$varname, "[", index, ", ", k, "]) <- ",
  #          paste_predictor(parnam = info$parname, parindex = index,
  #                          matnam = 'Mc', parelmts = par_elmts, cols = info$lp$Mc,
  #                          scale_pars = info$scale_pars$Mc, indent = indent)
  #   )
  # }, k = 2:info$ncat, info$parelmts$Mc)


  Mc_predictor <- mapply(function(k, par_elmts) {
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


  logs <- c(paste0(tab(4), "log(phi_", info$varname, "[", index, ", 1]) <- 0"),
            Mc_predictor)


  dummies <- if (!is.null(info$dummy_cols)) {
    paste0(c('\n', paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                               dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                               index = index)), collapse = "\n")
  }


  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    distr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial_ridge[k])", "\n",
                    tab(4), "tau_reg_multinomial_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial)", "\n")
  }



  paste0(tab(2), add_dashes(paste0("# Multinomial logit model for ", info$varname)), "\n",
         tab(2), "for (", index, " in 1:", info$N[[gsub("M_", "", info$resp_mat)]], ") {", "\n",
         tab(4), info$resp_mat, "[", index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", index, ", 1:", info$ncat, "])", "\n\n",
         paste(probs, collapse = "\n"), "\n\n",
         paste0(logs, collapse = "\n"),
         dummies, "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname,"\n",
         tab(), "for (k in ", min(unlist(info$parelmts)), ":", max(unlist(info$parelmts)), ") {", "\n",
         distr,
         tab(), "}", "\n")
}
