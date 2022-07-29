# split the data into matrices and obtain other relevant info for the further
# steps
divide_matrices <- function(data, fixed, random = NULL, analysis_type,
                            auxvars = NULL, scale_vars = NULL, refcats = NULL,
                            models = NULL,  timevar = NULL, no_model = NULL,
                            nonprop = NULL, rev = NULL,
                            ppc = TRUE, shrinkage = FALSE,
                            warn = TRUE, mess = TRUE, df_basehaz = 6,
                            rd_vcov = rd_vcov, ...) {

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

  # sort group levels and groups (so that higher levels, which contain the
  # ("Intercept") appear first in the linear predictor)
  group_lvls <- sort(group_lvls, decreasing = TRUE)
  groups <- groups[names(group_lvls)]


  # in case of last-observation-carried forward: the value of the time-varying
  # covariates at the event times is filled in
  if (analysis_type == "coxph" & length(groups) > 1 & !is.null(timevar))
    data <- fill_locf(data, fixed, random, auxvars, timevar, groups)


  # outcome --------------------------------------------------------------------
  # extract the outcomes from the fixed effects formulas
  outcomes <- extract_outcome_data(fixed, random = random, data = data,
                                   analysis_type = analysis_type, warn = warn)

  # name the elements of fixed:
  fixed <- outcomes$fixed
  names(random) <- names(fixed)

  # * model types --------------------------------------------------------------
  models <- get_models(fixed = fixed, random = random, data = data,
                       timevar = timevar,
                       auxvars = auxvars, no_model = no_model, models = models,
                       warn = warn)

  # * outcomes -----------------------------------------------------------------
  Y <- cbind(outcomes_to_mat(outcomes),
             prep_covoutcomes(data[setdiff(names(models),
                                           c(outcomes$outnams,
                                             names(outcomes$outnams)))])
  )


  # reference categories -----------------------------------------------------
  refs <- get_refs(c(fixed, auxvars), data, refcats, warn = warn)

  # for (i in names(refs)) {
  #   data[, i] <- relevel(factor(data[, i], ordered = FALSE),
  #                        as.character(refs[[i]]))
  # }
  #

  # covariates -----------------------------------------------------------------
  # * preliminary design matrix ------------------------------------------------
  X <- model_matrix_combi(fmla = c(fixed, auxvars), data = data, refs = refs,
                          terms_list = get_terms_list(fmla = c(fixed, auxvars),
                                                      data = data))

  # add auxiliary variables
  # - dummies for categorical variables
  # - timevar for survival model with time-varying covariates
  av <- sapply(all_vars(remove_lhs(fixed)), function(i) {
    if (i %in% names(refs)) {
      all(attr(refs[[i]], "dummies") %in% colnames(X))
    } else {
      i %in% colnames(X)
    }
  })

  add_to_aux <- c(timevar, names(av[!av]))

  auxvars <- if (is.null(auxvars)) {
    if (length(add_to_aux) > 0)
      as.formula(paste("~", paste0(add_to_aux, collapse = " + ")))
  } else {
    as.formula(paste0(c(deparse(auxvars, width.cutoff = 500L), add_to_aux),
                      collapse = " + "))
  }

  # design matrix with updated auxiliary variables
  terms_list <- get_terms_list(
    fmla = c(fixed, unlist(remove_grouping(random)), auxvars), data = data)
  X2 <- model_matrix_combi(
    fmla = c(fixed, unlist(remove_grouping(random)), auxvars),
    data = data, refs = refs, terms_list = terms_list)

  # combine covariate design matrix with outcome design matrix
  MX <- cbind(Y, X2[, setdiff(colnames(X2), colnames(Y)), drop = FALSE])
  MX <- MX[, unique(colnames(MX))]

  # identify levels of all variables
  # Mlvls <- apply(MX, 2, check_varlevel, groups = groups,
  #                group_lvls = identify_level_relations(groups))
  Mlvls <- get_datlvls(MX, groups)

  Mlvls <- setNames(paste0("M_", Mlvls), names(Mlvls))


  # identify interactions ------------------------------------------------------
  inter <- grep(":", colnames(MX), fixed = TRUE, value = TRUE)

  # if one element in an interaction is time-varying the interaction is
  # time-varying
  if (length(inter) > 0) {
    minlvl <- sapply(strsplit(inter, ":"), function(k)
      names(which.min(group_lvls[gsub("M_", "", Mlvls[k])]))
    )
    Mlvls[inter] <- paste0("M_", minlvl)
  }


  # Split data matrix by variable level
  # This split has to be done by names(groups) since they are sorted by level.
  # As a consequence, higher levels (which contain the "(Intercept)" will
  # appear first in the linear predictor, and also in the output. Just looks
  # nicer this way.
  M <- sapply(paste0("M_", names(groups)), function(k)
    MX[, Mlvls == k, drop = FALSE], simplify = FALSE)

  fcts_mis <- extract_fcts(fixed = fixed, data, random = random,
                           auxvars = auxvars, complete = FALSE,
                           dsgn_mat_lvls = Mlvls)
  fcts_all <- extract_fcts(fixed = fixed, data, random = random,
                           auxvars = auxvars, complete = TRUE,
                           dsgn_mat_lvls = Mlvls)


  if (any(fcts_mis$type %in% c("ns", "bs")))
    errormsg("Splines are currently not implemented for incomplete variables.")


  # !!! Error message that will be needed when splines are implemented
  # if (any(fcts_mis$type %in% c("ns")))
  # errormsg("Natural cubic splines are not implemented for incomplete
  #           variables.
            # Please use B-splines (using %s) instead.", dQuote("bs()"))


  # * interactions -------------------------------------------------------------
  interactions <- match_interaction(inter, M)

  # scaling --------------------------------------------------------------------
  scale_pars <- mapply(get_scale_pars,
                       mat = M, groups = groups[gsub("M_", "", names(M))],
                       MoreArgs = list(scale_vars = scale_vars, refs = refs,
                                       fcts_all = fcts_all,
                                       interactions = interactions,
                                       data = data),
                       SIMPLIFY  = FALSE)


  # * set columns NA -----------------------------------------------------------
  # set interaction terms that involve incomplete variables to NA
  # (otherwise error in JAGS)
  if (any(unlist(sapply(M, colnames)) %in% names(interactions)[
    sapply(interactions, "attr", "has_NAs")]))
    for (k in names(M)) {
      M[[k]][, which(colnames(M[[k]]) %in% names(interactions)[
        sapply(interactions, "attr", "has_NAs")])] <- NA
    }


  # set columns of trafos that need to be re-calculated in JAGS to NA
  for (k in names(M)) {
    M[[k]][, intersect(colnames(M[[k]]), fcts_mis$colname)] <- NA
  }


  # categorical variables ------------------------------------------------------
  # set dummies of incomplete variables to NA because they need to be
  # re-calculated
  # also set dummies of complete long. variables to NA if there is a JM
  # because they need to be re-calculated in the quadrature part
  for (k in names(refs)) {
    if (all(attr(refs[[k]], "dummies") %in% colnames(MX))) {

      if (any(is.na(data[, k]))) {
        M[[unique(Mlvls[attr(refs[[k]], "dummies")])]][, attr(
          refs[[k]],
          "dummies"
        )] <- NA
      } else if (any(sapply(fixed, "attr", "type") %in% "JM")) {
        # dummy matrix
        covmat <- unique(Mlvls[attr(refs[[k]], "dummies")])
        # outcome matrix
        outmat <- unique(Mlvls[colnames(outcomes$outcomes[[1]])[2]])
        if (colSums(!identify_level_relations(groups))[
          gsub("M_", "", outmat)] <
          colSums(!identify_level_relations(groups))[
            gsub("M_", "", covmat)]) {

          M[[unique(Mlvls[
            attr(refs[[k]], "dummies")])]][, attr(refs[[k]], "dummies")] <- NA
        }
      }
    }
  }


  # column names of the linear predictors for all models -----------------------
  XXnam <- get_linpreds(fixed, random, data, models, auxvars, analysis_type,
                        warn = warn, refs = refs)

  lp_cols <- lapply(XXnam, function(XX) {
    Mcols <- if (!is.null(M))
      sapply(M, function(x) c(na.omit(match(XX, colnames(x)))),
             simplify = FALSE)

    cml <- sapply(names(Mcols)[sapply(Mcols, length) > 0],
                  function(i)
                    setNames(Mcols[[i]], colnames(M[[i]])[Mcols[[i]]]),
                  simplify = FALSE)

    cml[sapply(cml, length) > 0]
  })

  # get the linear predictor variables that have non-proportional effects in
  # cumulative logit models
  lp_nonprop <- get_nonprop_lp(nonprop, dsgn_mat_lvls = Mlvls,
                               data, refs, fixed, lp_cols)


  # reduce the design matrices to the correct rows, according to their levels
  for (k in names(M)) {
    M[[k]] <- M[[k]][match(unique(groups[[gsub("M_", "", k)]]),
                           groups[[gsub("M_", "", k)]]), , drop = FALSE]
  }


  nranef <- get_nranef(idvar = idvar, random = random, data = data)
  rd_vcov <- check_rd_vcov(rd_vcov = rd_vcov, nranef = nranef)

  list(data = data,
       fixed = fixed, random = random, models = models,

       M = M, Mlvls = Mlvls,
       idvar = idvar, groups = groups, group_lvls = group_lvls,
       N = sapply(groups, function(x) length(unique(x))),

       timevar = timevar,
       auxvars = auxvars,
       refs = refs,

       lp_cols = lp_cols,
       lp_nonprop = lp_nonprop,
       rev = rev,
       interactions = interactions,
       trafos = fcts_mis, fcts_all = fcts_all,

       ppc = ppc,
       shrinkage = shrinkage,
       df_basehaz = df_basehaz,
       rd_vcov = rd_vcov,

       scale_pars = scale_pars,
       outcomes = outcomes,
       terms_list = terms_list
  )
}


#' Re-create the full `Mlist` from a "JointAI" object
#' @param object object of class "JointAI"
#' @keywords internal
#' @export
get_Mlist <- function(object) {

  if (!(inherits(object, "JointAI") | inherits(object, "JointAI_errored")))
    errormsg("%s must be of class %s or %s.",
             dQuote("object"), dQuote("JointAI"), dQuote("JointAI_errored"))

  c(object[c("data", "models", "fixed", "random")],
    object$Mlist,
    list(M = object$data_list[paste0("M_", names(object$Mlist$group_lvls))])
  )
}
