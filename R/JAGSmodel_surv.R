# parametric survival model ---------------------------------------------------
JAGSmodel_survreg <- function(info) {
  indent <- 4 + 9 + nchar(info$varname) + 8


  Mc_predictor <- if (!is.null(info$lp$Mc)) {
    paste_linpred(parname = info$parname,
                  parelmts = info$parelmts$Mc,
                  matnam = "Mc",
                  index = info$index,
                  cols = info$lp$Mc,
                  scale_pars = info$scale_pars$Mc,
                  isgk = FALSE)
  }


  paste_ppc <- if (info$ppc) {
    paste0(
      tab(4), info$varname, "_ppc[", info$index, "] ~ dgen.gamma(1, rate_",
      info$varname, "[", info$index, "], shape_", info$vaname, ")", "\n",
      tab(4), "mu_", info$varname, "[", info$index, "] <- 1/rate_", info$varname,
      "[", info$index, "] * exp(loggam(1 + 1/shape_", info$varname, "))", "\n"
    )
  }


  paste_ppc_prior <- if (info$ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', info$varname, '\n',
           tab(), 'ppc_', info$varname, "_o <- pow(", info$varname, "[] - mu_",
           info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, "_e <- pow(", info$varname, "_ppc[] - mu_",
           info$varname, "[], 2)", "\n",
           tab(), 'ppc_', info$varname, " <- mean(step(ppc_", info$varname,
           "_o - ppc_", info$varname, "_e)) - 0.5", "\n"
    )
  }


  if (info$shrinkage == "ridge" && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])",
                         "\n",
                    tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }

  paste0(tab(2), add_dashes(paste0("# Weibull survival model for ", info$varname)), "\n",
         tab(), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), info$varname, "[", info$index,
         "] ~ dgen.gamma(1, rate_", info$varname, "[", info$index,
         "], shape_", info$varname, ")", "\n",
         paste_ppc,
         tab(4), "cens_", info$varname, "[", info$index, "] ~ dinterval(", info$varname, "[",
         info$index, "], ", info$resp_mat[1], "[", info$index, ", ", info$resp_col[1],
         "])", "\n",
         tab(4), "log(rate_", info$varname, "[", info$index, "]) <- -1 * (",
         Mc_predictor, ")", "\n",
         tab(), "}\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (!is.null(info$lp$Mc)) {
           paste0(
             tab(), "for (k in ", min(info$parelmts$Mc), ":", max(info$parelmts$Mc), ") {", "\n",
             priordistr,
             tab(), "}", "\n")
         },
         tab(), "shape_", info$varname ," ~ dexp(0.01)", "\n",
         paste_ppc_prior
  )
}


