# get model info for a list of models
get_model_info <- function(
  Mlist,
  par_index_main,
  par_index_other,
  trunc = NULL,
  assoc_type = NULL,
  custom = NULL
) {
  args <- as.list(match.call())[-1L]

  setNames(
    lapply(names(Mlist$lp_cols), function(k) {
      do.call(get_model1_info, c(k = replace_dummy(k, refs = Mlist$refs), args))
    }),
    names(Mlist$lp_cols)
  )
}


# get model info for a single model
get_model1_info <- function(
  k,
  Mlist,
  par_index_main,
  par_index_other,
  trunc = NULL,
  assoc_type = NULL,
  custom = NULL,
  isgk = FALSE
) {
  arglist <- as.list(match.call())[-1L]

  # model type, family & link -------------------------------------------------
  modeltype <- get_modeltype(Mlist$models[k])
  family <- get_family(Mlist$models[k])
  link <- get_link(Mlist$models[k])

  if (modeltype %in% c("glm", "clm", "mlogit") & !is.null(Mlist$random[[k]])) {
    errormsg(
      "There is a random effects structure specified for the variable %s,
             but %s is being modeled with a model of type %s.",
      dQuote(k),
      dQuote(k),
      dQuote(modeltype)
    )
  }

  # response matrix and column(s) --------------------------------------------
  resp_mat <- get_resp_mat(
    resp = k,
    Mlvls = Mlist$Mlvls,
    outnames = if (!is.null(Mlist$outcomes$outcomes[[k]])) {
      names(Mlist$outcomes$outcomes[[k]])
    } else {
      k
    }
  )
  # resp_mat <- if (k %in% names(Mlist$Mlvls)) {
  #   # if the variable is a column of one of the design matrices, use the level
  #   # of that matrix
  #   Mlist$Mlvls[k]
  # } else if (attr(Mlist$fixed[[k]], "type") %in% c("survreg", "coxph", "JM")) {
  #   # if the model is a survival model (variable name is the survival expression
  #   # and not a single variable name) get the levels of the separate variables
  #   # involved in the survival expression
  #   if (all(names(Mlist$outcomes$outcomes[[k]]) %in% names(Mlist$Mlvls))) {
  #     Mlist$Mlvls[names(Mlist$outcomes$outcomes[[k]])]
  #   } else {
  #     errormsg("I have identified %s as a survival outcome, but I cannot find
  #              some of its elements in any of the matrices %s.",
  #              dQuote(k), dQuote("M"))
  #   }
  # } else {
  #   errormsg("I cannot find the variable %s in any of the matrices %s.",
  #            dQuote(k), dQuote("M"))
  # }

  resp_col <- if (
    k %in%
      names(Mlist$fixed) &&
      attr(Mlist$fixed[[k]], "type") %in%
        c("survreg", "coxph", "JM")
  ) {
    vapply(
      names(Mlist$outcomes$outcomes[[k]]),
      function(x) {
        match(x, colnames(Mlist$M[[resp_mat[x]]]))
      },
      FUN.VALUE = numeric(1L)
    )
  } else {
    match(k, colnames(Mlist$M[[resp_mat[1L]]]))
  }

  # linear predictor columns -------------------------------------------------
  lp <- get_lp(k, Mlist)

  # check and error message for time-dependent cox with interaction between
  # time-varying covariate with incomplete baseline covariate
  if (
    modeltype == "coxph" &
      !is.null(Mlist$interactions) &
      !is.null(lp$M_lvlone)
  ) {
    lapply(
      Mlist$interactions[intersect(
        names(Mlist$interactions),
        names(lp$M_lvlone)
      )],
      function(x) {
        if (
          any(names(x$elmts) == "M_lvlone") &
            any(names(x$elmts) != "M_lvlone") &
            attr(x, "has_NAs")
        ) {
          errormsg(
            "It seems that there is an interaction between a time-varying
                 covariate and a incomplete baseline covariate. This is not
                 yet implemented for proportional hazards models."
          )
        }
      }
    )
  }

  # parameter elements ------------------------------------------------------
  parelmts <- get_parelmts(k, Mlist, par_index_main, par_index_other, lp)

  # scaling parameter matrices -----------------------------------------------
  scale_pars <- Mlist$scale_pars

  # dummy columns -------------------------------------------------------------
  dummy_cols <- if (
    k %in%
      names(Mlist$refs) &
      (any(is.na(Mlist$M[[resp_mat[1L]]][, resp_col[1L]])) |
        any(
          vapply(Mlist$fixed, "attr", "type", FUN.VALUE = character(1L)) %in%
            "JM"
        ))
  ) {
    match(attr(Mlist$refs[[k]], "dummies"), colnames(Mlist$M[[resp_mat[[1L]]]]))
  }

  if (all(is.na(dummy_cols))) {
    dummy_cols <- NULL
  }

  # index name -----------------------------------------------------------------
  index <- get_indices(Mlist)

  # transformations ------------------------------------------------------------
  trafos <- paste_trafos(
    Mlist,
    varname = k,
    index = if (isgk) "ii" else index[gsub("M_", "", resp_mat[1L])],
    isgk = isgk
  )

  # JM settings ----------------------------------------------------------------
  # * time variable ------------------------------------------------------------
  # terms that only involve the time variable overlap with the baseline hazard
  if (modeltype %in% "JM") {
    check_jm_time_terms(fixed = Mlist$fixed[[k]], timevar = Mlist$timevar)
  }

  # * covariate names ----------------------------------------------------------
  covnames <- if (modeltype %in% "JM") {
    unique(unlist(
      lapply(lp, function(x) {
        vapply(
          names(x),
          replace_dummy,
          refs = Mlist$refs,
          FUN.VALUE = character(1L)
        )
      })
    ))
  }

  # * interactions with unknown elements ---------------------------------------
  # interaction terms in the time-varying part of the linear predictor of the
  # survival part need all their elements as columns of the design matrices
  if (modeltype %in% "JM" && resp_mat[2L] != "M_lvlone") {
    check_jm_unknown_interactions(
      lp_cols = lp[["M_lvlone"]],
      interactions = Mlist$interactions,
      design_cols = unlist(lapply(Mlist$M, colnames)),
      refs = Mlist$refs,
      timevar = Mlist$timevar
    )
  }

  # * functions of several variables -------------------------------------------
  # the JAGS syntax of the time-varying part of the linear predictor of the
  # survival part has one variable per column
  if (modeltype %in% "JM" && resp_mat[2L] != "M_lvlone") {
    check_jm_function_terms(
      lp_cols = lp[["M_lvlone"]],
      trafos = Mlist$fcts_all
    )
  }

  # * time-varying covariates --------------------------------------------------
  tv_vars <- if (modeltype %in% "JM") {
    # find the (longitudinal) covariates involved in the lp of the survival part
    covars <- unlist(
      lapply(unlist(lapply(lp, names)), replace_trafo, Mlist$fcts_all)
    )
    covars <- vapply(
      covars,
      replace_dummy,
      refs = Mlist$refs,
      FUN.VALUE = character(1L)
    )
    covars <- covars[covars %in% unlist(lapply(Mlist$M, colnames))]
    logsd_vars <- get_logsd_vars(covars, Mlist$logsd_of)
    covars <- c(covars, logsd_vars)

    rep_lvls <- names(which(
      Mlist$group_lvls <
        Mlist$group_lvls[
          gsub("M_", "", resp_mat[2L])
        ]
    ))

    tvars <- unique(unlist(c(
      lapply(lp[paste0("M_", rep_lvls)], names),
      lapply(Mlist$lp_cols[covars], function(x) {
        names(unlist(unname(x[paste0("M_", rep_lvls)])))
      })
    )))

    # get the variables needed to re-fit the models for "covars" in the
    # Gauss-Kronrod quadrature
    tvars <- unique(unlist(lapply(
      tvars,
      replace_interaction,
      Mlist$interactions
    )))
    tvars <- unlist(lapply(tvars, replace_trafo, Mlist$fcts_all))

    tvars <- unique(vapply(
      tvars[!tvars %in% Mlist$timevar],
      replace_dummy,
      refs = Mlist$refs,
      FUN.VALUE = character(1L)
    ))

    tvars <- tvars[Mlist$Mlvls[tvars] %in% paste0("M_", rep_lvls)]

    # the model of a variable with a model for its residual standard deviation
    # needs this standard deviation at the quadrature points
    tvars <- unique(c(tvars, get_logsd_vars(tvars, Mlist$logsd_of)))

    # get the model info for these variables
    setNames(
      lapply(tvars, function(i) {
        arglist_new <- arglist
        arglist_new$k <- replace_dummy(i, refs = Mlist$refs)
        arglist_new$isgk <- TRUE
        subinfo <- do.call(get_model1_info, arglist_new)
        subinfo$surv_lvl <- gsub("M_", "", resp_mat[2L])
        subinfo
      }),
      tvars
    )
  }

  # * interactions with time-varying covariates -------------------------------
  # interaction terms among the time-varying columns of the linear predictor of
  # the survival part; in the JAGS model, they are written as the product of
  # their elements (see paste_linpred_jm())
  jm_interactions <- if (modeltype %in% "JM") {
    get_jm_interactions(
      lp_cols = lp[["M_lvlone"]],
      interactions = Mlist$interactions,
      surv_mat = resp_mat[2L]
    )
  }

  # Hierarchical centering -----------------------------------------------------
  hc_list <- get_hc_info(
    varname = k,
    resplvl = gsub("M_", "", resp_mat[length(resp_mat)]),
    Mlist,
    parelmts,
    lp
  )

  nranef <- vapply(
    hc_list$hcvars,
    function(x) {
      as.integer(attr(x, "rd_intercept")) +
        if (!is.null(x$rd_slope_coefs)) {
          nrow(x$rd_slope_coefs)
          # if (any(!vapply(x$rd_slope_coefs, is.null, FUN.VALUE = logical(1L)))) {
          #   nrow(do.call(rbind, x$rd_slope_coefs))
        } else {
          0L
        }
    },
    FUN.VALUE = integer(1L)
  )

  # random effects variance covariance matrix
  rd_vcov <- nlapply(names(Mlist$rd_vcov), function(lvl) {
    x <- Mlist$rd_vcov[[lvl]]

    w <- which(lvapply(x, function(z) k %in% z))
    if (length(w) > 0L) {
      type <- names(w)

      attr(type, "ranef_index") <- attr(x[[w]], "ranef_index")
      attr(type, "name") <- attr(x[[w]], "name")
      type
    } else if (isTRUE(nranef[lvl] > 0L)) {
      "blockdiag"
    }
  })

  # shrinkage ------------------------------------------------------------------
  shrinkage <- if (k %in% names(Mlist$shrinkage)) {
    Mlist$shrinkage[k]
  } else if (is.null(names(Mlist$shrinkage))) {
    Mlist$shrinkage
  }

  assoc_type <- if (modeltype %in% "JM") {
    get_assoc_type(
      get_assoc_covars(lp, Mlist, tvars),
      Mlist$models,
      assoc_type,
      Mlist$refs
    )
  } else if (modeltype %in% "coxph") {
    "obs.value"
  } else if (isTRUE(isgk)) {
    get_assoc_type(setNames(k, k), Mlist$models, assoc_type, Mlist$refs)
  }

  # collect all info ---------------------------------------------------------
  info <- list(
    varname = if (modeltype %in% c("survreg", "coxph", "JM")) {
      internal_clean_survname(k)
    } else {
      k
    },
    modeltype = modeltype,
    family = family,
    link = link,
    resp_mat = resp_mat,
    resp_col = resp_col,
    dummy_cols = dummy_cols,
    ncat = length(levels(Mlist$refs[[k]])),
    rev = k %in% Mlist$rev,
    lp = lp,
    parelmts = parelmts,
    scale_pars = scale_pars,
    index = index,
    parname = switch(
      as.character(k %in% names(Mlist$fixed)),
      "TRUE" = "beta",
      "FALSE" = "alpha"
    ),
    hc_list = if (length(hc_list) > 0L) hc_list,
    nranef = nranef,
    rd_vcov = rd_vcov,
    group_lvls = Mlist$group_lvls,
    trafos = trafos,
    fcts_all = Mlist$fcts_all,
    trunc = trunc[[k]],
    custom = custom[[k]],
    ppc = FALSE,
    shrinkage = shrinkage,
    refs = Mlist$refs[[k]],
    covnames = covnames,
    assoc_type = assoc_type,
    tv_vars = tv_vars,
    N = Mlist$N,
    df_basehaz = Mlist$df_basehaz
  )

  # only added when there are such interactions, so that the model info of
  # all other models stays as it was
  if (length(jm_interactions) > 0L) {
    info$jm_interactions <- jm_interactions
  }

  # the same for models that are part of a model for a residual standard deviation
  if (k %in% Mlist$logsd_of) {
    info$logsd_var <- names(Mlist$logsd_of)[Mlist$logsd_of == k]
  }
  if (k %in% names(Mlist$logsd_of)) {
    info$is_logsd <- TRUE
  }

  info
}


