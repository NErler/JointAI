# Model specifications that are not supported give an informative error
# instead of an error from JAGS:
# * a joint model in which an unordered factor with more than two categories
#   is time-varying: its values between the observation times (needed for the
#   integral over the hazard) cannot be modelled yet (also not if the factor
#   is complete);
# * a model without any regression coefficient, e.g. y ~ 0 + (1 | id), for
#   the model types that need at least one (glm, glmm, mlogit, mlogitmm).

skip_on_cran()

pbc <- PBC[PBC$id %in% unique(PBC$id)[1:60], ]
pbc$event <- pbc$status != "censored"
set.seed(1)
pbc$f3 <- factor(sample(c("a", "b", "c"), nrow(pbc), replace = TRUE))
pbc$f3[sample(nrow(pbc), 20)] <- NA
pbc1 <- pbc[!duplicated(pbc$id), ]

test_that("JM_imp(): time-varying unordered factor in the survival part", {
  expect_error(
    JM_imp(
      list(Surv(futime, event) ~ age + f3, f3 ~ day + age + (day | id)),
      timevar = "day",
      data = pbc,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE,
      warn = FALSE
    ),
    "unordered factor"
  )

  # without a model for f3 in the formula list
  expect_error(
    JM_imp(
      list(Surv(futime, event) ~ age + f3 + chol, chol ~ day + (day | id)),
      timevar = "day",
      data = pbc,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE,
      warn = FALSE
    ),
    "unordered factor"
  )
})

test_that("JM_imp(): time-varying unordered factor in the model of chol", {
  # also if f3 is complete
  pbc$f3[is.na(pbc$f3)] <- "a"

  expect_error(
    JM_imp(
      list(Surv(futime, event) ~ age + chol, chol ~ day + f3 + (day | id)),
      timevar = "day",
      data = pbc,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE,
      warn = FALSE
    ),
    "unordered factor"
  )
})

test_that("models without regression coefficients", {
  expect_error(
    lm_imp(albumin ~ 0, data = pbc1, n.adapt = 0, n.iter = 0, mess = FALSE),
    "no regression coefficients"
  )
  expect_error(
    glm_imp(
      event ~ 0,
      family = binomial(),
      data = pbc1,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "no regression coefficients"
  )
  expect_error(
    lme_imp(
      chol ~ 0 + (1 | id),
      data = pbc,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "no regression coefficients"
  )
  expect_error(
    lme_imp(
      chol ~ 0 + (day | id),
      data = pbc,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "no regression coefficients"
  )
  expect_error(
    mlogit_imp(f3 ~ 0, data = pbc1, n.adapt = 0, n.iter = 0, mess = FALSE),
    "no regression coefficients"
  )
})

# the check functions ----------------------------------------------------------

test_that("check_jm_tv_modeltypes(): only glmm and clmm models", {
  expect_null(check_jm_tv_modeltypes(list(
    chol = list(modeltype = "glmm"),
    stage = list(modeltype = "clmm")
  )))
  expect_null(check_jm_tv_modeltypes(list()))

  # all variables with another model type are named
  expect_error(
    check_jm_tv_modeltypes(list(
      chol = list(modeltype = "glmm"),
      f3 = list(modeltype = "mlogitmm"),
      f4 = list(modeltype = "mlogitmm")
    )),
    "\"f3\"[[:space:]]+and[[:space:]]+\"f4\""
  )
})

test_that("check_has_coefficients()", {
  expect_null(check_has_coefficients(list(M_lvlone = 1:2), varname = "y"))
  expect_null(
    check_has_coefficients(list(M_id = 3L, M_lvlone = NULL), varname = "y")
  )

  expect_error(
    check_has_coefficients(list(M_lvlone = NULL), varname = "y"),
    "The model for \"y\" has no regression coefficients"
  )
  expect_error(
    check_has_coefficients(list(), varname = "y"),
    "no regression coefficients"
  )
})
