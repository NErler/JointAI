# parameters(): coefficients that are monitored as single elements (or ranges)
# of a node have to be listed with the information from the coefficient list.

monitored_parameters <- function(monitor_params, ...) {
  fit <- lme_imp(
    y ~ C1 + c1 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    monitor_params = monitor_params,
    mess = FALSE,
    ...
  )
  parameters(fit, mess = FALSE)
}

test_that("a single element of a coefficient node is found", {
  params <- monitored_parameters(
    list(analysis_main = FALSE, other = "beta[2]"),
    scale_vars = FALSE
  )

  expect_named(params, c("outcome", "outcat", "varname", "coef"))
  expect_equal(params$coef, "beta[2]")
  expect_equal(params$outcome, "y")
  expect_equal(params$varname, "C1")
})

test_that("a range of elements of a coefficient node gives one row each", {
  params <- monitored_parameters(
    list(analysis_main = FALSE, other = "beta[2:3]"),
    scale_vars = FALSE
  )

  expect_equal(params$coef, c("beta[2]", "beta[3]"))
  expect_equal(params$varname, c("C1", "c1"))
})

test_that("an element of a coefficient node is found next to other nodes", {
  params <- monitored_parameters(
    list(analysis_main = FALSE, other = c("sigma_y", "beta[2]")),
    scale_vars = FALSE
  )

  expect_setequal(params$coef, c("beta[2]", "sigma_y"))
  expect_equal(params$varname[params$coef == "beta[2]"], "C1")
  expect_equal(params$outcome, c("y", "y"))
})

test_that("coefficients added because of the scaling are found", {
  params <- monitored_parameters(
    list(analysis_main = FALSE, other = "b_y_id[5,2]")
  )

  betas <- params[params$coef != "b_y_id[5,1:2]", ]
  expect_equal(betas$coef, paste0("beta[", 1:4, "]"))
  expect_equal(betas$varname, c("(Intercept)", "C1", "c1", "time"))
  expect_equal(betas$outcome, rep("y", 4L))
})

test_that("elements of the coefficients of a covariate model are found", {
  fit <- lm_imp(
    y ~ C1 + C2 + B2,
    data = wideDF,
    n.adapt = 0,
    n.iter = 0,
    monitor_params = list(analysis_main = FALSE, other = "alpha[1]"),
    mess = FALSE
  )
  params <- parameters(fit, mess = FALSE)

  expect_true("alpha[1]" %in% params$coef)
  expect_false(anyNA(params$varname[grepl("^alpha", params$coef)]))
  expect_false(anyNA(params$outcome[grepl("^alpha", params$coef)]))
})

test_that("the columns have the same order without any coefficient", {
  params <- monitored_parameters(
    list(analysis_main = FALSE, other = "sigma_y"),
    scale_vars = FALSE
  )

  expect_named(params, c("outcome", "outcat", "varname", "coef"))
  expect_equal(params$coef, "sigma_y")
})