#' Identify the general model type from the covariate model type
#' @param model character string; the covariate model type
#' @keywords internal
get_modeltype <- function(model) {
  modtype <- if (!is.null(model)) {
    switch(
      model,
      lm = "glm",
      glm_gaussian_identity = "glm",
      glm_gaussian_log = "glm",
      glm_gaussian_inverse = "glm",
      glm_binomial_logit = "glm",
      glm_binomial_probit = "glm",
      glm_binomial_log = "glm",
      glm_binomial_cloglog = "glm",
      glm_logit = "glm",
      glm_probit = "glm",
      glm_gamma_inverse = "glm",
      glm_gamma_identity = "glm",
      glm_gamma_log = "glm",
      glm_poisson_log = "glm",
      glm_poisson_identity = "glm",
      lognorm = "glm",
      beta = "glm",
      lmm = "glmm",
      glmm_gaussian_identity = "glmm",
      glmm_gaussian_log = "glmm",
      glmm_gaussian_inverse = "glmm",
      glmm_binomial_logit = "glmm",
      glmm_binomial_probit = "glmm",
      glmm_binomial_log = "glmm",
      glmm_binomial_cloglog = "glmm",
      glmm_logit = "glmm",
      glmm_probit = "glmm",
      glmm_gamma_inverse = "glmm",
      glmm_gamma_identity = "glmm",
      glmm_gamma_log = "glmm",
      glmm_poisson_log = "glmm",
      glmm_poisson_identity = "glmm",
      glmm_lognorm = "glmm",
      glmm_beta = "glmm",
      clm = "clm",
      clmm = "clmm",
      mlogit = "mlogit",
      mlogitmm = "mlogitmm",
      coxph = "coxph",
      survreg = "survreg",
      JM = "JM",
      errormsg("I do not know the model type %s.", dQuote(model))
    )
  }

  modtype
}

