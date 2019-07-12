# Imputation by cumulative logistic regression
impmodel_multilogit <- function(varname, dest_col, Xc_cols, par_elmts, dummy_cols, ncat, dest_mat, refcat, ppc, ...){

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


  paste_ppc <- if (ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), varname, "_ppc[i] ~ dcat(p_", varname, "[i, 1:", ncat, "])", "\n"
    )
  }

  paste0(tab(4), "# multinomial model for ", varname, "\n",
         tab(4), "Xcat[i, ", dest_col, "] ~ dcat(p_", varname, "[i, 1:", ncat, "])", "\n\n",
         paste_ppc,
         paste(probs, collapse = "\n"), "\n\n",
         paste0(logs, collapse = "\n"), "\n\n",
         paste0(dummies, collapse = "\n"), "\n\n")
}



# Priors for multinomial imputation model
impprior_multilogit <- function(varname, par_elmts, par_name, ...){
  paste0('\n',
         tab(), "# Priors for ", varname,"\n",
         tab(), "for (k in ", min(unlist(par_elmts)), ":", max(unlist(par_elmts)), ") {", "\n",
         tab(4), "alpha[k] ~ dnorm(mu_reg_multinomial, tau_reg_multinomial)", "\n",
         tab(), "}", "\n"
  )
}
