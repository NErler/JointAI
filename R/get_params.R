get_params <- function(Mlist, info_list, data,
                       analysis_main = TRUE,
                       analysis_random = FALSE,
                       imp_pars = FALSE,
                       imps = NULL,
                       ppc = NULL,
                       betas = NULL, tau_main = NULL, sigma_main = NULL,
                       gamma_main = NULL, delta_main = NULL,
                       ranef_main = NULL, invD_main = NULL, D_main = NULL, RinvD_main = NULL,
                       alphas = NULL, tau_other = NULL, sigma_other = NULL,
                       gamma_other = NULL, delta_other = NULL,
                       ranef_other = NULL, invD_other = NULL, D_other = NULL, RinvD_other = NULL,
                       other = NULL, mess = TRUE, basehaz = FALSE,
                       ...){

  list_main <- info_list[names(Mlist$fixed)]
  list_other <- info_list[!names(info_list) %in% names(Mlist$fixed)]

  modeltypes_main <- sapply(list_main, "[[", 'modeltype')

  if (analysis_main) {
    if (is.null(betas)) betas <- TRUE
    if ((any(sapply(list_main, "[[", 'family') %in% c("gaussian", "Gamma")) |
         any(modeltypes_main %in% c('survreg'))) &
        is.null(sigma_main)) {
      sigma_main <- TRUE
    }
    if (any(sapply(list_main, "[[", 'family') %in% c("gaussian", "Gamma")) &
        is.null(sigma_main)) {
      tau_main <- TRUE
    }


    if (any(modeltypes_main %in% c('clm', 'clmm')) &
        is.null(gamma_main))
      gamma_main <- TRUE

    if (any(modeltypes_main %in% c('coxph')) &
        (is.null(basehaz) | !any(grepl("^beta\\b",
                                       do.call(rbind, get_coef_names(info_list))$coef))))
      # for a cox model with no betas, something needs to be monitored to prevent
      # JAGS error "No valid monitors set".
      basehaz <- TRUE


    if (any(modeltypes_main %in% c("glmm", "clmm", "mlogitmm")) &
        is.null(D_main))
      D_main <- TRUE
  }


  if (analysis_random &
      any(modeltypes_main %in% c("glmm", "clmm", "mlogitmm"))) {
    if (is.null(ranef_main)) ranef_main <- TRUE
    if (is.null(invD_main)) invD_main <- TRUE
    if (is.null(D_main)) D_main <- TRUE
    if (is.null(RinvD_main)) RinvD_main <- TRUE
  }

  if (imp_pars) {
    if (length(setdiff(names(info_list), names(Mlist$fixed))) == 0) {
      if (mess)
        message(paste0('There are no missing values in covariates, ',
                       'so I set "imp_pars = FALSE".'))
      imp_pars = FALSE
    } else {
      if (is.null(alphas)) alphas <- TRUE
      if (is.null(tau_other)) tau_other <- TRUE
      if (is.null(gamma_other)) gamma_other <- TRUE
      if (is.null(delta_other)) delta_other <- TRUE
      if (is.null(D_other)) D_other <- TRUE
    }
  }

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))

  for (i in names(arglist)) {
    if (is.null(arglist[[i]]) & i != "other") assign(i, FALSE)
  }

  params <- c(if (betas & any(
    grepl("^beta\\b", do.call(rbind, get_coef_names(info_list))$coef))) "beta",
              if (basehaz) "beta_Bh0",
              if (gamma_main) paste0("gamma_", names(list_main)[
                modeltypes_main %in% c('clm', 'clmm')]),
              if (delta_main) paste0("delta_", names(list_main)[
                modeltypes_main %in% c('clm', 'clmm')]),
              if (tau_main) paste0("tau_", names(list_main)[
                sapply(list_main, '[[', 'family') %in% c('gaussian', 'Gamma')]),
              if (sigma_main) {
                c(
                  if (any(sapply(list_main, '[[', 'family') %in%
                          c('gaussian', 'Gamma', 'lognorm', 'beta')))
                    paste0('sigma_', names(list_main)[
                      sapply(list_main, '[[', 'family') %in%
                        c('gaussian', 'Gamma', 'lognorm', 'beta')]),

                  if (any(modeltypes_main %in% c('survreg')))
                    paste0("shape_", sapply(list_main[modeltypes_main %in% c('survreg')],
                                            "[[", 'varname'))
                )
              },
              if (any(modeltypes_main %in% c('glmm', 'clmm', 'mlogitmm'))) {
                long_main <- names(list_main)[
                  modeltypes_main %in% c('glmm', 'clmm', 'mlogitmm')]

                c(
                  if (ranef_main) paste0("b_", long_main),
                  if (invD_main)
                    unlist(sapply(list_main[long_main], function(x)
                      sapply(1:max(1, length(x$hc_list)), function(i)
                        paste0("invD_", x$varname, "[", 1:i, ",", i, "]")
                      ))),
                  if (D_main)
                    unlist(sapply(list_main[long_main], function(x)
                      sapply(1:max(1, length(x$hc_list)), function(i)
                        paste0("D_", x$varname, "[", 1:i, ",", i, "]")
                      ))),
                  if (RinvD_main)
                    sapply(list_main[long_main], function(x)
                      paste0("RinvD_", x$varname, "[", 1:max(1, length(x$hc_list)),
                             ",", 1:max(1, length(x$hc_list)), "]")
                    )
                )
              },

              if (alphas) "alpha",
              if (tau_other & any(sapply(list_other, "[[", 'family') %in%
                                  c("gaussian", "lognorm", "gamma", "beta")))
                paste0("tau_", names(list_other)[
                  sapply(list_other, "[[", 'family') %in% c("gaussian", "lognorm",
                                                            "gamma", "beta")]),

              if (gamma_other & any(sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")))
                paste0("gamma_", names(list_other)[
                  sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")]),

              if (delta_other & any(sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")))
                paste0("delta_", names(list_other)[
                  sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")]),

              if (any(sapply(list_other, "[[", 'modeltype') %in% c('glmm', 'clmm', 'mlogitmm'))) {
                long_other <- names(list_other)[
                  sapply(list_other, "[[", 'modeltype') %in% c('glmm', 'clmm', 'mlogitmm')]

                c(
                  if (ranef_other) paste0("b_", long_other),
                  if (invD_other)
                    sapply(list_other[long_other], function(x)
                      sapply(1:max(1, length(x$hc_list)), function(i)
                        paste0("invD_", x$varname, "[", 1:i, ", ", i, "]")
                      )),
                  if (D_other)
                    sapply(list_other[long_other], function(x)
                      sapply(1:max(1, length(x$hc_list)), function(i)
                        paste0("D_", x$varname, "[", 1:i, ", ", i, "]")
                      )),
                  if (RinvD_other)
                    sapply(list_other[long_other], function(x)
                      paste0("RinvD_", x$varname, "[", 1:max(1, length(x$hc_list)),
                             ",", 1:max(1, length(x$hc_list)), "]")
                    )
                )
              },

              # if (ppc) paste0('ppc_', c(y_name, names(models))),
              other,
              if (imps) {
                c(if (any(is.na(Mlist$Mc))) {
                  Mc_NA <- which(is.na(Mlist$Mc[, colnames(Mlist$Mc) %in% names(data),
                                                drop = FALSE]), arr.ind = TRUE)
                  apply(Mc_NA, 1, function(x)
                    paste0("Mc[", x[1], ",", x[2], "]")
                  )
                },
                if (any(is.na(Mlist$Ml))) {
                  Ml_NA <- which(is.na(Mlist$Ml[, colnames(Mlist$Ml) %in% names(data),
                                                drop = FALSE]), arr.ind = TRUE)
                  apply(Ml_NA, 1, function(x)
                    paste0("Ml[", x[1], ",", x[2], "]")
                  )
                })
              }
  )
  return(params)
}


# get_params <- function(models, analysis_type, family, Mlist,
#                        imp_par_list = NULL,
#                        analysis_main = TRUE,
#                        analysis_random = FALSE,
#                        imp_pars = FALSE,
#                        imps = NULL,
#                        ppc = NULL,
#                        betas = NULL, tau_y = NULL, sigma_y = NULL,
#                        gamma_y = NULL, delta_y = NULL,
#                        ranef = NULL, invD = NULL, D = NULL, RinvD = NULL,
#                        alphas = NULL, tau_imp = NULL, gamma_imp = NULL, D_imp = NULL,
#                        delta_imp = NULL, other = NULL, mess = TRUE, basehaz = FALSE,
#                        ...){
#
#   y_name <- colnames(Mlist$outcomes[[1]])
#
#   if (missing(family))
#     family <- attr(analysis_type, "family")
#
#   if (analysis_main) {
#     if (is.null(betas) & any(!sapply(Mlist$cols_main[[1]], is.null))) betas <- TRUE
#     if (family$family %in% c("gaussian", "Gamma", 'weibull')) {
#       if (is.null(sigma_y)) sigma_y <- TRUE
#     }
#     if (family$family %in% c('ordinal')) {
#       gamma_y <- TRUE
#     }
#     basehaz <- family$family == 'prophaz'# & all(sapply(Mlist$cols_main, is.null))
#
#     if (analysis_type %in% c("lme", "glme", "clmm", "JM")) {
#       if (analysis_main & is.null(D)) D <- TRUE
#     }
#   }
#
#
#   if (analysis_random) {
#     if (is.null(ranef)) ranef <- TRUE
#     if (is.null(invD)) invD <- TRUE
#     if (is.null(D)) D <- TRUE
#     if (is.null(RinvD) & Mlist$nranef > 1) RinvD <- TRUE
#   }
#
#   if (imp_pars & is.null(models) & mess) {
#     message(paste0('There are no missing values in covariates, ',
#     'so I set "imp_pars = FALSE".'))
#   }
#   if (imp_pars & !is.null(models)) {
#     if (is.null(alphas)) alphas <- TRUE
#     if (is.null(tau_imp)) tau_imp <- TRUE
#     if (is.null(gamma_imp)) gamma_imp <- TRUE
#     if (is.null(delta_imp)) delta_imp <- TRUE
#     if (is.null(D_imp)) D_imp <- TRUE
#   }
#
#   arglist <- mget(names(formals()), sys.frame(sys.nframe()))
#
#   for (i in names(arglist)) {
#     if (is.null(arglist[[i]]) & i != "other") assign(i, FALSE)
#   }
#
#   params <- c(if (betas) "beta",
#               if (basehaz) "Bs.gammas",
#               if (gamma_y) paste0("gamma_", y_name),
#               if (delta_y) paste0("delta_", y_name),
#               if (tau_y) paste0("tau_", y_name),
#               if (sigma_y) {
#                 if (family$family == 'weibull')
#                   paste0("shape_", y_name)
#                 else
#                   paste0("sigma_", y_name)
#               },
#               if (alphas) "alpha",
#               if (tau_imp & any(models %in% c("norm", "lognorm", "gamma", "beta",
#                                               "lmm", 'glmm_gamma', 'glmm_lognorm'))) {
#                 paste0("tau_", names(models)[models %in% c("norm", "lognorm",
#                                                            "gamma", "beta", "lmm",
#                                                            "glmm_gamma", "glmm_lognorm")])
#               },
#               if (gamma_imp & any(models %in% c("cumlogit", "clmm"))) {
#                 paste0("gamma_", names(models)[models %in% c("cumlogit", "clmm")])
#               },
#               if (delta_imp & any(models %in% c("cumlogit", "clmm"))) {
#                 paste0("delta_", names(models)[models %in% c("cumlogit", "clmm")])
#               },
#               if (D_imp & any(models %in% c("lmm", "glmm_logit", "glmm_gamma",
#                                             "glmm_lognorm", "glmm_poisson"))) {
#                 paste0("D_", names(models)[models %in% c("lmm", "glmm_logit", "glmm_gamma",
#                                                          "glmm_lognorm", "glmm_poisson")])
#               },
#               # if (ppc) paste0('ppc_', c(y_name, names(models))),
#               other
#   )
#
#   if (analysis_type %in% c("lme", "glme", "clmm", "JM")) {
#     params <- c(params,
#                 if (ranef) "b",
#                 if (invD) unlist(sapply(1:Mlist$nranef, function(x)
#                   paste0("invD[", 1:x, ",", x,"]"))),
#                 if (D) {
#                   if(analysis_type != "JM") {
#                     unlist(sapply(1:Mlist$nranef, function(x)
#                       paste0("D[", 1:x, ",", x,"]")))
#                   } else {
#                     sapply(names(sapply(Mlist$outnam, 'attr', 'type'))[
#                       sapply(Mlist$outnam, 'attr', 'type') == 'other'],
#                     function(k) {
#                       unlist(sapply(1:imp_par_list[[k]]$nranef, function(x)
#                                paste0("D_", k, "[", 1:x, ",", x,"]")
#                              ))
#                     })
#                   }
#                 },
#                 if (RinvD) paste0("RinvD[", 1:Mlist$nranef, ",", 1:Mlist$nranef,"]")
#     )
#   }
#
#   if (imps) {
#     repl_list <- lapply(imp_par_list, function(x)
#       if (x$dest_mat %in% c('Xtrafo')) x[c('dest_col', 'trafo_cols')]
#     )
#
#     repl_list_long <- lapply(imp_par_list, function(x)
#       if (x$dest_mat %in% c('Xltrafo')) x[c('dest_col', 'trafo_cols')]
#     )
#
#     Xc_NA <- if (any(is.na(Mlist$Xc))) which(is.na(Mlist$Xc), arr.ind = TRUE)
#     if (!is.null(Xc_NA))
#       Xc_NA <- Xc_NA[Xc_NA[, 2] %in% which(colSums(!is.na(Mlist$Xc)) > 0), , drop = FALSE]
#
#     Xcat_NA <- if (any(is.na(Mlist$Xcat))) which(is.na(Mlist$Xcat), arr.ind = TRUE)
#     Xlcat_NA <- if (any(is.na(Mlist$Xlcat))) which(is.na(Mlist$Xlcat), arr.ind = TRUE)
#     Xtrafo_NA <- if (any(is.na(Mlist$Xtrafo))) which(is.na(Mlist$Xtrafo), arr.ind = TRUE)
#     Xltrafo_NA <- if (any(is.na(Mlist$Xltrafo))) which(is.na(Mlist$Xltrafo), arr.ind = TRUE)
#
#     Xl_NA <- if (any(is.na(Mlist$Xl))) which(is.na(Mlist$Xl), arr.ind = TRUE)
#     if (!is.null(Xl_NA))
#       Xl_NA <- Xl_NA[Xl_NA[, 2] %in% which(colSums(!is.na(Mlist$Xl)) > 0), , drop = FALSE]
#
#     Z_NA <- if (any(is.na(Mlist$Z))) which(is.na(Mlist$Z), arr.ind = TRUE)
#     if (!is.null(Z_NA))
#       Z_NA <- Z_NA[Z_NA[, 2] %in% which(colSums(!is.na(Mlist$Z)) > 0), , drop = FALSE]
#
#     if (any(is.na(Mlist$Xtrafo))) {
#       Xtrafo_NA_Xc <- matrix(nrow = 0, ncol = 2)
#       for (i in seq_along(repl_list)) {
#         for (j in seq_along(repl_list[[i]]$trafo_cols)) {
#           Xtrafo_NA_Xc_add <- Xtrafo_NA[Xtrafo_NA[, 'col'] == repl_list[[i]]$dest_col, ]
#           Xtrafo_NA_Xc_add[, 'col'] <- gsub(repl_list[[i]]$dest_col,
#                                             repl_list[[i]]$trafo_cols[j],
#                                             Xtrafo_NA_Xc_add[, 'col'])
#           Xtrafo_NA_Xc <- rbind(Xtrafo_NA_Xc, Xtrafo_NA_Xc_add)
#         }
#       }
#     }
#
#     if (any(is.na(Mlist$Xltrafo))) {
#       Xltrafo_NA_Z <- Xltrafo_NA_Xl <- matrix(nrow = 0, ncol = 2)
#       for (i in seq_along(repl_list_long)) {
#         for (j in seq_along(unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Xl')))) {
#           Xltrafo_NA_Xl_add <- Xltrafo_NA[Xltrafo_NA[, 'col'] == repl_list_long[[i]]$dest_col, ]
#
#           Xltrafo_NA_Xl_add[, 'col'] <- gsub(repl_list_long[[i]]$dest_col,
#                                              unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Xl'))[j],
#                                             Xltrafo_NA_Xl_add[, 'col'])
#           Xltrafo_NA_Xl <- rbind(Xltrafo_NA_Xl, Xltrafo_NA_Xl_add)
#         }
#         for (j in seq_along(unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Z')))) {
#           Xltrafo_NA_Z_add <- Xltrafo_NA[Xltrafo_NA[, 'col'] == repl_list_long[[i]]$dest_col, ]
#
#           Xltrafo_NA_Z_add[, 'col'] <- gsub(repl_list_long[[i]]$dest_col,
#                                              unlist(sapply(repl_list_long[[i]]$trafo_cols, '[[', 'Z'))[j],
#                                              Xltrafo_NA_Z_add[, 'col'])
#           Xltrafo_NA_Z <- rbind(Xltrafo_NA_Z, Xltrafo_NA_Z_add)
#         }
#       }
#     }
#
#
#     params <- c(params,
#                 if (!is.null(Xc_NA) && nrow(Xc_NA) > 0)
#                   paste0("Xc[", apply(Xc_NA, 1, paste, collapse = ","), "]"),
#                 if (!is.null(Xl_NA) && nrow(Xl_NA) > 0)
#                   paste0("Xl[", apply(Xl_NA, 1, paste, collapse = ","), "]"),
#                 if (!is.null(Z_NA) && nrow(Z_NA) > 0)
#                   paste0("Z[", apply(Z_NA, 1, paste, collapse = ","), "]"),
#                 if (!is.null(Xtrafo_NA) && nrow(Xtrafo_NA) > 0)
#                   c(paste0("Xtrafo[", apply(Xtrafo_NA, 1, paste, collapse = ","), "]"),
#                     paste0("Xc[", apply(Xtrafo_NA_Xc, 1, paste, collapse = ","), "]")),
#                 if (!is.null(Xltrafo_NA) && nrow(Xltrafo_NA) > 0)
#                   c(paste0("Xltrafo[", apply(Xltrafo_NA, 1, paste, collapse = ","), "]"),
#                     paste0("Xl[", apply(Xltrafo_NA_Xl, 1, paste, collapse = ","), "]"),
#                     paste0("Z[", apply(Xltrafo_NA_Z, 1, paste, collapse = ","), "]")),
#                 if (!is.null(Xcat_NA) && nrow(Xcat_NA) > 0)
#                   paste0("Xcat[", apply(Xcat_NA, 1, paste, collapse = ","), "]"),
#                 if (!is.null(Xlcat_NA) && nrow(Xlcat_NA) > 0)
#                   paste0("Xlcat[", apply(Xlcat_NA, 1, paste, collapse = ","), "]")
#     )
#   }
#
#   return(params)
# }
