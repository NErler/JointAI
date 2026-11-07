# The default type of a covariate model follows from the number of categories,
# whether the variable is ordered, and whether it is on the highest level.

test_that("each kind of variable gets its model without random effects", {
  # continuous, binary, ordered and unordered factor with three categories
  expect_equal(
    default_model_types(
      n_categories = c(0L, 2L, 3L, 3L),
      ordered = c(FALSE, FALSE, TRUE, FALSE),
      highest_level = rep(TRUE, 4L)
    ),
    c("lm", "glm_binomial_logit", "clm", "mlogit")
  )
})

test_that("below the highest level, the models have random effects", {
  expect_equal(
    default_model_types(
      n_categories = c(0L, 2L, 3L, 3L),
      ordered = c(FALSE, FALSE, TRUE, FALSE),
      highest_level = rep(FALSE, 4L)
    ),
    c("lmm", "glmm_binomial_logit", "clmm", "mlogitmm")
  )
})

test_that("a binary ordered factor gets a logistic model", {
  # two categories decide before the order
  expect_equal(
    default_model_types(
      n_categories = c(2L, 2L),
      ordered = c(TRUE, TRUE),
      highest_level = c(TRUE, FALSE)
    ),
    c("glm_binomial_logit", "glmm_binomial_logit")
  )
})

test_that("a factor with one category gets no type", {
  expect_equal(
    default_model_types(
      n_categories = c(1L, 1L),
      ordered = c(FALSE, FALSE),
      highest_level = c(TRUE, FALSE)
    ),
    c(NA_character_, NA_character_)
  )
})
