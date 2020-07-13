get_params <- function(analysis_main = TRUE,
                       analysis_random = FALSE,
                       other_models = FALSE,
                       imps = NULL,
                       betas = NULL,
                       tau_main = NULL,
                       sigma_main = NULL,
                       gamma_main = NULL,
                       delta_main = NULL,
                       ranef_main = NULL,
                       invD_main = NULL,
                       D_main = NULL,
                       RinvD_main = NULL,
                       basehaz = NULL,
                       alphas = NULL,
                       tau_other = NULL,
                       sigma_other = NULL,
                       gamma_other = NULL,
                       delta_other = NULL,
                       D_other = NULL,
                       RinvD_other = FALSE,
                       ranef_other = FALSE,
                       invD_other = FALSE,
                       other = NULL,
                       ppc = FALSE,
                       mess = TRUE,
                       Mlist,
                       info_list) {

  args <- as.list(match.call())[-1]
  fmls <- formals()
  args <- c(args, fmls[setdiff(names(fmls), names(args))])


  # update analysis_main parameters
  for (k in c(
    'betas',
    'sigma_main',
    'tau_main',
    'gamma_main',
    'shape_main',
    'D_main',
    'basehaz'
  )) {
    args[[k]] <-
      ifelse(is.null(args[[k]]), isTRUE(args$analysis_main), args[[k]])
  }

  # update analysis_random parameters
  for (k in c('D_main', 'invD_main', 'RinvD_main', 'ranef_main')) {
    args[[k]] <-
      ifelse(is.null(args[[k]]), isTRUE(args$analysis_random), args[[k]])
  }

  # update other_models parameters
  for (k in c(
    'alphas',
    'sigma_other',
    'tau_other',
    'gamma_other',
    'shape_other',
    'D_other'
  )) {
    args[[k]] <-
      ifelse(is.null(args[[k]]), isTRUE(args$other_models), args[[k]])
  }

  # imps
  impvals <- if (isTRUE(args$imps)) {
    unlist(unname(sapply(names(Mlist$M), function(k) {
      if (any(is.na(Mlist$M[[k]]))) {
        M_NA <- which(is.na(Mlist$M[[k]][, colnames(Mlist$M[[k]]) %in%
                                           names(Mlist$data), drop = FALSE]),
                      arr.ind = TRUE)

        apply(M_NA, 1, function(x) {
          paste0(k, "[", x[1], ",", x[2], "]")
        })
      }
    }, simplify = FALSE)))
  }


  # collect parameters ---------------------------------------------------------
  params <- c(
    get_modelpars(info_list, Mlist = Mlist, args = args, set = "main"),
    get_modelpars(info_list, Mlist = Mlist, args = args, set = "other"),
    get_ranefpars(info_list, Mlist = Mlist, args, set = 'main'),
    get_ranefpars(info_list, Mlist = Mlist, args, set = 'other'),
    other,
    impvals
  )

  unname(params)
}


get_modelpars <- function(info_list, Mlist, args, set = 'main') {

  sublist <- if (set == "main") {
    info_list[names(info_list) %in% names(Mlist$fixed)]
  } else {
    info_list[!names(info_list) %in% names(Mlist$fixed)]
  }

  modeltypes <- sapply(sublist, "[[", 'modeltype')
  families <- sapply(sublist, "[[", 'family')


  params <- c()


  # regcoef
  coefnam <- switch(set,
                    main = 'betas',
                    other = 'alphas')

  if (args[[coefnam]] &
      any(grepl(paste0("^", gsub("s$", "", coefnam), "\\b"),
                do.call(rbind, get_coef_names(info_list))$coef
      )))
    params <- c(params, gsub("s$", "", coefnam))


  # basehaz
  if (args$basehaz & any(modeltypes %in% c('coxph', 'JM'))) {
    survnams <- sapply(sublist[modeltypes %in% c('coxph', 'JM')],
                       "[[", 'varname')
    params <- c(params, paste0("beta_Bh0_", survnams))
  }

  # gamma & delta
  if (any(modeltypes %in% c('clm', 'clmm'))) {
    ord_mods <- names(sublist)[modeltypes %in% c('clm', 'clmm')]
    params <- c(params,
                if (args[[paste0("gamma_", set)]]) paste0("gamma_", ord_mods),
                if (isTRUE(args[[paste0("delta_", set)]]))
                  paste0("delta_", ord_mods)
    )
  }


  # sigma & tau
  sigvars <- if (args[[paste0("sigma_", set)]]) {
    names(sublist)[families %in% c('gaussian', 'Gamma', 'lognorm')]
  }
  tauvars <- if (args[[paste0("tau_", set)]]) {
    setdiff(names(sublist)[families %in%
                             c('gaussian', 'Gamma', 'lognorm', 'beta')],
            sigvars)
  }

  params <- c(params,
              if (length(sigvars) > 0) paste0('sigma_', sigvars),
              if (length(tauvars) > 0) paste0("tau_", tauvars))


  if (any(modeltypes %in% c('survreg')) &
      isTRUE(args$analysis_main) &
      set == 'main')
    params <- c(params,
                paste0("shape_", sapply(sublist[modeltypes %in% c('survreg')],
                                        "[[", 'varname')))

  params
}


