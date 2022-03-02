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

  args <- as.list(match.call())[-1L]
  fmls <- formals()
  args <- c(args, fmls[setdiff(names(fmls), names(args))])


  # update analysis_main parameters
  for (k in c(
    "betas",
    "sigma_main",
    "tau_main",
    "gamma_main",
    "shape_main",
    "D_main",
    "basehaz"
  )) {
    args[[k]] <- if (is.null(args[[k]])) {
      isTRUE(args$analysis_main)
    } else {
      args[[k]]
    }
  }

  # update analysis_random parameters
  for (k in c("D_main", "invD_main", "RinvD_main", "ranef_main")) {
    args[[k]] <- if (is.null(args[[k]])) {
      isTRUE(args$analysis_random)
    } else {
      args[[k]]
    }
  }

  # update other_models parameters
  for (k in c(
    "alphas",
    "sigma_other",
    "tau_other",
    "gamma_other",
    "shape_other",
    "D_other"
  )) {
    args[[k]] <- if (is.null(args[[k]])) {
      isTRUE(args$other_models)
    } else {
      args[[k]]
    }
  }

  # imps
  impvals <- if (isTRUE(args$imps)) {
    unlist(unname(lapply(names(Mlist$M), function(k) {
      if (any(is.na(Mlist$M[[k]]))) {
        misvals <- which(is.na(Mlist$M[[k]]), arr.ind = TRUE)
        relevant_cols <- which(colnames(Mlist$M[[k]]) %in% names(Mlist$data))
        misvals <- misvals[misvals[, "col"] %in% relevant_cols, ]

        apply(misvals, 1L, function(x) {
          paste0(k, "[", x[1L], ",", x[2L], "]")
        })
      }
    })))
  }


  # collect parameters ---------------------------------------------------------
  params <- c(
    get_modelpars(info_list, Mlist = Mlist, args = args, set = "main"),
    get_modelpars(info_list, Mlist = Mlist, args = args, set = "other"),
    get_ranefpars(info_list, Mlist = Mlist, args, set = "main"),
    get_ranefpars(info_list, Mlist = Mlist, args, set = "other"),
    other,
    impvals
  )

  unname(params)
}


get_modelpars <- function(info_list, Mlist, args, set = "main") {

  sublist <- if (set == "main") {
    info_list[names(info_list) %in% names(Mlist$fixed)]
  } else {
    info_list[!names(info_list) %in% names(Mlist$fixed)]
  }

  modeltypes <- cvapply(sublist, "[[", "modeltype")
  families <- nlapply(sublist, "[[", "family")


  params <- NULL


  # regression coefficients alpha & beta
  coefnam <- switch(set,
                    main = "betas",
                    other = "alphas")

  if (args[[coefnam]] &
      any(grepl(paste0("^", gsub("s$", "", coefnam), "\\b"),
                do.call(rbind, get_coef_names(info_list))$coef
      )))
    params <- c(params, gsub("s$", "", coefnam))


  # parameters basehaz
  if (args$basehaz & any(modeltypes %in% c("coxph", "JM"))) {
    survnams <- cvapply(sublist[modeltypes %in% c("coxph", "JM")],
                        "[[", "varname")
    params <- c(params, paste0("beta_Bh0_", survnams))
  }

  # parameters gamma & delta
  if (any(modeltypes %in% c("clm", "clmm"))) {
    ord_mods <- names(sublist)[modeltypes %in% c("clm", "clmm")]
    params <- c(params,
                if (args[[paste0("gamma_", set)]]) paste0("gamma_", ord_mods),
                if (isTRUE(args[[paste0("delta_", set)]]))
                  paste0("delta_", ord_mods)
    )
  }


  # parameters sigma & tau
  sigvars <- if (args[[paste0("sigma_", set)]]) {
    names(sublist)[families %in% c("gaussian", "Gamma", "lognorm")]
  }
  tauvars <- if (args[[paste0("tau_", set)]]) {
    setdiff(names(sublist)[families %in%
                             c("gaussian", "Gamma", "lognorm", "beta")],
            sigvars)
  }

  params <- c(params,
              if (length(sigvars) > 0L) paste0("sigma_", sigvars),
              if (length(tauvars) > 0L) paste0("tau_", tauvars))


  if (any(modeltypes %in% "survreg") &
      isTRUE(args$analysis_main) &
      set == "main")
    params <- c(params,
                paste0("shape_", cvapply(sublist[modeltypes %in% "survreg"],
                                         "[[", "varname")))

  params
}


