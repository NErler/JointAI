
get_model_info <- function(Mlist, K, K_imp, trunc = NULL, assoc_type = NULL) {
  args <- as.list(match.call())[-1L]

  sapply(names(Mlist$lp_cols), function(k) {
    do.call(get_model1_info, c(k = replace_dummy(k, refs = Mlist$refs), args))
  },  simplify = FALSE)
}

get_model1_info <- function(k, Mlist, K, K_imp, trunc = NULL, assoc_type = NULL,
                            isgk = FALSE) {
  arglist <- as.list(match.call())[-1L]

  # modeltype, family & link -------------------------------------------------
  modeltype <- get_modeltype(Mlist$models[k])
  family <- get_family(Mlist$models[k])
  link <- get_link(Mlist$models[k])


  # response matrix and column(s) --------------------------------------------
  resp_mat <- if (k %in% colnames(Mlist$Mc)) {
    'Mc'
  } else if (k %in% colnames(Mlist$Ml)) {
    "Ml"
  } else if (attr(Mlist$fixed[[k]], 'type') %in% c('survreg', 'coxph', 'JM')) {
    sapply(names(Mlist$outcomes$outcomes[[k]]), function(x)
      if (x %in% colnames(Mlist$Mc)) {
        'Mc'
      } else if (x %in% colnames(Mlist$Ml)) {
        "Ml"
      })
  } else {
    stop(gettextf("I can't find the variable %s in neither of the matrices Mc and Ml.",
                  dQuote(k)))
  }

  resp_col <- if (k %in% names(Mlist$fixed) &&
                  attr(Mlist$fixed[[k]], 'type') %in% c('survreg', 'coxph', 'JM')) {
    sapply(names(Mlist$outcomes$outcomes[[k]]), function(x)
      match(x, colnames(Mlist[[resp_mat[x]]])))
  } else {
    match(k, colnames(Mlist[[resp_mat[1]]]))
  }

  # linear predictor columns -------------------------------------------------
  lp <- Mlist$lp_cols[[k]]

  # parameter elements ------------------------------------------------------
  parelmts <- if (k %in% names(Mlist$fixed)) {
    sapply(rownames(K[[k]]), function(i) {
      if (!any(is.na(K[[k]][i, ]))) {
        if (Mlist$models[k] %in% c('mlogit', 'mlogitmm')) {
          split(K[[k]][i, 1]:K[[k]][i, 2],
                rep(1:length(levels(Mlist$refs[[k]])[-1]),
                    each = length(lp[[i]])))
        } else {
          K[[k]][i, 1]:K[[k]][i, 2]
        }
      }
    }, simplify = FALSE)
  } else {
    sapply(rownames(K_imp[[k]]), function(i) {
      if (!any(is.na(K_imp[[k]][i, ]))) {
        if (Mlist$models[k] %in% c('mlogit', 'mlogitmm')) {
          split(K_imp[[k]][i, 1]:K_imp[[k]][i, 2],
                rep(1:length(levels(Mlist$refs[[k]])[-1]),
                    each = length(lp[[i]])))
        } else {
          K_imp[[k]][i, 1]:K_imp[[k]][i, 2]
        }
      }
    }, simplify = FALSE)
  }


  # scaling parameter matrices -----------------------------------------------
  scale_pars <- list(Mc = Mlist$scale_pars$Mc,#[lp$Mc, ],
                     Ml = Mlist$scale_pars$Ml)#[lp$Ml, ])

  # dummy colums -------------------------------------------------------------
  dummy_cols <- if (k %in% names(Mlist$refs) &
                    (any(is.na(Mlist[[resp_mat[1]]][, resp_col[1]])) |
                     any(sapply(Mlist$fixed, 'attr', 'type') %in% 'JM'))) {
    match(attr(Mlist$refs[[k]], 'dummies'), colnames(Mlist[[resp_mat[1]]]))
  }
  if (all(is.na(dummy_cols)))
    dummy_cols <- NULL

  categories <- if (k %in% names(Mlist$refs) &
                    (any(is.na(Mlist[[resp_mat[1]]][, resp_col[1]])) |
                     any(sapply(Mlist$fixed, 'attr', 'type') %in% 'JM'))) {
    which(levels(Mlist$refs[[k]]) != Mlist$refs[[k]])
  }


  # transformations ----------------------------------------------------------
  trafos <- paste_trafos(Mlist, varname = k,
                         index = ifelse(resp_mat[1] == 'Ml' & !isgk, 'j', 'i'),
                         isgk = isgk)

  covnames = if (modeltype %in% "JM") {
    unique(sapply(names(lp$Ml), replace_dummy, refs = Mlist$refs))
  }

  tv_vars <- if (modeltype %in% "JM") {

    # find the (longitudinal) covariates infolved in the lp of the survival part
    covars <- unlist(sapply(names(lp$Ml), replace_trafo, Mlist$fcts_all))
    covars <- sapply(covars, replace_dummy, refs = Mlist$refs)
    covars <- covars[covars %in% colnames(Mlist$Ml)]

    tvars <- unique(unlist(c(names(lp$Ml),
                             lapply(Mlist$lp_cols[covars],
                                    function(x) names(x$Ml))
    )))


    # get the variables needed to re-fit the models for 'covars' in the Gauss-Kronrod
    # quadrature
    tvars <- unlist(sapply(tvars, replace_trafo, Mlist$fcts_all))

    tvars <- unique(sapply(tvars[!tvars %in% Mlist$timevar &
                                   tvars %in% colnames(Mlist$Ml)],
                           replace_dummy, refs = Mlist$refs))

    # get the model info for these variables
    sapply(tvars, function(i) {
      arglist_new <- arglist
      arglist_new$k <- replace_dummy(i, refs = Mlist$refs)
      arglist_new$isgk <- TRUE
      do.call(get_model1_info, arglist_new)
    },  simplify = FALSE)
  }



  # collect all info ---------------------------------------------------------
  list(
    varname = if (modeltype %in% c('survreg', 'coxph', 'JM')) {
      paste0(c('surv', Mlist$outcomes$outnams[[k]]), collapse = "_")
    } else {k},
    modeltype = modeltype,
    family = family,
    link = link,
    resp_mat = resp_mat,
    resp_col = resp_col,
    dummy_cols = dummy_cols,
    categories = categories,
    ncat = length(levels(Mlist$refs[[k]])),
    lp = lp,
    parelmts = parelmts,
    scale_pars = scale_pars,
    index = if (resp_mat[1] == 'Ml' && modeltype != "JM") c('j', 'i') else 'i',
    parname = ifelse(k %in% names(Mlist$fixed), 'beta', 'alpha'),
    hc_list = Mlist$hc_list[[k]],
    trafos = trafos,
    trunc = trunc[[k]],
    ppc = FALSE,
    shrinkage = NULL,
    covnames = covnames,
    assoc_type  = if (modeltype %in% "JM") {
      assoc_type <- get_assoc_type(covnames, Mlist$models, assoc_type)
    },
    tv_vars = tv_vars,
    N = Mlist$N,
    Ntot = Mlist$Ntot
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
    stop(gettextf("I do not know the model type %s.", dQuote(model)), call. = FALSE)
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
  assoc_type[fmlys %in% c('gaussian', 'Gamma', 'lognorm', 'beta')] <- 'underl.value'

  if (!is.null(assoc_type_user)) {
    assoc_type[intersect(names(assoc_type_user), names(assoc_type))] <-
      assoc_type_user[intersect(names(assoc_type_user), names(assoc_type))]
  }

  return(assoc_type)
}
