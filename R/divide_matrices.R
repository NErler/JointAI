# split the data into matrices and obtain other relevant info for the further steps
divide_matrices <- function(data, fixed, random = NULL, analysis_type,
                            auxvars = NULL, scale_vars = NULL, refcats = NULL,
                            models = NULL,  timevar = NULL, no_model = NULL,
                            ppc = TRUE, shrinkage = FALSE,
                            warn = TRUE, mess = TRUE, df_basehaz = 6, ...) {

  # id's and groups ------------------------------------------------------------
  # extract the id variable from the random effects formula and get groups
  idvar <- extract_id(random, warn = warn)

  # re-format data for survival with time-varying covariates:
  # the time variables of the longitudinal measurements and the survival times
  # are merged. The original column with survival times is retained and used in
  # the model, but the covariate value at the event time must be imputed.
  data <- reformat_longsurvdata(data, fixed, random, timevar = timevar,
                                idvar = idvar)

  groups <- get_groups(idvar, data)
  group_lvls <- colSums(!identify_level_relations(groups))


  # in case of last-observation-carried forward: the value of the time-varying
  # covariates at the event times is filled in
  if (analysis_type == 'coxph' & length(groups) > 1 & !is.null(timevar))
    data <- fill_locf(data, fixed, random, auxvars, timevar, groups)


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
                                           c(outcomes$outnams,
                                             names(outcomes$outnams)))])
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

  # add auxiliary variables
  # - dummies for categorical variables
  # - timevar for survival model with time-varying covariates
  av <- sapply(all_vars(remove_LHS(fixed)), function(i) {
    if (i %in% names(refs)) {
      all(attr(refs[[i]], 'dummies') %in% colnames(X))
    } else {
      i %in% colnames(X)
    }
  })

  add_to_aux <- c(timevar, names(av[!av]))

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

  # combine covariate design matrix with outcome design matrix
  MX <- cbind(Y, X2[, setdiff(colnames(X2), colnames(Y)), drop = FALSE])
  MX <- MX[, unique(colnames(MX))]

  # identify levels of all variables
  Mlvls <- apply(MX, 2, check_varlevel, groups = groups,
                 group_lvls = identify_level_relations(groups))
  Mlvls <- setNames(paste0("M_", Mlvls), names(Mlvls))

  if (length(unique(Mlvls)) < length(groups)) {
    errormsg("It seems some of the specified grouping levels are not necessary.
              All variables are from level %s but there are grouping variable(s)
              %s.", dQuote(gsub("M_", "", unique(Mlvls))), dQuote(idvar))
  }

  # identify interactions -------------------------------------------------------
  inter <- grep(":", colnames(MX), fixed = TRUE, value = TRUE)

  # if one element in an interaction is time-varying the interaction is time-varying
  if (length(inter) > 0) {
    minlvl <- sapply(strsplit(inter, ':'), function(k)
      names(which.min(group_lvls[gsub('M_', '', Mlvls[k])]))
    )
    Mlvls[inter] <- paste0("M_", minlvl)
  }


  # split data matrix by variable level
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
    errormsg("Splines are currently not implemented for incomplete variables.")

  # set columns of trafos that need to be re-calculated in JAGS to NA
  for (k in names(M)) {
    M[[k]][, intersect(colnames(M[[k]]), fcts_mis$colname)] <- NA
  }


  # !!! Error message that will be needed when splines are implemented
  # if (any(fcts_mis$type %in% c('ns')))
  # errormsg("Natural cubic splines are not implemented for incomplete variables.
            # Please use B-splines (using %s) instead.", dQuote("bs()"))


  # * interactions -------------------------------------------------------------
  interactions <- match_interaction(inter, M)

  # set interaction terms that involve incomplete variables to NA
  # (otherwise error in JAGS)
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
        # dummy matrix
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
    Mcols <- if (!is.null(M))
      sapply(M, function(x) c(na.omit(match(XX, colnames(x)))), simplify = FALSE)

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

  list(data = data, fixed = fixed, random = random, idvar = idvar,
       M = M, Mlvls = Mlvls,
       lp_cols = lp_cols, interactions = interactions,
       trafos = fcts_mis, fcts_all = fcts_all,
       refs = refs, timevar = timevar,
       auxvars = auxvars, groups = groups,
       group_lvls = group_lvls,
       N = sapply(groups, function(x) length(unique(x))),
       ppc = ppc, shrinkage = shrinkage,
       models = models, scale_pars = scale_pars,
       outcomes = outcomes,
       terms_list = terms_list, df_basehaz = df_basehaz
  )
}



