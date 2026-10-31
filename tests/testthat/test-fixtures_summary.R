# Post-processing of fitted models, tested on stored fixtures (no JAGS run):
# the results of all types in fixture_results() (summary(), coef(), confint(),
# predict(), parameters(), get_MIdat(), ...) are compared with stored results;
# printing must
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
  test_that(paste("post-processing results as stored:", k), {
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

test_that("print(summary()) gives the number of iterations per chain", {
  object <- fixture_load("lm")
  # the fixture has iterations 101:150; e.g. end = 141, thin = 10 keeps the
  # iterations 101, 111, ..., 141, i.e. 5 per chain
  for (args in list(
    list(),
    list(thin = 2),
    list(end = 141, thin = 10),
    list(start = 111, end = 131, thin = 5)
  )) {
    smry <- suppressWarnings(do.call(summary, c(list(object), args)))
    printed <- capture.output(print(smry))
    n_iter <- nrow(window(
      object$MCMC[[1L]],
      start = smry$start,
      end = smry$end,
      thin = smry$thin
    ))
    expect_true(
      paste("Sample size per chain =", n_iter) %in% trimws(printed),
      label = paste(names(args), args, collapse = ", ")
    )
  }
})
