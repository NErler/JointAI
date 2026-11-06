library("survival")

# Checks for outcomes that are used in more than one model formula
# (outcomes_to_mat()). No JAGS.

set.seed(2026)
n <- 20
dup_data <- data.frame(
  y = rnorm(n),
  x = rnorm(n),
  z = rnorm(n),
  t = rexp(n),
  t2 = rexp(n),
  e1 = rbinom(n, 1L, 0.5),
  e2 = rbinom(n, 1L, 0.5),
  cause = sample(0:2, n, replace = TRUE),
  all_events = 1L,
  all_events2 = 1L,
  int = rpois(n, 3)
)
dup_data$y_copy <- dup_data$y
# the same values, stored as double instead of integer
dup_data$int_copy <- as.numeric(dup_data$int)

# run outcomes_to_mat() for a list of formulas; returns the error message
# (whitespace collapsed) or the column names of the outcome matrix
run_outcomes_to_mat <- function(fixed, analysis_type) {
  outcomes <- extract_outcome_data(
    fixed,
    data = dup_data,
    analysis_type = analysis_type
  )
  tryCatch(
    colnames(outcomes_to_mat(outcomes)),
    error = function(e) gsub("\\s+", " ", conditionMessage(e))
  )
}


test_that("the same variable as outcome of two models gives an error", {
  res <- run_outcomes_to_mat(list(y ~ x, y ~ z), "lm")
  expect_match(
    res,
    'The variable "y" is used on the left hand side of more than one',
    fixed = TRUE
  )
})

test_that("a copy of an outcome gives an error that says so", {
  res <- run_outcomes_to_mat(list(y ~ x, y_copy ~ x + z), "lm")
  expect_match(
    res,
    'The outcomes "y" and "y_copy" have identical values.',
    fixed = TRUE
  )

  # integer and double values count as identical
  res <- run_outcomes_to_mat(list(int ~ x, int_copy ~ z), "lm")
  expect_match(
    res,
    'The outcomes "int" and "int_copy" have identical values.',
    fixed = TRUE
  )
})

test_that("parametric survival outcomes with the same time give an error", {
  res <- run_outcomes_to_mat(
    list(Surv(t, e1) ~ x, Surv(t, e2) ~ z),
    "survreg"
  )
  expect_match(
    res,
    paste(
      'The survival outcomes "Surv(t, e1)" and "Surv(t, e2)" have the same',
      "survival times."
    ),
    fixed = TRUE
  )
  expect_match(res, "competing risks", fixed = TRUE)

  # different event types from the same variable
  res <- run_outcomes_to_mat(
    list(Surv(t, cause == 1) ~ x, Surv(t, cause == 2) ~ z),
    "survreg"
  )
  expect_match(res, "have the same survival times.", fixed = TRUE)
})

test_that("proportional hazards outcomes may share the survival time", {
  # needed for several survival outcomes with time-varying covariates
  for (type in c("coxph", "JM")) {
    expect_equal(
      run_outcomes_to_mat(
        list(Surv(t, cause == 1) ~ x, Surv(t, cause == 2) ~ z, y ~ x),
        type
      ),
      c("t", "cause == 1", "t", "cause == 2", "y"),
      info = type
    )
  }
})

test_that("a survival time that is also modelled as outcome gives an error", {
  for (type in c("survreg", "coxph", "JM")) {
    res <- run_outcomes_to_mat(
      list(Surv(t, e1) ~ x, t ~ z),
      type
    )
    expect_match(
      res,
      'The variable "t" is used on the left hand side of more than one',
      fixed = TRUE,
      info = type
    )
  }
  # also when the time is shared by two proportional hazards outcomes
  res <- run_outcomes_to_mat(
    list(Surv(t, e1) ~ x, Surv(t, e2) ~ z, t ~ x),
    "coxph"
  )
  expect_match(
    res,
    'The variable "t" is used on the left hand side of more than one',
    fixed = TRUE
  )
})

test_that("the same event indicator in two survival outcomes gives an error", {
  for (type in c("survreg", "coxph", "JM")) {
    res <- run_outcomes_to_mat(
      list(Surv(t, e1) ~ x, Surv(t2, e1) ~ z),
      type
    )
    expect_match(
      res,
      'The variable "e1" is used on the left hand side of more than one',
      fixed = TRUE,
      info = type
    )
  }
})

test_that("an event indicator that is also modelled as outcome gives an error", {
  for (type in c("survreg", "coxph", "JM")) {
    res <- run_outcomes_to_mat(list(Surv(t, e1) ~ x, e1 ~ z), type)
    expect_match(
      res,
      'The variable "e1" is used on the left hand side of more than one',
      fixed = TRUE,
      info = type
    )
  }
})

test_that("different survival outcomes with identical event indicators work", {
  # e.g., no censoring in either outcome
  for (type in c("survreg", "coxph", "JM")) {
    expect_equal(
      run_outcomes_to_mat(
        list(Surv(t, all_events) ~ x, Surv(t2, all_events2) ~ z),
        type
      ),
      c("t", "all_events", "t2", "all_events2"),
      info = type
    )
  }
})

test_that("different survival outcomes work", {
  for (type in c("survreg", "coxph", "JM")) {
    expect_equal(
      run_outcomes_to_mat(
        list(Surv(t, e1) ~ x, Surv(t2, e2) ~ z, y ~ x),
        type
      ),
      c("t", "e1", "t2", "e2", "y"),
      info = type
    )
  }
})
