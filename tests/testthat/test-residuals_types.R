# Which type of residuals residuals() uses for which outcome, without JAGS: an
# object with only the elements that residuals() needs, and Poisson outcomes,
# for which the three types of residuals differ.

resid_type_object <- function(outcomes = c("a", "b", "c")) {
  n <- 6L
  y <- c(0, 1, 2, 3, 4, 5)
  structure(
    list(
      fixed = setNames(
        lapply(outcomes, function(k) as.formula(paste(k, "~ 1"))),
        outcomes
      ),
      info_list = setNames(
        lapply(outcomes, function(k) {
          list(modeltype = "glm", family = "poisson", link = "log")
        }),
        outcomes
      ),
      fitted.values = setNames(
        lapply(outcomes, function(k) rep(2.5, n)),
        outcomes
      ),
      data = as.data.frame(setNames(lapply(outcomes, function(k) y), outcomes))
    ),
    class = "JointAI"
  )
}

# the expected residuals of each type (mean 2.5, log link)
expected_resid <- function(type) {
  y <- c(0, 1, 2, 3, 4, 5)
  switch(
    type,
    working = (y - 2.5) / 2.5,
    pearson = (y - 2.5) / sqrt(2.5),
    response = y - 2.5
  )
}

expect_resid_types <- function(res, types) {
  for (k in names(types)) {
    expect_equal(res[[k]], expected_resid(types[[k]]), label = k)
  }
}

test_that("the default type is working residuals for all outcomes", {
  # with 2 and 3 outcomes: not recycled from the vector of possible types
  expect_resid_types(
    residuals(resid_type_object(c("a", "b")), warn = FALSE),
    c(a = "working", b = "working")
  )
  expect_resid_types(
    residuals(resid_type_object(), warn = FALSE),
    c(a = "working", b = "working", c = "working")
  )
  # one outcome: the vector of residuals itself
  expect_equal(
    residuals(resid_type_object("a"), warn = FALSE),
    expected_resid("working")
  )
})

test_that("one unnamed type is used for all outcomes", {
  expect_resid_types(
    residuals(resid_type_object(), type = "pearson", warn = FALSE),
    c(a = "pearson", b = "pearson", c = "pearson")
  )
})

test_that("a named type applies to the named outcomes, the others use the default", {
  # a named vector with fewer types than outcomes
  expect_resid_types(
    residuals(
      resid_type_object(),
      type = c(c = "response", a = "pearson"),
      warn = FALSE
    ),
    c(a = "pearson", b = "working", c = "response")
  )
  # a single named type
  expect_resid_types(
    residuals(resid_type_object(), type = c(b = "pearson"), warn = FALSE),
    c(a = "working", b = "pearson", c = "working")
  )
})

test_that("names of type that are not outcomes give an error", {
  expect_error(
    residuals(resid_type_object(), type = c(d = "pearson"), warn = FALSE),
    "must match outcome"
  )
})
