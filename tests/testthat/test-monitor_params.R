# `monitor_params` is documented as a "named list or vector". When logical
# values and parameter names are combined with c(), the logical values become
# character strings ("TRUE", "FALSE"), and a vector of parameter names in
# `other` gets the names other1, other2, ... (#114). Both forms must select
# the same parameters.

skip_on_cran()

# check_monitor_params() ---------------------------------------------------------

test_that("c() and list() give the same specification", {
  specs <- list(
    list(analysis_main = TRUE, other = "tau_y"),
    list(analysis_main = FALSE, other = "tau_y"),
    list(imps = TRUE, other = "tau_y"),
    list(analysis_main = TRUE, betas = FALSE, other = c("tau_y", "alpha")),
    list(other = c("tau_y", "alpha", "beta[2]")),
    list(analysis_main = TRUE, imps = FALSE)
  )
  for (spec in specs) {
    expect_identical(
      check_monitor_params(do.call(c, spec)),
      check_monitor_params(spec),
      info = deparse(spec)
    )
  }
})

test_that("logical values given as character strings become logical", {
  expect_identical(
    check_monitor_params(c(analysis_main = TRUE, other = "tau_y")),
    list(analysis_main = TRUE, other = "tau_y")
  )
  expect_identical(
    check_monitor_params(c(analysis_main = "FALSE", imps = "TRUE")),
    list(analysis_main = FALSE, imps = TRUE)
  )
  # the order of the parameter names in `other` is kept
  expect_identical(
    check_monitor_params(c(other = c("b", "a"), analysis_main = TRUE)),
    list(other = c("b", "a"), analysis_main = TRUE)
  )
})

test_that("a correct specification is not changed", {
  expect_identical(
    check_monitor_params(c(analysis_main = TRUE)),
    list(analysis_main = TRUE)
  )
  spec <- list(analysis_main = FALSE, betas = TRUE, other = c("a", "b"))
  expect_identical(check_monitor_params(spec), spec)
  expect_identical(check_monitor_params(NULL), list())
  expect_identical(check_monitor_params(list()), list())
})

# the error message on one line (the messages are wrapped)
error_message <- function(expr) {
  gsub("\\s+", " ", tryCatch(expr, error = conditionMessage))
}

test_that("check_monitor_params() names the mistakes", {
  # misspelled name: named, and not the error of do.call() ("unused argument")
  err <- error_message(check_monitor_params(list(analysis_mian = TRUE)))
  expect_match(err, "\"analysis_mian\" in \"monitor_params\" is not a known")
  expect_no_match(err, "unused argument")

  # only the unknown names are listed
  err <- error_message(
    check_monitor_params(c(analysis_main = TRUE, imp = TRUE, tau = TRUE))
  )
  expect_match(err, "The names \"imp\" and \"tau\" in")

  # elements without a name (would be matched by position in get_params())
  expect_match(
    error_message(check_monitor_params(c(analysis_main = TRUE, "tau_y"))),
    "must be named"
  )
  expect_match(error_message(check_monitor_params(c(TRUE))), "must be named")

  # the same name twice
  expect_match(
    error_message(check_monitor_params(list(imps = TRUE, imps = FALSE))),
    "\"imps\" is used more than once"
  )

  # a parameter name where TRUE or FALSE is expected
  expect_match(
    error_message(
      check_monitor_params(c(analysis_main = TRUE, imps = "tau_y"))
    ),
    "value of \"imps\" in \"monitor_params\" must be TRUE or FALSE"
  )

  # arguments of get_params() that are not parameter groups
  expect_match(
    error_message(check_monitor_params(list(mess = FALSE))),
    "\"mess\" in \"monitor_params\" is not a known"
  )
  expect_match(
    error_message(check_monitor_params(list(Mlist = list()))),
    "\"Mlist\" in \"monitor_params\" is not a known"
  )
})

test_that("all parameter groups of get_params() are accepted", {
  groups <- setdiff(
    names(formals(get_params)),
    c("other", "mess", "Mlist", "info_list")
  )
  spec <- as.list(setNames(rep(TRUE, length(groups)), groups))
  expect_identical(check_monitor_params(spec), spec)
})


# *_imp() and add_samples() ------------------------------------------------------

test_that("*_imp() monitors the same parameters for c() and list() (#114)", {
  fit <- function(monitor_params) {
    lm_imp(
      y ~ C1 + C2,
      data = wideDF,
      n.adapt = 0,
      n.iter = 0,
      scale_vars = FALSE,
      monitor_params = monitor_params,
      mess = FALSE
    )$mcmc_settings$variable.names
  }

  # the example from the issue
  vn <- fit(c(analysis_main = TRUE, other = "tau_y"))
  expect_setequal(vn, c("beta", "sigma_y", "tau_y"))
  expect_identical(vn, fit(list(analysis_main = TRUE, other = "tau_y")))

  # imputed values (C2 has missing values)
  vn <- fit(c(imps = TRUE, other = "tau_y"))
  expect_true(any(grepl("^M_lvlone\\[", vn)))
  expect_identical(vn, fit(list(imps = TRUE, other = "tau_y")))

  # "TRUE" without other parameters
  expect_identical(fit(c(analysis_main = "TRUE")), fit(c(analysis_main = TRUE)))

  # a misspelled parameter group gives a clear error
  expect_error(fit(c(analysis_mian = TRUE)), "\"analysis_mian\"")
})

test_that("elements of beta in `other` are handled for c() and list()", {
  # with scaled covariates, single elements of beta are replaced by all betas
  # (a message); this rewrites monitor_params before get_params() is called
  fit <- function(monitor_params) {
    lm_imp(
      y ~ C1 + C2,
      data = wideDF,
      n.adapt = 0,
      n.iter = 0,
      monitor_params = monitor_params,
      mess = FALSE
    )$mcmc_settings$variable.names
  }
  vn <- fit(c(analysis_main = FALSE, other = c("beta[2]", "tau_y")))
  expect_true("beta" %in% vn)
  expect_true("tau_y" %in% vn)
  expect_false("sigma_y" %in% vn)
  expect_identical(
    vn,
    fit(list(analysis_main = FALSE, other = c("beta[2]", "tau_y")))
  )
})

test_that("add_samples() monitors the same parameters for c() and list()", {
  skip_if_not_installed("rjags")
  mod <- lm_imp(
    y ~ C1 + C2,
    data = wideDF,
    n.adapt = 5,
    n.iter = 0,
    scale_vars = FALSE,
    seed = 2020,
    mess = FALSE
  )
  add <- function(monitor_params) {
    add_samples(
      mod,
      n.iter = 2,
      add = FALSE,
      monitor_params = monitor_params,
      progress.bar = "none",
      mess = FALSE
    )
  }

  res_c <- add(c(analysis_main = TRUE, other = "tau_y"))
  res_list <- add(list(analysis_main = TRUE, other = "tau_y"))
  expect_setequal(
    res_c$mcmc_settings$variable.names,
    c("beta", "sigma_y", "tau_y")
  )
  expect_identical(
    res_c$mcmc_settings$variable.names,
    res_list$mcmc_settings$variable.names
  )
  expect_true("tau_y" %in% colnames(res_c$MCMC[[1]]))

  expect_error(add(c(analysis_mian = TRUE)), "\"analysis_mian\"")
})
