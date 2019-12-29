
JAGSmodel_mlogit <- function(info) {

  indent <- nchar(info$varname) + 23

  probs <- sapply(1:info$ncat, function(k){
    paste0(tab(4), "p_", info$varname, "[", info$index, ", ", k,
           "] <- min(1-1e-7, max(1e-7, phi_", info$varname, "[", info$index, ", ", k,
           "] / sum(phi_", info$varname, "[", info$index, ", ])))")
    })



  # Mc_predictor <- mapply(function(k, par_elmts) {
  #   paste0(tab(4), "log(phi_", info$varname, "[", info$index, ", ", k, "]) <- ",
  #          paste_predictor(parnam = info$parname, parindex = info$index,
  #                          matnam = 'Mc', parelmts = par_elmts, cols = info$lp$Mc,
  #                          scale_pars = info$scale_pars$Mc, indent = indent)
  #   )
  # }, k = 2:info$ncat, info$parelmts$Mc)


  Mc_predictor <- mapply(function(k, par_elmts) {
    paste0(tab(4), "log(phi_", info$varname, "[", info$index, ", ", k, "]) <- ",
           add_linebreaks(
             paste_linpred(info$parname, par_elmts, matnam = "Mc",
                         index = info$index, cols = info$lp$Mc,
                         scale_pars = info$scale_pars$Mc),
             indent = indent)
    )
  }, k = 2:info$ncat, par_elmts = info$parelmts$Mc)


  logs <- c(paste0(tab(4), "log(phi_", info$varname, "[", info$index, ", 1]) <- 0"),
            Mc_predictor)


  dummies <- if (!is.null(info$dummy_cols)) {
    paste0(c('\n', paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                               dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                               index = info$index)), collapse = "\n")
  }


  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    distr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial_ridge[k])", "\n",
                    tab(4), "tau_reg_multinomial_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial)", "\n")
  }



  paste0(tab(2), "# Multinomial logit model for ", info$varname, "\n",
         tab(2), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index, ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", info$index, ", 1:", info$ncat, "])", "\n\n",
         paste(probs, collapse = "\n"), "\n\n",
         paste0(logs, collapse = "\n"),
         dummies, "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname,"\n",
         tab(), "for (k in ", min(unlist(info$parelmts$Mc)), ":", max(unlist(info$parelmts$Mc)), ") {", "\n",
         distr,
         tab(), "}", "\n")
}
