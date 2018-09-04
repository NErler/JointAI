# Get parameters to follow
# @param meth imputation method
# @param analysis_type analysis model type
# @param y_name name of the outcome variable
# @param Zcols number of columns in random effects design matrix
# @param Xc matrix
# @param Xtrafo matrix
# @param Xcat matrix
# @param analysis_main logical
# @param analysis_random logical
# @param imp_pars logical
# @param betas logical
# @param tau_y logical
# @param sigma_y logical
# @param ranef logical
# @param invD logical
# @param D logical
# @param RinvD logical
# @param alphas logical
# @param tau_imp logical
# @param gamma_imp logical
# @param delta_imp logical
# @param shaperate_imp logical
# @param imps logical
# @export
get_params <- function(meth, analysis_type, family,
                       Xc, Xcat, Xtrafo, y_name = NULL, y = NULL, Zcols = NULL, Z = NULL,
                       imp_par_list = NULL,
                       analysis_main = TRUE,
                       analysis_random = FALSE,
                       imp_pars = FALSE,
                       imps = NULL,
                       betas = NULL, tau_y = NULL, sigma_y = NULL,
                       ranef = NULL, invD = NULL, D = NULL, RinvD = NULL,
                       alphas = NULL, tau_imp = NULL, gamma_imp = NULL,
                       delta_imp = NULL, other = NULL, ...){

  if (is.null(y_name)) {
    y_name <- names(y)
  }
  if (missing(family))
    family <- attr(analysis_type, "family")


  if (analysis_main) {
    if (is.null(betas)) betas <- TRUE
    if (!family %in% c("binomial", "poisson")) {
      if (is.null(tau_y)) tau_y <- TRUE
      if (is.null(sigma_y)) sigma_y <- TRUE
    }
    if (analysis_type == "lme") {
      if (is.null(Zcols))
        Zcols <- ncol(Z)
      if (is.null(D)) D <- TRUE
    }
  }

  if (analysis_random) {
    if (is.null(ranef)) ranef <- TRUE
    if (is.null(invD)) invD <- TRUE
    if (is.null(D)) D <- TRUE
    if (is.null(RinvD)) RinvD <- TRUE
  }

  if (imp_pars) {
    if (is.null(alphas)) alphas <- TRUE
    if (is.null(tau_imp)) tau_imp <- TRUE
    if (is.null(gamma_imp)) gamma_imp <- TRUE
    if (is.null(delta_imp)) delta_imp <- TRUE
  }

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))

  for (i in names(arglist)) {
    if (is.null(arglist[[i]]) & i != "other") assign(i, FALSE)
  }

  params <- c(if (betas) "beta",
              if (tau_y) paste0("tau_", y_name),
              if (sigma_y) paste0("sigma_", y_name),
              if (alphas) "alpha",
              if (tau_imp & any(meth %in% c("norm", "lognorm", "gamma", "beta"))) {
                paste0("tau_", names(meth)[meth %in% c("norm", "lognorm", "gamma", "beta")])
              },
              if (gamma_imp & any(meth == "cumlogit")) {
                paste0("gamma_", names(meth)[meth == "cumlogit"])
              },
              if (delta_imp & any(meth == "cumlogit")) {
                paste0("delta_", names(meth)[meth == "cumlogit"])
              },
              other
  )


  if (analysis_type == "lme") {
    params <- c(params,
                if (ranef) "b",
                if (invD) unlist(sapply(1:Zcols, function(x)
                  paste0("invD[", 1:x, ",", x,"]"))),
                if (D) unlist(sapply(1:Zcols, function(x)
                  paste0("D[", 1:x, ",", x,"]"))),
                if (RinvD) paste0("RinvD[", 1:Zcols, ",", 1:Zcols,"]")
    )
  }

  if (imps) {
    repl_list <- lapply(imp_par_list, function(x)
      if (x$dest_mat == 'Xtrafo') x[c('dest_col', 'trafo_cols')]
    )

    Xc_NA <- if (any(is.na(Xc))) which(is.na(Xc), arr.ind = TRUE)
    Xc_NA <- Xc_NA[Xc_NA[, 2] %in% which(colSums(!is.na(Xc)) > 0), ]
    Xcat_NA <- if (any(is.na(Xcat))) which(is.na(Xcat), arr.ind = TRUE)
    Xtrafo_NA <- if (any(is.na(Xtrafo))) which(is.na(Xtrafo), arr.ind = TRUE)
    if (any(is.na(Xtrafo))) {
      Xtrafo_NA_Xc <- matrix(nrow = 0, ncol = 2)
      for (i in seq_along(repl_list)) {
        for (j in seq_along(repl_list[[i]]$trafo_cols)) {
          Xtrafo_NA_Xc_add <- Xtrafo_NA[Xtrafo_NA[, 'col'] == repl_list[[i]]$dest_col, ]
          Xtrafo_NA_Xc_add[, 'col'] <- gsub(repl_list[[i]]$dest_col,
                                            repl_list[[i]]$trafo_cols[j],
                                            Xtrafo_NA_Xc_add[, 'col'])
          Xtrafo_NA_Xc <- rbind(Xtrafo_NA_Xc, Xtrafo_NA_Xc_add)
        }
      }
    }

    params <- c(params,
                if (!is.null(Xc_NA))
                  paste0("Xc[", apply(Xc_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Xtrafo_NA))
                  c(paste0("Xtrafo[", apply(Xtrafo_NA, 1, paste, collapse = ","), "]"),
                    paste0("Xc[", apply(Xtrafo_NA_Xc, 1, paste, collapse = ","), "]")),
                if (!is.null(Xcat_NA))
                  paste0("Xcat[", apply(Xcat_NA, 1, paste, collapse = ","), "]")
    )
  }

  return(params)
}
