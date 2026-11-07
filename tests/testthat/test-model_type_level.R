# A model type given in `models` has to fit the level of its variable: a
# variable that varies within the groups of a grouping level (it is not on the
# highest level) needs a model with random effects, a variable on the highest
# level a model without. Before, a model without random effects for a
# level-one variable lost the part of its linear predictor on the higher
# levels (intercept and covariates of those levels) without a message; the
# other mismatches stopped with errors from JAGS.

dat3 <- longDF
dat3$center <- as.integer(dat3$id) %% 5L

test_that("no random effects for a variable below the highest level", {
  # level one, two levels
  expect_error(
    get_models(
      fixed = y ~ C1 + c2 + time,
      random = ~ 1 | id,
      data = longDF,
      models = c(c2 = "glm_gaussian_identity")
    ),
    "glmm_gaussian_identity"
  )

  # middle level (id), three levels
  expect_error(
    get_models(
      fixed = y ~ C1 + C2 + time,
      random = ~ (1 | id) + (1 | center),
      data = dat3,
      models = c(C2 = "lm")
    ),
    "lmm"
  )
})

test_that("random effects for a variable on the highest level", {
  expect_error(
    get_models(
      fixed = y ~ C2 + c2 + time,
      random = ~ 1 | id,
      data = longDF,
      models = c(C2 = "lmm")
    ),
    "\"lm\""
  )

  # a model with only one level
  expect_error(
    get_models(
      fixed = y ~ C1 + B2,
      data = wideDF,
      models = c(B2 = "glmm_binomial_logit")
    ),
    "glm_binomial_logit"
  )
})

test_that("types that fit the level are accepted", {
  models <- get_models(
    fixed = y ~ C1 + C2 + c2 + time,
    random = ~ 1 | id,
    data = longDF,
    models = c(c2 = "glmm_gamma_log", C2 = "lognorm")
  )
  expect_identical(models[["c2"]], "glmm_gamma_log")
  expect_identical(models[["C2"]], "lognorm")
})
