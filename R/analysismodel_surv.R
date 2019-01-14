
survreg_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)

  paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
    paste0('\n', tab(), " + ", tab(12 + nchar(y_name)),
           "inprod(Xic[j, ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }

  paste_ppc <- if (Mlist$ppc) {
    paste0(
      tab(4), y_name, "_ppc[j] ~ dgen.gamma(1, rate_", y_name, "[j], shape_", y_name, ")", "\n",
      tab(4), 'mu_', y_name, '[j] <- 1/rate_', y_name, '[j] * exp(loggam(1 + 1/shape_', y_name, '))', "\n"
    )
  }


  paste0(tab(4), "# Weibull survival model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dgen.gamma(1, rate_", y_name, "[j], shape_", y_name, ")", "\n",
         paste_ppc,
         tab(4), "cens[j] ~ dinterval(", y_name, "[j], ctime[j])", "\n",
         tab(4), "log(rate_", y_name, "[j]) <- -inprod(Xc[j, ], beta[", K['Xc', 1], ":", K['Xc', 2], "])",
         paste_Xic
  )
}

survreg_priors <- function(K, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste_ppc <- if (Mlist$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', y_name, '\n',
           tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
           tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
           tab(), 'ppc_', y_name, " <- mean(step(ppc_", y_name, "_o - ppc_", y_name, "_e)) - 0.5", "\n"
    )
  }

  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}", "\n",
    tab(), "shape_", y_name ," ~ dexp(0.01)", "\n",
    paste_ppc,
    "\n")
}





coxph_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)

  paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
    paste0(" + \n", tab(12 + nchar(y_name)),
           "inprod(Xic[subj[j], ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }


  paste0(tab(), "# Cox PH model for ", y_name, "\n",
         tab(), "dN[j] ~ dpois(Idt[j])", "\n",
         tab(), "Idt[j] <- RiskSet[j] * exp(inprod(Xc[subj[j],", K['Xc', 1], ":", K['Xc', 2],"], beta[", K['Xc', 1], ":", K['Xc', 2], "])",
         paste_Xic, ") * dL0[time[j]]", "\n",
         tab(), "}", "\n",
         tab(), "for (j in 1:(nt-1)) {", "\n",
         tab(4), "dL0[j] ~ dgamma(priorhaz[j], c)"
  )
}

coxph_priors <- function(K, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}"
  )
}
