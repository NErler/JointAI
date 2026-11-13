# divide_matrices() extends `auxvars` with the time variable and with variables
# that have no design-matrix column of their own (e.g. `C2` in `I(C2^2)`), by
# building a new formula from text. That formula, and the `terms` object made
# from it (in `terms_list`), got the evaluation frame of divide_matrices() as
# environment. The frame holds the data and all design matrices (e.g. `MX`),
# so every saved fit carried them (several MB for a JM on PBC).
# The check: no formula or terms object in `Mlist` has an environment that
# contains `MX`, a local variable of divide_matrices().

skip_on_cran()

test_that("auxvars extended by a variable inside a function: no frame of divide_matrices()", {
  fit <- lme_imp(
    y ~ C1 + B2 + c1 + I(C2^2) + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  expect_equal(all.vars(fit$Mlist$auxvars), "C2")
  expect_false(exists(
    "MX",
    envir = environment(fit$Mlist$auxvars),
    inherits = FALSE
  ))

  for (k in seq_along(fit$Mlist$terms_list)) {
    env <- environment(fit$Mlist$terms_list[[k]])
    expect_false(
      exists("MX", envir = env, inherits = FALSE),
      label = paste("terms_list element", k)
    )
  }
})


test_that("auxvars extended by the time variable: no frame of divide_matrices()", {
  fit <- coxph_imp(
    Surv(futime, status != "censored") ~ age + sex + albumin + (1 | id),
    timevar = "day",
    data = PBC,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  expect_equal(all.vars(fit$Mlist$auxvars), "day")
  expect_false(exists(
    "MX",
    envir = environment(fit$Mlist$auxvars),
    inherits = FALSE
  ))

  for (k in seq_along(fit$Mlist$terms_list)) {
    env <- environment(fit$Mlist$terms_list[[k]])
    expect_false(
      exists("MX", envir = env, inherits = FALSE),
      label = paste("terms_list element", k)
    )
  }
})


test_that("auxvars given by the user keep the user's environment", {
  aux <- ~ C2 + M1
  fit <- lm_imp(
    y ~ C1 + B2,
    auxvars = aux,
    data = wideDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  expect_identical(environment(fit$Mlist$auxvars), environment(aux))

  for (k in seq_along(fit$Mlist$terms_list)) {
    env <- environment(fit$Mlist$terms_list[[k]])
    expect_false(
      exists("MX", envir = env, inherits = FALSE),
      label = paste("terms_list element", k)
    )
  }
})
