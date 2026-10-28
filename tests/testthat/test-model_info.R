# The model information per sub-model (get_model_info(), get_model1_info() and
# their helpers in R/get_model_info.R). The models are set up but not sampled
# (n.adapt = 0, n.iter = 0). Overview of what is tested:
# dev/GET_MODEL_INFO.md (local notes).

skip_on_cran()

# set up a model without MCMC sampling
setup_model <- function(fun, ...) {
  suppressWarnings(fun(
    ...,
    n.adapt = 0,
    n.iter = 0,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  ))
}

# family and link --------------------------------------------------------------
test_that("binomial models with cloglog link use the cloglog link", {
  expect_identical(get_link("glm_binomial_cloglog"), "cloglog")
  expect_identical(get_link("glmm_binomial_cloglog"), "cloglog")

  mod <- setup_model(
    glme_imp,
    b1 ~ 1 + (1 | id),
    family = binomial(link = "cloglog"),
    data = longDF
  )
  expect_identical(mod$info_list$b1$link, "cloglog")
  expect_match(mod$jagsmodel, "cloglog(mu_b1[i])", fixed = TRUE)
})

test_that("model type, family and link of all model types", {
  # model type, family and link (NULL: not used) for each model type
  expected <- list(
    lm = c("glm", "gaussian", "identity"),
    glm_gaussian_identity = c("glm", "gaussian", "identity"),
    glm_gaussian_log = c("glm", "gaussian", "log"),
    glm_gaussian_inverse = c("glm", "gaussian", "inverse"),
    glm_binomial_logit = c("glm", "binomial", "logit"),
    glm_binomial_probit = c("glm", "binomial", "probit"),
    glm_binomial_log = c("glm", "binomial", "log"),
    glm_binomial_cloglog = c("glm", "binomial", "cloglog"),
    glm_logit = c("glm", "binomial", "logit"),
    glm_probit = c("glm", "binomial", "probit"),
    glm_gamma_inverse = c("glm", "Gamma", "inverse"),
    glm_gamma_identity = c("glm", "Gamma", "identity"),
    glm_gamma_log = c("glm", "Gamma", "log"),
    glm_poisson_log = c("glm", "poisson", "log"),
    glm_poisson_identity = c("glm", "poisson", "identity"),
    lognorm = c("glm", "lognorm", "identity"),
    beta = c("glm", "beta", "logit"),
    lmm = c("glmm", "gaussian", "identity"),
    glmm_gaussian_identity = c("glmm", "gaussian", "identity"),
    glmm_gaussian_log = c("glmm", "gaussian", "log"),
    glmm_gaussian_inverse = c("glmm", "gaussian", "inverse"),
    glmm_binomial_logit = c("glmm", "binomial", "logit"),
    glmm_binomial_probit = c("glmm", "binomial", "probit"),
    glmm_binomial_log = c("glmm", "binomial", "log"),
    glmm_binomial_cloglog = c("glmm", "binomial", "cloglog"),
    glmm_logit = c("glmm", "binomial", "logit"),
    glmm_probit = c("glmm", "binomial", "probit"),
    glmm_gamma_inverse = c("glmm", "Gamma", "inverse"),
    glmm_gamma_identity = c("glmm", "Gamma", "identity"),
    glmm_gamma_log = c("glmm", "Gamma", "log"),
    glmm_poisson_log = c("glmm", "poisson", "log"),
    glmm_poisson_identity = c("glmm", "poisson", "identity"),
    glmm_lognorm = c("glmm", "lognorm", "identity"),
    glmm_beta = c("glmm", "beta", "logit"),
    clm = "clm",
    clmm = "clmm",
    mlogit = "mlogit",
    mlogitmm = "mlogitmm",
    coxph = "coxph",
    survreg = "survreg",
    JM = "JM"
  )
  for (m in names(expected)) {
    expect_identical(
      c(get_modeltype(m), get_family(m), get_link(m)),
      expected[[m]],
      label = m
    )
  }

  for (fun in c(get_modeltype, get_family, get_link)) {
    expect_null(fun(NULL))
    expect_error(fun("glm_unknown"), "I do not know the model type")
  }
})

# properties of the model information ------------------------------------------
# Set up the model of a quoted call without MCMC sampling (golden_fit() from
# helper-golden.R; the call is evaluated with the golden data as variables).
setup_case <- function(case) golden_fit(case, golden_data())