#' Identify the family from the covariate model type
#' @param model character string; the covariate model type
#' @keywords internal
get_family <- function(model) {
  if (!is.null(model)) {
    switch(
      model,
      lm = "gaussian",
      glm_gaussian_identity = "gaussian",
      glm_gaussian_log = "gaussian",
      glm_gaussian_inverse = "gaussian",
      glm_binomial_logit = "binomial",
      glm_binomial_probit = "binomial",
      glm_binomial_log = "binomial",
      glm_binomial_cloglog = "binomial",
      glm_logit = "binomial",
      glm_probit = "binomial",
      glm_gamma_inverse = "Gamma",
      glm_gamma_identity = "Gamma",
      glm_gamma_log = "Gamma",
      glm_poisson_log = "poisson",
      glm_poisson_identity = "poisson",
      lognorm = "lognorm",
      beta = "beta",
      lmm = "gaussian",
      glmm_gaussian_identity = "gaussian",
      glmm_gaussian_log = "gaussian",
      glmm_gaussian_inverse = "gaussian",
      glmm_binomial_logit = "binomial",
      glmm_binomial_probit = "binomial",
      glmm_binomial_log = "binomial",
      glmm_binomial_cloglog = "binomial",
      glmm_logit = "binomial",
      glmm_probit = "binomial",
      glmm_gamma_inverse = "Gamma",
      glmm_gamma_identity = "Gamma",
      glmm_gamma_log = "Gamma",
      glmm_poisson_log = "poisson",
      glmm_poisson_identity = "poisson",
      glmm_lognorm = "lognorm",
      glmm_beta = "beta",
      clm = NULL,
      clmm = NULL,
      mlogit = NULL,
      mlogitmm = NULL,
      coxph = NULL,
      survreg = NULL,
      JM = NULL,
      errormsg("I do not know the model type %s.", dQuote(model))
    )
  }
}

