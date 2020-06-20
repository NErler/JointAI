# get model info for a list of models
get_model_info <- function(Mlist, K, K_imp, trunc = NULL, assoc_type = NULL) {
  args <- as.list(match.call())[-1L]

  sapply(names(Mlist$lp_cols), function(k) {
    do.call(get_model1_info, c(k = replace_dummy(k, refs = Mlist$refs), args))
  },  simplify = FALSE)
}


# get model info for a single model
get_model1_info <- function(k, Mlist, K, K_imp, trunc = NULL, assoc_type = NULL,
                            isgk = FALSE) {

  arglist <- as.list(match.call())[-1L]

  # model type, family & link -------------------------------------------------
  modeltype <- get_modeltype(Mlist$models[k])
  family <- get_family(Mlist$models[k])
  link <- get_link(Mlist$models[k])


  # response matrix and column(s) --------------------------------------------
  resp_mat <- if (k %in% names(Mlist$Mlvls)) {
    # if the variable is a column of one of the design matrices, use the level
    # of that matrix
    Mlist$Mlvls[k]
  } else if (attr(Mlist$fixed[[k]], 'type') %in% c('survreg', 'coxph', 'JM')) {
    # if the model is a survival model (variable name is the survival expression
    # and not a single variable name) get the levels of the separate variables
    # involved in the survival expression
    if (all(names(Mlist$outcomes$outcomes[[k]]) %in% names(Mlist$Mlvls))) {
      Mlist$Mlvls[names(Mlist$outcomes$outcomes[[k]])]
    } else {
      errormsg("I have identified %s as a survival outcome, but I cannot find
               some of its elements in any of the matrices %s.",
                 dQuote(k), dQuote("M"))
    }
  } else {
    errormsg("I cannot find the variable %s in any of the matrices %s.",
             dQuote(k), dQuote("M"))
  }

  resp_col <- if (k %in% names(Mlist$fixed) &&
                  attr(Mlist$fixed[[k]], "type") %in%
                  c("survreg", "coxph", "JM")) {
    sapply(names(Mlist$outcomes$outcomes[[k]]), function(x) {
      match(x, colnames(Mlist$M[[resp_mat[x]]]))
    })
  } else {
    match(k, colnames(Mlist$M[[resp_mat[1]]]))
  }

  # linear predictor columns -------------------------------------------------
  lp <- Mlist$lp_cols[[k]]

  # parameter elements ------------------------------------------------------
  parelmts <- if (k %in% names(Mlist$fixed)) {
    # for variables for which model was specified in fixed, use the
    # parameters given in the matrix K
    sapply(rownames(K[[k]]), function(i) {
      if (!any(is.na(K[[k]][i, ]))) {
        if (Mlist$models[k] %in% c('mlogit', 'mlogitmm')) {
          split(K[[k]][i, 1]:K[[k]][i, 2],
                rep(attr(Mlist$refs[[k]], 'dummies'),
                    each = length(lp[[i]])))
        } else {
          K[[k]][i, 1]:K[[k]][i, 2]
        }
      }
    }, simplify = FALSE)
  } else {
    # for variables for which no model was specified in fixed, use the
    # parameters given in K_imp
    sapply(rownames(K_imp[[k]]), function(i) {
      if (!any(is.na(K_imp[[k]][i, ]))) {
        if (Mlist$models[k] %in% c('mlogit', 'mlogitmm')) {
          split(K_imp[[k]][i, 1]:K_imp[[k]][i, 2],
                rep(seq_len(length(levels(Mlist$refs[[k]])[-1])),
                    each = length(lp[[i]])))
        } else {
          K_imp[[k]][i, 1]:K_imp[[k]][i, 2]
        }
      }
    }, simplify = FALSE)
  }

  parelmts <- mapply(function(pe, linpred) {
    if (is.list(pe)) {
      for (i in seq_along(pe))
        names(pe[[i]]) <- names(linpred)
      pe
    } else {
      setNames(pe, names(linpred))
    }
  }, pe = parelmts, linpred = lp, SIMPLIFY = FALSE)


  # scaling parameter matrices -----------------------------------------------
  scale_pars <- Mlist$scale_pars

  # dummy columns -------------------------------------------------------------
  dummy_cols <- if (k %in% names(Mlist$refs) &
                    (any(is.na(Mlist$M[[resp_mat[1]]][, resp_col[1]])) |
                     any(sapply(Mlist$fixed, 'attr', 'type') %in% 'JM'))) {
    match(attr(Mlist$refs[[k]], 'dummies'), colnames(Mlist$M[[resp_mat[1]]]))
  }

  if (all(is.na(dummy_cols)))
    dummy_cols <- NULL


  # index name -----------------------------------------------------------------
  index <- setNames(sapply(seq_along(sort(Mlist$group_lvls)),
                           function(k) paste0(rep('i', k), collapse = '')),
                    names(sort(Mlist$group_lvls)))



  # transformations ------------------------------------------------------------
  trafos <- paste_trafos(Mlist, varname = k,
                         index = index[gsub("M_", "", resp_mat[1])],
                         isgk = isgk)

  # JM settings ----------------------------------------------------------------
  # * covariate names ----------------------------------------------------------
  covnames <- if (modeltype %in% "JM") {
    unique(unlist(sapply(lp, function(x) sapply(names(x), replace_dummy,
                                                refs = Mlist$refs))))
  }

  # * time-varying covariates --------------------------------------------------
  tv_vars <- if (modeltype %in% "JM") {

    # find the (longitudinal) covariates involved in the lp of the survival part
    covars <- unlist(sapply(unlist(sapply(lp, names)),
                            replace_trafo, Mlist$fcts_all))
    covars <- sapply(covars, replace_dummy, refs = Mlist$refs)
    covars <- covars[covars %in% unlist(sapply(Mlist$M, colnames))]


    rep_lvls <- names(which(Mlist$group_lvls < Mlist$group_lvls[
      gsub("M_", "", resp_mat[2])]))

    tvars <- unique(unlist(c(sapply(lp[paste0("M_", rep_lvls)], names),
                             lapply(Mlist$lp_cols[covars], function(x)
                               names(unlist(unname(x[paste0("M_", rep_lvls)]))))
    )))


    # get the variables needed to re-fit the models for 'covars' in the
    # Gauss-Kronrod quadrature
    tvars <- unlist(sapply(tvars, replace_trafo, Mlist$fcts_all))

    tvars <- unique(sapply(tvars[!tvars %in% Mlist$timevar],
                           replace_dummy, refs = Mlist$refs))

    # get the model info for these variables
    sapply(tvars, function(i) {
      arglist_new <- arglist
      arglist_new$k <- replace_dummy(i, refs = Mlist$refs)
      arglist_new$isgk <- TRUE
      subinfo <- do.call(get_model1_info, arglist_new)
      subinfo$surv_lvl <- gsub("M_", "", resp_mat[2])
      subinfo
    },  simplify = FALSE)
  }



  # Hierarchical centering -----------------------------------------------------
  hc_list <- get_hc_info(varname = k,
                         lvl = gsub("M_", "", resp_mat[length(resp_mat)]),
                         Mlist, parelmts, lp)
  nranef <- sapply(hc_list$hcvars, function(x)
    as.numeric(attr(x, 'rd_intercept')) +
      ifelse(any(!sapply(x$rd_slope_coefs, is.null)),
             nrow(do.call(rbind, x$rd_slope_coefs)), 0))


  # shrinkage ------------------------------------------------------------------
  shrinkage <- if (k %in% names(Mlist$shrinkage)) {
    Mlist$shrinkage[k]
  } else if (is.null(names(Mlist$shrinkage))) {
    Mlist$shrinkage
  }


  # collect all info ---------------------------------------------------------
  list(
    varname = if (modeltype %in% c('survreg', 'coxph', 'JM')) {
      clean_survname(k)
    } else {k},
    modeltype = modeltype,
    family = family,
    link = link,
    resp_mat = resp_mat,
    resp_col = resp_col,
    dummy_cols = dummy_cols,
    ncat = length(levels(Mlist$refs[[k]])),
    lp = lp,
    parelmts = parelmts,
    scale_pars = scale_pars,
    index = index,
    parname = ifelse(k %in% names(Mlist$fixed), 'beta', 'alpha'),
    hc_list = if (length(hc_list) > 0) hc_list,
    nranef = nranef,
    group_lvls = Mlist$group_lvls,
    trafos = trafos,
    trunc = trunc[[k]],
    ppc = FALSE,
    shrinkage = shrinkage,
    refs = Mlist$refs[[k]],
    covnames = covnames,
    assoc_type  = if (modeltype %in% "JM") {
      get_assoc_type(tvars, Mlist$models, assoc_type)
    } else if (modeltype %in% "coxph") {
      "obs.value"
    },
    tv_vars = tv_vars,
    N = Mlist$N,
    df_basehaz = Mlist$df_basehaz
  )
}



