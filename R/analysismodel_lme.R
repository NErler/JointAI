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
lme_model <- function(Mlist, K, ...){
  y_name <- colnames(Mlist$y)

  norm.distr  <- if (ncol(Mlist$Z) < 2) {"dnorm"} else {"dmnorm"}

  paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
    paste0(" + \n", tab(nchar(y_name) + 17),
           paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xic',
                           parelmts = K["Xic", 1]:K["Xic", 2],
                           cols = Mlist$cols_main$Xic, indent = 0))
  }

  paste_Xl <- if (length(Mlist$cols_main$Xl) > 0) {
    paste0(" + \n", tab(nchar(y_name) + 14),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xl',
                           parelmts = K["Xl", 1]:K["Xl", 2],
                           cols = Mlist$cols_main$Xl, indent = 0)
    )
  }

  paste_Xil <- if (length(Mlist$cols_main$Xil) > 0) {
    paste0(" + \n", tab(nchar(y_name) + 14),
           paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xil',
                           parelmts = K["Xil", 1]:K["Xil", 2],
                           cols = Mlist$cols_main$Xil, indent = 0)
    )
  }


  paste_ppc <- if (Mlist$ppc) {
    paste0(
      tab(4), y_name, "_ppc[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n"
    )
  }

  paste0(tab(4), "# Linear mixed effects model for ", y_name, "\n",
         tab(4), y_name, "[j] ~ dnorm(mu_", y_name, "[j], tau_", y_name, ")", "\n",
         paste_ppc,
         tab(4), "mu_", y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
         paste_Xl,
         paste_Xil, "\n",
         tab(2), "}", "\n\n",
         tab(2), "for (i in 1:", Mlist$N, ") {", "\n",
         tab(4), "b[i, 1:", Mlist$nranef, "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
         tab(4), "mu_b[i, 1] <- ",
         paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xc',
                         parelmts = K["Xc", 1]:K["Xc", 2],
                         cols = Mlist$cols_main$Xc, indent = 18),
         paste_Xic, "\n",
         paste_rdslopes(Mlist$nranef, Mlist$hc_list, K)
  )
}


paste_rdslopes <- function(nranef, hc_list, K){
  if (nranef > 1) {
    rd_slopes <- list()
    for (k in 2:nranef) {
      beta_start <- K[names(hc_list)[k - 1], 1]
      beta_end <- K[names(hc_list)[k - 1], 2]

      if (any(sapply(hc_list[[k - 1]], attr, "matrix") == "Xc")) {
        vec <- sapply(hc_list[[k - 1]], attr, "matrix") == "Xc"
        Xc_pos <- sapply(seq_along(vec), function (i) {
          ifelse(vec[i], attr(hc_list[[k - 1]][[i]], 'column'), NA)
        })

        hc_interact <- paste0("beta[", beta_start:beta_end, "]",
                              sapply(Xc_pos, function(x) {
                                if (!is.na(x)) {
                                  paste0(" * Xc[i, ", x, "]")
                                } else {
                                  ""
                                }
                              })
        )
      } else {
        hc_interact <- "0"
      }

      # hc_interact <- if (!is.null(hc_list[[colnames(Z)[k]]])) {
      #   paste0("beta[", beta_start:beta_end, "]",
      #          sapply(Xc_pos, function(x) {
      #            if (!is.na(x)) {
      #              paste0(" * Xc[i, ", x, "]")
      #            } else {
      #              ""
      #            }
      #          })
      #   )
      # } else {
      #   "0"
      # }

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
lme_priors <- function(K, Mlist, ...){
  y_name <- colnames(Mlist$y)

  paste_ppc <- if (Mlist$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', y_name, '\n',
           tab(), 'ppc_', y_name, "_o <- pow(", y_name, "[] - mu_", y_name, "[], 2)", "\n",
           tab(), 'ppc_', y_name, "_e <- pow(", y_name, "_ppc[] - mu_", y_name, "[], 2)", "\n",
           tab(), 'ppc_', y_name, " <- mean(step(ppc_", y_name, "_o - ppc_", y_name, "_e)) - 0.5", "\n"
    )
  }

  paste0(c(ranef_priors(Mlist$nranef),
           lmereg_priors(K, y_name, Mlist),
           paste_ppc), collapse = "\n\n")
}


lmereg_priors <- function(K, y_name, Mlist){

  if (Mlist$ridge) {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main[k])", "\n",
                    tab(4), "tau_reg_main[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n")
  }

  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    distr,
    tab(), "}", "\n",
    tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
    tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")", "\n")
}