get_link <- function(model) {
  if (!is.null(model)) {
    switch(
      model,
      lm = "identity",
      glm_gaussian_identity = "identity",
      glm_gaussian_log = "log",
      glm_gaussian_inverse = "inverse",
      glm_binomial_logit = "logit",
      glm_binomial_probit = "probit",
      glm_binomial_log = "log",
      glm_binomial_cloglog = "cloglog",
      glm_logit = "logit",
      glm_probit = "probit",
      glm_gamma_inverse = "inverse",
      glm_gamma_identity = "identity",
      glm_gamma_log = "log",
      glm_poisson_log = "log",
      glm_poisson_identity = "identity",
      lognorm = "identity",
      beta = "logit",
      lmm = "identity",
      glmm_gaussian_identity = "identity",
      glmm_gaussian_log = "log",
      glmm_gaussian_inverse = "inverse",
      glmm_binomial_logit = "logit",
      glmm_binomial_probit = "probit",
      glmm_binomial_log = "log",
      glmm_binomial_cloglog = "cloglog",
      glmm_logit = "logit",
      glmm_probit = "probit",
      glmm_gamma_inverse = "inverse",
      glmm_gamma_identity = "identity",
      glmm_gamma_log = "log",
      glmm_poisson_log = "log",
      glmm_poisson_identity = "identity",
      glmm_lognorm = "identity",
      glmm_beta = "logit",
      clm = NULL,
      clmm = NULL,
      mlogit = NULL,
      mlogitmm = NULL,
      coxph = NULL,
      survreg = NULL,
      JM = NULL,
      errormsg("I do not know the model type %s.", dQuote(model))
    )
  }
}


#' Interactions in the time-varying part of the survival model of a joint model
#'
#' Selects the interaction terms among the time-varying columns of the linear
#' predictor of the survival part of a joint model, and checks that all their
#' elements are on the level of the time-varying covariates or on the level of
#' the survival outcome.
#'
#' @param lp_cols named integer vector: the columns of `M_lvlone` in the linear
#'   predictor of the survival model (names are the column names).
#' @param interactions list of interaction terms, as in `Mlist$interactions`
#'   (output of `match_interaction()`).
#' @param surv_mat name of the design matrix of the level of the survival
#'   outcome, e.g., `"M_id"`.
#'
#' @returns A (possibly empty) named list: the elements of `interactions` that
#'   are columns in `lp_cols`.
#' @keywords internal
get_jm_interactions <- function(lp_cols, interactions, surv_mat) {
  jm_interactions <- interactions[
    intersect(names(lp_cols), names(interactions))
  ]

  for (inter in jm_interactions) {
    elmt_mats <- names(inter$elmts)
    if (!all(elmt_mats %in% c("M_lvlone", surv_mat))) {
      errormsg(
        "The interaction %s in the survival part of the joint model involves
        a variable from a level above the level of the survival outcome. This
        is not possible.",
        dQuote(attr(inter, "interaction"))
      )
    }
  }

  jm_interactions
}


