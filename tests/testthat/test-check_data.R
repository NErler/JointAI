# Regression tests for tibble input (GitHub issues #12 and #16).
# Before adfbd7c0, check_data() failed for tibbles with
# "default method not implemented for type 'list'" from is.nan(), because
# `data[, k]` on a tibble returns a tibble and not a vector.
# These tests call check_data() directly, so JAGS is not needed.

run_check_data <- function(data, formula) {
  formula <- check_formula_list(formula)
  check_data(
    data,
    fixed = split_formula_list(formula)$fixed,
    random = split_formula_list(formula)$random,
    auxvars = NULL,
    timevar = NULL,
    mess = FALSE,
    warn = FALSE
  )
}

test_that("check_data() accepts a tibble (example from issue #12)", {
  skip_if_not_installed("tibble")

  set.seed(284397)
  df <- data.frame(y = rnorm(100), x = c(rnorm(99), NA))

  res <- run_check_data(tibble::as_tibble(df), y ~ x)

  expect_s3_class(res, "data.frame", exact = TRUE)
  expect_identical(res, run_check_data(df, y ~ x))
})

test_that("check_data() gives the same result for a tibble and a data.frame", {
  skip_if_not_installed("tibble")

  # continuous, binary, multi-category and ordinal variables with missing
  # values, plus a logical and a two-valued numeric variable, which
  # check_data() converts to factors
  df <- wideDF
  df$lgl <- df$C2 > 0
  df$num2 <- ifelse(df$C1 > 1.45, 1, 0)
  form <- y ~ C1 + C2 + B1 + B2 + M1 + O1 + lgl + num2

  res <- run_check_data(tibble::as_tibble(df), form)

  expect_s3_class(res, "data.frame", exact = TRUE)
  expect_identical(res, run_check_data(df, form))
  expect_true(all(vapply(res[c("lgl", "num2")], is.factor, logical(1))))
})
