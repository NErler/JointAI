JAGSmodel_clmm <- function(info) {
  indent <- 4 + 4 + nchar(info$varname) + 7

  # model parts ----------------------------------------------------------------
  probs <- sapply(2:(info$ncat - 1), function(k) {
    paste0(tab(4), "p_", info$varname, "[", info$index[1], ", ", k, "] <- max(1e-7, min(1-1e-10, psum_",
           info$varname, "[", info$index[1], ", ", k,"] - psum_", info$varname, "[", info$index[1], ", ", k - 1, "]))")})

  logits <- sapply(1:(info$ncat - 1), function(k) {
    paste0(tab(4), "logit(psum_", info$varname, "[", info$index[1], ", ", k, "])  <- gamma_", info$varname,
           "[", k, "]", " + eta_", info$varname,"[", info$index[1], "]")
  })


  deltas <- sapply(1:(info$ncat - 2), function(k) {
    paste0(tab(), "delta_", info$varname, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
  })

  gammas <- sapply(1:(info$ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", info$varname, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
    } else {
      paste0(tab(), "gamma_", info$varname, "[", k, "] <- gamma_", info$varname, "[", k - 1,
             "] + exp(delta_", info$varname, "[", k - 1, "])")
    }
  })


  rd_predictor <- get_ranefpreds(info)

  norm.distr  <- if (length(info$hc_list) < 2) {"dnorm"} else {"dmnorm"}

  dummies <- if (!is.null(info$dummy_cols)) {
    paste0('\n', paste_dummies(categories = info$categories, dest_mat = info$resp_mat,
                               dest_col = info$resp_col, dummy_cols = info$dummy_cols,
                               index = info$index[1]), collapse = "\n")
  }


  trunc <- if (!is.null(info$trunc))
    paste0("T(", paste0(info$trunc, collapse = ", "), ")")



  # posterior predictive check -------------------------------------------------
  paste_ppc <- if (info$ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), info$varname, "_ppc[", info$index[1], "] ~ dcat(p_",
           info$varname, "[", info$index[1], ", 1:", info$ncat, "])", "\n"
    )
  }

  # paste_ppc_prior <- if (info$ppc) {
  #   paste0('\n',
  #          tab(), '# Posterior predictive check for the model for ', info$varname, '\n',
  #          tab(), 'ppc_', info$varname, "_o <- pow(", info$varname, "[] - mu_", info$varname, "[], 2)", "\n",
  #          tab(), 'ppc_', info$varname, "_e <- pow(", info$varname, "_ppc[] - mu_", info$varname, "[], 2)", "\n",
  #          tab(), 'ppc_', info$varname, " <- mean(step(ppc_", info$varname, "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
  #   )
  # }


  # shrinkage ------------------------------------------------------------------
  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal_ridge[k])", "\n",
                    tab(4), "tau_reg_ordinal_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n")
  }

  # write model ----------------------------------------------------------------
  paste0(tab(), "# Cumulative logit mixed effects model for ", info$varname, "\n",
         tab(), "for (", info$index[1], " in 1:", info$Ntot, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index[1], ", ", info$resp_col,
         "] ~ dcat(p_", info$varname, "[", info$index[1], ", 1:", info$ncat, "])", "\n",

         tab(4), 'eta_', info$varname, "[", info$index[1], "] <- ",
         paste0(c(rd_predictor$Z_predictor, rd_predictor$Ml_predictor), collapse = " +\n"), "\n\n",
         tab(4), "p_", info$varname, "[", info$index[1], ", 1] <- max(1e-10, min(1-1e-7, psum_", info$varname, "[", info$index[1], ", 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(4), "p_", info$varname, "[", info$index[1], ", ", info$ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
         info$varname, "[", info$index[1], ", 1:", info$ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"),
         paste(dummies, collapse = "\n"),
         "\n",
         paste_ppc,
         tab(), "}", "\n",
         "\n",
         tab(), "for (", info$index[2], " in 1:", info$N, ") {", "\n",
         tab(4), "b_", info$varname, "[", info$index[2], ", 1:", max(1, length(info$hc_list)), "] ~ ", norm.distr,
         "(mu_b_", info$varname, "[", info$index[2], ", ], invD_", info$varname, "[ , ])", "\n",
         rd_predictor$ranefpreds, "\n",
         tab(), "}", "\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (any(!sapply(info$parelmts, is.null))) {
           paste0(tab(), "for (k in ", min(info$parelmts$Mc, info$parelmts$Ml), ":",
                  max(info$parelmts$Mc, info$parelmts$Ml), ") {", "\n",
                  priordistr,
                  tab(), "}")
         },
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"),
         # paste_ppc_prior,
         "\n",
         ranef_priors(max(1, length(info$hc_list)), info$varname)
  )
}




