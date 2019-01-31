# Imputation by cumulative logistic regression
# @param varname name of the variable to be imputed
# @param dest_col column of Xc containing the variable to be imputed
# @param Xc_cols columns of the design matrix to used in linear predictor
# @param par_elmts elements of the parameter vector to be used
# @param par_name name of the parameter
# @export
impmodel_multilogit <- function(varname, dest_col, Xc_cols, par_elmts, dummy_cols, ncat, refcat, ...){

  indent <- nchar(varname) + 23

  probs <- sapply(1:ncat, function(k){
    paste0(tab(4), "p_", varname, "[i, ", k, "] <- min(1-1e-7, max(1e-7, phi_", varname, "[i, ", k,
           "] / sum(phi_", varname, "[i, ])))")
    })

  logs <- c(paste0(tab(4), "log(phi_", varname, "[i, 1]) <- 0"),
            mapply(function(k, par_elmts){
              paste0(tab(4), "log(phi_", varname, "[i, ", k, "]) <- ",
                     paste_predictor(parnam = 'alpha', parindex = 'i', matnam = 'Xc',
                                     parelmts = par_elmts["Xc", 1]:par_elmts["Xc", 2],
                                     cols = Xc_cols, indent = indent))
            }, k = 2:ncat, par_elmts))

  dummies <- paste_dummies(c(1:ncat)[-refcat], dest_mat, dest_col, 'Xc', dummy_cols, index = 'i')


  paste0(tab(4), "# multinomial model for ", varname, "\n",
         tab(4), "Xcat[i, ", dest_col, "] ~ dcat(p_", varname, "[i, 1:", ncat, "])", "\n\n",
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
  paste0('\n',
         tab(), "# Priors for ", varname,"\n",
         tab(), "for (k in ", min(unlist(par_elmts)), ":", max(unlist(par_elmts)), ") {", "\n",
         tab(4), "alpha[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial)", "\n",
         tab(), "}", "\n"
  )
}
