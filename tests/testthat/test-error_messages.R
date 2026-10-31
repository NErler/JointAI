# Error messages for functions that are not available for an object, tested on
# stored fixtures (no JAGS run). Fixtures and helpers: helper-fixtures.R.

skip_on_cran()

test_that("residuals() for JM and mlogit models names residuals", {
  for (k in c("jm", "mlogit")) {
    expect_error(
      residuals(fixture_load(k), warn = FALSE),
      "Residuals are not yet implemented for a model of type",
      label = k
    )
  }
})

test_that("residuals() for coxph models: no typo in the error message", {
  expect_error(
    residuals(fixture_load("coxph"), warn = FALSE),
    "residuals for coxph models"
  )
})

test_that("plot_imp_distr() for a JointAI object points to get_MIdat()", {
  expect_error(plot_imp_distr(fixture_load("lm")), "get_MIdat")
})

test_that("extract_state() without JAGS model gives an informative error", {
  # the fixtures do not contain the JAGS model; object$model must not match
  # object$models partially
  object <- fixture_load("lm")
  expect_null(object[["model"]])
  expect_error(extract_state(object), "does not contain the JAGS model")
  expect_error(extract_state(list()), "Use only with 'JointAI' objects")
})
