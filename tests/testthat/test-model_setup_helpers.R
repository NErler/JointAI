# The helpers of get_models(): the checks of the arguments `models` and
# `no_model`, the table of variables that can get a model, and the order of the
# models. get_models() itself is tested in test-get_models.R.

# check_models_args() ----------------------------------------------------------

test_that("check_models_args() passes valid arguments silently", {
  # B1 is a column of the data and part of the model, C1 is complete
  expect_silent(
    check_models_args(
      models_user = c(B1 = "glm_binomial_logit"),
      no_model = "C1",
      data = wideDF,
      allvars = c("y", "C1", "B1")
    )
  )

  # nothing given by the user
  expect_silent(
    check_models_args(
      models_user = NULL,
      no_model = NULL,
      data = wideDF,
      allvars = c("y", "C1")
    )
  )
})

test_that("check_models_args() rejects a variable that is not in the data", {
  expect_error(
    check_models_args(
      models_user = c(xyz = "lm"),
      no_model = NULL,
      data = wideDF,
      allvars = c("y", "C1")
    ),
    "not found in the data"
  )
})

test_that("check_models_args() rejects an incomplete variable in no_model", {
  # C2 has missing values in wideDF
  expect_true(anyNA(wideDF$C2))
  expect_error(
    check_models_args(
      models_user = NULL,
      no_model = "C2",
      data = wideDF,
      allvars = c("y", "C2")
    ),
    "have missing values"
  )
})

test_that("check_models_args() rejects a variable that is not in the model", {
  # C2 is a column of the data, but not part of the model formulas
  expect_error(
    check_models_args(
      models_user = c(C2 = "lm"),
      no_model = NULL,
      data = wideDF,
      allvars = c("y", "C1")
    ),
    "not part of the model"
  )
})


# get_model_variables() --------------------------------------------------------

test_that("get_model_variables() describes the variables of a 2-level model", {
  # set-up: longDF with the levels "id" (rank 2) and "lvlone" (rank 1)
  data_structure <- get_data_structure(longDF, extract_grouping(~ 1 | id))
  fixed <- get_outcome_data(
    list(y ~ c1 + C2 + b2 + o2),
    data = longDF,
    data_structure = data_structure
  )$fixed
  allvars <- c("y", "c1", "C2", "b2", "o2")

  varinfo <- get_model_variables(allvars, fixed, longDF, data_structure)

  # one row per variable, in the order of allvars
  expect_equal(varinfo$name, allvars)
  expect_equal(varinfo$outcome, c(TRUE, FALSE, FALSE, FALSE, FALSE))
  # C2 is on the subject level, the other variables on the lowest level
  expect_equal(varinfo$rank, c(1, 1, 2, 1, 1))
  # complete variables have no missing values; the others are counted on
  # their own level (C2: once per subject)
  expect_equal(varinfo$n_missing[1:2], c(0, 0))
  expect_equal(
    varinfo$n_missing[4:5],
    c(sum(is.na(longDF$b2)), sum(is.na(longDF$o2)))
  )
  expect_equal(
    varinfo$n_missing[3],
    sum(is.na(longDF$C2[!duplicated(longDF$id)]))
  )
  # types with random effects below the highest level
  expect_equal(
    varinfo$type,
    c("lmm", "lmm", "lm", "glmm_binomial_logit", "clmm")
  )
})

test_that("get_model_variables() evaluates outcome names that are no columns", {
  # set-up: the survival outcome "Surv(futime, status == 2)" is not a column of
  # the data and is evaluated in the data
  data_structure <- get_data_structure(PBC, extract_grouping(~ 1 | id))
  fixed <- get_outcome_data(
    list(Surv(futime, status == 2) ~ age + copper),
    data = PBC,
    data_structure = data_structure,
    analysis_type = "coxph"
  )$fixed
  allvars <- c(names(fixed), "age", "copper")

  varinfo <- get_model_variables(allvars, fixed, PBC, data_structure)

  expect_equal(varinfo$name, allvars)
  expect_equal(varinfo$outcome, c(TRUE, FALSE, FALSE))
  # the survival outcome is on the subject level and complete
  expect_equal(varinfo$rank[1], 2)
  expect_equal(varinfo$n_missing[1], 0)
})


# order_models() ---------------------------------------------------------------

test_that("order_models() puts the outcomes first", {
  # the outcome is in the last row, the incomplete covariate in the first
  varinfo <- data.frame(
    outcome = c(FALSE, TRUE),
    rank = c(1, 1),
    n_missing = c(5, 0)
  )
  expect_equal(order_models(varinfo), c(2L, 1L))
})

test_that("order_models() orders incomplete covariates by missing values", {
  # per level: most missing values first, ties in the order of the rows
  varinfo <- data.frame(
    outcome = c(TRUE, FALSE, FALSE, FALSE, FALSE),
    rank = c(1, 1, 1, 1, 1),
    n_missing = c(0, 2, 7, 2, 4)
  )
  expect_equal(order_models(varinfo), c(1L, 3L, 5L, 2L, 4L))
})

test_that("order_models() gives only the outcomes when nothing is missing", {
  varinfo <- data.frame(
    outcome = c(TRUE, FALSE, FALSE),
    rank = c(1, 1, 2),
    n_missing = c(0, 0, 0)
  )
  expect_equal(order_models(varinfo), 1L)

  # no covariates
  varinfo <- data.frame(outcome = TRUE, rank = 1, n_missing = 3)
  expect_equal(order_models(varinfo), 1L)
})

test_that("order_models() goes level by level, from the lowest level up", {
  # rows: outcome, then (rank, n_missing) = (2, 3), (1, 1), (3, 0), (1, 0)
  varinfo <- data.frame(
    outcome = c(TRUE, FALSE, FALSE, FALSE, FALSE),
    rank = c(1, 2, 1, 3, 1),
    n_missing = c(0, 3, 1, 0, 0)
  )
  # the highest level with missing values is 2: on level 1 the incomplete and
  # the complete covariate, on level 2 the incomplete covariate; the complete
  # covariate on level 3 gets no model
  expect_equal(order_models(varinfo), c(1L, 3L, 5L, 2L))
})

test_that("order_models() adds no complete covariates on the top NA level", {
  # missing values only on level 1: the complete covariates on level 1 and
  # level 2 get no model
  varinfo <- data.frame(
    outcome = c(TRUE, FALSE, FALSE, FALSE),
    rank = c(1, 1, 1, 2),
    n_missing = c(0, 0, 4, 0)
  )
  expect_equal(order_models(varinfo), c(1L, 3L))
})

test_that("order_models() counts missing values in outcomes for the levels", {
  # the outcome on level 2 is incomplete: as for an incomplete covariate on
  # level 2, the complete covariate on level 1 gets a model, the complete
  # covariate on level 2 does not
  varinfo <- data.frame(
    outcome = c(TRUE, FALSE, FALSE),
    rank = c(2, 1, 2),
    n_missing = c(3, 0, 0)
  )
  expect_equal(order_models(varinfo), c(1L, 2L))
})