#' Interactions in the survival part of a joint model with unknown elements
#'
#' An interaction term is only recognised as such (in `Mlist$interactions`)
#' when all its elements are columns of the design matrices. In the
#' time-varying part of the linear predictor of the survival part of a joint
#' model, the value of an interaction term is the product of its elements
#' (see `paste_jm_interaction()`), so that an interaction with an element that
#' is not a column is not possible. This happens
#' * for an interaction with a function of the time variable (e.g.,
#'   `chol:ns(day, df = 3)`) without the main effect of this function: as a
#'   workaround, the function can be added to the data with the argument
#'   `auxvars` (this does not change the models for incomplete covariates,
#'   because they already contain the time variable);
#' * for an interaction of a factor with a variable without the main effect of
#'   that variable (e.g., `sex + sex:day`): R (`model.matrix()`) then codes
#'   the interaction with all categories of the factor, also the reference
#'   category (`sexmale:day` and `sexfemale:day`), which is not a column of the
#'   design matrix. Together, these terms contain a main effect of the other
#'   variable, which, for the time variable or a function of it, cannot (or
#'   hardly) be distinguished from the baseline hazard.
#'
#' Stops with an informative error if there is such an interaction.
#'
#' @param lp_cols named integer vector: the columns of `M_lvlone` in the linear
#'   predictor of the survival model (names are the column names).
#' @param interactions list of interaction terms, as in `Mlist$interactions`
#'   (output of `match_interaction()`).
#' @param design_cols character vector: the names of all columns of the design
#'   matrices.
#' @param refs list of reference category information (`Mlist$refs`).
#' @param timevar name of the time variable.
#'
#' @returns `NULL`, invisibly; called for the error.
#' @keywords internal
check_jm_unknown_interactions <- function(
  lp_cols,
  interactions,
  design_cols,
  refs,
  timevar
) {
  # interaction columns that were not recognised as interactions
  is_inter <- grepl(":", names(lp_cols), fixed = TRUE)
  unknown <- setdiff(names(lp_cols)[is_inter], names(interactions))

  for (inter in unknown) {
    elmts <- strsplit(inter, ":", fixed = TRUE)[[1L]]
    missing_elmts <- setdiff(elmts, design_cols)

    # does an element involve the time variable (e.g., "ns(day, df = 3)1")?
    timevar_pattern <- paste0(
      "(^|[^[:alnum:]._])",
      gsub("([.])", "\\\\\\1", timevar),
      "($|[^[:alnum:]._])"
    )

    # a missing element that starts with the name of a factor is a category of
    # that factor: R codes the interaction of a factor with a variable whose
    # main effect is not in the formula with all categories of the factor
    # (e.g., "sexmale:day" and "sexfemale:day" for `sex + sex:day`), also with
    # the reference category, which is not a column of the design matrix
    factor_of <- function(elmt) {
      fcts <- names(refs)[startsWith(elmt, names(refs))]
      fcts[which.max(nchar(fcts))]
    }
    is_category <- vapply(
      missing_elmts,
      function(elmt) length(factor_of(elmt)) > 0L,
      FUN.VALUE = logical(1L)
    )

    if (any(is_category)) {
      category <- missing_elmts[is_category][1L]
      fct <- factor_of(category)
      # the other element(s) of the interaction, as terms of the formula
      # (e.g., "ns(day, df = 3)" instead of "ns(day, df = 3)1")
      others <- setdiff(elmts, category)
      others <- unique(sub("\\)[0-9]+$", ")", others))

      msg_coding <- sprintf(
        "The interaction %s in the survival part of the joint model cannot be
        used. Because the main effect of %s is not in the survival model, R
        codes the interaction of the factor %s with %s using all categories
        of %s, including the reference category (%s). Together, these
        interaction terms contain a main effect of %s.",
        dQuote(inter),
        paste_and(dQuote(others)),
        dQuote(fct),
        paste_and(dQuote(others)),
        dQuote(fct),
        dQuote(category),
        paste_and(dQuote(others))
      )

      if (any(grepl(timevar_pattern, others))) {
        errormsg(
          "%s A main effect of the time variable cannot be distinguished from
          the baseline hazard, and a main effect of a function of it (e.g., a
          spline) hardly. An interaction of %s with %s that is coded without
          the reference category of %s is currently not possible in the
          survival part of a joint model.",
          msg_coding,
          dQuote(fct),
          paste_and(dQuote(others)),
          dQuote(fct)
        )
      }

      errormsg(
        "%s Please add the main effect of %s to the survival model; the
        interaction is then coded without the reference category of %s.",
        msg_coding,
        paste_and(dQuote(others)),
        dQuote(fct)
      )
    }

    if (grepl(timevar_pattern, missing_elmts[1L])) {
      errormsg(
        "The interaction %s in the survival part of the joint model involves
        %s, which is not a column of the data used in the model, because its
        main effect is not in the model. As a workaround, a function of the
        time variable can be added to the data with the argument %s (e.g.,
        %s). The argument %s is meant for additional variables in the models
        for incomplete covariates; these models are not changed by a function
        of the time variable, because the time variable itself is already
        added to %s automatically.",
        dQuote(inter),
        dQuote(missing_elmts[1L]),
        dQuote("auxvars"),
        sQuote(paste0("auxvars = ~ ns(", timevar, ", df = 3)")),
        dQuote("auxvars"),
        dQuote("auxvars")
      )
    }

    errormsg(
      "The interaction %s in the survival part of the joint model involves
      %s, which is not a column of the data used in the model, because its
      main effect is not in the model. Please add the main effect of %s to
      the model.",
      dQuote(inter),
      dQuote(missing_elmts[1L]),
      dQuote(missing_elmts[1L])
    )
  }

  invisible(NULL)
}


#' Time-varying covariates with an association type in a joint model
#'
#' Finds the columns of the linear predictor of the survival part of a joint
#' model that need an association type, and the variable each of them belongs to.
#'
#' Interaction terms are replaced by their elements, so that a covariate that is
#' only part of an interaction also gets an association type. Dummy variables
#' are replaced by their factor. A function of several variables (e.g.,
#' `I(age * trig)`) has one entry per variable, with the name of the column
#' repeated, so that names and variables stay aligned; those that are not
#' time-varying are then dropped.
#'
#' @param lp list per design matrix with the columns of the linear predictor
#'   (named vectors of column numbers)
#' @param Mlist list of model information, as created by `divide_matrices()`;
#'   used are `interactions`, `refs` and `fcts_all`
#' @param tvars character vector with the names of the time-varying covariates
#'
#' @returns A character vector with the names of the variables, named by the
#'   column (for a factor: the name of the factor).
#' @keywords internal
get_assoc_covars <- function(lp, Mlist, tvars) {
  lp_columns <- unique(unlist(lapply(
    names(unlist(unname(lp))),
    replace_interaction,
    Mlist$interactions
  )))
  columns <- unique(unlist(lapply(lp_columns, replace_dummy, Mlist$refs)))

  vars_per_column <- lapply(columns, replace_trafo, Mlist$fcts_all)
  covrs <- setNames(
    unlist(vars_per_column),
    rep(columns, lengths(vars_per_column))
  )

  covrs[covrs %in% tvars]
}


