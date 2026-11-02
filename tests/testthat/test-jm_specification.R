# Specifications of JM_imp() that are not the intended use of a joint model
# (#110). The JAGS model is set up (n.adapt = 0, n.iter = 0) and compiled, but
# not run, unless stated otherwise.

skip_on_cran()

jm_spec_setup <- function(formula, warn = TRUE, ...) {
  JM_imp(
    formula,
    timevar = "day",
    data = golden_data()$PBC_small,
    n.adapt = 0,
    n.iter = 0,
    seed = 2020,
    overwrite = TRUE,
    mess = FALSE,
    warn = warn,
    ...
  )
}

# the statement of the JAGS model that starts with `start`, including the lines
# it continues on
jm_spec_statement <- function(fit, start) {
  lines <- strsplit(fit$jagsmodel, "\n", fixed = TRUE)[[1L]]
  first <- which(startsWith(trimws(lines), start))
  expect_length(first, 1L)

  last <- first
  while (grepl("[+*]\\s*$", lines[last])) {
    last <- last + 1L
  }
  paste(trimws(lines[first:last]), collapse = " ")
}


test_that("a joint model needs a grouping variable", {
  cases <- list(
    # no time-varying covariate
    baseline = Surv(futime, status != "censored") ~ sex + age,
    baseline_list = list(Surv(futime, status != "censored") ~ sex + age),
    # a complete and an incomplete time-varying covariate, without a model
    tv_complete = Surv(futime, status != "censored") ~ sex + age + albumin,
    tv_incomplete = Surv(futime, status != "censored") ~ sex + age + chol,
    # a second model, but without a random effects structure
    no_random = list(
      Surv(futime, status != "censored") ~ sex + age,
      albumin ~ age + day
    )
  )

  for (case in names(cases)) {
    expect_error(
      jm_spec_setup(cases[[case]]),
      "needs\\s+a\\s+grouping\\s+variable.*coxph_imp.*random\\s+effects\\s+structure",
      info = case
    )
  }
})


test_that("a joint model needs something longitudinal", {
  cases <- list(
    only_survival = Surv(futime, status != "censored") ~ sex + age + (1 | id),
    # the only other model is on the level of the subjects
    baseline_model = list(
      Surv(futime, status != "censored") ~ age + copper + (1 | id),
      copper ~ age
    )
  )

  for (case in names(cases)) {
    expect_error(
      jm_spec_setup(cases[[case]]),
      "no\\s+time-varying\\s+covariates.*no\\s+longitudinal\\s+model.*coxph_imp",
      info = case
    )
  }
})


test_that("a longitudinal outcome that is not in the survival model can be fitted", {
  longitudinal_models <- list(
    gaussian = albumin ~ age + day + (day | id),
    binary = hepato ~ age + day + (1 | id),
    ordinal = stage ~ age + day + (1 | id)
  )
  n_subjects <- length(unique(golden_data()$PBC_small$id))

  for (case in names(longitudinal_models)) {
    outcome <- all.vars(longitudinal_models[[case]])[1L]
    expect_warning(
      fit <- jm_spec_setup(list(
        Surv(futime, status != "censored") ~ sex + age,
        longitudinal_models[[case]]
      )),
      paste0(outcome, ".*not\\s+part\\s+of\\s+the\\s+survival\\s+model"),
      info = case
    )

    # the survival part only has the baseline covariates
    surv_name <- names(fit$info_list)[1L]
    surv_info <- fit$info_list[[1L]]
    varname <- surv_info$varname
    expect_identical(surv_info$modeltype, "JM", info = case)
    expect_identical(names(surv_info$lp), "M_id", info = case)
    expect_identical(surv_info$N[["id"]], n_subjects, info = case)
    expect_length(surv_info$tv_vars, 0L)

    expect_identical(
      jm_spec_statement(fit, paste0("logh_", varname, "[ii] <- ")),
      sprintf(
        "logh_%s[ii] <- logh0_%s[ii] + eta_%s[ii]",
        varname,
        varname,
        varname
      ),
      info = case
    )
    expect_identical(
      jm_spec_statement(fit, paste0("Surv_", varname, "[ii, 1:15] <- ")),
      sprintf(
        "Surv_%s[ii, 1:15] <- gkw[] * exp(1)^(logh0s_%s[ii, ])",
        varname,
        varname
      ),
      info = case
    )

    # no quadrature for a time-varying covariate
    expect_false("M_lvlonegk" %in% names(fit$data_list), info = case)
    expect_false(
      paste0("srow_", varname) %in% names(fit$data_list),
      info = case
    )

    # the longitudinal model is still there, without a quadrature part
    expect_identical(names(fit$info_list), c(surv_name, outcome), info = case)
    expect_false(grepl("mugk_|etagk_", fit$jagsmodel), info = case)
  }
})


