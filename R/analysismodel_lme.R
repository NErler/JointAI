# Function to write linear mixed model as analysis model
# @param N number of subjects / random intercepts
# @param y y
# @param Z random effects design matrix
# @param Xic design matrix of cross-sectional interaction effects
# @param Xl design matrix of longitudinal covariates
# @param hc_list hierarchical centering specification
# @param K matrix specifying the number of parameters for each component of the
#        fixed effects
# @export
lme_model <- function(N, y_name, Z = NULL, Xic = NULL, Xl = NULL,
                      Xil = NULL, hc_list = NULL, Mlist = NULL, K, ...){

  if (!is.null(Mlist)) {
    for (i in 1:length(Mlist)) {
      assign(names(Mlist)[i], Mlist[[i]])
    }
  }

  norm.distr  <- if (ncol(Z) < 2) {"dnorm"} else {"dmnorm"}

  paste_Xic <- if (!is.null(Xic)) {
    paste0(" + \n", tab(nchar(y_name) + 17),
           "inprod(Xic[i, ], beta[", K["Xic", 1],":", K["Xic", 2],"])", sep = "")
  }

  paste_Xl <- if (!is.null(Xl)) {
    paste0(" + \n", tab(nchar(y_name) + 12),
           "inprod(Xl[j, ], beta[", K["Xl", 1], ":", K["Xl", 2], "])")
  }

  paste_Xil <- if (!is.null(Xil)) {
    paste0(" + \n", tab(nchar(y_name) + 12),
           "inprod(Xil[j, ], beta[", K["Xil", 1], ":", K["Xil", 2], "])")
  }



  paste0(tab(), "# Linear mixed effects model for ", y_name, "\n",
         tab(), y_name, "[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n",
         tab(), "mu_", y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
         paste_Xl,
         paste_Xil, "\n",
         tab(), "}", "\n\n",
         tab(), "for (i in 1:", N, ") {", "\n",
         tab(4), "b[i, 1:", ncol(Z), "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
         tab(4), "mu_b[i, 1] <- inprod(beta[", K["Xc", 1], ":", K["Xc", 2], "], Xc[i, ])",
         paste_Xic, "\n",
         paste_rdslopes(Z, hc_list, K)
  )
}


paste_rdslopes <- function(Z, hc_list, K){
  if (ncol(Z) > 1) {
    rd_slopes <- list()
    for (k in 2:ncol(Z)) {
      beta_start <- K[colnames(Z)[k], 1]
      beta_end <- K[colnames(Z)[k], 2]
      Xc_pos <- if (any(attr(hc_list[[k - 1]], "matrix") == "Xc")) {
        hc_list[[k - 1]][which(attr(hc_list[[k - 1]], "matrix") %in% c("Z", "Xc"))]
      }

      hc_interact <- if (!is.null(hc_list[[colnames(Z)[k]]])) {
        paste0("beta[", beta_start:beta_end, "]",
               sapply(Xc_pos, function(x) {
                 if (!is.na(x)) {
                   paste0(" * Xc[i, ", x, "]")
                 } else {
                   ""
                 }
               })
        )
      } else {
        "0"
      }

      rd_slopes[[k - 1]] <- paste0(tab(4), "mu_b[i, ", k,"] <- ",
                                   paste0(hc_interact, sep = "", collapse = " + "))
    }
    paste(rd_slopes, collapse = "\n")
  }
}


# Write priors for a linear mixed model
# @param K K
# @param y_name name of the outcome
# @param Z random effects design matrix
# @export
lme_priors <- function(K, y_name, Z = NULL, Mlist = NULL, ...){
  if (is.null(Z) & !is.null(Mlist)) {
    Z <- Mlist$Z
  }
  paste0(c(ranef_priors(Z),
           lmereg_priors(K, y_name)), collapse = "\n\n")
}


lmereg_priors <- function(K, y_name){
  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = T), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}", "\n",
    tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
    tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")", "\n\n")
}



ranef_priors <- function(Z){
  paste0(
    tab(), "# Priors for the covariance of the random effects", "\n",
    tab(), "for (k in 1:", ncol(Z), "){", "\n",
    tab(4), "RinvD[k, k] ~ dgamma(a_diag_RinvD, b_diag_RinvD)", "\n",
    tab(), "}", "\n",
    tab(), "invD[1:", ncol(Z), ", 1:", ncol(Z),"] ~ ", invD_distr(Z), "\n",
    tab(), "D[1:", ncol(Z),", 1:", ncol(Z),"] <- inverse(invD[ , ])"
  )
}

invD_distr <- function(Z){
  if (ncol(Z) == 1) {
    "dgamma(a_diag_RinvD, b_diag_RinvD)"
  } else {
    "dwish(RinvD[ , ], KinvD)"
  }
}

