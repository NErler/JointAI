#' Function to build JAGS model
#' @param type analysis model type (character string)
#' @param meth named vector specifying imputation methods and ordering
#' @param Ntot number of observations
#' @param N number of individuals
#' @param y_name name of outcome variable
#' @param Mlist list of design matrices
#' @param Z random effects design matrix
#' @param Xic design matrix of time-constant interactions
#' @param Xl design matrix of time-varying covariates
#' @param Xil design matrix of interactions involving time-varying covariates
#' @param hc_list list specifying hierarchical centring structure
#' @param K matrix specifying range of regression coefficients used for each
#' component of the analysis model
#' @export
build_JAGS <- function(type, meth = NULL, Ntot, N, y_name,  Mlist = NULL,
                        Z = NULL, Xic = NULL, Xl = NULL, Xil = NULL,
                        hc_list = NULL, K, imp_par_list, imp_interact_list, ...) {
  arglist <- as.list(match.call())[-1]

  analysis_model <- switch(type,
                           "lme" = lme_model,
                           "lm" = lm_model)
  analysis_priors <- switch(type,
                            "lme" = lme_priors,
                            "lm" = lm_priors)

  Xic <- Mlist$Xic

  interactions <- if (!is.null(Xic)) {
    splitnam <- sapply(colnames(Xic)[apply(is.na(Xic), 2, any)],
                       strsplit, split = ":")
    Xc_pos <- sapply(splitnam, match, colnames(Mlist$Xc))
    Xic_pos <- match(colnames(Xic)[apply(is.na(Xic), 2, any)], colnames(Xic))

    paste0(
      tab(), "# -------------------------------------------- #", "\n",
      tab(), "# Interactions involving incomplete covariates #", "\n",
      tab(), "# -------------------------------------------- #", "\n\n",
      tab(), "for (i in 1:", N, ") {", "\n",
      paste0(paste_interactions(index = "i", mat0 = "Xic", mat1 = "Xc",
                                mat2 = "Xc", mat0_col = Xic_pos,
                                mat1_col = Xc_pos[1, ], mat2_col = Xc_pos[2, ]),
             collapse = "\n"), "\n",
      tab(), "}", "\n")
  }

  imputation_part <- if (!is.null(meth)) {
    paste0(
      tab(), "# ----------------- #", "\n",
      tab(), "# Imputation models #", "\n",
      tab(), "# ----------------- #", "\n\n",
      tab(), "for (i in 1:", N, ") {", "\n",
      paste0(sapply(imp_par_list, paste_imp_model), collapse = "\n"),
      tab(), "}", "\n\n",
      tab(), "# -------------------------------- #", "\n",
      tab(), "# Priors for the imputation models #", "\n",
      tab(), "# -------------------------------- #", "\n\n",
      paste0(sapply(imp_par_list, paste_imp_priors), collapse = "\n")
    )
  }


  paste0(
    "model {", "\n",
    tab(), "# -------------- #", "\n",
    tab(), "# Analysis model #", "\n",
    tab(), "# -------------- #", "\n\n",
    tab(), "for (j in 1:", Ntot,") {", "\n",
    paste0(do.call(analysis_model, arglist), collapse = "\n"), "\n",
    tab(), "}", "\n\n\n",
    tab(), "# ----------------------------- #", "\n",
    tab(), "# Priors for the analysis model #", "\n",
    tab(), "# ----------------------------- #", "\n\n",
    paste0(do.call(analysis_priors, arglist), collapse = "\n"),
    "\n\n",
    imputation_part, "\n\n",
    interactions, "\n",
    "}"
  )
}







