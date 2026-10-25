# Post-processing of fitted models, tested on stored fixtures (no JAGS run):
# summary(), coef(), confint() are compared with stored results; printing must
# work; and functions that are not implemented for some model types must give
# their error. Fixtures, expected results and helpers: helper-fixtures.R.

skip_on_cran()

fixture_names <- names(fixture_cases())
results <- fixture_results()

test_that("there is a fixture and expected results for every case", {
  expect_setequal(
    setdiff(
      sub("\\.rds$", "", list.files(fixture_path(), pattern = "\\.rds$")),
      "info"
    ),
    fixture_names
  )
  expected_files <- list.files(fixture_path("expected"), pattern = "\\.rds$")
  expect_setequal(
    expected_files,
    paste0(
      rep(fixture_names, each = length(results)),
      "_",
      names(results),
      ".rds"
    )
  )
})

for (k in fixture_names) {
  test_that(paste("summary, coef and confint:", k), {
    object <- fixture_load(k)
    for (type in names(results)) {
      expect_equal(
        results[[type]](object),
        fixture_expected(k, type),
        label = paste(type, "of", k)
      )
    }
  })

  test_that(paste("print and print(summary()) work:", k), {
    object <- fixture_load(k)
    expect_no_error(capture.output(print(object)))
    expect_no_error(
      capture.output(print(suppressWarnings(summary(object, missinfo = TRUE))))
    )
  })
}

test_that("functions not implemented for some model types give an error", {
  for (k in c("clm_nonprop", "mlogit", "coxph", "survreg", "jm")) {
    expect_error(residuals(fixture_load(k)), "not", label = k)
  }
  expect_error(
    predict(fixture_load("jm"), warn = FALSE),
    "not yet implemented"
  )
  # imputed values were not monitored in this fixture
  # (m = 2: the fixtures have too few iterations for the default m = 10)
  expect_error(get_MIdat(fixture_load("glm_binomial"), m = 2), "monitor")
})
