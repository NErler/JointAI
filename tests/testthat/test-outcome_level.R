# The outcome of a model with random effects for a grouping variable must vary
# within that grouping variable. An outcome on the level of the subjects (e.g.
# C2 in longDF) with random effects for the subjects gave an empty linear
# predictor (JAGS error) or, for multinomial mixed models, a model without any
# covariates or random effects.
# The models are set up without JAGS run (n.adapt = 0, n.iter = 0).

skip_on_cran()

test_that("an outcome on the level of the random effects gives an error", {
  expect_error(
    lme_imp(
      C2 ~ C1 + c1 + time + (1 | id),
      data = longDF,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "The outcome \"C2\" does not vary within \"id\""
  )
  expect_error(
    glme_imp(
      B1 ~ C1 + c1 + (1 | id),
      family = binomial(),
      data = longDF,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "The outcome \"B1\" does not vary within \"id\""
  )
  expect_error(
    clmm_imp(
      O1 ~ C1 + c1 + (1 | id),
      data = longDF,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "The outcome \"O1\" does not vary within \"id\""
  )
  expect_error(
    mlogitmm_imp(
      M1 ~ C1 + c1 + (1 | id),
      data = longDF,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "The outcome \"M1\" does not vary within \"id\""
  )
})

test_that("models with an outcome that varies within the groups still work", {
  expect_no_error(lme_imp(
    y ~ C1 + c1 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  ))

  # survival models: (1 | id) defines the subjects of the time-varying
  # covariates
  pbc <- PBC[PBC$id %in% unique(PBC$id)[1:30], ]
  expect_no_error(coxph_imp(
    Surv(futime, status != "censored") ~ age + chol + (1 | id),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  ))
  expect_no_error(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + chol,
      chol ~ age + day + (day | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  ))
})

test_that("crossed grouping variables", {
  # y_a is constant within a, but varies within the crossed b
  set.seed(1)
  dat <- expand.grid(a = 1:6, b = 1:5, rep = 1:2)
  dat$x <- rnorm(nrow(dat))
  dat$y_a <- rnorm(6)[dat$a]

  expect_no_error(lme_imp(
    y_a ~ x + (1 | b),
    data = dat,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  ))
  expect_error(
    lme_imp(
      y_a ~ x + (1 | a) + (1 | b),
      data = dat,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "The outcome \"y_a\" does not vary within \"a\""
  )
})


# the check function ------------------------------------------------------------

test_that("check_outcome_varies_within_groups()", {
  dat <- data.frame(
    id = c(1, 1, 2, 2, 3, 3),
    y = c(1, 2, 3, 3, NA, 5),
    z = c(1, 1, 2, NA, 3, 3)
  )

  # y varies within id (in id 1)
  expect_null(check_outcome_varies_within_groups(
    fixed = list(y = y ~ 1),
    random = list(y = ~ 1 | id),
    data = dat
  ))
  # also with a transformation of the outcome
  expect_null(check_outcome_varies_within_groups(
    fixed = list(y = log(y) ~ 1),
    random = list(y = ~ 1 | id),
    data = dat
  ))
  # z does not vary within id (missing values are ignored)
  expect_error(
    check_outcome_varies_within_groups(
      fixed = list(z = z ~ 1),
      random = list(z = ~ 1 | id),
      data = dat
    ),
    "The outcome \"z\" does not vary within \"id\", so its model cannot have\\s+random effects for \"id\"\\.$"
  )
  # no random effects, and survival outcomes, are not checked
  expect_null(check_outcome_varies_within_groups(
    fixed = list(z = z ~ 1, y = y ~ 1),
    random = list(z = NULL, y = ~ 1 | id),
    data = dat
  ))
  expect_null(check_outcome_varies_within_groups(
    fixed = list(`Surv(z, y)` = Surv(z, y) ~ 1),
    random = list(`Surv(z, y)` = ~ 1 | id),
    data = dat
  ))
})
