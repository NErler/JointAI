# Imputation by cumulative logistic regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_multilogit <- function(varname, dest_col, Xc_cols, par_elmts, par_name, dummy_cols, ncat, refcat, ...){

  indent <- nchar(varname) + 21
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  spltpred <- split(predictor, c(1:ncat)[-refcat] >= refcat)
  predictor2 <- c(spltpred[["FALSE"]], "0", spltpred[["TRUE"]])

  probs <- sapply(1:ncat, function(k){
    paste0(tab(), "p_", varname, "[i, ", k, "] <- min(1-1e-7, max(1e-7, phi_", varname, "[i, ", k,
           "] / sum(phi_", varname, "[i, ])))")
    })

  logs <- mapply(function(k, predictor){
    paste0(tab(), "log(phi_", varname, "[i, ", k, "]) <- ", predictor)
  }, 1:ncat, predictor2)


  dummies <- paste_dummies(c(1:ncat)[-refcat], dest_col, dummy_cols)

  paste0(tab(), "# multinomial model for ", varname, "\n",
         tab(), "Xcat[i, ", dest_col, "] ~ dcat(p_", varname, "[i, 1:", ncat, "])", "\n\n",
         paste(probs, collapse = "\n"), "\n\n",
         paste0(logs, collapse = "\n"), "\n\n",
         paste0(dummies, collapse = "\n"), "\n\n")
}



# Priors for multinomial imputation model
# @param varname name of the variable to be imputed
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impprior_multilogit <- function(varname, par_elmts, par_name, ...){
  paste0(tab(), "# Priors for ", varname,"\n",
         tab(), "for (k in ", min(unlist(par_elmts)), ":", max(unlist(par_elmts)), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial)", "\n",
         tab(), "}", "\n\n"
  )
}
