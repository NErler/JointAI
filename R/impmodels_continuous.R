# Imputation by Bayesian linear regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_normal <- function(varname, dest_col, dest_mat, trafo_cols, trafos, trfo_fct, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 12
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  trfs <- if (dest_mat != "Xc") {
    paste_trafos(dest_col, trafo_cols, trafos = trfo_fct)
  }

  trunc <- if (varname %in% trafos$var &
              any(!trafos$type[trafos$var == varname] %in% c("I", "identity", "exp"))) {
    "T(1e-10, 1e10)"
  }
  if (!is.null(trunc))
    message(gettextf("Note: The imputation model for %s", dQuote(varname)),
            " will be restricted to be larger than 0 to prevent problems ",
            gettextf("in calculating %s.",
                     dQuote(trafos$Xc_var[trafos$var == varname &
                                            trafos$type %in% c("log", "sqrt")]))
    )


  paste0(tab(), "# normal model for ", varname, "\n",
         tab(), dest_mat, "[i, ", dest_col, "] ~ dnorm(mu_", varname,
         "[i], tau_", varname,")", trunc, "\n",
         tab(), "mu_", varname,"[i] <- ", predictor, "\n\n",
         paste0(trfs, collapse = "\n"), "\n\n")
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





# Imputation by Bayesian log-normal regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_lognorm <- function(varname, dest_col, dest_mat, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 12
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  paste0(tab(), "# normal model for ", varname, "\n",
         tab(), "Xc[i, ", dest_col, "] ~ dlnorm(mu_", varname, "[i], tau_", varname,")", "\n",
         tab(), "mu_", varname,"[i] <- ", predictor, "\n\n")
}


# Priors for log-normal imputation model
impprior_lognorm <- function(varname, par_elmts, par_name, ...){
  paste0(tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_norm, tau_reg_norm)", "\n",
         tab(), "}", "\n",
         tab(), "tau_", varname,  " ~ dgamma(a_tau_norm, b_tau_norm)", "\n\n"
  )
}




# Imputation by gamma regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_gamma <- function(varname, dest_col, dest_mat, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 12
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  paste0(tab(), "# gamma model for ", varname, "\n",
         tab(), "Xc[i, ", dest_col, "] ~ dgamma(shape_", varname, "[i], rate_", varname, "[i])", "\n",
         tab(), "log(mu_", varname,"[i]) <- ", predictor, "\n",
         tab(), "shape_", varname,"[i] <- pow(mu_", varname, "[i], 2) / pow(sigma_", varname, ", 2)", "\n",
         tab(), "rate_", varname, "[i] <- mu_", varname, "[i] / pow(sigma_", varname, ", 2)", "\n\n")
}


# Priors for gamma imputation model
impprior_gamma <- function(varname, par_elmts, par_name, ...){
  paste0(tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_gamma, tau_reg_gamma)", "\n",
         tab(), "}", "\n",
         tab(), "tau_", varname,  " ~ dgamma(a_tau_gamma, b_tau_gamma)", "\n",
         tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")", "\n\n"
  )
}





# Imputation by beta regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_beta <- function(varname, dest_col, dest_mat, Xc_cols, par_elmts, par_name, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 12
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  paste0(tab(), "# beta model for ", varname, "\n",
         tab(), "Xc[i, ", dest_col, "] ~ dbeta(shape1_", varname, "[i], shape2_", varname, "[i])T(1e-15, 1 - 1e-15)", "\n",
         tab(), "logit(mu_", varname,"[i]) <- ", predictor, "\n",
         tab(), "shape1_", varname,"[i] <- mu_", varname, "[i] * tau_", varname, "\n",
         tab(), "shape2_", varname, "[i] <- (1 - mu_", varname, "[i]) * tau_", varname, "\n\n")
}

# Priors for beta imputation model
impprior_beta <- function(varname, par_elmts, par_name, ...){
  paste0(tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_beta, tau_reg_beta)", "\n",
         tab(), "}", "\n",
         tab(), "tau_", varname,  " ~ dgamma(a_tau_beta, b_tau_beta)", "\n"
  )
}
