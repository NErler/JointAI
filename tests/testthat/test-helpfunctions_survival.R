library(testthat)

test_that("non-factors are returned unchanged", {
  expect_identical(factor_to_integer(1:3), 1:3)
  chars <- c("a", "b", "c")
  expect_identical(factor_to_integer(chars), chars)
})

test_that("binary factor mapped to 0/1 integers", {
  f <- factor(c("no", "yes", "no"))
  res <- factor_to_integer(f)
  expect_type(res, "integer")
  expect_equal(res, c(0L, 1L, 0L))
})

test_that("multinomial/ordinal factor mapped to 1..n integers", {
  f <- factor(c("low", "med", "high", "med"))
  expect_equal(factor_to_integer(f), as.integer(f))

  of <- ordered(c("low", "med", "high", "low"))
  expect_equal(factor_to_integer(of), as.integer(of))
})

test_that("NA values in factors are preserved", {
  f <- factor(c("a", NA, "b"))
  res <- factor_to_integer(f)
  expect_true(is.na(res[2]))
  expect_equal(res[c(1, 3)], c(0, 1))
})

test_that("factor with a single level produces an error", {
  expect_error(factor_to_integer(factor("only")))
})