#' The term in the model formula that a column of a design matrix belongs to
#'
#' A function with several columns (e.g., `ns(chol, df = 2)`, with the columns
#' `ns(chol, df = 2)1` and `ns(chol, df = 2)2`) is one term. Any other column is
#' its own term.
#'
#' @param columns character vector of column names
#' @param trafos data.frame with information on the transformations, with the
#'   columns `colname` and `fct` (`Mlist$fcts_all`), or `NULL`
#'
#' @returns A character vector with the term of each column.
#' @keywords internal
column_to_term <- function(columns, trafos) {
  terms <- columns
  rows <- match(columns, trafos$colname)
  has_trafo <- !is.na(rows)
  terms[has_trafo] <- trafos$fct[rows[has_trafo]]
  terms
}


#' Check the specification of a joint model
#'
#' A joint model needs subjects with repeated measurements and something that
#' changes over time in the survival part. This function
#' * stops if the survival outcome is on the level of the observations: without
#'   a random effects structure, there is no grouping, and each row of the data
#'   would be one subject, with time-varying covariates used as baseline
#'   covariates;
#' * stops if there is nothing longitudinal at all, i.e., no time-varying term
#'   in the survival part and no longitudinal model (this is a proportional
#'   hazards model);
#' * gives a warning for a time-varying covariate in the survival part with an
#'   automatically added model, which only has a random intercept and so may not
#'   describe the change of the covariate over time well enough for a joint model;
#' * gives a warning if the only time-varying terms in the survival part are
#'   effects of baseline covariates that change with time, and there is no
#'   longitudinal model. (It does not point to `coxph_imp()`, which currently
#'   stops with an error for a term with the time variable.)
#' * gives a warning for a sub-model whose outcome is neither in the survival
#'   part nor a covariate in another sub-model, because this outcome is assumed
#'   to be independent of the survival outcome.
#'
#' @param info_list list of model information, from `get_model_info()`
#' @param Mlist list of model information, as created by `divide_matrices()`
#' @param warn logical; should the warnings be given?
#'
#' @returns `NULL`, invisibly; called for its errors and warnings.
#' @keywords internal
check_jm_specification <- function(info_list, Mlist, warn = TRUE) {
  is_jm <- lvapply(info_list, function(info) info$modeltype %in% "JM")

  if (!any(is_jm)) {
    return(invisible(NULL))
  }

  # no grouping: each row of the data would be one subject
  on_lvlone <- lvapply(info_list[is_jm], function(info) {
    info$resp_mat[2L] == "M_lvlone"
  })
  if (any(on_lvlone)) {
    errormsg(
      "A joint model needs a grouping variable, but no random effects structure
      is specified, so that each row of the data would be one subject.
      Specify a longitudinal model for the time-varying covariates in the
      survival part (e.g., %s), or add a random effects structure to the
      formula. A joint model without time-varying covariates is not meaningful.",
      dQuote(paste0(
        "x ~ ",
        Mlist$timevar,
        " + (",
        Mlist$timevar,
        " | id)"
      ))
    )
  }

  # the sub-models of the formula (not the automatically added covariate models)
  is_surv <- lvapply(Mlist$fixed, function(fmla) {
    attr(fmla, "type") %in% c("survreg", "coxph", "JM")
  })
  submodels <- names(Mlist$fixed)[!is_surv]

  # nothing longitudinal: this is a proportional hazards model
  has_tv_part <- lvapply(info_list[is_jm], function(info) {
    length(info$lp[["M_lvlone"]]) > 0L
  })
  is_long <- lvapply(info_list[submodels], function(info) {
    "M_lvlone" %in% info$resp_mat
  })
  if (!any(has_tv_part) && !any(is_long)) {
    errormsg(
      "The joint model has no time-varying covariates in the survival part and
      no longitudinal model. For a proportional hazards model use %s.",
      dQuote("coxph_imp()")
    )
  }

  if (!warn) {
    return(invisible(NULL))
  }

  # automatically added models of time-varying covariates in the survival part
  # (`tv_vars` also has the covariates of the models of these covariates)
  tv_vars <- unique(unlist(lapply(info_list[is_jm], function(info) {
    names(info$tv_vars)
  })))
  surv_vars <- unlist(lapply(Mlist$fixed[is_surv], function(fmla) {
    all.vars(fmla[[3L]])
  }))
  automatic <- setdiff(intersect(tv_vars, surv_vars), names(Mlist$fixed))
  if (length(automatic) > 0L) {
    warnmsg(
      "The models for the time-varying covariate(s) %s were added automatically,
      with only a random intercept. In a joint model, the change of these
      covariates over time needs to be modelled appropriately. Specify the
      model(s) in the formula (e.g., %s), or use a time-dependent proportional
      hazards model (%s).",
      paste_and(automatic, dQ = TRUE),
      dQuote(paste0(
        automatic[1L],
        " ~ ",
        Mlist$timevar,
        " + (",
        Mlist$timevar,
        " | id)"
      )),
      dQuote("coxph_imp()")
    )
  }

  # time-varying effects of baseline covariates are the only time-varying terms
  if (any(has_tv_part) && length(tv_vars) == 0L && !any(is_long)) {
    warnmsg(
      "This is not really a joint model: the only time-varying terms in the
      survival part are effects of baseline covariates that change with %s, and
      there is no longitudinal model.",
      dQuote(Mlist$timevar)
    )
  }

  # outcomes that are not linked to the survival outcome
  unlinked <- character(0L)
  for (outcome in submodels) {
    other_fmlas <- Mlist$fixed[names(Mlist$fixed) != outcome]
    used <- unlist(lapply(other_fmlas, function(fmla) all.vars(fmla[[3L]])))
    # an outcome and the log of its residual standard deviation are linked to
    # the survival outcome if one of them is used
    pair <- c(
      outcome,
      Mlist$logsd_of[outcome],
      names(Mlist$logsd_of)[Mlist$logsd_of == outcome]
    )
    if (!any(pair %in% used)) {
      unlinked <- c(unlinked, outcome)
    }
  }
  if (length(unlinked) > 0L) {
    warnmsg(
      "The outcome(s) %s of the sub-models are not part of the survival model or
      of another sub-model. They are assumed to be independent of the survival
      outcome.",
      paste_and(unlinked, dQ = TRUE)
    )
  }

  invisible(NULL)
}


