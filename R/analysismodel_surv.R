
survreg_model <- function(Mlist, K, ...){

  y_name <- colnames(Mlist$y)

  paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
    paste0(tab(), " + ", tab(12 + nchar(y_name)),
           "inprod(Xic[j, ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }



  paste0(tab(), "# Weibull survival model for ", y_name, "\n",
         tab(), y_name, "[j] ~ dgen.gamma(1, mu_", y_name, "[j], sigma_", y_name, ")", "\n",
         tab(), "cens[j] ~ dinterval(", y_name, "[j], ctime[j])", "\n",
         tab(), "log(mu_", y_name, "[j]) <- -inprod(Xc[j, ], beta[", K['Xc', 1], ":", K['Xc', 2], "])", "\n",
         paste_Xic
  )
}

survreg_priors <- function(K, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}", "\n",
    tab(), "sigma_", y_name ," ~ dexp(0.01)", "\n\n")
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