#
# # Cumulative logit mixed model
#
# clmm_model <- function(Mlist = NULL, K, ...){
#
#   y_name <- colnames(Mlist$y)
#
#   norm.distr  <- if (ncol(Mlist$Z) < 2) {"dnorm"} else {"dmnorm"}
#
#
#   paste_Xic <- if (!is.null(Mlist$Xic)) {
#     paste0(" + \n", tab(nchar(y_name) + 17),
#            paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xic',
#                            parelmts = K["Xic", 1]:K["Xic", 2],
#                            cols = Mlist$cols_main$Xic, indent = 0))
#   }
#
#   paste_Xl <- if (!is.null(Mlist$Xl)) {
#     paste0(" + \n", tab(nchar(y_name) + 15),
#            paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xl',
#                            parelmts = K["Xl", 1]:K["Xl", 2],
#                            cols = Mlist$cols_main$Xl, indent = 0)
#     )
#   }
#
#   paste_Xil <- if (!is.null(Mlist$Xil)) {
#     paste0(" + \n", tab(nchar(y_name) + 15),
#            paste_predictor(parnam = 'beta', parindex = 'j', matnam = 'Xil',
#                            parelmts = K["Xil", 1]:K["Xil", 2],
#                            cols = Mlist$cols_main$Xil, indent = 0)
#     )
#   }
#
#
#
#   probs <- sapply(2:(Mlist$ncat - 1), function(k){
#     paste0(tab(4), "p_", y_name, "[j, ", k, "] <- max(1e-7, min(1-1e-10, psum_",
#            y_name, "[j, ", k,"] - psum_", y_name, "[j, ", k - 1, "]))")})
#
#   logits <- sapply(1:(Mlist$ncat - 1), function(k) {
#     paste0(tab(4), "logit(psum_", y_name, "[j, ", k, "])  <- gamma_", y_name,
#            "[", k, "]", " + eta_", y_name,"[j]")
#   })
#
#
#   paste0(tab(4), "# Cumulative logit mixed effects model for ", y_name, "\n",
#          tab(4), y_name, "[j] ~ dcat(p_", y_name, "[j, 1:", Mlist$ncat, "])", "\n",
#          tab(4), 'eta_', y_name, "[j] <- inprod(Z[j, ], b[groups[j], ])",
#          paste_Xl,
#          paste_Xil,
#          "\n\n",
#          tab(4), "p_", y_name, "[j, 1] <- max(1e-10, min(1-1e-7, psum_", y_name, "[j, 1]))", "\n",
#          paste(probs, collapse = "\n"), "\n",
#          tab(4), "p_", y_name, "[j, ", Mlist$ncat, "] <- 1 - max(1e-10, min(1-1e-7, sum(p_",
#          y_name, "[j, 1:", Mlist$ncat - 1,"])))", "\n\n",
#          paste0(logits, collapse = "\n"), "\n",
#          tab(), "}", "\n\n",
#          tab(), "for (i in 1:", Mlist$N, ") {", "\n",
#          tab(4), "b[i, 1:", ncol(Mlist$Z), "] ~ ", norm.distr, "(mu_b[i, ], invD[ , ])", "\n",
#          tab(4), "mu_b[i, 1] <- ",
#          if (length(Mlist$cols_main$Xc) > 0) {
#            paste_predictor(parnam = 'beta', parindex = 'i', matnam = 'Xc',
#                            parelmts = K["Xc", 1]:K["Xc", 2],
#                            cols = Mlist$cols_main$Xc, indent = 18)
#            } else {'0'},
#          paste_Xic, "\n",
#          paste_rdslopes(Mlist$nranef, Mlist$hc_list, K)
#   )
# }
#
#
# clmm_priors <- function(Mlist, K, ...){
#
#   y_name <- colnames(Mlist$y)
#
#   deltas <- sapply(1:(Mlist$ncat - 2), function(k) {
#     paste0(tab(), "delta_", y_name, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
#   })
#
#   gammas <- sapply(1:(Mlist$ncat - 1), function(k) {
#     if (k == 1) {
#       paste0(tab(), "gamma_", y_name, "[", k, "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
#     } else {
#       paste0(tab(), "gamma_", y_name, "[", k, "] <- gamma_", y_name, "[", k - 1,
#              "] + exp(delta_", y_name, "[", k - 1, "])")
#     }
#   })
#
#   if (Mlist$ridge) {
#     distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal_ridge[k])", "\n",
#                     tab(4), "tau_reg_ordinal_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
#   } else {
#     distr <- paste0(tab(4), "beta[k] ~ dnorm(mu_reg_ordinal, tau_reg_ordinal)", "\n")
#   }
#
#   paste0(tab(), "# Priors for the coefficients in the analysis model", "\n",
#          if (any(!is.na(K))) {
#          paste0(
#            tab(), "for (k in 1:", max(K, na.rm = T), ") {", "\n",
#            distr,
#            tab(), "}", "\n\n")
#          },
#          paste(deltas, collapse = "\n"), "\n\n",
#          paste(gammas, collapse = "\n"), "\n\n",
#          ranef_priors(Mlist$nranef)
#   )
# }