# Cox PH model ----------------------------------------------------------------
JAGSmodel_coxph <- function(info) {
  indent <- 4 + 10 + 4

  index <- info$index[gsub("M_", "", info$resp_mat[2])]
  N <- info$N[gsub("M_", "", info$resp_mat[2])]


  rdintercept <- paste_rdintercept_lp(info)
  rdslopes <- paste_rdslope_lp(info)
  Z_predictor <- paste_lp_Zpart(info)

  eta <- if (!is.null(Z_predictor)) {
    add_linebreaks(paste0(Z_predictor, collapse = " + "), indent = indent + 2)
  } else if (!is.null(info$lp[[info$resp_mat[2]]])) {
    paste_linpred(parname = info$parname,
                  parelmts = info$parelmts[[info$resp_mat[2]]],
                  matnam = info$resp_mat[2],
                  index = index,
                  cols = info$lp[[info$resp_mat[2]]],
                  scale_pars = info$scale_pars[[info$resp_mat[2]]],
                  isgk = FALSE)
  } else {"0"}



  logh_pred <- paste(
    c(paste0("logh0[", index, "] + eta_surv[", index, "]"),
    if (info$resp_mat[2] != 'M_toplevel') {
      paste_linpred_JM(parname = info$parname,
                       parelmts = info$parelmts[['M_toplevel']],
                       matnam = "M_toplevel",
                       index = index,
                       cols = info$lp[['M_toplevel']],
                       scale_pars = info$scale_pars[['M_toplevel']],
                       assoc_type = info$assoc_type,
                       covnames = vector(mode = "list", length = length(info$lp[['M_toplevel']])),
                       isgk = FALSE)
      }), collapse = " + ")

  Surv_predictor <- paste0(
    paste0(
      c(paste0("gkw[k] * exp(logh0s[", index, ", k]"),
        if (info$resp_mat[2] != 'M_toplevel') {
          paste_linpred_JM(parname = info$parname,
                           parelmts = info$parelmts[['M_toplevel']],
                           matnam = "M_toplevel",
                           index = index,
                           cols = info$lp[['M_toplevel']],
                           scale_pars = info$scale_pars[['M_toplevel']],
                           assoc_type = info$assoc_type,
                           covnames = vector(mode = "list", length = length(info$lp[['M_toplevel']])),
                           isgk = TRUE)
        }
      ), collapse = " + "),
    ")"
  )


  survtime_col <- paste0(info$resp_mat[1] , "[",
                         if (info$resp_mat[1] != info$resp_mat[2]) {
                           paste0("survrow[", index, "]")
                         } else {
                           index
                         }, ", ", info$resp_col[1], "]")



  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])",
                         "\n",
                         tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }



  paste0(tab(), add_dashes(paste0("# Cox PH model for ", info$varname)), "\n",
         tab(), "for (", index, " in 1:", N, ") {", "\n",
         tab(4), "logh0[", index, "] <- inprod(",
         info$parname, "_Bh0[], Bh0[", index, ", ])", "\n",
         tab(4), "eta_surv[", index, "] <- ", add_linebreaks(eta, indent = 20), "\n",
         tab(4), "logh[", index, "] <- ",
         add_linebreaks(logh_pred, indent = 15),
         "\n\n",
         tab(4), "for (k in 1:15) {", "\n",
         tab(6), "logh0s[", index, ", k] <- inprod(", info$parname,
         "_Bh0[], Bsh0[15 * (", index, " - 1) + k, ])", "\n",
         tab(6), "Surv[", index, ", k] <- ",
         add_linebreaks(Surv_predictor, indent = 20), "\n",
         tab(4), "}", "\n\n",
         tab(4), "log.surv[", index, "] <- -exp(eta_surv[", index,
         "]) * ", survtime_col, "/2 * sum(Surv[", index, ", ])", "\n",
         tab(4), "phi_", info$varname, "[", index, "] <- 5000 - ((",
         info$resp_mat[2] ,"[", index, ", ", info$resp_col[2], "] * logh[",
         index, "])) - (log.surv[", index, "])", "\n",
         tab(4), "zeros[", index, "] ~ dpois(phi_", info$varname,
         "[", index, "])", "\n",
         tab(), "}\n\n",
         paste0(sapply(names(rdintercept), write_ranefs, info = info,
                       rdintercept = rdintercept, rdslopes = rdslopes), collapse = ''), "\n",
         tab(), "# Priors for the coefficients in the model for ", info$varname, "\n",
         if (any(!sapply(info$lp, is.null))) {
           paste0(
             tab(), "for (k in ", min(unlist(info$parelmts)), ":",
             max(unlist(info$parelmts)), ") {", "\n",
             priordistr,
             tab(), "}", "\n\n")
         },
         tab(), "for (k in 1:", info$df_basehaz, ") {", "\n",
         tab(4), info$parname, "_Bh0[k] ~ dnorm(mu_reg_surv, tau_reg_surv)",
         "\n",
         tab(), "}", "\n",
         paste0(
           sapply(names(info$hc_list$hcvars), function(x) {
             ranef_priors(info$nranef[x], paste0(info$varname, "_", x))
           }), collapse = "\n")
  )
}


