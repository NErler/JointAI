# Function to build JAGS model
# @param analysis_type analysis model type (character string)
# @param family model family
# @param link link function
# @param meth named vector specifying imputation methods and ordering
# @param Ntot number of observations
# @param N number of individuals
# @param y_name name of outcome variable
# @param Mlist list of design matrices
# @param Z random effects design matrix
# @param Xic design matrix of time-constant interactions
# @param Xl design matrix of time-varying covariates
# @param Xil design matrix of interactions involving time-varying covariates
# @param hc_list list specifying hierarchical centring structure
# @param K matrix specifying range of regression coefficients used for each
# component of the analysis model
# @param imp_par_list output from get_imp_par_list
# @export
build_JAGS <- function(analysis_type, family = NULL, link = NULL, models = NULL,
                       Ntot, Mlist = NULL, K, imp_par_list, ...) {
  arglist <- as.list(match.call())[-1]

  analysis_model <- switch(analysis_type,
                           "lme" = lme_model,
                           "glme" = glme_model,
                           "clmm" = clmm_model,
                           "lm" = lm_model,
                           "glm" = glm_model,
                           "clm" = clm_model,
                           "survreg" = survreg_model,
                           "coxph" = coxph_model)
  analysis_priors <- switch(analysis_type,
                            "lme" = lme_priors,
                            "glme" = glme_priors,
                            "clmm" = clmm_priors,
                            "glm" = glm_priors,
                            "clm" = clm_priors,
                            "lm" = lm_priors,
                            "survreg" = survreg_priors,
                            "coxph" = coxph_priors)


  # Interactions within cross-sectional variables inlcuding missing values
  Xic <- Mlist$Xic

  interactions <- if (!is.null(Xic)) {
    #if (any(is.na(Xic))) {
      splitnam <- sapply(colnames(Xic)[apply(is.na(Xic), 2, any)],
                         strsplit, split = ":")
      Xc_pos <- lapply(splitnam, match, colnames(Mlist$Xc))
      Xic_pos <- match(colnames(Xic)[apply(is.na(Xic), 2, any)], colnames(Xic))
      #  the above line may be too complicated (left over from previous version)

      paste0('\n\n',
        tab(), "# ------------------------------------------------------ #", "\n",
        tab(), "# Interactions involving only cross-sectional covariates #", "\n",
        tab(), "# ------------------------------------------------------ #", "\n\n",
        tab(), "for (i in 1:", Mlist$N, ") {", "\n",
        paste0(paste_interactions(index = "i", mat0 = "Xic", mat1 = "Xc",
                                  mat0_col = Xic_pos, mat1_col = Xc_pos),
               collapse = "\n"), "\n",
        tab(), "}", "\n")
    # }
  }

  # Interactions within longitudinal variables
  Xil <- Mlist$Xil

  interactions_long <- if (!is.null(Xil)) {
    splitnam <- sapply(colnames(Xil)[apply(is.na(Xil), 2, any)],
                       strsplit, split = ":")
    Xc_pos <- lapply(splitnam, match, colnames(Mlist$Xc))
    Xl_pos <- lapply(splitnam, match, colnames(Mlist$Xl))
    Xil_pos <- match(names(splitnam), colnames(Xil))
    Z_pos <- lapply(splitnam, match, colnames(Mlist$Z))

    mat1 <- sapply(names(splitnam), function(x) {
      a <- vector("character", length(splitnam[[x]]))
      a[which(!is.na(Xc_pos[[x]]))] <- "Xc"
      a[which(!is.na(Xl_pos[[x]]))] <- "Xl"
      a[which(!is.na(Z_pos[[x]]))] <- 'Z'
      a
    }, simplify = FALSE)
    mat1_col <- sapply(names(splitnam), function(x) {
      a <- vector("numeric", length(splitnam[[x]]))
      a[which(!is.na(Xc_pos[[x]]))] <- Xc_pos[[x]][which(!is.na(Xc_pos[[x]]))]
      a[which(!is.na(Xl_pos[[x]]))] <- Xl_pos[[x]][which(!is.na(Xl_pos[[x]]))]
      a[which(!is.na(Z_pos[[x]]))] <- Z_pos[[x]][which(!is.na(Z_pos[[x]]))]
      a
    }, simplify = FALSE)

    paste0('\n\n',
      tab(), "# ---------------------------------------------- #", "\n",
      tab(), "# Interactions involving longitudinal covariates #", "\n",
      tab(), "# ---------------------------------------------- #", "\n\n",
      tab(), "for (j in 1:", Ntot, ") {", "\n",
      paste0(paste_long_interactions(index = "j", mat0 = "Xil", mat1 = mat1,
                                mat0_col = Xil_pos, mat1_col = mat1_col),
             collapse = "\n"), "\n",
      tab(), "}", "\n")
    # }
  }

  # imputation section of the model

  imputation_part <- if (!is.null(meth)) {
    paste0('\n\n',
      tab(), "# ----------------- #", "\n",
      tab(), "# Imputation models #", "\n",
      tab(), "# ----------------- #", "\n\n",
      tab(), "for (i in 1:", Mlist$N, ") {", "\n",
      paste0(sapply(imp_par_list, paste_imp_model), collapse = "\n"),
      tab(), "}", "\n\n",
      tab(), "# -------------------------------- #", "\n",
      tab(), "# Priors for the imputation models #", "\n",
      tab(), "# -------------------------------- #", "\n",
      paste0(sapply(imp_par_list, paste_imp_priors), collapse = "\n")
    )
  }



  # Analysis part and insert the rest
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
    imputation_part, "\n",
    interactions,
    interactions_long,
    "}"
  )
}







