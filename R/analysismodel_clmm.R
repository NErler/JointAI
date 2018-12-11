# Cumulative logit mixed model

clmm_model <- function(Mlist = NULL, K, ...){

  y_name <- colnames(Mlist$y)

  norm.distr  <- if (ncol(Mlist$Z) < 2) {"dnorm"} else {"dmnorm"}


  paste_Xic <- if (!is.null(Mlist$Xic)) {
    paste0(" + \n", tab(nchar(y_name) + 17),
           paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = 0))
  }

  paste_Xl <- if (!is.null(Mlist$Xl)) {
    paste0(" + \n", tab(nchar(y_name) + 15),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xl',
                           parelmts = K["Xl", 1]:K["Xl", 2],
                           cols = Mlist$cols_main$Xl, indent = 0)
    )
  }

  paste_Xil <- if (!is.null(Mlist$Xil)) {
    paste0(" + \n", tab(nchar(y_name) + 15),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xil',
                           parelmts = K["Xil", 1]:K["Xil", 2],
                           cols = Mlist$cols_main$Xil, indent = 0)
    )
  }



  probs <- sapply(2:(Mlist$ncat - 1), function(k){
    paste0(tab(4), "p_", y_name, "[j, ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           y_name, "[j, ", k,"] - psum_", y_name, "[j, ", k - 1, "]))")})

  logits <- sapply(1:(Mlist$ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", y_name, "[j, ", k, "])  <- gamma_", y_name,
           "[", k, "]", " + eta_", y_name,"[j]")
  })


  paste0(tab(4), "# Cumulative logit mixed effects model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dcat(p_", y_name, "[j, 1:", Mlist$ncat, "])", "\n",
         tab(4), 'eta_', y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
         paste_Xl,
         paste_Xil,
         "\n\n",
         tab(4), "p_", y_name, "[j, 1] <- max(1e-10, min(1-1e-7, psum_", y_name, "[j, 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", y_name, "[j, ", Mlist$ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         y_name, "[j, 1:", Mlist$ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n",
         tab(), "}", "\n\n",
         tab(), "for (i in 1:", Mlist$N, ") {", "\n",
         tab(4), "b[i, 1:", ncol(Mlist$Z), "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
         tab(4), "mu_b[i, 1] <- ",
         if (length(Mlist$cols_main$Xc) > 0) {
           paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xc',
                           parelmts = K["Xc", 1]:K["Xc", 2],
                           cols = Mlist$cols_main$Xc, indent = 18)
           } else {'0'},
         paste_Xic, "\n",
         paste_rdslopes(Mlist$Z, Mlist$hc_list, K)
  )
}


clmm_priors <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)

  deltas <- sapply(1:(Mlist$ncat - 2), function(k) {
    paste0(tab(), "delta_", y_name, "[", k, "] ~ dnorm(mu_delta_main, tau_delta_main)")
  })

  gammas <- sapply(1:(Mlist$ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", y_name, "[", k, "] ~ dnorm(mu_delta_main, tau_delta_main)")
    } else {
      paste0(tab(), "gamma_", y_name, "[", k, "] <- gamma_", y_name, "[", k - 1,
             "] + exp(delta_", y_name, "[", k - 1, "])")
    }
  })

  paste0(tab(), "# Priors for the coefficients in the analysis model", "\n",
         if (any(!is.na(K))) {
         paste0(
           tab(), "for (k in 1:", max(K, na.rm = T), ") {", "\n",
           tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
           tab(), "}", "\n\n")
         },
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"), "\n\n",
         ranef_priors(Mlist$Z))
}
