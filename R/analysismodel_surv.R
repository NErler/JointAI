
survreg_model <- function(N, y_name, Z = NULL, Xic = NULL, Xl = NULL,
                     Xil = NULL, hc_list = NULL, Mlist = NULL, K, ...){

  if (!is.null(Mlist)) {
    for (i in 1:length(Mlist)) {
      assign(names(Mlist)[i], Mlist[[i]])
    }
  }

  paste_Xic <- if (!is.null(Xic)) {
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

survreg_priors <- function(K, y_name, ...){
  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}", "\n",
    tab(), "sigma_", y_name ," ~ dexp(0.01)", "\n\n")
}









coxph_model <- function(N, y_name, Z = NULL, Xic = NULL, Xl = NULL,
                          Xil = NULL, hc_list = NULL, Mlist = NULL, K, ...){

  if (!is.null(Mlist)) {
    for (i in 1:length(Mlist)) {
      assign(names(Mlist)[i], Mlist[[i]])
    }
  }

  paste_Xic <- if (!is.null(Xic)) {
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

coxph_priors <- function(K, y_name, ...){
  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}"
  )
}
