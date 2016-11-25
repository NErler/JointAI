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

  indent <- nchar(varname) + 10
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)

  paste0("# normal imputation for ", varname, "\n",
        "Xc[i, ", dest_col, "] ~ dnorm(mu.", varname, "[i], tau.", varname,")", "\n",
        "mu.", varname,"[i] <- ", predictor, "\n\n")
}


#' Priors for linear imputation model
#' @param varname name of the variable to be imputed
#' @param par_elmts elements of the parameter vector to be used
#' @param par_name name of the parameter
#' @export
impprior_normal <- function(varname, par_elmts, par_name, ...){
  paste0("# Priors for ", varname, "\n",
         "for(k in ", min(par_elmts), ":", max(par_elmts), "){", "\n",
         "  ", par_name, "[k] ~ dnorm(0, 0.001)", "\n",
         "}", "\n",
         "tau.", varname,  " ~ dgamma(0.01, 0.01)", "\n\n\n"
  )
}

