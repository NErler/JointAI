# split the data into matrices and obtain other relevant info for the further steps

# divide_matrices_old <- function(data, fixed, analysis_type, random = NULL, auxvars = NULL,
#                             scale_vars = NULL, refcats = NULL, models, warn = TRUE,
#                             mess = TRUE, ppc = TRUE, ridge = FALSE, timevar = NULL, ...) {
#
#   # id's and groups ------------------------------------------------------------
#   # extract the id variable from the random effects formula
#   id <- extract_id(random, warn = warn)
#
#   # define/identify groups/clusters in the data
#   groups <- if (!is.null(id)) {
#     data[, id]
#   } else {
#     1:nrow(data)
#   }
#
#
#   # outcome --------------------------------------------------------------------
#   # extract the outcomes from the fixed effects formulas
#   outcomes <- extract_outcome_data(fixed, data)
#   Y <- outcomes_to_mat(outcomes)
#
#   # name the elements of fixed:
#   fixed <- outcomes$fixed
#
#
#   # covariates -----------------------------------------------------------------
#   # * preliminary design matrix ------------------------------------------------
#   X <- model.matrix_combi(fixed, data)
#
#   M <- cbind(Y, X[, setdiff(colnames(X), colnames(Y))])
#   tvarM <- apply(M, 2, check_tvar, groups)
#
#   Mc <- if(any(!tvarM)) M[, !tvarM]
#   Ml <- if(any(tvarM)) M[, tvarM]
#
#   # variables that do not have a main effect in fixed are added to the auxiliary variables
#   trafos <- extract_fcts(fixed = fixed, data, random = random, complete = TRUE)
#   # add_to_aux <- trafosX$var[which(!trafosX$var %in% c(colnames(X), all_vars(auxvars)))]
#
#   # if (length(add_to_aux) > 0 & !is.null(models))
#   #   auxvars <- as.formula(paste(ifelse(is.null(auxvars), "~ ",
#   #                                      paste0(deparse(auxvars, width.cutoff = 500), " + ")),
#   #                               paste0(unique(add_to_aux), collapse = " + ")))
#
#   # reference categories -----------------------------------------------------
#   refs <- get_refs(c(fixed, auxvars), data, refcats)
#
#   for (i in names(refs)) {
#     data[, i] <- relevel(factor(data[, i], ordered = FALSE),
#                          as.character(refs[[i]]))
#   }
#
#   # * final combined design matrix ---------------------------------------------
#   X2 <- model.matrix_combi(c(fixed, auxvars), data)
#   X2 <- X2[, !colnames(X2) %in% colnames(Y), drop = FALSE]
#
#   # Yc and Yic -----------------------------------------------------------------
#   tvarY <- apply(Y, 2, check_tvar, groups)
#
#   # time-constant part of Y
#   Yc <- Y[match(unique(groups), groups), !tvarY, drop = FALSE]
#   Yl <- Y[, tvarY, drop = FALSE]
#   if(ncol(Yc) == 0) Yc <- NULL
#   if(ncol(Yl) == 0) Yl <- NULL
#
#
#   # Xc and Xic -----------------------------------------------------------------
#   # identify time-varying (level-1) variables
#   tvarX <- apply(X2, 2, check_tvar, groups)
#
#   # make sure that interactions in which at least one partner is time-varying
#   # are also recognized as time-varying
#   inter <- grep(":", names(tvarX), fixed = TRUE, value = TRUE)
#   if (length(inter) > 0)
#     tvarX[inter[sapply(strsplit(inter, ':'),
#                        function(k) any(na.omit(c(tvarY[k], tvarX[k]))))]] <- TRUE
#
#
#   # time-constant part of X
#   Xcross <- X2[match(unique(groups), groups), !tvarX, drop = FALSE]
#   interact <- grep(":", colnames(Xcross), fixed = TRUE, value = TRUE)
#
#   Xc <- Xcross[, !colnames(Xcross) %in% interact, drop = FALSE]
#
#   Xic <- if (length(interact) > 0) {
#     Xcross[, interact, drop = FALSE]
#   }
#
#   if (!is.null(Xic)) Xic <- Xic * NA
#
#
#   # re-order columns in Xc -----------------------------------------------------
#   # identify functions in the model formulas
#   fcts_all <- extract_fcts(c(fixed, auxvars), data, random = random, complete = TRUE)
#
#   Xc <- Xc[, sort_cols(Xc, fcts_all, auxvars), drop = FALSE]
#
#
#   # * Xlong --------------------------------------------------------------------
#   Xlong <- if (any(tvarX)) X2[, tvarX, drop = FALSE]
#
#   if (!is.null(Xlong)) {
#     linteract <- if (any(grepl(":", colnames(Xlong), fixed = TRUE))) {
#       grep(":", colnames(Xlong), fixed = TRUE, value = TRUE)
#     }
#
#     Xl <- if (any(!colnames(Xlong) %in% linteract)) {
#       Xl <- Xlong[, !colnames(Xlong) %in% linteract, drop = FALSE]
#       Xl <- Xl[, sort_cols(Xl, fcts_all, auxvars), drop = FALSE]
#     }
#
#     Xil <- if (!is.null(linteract)){
#       Xlong[, linteract, drop = FALSE]
#     }
#
#     if (!is.null(Xil)) Xil <- Xil * NA
#
#   } else {
#     Xl <- Xil <- NULL
#   }
#
#
#   # Xtrafo ---------------------------------------------------------------------
#   fcts_mis <- extract_fcts(c(fixed, auxvars), data, random = random, complete = FALSE)
#
#   if (any(fcts_mis$type %in% c('ns', 'bs')))
#     stop("Splines are currently not implemented for incomplete variables.",
#          call. = FALSE)
#
#   # if (any(fcts_mis$type %in% c('ns')))
#   #   stop(paste0("Natural cubic splines are not implemented for incomplete variables. ",
#   #               "Please use B-splines (using ", dQuote("bs()"), ") instead."),
#   #        call. = FALSE)
#
#   if (!is.null(fcts_mis)) {
#     fmla_trafo <- as.formula(
#       paste("~", paste0(unique(fcts_mis$var), collapse = " + "))
#     )
#
#     Xt <- model.matrix(fmla_trafo,
#                        model.frame(fmla_trafo, data, na.action = na.pass)
#     )[, -1, drop = FALSE]
#
#     Xtrafo_tvar <- apply(Xt, 2, check_tvar, groups)
#
#     Xtrafo <- if (any(!Xtrafo_tvar)) Xt[match(unique(groups), groups), !Xtrafo_tvar, drop = FALSE]
#     Xltrafo <- if (any(Xtrafo_tvar)) Xt[, Xtrafo_tvar, drop = FALSE]
#   } else {
#     Xtrafo <- Xltrafo <- NULL
#   }
#
#   if (!is.null(Xtrafo)) {
#     Xc[, match(as.character(fcts_mis$X_var), colnames(Xc))] <- NA
#   }
#
#   if (!is.null(Xltrafo)) {
#     Xl[, match(as.character(fcts_mis$X_var), colnames(Xl))] <- NA
#     # Z[, match(as.character(fcts_mis$X_var), colnames(Z))] <- NA
#   }
#
#
#
#   # Xcat & Xlcat ---------------------------------------------------------------
#   # make filter variables:
#
#   # - variable relevant?
#   infmla <- names(data) %in% all_vars(c(fixed, auxvars))
#   # - variabe incomplete?
#   misvar <- colSums(is.na(data[, infmla, drop = FALSE])) > 0
#   # - variabe categorical with >2 categories?
#   catvars <- sapply(colnames(data[infmla]),
#                     function(i) i %in% names(refs) && length(levels(refs[[i]])) > 2)
#
#   tvar_data <- sapply(data[, infmla, drop = FALSE], check_tvar, groups)
#
#   misvar_long <- if (any(!tvar_data & misvar)) TRUE else misvar
#
#   # select names of relevant variables
#   cat_vars_base <- names(data[, infmla])[misvar & catvars & !tvar_data]
#   cat_vars_long <- names(data[, infmla])[misvar_long & catvars & tvar_data]
#
#   # match them to the position in Xc
#   cat_vars_base <- sapply(cat_vars_base, match_positions,
#                           data[, infmla], colnames(Xc), simplify = FALSE)
#
#
#   Xcat <- if (length(cat_vars_base) > 0) {
#     data[match(unique(groups), groups), names(cat_vars_base), drop = FALSE]
#   }
#
#   if (!is.null(Xcat)) {
#     Xc[, unlist(sapply(cat_vars_base, names))] <- NA
#   }
#
#   Xlcat <- if (length(cat_vars_long) > 0) {
#     data[, cat_vars_long, drop = FALSE]
#   }
#
#   if (!is.null(Xlcat)) {
#     Xl[, match(unlist(lapply(refs[cat_vars_long], attr, 'dummies')), colnames(Xl))] <- NA
#     # Z[, match(unlist(lapply(refs[cat_vars_long], attr, 'dummies')), colnames(Z))] <- NA
#   }
#
#
#   # scaling --------------------------------------------------------------------
#   if (is.null(scale_vars)) {
#     scale_vars <- find_continuous(c(fixed, auxvars), data)
#
#     compl_fcts_vars <- fcts_all$X_var[fcts_all$type != "identity" &
#                                         colSums(is.na(data[fcts_all$var])) == 0]
#
#     excl <- grep("[[:alpha:]]*\\(", scale_vars, value = TRUE)
#     excl <- c(excl, unique(fcts_mis$X_var))
#     excl <- excl[!excl %in% compl_fcts_vars]
#
#     scale_vars <- scale_vars[which(!scale_vars %in% excl)]
#     if (length(scale_vars) == 0) scale_vars <- NULL
#   }
#
#
#
#   # Hierarchical centering -----------------------------------------------------
#   hc_list <- HC(fixed, random, data,
#                 Ms = list(Xc = Xc, Xl = Xl, Xic = Xic, Xil = Xil, Yc = Yc, Yl = Yl))
#
#
#   ncat <- if (analysis_type %in% c('clmm', 'clm'))
#     length(unique(unlist(y)))
#
#   N <- length(unique(groups))
#
#
#   XXnam <- lapply(fixed, function(x) colnames(model.matrix(x, data)))
#
#
#   if (analysis_type %in% c('coxph', "JM")) {
#     XXnam[[which(sapply(outnam, "attr", "type") == 'survival')]] <-
#     XXnam[[which(sapply(outnam, "attr", "type") == 'survival')]][-1]
#
#     if (any(names(outnam) %in% names(models)[models %in% "clmm"])) {
#       for (i in which(names(outnam) %in% names(models)[models %in% "clmm"]))
#         XXnam[[i]] <- XXnam[[i]][-1]
#     }
#   }
#
#   if (analysis_type %in% c('clm', 'clmm'))
#     XXnam[[1]] <- XXnam[[1]][-1]
#
#
#
#
#   cols_main <- lapply(XXnam, function(XX) {
#     cml <- list(Xc = c(na.omit(match(XX[!XX %in% names(hc_list)], colnames(Xc)))),
#                 Xl = if (!is.null(Xl)) c(na.omit(match(XX, colnames(Xl)))),
#                 Xic = if (!is.null(Xic)) c(na.omit(match(XX, colnames(Xic)))),
#                 Xil = if (!is.null(Xil)) c(na.omit(match(XX, colnames(Xil)))),
#                 Z = if (!is.null(Z)) c(na.omit(match(XX, colnames(Z)))),
#                 Yc = if(!is.null(Yc)) c(na.omit(match(XX, colnames(Yc)))),
#                 Yl = if(!is.null(Yl)) c(na.omit(match(XX, colnames(Yl))))
#     )
#     sapply(cml, function(x) if (length(x) > 0)  x else NULL)
#   })
#
#   names_main <- lapply(cols_main, function(k) {
#     mapply(function(cols, mat) {
#       colnames(mat)[cols]
#     }, cols = k,
#     mat = list(Xc, Xl, Xic, Xil, Z, Yc, Yl))
#   })
#
#
#   return(list(outcomes = outcomes$outcomes, #event = event,
#               Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil, Xcat = Xcat, Xlcat = Xlcat,
#               Xtrafo = Xtrafo, Xltrafo = Xltrafo, Z = Z, Yc = Yc, Yl = Yl,
#               cols_main = cols_main, names_main = names_main,
#               trafos = fcts_all, hc_list = hc_list,
#               refs = refs, timevar = timevar,
#               auxvars = auxvars, groups = groups, scale_vars = scale_vars,
#               ncat = ncat,
#               N = N, ppc = ppc, ridge = ridge, nranef = ncol(Z2),
#               survrow = if(exists("survrow")) survrow))
# }
#







