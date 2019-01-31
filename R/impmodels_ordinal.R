# Imputation by cumulative logistic regression
impmodel_cumlogit <- function(varname, dest_mat, dest_col, Xc_cols, par_elmts, dummy_cols, ncat, refcat, ...){

  indent <- nchar(varname) + 15

  predictor <-  paste_predictor(parnam = 'alpha', parindex = 'i', matnam = 'Xc',
                                parelmts = par_elmts["Xc", 1]:par_elmts["Xc", 2],
                                cols = Xc_cols, indent = indent)

  probs <- sapply(2:(ncat - 1), function(k){
    paste0(tab(4), "p_", varname, "[i, ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           varname, "[i, ", k,"] - psum_", varname, "[i, ", k - 1, "]))")})

  logits <- sapply(1:(ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", varname, "[i, ", k, "])  <- gamma_", varname,
           "[", k, "]", " + eta_", varname,"[i]")
  })

  dummies <- paste_dummies(c(1:ncat)[-refcat], dest_mat, dest_col, 'Xc', dummy_cols, index = 'i')


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
         tab(), "for (k in ", par_elmts['Xc', 1], ":", par_elmts['Xc', 2], ") {", "\n",
         tab(4), "alpha[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n",
         tab(), "}", "\n\n",
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"), "\n")
}


impmodel_clmm <- function(varname, dest_mat, dest_col, Xc_cols, Xl_cols, ncat, refcat,
                          Z_cols, dummy_cols, par_elmts, ppc, nranef, N, Ntot, hc_list, ...) {


  norm.distr  <- if (nranef < 2) {"dnorm"} else {"dmnorm"}

  paste_Xl <- if (!is.null(Xl_cols)) {
    paste0(" + \n", tab(nchar(varname) + 15),
           paste_predictor(parnam = 'alpha', parindex = 'j', matnam = 'Xl',
                           parelmts = par_elmts["Xl", 1]:par_elmts["Xl", 2],
                           cols = Xl_cols, indent = nchar(varname) + 15)
    )
  }

  probs <- sapply(2:(ncat - 1), function(k){
    paste0(tab(4), "p_", varname, "[j, ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           varname, "[j, ", k,"] - psum_", varname, "[j, ", k - 1, "]))")})

  logits <- sapply(1:(ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", varname, "[j, ", k, "])  <- gamma_", varname,
           "[", k, "]", " + eta_", varname,"[j]")
  })

  dummies <- paste_dummies(c(1:ncat)[-refcat], dest_mat, dest_col, 'Xl', dummy_cols, index = 'j')


  paste_ppc <- NULL #if (ppc) {
  # paste0("\n",
  # tab(4), "# For posterior predictive check:", "\n",
  # tab(4), varname, "_ppc[j] ~ ", distr(varname), "\n"
  # )
  # }

  paste0(tab(), "# Cumulative logit mixed effects model for ", varname, "\n",
         tab(), "for (j in 1:", Ntot, ") {", "\n",
         tab(4), dest_mat, "[j, ", dest_col, "] ~ dcat(p_", varname, "[j, 1:", ncat, "])", "\n",
         tab(4), "eta_", varname,"[j] <- ",
         paste_ranef_predictor(parnam = paste0("b_", varname), parindex = 'j',
                               matnam = 'Z',
                               parelmts = 1:nranef,
                               cols = Z_cols, indent = 4 + 3 + nchar(varname) + 7),
         paste_Xl, '\n\n',
         tab(4), "p_", varname, "[j, 1] <- max(1e-10, min(1-1e-7, psum_", varname, "[j, 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", varname, "[j, ", ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         varname, "[j, 1:", ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n\n",
         paste0(dummies, collapse = "\n"), "\n",
         paste_ppc,
         tab(), "}", "\n\n",
         tab(), "for (i in 1:", N, ") {", "\n",
         tab(4), "b_", varname, "[i, 1:", nranef, "] ~ ", norm.distr,
         "(mu_b_", varname, "[i, ], invD_", varname, "[ , ])", "\n",
         tab(4), "mu_b_", varname, "[i, 1] <- ",
         paste_predictor(parnam = 'alpha', parindex = 'i', matnam = 'Xc',
                         parelmts = par_elmts["Xc", 1]:par_elmts["Xc", 2],
                         cols = Xc_cols, indent = 19 + nchar(varname)), "\n",
         paste_rdslopes_covmod(nranef, hc_list, par_elmts, varname), "\n",
         tab(), "}\n"
         # paste_Xic,
         # "\n",
  )
}


# family, link, varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...
impprior_clmm <- function(varname, par_elmts, ncat, ppc, nranef, ...){
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


  paste_ppc <- NULL # if (ppc) {
  #   paste0('\n',
  #          tab(), '# Posterior predictive check for the model for ', varname, '\n',
  #          tab(), 'ppc_', varname, "_o <- pow(", dest_mat, "[,", dest_col, "] - mu_", varname, "[], 2)", "\n",
  #          tab(), 'ppc_', varname, "_e <- pow(", varname, "_ppc[] - mu_", varname, "[], 2)", "\n",
  #          tab(), 'ppc_', varname, " <- mean(ifelse(ppc_", varname, "_o > ppc_", varname, "_e, 1, 0) + ",
  #          "ifelse(ppc_", varname, "_o == ppc_", varname, "_e, 0.5, 0)) - 0.5", "\n"
  #   )
  # }
  #
  priors <- paste0('\n',
                   tab(), "# Priors for ", varname, "\n",
                   tab(), "for (k in ", min(par_elmts, na.rm = T), ":", max(par_elmts, na.rm = TRUE), ") {", "\n",
                   tab(4), "alpha[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n",
                   tab(), "}", "\n\n",
                   paste(deltas, collapse = "\n"), "\n\n",
                   paste(gammas, collapse = "\n")
  )

  paste0(c(priors,
           ranef_priors(nranef, varname),
           paste_ppc), collapse = "\n")
}
