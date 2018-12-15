impmodel_continuous <- function(impmeth, varname, dest_col, dest_mat, trafo_cols, trafos,
                                trfo_fct, Xc_cols, par_elmts, par_name, trunc, ppc,
                                mess = TRUE, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  indent <- nchar(varname) + 14
  predictor <-  paste_predictor(parnam = par_name, parindex = 'i', matnam = 'Xc',
                                parelmts = par_elmts,
                                cols = Xc_cols, indent = indent)


  trfs <- if (dest_mat != "Xc") {
    c(paste_trafos(dest_col, trafo_cols, trafos = trfo_fct), "\n")
  }

  trunc <- if (!is.null(trunc)) paste0("T(", paste(trunc, collapse = ", "), ")")


  if (impmeth == 'norm') {
    type_spec <- c(title = "Normal",
                   model = paste0("dnorm(mu_", varname, "[i], tau_", varname,")", trunc, "\n",
                                  tab(4), "mu_", varname,"[i] <- ", predictor)
    )
  } else if (impmeth == 'lognorm') {
    type_spec = c(title = "Log-normal",
                  model = paste0("dlnorm(mu_", varname, "[i], tau_", varname,")", "\n",
                                 tab(4), "mu_", varname,"[i] <- ", predictor)
    )
  } else if (impmeth == 'beta') {
    type_spec = c(title = "Beta",
                  model = paste0("dbeta(shape1_", varname, "[i], shape2_",
                                 varname, "[i])T(1e-15, 1 - 1e-15)", "\n",
                                 tab(4), "logit(mu_", varname,"[i]) <- ", predictor, "\n",
                                 tab(4), "shape1_", varname,"[i] <- mu_",
                                 varname, "[i] * tau_", varname, "\n",
                                 tab(4), "shape2_", varname, "[i] <- (1 - mu_",
                                 varname, "[i]) * tau_", varname)
    )
  } else if (impmeth == 'gamma') {
    type_spec = c(title = 'Gamma',
                  model = paste0("dgamma(shape_", varname, "[i], rate_", varname, "[i])", "\n",
                                 tab(4), "log(mu_", varname,"[i]) <- ", predictor, "\n",
                                 tab(4), "shape_", varname,"[i] <- pow(mu_",
                                 varname, "[i], 2) / pow(sigma_", varname, ", 2)", "\n",
                                 tab(4), "rate_", varname, "[i] <- mu_",
                                 varname, "[i] / pow(sigma_", varname, ", 2)"

                  )
    )
  }

  paste_ppc <- if (ppc) {
    if (impmeth == 'norm') {
      paste0(
        tab(4), varname, "_ppc[i] ~ dnorm(mu_", varname, "[i], tau_", varname,")", trunc, "\n"
      )
    } else if (impmeth == 'lognorm') {
      paste0(
        tab(4), varname, "_ppc[i] ~ dlnorm(mu_", varname, "[i], tau_", varname,")", "\n"
      )
    } else if (impmeth == 'beta') {
      paste0(
        tab(4),  varname, "_ppc[i]] ~ dbeta(shape1_", varname, "[i], shape2_",
        varname, "[i])T(1e-15, 1 - 1e-15)", "\n"
      )
    } else if (impmeth == 'gamma') {
      paste0(
        tab(4), varname, "_ppc[i] ~ dgamma(shape_", varname, "[i], rate_", varname, "[i])", "\n"
      )
    }
  }

  paste0(tab(4), "# ", type_spec['title'], " model for ", varname, "\n",
         tab(4), dest_mat, "[i, ", dest_col, "] ~ ", type_spec['model'], "\n\n",
         paste_ppc,
         paste0(trfs, collapse = "\n"))
}


# Priors for continuous imputation model
impprior_continuous <- function(impmeth, varname, par_elmts, par_name, ppc, dest_mat, dest_col, ...){

  paste_ppc <- if (ppc) {
    paste0('\n',
           tab(), '# Posterior predictive check for the model for ', varname, '\n',
           tab(), 'ppc_', varname, "_o <- pow(", dest_mat, "[,", dest_col, "] - mu_", varname, "[], 2)", "\n",
           tab(), 'ppc_', varname, "_e <- pow(", varname, "_ppc[] - mu_", varname, "[], 2)", "\n",
           tab(), 'ppc_', varname, " <- mean(step(ppc_", varname, "_o - ppc_", varname, "_e))", "\n"
    )
  }


  paste0('\n',
         tab(), "# Priors for ", varname, "\n",
         tab(), "for (k in ", min(par_elmts), ":", max(par_elmts), ") {", "\n",
         tab(4), par_name, "[k] ~ dnorm(mu_reg_", impmeth, ", tau_reg_", impmeth, ")", "\n",
         tab(), "}", "\n",
         tab(), "tau_", varname,  " ~ dgamma(a_tau_", impmeth, ", b_tau_", impmeth, ")", "\n",
         tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")", "\n",
         paste_ppc
  )
}