# split the data into matrices and obtain other relevant info for the further steps

divide_matrices <- function(data, fixed, random = NULL, analysis_type,
                            auxvars = NULL, scale_vars = NULL, refcats = NULL,
                            models = NULL,  timevar = NULL, no_model = NULL,
                            ppc = TRUE, ridge = FALSE,
                            warn = TRUE, mess = TRUE, ...) {

  # id's and groups ------------------------------------------------------------
  # extract the id variable from the random effects formula
  id <- extract_id(random, warn = warn)

  # define/identify groups/clusters in the data
  groups <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }

  # outcome --------------------------------------------------------------------
  # extract the outcomes from the fixed effects formulas
  outcomes <- extract_outcome_data(fixed, random = random, data = data, analysis_type = analysis_type)

  # * imputation method -------------------------------------------------------
  models <- get_models(fixed = fixed, random = random, data = data, timevar = timevar,
                       auxvars = auxvars, no_model = no_model, models = models)

  # * outcomes -------------------------------------------------------------------
  Y <- cbind(outcomes_to_mat(outcomes),
             prep_covoutcomes(data[setdiff(names(models), outcomes$outnams)])
  )

  # name the elements of fixed:
  fixed <- outcomes$fixed

  # reference categories -----------------------------------------------------
  refs <- get_refs(c(fixed, auxvars), data, refcats)

  for (i in names(refs)) {
    data[, i] <- relevel(factor(data[, i], ordered = FALSE),
                         as.character(refs[[i]]))
  }


  # covariates -----------------------------------------------------------------
  # * preliminary design matrix ------------------------------------------------
  X <- model.matrix_combi(c(fixed, auxvars), data)

  av <- sapply(all_vars(remove_LHS(fixed)), function(i) {
    if (i %in% names(refs)) {
      all(attr(refs[[i]], 'dummies') %in% colnames(X))
    } else {
      i %in% colnames(X)
    }
  })

  add_to_aux <- names(av[!av])

  auxvars <- if (is.null(auxvars)) {
    if (length(add_to_aux) > 0)
      as.formula(paste("~", paste0(add_to_aux, collapse = ' + ')))
  } else {
    as.formula(paste0(c(deparse(auxvars, width.cutoff = 500), add_to_aux),
                      collapse = " + "))
  }

  # design matrix with updated auxiliary variables
  X2 <- model.matrix_combi(c(fixed, auxvars), data)

  M <- cbind(Y, X2[, setdiff(colnames(X2), colnames(Y)), drop = FALSE])
  tvarM <- apply(M, 2, check_tvar, groups)

  Mc <- if (any(!tvarM)) M[, !tvarM, drop = FALSE]
  Ml <- if (any(tvarM)) M[, tvarM, drop = FALSE]

  fcts_mis <- extract_fcts(fixed = fixed, data, random = random, complete = FALSE)


  # scaling --------------------------------------------------------------------
  scale_pars <- list(Mc = get_scale_pars(Mc, groups, scale_vars),
                     Ml = get_scale_pars(Ml, groups, scale_vars))


  if (any(fcts_mis$type %in% c('ns', 'bs')))
    stop("Splines are currently not implemented for incomplete variables.",
         call. = FALSE)

  # set columns of trafos that need to be re-calculated in JAGS to NA
  if (any(fcts_mis$colname %in% colnames(Mc)))
    Mc[, unique(fcts_mis$colname)] <- NA
  if (any(fcts_mis$colname %in% colnames(Ml)))
    Ml[, unique(fcts_mis$colname)] <- NA


  # if (any(fcts_mis$type %in% c('ns')))
  #   stop(paste0("Natural cubic splines are not implemented for incomplete variables. ",
  #               "Please use B-splines (using ", dQuote("bs()"), ") instead."),
  #        call. = FALSE)


  # trafos <- c(
  #   match_trafos(fcts_mis, colnams = colnames(Mc), matname = 'Mc'),
  #   match_trafos(fcts_mis, colnams = colnames(Ml), matname = 'Ml')
  # )


  inter <- grep(":", names(tvarM), fixed = TRUE, value = TRUE)

  # if one element in an interaction is time-varying the interaction is time-varying
  if (length(inter) > 0 & any(tvarM))
    tvarM[inter[sapply(strsplit(inter, ':'),
                       function(k) any(na.omit(tvarM[k])))]] <- TRUE

  # * interactions -------------------------------------------------------------
  interactions <- match_interaction(inter, Mc = Mc, Ml = Ml)

  if (any(colnames(Mc) %in% names(interactions)))
    Mc[, which(colnames(Mc) %in% names(interactions))] <- NA
  if (any(colnames(Ml) %in% names(interactions)))
    Ml[, which(colnames(Ml) %in% names(interactions))] <- NA


  # categorical variables ------------------------------------------------------
  # set dummies of incomplete variables to NA because they need to be re-calculated
  for (k in names(refs)) {
    if (any(is.na(data[, k])) & all(attr(refs[[k]], 'dummies') %in% colnames(M))) {
      if (any(!tvarM[attr(refs[[k]], 'dummies')]))
        Mc[, attr(refs[[k]], 'dummies')] <- NA
      else
        Ml[, attr(refs[[k]], 'dummies')] <- NA
    }
  }


  # Hierarchical centering -----------------------------------------------------
  hc_list <- if (!all(sapply(random, is.null)))
    HC(fixed, random, data, interactions = interactions,
       Mcnam = colnames(Mc), Mlnam = colnames(Ml))


  # other info ----------------------------------------------------------------
  # ncat <- if (analysis_type %in% c('clmm', 'clm'))
  #   length(unique(unlist(y)))

  # column names of the linear predictors for all models -----------------------
  XXnam <- get_linpreds(fixed, random, data, models, auxvars, analysis_type)

  lp_cols <- lapply(XXnam, function(XX) {
    Mccols <- if (!is.null(Mc)) c(na.omit(match(XX, colnames(Mc))))
    Mlcols <- if (!is.null(Ml)) c(na.omit(match(XX, colnames(Ml))))

    cml <- list(Mc = if (length(Mccols) > 0) setNames(Mccols, colnames(Mc)[Mccols]),
                Ml = if (length(Mlcols) > 0) setNames(Mlcols, colnames(Ml)[Mlcols])
    )
    cml[!sapply(cml, is.null)]
  })


  return(list(fixed = fixed, random = random,
              Mc = Mc, Ml = Ml, lp_cols = lp_cols, interactions = interactions,
              trafos = fcts_mis, hc_list = hc_list,
              refs = refs, timevar = timevar,
              auxvars = auxvars, groups = groups,
              # ncat = ncat,
              N = length(unique(groups)), Ntot = length(groups),
              ppc = ppc, ridge = ridge,
              models = models, scale_pars = scale_pars
              # survrow = if(exists("survrow")) survrow
              )
         )
}

