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


  paste_ppc <- if (Mlist$ppc) {
    paste0(
      tab(4), y_name, "_ppc[j] ~ dcat(p_", y_name, "[j, 1:", Mlist$ncat, "])", "\n"
    )
  }


  paste0(tab(4), "# Cumulative logit mixed effects model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dcat(p_", y_name, "[j, 1:", Mlist$ncat, "])", "\n",
         paste_ppc,
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
         paste_rdslopes(Mlist$nranef, Mlist$hc_list, K)
  )
}


clmm_priors <- function(Mlist, K, K_list, ...){

  y_name <- colnames(Mlist$y)

  deltas <- sapply(1:(Mlist$ncat - 2), function(k) {
    paste0(tab(), "delta_", y_name, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
  })

  gammas <- sapply(1:(Mlist$ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", y_name, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
    } else {
      paste0(tab(), "gamma_", y_name, "[", k, "] <- gamma_", y_name, "[", k - 1,
             "] + exp(delta_", y_name, "[", k - 1, "])")
    }
  })

  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal_ridge[k])", "\n",
                    tab(4), "tau_reg_ordinal_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n")
  }


  paste0(tab(), "# Priors for the coefficients in the analysis model", "\n",
         if (any(!is.na(K))) {
           paste0(
             paste_regcoef_prior(K_list, distr, 'beta'),
           #   tab(), "for (k in 1:", max(K, na.rm = T), ") {", "\n",
           #   distr,
           #   tab(), "}",
           "\n\n")
         },
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"), "\n\n",
         ranef_priors(Mlist$nranef)
  )
}






# latent normal model -----------------------------------------------------------
lnmm_model <- function(Mlist = NULL, K, ...) {

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

  paste_ppc <- if (Mlist$ppc) {
    paste0(
      tab(4), y_name, "_lat_ppc[j] ~ dnorm(mu_", y_name, "[j], 1)", "\n",
      tab(4), y_name, "_ppc[j] ~ dinterval(", y_name, "_lat_ppc[j], delta_", y_name, "[])", "\n",
    )
  }

  paste0(tab(4), "# Latent normal mixed effects model for ", y_name, "\n",
         tab(4), y_name, "_lat[j] ~ dnorm(mu_", y_name, "[j], 1)", "\n",
         tab(4), y_name, "[j] ~ dinterval(", y_name, "_lat[j], delta_", y_name, "[])", "\n",
         paste_ppc,
         tab(4), "mu_", y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
         paste_Xl,
         paste_Xil,
         "\n\n",
         tab(), "}", "\n\n",
         tab(), "for (k in 1:", Mlist$ncat - 1, ") {", "\n",
         tab(4), "delta0[k] ~ dnorm(0, 1e-3)", "\n",
         tab(), "}", "\n",
         tab(), "delta_", y_name, "[1:", Mlist$ncat - 1, "] <- sort(delta0[])", "\n\n",
         tab(), "for (i in 1:", Mlist$N, ") {", "\n",
         tab(4), "b[i, 1:", ncol(Mlist$Z), "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
         tab(4), "mu_b[i, 1] <- ",
         if (length(Mlist$cols_main$Xc) > 0) {
           paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xc',
                           parelmts = K["Xc", 1]:K["Xc", 2],
                           cols = Mlist$cols_main$Xc, indent = 18)
         } else {'0'},
         paste_Xic, "\n",
         paste_rdslopes(Mlist$nranef, Mlist$hc_list, K)
  )
}




lnmm_priors <- function(Mlist, K, ...){

  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_norm, tau_reg_norm_ridge[k])", "\n",
                    tab(4), "tau_reg_norm_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_norm, tau_reg_norm)", "\n")
  }

  paste0(tab(), "# Priors for the coefficients in the analysis model", "\n",
         if (any(!is.na(K))) {
           paste0(
             tab(), "for (k in 1:", max(K, na.rm = T), ") {", "\n",
             distr,
             tab(), "}", "\n\n")
         },
         # paste(deltas, collapse = "\n"), "\n\n",
         # paste(gammas, collapse = "\n"), "\n\n",
         ranef_priors(Mlist$nranef)
  )
}