# cases not covered by the golden master
extra_cases <- list(
  survreg = quote(survreg_imp(
    Surv(futime, status != "censored") ~ age + sex + copper,
    data = PBC2_small
  )),
  glmm_probit = quote(glme_imp(
    b1 ~ C1 + c2 + (1 | id),
    family = binomial(link = "probit"),
    data = longDF
  )),
  lognorm = quote(lognorm_imp(L1 ~ C1 + B2, data = wideDF)),
  betareg = quote(betareg_imp(Be2 ~ C1 + B2, data = wideDF)),
  mlogit_covariate = quote(lm_imp(
    y ~ C1 + M2 + O2,
    models = c(M2 = "mlogit"),
    data = wideDF
  )),
  lme_two_outcomes_full = quote(lme_imp(
    list(y ~ C1 + time + (time | id), c1 ~ C1 + time + (1 | id)),
    rd_vcov = "full",
    data = longDF
  ))
)

# all parameter numbers of one sub-model (also of non-proportional effects)
all_parelmts <- function(parelmts) {
  unlist(lapply(parelmts, function(x) c(unlist(x), unlist(attr(x, "nonprop")))))
}

test_that("the model information is consistent with the model", {
  for (case in c(golden_cases(), extra_cases)) {
    fit <- setup_case(case)
    lab <- deparse1(case)

    for (k in names(fit$info_list)) {
      info <- fit$info_list[[k]]
      lab_k <- paste(k, "in", lab)

      # model type, family and link as for the model type of the sub-model
      m <- unname(fit$models[k])
      expect_identical(info$modeltype, get_modeltype(m), label = lab_k)
      expect_identical(info$family, get_family(m), label = lab_k)
      expect_identical(info$link, get_link(m), label = lab_k)

      # analysis models have parameters "beta", covariate models "alpha"
      expect_identical(
        info$parname,
        if (k %in% names(fit$fixed)) "beta" else "alpha",
        label = lab_k
      )

      # the regression coefficients of analysis models are those of coef_list
      # (a single coefficient is called "beta" there, as in the MCMC sample)
      if (info$parname == "beta") {
        coefs <- grep("^beta", fit$coef_list[[k]]$coef, value = TRUE)
        expect_setequal(
          as.integer(all_parelmts(info$parelmts)),
          ifelse(coefs == "beta", 1L, as.integer(gsub("\\D", "", coefs)))
        )
      }

      # loop indices: "i" for the lowest level, "ii" for the next, ...
      expect_identical(
        unname(info$index[names(sort(fit$Mlist$group_lvls))]),
        strrep("i", seq_along(fit$Mlist$group_lvls)),
        label = lab_k
      )

      # number of random effects per level = number of random effect variables
      for (lvl in names(info$nranef)) {
        expect_identical(
          info$nranef[[lvl]],
          length(attr(info$hc_list$hcvars[[lvl]], "z_names")),
          label = paste(lvl, lab_k)
        )
      }

      # categorical responses: one dummy column per non-reference category
      if (!is.null(info$dummy_cols)) {
        expect_length(info$dummy_cols, info$ncat - 1L)
        expect_length(attr(info$refs, "dummies"), info$ncat - 1L)
      }

      # survival models: a time and an event column
      if (info$modeltype %in% c("survreg", "coxph", "JM")) {
        expect_length(info$resp_col, 2L)
        expect_identical(names(info$resp_col), names(info$resp_mat))
      }
    }

    # analysis and covariate models do not share parameters, and the
    # parameters are numbered without gaps
    for (parname in c("beta", "alpha")) {
      nrs <- unlist(lapply(fit$info_list, function(info) {
        if (info$parname == parname) all_parelmts(info$parelmts)
      }))
      expect_identical(sort(as.integer(nrs)), seq_along(nrs), label = lab)
    }
  }
})

test_that("time-varying covariates and association types of a joint model", {
  fit <- setup_case(golden_cases()$jm_three_longitudinal)
  info <- fit$info_list[[1L]]

  expect_named(info$tv_vars, c("chol", "stage", "hepato"))
  for (sub in info$tv_vars) {
    expect_identical(unname(sub$surv_lvl), "id")
  }
  # default association: underlying value for continuous covariates, observed
  # value (one per dummy variable) for categorical covariates
  expect_identical(
    info$assoc_type,
    c(
      chol = "underl.value",
      stage2 = "obs.value",
      stage3 = "obs.value",
      stage4 = "obs.value",
      hepatoyes = "obs.value"
    )
  )
})

