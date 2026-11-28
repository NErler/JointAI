# The data for JAGS (data_list) must be numeric: rjags >= 5 drops data values
# that are not numeric (with the warning "Non-numeric data values supplied"),
# which leaves the corresponding nodes of the JAGS model undefined.

test_that("the hyperparameters of the random effects are numeric", {
  # set-up: a mixed model, which uses the hyperparameters of the random effects
  fit <- lme_imp(
    y ~ C1 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )

  # the values of default_hyperpars(), as numbers
  expect_identical(fit$data_list$shape_diag_RinvD, 0.01)
  expect_identical(fit$data_list$rate_diag_RinvD, 0.001)
})

test_that("all elements of the data list are numeric", {
  # set-up: a mixed model with scaled covariates (the scaling parameters are
  # data frames with numeric columns)
  fit <- lme_imp(
    y ~ C1 + c1 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )

  # each element is numeric, or a data frame whose columns are all numeric
  for (name in names(fit$data_list)) {
    x <- fit$data_list[[name]]
    is_numeric <- if (is.data.frame(x)) {
      all(vapply(x, is.numeric, logical(1L)))
    } else {
      is.numeric(x)
    }
    expect_true(is_numeric, info = name)
  }
})