get_modeltype <- function(model) {
  if (is.null(model))
    return(NULL)

  modtype <- switch(model,
         lm = 'glm',
         glm_gaussian_identity = 'glm',
         glm_gaussian_log = 'glm',
         glm_gaussian_inverse = 'glm',
         glm_binomial_logit = 'glm',
         glm_binomial_probit = 'glm',
         glm_binomial_log = 'glm',
         glm_binomial_cloglog = 'glm',
         glm_logit = 'glm',
         glm_probit = 'glm',
         glm_gamma_inverse = 'glm',
         glm_gamma_identity = 'glm',
         glm_gamma_log = 'glm',
         glm_poisson_log = 'glm',
         glm_poisson_identity = 'glm',
         lognorm = 'glm',
         beta = 'glm',
         lmm = 'glmm',
         glmm_gaussian_identity = 'glmm',
         glmm_gaussian_log = 'glmm',
         glmm_gaussian_inverse = 'glmm',
         glmm_binomial_logit = 'glmm',
         glmm_binomial_probit = 'glmm',
         glmm_binomial_log = 'glmm',
         glmm_binomial_cloglog = 'glmm',
         glmm_logit = 'glmm',
         glmm_probit = 'glmm',
         glmm_gamma_inverse = 'glmm',
         glmm_gamma_identity = 'glmm',
         glmm_gamma_log = 'glmm',
         glmm_poisson_log = 'glmm',
         glmm_poisson_identity = 'glmm',
         glmm_lognorm = 'glmm',
         glmm_beta = 'glmm',
         clm = 'clm',
         clmm = 'clmm',
         mlogit = 'mlogit',
         mlogitmm = 'mlogitmm',
         coxph = 'coxph',
         survreg = 'survreg',
         JM = 'JM')

  if (is.null(modtype)) {
    errormsg("I do not know the model type %s.", dQuote(model))
  }

  return(modtype)
}


