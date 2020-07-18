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
  } else if (attr(Mlist$fixed[[k]], "type") %in% c("survreg", "coxph", "JM")) {
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
  lp <- get_lp(k, Mlist)

  # check and error message for time-dependent cox with interaction between
  # time-varying covariate with incomplete baseline covariate
  if (modeltype == "coxph" &
      !is.null(Mlist$interactions) &
      !is.null(lp$M_lvlone)) {

    sapply(Mlist$interactions[intersect(names(Mlist$interactions),
                                        names(lp$M_lvlone))], function(x) {
      if (any(names(x$elmts) == "M_lvlone") &
          any(names(x$elmts) != "M_lvlone") &
          attr(x, "has_NAs")) {
        errormsg("It seems that there is an interaction between a time-varying
                 covariate and a incomplete baseline covariate. This is not
                 yet implemented for proportional hazards models.")
      }
    })
  }


  # parameter elements ------------------------------------------------------
  parelmts <- get_parelmts(k, Mlist, K, K_imp, lp)


  # scaling parameter matrices -----------------------------------------------
  scale_pars <- Mlist$scale_pars

  # dummy columns -------------------------------------------------------------
  dummy_cols <- if (k %in% names(Mlist$refs) &
                    (any(is.na(Mlist$M[[resp_mat[1]]][, resp_col[1]])) |
                     any(sapply(Mlist$fixed, "attr", "type") %in% "JM"))) {
    match(attr(Mlist$refs[[k]], "dummies"), colnames(Mlist$M[[resp_mat[1]]]))
  }

  if (all(is.na(dummy_cols)))
    dummy_cols <- NULL


  # index name -----------------------------------------------------------------
  index <- setNames(sapply(seq_along(sort(Mlist$group_lvls)),
                           function(k) paste0(rep("i", k), collapse = "")),
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


    # get the variables needed to re-fit the models for "covars" in the
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
                         resplvl = gsub("M_", "", resp_mat[length(resp_mat)]),
                         Mlist, parelmts, lp)
  nranef <- sapply(hc_list$hcvars, function(x)
    as.numeric(attr(x, "rd_intercept")) +
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
    varname = if (modeltype %in% c("survreg", "coxph", "JM")) {
      clean_survname(k)
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
    parname = ifelse(k %in% names(Mlist$fixed), "beta", "alpha"),
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
      get_assoc_type(tvars, Mlist$models, assoc_type, Mlist$refs)
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
         JM = "JM")

  if (is.null(modtype)) {
    errormsg("I do not know the model type %s.", dQuote(model))
  }

  return(modtype)
}


get_family <- function(model) {
  if (is.null(model))
    return(NULL)

  switch(model,
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
         JM = NULL)
}

get_link <- function(model) {
  if (is.null(model))
    return(NULL)

  switch(model,
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
         glmm_binomial_cloglog = "log",
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
         JM = NULL)
}



get_assoc_type <- function(covnames, models, assoc_type, refs) {
  assoc_type_user <- assoc_type

  fmlys <- sapply(models[covnames], get_family)

  assoc_type <- setNames(rep("obs.value", length(covnames)),
                         covnames)
  assoc_type[fmlys %in% c("gaussian", "Gamma", "lognorm", "beta")] <-
    "underl.value"

  if (!is.null(assoc_type_user)) {
    assoc_type[intersect(names(assoc_type_user), names(assoc_type))] <-
      assoc_type_user[intersect(names(assoc_type_user), names(assoc_type))]
  }

  unlist(lapply(seq_along(assoc_type), function(k) {
    if (names(assoc_type)[k] %in% names(refs)) {
      setNames(rep(assoc_type[k],
                   length(attr(refs[[names(assoc_type)[k]]], "dummies"))),
               attr(refs[[names(assoc_type)[k]]], "dummies"))
    } else {
      assoc_type[k]
    }
  }))

}



# used in get_model_info() (2020-07-08)
get_lp <- function(k, Mlist) {
  # obtain the linear predictor for a given response variable for all levels
  # k: the name of the response
  # Mlist: obtained from divide_matrices()

  lplist <- sapply(names(Mlist$lp_cols[[k]]), function(lvl) {
    lpc <- Mlist$lp_cols[[k]][[lvl]]
    list(prop = lpc[!names(lpc) %in% Mlist$lp_nonprop[[k]][[lvl]]],
         nonprop = lpc[names(lpc) %in% Mlist$lp_nonprop[[k]][[lvl]]]
    )
  }, simplify = FALSE)

  lp <- lapply(lplist, "[[", "prop")

  if (!is.null(Mlist$lp_nonprop[[k]])) {
    attr(lp, "nonprop") <- lapply(lplist, "[[", "nonprop")
  }
  lp
}



get_parelmts <- function(k, Mlist, K, K_imp, lp) {

  Kmat <- if (k %in% names(Mlist$fixed)) K else K_imp

  if (any(is.na(Kmat)))
    errormsg("There are missing values in the matrix %s.",
             if (k %in% names(Mlist$fixed)) "K" else "K_imp")

  sapply(rownames(Kmat[[k]]), function(lvl) {
    parnums <- Kmat[[k]][lvl, 1]:Kmat[[k]][lvl, 2]

    if (Mlist$models[k] %in% c("mlogit", "mlogitmm")) {
      if (length(levels(Mlist$refs[[k]])) == 0) {
        errormsg("It seems the variable %s is numeric, but to fit a multinomial
                 logit model the response variable must be a factor with at
                 least three levels.", dQuote(k))
      } else if (length(levels(Mlist$refs[[k]])) < 3) {
        errormsg("The variable %s has less than three levels. You should use
                 a binomial model for this variable instead of a multinomial
                 model.", dQuote(k))
      }

      parnums <- setNames(Kmat[[k]][lvl, 1]:Kmat[[k]][lvl, 2],
                          rep(names(lp[[lvl]]),
                              length(levels(Mlist$refs[[k]])) - 1)
      )

      split(parnums,
            rep(paste0(k, levels(Mlist$refs[[k]])[-1]),
                each = length(lp[[lvl]])))

    } else if (Mlist$models[[k]] %in% c("clm", "clmm")) {
      # parameter elements for covariates with proportional effects
      parnums_prop <- setNames(parnums[seq_along(lp[[lvl]])], names(lp[[lvl]]))

      # parameter elements for covariates with non-proportional effects
      parnums_nonprop <- setNames(setdiff(parnums, parnums_prop),
                                  rep(names(attr(lp, "nonprop")[[lvl]]),
                                      length(attr(Mlist$refs[[k]], "dummies")))
      )

      parnums_nonprop <- split(parnums_nonprop,
                               rep(paste0(k, levels(Mlist$refs[[k]])[-1]),
                                   each = length(attr(lp, "nonprop")[[lvl]])))

      if (length(parnums_nonprop) > 0) {
        attr(parnums_prop, "nonprop") <- parnums_nonprop
      }
      parnums_prop
    } else {
      setNames(parnums, names(lp[[lvl]]))
    }
  }, simplify = FALSE)
}
