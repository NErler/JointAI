# parameters() and list_models(), tested on stored fixtures (no JAGS run). The
# results themselves are compared with stored results in
# test-fixtures_summary.R (types "parameters" and "list_models" of
# fixture_results()); here: properties that must hold independently of the
# stored values, the arguments, and the error for other objects. Fixtures and
# helpers: helper-fixtures.R.

skip_on_cran()

fixture_names <- names(fixture_cases())

# parameters() -----------------------------------------------------------------

# glm_binomial, mlogit: only regression coefficients are monitored, and
# parameters() then also lists the coefficients of the covariate models, which
# are not monitored (recorded in dev/STATUS.md as a possible bug).
for (k in setdiff(fixture_names, c("glm_binomial", "mlogit"))) {
  test_that(paste("parameters() lists exactly the monitored nodes:", k), {
    object <- fixture_load(k)
    params <- parameters(object, mess = FALSE)
    expect_false(anyDuplicated(params$coef) > 0)
    expect_setequal(params$coef, colnames(object$MCMC[[1L]]))
  })
}

for (k in c("glm_binomial", "mlogit")) {
  test_that(paste("parameters() lists only monitored coefficients:", k), {
    object <- fixture_load(k)
    params <- parameters(object, mess = FALSE)
    expect_false(anyDuplicated(params$coef) > 0)
    expect_setequal(params$coef, colnames(object$MCMC[[1L]]))
  })
}

for (k in fixture_names) {
  test_that(paste("parameters() rows match the coefficient list:", k), {
    object <- fixture_load(k)
    params <- parameters(object, mess = FALSE)
    expect_s3_class(params, "data.frame")
    expect_named(params, c("outcome", "outcat", "varname", "coef"))

    # outcome: one of the (cleaned) outcome names, grouped in the order of the
    # models; NA only for parameters that belong to no model (imputed values)
    outcomes <- internal_clean_survname(names(object$coef_list))
    expect_true(all(params$outcome %in% c(outcomes, NA)))
    expect_false(is.unsorted(match(params$outcome, outcomes), na.rm = TRUE))

    # regression coefficients have the same outcome, category and variable as
    # in the coefficient list
    coefs <- do.call(rbind, object$coef_list)
    reg <- params[params$coef %in% coefs$coef, ]
    expect_equal(
      reg,
      coefs[match(reg$coef, coefs$coef), names(params)],
      ignore_attr = "row.names"
    )
  })
}

test_that("parameters(expand_ranef = TRUE) changes nothing without ranefs", {
  # none of the fixtures monitors the random effects
  for (k in fixture_names) {
    object <- fixture_load(k)
    expect_equal(
      parameters(object, expand_ranef = TRUE, mess = FALSE),
      parameters(object, mess = FALSE),
      label = k
    )
  }
})

test_that("parameters() expands baseline hazard and ordinal intercepts", {
  coxph <- parameters(fixture_load("coxph"), mess = FALSE)
  expect_equal(
    grep("^beta_Bh0", coxph$coef, value = TRUE),
    paste0("beta_Bh0_Srv_ftm_stts_cn[", 1:6, "]")
  )
  clm <- parameters(fixture_load("clm_nonprop"), mess = FALSE)
  expect_equal(
    grep("^gamma_", clm$coef, value = TRUE),
    paste0("gamma_O1[", 1:3, "]")
  )
})

test_that("parameters() gives a note for a model without MCMC samples", {
  object <- fixture_load("lm")
  object$MCMC <- NULL
  expect_message(parameters(object), "does not contain MCMC samples")
  expect_silent(parameters(object, mess = FALSE))
})

test_that("parameters() and list_models() only work with JointAI objects", {
  expect_error(parameters(list(a = 1)), "JointAI")
  expect_error(list_models(list(a = 1)), "JointAI")
})

test_that("expand_params() and expand_ranefs() replace a node by elements", {
  expect_equal(
    expand_params("^beta_Bh0", c("beta", "beta_Bh0_y", "sigma_y"), n = 2),
    c("beta", "sigma_y", "beta_Bh0_y[1]", "beta_Bh0_y[2]")
  )
  # no match: unchanged
  expect_equal(
    expand_params("^beta_Bh0", c("beta", "tau"), n = 2),
    c("beta", "tau")
  )

  expect_equal(
    expand_ranefs(
      "^b[[:print:]]*_id$",
      c("beta", "b_y_id"),
      MCMC_names = c("beta[1]", "b_y_id[1,1]", "b_y_id[2,1]", "b_y_id2[1,1]")
    ),
    c("beta", "b_y_id[1,1]", "b_y_id[2,1]")
  )
  expect_equal(expand_ranefs("^b_id$", "beta", MCMC_names = "beta[1]"), "beta")
})


# list_models() ----------------------------------------------------------------

for (k in fixture_names) {
  test_that(paste("list_models() describes every sub-model:", k), {
    object <- fixture_load(k)
    out <- capture.output(res <- withVisible(list_models(object)))
    expect_null(res$value)
    expect_false(res$visible)
    headers <- grep(" for \"", out, value = TRUE)
    expect_equal(
      sub('^.* for "(.*)" $', "\\1", headers),
      unname(sapply(object$info_list, "[[", "varname"))
    )
    # all predictor variables are listed (non-proportional effects in clm
    # models are not; recorded in dev/STATUS.md)
    text <- paste(out, collapse = " ")
    for (i in object$info_list) {
      for (v in names(unlist(unname(i$lp)))) {
        expect_true(grepl(v, text, fixed = TRUE), label = v)
      }
    }
  })
}

test_that("list_models() leaves out the sections that are switched off", {
  sections <- list(
    predvars = "* Predictor variables:",
    regcoef = "* Regression coefficients:",
    priors = "prior",
    refcat = "* Reference category:",
    otherpars = c(
      "* Precision of",
      "* Intercepts:",
      "* Shape parameter:",
      "* Regression coefficients of the baseline hazard:"
    )
  )
  # together, these models have all sections
  objects <- lapply(c("lm", "survreg", "jm"), fixture_load)
  print_all <- function(...) {
    unlist(lapply(objects, function(object) {
      capture.output(list_models(object, ...))
    }))
  }
  full <- print_all()
  for (arg in names(sections)) {
    out <- do.call(print_all, setNames(list(FALSE), arg))
    found <- function(lines) {
      sapply(sections[[arg]], function(s) any(grepl(s, lines, fixed = TRUE)))
    }
    expect_true(all(found(full)), label = arg)
    expect_false(any(found(out)), label = arg)
  }
})

test_that("list_models() prints a custom sub-model as given", {
  object <- fixture_load("lm")
  object$info_list$C2$custom <- "  C2[i] ~ dnorm(0, 1)"
  out <- capture.output(list_models(object))
  expect_true("Custom model for \"C2\" " %in% out)
  expect_true("  C2[i] ~ dnorm(0, 1) " %in% out)
  expect_false(any(grepl("Linear model for \"C2\"", out, fixed = TRUE)))
})
