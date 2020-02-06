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
    match(data[, id], unique(data[, id]))
  } else {
    1:nrow(data)
  }

  # outcome --------------------------------------------------------------------
  # extract the outcomes from the fixed effects formulas
  outcomes <- extract_outcome_data(fixed, random = random, data = data,
                                   analysis_type = analysis_type)

  # name the elements of fixed:
  fixed <- outcomes$fixed
  names(random) <- names(fixed)

  # * model types --------------------------------------------------------------
  models <- get_models(fixed = fixed, random = random, data = data, timevar = timevar,
                       auxvars = auxvars, no_model = no_model, models = models)

  # * outcomes -------------------------------------------------------------------
  Y <- cbind(outcomes_to_mat(outcomes),
             prep_covoutcomes(data[setdiff(names(models),
                                           c(outcomes$outnams, names(outcomes$outnams)))])
  )


  # reference categories -----------------------------------------------------
  refs <- get_refs(c(fixed, auxvars), data, refcats)

  for (i in names(refs)) {
    data[, i] <- relevel(factor(data[, i], ordered = FALSE),
                         as.character(refs[[i]]))
  }


  # covariates -----------------------------------------------------------------
  # * preliminary design matrix ------------------------------------------------
  X <- model.matrix_combi(fmla = c(fixed, auxvars), data = data,
                          terms_list = get_terms_list(fmla = c(fixed, auxvars),
                                                      data = data))

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
  terms_list <- get_terms_list(fmla = c(fixed, auxvars), data = data)
  X2 <- model.matrix_combi(fmla = c(fixed, auxvars), data = data,
                           terms_list = terms_list)

  M <- cbind(Y, X2[, setdiff(colnames(X2), colnames(Y)), drop = FALSE])
  tvarM <- apply(M, 2, check_tvar, groups)

  Mc <- if (any(!tvarM)) M[, !tvarM, drop = FALSE]
  Ml <- if (any(tvarM)) M[, tvarM, drop = FALSE]

  fcts_mis <- extract_fcts(fixed = fixed, data, random = random, complete = FALSE,
                           Mcnam = colnames(Mc))
  fcts_all <- extract_fcts(fixed = fixed, data, random = random, complete = TRUE,
                           Mcnam = colnames(Mc))

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

  if (any(colnames(Mc) %in% names(interactions)[sapply(interactions, 'attr', "has_NAs")]))
    Mc[, which(colnames(Mc) %in% names(interactions))] <- NA
  if (any(colnames(Ml) %in% names(interactions)[sapply(interactions, 'attr', "has_NAs")]))
    Ml[, which(colnames(Ml) %in% names(interactions)[sapply(interactions, 'attr', "has_NAs")])] <- NA


  # categorical variables ------------------------------------------------------
  # set dummies of incomplete variables to NA because they need to be re-calculated
  # also set dummies of complete long. variables to NA if there is a JM
  # because they need to be re-calculated in the quadrature part
  for (k in names(refs)) {
    if (all(attr(refs[[k]], 'dummies') %in% colnames(M))) {
      if (any(is.na(data[, k])) & any(!tvarM[attr(refs[[k]], 'dummies')]))
        Mc[, attr(refs[[k]], 'dummies')] <- NA
      else if ((any(is.na(data[, k])) | any(sapply(fixed, 'attr', 'type') %in% 'JM')) &
               any(tvarM[attr(refs[[k]], 'dummies')]))
        Ml[, attr(refs[[k]], 'dummies')] <- NA
    }
  }


  # Hierarchical centering -----------------------------------------------------
  hc_list <- if (!all(sapply(random, is.null)))
    HC(fixed, random, data, interactions = interactions,
       Mcnam = colnames(Mc), Mlnam = colnames(Ml))

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
              Mc = Mc[match(unique(groups), groups), , drop = FALSE],
              Ml = Ml, lp_cols = lp_cols, interactions = interactions,
              trafos = fcts_mis, hc_list = hc_list,
              refs = refs, timevar = timevar,
              auxvars = auxvars, groups = groups,
              N = length(unique(groups)), Ntot = length(groups),
              ppc = ppc, ridge = ridge,
              models = models, scale_pars = scale_pars,
              outcomes = outcomes, fcts_all = fcts_all,
              terms_list = terms_list
              )
         )
}


