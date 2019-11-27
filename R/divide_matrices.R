# split the data into matrices and obtain other relevant info for the further steps

divide_matrices <- function(data, fixed, analysis_type, random = NULL, auxvars = NULL,
                            scale_vars = NULL, refcats = NULL, models, warn = TRUE,
                            mess = TRUE, ppc = TRUE, ridge = FALSE, timevar = NULL, ...) {

  # general design matrix ------------------------------------------------------

  # extract the id variable from the random effects formula
  id <- extract_id(random, warn = warn)

  # define/identify groups/clusters in the data
  groups <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }

  outcomes <- extract_outcome_data(fixed, data)
  fixed <- outcomes$fixed

  # # extract the outcome data from the fixed effects formula
  # outnam <- outcomes <- extract_outcome(fixed)
  #
  # for (i in seq_along(outnam)) {
  #   if (survival::is.Surv(eval(parse(text = names(outnam[i])), env = data))) {
  #     outcomes[[i]] <- as.data.frame.matrix(eval(parse(text = names(outnam[i])), env = data))
  #     attr(outnam[[i]], "type") <- "survival"
  #   } else {
  #     outcomes[[i]] <- as.data.frame(eval(parse(text = names(outnam[i])), env = data))
  #     names(outcomes[[i]]) <- outnam[i]
  #     attr(outnam[[i]], "type") <- "other"
  #   }
  # }
  #
  # if (analysis_type %in% c('survreg', 'coxph', 'JM')) {
  #   out <- outcomes[[which(sapply(outnam, 'attr', 'type') ==  'survival')]]
  #
  #   if (ncol(out) == 2) {
  #     out <- cbind(data[, id, drop = FALSE], out, rownr = 1:nrow(out))
  #
  #     out_lr <- do.call(rbind, lapply(split(out, out[, id]), function(x) {
  #
  #       x[nrow(x), ]
  #     }))
  #     y <- out_lr[, "time", drop = FALSE]
  #     event <- out_lr[, "status", drop = FALSE]
  #     survrow <- out_lr[, 'rownr']
  #   } else if (ncol(out) == 3) {
  #     out <- cbind(id = data[, id], out, rownr = 1:nrow(out))
  #
  #     out_lr <- do.call(rbind, lapply(split(out, out[, id]), function(x) {
  #
  #       if (sum(x$status, na.rm = TRUE) > 1)
  #         stop("At least one subject has multiple events.")
  #
  #       x[nrow(x), ]
  #     }))
  #     y <- out_lr[, 'stop', drop = FALSE]
  #     event <- out_lr[, 'status', drop = FALSE]
  #     survrow <- out_lr[, 'rownr']
  #   } else {
  #     stop("Expected two or three outcome variables.")
  #   }
  #   if (!is.null(timevar)) names(y) <- timevar
  #   else timevar <- names(y)
  #
  # } else {
  #   y <- data[, unlist(outnam), drop = FALSE]
  #   event <- NULL
  # }


  # random_combined_nogroup <- if(!is.null(random))
  #   as.formula(paste("~",
  #                    paste(unique(unlist(lapply(remove_grouping(random),
  #                                               function(x) if(!is.null(x)) attr(terms(x), 'term.labels'))
  #                    )), collapse = " + ")
  #   ))


  # * preliminary design matrix ------------------------------------------------
  X <- model.matrix_combi(fixed, data)

  # variables that do not have a main effect in fixed are added to the auxiliary variables
  trafosX <- extract_fcts(formula = fixed, data, random = random, complete = TRUE)
  add_to_aux <- trafosX$var[which(!trafosX$var %in% c(colnames(X), all_vars(auxvars)))]

  if (length(add_to_aux) > 0 & !is.null(models))
    auxvars <- as.formula(paste(ifelse(is.null(auxvars), "~ ",
                                       paste0(deparse(auxvars, width.cutoff = 500), " + ")),
                          paste0(unique(add_to_aux), collapse = " + ")))

  # fixed effects design matrices
  # fixed2 <- as.formula(paste(c(sub(":", "*", deparse(fixed_combined, width.cutoff = 500),
  #                                  fixed = TRUE),
  #                              auxvars[[2]]), collapse = " + "))

  fcts_all <- extract_fcts(c(fixed, auxvars), data, random = random, complete = TRUE)


  # * reference categories -----------------------------------------------------
  refs <- get_refs(c(fixed, auxvars), data, refcats)

  for (i in names(refs)) {
    data[, i] <- relevel(factor(data[, i], ordered = FALSE),
                         as.character(refs[[i]]))
  }


  # * final combined design matrix ---------------------------------------------
  X2 <- model.matrix_combi(c(fixed, auxvars), data)


  # Z --------------------------------------------------------------------------
  # random effects design matrix
  Z <- if (!is.null(random)) {
    model.matrix_combi(remove_grouping(random), data)
  }


  # Xc and Xic -----------------------------------------------------------------
  tvar <- apply(X2, 2, check_tvar, groups)

  # make sure that interactions in which at least one partner is time-varying
  # are also recognized as time-varying
  inter <- grep(":", names(tvar), fixed = TRUE, value = TRUE)
  if (length(inter) > 0)
    tvar[inter[sapply(strsplit(inter, ':'), function(k) any(tvar[k]))]] <- TRUE


  # time-constant part of X
  Xcross <- X2[match(unique(groups), groups), !tvar, drop = FALSE]
  interact <- grep(":", colnames(Xcross), fixed = TRUE, value = TRUE)

  Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = FALSE]

  Xic <- if (length(interact) > 0) {
    Xcross[, interact, drop = FALSE]
  }

  if (!is.null(Xic)) Xic <- Xic * NA

  # re-order columns in Xc -----------------------------------------------------
  Xc <- Xc[, sort_cols(Xc, fcts_all, auxvars), drop = FALSE]

  # * update Z -------------------------------------------------
  Z2 <- Z
  if (!is.null(Z)) {
    Z[, na.omit(match(colnames(Xc)[-1], colnames(Z)))] <- 1
    colnames(Z)[na.omit(match(colnames(Xc)[-1], colnames(Z)))] <- 'placeholder'
  }

  # Xl and Xil -----------------------------------------------------------------
  Xlong <- if (sum(!names(tvar)[tvar] %in% colnames(Z)) > 0) {
    X2[, which(tvar & !names(tvar) %in% colnames(Z)), drop = FALSE]
  }

  # * hc_list -------------------------------------------------------
  hc_list <- if (!is.null(random))
    get_hc_list(X2, Xc, Xic, Z, Z2, Xlong)

  # * Xlong --------------------------------------------------------------------
  if (!is.null(Xlong)) {
    linteract <- if (any(grepl(":", colnames(Xlong), fixed = TRUE))) {
      grep(":", colnames(Xlong), fixed = TRUE, value = TRUE)
    }

    Xl <- if (any(!colnames(Xlong) %in% linteract)) {
      Xl <- Xlong[, !colnames(Xlong) %in% linteract, drop = FALSE]
      Xl <- Xl[, sort_cols(Xl, fcts_all, auxvars), drop = FALSE]
    }

    hc_interact <- unlist(sapply(hc_list, function(x) {
      names(x)[sapply(x, attr, 'matrix') == 'Xc']
    }))

    Xil <- if (!is.null(linteract) & any(!linteract %in% hc_interact)) {
      Xlong[, linteract[!linteract %in% hc_interact], drop = FALSE]
    }

    if (!is.null(Xil)) Xil <- Xil * NA

  } else {
    Xl <- Xil <- NULL
  }


  # Xtrafo ---------------------------------------------------------------------
  fcts_mis <- extract_fcts(c(fixed, auxvars), data, random = random, complete = FALSE)

  if (any(fcts_mis$type %in% c('ns', 'bs')))
    stop("Splines are currently not implemented for incomplete variables.",
         call. = FALSE)

  # if (any(fcts_mis$type %in% c('ns')))
  #   stop(paste0("Natural cubic splines are not implemented for incomplete variables. ",
  #               "Please use B-splines (using ", dQuote("bs()"), ") instead."),
  #        call. = FALSE)

  if (!is.null(fcts_mis)) {
    fmla_trafo <- as.formula(
      paste("~", paste0(unique(fcts_mis$var), collapse = " + "))
    )

    Xt <- model.matrix(fmla_trafo,
                       model.frame(fmla_trafo, data, na.action = na.pass)
    )[, -1, drop = FALSE]

    Xtrafo_tvar <- apply(Xt, 2, check_tvar, groups)

    Xtrafo <- if (any(!Xtrafo_tvar)) Xt[match(unique(groups), groups), !Xtrafo_tvar, drop = FALSE]
    Xltrafo <- if (any(Xtrafo_tvar)) Xt[, Xtrafo_tvar, drop = FALSE]
  } else {
    Xtrafo <- Xltrafo <- NULL
  }

  if (!is.null(Xtrafo)) {
    Xc[, match(as.character(fcts_mis$X_var), colnames(Xc))] <- NA
  }

  if (!is.null(Xltrafo)) {
    Xl[, match(as.character(fcts_mis$X_var), colnames(Xl))] <- NA
    Z[, match(as.character(fcts_mis$X_var), colnames(Z))] <- NA
  }



  # Xcat & Xlcat ---------------------------------------------------------------
  # make filter variables:

  # - variable relevant?
  infmla <- names(data) %in% all_vars(c(fixed, auxvars))
  # - variabe incomplete?
  misvar <- colSums(is.na(data[, infmla, drop = FALSE])) > 0
  # - variabe categorical with >2 categories?
  catvars <- sapply(colnames(data[infmla]),
                    function(i) i %in% names(refs) && length(levels(refs[[i]])) > 2)

  tvar_data <- sapply(data[, infmla, drop = FALSE], check_tvar, groups)

  misvar_long <- if (any(!tvar_data & misvar)) TRUE else misvar

  # select names of relevant variables
  cat_vars_base <- names(data[, infmla])[misvar & catvars & !tvar_data]
  cat_vars_long <- names(data[, infmla])[misvar_long & catvars & tvar_data]

  # match them to the position in Xc
  cat_vars_base <- sapply(cat_vars_base, match_positions,
                          data[, infmla], colnames(Xc), simplify = FALSE)


  Xcat <- if (length(cat_vars_base) > 0) {
    data[match(unique(groups), groups), names(cat_vars_base), drop = FALSE]
  }

  if (!is.null(Xcat)) {
    Xc[, unlist(sapply(cat_vars_base, names))] <- NA
  }

  Xlcat <- if (length(cat_vars_long) > 0) {
    data[, cat_vars_long, drop = FALSE]
  }

  if (!is.null(Xlcat)) {
    Xl[, match(unlist(lapply(refs[cat_vars_long], attr, 'dummies')), colnames(Xl))] <- NA
    Z[, match(unlist(lapply(refs[cat_vars_long], attr, 'dummies')), colnames(Z))] <- NA
  }


  # scaling --------------------------------------------------------------------
  if (is.null(scale_vars)) {
    scale_vars <- find_continuous(c(fixed, auxvars), data)

    compl_fcts_vars <- fcts_all$X_var[fcts_all$type != "identity" &
                                        colSums(is.na(data[fcts_all$var])) == 0]

    excl <- grep("[[:alpha:]]*\\(", scale_vars, value = TRUE)
    excl <- c(excl, unique(fcts_mis$X_var))
    excl <- excl[!excl %in% compl_fcts_vars]

    scale_vars <- scale_vars[which(!scale_vars %in% excl)]
    if (length(scale_vars) == 0) scale_vars <- NULL
  }


  ncat <- if (analysis_type %in% c('clmm', 'clm'))
    length(unique(unlist(y)))

  N <- length(unique(groups))


  XXnam <- lapply(fixed, function(x) colnames(model.matrix(x, data)))


  if (analysis_type %in% c('coxph', "JM")) {
    XXnam[[which(sapply(outnam, "attr", "type") == 'survival')]] <-
    XXnam[[which(sapply(outnam, "attr", "type") == 'survival')]][-1]

    if (any(names(outnam) %in% names(models)[models %in% "clmm"])) {
      for (i in which(names(outnam) %in% names(models)[models %in% "clmm"]))
        XXnam[[i]] <- XXnam[[i]][-1]
    }
  }

  if (analysis_type %in% c('clm', 'clmm'))
    XXnam[[1]] <- XXnam[[1]][-1]


  cols_main <- lapply(XXnam, function(XX) {
    cml <- list(Xc = c(na.omit(match(XX[!XX %in% names(hc_list)], colnames(Xc)))),
         Xl = if (!is.null(Xl)) c(na.omit(match(XX, colnames(Xl)))),
         Xic = if (!is.null(Xic)) c(na.omit(match(XX, colnames(Xic)))),
         Xil = if (!is.null(Xil)) c(na.omit(match(XX, colnames(Xil)))),
         Z = if (!is.null(Z)) c(na.omit(match(XX, colnames(Z))))
    )
    sapply(cml, function(x) if (length(x) > 0) x)
  })

  names_main <- sapply(names(cols_main), function(i) {
    mapply(function(cols, mat) {
      colnames(mat)[cols]
    }, cols = cols_main[[i]],
    mat = list(Xc, Xl, Xic, Xil, Z))
  }, simplify = FALSE)

  return(list(outcomes = outcomes$outcomes, #event = event,
              Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat, Xlcat = Xlcat,
              Xtrafo = Xtrafo, Xltrafo = Xltrafo, Z = Z,
              cols_main = cols_main, names_main = names_main,
              trafos = fcts_all, hc_list = hc_list, refs = refs, timevar = timevar,
              auxvars = auxvars, groups = groups, scale_vars = scale_vars,
              ncat = ncat,
              N = N, ppc = ppc, ridge = ridge, nranef = ncol(Z2),
              survrow = if(exists("survrow")) survrow))
}