test_that("a user-specified association type is used", {
  fit <- setup_case(quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + chol + (1 | id),
      chol ~ day + (1 | id)
    ),
    timevar = "day",
    assoc_type = c(chol = "obs.value"),
    data = PBC_small
  )))
  info <- fit$info_list[[1L]]
  expect_identical(info$assoc_type, c(chol = "obs.value"))
  expect_identical(info$tv_vars$chol$assoc_type, c(chol = "obs.value"))
})

# arguments passed on to the model information ----------------------------------
test_that("shrinkage can be specified per variable", {
  fit <- setup_case(quote(lm_imp(
    y ~ C1 + C2 + B2,
    shrinkage = c(y = "ridge"),
    data = wideDF
  )))
  expect_identical(fit$info_list$y$shrinkage, c(y = "ridge"))
  expect_null(fit$info_list$C2$shrinkage)
})

test_that("rev reverses the coding of an ordinal outcome", {
  fit <- setup_case(quote(clm_imp(O1 ~ C1, rev = "O1", data = wideDF)))
  expect_true(fit$info_list$O1$rev)
  fit <- setup_case(quote(clm_imp(O1 ~ C1, data = wideDF)))
  expect_false(fit$info_list$O1$rev)
})

test_that("rd_vcov sets the structure of the random effects covariance", {
  fit <- setup_case(quote(lme_imp(
    y ~ C1 + time + (time | id),
    rd_vcov = "indep",
    data = longDF
  )))
  expect_identical(fit$info_list$y$rd_vcov$id, "indep", ignore_attr = TRUE)

  fit <- setup_case(extra_cases$lme_two_outcomes_full)
  for (k in c("y", "c1")) {
    expect_identical(fit$info_list[[k]]$rd_vcov$id, "full", ignore_attr = TRUE)
  }
  # random effects 1:2 belong to y, 3 to c1
  expect_identical(
    attr(fit$info_list$y$rd_vcov$id, "ranef_index"),
    c(y = "1:2", c1 = "3")
  )
})

test_that("custom sub-models, trunc and df_basehaz are passed on", {
  fit <- setup_case(quote(lm_imp(
    y ~ C1 + C2,
    custom = list(C2 = "  C2[i] ~ dnorm(0, 1)"),
    data = wideDF
  )))
  expect_identical(fit$info_list$C2$custom, "  C2[i] ~ dnorm(0, 1)")
  expect_match(fit$jagsmodel, "  C2[i] ~ dnorm(0, 1)", fixed = TRUE)

  fit <- setup_case(quote(lm_imp(
    y ~ C1 + C2,
    trunc = list(C2 = c(-10, 10)),
    data = wideDF
  )))
  expect_identical(fit$info_list$C2$trunc, c(-10, 10))

  fit <- setup_case(quote(coxph_imp(
    Surv(futime, status != "censored") ~ age + sex,
    df_basehaz = 4,
    data = PBC2_small
  )))
  expect_identical(fit$info_list[[1L]]$df_basehaz, 4)
})

# errors -----------------------------------------------------------------------
test_that("errors for model types that do not fit the data", {
  # random effects for a covariate with a model without random effects
  expect_error(
    setup_case(quote(lme_imp(
      list(y ~ c1 + (1 | id), c1 ~ C1 + (1 | id)),
      models = c(c1 = "lm"),
      data = longDF
    ))),
    "random effects structure specified for the variable"
  )
  # multinomial model for a numeric variable or a factor with two levels
  expect_error(
    setup_case(quote(lm_imp(
      y ~ C1 + M2,
      models = c(M2 = "mlogit"),
      data = within(wideDF, M2 <- as.numeric(M2))
    ))),
    "seems the variable .M2. is numeric"
  )
  expect_error(
    setup_case(quote(mlogit_imp(B1 ~ C1, data = wideDF))),
    "has less than three levels"
  )
})

test_that("error for coxph with interaction of time-varying and incomplete baseline covariate", {
  expect_error(
    setup_case(quote(coxph_imp(
      Surv(futime, status != "censored") ~ age + trig * platelet + (1 | id),
      timevar = "day",
      data = PBC_small
    ))),
    "interaction between a time-varying\\s+covariate\\s+and a\\s+incomplete"
  )
})
