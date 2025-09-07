library("JointAI")

# replace_nan_with_na ---------------------------------------------------------
test_that("replaces NaN with NA in numeric vector", {
  x <- c(1, NaN, 3)
  expect_equal(replace_nan_with_na(x), c(1, NA, 3))
})

test_that("does not change vector without NaN", {
  x <- c(1, 2, 3)
  expect_equal(replace_nan_with_na(x), x)
})

test_that("handles all NaN vector", {
  x <- c(NaN, NaN)
  expect_equal(replace_nan_with_na(x), c(NA_real_, NA_real_))
})

test_that("handles mixed types with NaN", {
  x <- c(1, NaN, NA, 4)
  expect_equal(replace_nan_with_na(x), c(1, NA, NA, 4))
})

test_that("replace_nan_with_na works with matrix", {
  x <- matrix(c(1, NaN, 3, NaN), nrow = 2)
  expect_equal(replace_nan_with_na(x), x)
})

test_that("replace_nan_with_na throws error", {
  x <- matrix(c(1, NaN, 3, NaN), nrow = 2)
  df <- data.frame(a = c(1, NaN), b = c(NaN, 2))
  expect_error(replace_nan_with_na(df))
  expect_error(replace_nan_with_na(list(x)))
})


# two_value_to_factor ---------------------------------------------------------
test_that("converts numeric vector with two unique values to factor", {
  x <- c(1, 2, 1, 2)
  result <- two_value_to_factor(x)
  expect_s3_class(result, "factor")
  expect_equal(levels(result), c("1", "2"))
})

test_that("does not convert numeric vector with more than two unique values", {
  x <- c(1, 2, 3)
  result <- two_value_to_factor(x)
  expect_type(result, "double")
})

test_that("does not convert factor input", {
  x <- factor(c("yes", "no", "yes"))
  result <- two_value_to_factor(x)
  expect_identical(result, x)
})

test_that("handles NA values correctly", {
  x <- c(1, 2, NA, 1, 2)
  result <- two_value_to_factor(x)
  expect_s3_class(result, "factor")
  expect_equal(levels(result), c("1", "2"))
})

test_that("does not convert vector with only one unique non-NA value", {
  x <- c(1, 1, NA)
  result <- two_value_to_factor(x)
  expect_type(result, "double")
})

test_that("works with character vectors", {
  x <- c("a", "b", "a", "b")
  result <- two_value_to_factor(x)
  expect_s3_class(result, "factor")
  expect_equal(levels(result), c("a", "b"))
})

test_that("works with logical vectors", {
  x <- c(TRUE, TRUE, FALSE, TRUE)
  result <- two_value_to_factor(x)
  expect_s3_class(result, "factor")
  expect_equal(levels(result), c("FALSE", "TRUE"))
})

test_that("returns input unchanged if not converted", {
  x <- c(1, 2, 3)
  result <- two_value_to_factor(x)
  expect_identical(result, x)
})



# compare_data_structure ------------------------------------------------------
test_that("detects class changes between data.frames", {
  df1 <- data.frame(a = 1:3, b = factor(c("x", "y", "x")))
  df2 <- data.frame(a = as.character(1:3), b = factor(c("x", "y", "x")))

  expect_message(compare_data_structure(df1, df2),
                 regexp = paste0("The variable\\(s\\) ", dQuote("a"),
                                 " was/were changed to ", dQuote("character")))
})

test_that("detects level changes in factor variables", {
  df1 <- data.frame(a = factor(c("x", "y", "x")))
  df2 <- data.frame(a = factor(c("x", "y", "z"), levels = c("x", "y", "z")))

  expect_message(compare_data_structure(df1, df2),
                 regexp = "The levels of the variable")
})

test_that("detects both class and level changes", {
  df1 <- data.frame(a = 1:3, b = factor(c("x", "y", "x")))
  df2 <- data.frame(a = as.character(1:3), b = factor(c("x", "y", "z"),
                                                      levels = c("x", "y", "z")))

  expect_message(compare_data_structure(df1, df2),
                 regexp = "The variable\\(s\\)")
  expect_message(compare_data_structure(df1, df2),
                 regexp = "The levels of the variable")
})



test_that("no message when data.frames are structurally identical", {
  df1 <- data.frame(a = 1:3, b = factor(c("x", "y", "x")))
  df2 <- df1

  expect_silent(compare_data_structure(df1, df2))
})

test_that("handles non-factor variables without error", {
  df1 <- data.frame(a = 1:3, b = letters[1:3])
  df2 <- data.frame(a = 1:3, b = letters[1:3])

  expect_silent(compare_data_structure(df1, df2))
})