#' Check the names in `assoc_type`
#'
#' The names in `assoc_type` have to be terms in the survival part of a joint
#' model that have an association type, i.e., a time-varying covariate or a
#' function of it. Anything else (which would otherwise be ignored) is an error.
#' A function with several columns is one term, and an interaction has no name of
#' its own: it uses the association types of its elements.
#' With several survival outcomes, a name has to apply to one of them. Does
#' nothing if the model has no survival part of a joint model.
#'
#' @param assoc_type named vector of association types, as given by the user, or
#'   `NULL`
#' @param info_list list of model information, from `get_model_info()`
#' @param Mlist list of model information, as created by `divide_matrices()`
#'
#' @returns `NULL`, invisibly; called for its error.
#' @keywords internal
check_assoc_type_names <- function(assoc_type, info_list, Mlist) {
  is_jm <- vapply(
    info_list,
    function(info) info$modeltype %in% "JM",
    logical(1L)
  )

  if (is.null(assoc_type) || !any(is_jm)) {
    return(invisible(NULL))
  }

  possible <- character(0L)
  for (info in info_list[is_jm]) {
    covrs <- get_assoc_covars(info$lp, Mlist, names(info$tv_vars))
    possible <- c(possible, column_to_term(names(covrs), Mlist$fcts_all))
  }
  possible <- unique(possible)

  # a vector without names cannot be used at all
  usernames <- if (is.null(names(assoc_type))) {
    rep("", length(assoc_type))
  } else {
    names(assoc_type)
  }
  unknown <- unique(usernames[!usernames %in% possible])

  if (length(unknown) > 0L) {
    errormsg(
      "The name(s) %s in %s are not valid. The names have to be time-varying
      terms in the survival part of the model, as written in the formula.
      Possible names are: %s.",
      paste_and(unknown, dQ = TRUE),
      dQuote("assoc_type"),
      if (length(possible) > 0L) paste_and(possible, dQ = TRUE) else "none"
    )
  }

  invisible(NULL)
}


get_assoc_type <- function(covnames, models, assoc_type, refs) {
  assoc_type_user <- assoc_type

  fmlys <- lapply(models[covnames], get_family)

  assoc_type <- setNames(rep("obs.value", length(covnames)), names(covnames))
  assoc_type[fmlys %in% c("gaussian", "Gamma", "lognorm", "beta")] <-
    "underl.value"

  if (!is.null(assoc_type_user)) {
    assoc_type[intersect(names(assoc_type_user), names(assoc_type))] <-
      assoc_type_user[intersect(names(assoc_type_user), names(assoc_type))]
  }

  unlist(lapply(seq_along(assoc_type), function(k) {
    if (names(assoc_type)[k] %in% names(refs)) {
      setNames(
        rep(
          assoc_type[k],
          length(attr(refs[[names(assoc_type)[k]]], "dummies"))
        ),
        attr(refs[[names(assoc_type)[k]]], "dummies")
      )
    } else {
      assoc_type[k]
    }
  }))
}


#' Functions of several variables in the survival part of a joint model
#'
#' In the time-varying part of the linear predictor of the survival part of a
#' joint model, the value of a column is written in terms of one variable (see
#' `paste_linpred_jm()`), which, for example, is replaced by its expected value
#' for the association type `"underl.value"`. A function of several variables
#' (e.g., `I(age * chol)`) that is part of `M_lvlone` because at least one of the
#' variables is time-varying is therefore not possible. Functions of several
#' baseline variables are not concerned.
#'
#' Stops with an informative error if there is such a term.
#'
#' @param lp_cols named integer vector: the columns of `M_lvlone` in the linear
#'   predictor of the survival model (names are the column names).
#' @param trafos data.frame with information on the transformations, with the
#'   columns `colname`, `fct` and `var` (`Mlist$fcts_all`), or `NULL`.
#'
#' @returns `NULL`, invisibly; called for the error.
#' @keywords internal
check_jm_function_terms <- function(lp_cols, trafos) {
  for (column in names(lp_cols)) {
    # via the term and not the column: a function with several columns can have
    # a different variable per column (e.g., `ns(age * day, df = 2)`)
    term <- column_to_term(column, trafos)
    variables <- unique(trafos$var[trafos$fct %in% term])

    if (length(variables) > 1L) {
      errormsg(
        "The term %s in the survival part of the joint model is a function of
        several variables (%s), at least one of which is time-varying. This is
        currently not possible. A product of these variables can be specified
        as the interaction %s, with the main effects as needed.",
        dQuote(term),
        paste_and(dQuote(variables)),
        dQuote(paste0(variables, collapse = ":"))
      )
    }
  }

  invisible(NULL)
}


