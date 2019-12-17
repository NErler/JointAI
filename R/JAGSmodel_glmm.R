

JAGSmodel_glmm <- function(info) {
  distr <- switch(info$family,
                  "gaussian" = paste0("dnorm(mu_", info$varname, "[", info$index, "], tau_", info$varname, ")"),
                  "lognorm" = paste0("dlnorm(mu_", info$varname, "[", info$index, "], tau_", info$varname, ")"),
                  "binomial" = paste0("dbern(mu_", info$varname, "[", info$index, "])"),
                  "Gamma" = paste0("dgamma(shape_", info$varname, "[", info$index,
                                   "], rate_", info$varname, "[", info$index, "])"),
                  "poisson" = paste0("dpois(mu_", info$varname, "[", info$index, "])")
  )


  linkfun <- switch(info$link,
                    "identity" = function(x) x,
                    "logit"    = function(x) paste0("logit(", x, ")"),
                    "probit"   = function(x) paste0("probit(", x, ")"),
                    "log"      = function(x) paste0("log(", x, ")"),
                    "cloglog"  = function(x) paste0("cloglog(", x, ")"),
                    # "sqrt"     = function(x) paste0("sqrt(", x, ")"),
                    "inverse"  = function(x) paste0("1/", x)
  )

  indent <- switch(info$link,
                   'identity' = 4 + 0 + 3 + nchar(info$varname) + 7,
                   'logit'    = 4 + 7 + 3 + nchar(info$varname) + 7,
                   'probit'   = 4 + 8 + 3 + nchar(info$varname) + 7,
                   'log'      = 4 + 5 + 3 + nchar(info$varname) + 7,
                   'cloglog'  = 4 + 9 + 3 + nchar(info$varname) + 7,
                   'inverse'  = 4 + 9 + 3 + nchar(info$varname) + 7)



  repar <- switch(info$family,
                  "gaussian" = NULL,
                  "lognorm" = NULL,
                  "binomial" = NULL,
                  "Gamma" = paste0(tab(), "shape_", info$varname, "[", info$index, "] <- pow(mu_", info$varname,
                                   "[", info$index, "], 2) / pow(sigma_", info$varname, ", 2)",
                                   "\n",
                                   tab(), "rate_", info$varname, "[", info$index, "]  <- mu_", info$varname,
                                   "[", info$index, "] / pow(sigma_", info$varname, ", 2)", "\n"),
                  "Poisson" = NULL)


  rd_predictor <- get_ranefpreds(info)

  norm.distr  <- if (length(info$hc_list) < 2) {"dnorm"} else {"dmnorm"}

  paste_ppc <- if (info$ppc) {
    paste0("\n",
           tab(4), "# For posterior predictive check:", "\n",
           tab(4), info$varname, "_ppc[", info$index, "] ~ ", distr(info$varname), "\n"
    )
  }


  # trfs <- if (dest_mat == "Xltrafo" & length(trfo_fct) > 0) {
  #   c("\n",
  #     mapply(paste_trafos, trafo_cols = trafo_cols, trafos = trfo_fct,
  #            Xmat = lapply(trafo_cols, names),
  #            MoreArgs = list(dest_col = dest_col, index = 'j')), "\n"
  #   )
  # }

  paste0(tab(), "# Generalized linear mixed effects model for ", info$varname, "\n",
         tab(), "for (", info$index, " in 1:", info$Ntot, ") {", "\n",
         tab(4), info$resp_mat, "[", info$index, ", ", info$resp_col, "] ~ ",
         distr, "\n",
         repar,
         tab(4), linkfun(paste0("mu_", info$varname, "[", info$index, "]")), " <- ",
         paste0(c(rd_predictor$Z_predictor, rd_predictor$Ml_predictor), collapse = " +\n"),
         "\n",
         paste_ppc,
         # paste0(trfs, collapse = "\n"),
         "\n",
         tab(), "}", "\n",
         "\n",
         tab(), "for (i in 1:", info$N, ") {", "\n",
         tab(4), "b_", info$varname, "[i, 1:", info$nranef, "] ~ ", norm.distr,
         "(mu_b_", info$varname, "[i, ], invD_", info$varname, "[ , ])", "\n",
         rd_predictor$ranefpreds, "\n",
         tab(), "}\n"
  )
}
