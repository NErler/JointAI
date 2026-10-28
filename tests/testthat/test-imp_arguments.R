# Arguments of model_imp() that the *_imp() functions do not have themselves
# are passed on via `...`. They must be evaluated where they were specified:
# in a calling function (local variables), or in a function that passes on
# its own `...`. The models are set up but not sampled.

skip_on_cran()

test_that("merge_call_args() evaluates `...` arguments where they were given", {
  f <- function(a = 1, ...) {
    merge_call_args(formals(), match.call(), environment())
  }
  # local variable of a calling function
  g <- function() {
    v <- 4
    f(d = v)
  }
  expect_identical(g()$d, 4)
  # function that passes on its `...`
  h <- function(...) f(...)
  k <- function() {
    v <- 4
    h(d = v)
  }
  expect_identical(k()$d, 4)
  expect_identical(h(a = 2)$a, 2)
})

test_that("*_imp() arguments passed via `...` can be local variables", {
  fit <- function() {
    tr <- list(C2 = c(-10, 10))
    lm_imp(
      y ~ C1 + C2,
      data = wideDF,
      trunc = tr,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE,
      warn = FALSE
    )
  }
  expect_identical(fit()$info_list$C2$trunc, c(-10, 10))
})

test_that("*_imp() arguments passed via `...` can be passed on", {
  fit <- function(...) {
    lm_imp(
      y ~ C1 + C2,
      data = wideDF,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE,
      warn = FALSE,
      ...
    )
  }
  caller <- function() {
    cu <- list(C2 = "  C2[i] ~ dnorm(0, 1)")
    fit(custom = cu)
  }
  expect_identical(caller()$info_list$C2$custom, "  C2[i] ~ dnorm(0, 1)")

  # a function that gets the model function and all its arguments via `...`
  run <- function(fun, ...) fun(...)
  mod <- run(
    lm_imp,
    y ~ C1 + C2,
    data = wideDF,
    trunc = list(C2 = c(-10, 10)),
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  expect_identical(mod$info_list$C2$trunc, c(-10, 10))
})
