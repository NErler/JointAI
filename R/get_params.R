
get_params <- function(models, analysis_type, family, Mlist,
                       imp_par_list = NULL,
                       analysis_main = TRUE,
                       analysis_random = FALSE,
                       imp_pars = FALSE,
                       imps = NULL,
                       ppc = NULL,
                       betas = NULL, tau_y = NULL, sigma_y = NULL,
                       gamma_y = NULL, delta_y = NULL,
                       ranef = NULL, invD = NULL, D = NULL, RinvD = NULL,
                       alphas = NULL, tau_imp = NULL, gamma_imp = NULL, D_imp = NULL,
                       delta_imp = NULL, other = NULL, mess = TRUE, basehaz = FALSE,
                       ...){

  y_name <- colnames(Mlist$outcomes[[1]])

  if (missing(family))
    family <- attr(analysis_type, "family")

  if (analysis_main) {
    if (is.null(betas) & any(!sapply(Mlist$cols_main[[1]], is.null))) betas <- TRUE
    if (family$family %in% c("gaussian", "Gamma", 'weibull')) {
      if (is.null(sigma_y)) sigma_y <- TRUE
    }
    if (family$family %in% c('ordinal')) {
      gamma_y <- TRUE
    }
    basehaz <- family$family == 'prophaz'# & all(sapply(Mlist$cols_main, is.null))

    if (analysis_type %in% c("lme", "glme", "clmm", "JM")) {
      if (analysis_main & is.null(D)) D <- TRUE
    }
  }


  if (analysis_random) {
    if (is.null(ranef)) ranef <- TRUE
    if (is.null(invD)) invD <- TRUE
    if (is.null(D)) D <- TRUE
    if (is.null(RinvD) & Mlist$nranef > 1) RinvD <- TRUE
  }

  if (imp_pars & is.null(models) & mess) {
    message(paste0('There are no missing values in covariates, ',
    'so I set "imp_pars = FALSE".'))
  }
  if (imp_pars & !is.null(models)) {
    if (is.null(alphas)) alphas <- TRUE
    if (is.null(tau_imp)) tau_imp <- TRUE
    if (is.null(gamma_imp)) gamma_imp <- TRUE
    if (is.null(delta_imp)) delta_imp <- TRUE
    if (is.null(D_imp)) D_imp <- TRUE
  }

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))

  for (i in names(arglist)) {
    if (is.null(arglist[[i]]) & i != "other") assign(i, FALSE)
  }

  params <- c(if (betas) "beta",
              if (basehaz) "Bs.gammas",
              if (gamma_y) paste0("gamma_", y_name),
              if (delta_y) paste0("delta_", y_name),
              if (tau_y) paste0("tau_", y_name),
              if (sigma_y) {
                if (family$family == 'weibull')
                  paste0("shape_", y_name)
                else
                  paste0("sigma_", y_name)
              },
              if (alphas) "alpha",
              if (tau_imp & any(models %in% c("norm", "lognorm", "gamma", "beta",
                                              "lmm", 'glmm_gamma', 'glmm_lognorm'))) {
                paste0("tau_", names(models)[models %in% c("norm", "lognorm",
                                                           "gamma", "beta", "lmm",
                                                           "glmm_gamma", "glmm_lognorm")])
              },
              if (gamma_imp & any(models %in% c("cumlogit", "clmm"))) {
                paste0("gamma_", names(models)[models %in% c("cumlogit", "clmm")])
              },
              if (delta_imp & any(models %in% c("cumlogit", "clmm"))) {
                paste0("delta_", names(models)[models %in% c("cumlogit", "clmm")])
              },
              if (D_imp & any(models %in% c("lmm", "glmm_logit", "glmm_gamma",
                                            "glmm_lognorm", "glmm_poisson"))) {
                paste0("D_", names(models)[models %in% c("lmm", "glmm_logit", "glmm_gamma",
                                                         "glmm_lognorm", "glmm_poisson")])
              },
              # if (ppc) paste0('ppc_', c(y_name, names(models))),
              other
  )

  if (analysis_type %in% c("lme", "glme", "clmm", "JM")) {
    params <- c(params,
                if (ranef) "b",
                if (invD) unlist(sapply(1:Mlist$nranef, function(x)
                  paste0("invD[", 1:x, ",", x,"]"))),
                if (D) {
                  if(analysis_type != "JM") {
                    unlist(sapply(1:Mlist$nranef, function(x)
                      paste0("D[", 1:x, ",", x,"]")))
                  } else {
                    sapply(names(sapply(Mlist$outnam, 'attr', 'type'))[
                      sapply(Mlist$outnam, 'attr', 'type') == 'other'],
                    function(k) {
                      unlist(sapply(1:imp_par_list[[k]]$nranef, function(x)
                               paste0("D_", k, "[", 1:x, ",", x,"]")
                             ))
                    })
                  }
                },
                if (RinvD) paste0("RinvD[", 1:Mlist$nranef, ",", 1:Mlist$nranef,"]")
    )
  }

  if (imps) {
    repl_list <- lapply(imp_par_list, function(x)
      if (x$dest_mat %in% c('Xtrafo')) x[c('dest_col', 'trafo_cols')]
    )

    repl_list_long <- lapply(imp_par_list, function(x)
      if (x$dest_mat %in% c('Xltrafo')) x[c('dest_col', 'trafo_cols')]
    )

    Xc_NA <- if (any(is.na(Mlist$Xc))) which(is.na(Mlist$Xc), arr.ind = TRUE)
    if (!is.null(Xc_NA))
      Xc_NA <- Xc_NA[Xc_NA[, 2] %in% which(colSums(!is.na(Mlist$Xc)) > 0), , drop = FALSE]

    Xcat_NA <- if (any(is.na(Mlist$Xcat))) which(is.na(Mlist$Xcat), arr.ind = TRUE)
    Xlcat_NA <- if (any(is.na(Mlist$Xlcat))) which(is.na(Mlist$Xlcat), arr.ind = TRUE)
    Xtrafo_NA <- if (any(is.na(Mlist$Xtrafo))) which(is.na(Mlist$Xtrafo), arr.ind = TRUE)
    Xltrafo_NA <- if (any(is.na(Mlist$Xltrafo))) which(is.na(Mlist$Xltrafo), arr.ind = TRUE)

    Xl_NA <- if (any(is.na(Mlist$Xl))) which(is.na(Mlist$Xl), arr.ind = TRUE)
    if (!is.null(Xl_NA))
      Xl_NA <- Xl_NA[Xl_NA[, 2] %in% which(colSums(!is.na(Mlist$Xl)) > 0), , drop = FALSE]

    Z_NA <- if (any(is.na(Mlist$Z))) which(is.na(Mlist$Z), arr.ind = TRUE)
    if (!is.null(Z_NA))
      Z_NA <- Z_NA[Z_NA[, 2] %in% which(colSums(!is.na(Mlist$Z)) > 0), , drop = FALSE]

    if (any(is.na(Mlist$Xtrafo))) {
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

    if (any(is.na(Mlist$Xltrafo))) {
      Xltrafo_NA_Z <- Xltrafo_NA_Xl <- matrix(nrow = 0, ncol = 2)
      for (i in seq_along(repl_list_long)) {
        for (j in seq_along(unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Xl')))) {
          Xltrafo_NA_Xl_add <- Xltrafo_NA[Xltrafo_NA[, 'col'] == repl_list_long[[i]]$dest_col, ]

          Xltrafo_NA_Xl_add[, 'col'] <- gsub(repl_list_long[[i]]$dest_col,
                                             unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Xl'))[j],
                                            Xltrafo_NA_Xl_add[, 'col'])
          Xltrafo_NA_Xl <- rbind(Xltrafo_NA_Xl, Xltrafo_NA_Xl_add)
        }
        for (j in seq_along(unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Z')))) {
          Xltrafo_NA_Z_add <- Xltrafo_NA[Xltrafo_NA[, 'col'] == repl_list_long[[i]]$dest_col, ]

          Xltrafo_NA_Z_add[, 'col'] <- gsub(repl_list_long[[i]]$dest_col,
                                             unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Z'))[j],
                                             Xltrafo_NA_Z_add[, 'col'])
          Xltrafo_NA_Z <- rbind(Xltrafo_NA_Z, Xltrafo_NA_Z_add)
        }
      }
    }


    params <- c(params,
                if (!is.null(Xc_NA) && nrow(Xc_NA) > 0)
                  paste0("Xc[", apply(Xc_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Xl_NA) && nrow(Xl_NA) > 0)
                  paste0("Xl[", apply(Xl_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Z_NA) && nrow(Z_NA) > 0)
                  paste0("Z[", apply(Z_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Xtrafo_NA) && nrow(Xtrafo_NA) > 0)
                  c(paste0("Xtrafo[", apply(Xtrafo_NA, 1, paste, collapse = ","), "]"),
                    paste0("Xc[", apply(Xtrafo_NA_Xc, 1, paste, collapse = ","), "]")),
                if (!is.null(Xltrafo_NA) && nrow(Xltrafo_NA) > 0)
                  c(paste0("Xltrafo[", apply(Xltrafo_NA, 1, paste, collapse = ","), "]"),
                    paste0("Xl[", apply(Xltrafo_NA_Xl, 1, paste, collapse = ","), "]"),
                    paste0("Z[", apply(Xltrafo_NA_Z, 1, paste, collapse = ","), "]")),
                if (!is.null(Xcat_NA) && nrow(Xcat_NA) > 0)
                  paste0("Xcat[", apply(Xcat_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Xlcat_NA) && nrow(Xlcat_NA) > 0)
                  paste0("Xlcat[", apply(Xlcat_NA, 1, paste, collapse = ","), "]")
    )
  }

  return(params)
}
