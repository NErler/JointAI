# The argument `subset` of the output functions (summary(), coef(), confint(),
# traceplot(), densplot(), GR_crit(), MC_error()) follows `monitor_params`.
# Combined with c(), logical values become character strings ("FALSE"), and
# several parameter names in `other` get the names other1, other2, ... . Both
# forms must select the same parameters (as for `monitor_params`, #114).
# Tested on the stored fixture of a linear model, which monitors the main
# parameters, the parameters of the covariate models and the imputed values.

skip_on_cran()

object <- fixture_load("lm")

# the selected columns of the MCMC sample
subset_names <- function(subset) {
  colnames(get_subset(object, subset, mess = FALSE)[[1L]])
}

test_that("get_subset() selects the same parameters for c() and list()", {
  specs <- list(
    list(analysis_main = FALSE, other = "beta[2]"),
    list(analysis_main = FALSE, other = c("beta[2]", "sigma_y")),
    list(analysis_main = FALSE, other_models = TRUE),
    list(analysis_main = FALSE, other_models = TRUE, other = "sigma_y"),
    list(analysis_main = FALSE, imps = TRUE, other = "sigma_y"),
    list(analysis_main = TRUE, other = c("alpha[1]", "alpha[2]"))
  )
  for (spec in specs) {
    expect_identical(
      subset_names(do.call(c, spec)),
      subset_names(spec),
      info = deparse(spec)
    )
  }
})

test_that("main parameters are excluded with c(analysis_main = FALSE, ...)", {
  expect_identical(
    subset_names(c(analysis_main = FALSE, other = "beta[2]")),
    "beta[2]"
  )

  nams <- subset_names(c(analysis_main = FALSE, imps = TRUE, other = "sigma_y"))
  expect_true("sigma_y" %in% nams)
  expect_true(all(grepl("^M_lvlone\\[", setdiff(nams, "sigma_y"))))
  expect_false(any(grepl("^beta", nams)))
})

test_that("the default and FALSE are unchanged", {
  # default: the parameters of the analysis model
  nams <- subset_names(NULL)
  expect_true(all(grepl("^beta\\[|^sigma_y$", nams)))
  expect_identical(nams, subset_names(c(analysis_main = TRUE)))
  # FALSE: all monitored nodes
  expect_identical(subset_names(FALSE), colnames(object$MCMC[[1L]]))
})

test_that("wrong specifications of `subset` give an informative error", {
  err <- gsub(
    "\\s+",
    " ",
    tryCatch(
      subset_names(c(analysis_mian = FALSE)),
      error = conditionMessage
    )
  )
  expect_match(err, "\"analysis_mian\" in \"subset\" is not a known")

  err <- gsub(
    "\\s+",
    " ",
    tryCatch(
      subset_names(c(analysis_main = FALSE, imps = "sigma_y")),
      error = conditionMessage
    )
  )
  expect_match(err, "value of \"imps\" in \"subset\" must be TRUE or FALSE")
})

test_that("the output functions select the same parameters for c() and list()", {
  # main parameters excluded, a single coefficient selected
  spec <- list(analysis_main = FALSE, other = "beta[2]")
  spec_c <- do.call(c, spec)

  expect_identical(coef(object, subset = spec_c), coef(object, subset = spec))
  expect_named(coef(object, subset = spec_c)$y, "C1")
  expect_identical(
    confint(object, subset = spec_c),
    confint(object, subset = spec)
  )
  expect_identical(
    GR_crit(object, subset = spec_c),
    GR_crit(object, subset = spec)
  )
  # traceplot() and densplot()
  expect_identical(
    plot_prep(object, subset = spec_c, mess = FALSE)$MCMC,
    plot_prep(object, subset = spec, mess = FALSE)$MCMC
  )

  # covariate models and a single parameter of the analysis model
  spec <- list(analysis_main = FALSE, other_models = TRUE, other = "sigma_y")
  spec_c <- do.call(c, spec)
  expect_identical(
    summary(object, subset = spec_c)$res,
    summary(object, subset = spec)$res
  )
  capture.output(
    mce_c <- MC_error(object, subset = spec_c, mess = FALSE),
    mce <- MC_error(object, subset = spec, mess = FALSE)
  )
  expect_identical(mce_c, mce)
  # the coefficients of the analysis model have no prefix, those of the
  # covariate models are named "<outcome>: <term>"
  nams <- rownames(mce$data_scale)
  expect_true("sigma_y" %in% nams)
  expect_false(any(c("(Intercept)", "C1") %in% nams))
})
