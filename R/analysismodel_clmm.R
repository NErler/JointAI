# Cumulative logit mixed model

clmm_model <- function(N, y_name, Z = NULL, Xic = NULL, Xl = NULL,
                      Xil = NULL, hc_list = NULL, Mlist = NULL, K, ...){

  if (!is.null(Mlist)) {
    for (i in 1:length(Mlist)) {
      assign(names(Mlist)[i], Mlist[[i]])
    }
  }

  norm.distr  <- if (ncol(Z) < 2) {"dnorm"} else {"dmnorm"}

  paste_Xic <- if (!is.null(Xic)) {
    paste0(" + \n", tab(nchar(y_name) + 17),
           "inprod(Xic[j, ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }

  paste_Xl <- if (!is.null(Xl)) {
    paste0(" + \n", tab(nchar(y_name) + 12),
           "inprod(Xl[j, ], beta[", K["Xl", 1], ":", K["Xl", 2], "])")
  }

  paste_Xil <- if (!is.null(Xil)) {
    paste0(" + \n", tab(nchar(y_name) + 12),
           "inprod(Xil[j, ], beta[", K["Xil", 1], ":", K["Xil", 2], "])")
  }

  probs <- sapply(2:(ncat - 1), function(k){
    paste0(tab(), "p_", y_name, "[j, ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           y_name, "[j, ", k,"] - psum_", y_name, "[j, ", k - 1, "]))")})

  logits <- sapply(1:(ncat - 1), function(k) {
    paste0(tab(), "logit(psum_", y_name, "[j, ", k, "])  <- gamma_", y_name,
           "[", k, "]", " + eta_", y_name,"[j]")
  })


  paste0(tab(), "# Cumulative logit mixed effects model for ", y_name, "\n",
         tab(), y_name, "[j] ~ dcat(p_", y_name, "[j, 1:", ncat, "])", "\n",
         tab(), 'eta_', y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
         paste_Xic,
         paste_Xl,
         paste_Xil, "\n\n",
         tab(), "p_", y_name, "[j, 1] <- max(1e-10, min(1-1e-7, psum_", y_name, "[j, 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(), "p_", y_name, "[j, ", ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         y_name, "[j, 1:", ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n\n",
         tab(), "}", "\n\n",
         tab(), "for (i in 1:", N, ") {", "\n",
         tab(4), "b[i, 1:", ncol(Z), "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
         tab(4), "mu_b[i, 1] <- inprod(beta[", K["Xc", 1], ":", K["Xc", 2], "], Xc[i, ])", "\n",
         paste_rdslopes(Z, hc_list, K)
  )
}


clmm_priors <- function(K, y_name, Z = NULL, Mlist = NULL, ncat, ...){

  if (is.null(Z))
    Z <- Mlist$Z


  par_elmts <- seq(min(K, na.rm = T), max(K, na.rm = T), by = 1)
  par_name <- 'beta'

  deltas <- sapply(1:(ncat - 2), function(k) {
    paste0(tab(), "delta_", y_name, "[", k, "] ~ dnorm(mu_delta_main, tau_delta_main)")
  })

  gammas <- sapply(1:(ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", y_name, "[", k, "] ~ dnorm(mu_delta_main, tau_delta_main)")
    } else {
      paste0(tab(), "gamma_", y_name, "[", k, "] <- gamma_", y_name, "[", k - 1,
             "] + exp(delta_", y_name, "[", k - 1, "])")
    }
  })

  paste0(tab(), "# Priors for ", y_name, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
         tab(), "}", "\n\n",
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"), "\n\n",
         ranef_priors(Z))
}
