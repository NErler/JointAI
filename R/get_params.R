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
                       other = NULL, mess = TRUE, basehaz = NULL,
                       ...){

  list_main <- info_list[names(Mlist$fixed)]
  list_other <- info_list[!names(info_list) %in% names(Mlist$fixed)]

  ranef_info_main <- lapply(list_main, function(x)
    if (!is.null(x$hc_list))
      list(varname = x$varname,
           lvls = names(x$hc_list$hcvars),
           nranef = x$nranef)
  )

  ranef_info_other <- lapply(list_other, function(x)
    if (!is.null(x$hc_list))
      list(varname = x$varname,
           lvls = names(x$hc_list$hcvars),
           nranef = x$nranef)
  )

  modeltypes_main <- sapply(list_main, "[[", 'modeltype')

  if (analysis_main) {
    if (is.null(betas)) betas <- TRUE
    if ((any(sapply(list_main, "[[", 'family') %in% c("gaussian", "Gamma", "lognorm")) |
         any(modeltypes_main %in% c('survreg'))) &
        is.null(sigma_main)) {
      sigma_main <- TRUE
    }
    if (any(sapply(list_main, "[[", 'family') %in% c("gaussian", "Gamma", "lognorm")) &
        is.null(sigma_main)) {
      tau_main <- TRUE
    }


    gamma_main <- any(modeltypes_main %in% c('clmm', 'clm')) & isTRUE(gamma_main)


    if (any(modeltypes_main %in% c('coxph', "JM")) & !isFALSE(basehaz))
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
    if (isTRUE(basehaz)) "beta_Bh0",
    if (isTRUE(gamma_main)) paste0("gamma_", names(list_main)[
      modeltypes_main %in% c('clm', 'clmm')]),
    if (isTRUE(delta_main)) paste0("delta_", names(list_main)[
      modeltypes_main %in% c('clm', 'clmm')]),
    if (isTRUE(tau_main)) paste0("tau_", names(list_main)[
      sapply(list_main, '[[', 'family') %in% c('gaussian', 'Gamma', 'lognorm')]),
    if (isTRUE(sigma_main)) {
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

    if (any(!sapply(ranef_info_main, is.null))) {
      c(
        if (isTRUE(ranef_main)) sapply(ranef_info_main, function(k)
          paste0('b_', k$varname, "_", k$lvls)),
        if (isTRUE(invD_main))
          unlist(sapply(ranef_info_main, function(x)
            sapply(x$lvls, function(lvl) {
              sapply(1:max(1, x$nranef[lvl]), function(i)
                paste0("invD_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
              )}))),
        if (isTRUE(D_main))
          unlist(sapply(ranef_info_main, function(x)
            sapply(x$lvls, function(lvl) {
              sapply(1:max(1, x$nranef[lvl]), function(i)
                paste0("D_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
              )}))),
        if (isTRUE(RinvD_main))
          unlist(sapply(ranef_info_main, function(x)
            sapply(x$lvls, function(lvl) {
            paste0("RinvD_", x$varname, "_", lvl, "[", 1:max(1, x$nranef[lvl]),
                   ",", 1:max(1, x$nranef[lvl]), "]")
            })))
      )
    },

    if (isTRUE(alphas)) "alpha",
    if (isTRUE(tau_other) & any(sapply(list_other, "[[", 'family') %in%
                        c("gaussian", "lognorm", "gamma", "beta")))
      paste0("tau_", names(list_other)[
        sapply(list_other, "[[", 'family') %in% c("gaussian", "lognorm",
                                                  "gamma", "beta")]),

    if (isTRUE(gamma_other) & any(sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")))
      paste0("gamma_", names(list_other)[
        sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")]),

    if (isTRUE(delta_other) & any(sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")))
      paste0("delta_", names(list_other)[
        sapply(list_other, "[[", 'modeltype') %in% c("clm", "clmm")]),

    if (any(!sapply(ranef_info_other, is.null))) {
      c(
        if (isTRUE(ranef_other)) sapply(ranef_info_other, function(k)
          paste0('b_', k$varname, "_", k$lvls)),
        if (isTRUE(invD_other))
          unlist(sapply(ranef_info_other, function(x)
            sapply(x$lvls, function(lvl) {
              sapply(1:max(1, x$nranef[lvl]), function(i)
                paste0("invD_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
              )}))),
        if (isTRUE(D_other))
          unlist(sapply(ranef_info_other, function(x)
            sapply(x$lvls, function(lvl) {
              sapply(1:max(1, x$nranef[lvl]), function(i)
                paste0("D_", x$varname, "_", lvl, "[", 1:i, ",", i, "]")
              )}))),
        if (isTRUE(RinvD_other))
          unlist(sapply(ranef_info_other, function(x)
            sapply(x$lvls, function(lvl) {
              paste0("RinvD_", x$varname, "_", lvl, "[", 1:max(1, x$nranef[lvl]),
                     ",", 1:max(1, x$nranef[lvl]), "]")
            })))
      )
    },

    # if (ppc) paste0('ppc_', c(y_name, names(models))),
    other,
    if (isTRUE(imps)) {
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
