#' Imputation by Bayesian linear regression
#' @param varname name of the variable to be imputed
#' @param dest_col column of Xc containing the variable to be imputed
#' @param Xc_cols columns of the design matrix to used in linear predictor
#' @param par_elmts elements of the parameter vector to be used
#' @param par_name name of the parameter
#' @export
impmodel_normal <- function(varname, dest_col, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector don't match!")
  }

  indent <- nchar(varname) + 12
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  paste0(tab(), "# normal model for ", varname, "\n",
         tab(), "Xc[i, ", dest_col, "] ~ dnorm(mu_", varname, "[i], tau_", varname,")", "\n",
         tab(), "mu_", varname,"[i] <- ", predictor, "\n\n")
}


# Priors for linear imputation model
impprior_normal <- function(varname, par_elmts, par_name, ...){
  paste0(tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_norm, tau_reg_norm)", "\n",
         tab(), "}", "\n",
         tab(), "tau_", varname,  " ~ dgamma(a_tau_norm, b_tau_norm)", "\n\n"
  )
}





#' Imputation by Bayesian log-normal regression
#' @param varname name of the variable to be imputed
#' @param dest_col column of Xc containing the variable to be imputed
#' @param Xc_cols columns of the design matrix to used in linear predictor
#' @param par_elmts elements of the parameter vector to be used
#' @param par_name name of the parameter
#' @export
impmodel_lognormal <- function(varname, dest_col, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector don't match!")
  }

  indent <- nchar(varname) + 12
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  paste0(tab(), "# normal model for ", varname, "\n",
         tab(), "Xc[i, ", dest_col, "] ~ dlnorm(mu_", varname, "[i], tau_", varname,")", "\n",
         tab(), "mu_", varname,"[i] <- ", predictor, "\n\n")
}


# Priors for log-normal imputation model
impprior_lognormal <- function(varname, par_elmts, par_name, ...){
  paste0(tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_norm, tau_reg_norm)", "\n",
         tab(), "}", "\n",
         tab(), "tau_", varname,  " ~ dgamma(a_tau_norm, b_tau_norm)", "\n\n"
  )
}