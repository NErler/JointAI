# split the data into matrices and obtain other relevant info for the further steps
divide_matrices <- function(data, fixed, random = NULL, analysis_type,
                            auxvars = NULL, scale_vars = NULL, refcats = NULL,
                            models = NULL,  timevar = NULL, no_model = NULL,
                            ppc = TRUE, ridge = FALSE,
                            warn = TRUE, mess = TRUE, df_basehaz = 6, ...) {

  # id's and groups ------------------------------------------------------------
  # extract the id variable from the random effects formula and get groups
  idvar <- extract_id(random, warn = warn)
  groups <- get_groups(idvar, data)
  group_lvls <- colSums(!identify_level_relations(groups))


  # outcome --------------------------------------------------------------------
  # extract the outcomes from the fixed effects formulas
  outcomes <- extract_outcome_data(fixed, random = random, data = data,
                                   analysis_type = analysis_type, warn = warn)

  # name the elements of fixed:
  fixed <- outcomes$fixed
  names(random) <- names(fixed)

  # * model types --------------------------------------------------------------
  models <- get_models(fixed = fixed, random = random, data = data, timevar = timevar,
                       auxvars = auxvars, no_model = no_model, models = models,
                       warn = warn)

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
  terms_list <- get_terms_list(fmla = c(fixed, unlist(remove_grouping(random)), auxvars), data = data)
  X2 <- model.matrix_combi(fmla = c(fixed, unlist(remove_grouping(random)), auxvars), data = data,
                           terms_list = terms_list)

  MX <- cbind(Y, X2[, setdiff(colnames(X2), colnames(Y)), drop = FALSE])

  Mlvls <- apply(MX, 2, check_varlevel, groups = groups,
                 group_lvls = identify_level_relations(groups))
  Mlvls <- setNames(paste0("M_", Mlvls), names(Mlvls))

  # identify interactions -------------------------------------------------------
  inter <- grep(":", colnames(MX), fixed = TRUE, value = TRUE)

  # if one element in an interaction is time-varying the interaction is time-varying
  if (length(inter) > 0) {
    minlvl <- sapply(strsplit(inter, ':'), function(k)
      names(which.min(group_lvls[gsub('M_', '', Mlvls[k])]))
    )
    Mlvls[inter] <- paste0("M_", minlvl)
  }


  M <- sapply(unique(Mlvls), function(k)
    MX[ , Mlvls == k, drop = FALSE], simplify = FALSE)

  fcts_mis <- extract_fcts(fixed = fixed, data, random = random, complete = FALSE,
                           Mlvls = Mlvls)
  fcts_all <- extract_fcts(fixed = fixed, data, random = random, complete = TRUE,
                           Mlvls = Mlvls)

  # scaling --------------------------------------------------------------------
  scale_pars <- mapply(get_scale_pars,
                       mat = M, groups = groups[gsub('M_', '', names(M))],
                       MoreArgs = list(scale_vars = scale_vars),
                       SIMPLIFY  = FALSE)


  if (any(fcts_mis$type %in% c('ns', 'bs')))
    stop("Splines are currently not implemented for incomplete variables.",
         call. = FALSE)

  # set columns of trafos that need to be re-calculated in JAGS to NA
  for (k in names(M)) {
    if (any(k %in% fcts_mis$matrix))
      M[[k]][, unique(fcts_mis$colname[fcts_mis$matrix %in% k])] <- NA
  }

  # if (any(fcts_mis$type %in% c('ns')))
  #   stop(paste0("Natural cubic splines are not implemented for incomplete variables. ",
  #               "Please use B-splines (using ", dQuote("bs()"), ") instead."),
  #        call. = FALSE)


  # trafos <- c(
  #   match_trafos(fcts_mis, colnams = colnames(Mc), matname = 'Mc'),
  #   match_trafos(fcts_mis, colnams = colnames(Ml), matname = 'Ml')
  # )




  # * interactions -------------------------------------------------------------
  interactions <- match_interaction(inter, M)

  if (any(unlist(sapply(M, colnames)) %in% names(interactions)[
    sapply(interactions, 'attr', "has_NAs")]))
    for (k in names(M)) {
      M[[k]][, which(colnames(M[[k]]) %in% names(interactions)[
        sapply(interactions, 'attr', "has_NAs")])] <- NA
    }


  # categorical variables ------------------------------------------------------
  # set dummies of incomplete variables to NA because they need to be re-calculated
  # also set dummies of complete long. variables to NA if there is a JM
  # because they need to be re-calculated in the quadrature part
  for (k in names(refs)) {
    if (all(attr(refs[[k]], 'dummies') %in% colnames(MX))) {

      if (any(is.na(data[, k]))) {
        M[[unique(Mlvls[attr(refs[[k]], 'dummies')])]][, attr(refs[[k]], 'dummies')] <- NA

      } else if (any(sapply(fixed, 'attr', 'type') %in% 'JM')) {
        # dummmy matrix
        covmat <- unique(Mlvls[attr(refs[[k]], 'dummies')])
        # outcome matrix
        outmat <- unique(Mlvls[colnames(outcomes$outcomes[[1]])[2]])
        if (colSums(!identify_level_relations(groups))[gsub('M_', '', outmat)] <
            colSums(!identify_level_relations(groups))[gsub('M_', '', covmat)]) {

          M[[unique(Mlvls[attr(refs[[k]], 'dummies')])]][, attr(refs[[k]], 'dummies')] <- NA
        }
      }
    }
  }


  # column names of the linear predictors for all models -----------------------
  XXnam <- get_linpreds(fixed, random, data, models, auxvars, analysis_type,
                        warn = warn)

  lp_cols <- lapply(XXnam, function(XX) {
    Mcols <- if (!is.null(M)) sapply(M, function(x) c(na.omit(match(XX, colnames(x)))), simplify = FALSE)

    cml <- sapply(names(Mcols)[sapply(Mcols, length) > 0],
                  function(i)
                    setNames(Mcols[[i]], colnames(M[[i]])[Mcols[[i]]]),
                  simplify = FALSE)

    cml[sapply(cml, length) > 0]
  })

  for (k in names(M)) {
    M[[k]] <- M[[k]][match(unique(groups[[gsub('M_', '', k)]]),
                           groups[[gsub('M_', '', k)]]), , drop = FALSE]
  }

  list(fixed = fixed, random = random, idvar = idvar,
       M = M, Mlvls = Mlvls,
       lp_cols = lp_cols, interactions = interactions,
       trafos = fcts_mis, #hc_list = hc_list,
       refs = refs, timevar = timevar,
       auxvars = auxvars, groups = groups,
       group_lvls = group_lvls,
       N = sapply(groups, function(x) length(unique(x))),
       ppc = ppc, ridge = ridge,
       models = models, scale_pars = scale_pars,
       outcomes = outcomes, fcts_all = fcts_all,
       terms_list = terms_list, df_basehaz = df_basehaz
  )
}