get_ranefpars <- function(info_list, Mlist, args, set = 'main') {

  sublist <- if (set == "main") {
    info_list[names(info_list) %in% names(Mlist$fixed)]
  } else {
    info_list[!names(info_list) %in% names(Mlist$fixed)]
  }

  ranef_info <- lapply(sublist, function(x)
    if (!is.null(x$hc_list))
      list(varname = x$varname,
           lvls = names(x$hc_list$hcvars),
           nranef = x$nranef)
  )

  if (all(sapply(ranef_info, is.null))) return(NULL)

  params <- c()


  # ranef
  if (args[[paste0("ranef_", set)]]) {
    params <- c(params,
                sapply(ranef_info, function(k)
                  paste0('b_', k$varname, "_", k$lvls)))
  }

  # invD
  if (args[[paste0("invD_", set)]]) {
    params <- c(params,
                unlist(sapply(ranef_info, function(x) {
                  sapply(x$lvls, function(lvl) {
                    sapply(1:max(1, x$nranef[lvl]), function(i)
                      paste0("invD_", x$varname, "_", lvl, "[", 1:i, ",", i, "]"))
                  })
                })))
  }

  # D
  if (args[[paste0("D_", set)]]) {
    params <- c(params,
                unlist(sapply(ranef_info, function(x) {
                  sapply(x$lvls, function(lvl) {
                    sapply(1:max(1, x$nranef[lvl]), function(i)
                      paste0("D_", x$varname, "_", lvl, "[", 1:i, ",", i, "]"))
                  })
                })))
  }

  # RinvD
  if (args[[paste0("RinvD_", set)]]) {
    params <- c(params,
                unlist(sapply(ranef_info, function(x) {
                  sapply(x$lvls, function(lvl) {
                    paste0("RinvD_", x$varname, "_", lvl,
                           "[", 1:max(1, x$nranef[lvl]), ",",
                           1:max(1, x$nranef[lvl]), "]")
                  })
                })))
  }

  params
}