# Joint model ------------------------------------------------------------------
JAGSmodel_JM <- function(info) {
  # indent <- 4 + nchar(info$varname)

  Mc_predictor <- if (!is.null(info$lp$Mc)) {
    paste_linpred(parname = info$parname,
                  parelmts = info$parelmts$Mc,
                  matnam = "Mc",
                  index = info$index,
                  cols = info$lp$Mc,
                  scale_pars = info$scale_pars$Mc,
                  isgk = FALSE)
  } else {"0"}


  logh_pred <- paste(
    paste0("logh0[", info$index, "] + eta_surv[", info$index, "]"),
    paste_linpred_JM(parname = info$parname,
                     parelmts = info$parelmts$Ml,
                     matnam = "Ml",
                     index = info$index,
                     cols = info$lp$Ml,
                     scale_pars = info$scale_pars$Ml,
                     assoc_type = info$assoc_type,
                     covnames = info$covnames,
                     isgk = FALSE),
    sep = " + ")



  Surv_predictor <- paste0(
    "gkw[k] * exp(",
    paste(paste0("logh0s[", info$index, ", k]"),
          paste_linpred_JM(parname = info$parname,
                           parelmts = info$parelmts$Ml,
                           matnam = "Ml",
                           index = info$index,
                           cols = info$lp$Ml,
                           scale_pars = info$scale_pars$Ml,
                           assoc_type = info$assoc_type,
                           covnames = info$covnames,
                           isgk = TRUE),
          sep = " + "),
    ")"
  )

  if (info$shrinkage == 'ridge' && !is.null(info$shrinkage)) {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv_ridge[k])",
                         "\n",
                         tab(4), "tau_reg_surv_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    priordistr <- paste0(tab(4), info$parname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n")
  }

  paste0(tab(), add_dashes(paste0("# Cox PH model for ", info$varname)), "\n",
         tab(), "for (", info$index, " in 1:", info$N, ") {", "\n",
         tab(4), "logh0[", info$index, "] <- inprod(",
         info$parname, "_Bh0[], Bh0[", info$index, ", ])", "\n",
         tab(4), "eta_surv[", info$index, "] <- ",
         add_linebreaks(Mc_predictor, indent = 19), "\n",
         tab(4), "logh[", info$index, "] <- ",
         add_linebreaks(logh_pred, indent = 15),
         "\n\n",
         tab(4), "for (k in 1:15) {", "\n",
         tab(6), "logh0s[", info$index, ", k] <- inprod(", info$parname,
         "_Bh0[], Bsh0[15 * (", info$index, " - 1) + k, ])", "\n",
         tab(6), "Surv[", info$index, ", k] <- ",
         add_linebreaks(Surv_predictor, indent = 20),
         "\n\n",
         paste0(unlist(lapply(info$tv_vars, gkmodel_in_JM)), collapse = "\n\n"),
         tab(4), "}", "\n\n",
         tab(4), "log.surv[", info$index, "] <- -exp(eta_surv[",
         info$index, "]) * ", info$resp_mat[1] ,"[survrow[", info$index, "], ",
         info$resp_col[1], "]/2 * sum(Surv[", info$index, ", ])", "\n",
         tab(4), "phi_", info$varname, "[", info$index, "] <- 5000 - ((",
         info$resp_mat[2] ,"[", info$index, ", ", info$resp_col[2], "] * logh[",
         info$index, "])) - (log.surv[", info$index, "])", "\n",
         tab(4), "zeros[", info$index, "] ~ dpois(phi_", info$varname,
         "[", info$index, "])", "\n",
         tab(), "}\n\n",
         tab(), "# Priors for the coefficients in the model for ", info$varname, "\n",
         if (!is.null(info$lp$Mc)) {
           paste0(
             tab(), "for (k in ", min(info$parelmts$Mc, info$parelmts$Ml), ":",
             max(info$parelmts$Mc, info$parelmts$Ml), ") {", "\n",
             priordistr,
             tab(), "}", "\n\n")
         },
         tab(), "for (k in 1:", info$df_basehaz, ") {", "\n",
         tab(4), info$parname, "_Bh0[k] ~ dnorm(mu_reg_surv, tau_reg_surv)",
         "\n",
         tab(), "}"
  )
}

gkmodel_in_JM <- function(info) {
  switch(info$modeltype,
         'glmm' = glmm_in_JM(info),
         'clmm' = clmm_in_JM(info))
}