test_that("the warning about an outcome outside the survival model can be switched off", {
  fmla <- list(
    Surv(futime, status != "censored") ~ sex + age,
    albumin ~ age + day + (day | id)
  )
  expect_no_warning(jm_spec_setup(fmla, warn = FALSE))
})


test_that("the warning only names outcomes that are not linked to the survival model", {
  # bili is not used anywhere, albumin is in the survival model
  expect_warning(
    jm_spec_setup(list(
      Surv(futime, status != "censored") ~ age + albumin,
      albumin ~ age + day + (day | id),
      bili ~ day + (1 | id)
    )),
    "The\\s+outcome\\(s\\)\\s+.bili.\\s+of"
  )

  # bili is a covariate in the model for albumin
  expect_no_warning(jm_spec_setup(list(
    Surv(futime, status != "censored") ~ age + albumin,
    albumin ~ bili + day + (day | id),
    bili ~ day + (1 | id)
  )))

  # a function of the outcome in the survival model
  expect_no_warning(jm_spec_setup(list(
    Surv(futime, status != "censored") ~ age + log(albumin),
    albumin ~ day + (day | id)
  )))

  expect_no_warning(jm_spec_setup(list(
    Surv(futime, status != "censored") ~ age + chol,
    chol ~ age + day + (day | id)
  )))
})


test_that("there is a warning for automatically added models of time-varying covariates", {
  cases <- list(
    # only the survival formula
    survival_only = list(
      formula = Surv(futime, status != "censored") ~ age + albumin + (1 | id),
      automatic = "albumin"
    ),
    function_of_covariate = list(
      formula = Surv(futime, status != "censored") ~ age +
        log(albumin) +
        (1 | id),
      automatic = "albumin"
    ),
    # one of the covariates of the survival part has a model in the formula
    one_given = list(
      formula = list(
        Surv(futime, status != "censored") ~ age + albumin + bili,
        albumin ~ day + (day | id)
      ),
      automatic = "bili"
    )
  )

  for (case in names(cases)) {
    expect_warning(
      fit <- jm_spec_setup(cases[[case]]$formula),
      paste0(
        "time-varying\\s+covariate\\(s\\)\\s+.",
        cases[[case]]$automatic,
        ".\\s+were\\s+added\\s+automatically.*random\\s+intercept.*coxph_imp"
      ),
      info = case
    )
    expect_true(
      cases[[case]]$automatic %in% names(fit$info_list[[1L]]$tv_vars),
      info = case
    )
    # the description of the model is correct: a random intercept only
    expect_equal(
      unname(fit$info_list[[cases[[case]]$automatic]]$nranef),
      1L,
      info = case
    )
  }

  expect_no_warning(jm_spec_setup(
    Surv(futime, status != "censored") ~ age + albumin + (1 | id),
    warn = FALSE
  ))

  # no warning for a covariate that is only in the model of a longitudinal
  # outcome, not in the survival part
  expect_no_warning(
    fit <- jm_spec_setup(list(
      Surv(futime, status != "censored") ~ age + albumin,
      albumin ~ chol + day + (day | id)
    ))
  )
  expect_true("chol" %in% names(fit$info_list[[1L]]$tv_vars))
})


test_that("there is a warning if the only time-varying terms are effects of baseline covariates", {
  expect_warning(
    fit <- jm_spec_setup(
      Surv(futime, status != "censored") ~ age + age:day + (1 | id)
    ),
    "not\\s+really\\s+a\\s+joint\\s+model"
  )
  # the model is still set up
  expect_identical(names(fit$info_list[[1L]]$lp$M_lvlone), "age:day")
  expect_true("M_lvlonegk" %in% names(fit$data_list))

  expect_no_warning(jm_spec_setup(
    Surv(futime, status != "censored") ~ age + age:day + (1 | id),
    warn = FALSE
  ))

  # with a longitudinal model, the warning is about that outcome
  expect_warning(
    jm_spec_setup(list(
      Surv(futime, status != "censored") ~ age + age:day,
      albumin ~ day + (day | id)
    )),
    "The\\s+outcome\\(s\\)\\s+.albumin.\\s+of"
  )

  # with a time-varying covariate, this is a joint model
  expect_no_warning(jm_spec_setup(list(
    Surv(futime, status != "censored") ~ age + chol + age:day,
    chol ~ age + day + (day | id)
  )))
})


test_that("no association types are printed if there are none", {
  fit <- JM_imp(
    list(
      Surv(futime, status != "censored") ~ sex + age,
      albumin ~ age + day + (1 | id)
    ),
    timevar = "day",
    data = golden_data()$PBC_small,
    n.adapt = 2,
    n.iter = 5,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  )

  expect_false(any(grepl(
    "association types",
    capture.output(list_models(fit))
  )))
  expect_false(any(grepl(
    "Association types",
    capture.output(print(summary(fit)))
  )))
})
