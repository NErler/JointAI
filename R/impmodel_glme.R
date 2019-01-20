

impmodel_glmm <- function(family, link, varname, dest_col, Xc_cols, Xl_cols,
                          par_elmts, ppc, nranef, N, Ntot, hc_list, ...) {
  distr <- switch(family,
                  "gaussian" = function(varname) {
                    paste0("dnorm(mu_", varname, "[j], tau_", varname, ")")
                  },
                  "binomial" =  function(varname) {
                    paste0("dbern(mu_", varname, "[j])")
                  },
                  "Gamma" =  function(varname) {
                    paste0("dgamma(shape_", varname, "[j], rate_", varname, "[j])")
                  },
                  "poisson" = function(varname) {
                    paste0("dpois(mu_", varname, "[j])")
                  }
  )

  repar <- switch(family,
                  "gaussian" = NULL,
                  "binomial" = NULL,
                  "Gamma" = paste0(tab(), "shape_", varname, "[j] <- pow(mu_", varname,
                                   "[j], 2) / pow(sigma_", varname, ", 2)",
                                   "\n",
                                   tab(), "rate_", varname, "[j]  <- mu_", varname,
                                   "[j] / pow(sigma_", varname, ", 2)", "\n"),
                  "Poisson" = NULL)


  linkfun <- switch(link,
                    "identity" = function(x) x,
                    "logit"    = function(x) paste0("logit(", x, ")"),
                    "probit"   = function(x) paste0("probit(", x, ")"),
                    "log"      = function(x) paste0("log(", x, ")"),
                    "cloglog"  = function(x) paste0("cloglog(", x, ")"),
                    # "sqrt"     = function(x) paste0("sqrt(", x, ")"),
                    "inverse"  = function(x) paste0("1/", x)
  )



  norm.distr  <- if (nranef < 2) {"dnorm"} else {"dmnorm"}

  # paste_Xic <- if (length(Mlist$cols_main$Xic) > 0) {
  #   paste0(" + \n", tab(nchar(varname) + 17),
  #          paste_predictor(parnam = 'alpha', parindex = 'i', matnam = 'Xic',
  #                          parelmts = K["Xic", 1]:K["Xic", 2],
  #                          cols = Mlist$cols_main$Xic, indent = 0))
  # }

  paste_Xl <- if (!is.null(Xl_cols)) {
    paste0(" + \n", tab(nchar(varname) + 14),
           paste_predictor(parnam = 'alpha', parindex = 'j', matnam = 'Xl',
                           parelmts = par_elmts["Xl", 1]:par_elmts["Xl", 2],
                           cols = Xl_cols, indent = 14)
    )
  }
  # rdslopes <- if (nranef > 1) {
  #   rd_slopes <- list()
  #   for (k in 2:nranef) {
  #
  #
  #     Xc_pos <- if (any(sapply(hc_list[[k - 1]], attr, "matrix") %in% c("Xc", 'Z'))) {
  #       hc_list[[k - 1]][which(sapply(hc_list[[k - 1]], attr, "matrix") %in% c("Z", "Xc"))]
  #     }
  #
  #     Znam <- names(hc_list)[sapply(hc_list, attr, 'matrix') == 'Z']
  #
  #     hc_interact <- if (!is.null(hc_list[[Znam[k - 1]]])) {
  #       paste0("alpha[", par_elmts['Z', 1]:par_elmts['Z', 2], "]",
  #              sapply(Xc_pos, function(x) {
  #                if (!is.na(x)) {
  #                  paste0(" * Xc[i, ", x, "]")
  #                } else {
  #                  ""
  #                }
  #              })
  #       )
  #     } else {
  #       "0"
  #     }
  #
  #     rd_slopes[[k - 1]] <- paste0(tab(4), "mu_b_", varname, "[i, ", k,"] <- ",
  #                                  paste0(hc_interact, sep = "", collapse = " + "))
  #   }
  #   paste(rd_slopes, collapse = "\n")
  # }






  paste_ppc <- if (ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), varname, "_ppc[j] ~ ", distr(varname), "\n"
    )
  }

  paste0(tab(), "# Generalized linear mixed effects model for ", varname, "\n",
         tab(), "for (j in 1:", Ntot, ") {", "\n",
         tab(4), "Xl[j, ", dest_col, "] ~ ", distr(varname), "\n",
         repar,
         tab(4), linkfun(paste0("mu_", varname, "[j]")), " <- inprod(Z[j, ], b_", varname, "[groups[j], ])",
         paste_Xl,
         # paste_Xil,
         "\n",
         paste_ppc,
         tab(), "}", "\n\n",
         tab(), "for (i in 1:", N, ") {", "\n",
         tab(4), "b_", varname, "[i, 1:", nranef, "] ~ ", norm.distr, "(mu_b_", varname, "[i, ], invD[ , ])", "\n",
         tab(4), "mu_b_", varname, "[i, 1] <- ",
         paste_predictor(parnam = 'alpha', parindex = 'i', matnam = 'Xc',
                         parelmts = par_elmts["Xc", 1]:par_elmts["Xc", 2],
                         cols = Xc_cols, indent = 19 + nchar(varname)), "\n",
         paste_rdslopes_covmod(nranef, hc_list, par_elmts, varname), "\n",
         tab(), "}\n"
         # paste_Xic,
         # "\n",
  )
}

