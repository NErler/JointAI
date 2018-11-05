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
glme_model <- function(family, link, N, y_name, Z = NULL, Xic = NULL, Xl = NULL,
                      Xil = NULL, hc_list = NULL, Mlist = NULL, K, ...){

  distr <- switch(family,
                  "gaussian" = function(y_name) {
                    paste0("dnorm(mu_", y_name, "[j], tau_", y_name, ")")
                  },
                  "binomial" =  function(y_name) {
                    paste0("dbern(mu_", y_name, "[j])")
                  },
                  "Gamma" =  function(y_name) {
                    paste0("dgamma(shape_", y_name, "[j], rate_", y_name, "[j])")
                  },
                  "poisson" = function(y_name) {
                    paste0("dpois(mu_", y_name, "[j])")
                  }
  )

  repar <- switch(family,
                  "gaussian" = NULL,
                  "binomial" = NULL,
                  "Gamma" = paste0(tab(), "shape_", y_name, "[j] <- pow(mu_", y_name,
                                   "[j], 2) / pow(sigma_", y_name, ", 2)",
                                   "\n",
                                   tab(), "rate_", y_name, "[j]  <- mu_", y_name,
                                   "[j] / pow(sigma_", y_name, ", 2)", "\n"),
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



  paste0(tab(), "# Generalized linear mixed effects model for ", y_name, "\n",
         tab(), y_name, "[j] ~ ", distr(y_name), "\n",
         repar,
         tab(), linkfun(paste0("mu_", y_name, "[j]")), " <- inprod(Z[j, ], b[groups[j], ])",
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
glme_priors <- function(family, K, y_name, Z = NULL, Mlist = NULL, ...){

  secndpar <- switch(family,
                     "gaussian" = paste0("\n",
                                         tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
                                         tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")"),
                     "binomial" = NULL,
                     "Gamma" = paste0("\n",
                                      tab(), "tau_", y_name ," ~ dgamma(a_tau_main, b_tau_main)", "\n",
                                      tab(), "sigma_", y_name," <- sqrt(1/tau_", y_name, ")"),
                     "Poisson" = NULL)



  if (is.null(Z) & !is.null(Mlist)) {
    Z <- Mlist$Z
  }
  paste0(c(ranef_priors(Z),
           secndpar,
           glmereg_priors(K, y_name)), collapse = "\n\n")
}


glmereg_priors <- function(K, y_name){
  paste0(
    tab(), "# Priors for the coefficients in the analysis model", "\n",
    tab(), "for (k in 1:", max(K, na.rm = TRUE), ") {", "\n",
    tab(4), "beta[k] ~ dnorm(mu_reg_main, tau_reg_main)", "\n",
    tab(), "}",  "\n\n")
}



