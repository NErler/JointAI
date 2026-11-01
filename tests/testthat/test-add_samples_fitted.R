# add_samples(): the fitted values and residuals of the returned object have to
# be those of the MCMC sample of the returned object.

fit_short_model <- function(n.iter = 10L) {
  lm_imp(
    y ~ C1 + C2,
    data = wideDF,
    n.adapt = 10L,
    n.iter = n.iter,
    n.chains = 1L,
    seed = 2026L,
    progress.bar = "none",
    mess = FALSE,
    warn = FALSE
  )
}

expect_current_fit <- function(object) {
  expected <- fitted_values(object, mess = FALSE, warn = FALSE)
  expect_equal(object$fitted.values, expected)
  expect_equal(object$residuals, object$data$y - expected)
}

test_that("add = FALSE replaces the fitted values and residuals", {
  old <- fit_short_model()
  new <- add_samples(
    old,
    n.iter = 10L,
    add = FALSE,
    progress.bar = "none",
    mess = FALSE
  )

  expect_false(isTRUE(all.equal(new$fitted.values, old$fitted.values)))
  expect_current_fit(new)
})

test_that("add = TRUE uses all samples for the fitted values and residuals", {
  old <- fit_short_model()
  new <- add_samples(
    old,
    n.iter = 10L,
    add = TRUE,
    progress.bar = "none",
    mess = FALSE
  )

  expect_equal(coda::niter(new$MCMC), 20L)
  expect_false(isTRUE(all.equal(new$fitted.values, old$fitted.values)))
  expect_current_fit(new)
})

test_that("a model without sample gets fitted values and residuals", {
  old <- fit_short_model(n.iter = 0L)
  new <- add_samples(
    old,
    n.iter = 10L,
    add = FALSE,
    progress.bar = "none",
    mess = FALSE
  )

  expect_null(old$fitted.values)
  expect_current_fit(new)
})

test_that("old fitted values do not stay if they cannot be calculated", {
  old <- fit_short_model()
  new <- add_samples(
    old,
    n.iter = 10L,
    add = FALSE,
    monitor_params = list(analysis_main = FALSE, sigma_main = TRUE),
    progress.bar = "none",
    mess = FALSE
  )

  expect_false(any(grepl("^beta", colnames(new$MCMC[[1L]]))))
  expect_null(new$fitted.values)
  expect_null(new$residuals)
})
