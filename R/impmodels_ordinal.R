# Imputation by cumulative logistic regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_cumlogit <- function(varname, dest_col, Xc_cols, par_elmts, par_name, dummy_cols, ncat, refcat, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 15

  predictor <-  paste_predictor(parnam = par_name, parindex = 'i', matnam = 'Xc',
                  parelmts = par_elmts,
                  cols = Xc_cols, indent = indent)

  probs <- sapply(2:(ncat - 1), function(k){
    paste0(tab(4), "p_", varname, "[i, ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           varname, "[i, ", k,"] - psum_", varname, "[i, ", k - 1, "]))")})

  logits <- sapply(1:(ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", varname, "[i, ", k, "])  <- gamma_", varname,
           "[", k, "]", " + eta_", varname,"[i]")
  })

  dummies <- paste_dummies(c(1:ncat)[-refcat], dest_col, dummy_cols)

  paste0(tab(4), "# ordinal model for ", varname, "\n",
         tab(4), "Xcat[i, ", dest_col, "] ~ dcat(p_", varname, "[i, 1:", ncat, "])", "\n",
         tab(4), "eta_", varname,"[i] <- ", predictor, "\n\n",
         tab(4), "p_", varname, "[i, 1] <- max(1e-10, min(1-1e-7, psum_", varname, "[i, 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", varname, "[i, ", ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         varname, "[i, 1:", ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n\n",
         paste0(dummies, collapse = "\n"), "\n\n")
}



# Priors for ordinal imputation model
# @param varname name of the variable to be imputed
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impprior_cumlogit <- function(varname, par_elmts, ncat, ...){
  deltas <- sapply(1:(ncat - 2), function(k) {
    paste0(tab(), "delta_", varname, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
  })

  gammas <- sapply(1:(ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", varname, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
    } else {
      paste0(tab(), "gamma_", varname, "[", k, "] <- gamma_", varname, "[", k - 1,
             "] + exp(delta_", varname, "[", k - 1, "])")
    }
  })

  paste0('\n',
         tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n",
         tab(), "}", "\n\n",
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"), "\n")
}
