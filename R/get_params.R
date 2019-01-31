
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
                       alphas = NULL, tau_imp = NULL, gamma_imp = NULL,
                       delta_imp = NULL, other = NULL, ...){

  y_name <- colnames(Mlist$y)

  if (missing(family))
    family <- attr(analysis_type, "family")

  if (analysis_main) {
    if (is.null(betas)) betas <- TRUE
    if (family %in% c("gaussian", "gamma", 'weibull')) {
      if (is.null(sigma_y)) sigma_y <- TRUE
    }
    if (family %in% c('ordinal')) {
      gamma_y <- TRUE
    }
  }
  if (analysis_type %in% c("lme", "glme", "clmm")) {
    if (analysis_main & is.null(D)) D <- TRUE
  }


  if (analysis_random) {
    if (is.null(ranef)) ranef <- TRUE
    if (is.null(invD)) invD <- TRUE
    if (is.null(D)) D <- TRUE
    if (is.null(RinvD) & Mlist$nranef > 1) RinvD <- TRUE
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
              if (gamma_y) paste0("gamma_", y_name),
              if (delta_y) paste0("delta_", y_name),
              if (tau_y) paste0("tau_", y_name),
              if (sigma_y) {
                if (family == 'weibull')
                  paste0("shape_", y_name)
                else
                  paste0("sigma_", y_name)
              },
              if (alphas) "alpha",
              if (tau_imp & any(models %in% c("norm", "lognorm", "gamma", "beta"))) {
                paste0("tau_", names(models)[models %in% c("norm", "lognorm", "gamma", "beta")])
              },
              if (gamma_imp & any(models == "cumlogit")) {
                paste0("gamma_", names(models)[models == "cumlogit"])
              },
              if (delta_imp & any(models == "cumlogit")) {
                paste0("delta_", names(models)[models == "cumlogit"])
              },
              # if (ppc) paste0('ppc_', c(y_name, names(models))),
              other
  )

  if (analysis_type %in% c("lme", "glme", "clmm")) {
    params <- c(params,
                if (ranef) "b",
                if (invD) unlist(sapply(1:Mlist$nranef, function(x)
                  paste0("invD[", 1:x, ",", x,"]"))),
                if (D) unlist(sapply(1:Mlist$nranef, function(x)
                  paste0("D[", 1:x, ",", x,"]"))),
                if (RinvD) paste0("RinvD[", 1:Mlist$nranef, ",", 1:Mlist$nranef,"]")
    )
  }

  if (imps) {
    repl_list <- lapply(imp_par_list, function(x)
      if (x$dest_mat == 'Xtrafo') x[c('dest_col', 'trafo_cols')]
    )

    Xc_NA <- if (any(is.na(Mlist$Xc))) which(is.na(Mlist$Xc), arr.ind = TRUE)
    if (!is.null(Xc_NA))
      Xc_NA <- Xc_NA[Xc_NA[, 2] %in% which(colSums(!is.na(Mlist$Xc)) > 0), , drop = FALSE]

    Xcat_NA <- if (any(is.na(Mlist$Xcat))) which(is.na(Mlist$Xcat), arr.ind = TRUE)
    Xtrafo_NA <- if (any(is.na(Mlist$Xtrafo))) which(is.na(Mlist$Xtrafo), arr.ind = TRUE)

    Xl_NA <- if (any(is.na(Mlist$Xl))) which(is.na(Mlist$Xl), arr.ind = TRUE)

    if (!is.null(Xl_NA))
      Xl_NA <- Xl_NA[Xl_NA[, 2] %in% which(colSums(!is.na(Mlist$Xl)) > 0), , drop = FALSE]

    Z_NA <- if (any(is.na(Mlist$Z))) which(is.na(Mlist$Z), arr.ind = TRUE)

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

    params <- c(params,
                if (!is.null(Xc_NA))
                  paste0("Xc[", apply(Xc_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Xl_NA))
                  paste0("Xl[", apply(Xl_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Z_NA))
                  paste0("Z[", apply(Z_NA, 1, paste, collapse = ","), "]"),
                if (!is.null(Xtrafo_NA))
                  c(paste0("Xtrafo[", apply(Xtrafo_NA, 1, paste, collapse = ","), "]"),
                    paste0("Xc[", apply(Xtrafo_NA_Xc, 1, paste, collapse = ","), "]")),
                if (!is.null(Xcat_NA))
                  paste0("Xcat[", apply(Xcat_NA, 1, paste, collapse = ","), "]")
    )
  }

  return(params)
}