# get_params_old <- function(Mlist, info_list,
#                        analysis_main = TRUE,
#                        analysis_random = FALSE,
#                        other_models = FALSE,
#                        imps = NULL,
#                        ppc = NULL,
#                        betas = NULL, tau_main = NULL, sigma_main = NULL,
#                        gamma_main = NULL, delta_main = NULL,
#                        ranef_main = NULL, invD_main = NULL,
#                        D_main = NULL, RinvD_main = NULL,
#                        alphas = NULL, tau_other = NULL, sigma_other = NULL,
#                        gamma_other = NULL, delta_other = NULL,
#                        ranef_other = NULL, invD_other = NULL,
#                        D_other = NULL, RinvD_other = NULL,
#                        other = NULL, mess = TRUE, basehaz = NULL, ...) {
#
#
#   # split info_list into main models and other models
#   list_main <- info_list[names(Mlist$fixed)]
#   list_other <- info_list[!names(info_list) %in% names(Mlist$fixed)]
#
#   modeltypes_main <- sapply(list_main, "[[", 'modeltype')
#   modeltypes_other <- sapply(list_other, "[[", 'modeltype')
#
#   families_main <- sapply(list_main, "[[", 'family')
#   families_other <- sapply(list_other, "[[", 'family')
#
#
#   # get random effects info for the main models and other models
#   ranef_info_main <- lapply(list_main, function(x)
#     if (!is.null(x$hc_list))
#       list(varname = x$varname,
#            lvls = names(x$hc_list$hcvars),
#            nranef = x$nranef)
#   )
#
#   ranef_info_other <- lapply(list_other, function(x)
#     if (!is.null(x$hc_list))
#       list(varname = x$varname,
#            lvls = names(x$hc_list$hcvars),
#            nranef = x$nranef)
#   )
#
#
#   # analysis_main  -------------------------------------------------------------
#   if (analysis_main) {
#     # betas
#     if (is.null(betas)) betas <- TRUE
#
#     # sigma
#     if ((any(families_main %in% c("gaussian", "Gamma", "lognorm")) |
#          any(modeltypes_main %in% c('survreg'))) &
#         is.null(sigma_main)) {
#       sigma_main <- TRUE
#     }
#
#     # tau
#     if (any(families_main %in% c("gaussian", "Gamma", "lognorm", "beta")) &
#         !isFALSE(tau_main)) {
#       tau_main <- TRUE
#     }
#
#     # sigma_main
#     sigvars <- if (isTRUE(sigma_main)) {
#       names(list_main)[families_main %in% c('gaussian', 'Gamma', 'lognorm')]
#     }
#
#     # tau_main
#     tauvars <- if (isTRUE(tau_main)) {
#       setdiff(
#         names(list_main)[families_main %in% c('gaussian', 'Gamma',
#                                               'lognorm', 'beta')],
#         sigvars
#       )
#     }
#
#
#
#     # gamma
#     gamma_main <- any(modeltypes_main %in% c('clmm', 'clm')) &
#       !isFALSE(gamma_main)
#
#
#     # basehaz
#     if (any(modeltypes_main %in% c('coxph', "JM")) & !isFALSE(basehaz))
#       # for a cox model with no betas, something needs to be monitored to
#       # prevent JAGS error "No valid monitors set".
#       basehaz <- TRUE
#
#     # D
#     if (!isFALSE(D_main))
#       D_main <- TRUE
#   }
#
#
#   # analysis_random ------------------------------------------------------------
#   if (analysis_random &
#       any(modeltypes_main %in% c("glmm", "clmm", "mlogitmm", "coxph",
#                                  "survreg", "JM"))) {
#     if (is.null(ranef_main)) ranef_main <- TRUE
#     if (is.null(invD_main)) invD_main <- TRUE
#     if (is.null(D_main)) D_main <- TRUE
#     if (is.null(RinvD_main)) RinvD_main <- TRUE
#   }
#
#   # imputation parameters -----------------------------------------------------
#   if (other_models) {
#     if (length(setdiff(names(info_list), names(Mlist$fixed))) == 0) {
#       if (mess)
#         msg('There are no missing values in covariates. I will set
#             "other_models = FALSE".')
#       other_models <- FALSE
#     } else {
#       if (is.null(alphas)) alphas <- TRUE
#       if (is.null(tau_other)) tau_other <- TRUE
#       if (is.null(gamma_other)) gamma_other <- TRUE
#       if (is.null(delta_other)) delta_other <- TRUE
#       if (is.null(D_other)) D_other <- TRUE
#     }
#   }
#
#   # other ----------------------------------------------------------------------
#   arglist <- mget(names(formals()), sys.frame(sys.nframe()))
#
#   for (i in names(arglist)) {
#     if (is.null(arglist[[i]]) & i != "other") assign(i, FALSE)
#   }
#
#   # params ---------------------------------------------------------------------
#   params <- c(
#     # beta
#     if (isTRUE(betas) &
#         any(grepl("^beta\\b", do.call(rbind, get_coef_names(info_list))$coef)))
#       "beta",
#
#     # basehaz
#     if (isTRUE(basehaz))
#       paste0("beta_Bh0_",
#              sapply(list_main[modeltypes_main %in% c('coxph', 'JM')],
#                     "[[", 'varname')),
#     # gamma_main
#     if (isTRUE(gamma_main))
#       paste0("gamma_", names(list_main)[modeltypes_main %in% c('clm', 'clmm')]),
#
#     # delta_main
#     if (isTRUE(delta_main))
#       paste0("delta_", names(list_main)[modeltypes_main %in% c('clm', 'clmm')]),
#
#     # sigma_main
#     if (isTRUE(sigma_main)) {
#       c(if (length(sigvars) > 0) paste0('sigma_', sigvars),
#
#         if (any(modeltypes_main %in% c('survreg')))
#           paste0("shape_", sapply(list_main[modeltypes_main %in% c('survreg')],
#                                   "[[", 'varname'))
#       )
#     },
#
#     # tau_main
#     if (isTRUE(tau_main && length(tauvars) > 0))
#       paste0("tau_", tauvars),
#
#
#
#     # random effects parameters
#     if (any(!sapply(ranef_info_main, is.null))) {
#       c(
#         # ranef_main
#         if (isTRUE(ranef_main))
#           sapply(ranef_info_main, function(k)
#             paste0('b_', k$varname, "_", k$lvls)),
#
#         # invD_main
#         if (isTRUE(invD_main))
#           unlist(sapply(ranef_info_main, function(x)
#             sapply(x$lvls, function(lvl) {
#               sapply(1:max(1, x$nranef[lvl]), function(i)
#                 paste0("invD_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
#               )}))),
#
#         # D_main
#         if (isTRUE(D_main))
#           unlist(sapply(ranef_info_main, function(x)
#             sapply(x$lvls, function(lvl) {
#               sapply(1:max(1, x$nranef[lvl]), function(i)
#                 paste0("D_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
#               )}))),
#
#         # RinvD_main
#         if (isTRUE(RinvD_main))
#           unlist(sapply(ranef_info_main, function(x)
#             sapply(x$lvls, function(lvl) {
#             paste0("RinvD_", x$varname, "_", lvl, "[", 1:max(1, x$nranef[lvl]),
#                    ",", 1:max(1, x$nranef[lvl]), "]")
#             })))
#       )
#     },
#
#     # alphas
#     if (isTRUE(alphas)) "alpha",
#
#     # tau_other
#     if (isTRUE(tau_other) & any(families_other %in%
#                                 c("gaussian", "lognorm", "gamma", "beta")))
#       paste0("tau_", names(list_other)[
#         families_other %in% c("gaussian", "lognorm", "gamma", "beta")]),
#
#     # gamma_other
#     if (isTRUE(gamma_other) &
#         any(modeltypes_other %in% c("clm", "clmm")))
#       paste0("gamma_", names(list_other)[
#         modeltypes_other %in% c("clm", "clmm")]),
#
#     # delta_other
#     if (isTRUE(delta_other) & any(modeltypes_other %in% c("clm", "clmm")))
#       paste0("delta_", names(list_other)[
#         modeltypes_other %in% c("clm", "clmm")]),
#
#     # random effects in other models
#     if (any(!sapply(ranef_info_other, is.null))) {
#       c(
#         # ranef_other
#         if (isTRUE(ranef_other))
#           sapply(ranef_info_other, function(k)
#             paste0('b_', k$varname, "_", k$lvls)),
#
#         # invD_other
#         if (isTRUE(invD_other))
#           unlist(sapply(ranef_info_other, function(x)
#             sapply(x$lvls, function(lvl) {
#               sapply(1:max(1, x$nranef[lvl]), function(i)
#                 paste0("invD_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
#               )}))),
#
#         # D_other
#         if (isTRUE(D_other))
#           unlist(sapply(ranef_info_other, function(x)
#             sapply(x$lvls, function(lvl) {
#               sapply(1:max(1, x$nranef[lvl]), function(i)
#                 paste0("D_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
#               )}))),
#
#         # RinvD_other
#         if (isTRUE(RinvD_other))
#           unlist(sapply(ranef_info_other, function(x)
#             sapply(x$lvls, function(lvl) {
#               paste0("RinvD_", x$varname, "_", lvl, "[",
#                      1:max(1, x$nranef[lvl]), ",", 1:max(1, x$nranef[lvl]), "]")
#             })))
#       )
#     },
#
#     # other
#     other,
#
#     # imps
#     if (isTRUE(imps)) {
#       unlist(unname(
#         sapply(names(Mlist$M), function(k) {
#         if (any(is.na(Mlist$M[[k]]))) {
#           M_NA <- which(is.na(Mlist$M[[k]][, colnames(Mlist$M[[k]]) %in%
#                                              names(Mlist$data), drop = FALSE]),
#                         arr.ind = TRUE)
#
#           apply(M_NA, 1, function(x) {
#             paste0(k, "[", x[1], ",", x[2], "]")
#           })
#         }
#       }, simplify = FALSE)
#       ))
#     }
#   )
#   unname(params)
# }
