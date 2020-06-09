# parametric survival model ---------------------------------------------------
JAGSmodel_survreg <- function(info) {
  indent <- 4 + 9 + nchar(info$varname) + 8
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



  paste_ppc <- if (info$ppc) {
    paste0(
      tab(4), info$varname, "_ppc[", index, "] ~ dgen.gamma(1, rate_",
      info$varname, "[", index, "], shape_", info$vaname, ")", "\n",
      tab(4), "mu_", info$varname, "[", index, "] <- 1/rate_", info$varname,
      "[", index, "] * exp(loggam(1 + 1/shape_", info$varname, "))", "\n"
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


  paste0(tab(2), add_dashes(paste0("# Weibull survival model for ", info$varname)), "\n",
         tab(), "for (", index, " in 1:", N, ") {", "\n",
         tab(4), info$varname, "[", index,
         "] ~ dgen.gamma(1, rate_", info$varname, "[", index,
         "], shape_", info$varname, ")", "\n",
         paste_ppc,
         tab(4), "cens_", info$varname, "[", index, "] ~ dinterval(", info$varname, "[",
         index, "], ", info$resp_mat[1], "[", index, ", ", info$resp_col[1],
         "])", "\n",
         tab(4), "log(rate_", info$varname, "[", index, "]) <- -1 * (",
         add_linebreaks(eta, indent = 20), ")", "\n",
         tab(), "}\n\n",
         tab(), "# Priors for the model for ", info$varname, "\n",
         if (any(!sapply(info$lp, is.null))) {
           paste0(
             tab(), "for (k in ", min(unlist(info$parelmts)), ":",
             max(unlist(info$parelmts)), ") {", "\n",
             get_priordistr(info$shrinkage, type = 'surv', parname = info$parname),
             tab(), "}", "\n\n")
         },
         tab(), "shape_", info$varname ," ~ dexp(0.01)", "\n",
         paste_ppc_prior
  )
}


# Cox PH model ----------------------------------------------------------------
JAGSmodel_coxph <- function(info) {

  index <- info$index[gsub("M_", "", info$resp_mat[2])]
  N <- info$N[gsub("M_", "", info$resp_mat[2])]

  indent <- 4 + 10 + 4 + nchar(index)

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
    c(paste0("logh0_", info$varname, "[", index, "] + eta_surv_", info$varname, "[", index, "]"),
    if (info$resp_mat[2] != 'M_levelone') {
      paste_linpred_JM(varname = info$varname,
                       parname = info$parname,
                       parelmts = info$parelmts[['M_levelone']],
                       matnam = "M_levelone",
                       index = index,
                       cols = info$lp[['M_levelone']],
                       scale_pars = info$scale_pars[['M_levelone']],
                       assoc_type = info$assoc_type,
                       covnames = vector(mode = "list", length = length(info$lp[['M_levelone']])),
                       isgk = FALSE)
      }), collapse = " + ")

  Surv_predictor <- paste0(
    paste0(
      c(paste0("gkw[k] * exp(logh0s_", info$varname, "[", index, ", k]"),
        if (info$resp_mat[2] != 'M_levelone') {
          paste_linpred_JM(varname = info$varname,
                           parname = info$parname,
                           parelmts = info$parelmts[['M_levelone']],
                           matnam = "M_levelone",
                           index = index,
                           cols = info$lp[['M_levelone']],
                           scale_pars = info$scale_pars[['M_levelone']],
                           assoc_type = info$assoc_type,
                           covnames = vector(mode = "list", length = length(info$lp[['M_levelone']])),
                           isgk = TRUE)
        }
      ), collapse = " + "),
    ")"
  )


  survtime_col <- paste0(info$resp_mat[1] , "[",
                         if (info$resp_mat[1] != info$resp_mat[2]) {
                           paste0("survrow_", info$varname, "[", index, "]")
                         } else {
                           index
                         }, ", ", info$resp_col[1], "]")



  paste0(tab(), add_dashes(paste0("# Cox PH model for ", info$varname)), "\n",
         tab(), "for (", index, " in 1:", N, ") {", "\n",
         tab(4), "logh0_", info$varname, "[", index, "] <- inprod(",
         info$parname, "_Bh0_", info$varname, "[], Bh0_", info$varname, "[", index, ", ])", "\n",
         tab(4), "eta_surv_", info$varname, "[", index, "] <- ",
         add_linebreaks(eta, indent = 18 + nchar(index)), "\n",
         tab(4), "logh_", info$varname, "[", index, "] <- ",
         add_linebreaks(logh_pred, indent = 14 + nchar(index)),
         "\n\n",
         tab(4), "for (k in 1:15) {", "\n",
         tab(6), "logh0s_", info$varname, "[", index, ", k] <- inprod(", info$parname,
         "_Bh0_", info$varname, "[], Bsh0_", info$varname, "[15 * (", index, " - 1) + k, ])", "\n",
         tab(6), "Surv_", info$varname, "[", index, ", k] <- ",
         add_linebreaks(Surv_predictor, indent = 20), "\n",
         tab(4), "}", "\n\n",
         tab(4), "log.surv_", info$varname, "[", index, "] <- -exp(eta_surv_", info$varname, "[", index,
         "]) * ", survtime_col, "/2 * sum(Surv_", info$varname, "[", index, ", ])", "\n",
         tab(4), "phi_", info$varname, "[", index, "] <- 5000 - ((",
         info$resp_mat[2] ,"[", index, ", ", info$resp_col[2], "] * logh_", info$varname, "[",
         index, "])) - (log.surv_", info$varname, "[", index, "])", "\n",
         tab(4), "zeros_", info$varname, "[", index, "] ~ dpois(phi_", info$varname,
         "[", index, "])", "\n",
         tab(), "}\n\n",
         paste0(sapply(names(rdintercept), write_ranefs, info = info,
                       rdintercept = rdintercept, rdslopes = rdslopes), collapse = ''), "\n",
         tab(), "# Priors for the coefficients in the model for ", info$varname, "\n",
         if (any(!sapply(info$lp, is.null))) {
           paste0(
             tab(), "for (k in ", min(unlist(info$parelmts)), ":",
             max(unlist(info$parelmts)), ") {", "\n",
             get_priordistr(info$shrinkage, type = 'surv', parname = info$parname),
             tab(), "}", "\n\n")
         },
         tab(), "for (k in 1:", info$df_basehaz, ") {", "\n",
         tab(4), info$parname, "_Bh0_", info$varname, "[k] ~ dnorm(mu_reg_surv, tau_reg_surv)",
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

  index <- info$index[gsub("M_", "", info$resp_mat[2])]
  indent <- 4 + 10 + 4 + nchar(index)
  N <- info$N[gsub("M_", "", info$resp_mat[2])]


  rdintercept <- paste_rdintercept_lp(info)
  rdslopes <- paste_rdslope_lp(info)
  Z_predictor <- paste_lp_Zpart(info)

  eta <- if (!is.null(Z_predictor)) {
    paste0(Z_predictor, collapse = " + ")
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
    c(paste0("logh0_", info$varname, "[", index, "] + eta_surv_", info$varname, "[", index, "]"),
      if (info$resp_mat[2] != 'M_levelone') {
        paste_linpred_JM(varname = info$varname,
                         parname = info$parname,
                         parelmts = info$parelmts[['M_levelone']],
                         matnam = "M_levelone",
                         index = index,
                         cols = info$lp[['M_levelone']],
                         scale_pars = info$scale_pars[['M_levelone']],
                         assoc_type = info$assoc_type,
                         covnames = names(info$lp[['M_levelone']]),
                         #vector(mode = "list", length = length(info$lp[['M_levelone']])),
                         isgk = FALSE)
      }), collapse = " + ")

  Surv_predictor <- paste0(
    paste0(
      c(paste0("gkw[k] * exp(logh0s_", info$varname, "[", index, ", k]"),
        if (info$resp_mat[2] != 'M_levelone') {
          paste_linpred_JM(varname = info$varname,
                           parname = info$parname,
                           parelmts = info$parelmts[['M_levelone']],
                           matnam = "M_levelone",
                           index = index,
                           cols = info$lp[['M_levelone']],
                           scale_pars = info$scale_pars[['M_levelone']],
                           assoc_type = info$assoc_type,
                           covnames = names(info$lp[['M_levelone']]), #vector(mode = "list", length = length(info$lp[['M_levelone']])),
                           isgk = TRUE)
        }
      ), collapse = " + "),
    ")"
  )


  survtime_col <- paste0(info$resp_mat[1] , "[",
                         if (info$resp_mat[1] != info$resp_mat[2]) {
                           paste0("survrow_", info$varname, "[", index, "]")
                         } else {
                           index
                         }, ", ", info$resp_col[1], "]")


  # Mc_predictor <- if (!is.null(info$lp$Mc)) {
  #   paste_linpred(parname = info$parname,
  #                 parelmts = info$parelmts$Mc,
  #                 matnam = "Mc",
  #                 index = info$index,
  #                 cols = info$lp$Mc,
  #                 scale_pars = info$scale_pars$Mc,
  #                 isgk = FALSE)
  # } else {"0"}
  #
  #
  # logh_pred <- paste(
  #   paste0("logh0[", info$index, "] + eta_surv[", info$index, "]"),
  #   paste_linpred_JM(parname = info$parname,
  #                    parelmts = info$parelmts$Ml,
  #                    matnam = "Ml",
  #                    index = info$index,
  #                    cols = info$lp$Ml,
  #                    scale_pars = info$scale_pars$Ml,
  #                    assoc_type = info$assoc_type,
  #                    covnames = info$covnames,
  #                    isgk = FALSE),
  #   sep = " + ")
  #
  #
  #
  # Surv_predictor <- paste0(
  #   "gkw[k] * exp(",
  #   paste(paste0("logh0s[", info$index, ", k]"),
  #         paste_linpred_JM(parname = info$parname,
  #                          parelmts = info$parelmts$Ml,
  #                          matnam = "Ml",
  #                          index = info$index,
  #                          cols = info$lp$Ml,
  #                          scale_pars = info$scale_pars$Ml,
  #                          assoc_type = info$assoc_type,
  #                          covnames = info$covnames,
  #                          isgk = TRUE),
  #         sep = " + "),
  #   ")"
  # )


  paste0(tab(), add_dashes(paste0("# Cox PH model for ", info$varname)), "\n",
         tab(), "for (", index, " in 1:", N, ") {", "\n",
         tab(4), "logh0_", info$varname, "[", index, "] <- inprod(",
         info$parname, "_Bh0_", info$varname, "[], Bh0_", info$varname, "[", index, ", ])", "\n",
         tab(4), "eta_surv_", info$varname, "[", index, "] <- ",
         add_linebreaks(eta, indent = 18 + nchar(index)), "\n",
         tab(4), "logh_", info$varname, "[", index, "] <- ",
         add_linebreaks(logh_pred, indent = 14 + nchar(index)),
         "\n\n",
         tab(4), "for (k in 1:15) {", "\n",
         tab(6), "logh0s_", info$varname, "[", index, ", k] <- inprod(", info$parname,
         "_Bh0_", info$varname, "[], Bsh0_", info$varname, "[15 * (", index, " - 1) + k, ])", "\n",
         tab(6), "Surv_", info$varname, "[", index, ", k] <- ",
         add_linebreaks(Surv_predictor, indent = 6 + 5 + 8 + nchar(index)),
         "\n\n",
         paste0(unlist(lapply(info$tv_vars, gkmodel_in_JM, index = index)), collapse = "\n"),
         tab(4), "}", "\n\n",
         tab(4), "log.surv_", info$varname, "[", index, "] <- -exp(eta_surv_", info$varname, "[",
         index, "]) * ", info$resp_mat[1] ,"[", index, ", ",
         info$resp_col[1], "]/2 * sum(Surv_", info$varname, "[", index, ", ])", "\n",
         tab(4), "phi_", info$varname, "[", index, "] <- 5000 - ((",
         info$resp_mat[2] ,"[", index, ", ", info$resp_col[2], "] * logh_", info$varname, "[",
         index, "])) - (log.surv_", info$varname, "[", index, "])", "\n",
         tab(4), "zeros_", info$varname, "[", index, "] ~ dpois(phi_", info$varname,
         "[", index, "])", "\n",
         tab(), "}\n\n",
         paste0(sapply(names(rdintercept), write_ranefs, info = info,
                       rdintercept = rdintercept, rdslopes = rdslopes), collapse = ''), "\n",
         tab(), "# Priors for the coefficients in the model for ", info$varname, "\n",
         if (any(!sapply(info$lp, is.null))) {
           paste0(
             tab(), "for (k in ", min(unlist(info$parelmts)), ":",
             max(unlist(info$parelmts)), ") {", "\n",
             get_priordistr(info$shrinkage, type = 'surv', parname = info$parname),
             tab(), "}", "\n\n")
         },
         tab(), "for (k in 1:", info$df_basehaz, ") {", "\n",
         tab(4), info$parname, "_Bh0_", info$varname,
         "[k] ~ dnorm(mu_reg_surv, tau_reg_surv)", "\n",
         tab(), "}", "\n",
         paste0(
           sapply(names(info$hc_list$hcvars), function(x) {
             ranef_priors(info$nranef[x], paste0(info$varname, "_", x))
           }), collapse = "\n")
  )

}

gkmodel_in_JM <- function(info, index) {
  switch(info$modeltype,
         'glmm' = glmm_in_JM(info),
         'clmm' = clmm_in_JM(info))
}