paste_rdslopes_covmod <- function(nranef, hc_list, par_elmts, varname){
  if (nranef > 1) {
    rd_slopes <- list()
    for (k in 2:nranef) {
      if (any(sapply(hc_list[[k - 1]], attr, "matrix") %in% c("Xc", 'Z'))) {
        vec <- sapply(hc_list[[k - 1]], attr, "matrix")# == "Xc"

        Xc_pos <- lapply(seq_along(vec), function (i) {
          switch(vec[i], 'Xc' = attr(hc_list[[k - 1]][[i]], 'column'),
                 'Z' = NA,
                 'Xlong' = NULL)
        })

        hc_interact <- paste0("alpha[", par_elmts['Z', 1]:par_elmts['Z', 2], "]",
                              sapply(unlist(Xc_pos), function(x) {
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
      rd_slopes[[k - 1]] <- paste0(tab(4), "mu_b_", varname, "[i, ", k,"] <- ",
                                   paste0(hc_interact, sep = "", collapse = " + "))
    }
    paste(rd_slopes, collapse = "\n")
  }
}


impprior_glmm <- function(family, varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...){
  secndpar <- switch(family,
                     "gaussian" = paste0("\n",
                                         tab(), "tau_", varname ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
                                         tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")"),
                     "binomial" = NULL,
                     "Gamma" = paste0("\n",
                                      tab(), "tau_", varname ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
                                      tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")"),
                     "Poisson" = NULL)


  paste_ppc <- if (ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', varname, '\n',
           tab(), 'ppc_', varname, "_o <- pow(", dest_mat, "[,", dest_col, "] - mu_", varname, "[], 2)", "\n",
           tab(), 'ppc_', varname, "_e <- pow(", varname, "_ppc[] - mu_", varname, "[], 2)", "\n",
           tab(), 'ppc_', varname, " <- mean(ifelse(ppc_", varname, "_o > ppc_", varname, "_e, 1, 0) + ",
           "ifelse(ppc_", varname, "_o == ppc_", varname, "_e, 0.5, 0)) - 0.5", "\n"
    )
  }

  priors <- paste0(
    "\n",
    tab(), "# Priors for the model for ", varname, "\n",
    tab(), "for (k in ", min(par_elmts, na.rm = T), ":", max(par_elmts, na.rm = TRUE), ") {", "\n",
    tab(4), "alpha[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}")

  paste0(c(priors,
           secndpar,
           ranef_priors(nranef, varname),
           paste_ppc), collapse = "\n")
}



impmodel_lmm <- function(varname, dest_col, Xc_cols, Xl_cols, par_elmts,
                         ppc, nranef, N, Ntot, hc_list, ...) {
  impmodel_glmm(family = 'gaussian', link = 'identity', varname, dest_col,
                Xc_cols, Xl_cols, par_elmts, ppc, nranef, N, Ntot, hc_list, ...)
}

impmodel_glmm_logit <- function(varname, dest_col, Xc_cols, Xl_cols, par_elmts,
                                ppc, nranef, N, Ntot, hc_list, ...) {
  impmodel_glmm(family = 'binomial', link = 'logit', varname, dest_col,
                Xc_cols, Xl_cols, par_elmts, ppc, nranef, N, Ntot, hc_list, ...)
}

impmodel_glmm_gamma <- function(varname, dest_col, Xc_cols, Xl_cols, par_elmts,
                                ppc, nranef, N, Ntot, hc_list, ...) {
  impmodel_glmm(family = 'Gamma', link = 'log', varname, dest_col,
                Xc_cols, Xl_cols, par_elmts, ppc, nranef, N, Ntot, hc_list, ...)
}

impmodel_glmm_poisson <- function(varname, dest_col, Xc_cols, Xl_cols, par_elmts,
                                  ppc, nranef, N, Ntot, hc_list, ...) {
  impmodel_glmm(family = 'poisson', link = 'log', varname, dest_col,
                Xc_cols, Xl_cols, par_elmts, ppc, nranef, N, Ntot, hc_list, ...)
}

impprior_lmm <- function(varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...) {
  impprior_glmm(family = 'gaussian', varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...)
}

impprior_glmm_logit <- function(varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...) {
  impprior_glmm(family = 'binomial', varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...)
}

impprior_glmm_gamma <- function(varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...) {
  impprior_glmm(family = 'Gamma', varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...)
}

impprior_glmm_poisson <- function(varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...) {
  impprior_glmm(family = 'poisson', varname, par_elmts, dest_mat, dest_col, ppc, nranef, ...)
}
