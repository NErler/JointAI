# Imputation by Bayesian logistic regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_logit <- function(varname, dest_col, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 20
  predictor <-  paste_predictor(parnam = par_name, parindex = 'i', matnam = 'Xc',
                                parelmts = par_elmts,
                                cols = Xc_cols, indent = indent)

  paste0(tab(4), "# logistic model for ", varname,"\n",
         tab(4), "Xc[i, ", dest_col, "] ~ dbern(max(1e-7, min(1-1e-7, p_", varname, "[i])))", "\n",
         tab(4), "logit(p_", varname, "[i]) <- ", predictor, "\n\n")
}


# Priors for logistic imputation model
# @param varname name of the variable to be imputed
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impprior_logit <- function(varname, par_elmts, par_name, ...){
  paste0('\n',
         tab(), "# Priors for ", varname,"\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_logit, tau_reg_logit)", "\n",
         tab(), "}", "\n"
  )
}