#' Terms of only the time variable in the survival part of a joint model
#'
#' The baseline hazard of a joint model is a (spline) function of time, so that
#' the effect of a term that involves nothing but the time variable (e.g., `day`,
#' `ns(day, df = 3)`, `log(day + 1)` or `I(day^2)`) cannot (or hardly) be
#' distinguished from it. Interactions of the time variable with another
#' variable (e.g., `chol:day`) describe an effect of that other variable that
#' changes over time, and are not concerned.
#'
#' Stops with an informative error if there is such a term.
#'
#' @param fixed the formula of the survival model.
#' @param timevar name of the time variable.
#'
#' @returns `NULL`, invisibly; called for the error.
#' @keywords internal
check_jm_time_terms <- function(fixed, timevar) {
  # matrix with variables in the rows and terms in the columns, e.g., the
  # variable "ns(day, df = 3)" and the terms "ns(day, df = 3)" and
  # "chol:ns(day, df = 3)"
  term_factors <- attr(terms(fixed), "factors")

  time_terms <- character(0L)
  for (term in colnames(term_factors)) {
    term_vars <- rownames(term_factors)[term_factors[, term] > 0L]

    # the data variables used in each of the variables of this term
    only_time <- vapply(
      term_vars,
      function(var) identical(all.vars(str2lang(var)), timevar),
      FUN.VALUE = logical(1L)
    )

    if (all(only_time)) {
      time_terms <- c(time_terms, term)
    }
  }

  if (length(time_terms) > 0L) {
    errormsg(
      "The time variable %s is part of the linear predictor of the survival
      model, in %s. In a joint model, the effect of time is described by the
      baseline hazard. Please remove %s from the model formula of the survival
      model.",
      dQuote(timevar),
      paste_and(dQuote(time_terms)),
      paste_and(dQuote(time_terms))
    )
  }

  invisible(NULL)
}


# used in get_model_info() (2020-07-08)
get_lp <- function(k, Mlist) {
  # obtain the linear predictor for a given response variable for all levels
  # k: the name of the response
  # Mlist: obtained from divide_matrices()

  lplist <- setNames(
    lapply(names(Mlist$lp_cols[[k]]), function(lvl) {
      lpc <- Mlist$lp_cols[[k]][[lvl]]
      list(
        prop = lpc[!names(lpc) %in% Mlist$lp_nonprop[[k]][[lvl]]],
        nonprop = lpc[names(lpc) %in% Mlist$lp_nonprop[[k]][[lvl]]]
      )
    }),
    names(Mlist$lp_cols[[k]])
  )

  lp <- lapply(lplist, "[[", "prop")

  if (!is.null(Mlist$lp_nonprop[[k]])) {
    attr(lp, "nonprop") <- lapply(lplist, "[[", "nonprop")
  }
  lp
}


get_parelmts <- function(k, Mlist, par_index_main, par_index_other, lp) {
  par_ind_mat <- if (k %in% names(Mlist$fixed)) {
    par_index_main
  } else {
    par_index_other
  }

  if (any(is.na(par_ind_mat))) {
    errormsg(
      "There are missing values in the matrix %s.",
      switch(
        as.character(k %in% names(Mlist$fixed)),
        "TRUE" = "par_index_main",
        "FALSE" = "par_index_other"
      )
    )
  }

  nlapply(rownames(par_ind_mat[[k]]), function(lvl) {
    parnums <- par_ind_mat[[k]][lvl, 1L]:par_ind_mat[[k]][lvl, 2L]

    if (Mlist$models[k] %in% c("mlogit", "mlogitmm")) {
      if (length(levels(Mlist$refs[[k]])) == 0L) {
        errormsg(
          "It seems the variable %s is numeric, but to fit a multinomial
                 logit model the response variable must be a factor with at
                 least three levels.",
          dQuote(k)
        )
      } else if (length(levels(Mlist$refs[[k]])) < 3L) {
        errormsg(
          "The variable %s has less than three levels. You should use
                 a binomial model for this variable instead of a multinomial
                 model.",
          dQuote(k)
        )
      }

      parnums <- setNames(
        par_ind_mat[[k]][lvl, 1L]:par_ind_mat[[k]][lvl, 2L],
        rep(names(lp[[lvl]]), length(levels(Mlist$refs[[k]])) - 1L)
      )

      split(
        parnums,
        rep(paste0(k, levels(Mlist$refs[[k]])[-1L]), each = length(lp[[lvl]]))
      )
    } else if (Mlist$models[[k]] %in% c("clm", "clmm")) {
      # parameter elements for covariates with proportional effects
      parnums_prop <- setNames(parnums[seq_along(lp[[lvl]])], names(lp[[lvl]]))

      # parameter elements for covariates with non-proportional effects
      parnums_nonprop <- setNames(
        setdiff(parnums, parnums_prop),
        rep(
          names(attr(lp, "nonprop")[[lvl]]),
          length(attr(Mlist$refs[[k]], "dummies"))
        )
      )

      parnums_nonprop <- split(
        parnums_nonprop,
        rep(
          paste0(k, levels(Mlist$refs[[k]])[-1L]),
          each = length(attr(lp, "nonprop")[[lvl]])
        )
      )

      if (length(parnums_nonprop) > 0L) {
        attr(parnums_prop, "nonprop") <- parnums_nonprop
      }
      parnums_prop
    } else {
      setNames(parnums, names(lp[[lvl]]))
    }
  })
}


get_indices <- function(Mlist) {
  setNames(
    vapply(
      seq_along(sort(Mlist$group_lvls)),
      function(q) paste0(rep("i", q), collapse = ""),
      FUN.VALUE = character(1L)
    ),
    names(sort(Mlist$group_lvls))
  )
}