get_family <- function(model) {
  if (is.null(model))
    return(NULL)

  switch(model,
         lm = 'gaussian',
         glm_gaussian_identity = 'gaussian',
         glm_gaussian_log = 'gaussian',
         glm_gaussian_inverse = 'gaussian',
         glm_binomial_logit = 'binomial',
         glm_binomial_probit = 'binomial',
         glm_binomial_log = 'binomial',
         glm_binomial_cloglog = 'binomial',
         glm_logit = 'binomial',
         glm_probit = 'binomial',
         glm_gamma_inverse = 'Gamma',
         glm_gamma_identity = 'Gamma',
         glm_gamma_log = 'Gamma',
         glm_poisson_log = 'poisson',
         glm_poisson_identity = 'poisson',
         lognorm = 'lognorm',
         beta = 'beta',
         lmm = 'gaussian',
         glmm_gaussian_identity = 'gaussian',
         glmm_gaussian_log = 'gaussian',
         glmm_gaussian_inverse = 'gaussian',
         glmm_binomial_logit = 'binomial',
         glmm_binomial_probit = 'binomial',
         glmm_binomial_log = 'binomial',
         glmm_binomial_cloglog = 'binomial',
         glmm_logit = 'binomial',
         glmm_probit = 'binomial',
         glmm_gamma_inverse = 'Gamma',
         glmm_gamma_identity = 'Gamma',
         glmm_gamma_log = 'Gamma',
         glmm_poisson_log = 'poisson',
         glmm_poisson_identity = 'poisson',
         glmm_lognorm = 'lognorm',
         glmm_beta = 'beta',
         clm = NULL,
         clmm = NULL,
         mlogit = NULL,
         mlogitmm = NULL,
         coxph = NULL,
         survreg = NULL,
         JM = NULL)
}

get_link <- function(model) {
  if (is.null(model))
    return(NULL)

  switch(model,
         lm = 'identity',
         glm_gaussian_identity = 'identity',
         glm_gaussian_log = 'log',
         glm_gaussian_inverse = 'inverse',
         glm_binomial_logit = 'logit',
         glm_binomial_probit = 'probit',
         glm_binomial_log = 'log',
         glm_binomial_cloglog = 'cloglog',
         glm_logit = 'logit',
         glm_probit = 'probit',
         glm_gamma_inverse = 'inverse',
         glm_gamma_identity = 'identity',
         glm_gamma_log = 'log',
         glm_poisson_log = 'log',
         glm_poisson_identity = 'identity',
         lognorm = 'identity',
         beta = 'logit',
         lmm = 'identity',
         glmm_gaussian_identity = 'identity',
         glmm_gaussian_log = 'log',
         glmm_gaussian_inverse = 'inverse',
         glmm_binomial_logit = 'logit',
         glmm_binomial_probit = 'probit',
         glmm_binomial_log = 'log',
         glmm_binomial_cloglog = 'log',
         glmm_logit = 'logit',
         glmm_probit = 'probit',
         glmm_gamma_inverse = 'inverse',
         glmm_gamma_identity = 'identity',
         glmm_gamma_log = 'log',
         glmm_poisson_log = 'log',
         glmm_poisson_identity = 'identity',
         glmm_lognorm = 'identity',
         glmm_beta = 'logit',
         clm = NULL,
         clmm = NULL,
         mlogit = NULL,
         mlogitmm = NULL,
         coxph = NULL,
         survreg = NULL,
         JM = NULL)
}



get_assoc_type <- function(covnames, models, assoc_type) {
  assoc_type_user <- assoc_type

  fmlys <- sapply(models[covnames], get_family)

  assoc_type <- setNames(rep('obs.value', length(covnames)),
                         covnames)
  assoc_type[fmlys %in% c('gaussian', 'Gamma', 'lognorm', 'beta')] <-
    'underl.value'

  if (!is.null(assoc_type_user)) {
    assoc_type[intersect(names(assoc_type_user), names(assoc_type))] <-
      assoc_type_user[intersect(names(assoc_type_user), names(assoc_type))]
  }

  return(assoc_type)
}
