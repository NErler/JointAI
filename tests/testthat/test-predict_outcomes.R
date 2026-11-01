# predict() for models with more than one outcome, tested on stored fixtures
# (no JAGS run): the prediction for one outcome must only use the parameters of
# that outcome, and a named `type` must only apply to the named outcomes.

skip_on_cran()

pred <- function(object, ...) {
  suppressWarnings(predict(object, mess = FALSE, warn = FALSE, ...))
}

# add columns with the parameters of another outcome to the MCMC sample
add_mcmc_columns <- function(object, new_columns) {
  chains <- lapply(object$MCMC, function(chain) {
    new <- matrix(
      100,
      nrow = nrow(chain),
      ncol = length(new_columns),
      dimnames = list(NULL, new_columns)
    )
    coda::mcmc(
      cbind(as.matrix(chain), new),
      start = start(chain),
      thin = coda::thin(chain)
    )
  })
  object$MCMC <- coda::as.mcmc.list(chains)
  object
}

test_that("ordinal models do not use the thresholds of a similar outcome name", {
  object <- fixture_load("clm_nonprop")
  # O1 and O11: the name of the outcome is the start of another name
  extended <- add_mcmc_columns(object, paste0("gamma_O11[", 1:3, "]"))

  for (type in fixture_predict_types(object)) {
    expect_equal(
      pred(extended, type = type)$fitted,
      pred(object, type = type)$fitted,
      label = type
    )
  }

  # one set of probabilities per category of the outcome
  expect_equal(
    dimnames(pred(extended, type = "prob")$fitted)[[3L]],
    paste0("P(O1=", levels(object$data$O1), ")")
  )
})

test_that("Cox models do not use the baseline hazard of another outcome", {
  object <- fixture_load("coxph")
  extended <- add_mcmc_columns(object, paste0("beta_Bh0_Other[", 1:6, "]"))

  for (type in fixture_predict_types(object)) {
    expect_equal(
      pred(extended, type = type)$fitted,
      pred(object, type = type)$fitted,
      label = type
    )
  }
})

# a model with two outcomes "B1" and "B2nd", which have the same parameters, so
# that the results differ only by the type of the prediction
two_outcomes <- function() {
  object <- fixture_load("glm_binomial")
  object$fixed$B2nd <- object$fixed$B1
  object$coef_list$B2nd <- object$coef_list$B1
  object$info_list$B2nd <- object$info_list$B1
  object
}

test_that("one unnamed type is used for all outcomes", {
  object <- two_outcomes()
  fit <- pred(object, outcome = 1:2, type = "response")$fitted
  expected <- pred(fixture_load("glm_binomial"), type = "response")$fitted

  expect_equal(fit$B1, expected)
  expect_equal(fit$B2nd, expected)
})

test_that("a named type applies to the named outcomes, the others use lp", {
  object <- two_outcomes()
  single <- fixture_load("glm_binomial")
  lp <- pred(single, type = "lp")$fitted
  response <- pred(single, type = "response")$fitted

  # a single named type
  fit <- pred(object, outcome = 1:2, type = c(B2nd = "response"))$fitted
  expect_equal(fit$B1, lp)
  expect_equal(fit$B2nd, response)

  # all outcomes named
  fit <- pred(
    object,
    outcome = 1:2,
    type = c(B2nd = "lp", B1 = "response")
  )$fitted
  expect_equal(fit$B1, response)
  expect_equal(fit$B2nd, lp)
})

test_that("names of type that are not outcomes give an error", {
  object <- two_outcomes()

  expect_error(
    pred(object, outcome = 1:2, type = c(other = "response")),
    "must match outcome"
  )
  expect_error(
    pred(object, outcome = 1:2, type = c(B1 = "lp", other = "response")),
    "must match outcome"
  )
})