get_ranefpars <- function(info_list, Mlist, args, set = "main") {

  sublist <- if (set == "main") {
    info_list[names(info_list) %in% names(Mlist$fixed)]
  } else {
    info_list[!names(info_list) %in% names(Mlist$fixed)]
  }

  ranef_info <- lapply(sublist, function(x)
    if (!is.null(x$hc_list))
      list(varname = x$varname,
           lvls = names(x$hc_list$hcvars),
           nranef = x$nranef,
           rd_vcov = x$rd_vcov)
  )

  if (all(lvapply(ranef_info, is.null))) {
    return(NULL)
  }

  params <- NULL

  # ranef
  if (args[[paste0("ranef_", set)]]) {

    b_block_indep <- lapply(names(ranef_info), function(var) {
      lapply(names(ranef_info[[var]]$rd_vcov), function(lvl) {
        if (isTRUE(ranef_info[[var]]$rd_vcov[[lvl]] != "full")) {
          paste0("b_", var, "_", lvl)
        }
      })
    })

    b_full <- lapply(names(Mlist$rd_vcov), function(lvl) {
      lapply(
        which(names(Mlist$rd_vcov[[lvl]]) == "full"),
        function(k) {
          nam <- attr(Mlist$rd_vcov[[lvl]][[k]], "name")
          paste0("b", nam, "_", lvl)
        })
    })

    params <- c(params,
                unlist(b_block_indep),
                unlist(b_full)
    )
  }

  # invD
  if (args[[paste0("invD_", set)]]) {
    invD_full <- lapply(names(Mlist$rd_vcov), function(lvl) {
      lapply(
        which(names(Mlist$rd_vcov[[lvl]]) == "full"),
        function(k) {
          rd_vcov <- Mlist$rd_vcov[[lvl]][[k]]
          nranef <- sapply(attr(rd_vcov, "ranef_index"),
                           function(nr) eval(parse(text = nr)))
          get_uptri_elmts(mat = "invD",
                          name = paste0(attr(rd_vcov, "name"), "_", lvl),
                          dim = max(unlist(nranef)))
        })
    })

    invD_block_indep <- lapply(ranef_info, function(x) {
      lapply(x$lvls, function(lvl) {
        if (isTRUE(x$rd_vcov[[lvl]] != "full")) {
          get_uptri_elmts(mat = "invD",
                          dim = x$nranef[lvl],
                          name = paste0("_", x$varname, "_", lvl)
          )
        }
      })
    })

    params <- c(params,
                unlist(invD_block_indep),
                unlist(invD_full)
    )
  }

  # D
  if (args[[paste0("D_", set)]]) {
    D_full <- lapply(names(Mlist$rd_vcov), function(lvl) {
      lapply(
        which(names(Mlist$rd_vcov[[lvl]]) == "full"),
        function(k) {
          rd_vcov <- Mlist$rd_vcov[[lvl]][[k]]
          nranef <- sapply(attr(rd_vcov, "ranef_index"),
                           function(nr) eval(parse(text = nr)))
          get_uptri_elmts(mat = "D",
                          name = paste0(attr(rd_vcov, "name"), "_", lvl),
                          dim = max(unlist(nranef)))
        })
    })

    D_block_indep <- lapply(ranef_info, function(x) {
      lapply(x$lvls, function(lvl) {
        if (isTRUE(x$rd_vcov[[lvl]] != "full")) {
          get_uptri_elmts(mat = "D",
                          dim = x$nranef[lvl],
                          name = paste0("_", x$varname, "_", lvl)
          )
        }
      })
    })

    params <- c(params,
                unlist(D_block_indep),
                unlist(D_full)
    )
  }

  # RinvD
  if (args[[paste0("RinvD_", set)]]) {

    RinvD_full <- lapply(names(Mlist$rd_vcov), function(lvl) {
      lapply(
        which(names(Mlist$rd_vcov[[lvl]]) == "full"),
        function(k) {
          rd_vcov <- Mlist$rd_vcov[[lvl]][[k]]
          nranef <- sapply(attr(rd_vcov, "ranef_index"),
                           function(nr) eval(parse(text = nr)))
          get_diag_elmts(mat = "RinvD",
                         name = paste0(attr(rd_vcov, "name"), "_", lvl),
                         dim = max(unlist(nranef)))
        })
    })

    RinvD_block_indep <- lapply(ranef_info, function(x) {
      lapply(x$lvls, function(lvl) {
        if (x$nranef[lvl] > 1) {
          if (isTRUE(x$rd_vcov[[lvl]] == "blockdiag")) {
            paste0("RinvD_", x$varname, "_", lvl,
                   "[", seq.int(max(1L, x$nranef[lvl])), ",",
                   seq.int(max(1L, x$nranef[lvl])), "]")
          }
        }
      })
    })

    params <- c(params,
                unlist(RinvD_block_indep),
                unlist(RinvD_full))
  }

  params
}


get_uptri_elmts <- function(mat, dim, name) {
  unlist(
    lapply(seq.int(max(1L, dim)), function(i) {
      paste0(mat, name, "[", 1L:i, ",", i, "]")
    })
  )
}

get_diag_elmts <- function(mat, dim, name) {
  paste0(mat, name, "[", seq.int(dim), ",", seq.int(dim), "]")
}
