# Plots and MCMC diagnostics, tested on stored fixtures and the example data
# (no JAGS run). The plots are drawn on a null device (setup-graphics.R). As
# decided for the plots, the tests check the preparation of the plots (the
# data of ggplot objects, the panels, the restored graphics parameters) and
# the error messages, not the images. Fixtures and helpers: helper-fixtures.R.

skip_on_cran()

fixture_names <- names(fixture_cases())

# graphics parameters must be restored after a base plot
expect_par_restored <- function(code) {
  before <- graphics::par("mfrow", "mar", "mgp")
  force(code)
  expect_identical(graphics::par("mfrow", "mar", "mgp"), before)
}

# traceplot() and densplot() ----------------------------------------------------
test_that("traceplot() and densplot() work for all fixtures (base graphics)", {
  for (k in fixture_names) {
    object <- fixture_load(k)
    expect_par_restored(expect_no_error(traceplot(object), message = k))
    expect_par_restored(expect_no_error(densplot(object), message = k))
  }
})

test_that("traceplot() with ggplot: one panel per parameter, one line per chain", {
  skip_if_not_installed("ggplot2")
  for (k in fixture_names) {
    object <- fixture_load(k)
    prep <- plot_prep(object, subset = c(analysis_main = TRUE))
    p <- traceplot(object, use_ggplot = TRUE)

    expect_s3_class(p, "ggplot")
    expect_setequal(
      as.character(unique(p$data$variable)),
      colnames(prep$MCMC[[1]])
    )
    expect_identical(nlevels(p$data$chain), coda::nchain(object$MCMC))
    expect_identical(
      nrow(p$data),
      coda::niter(prep$MCMC) * coda::nvar(prep$MCMC) * coda::nchain(prep$MCMC)
    )
  }
})

test_that("densplot() with ggplot: panels named by variable, chains joined", {
  skip_if_not_installed("ggplot2")
  object <- fixture_load("lm")
  prep <- plot_prep(object, subset = c(analysis_main = TRUE))
  plotnams <- get_plotmain(object, colnames(prep$MCMC[[1]]))

  p <- densplot(object, use_ggplot = TRUE)
  expect_s3_class(p, "ggplot")
  expect_setequal(as.character(unique(p$data$variable)), plotnams)
  expect_identical(nlevels(p$data$chain), coda::nchain(object$MCMC))

  p <- densplot(object, use_ggplot = TRUE, joined = TRUE)
  expect_identical(nlevels(p$data$chain), 1L)
  expect_identical(
    nrow(p$data),
    coda::niter(prep$MCMC) * coda::nchain(prep$MCMC) * length(plotnams)
  )
})

test_that("traceplot() and densplot() arguments are used", {
  skip_if_not_installed("ggplot2")
  object <- fixture_load("lme")

  # selected iterations and chains
  p <- traceplot(
    object,
    start = 111,
    end = 130,
    thin = 2,
    exclude_chains = 2,
    use_ggplot = TRUE
  )
  expect_identical(nlevels(p$data$chain), 1L)
  expect_identical(length(unique(p$data$iteration)), 10L)

  # number of rows and columns of panels
  p <- traceplot(object, ncol = 2, use_ggplot = TRUE)
  expect_identical(p$facet$params$ncol, 2)

  # vertical lines in density plots (one value per parameter, or a list)
  n <- coda::nvar(plot_prep(object, subset = c(analysis_main = TRUE))$MCMC)
  expect_no_error(densplot(object, vlines = list(v = rep(0, n), lty = 2)))
  expect_no_error(densplot(
    object,
    vlines = list(list(v = rep(0, n)), list(v = rep(1, n), col = 2))
  ))
  expect_no_error(densplot(object, col = c("red", "blue"), lwd = 2))
})

test_that("traceplot() and densplot() for selected outcomes and parameters", {
  object <- fixture_load("jm")
  for (outcome in seq_along(object$fixed)) {
    expect_no_error(traceplot(object, outcome = outcome))
  }
  expect_no_error(densplot(object, subset = c(analysis_random = TRUE)))
})

test_that("traceplot() and densplot() of an mcmc.list", {
  mcmc <- fixture_load("lm")$MCMC
  expect_par_restored(expect_no_error(traceplot(mcmc)))
  expect_no_error(densplot(mcmc, start = 111, end = 130, thin = 2))
})

test_that("traceplot() and densplot() need an MCMC sample", {
  object <- fixture_load("lm")
  object$MCMC <- NULL
  expect_error(traceplot(object), "There is no MCMC sample")
  expect_error(densplot(object), "There is no MCMC sample")
})

# other plots of fitted models ---------------------------------------------------
test_that("plot() of the Monte Carlo error", {
  for (k in fixture_names) {
    mce <- MC_error(fixture_load(k))
    expect_no_error(plot(mce))
  }
  # the sampling scale is only available with keep_scaled_mcmc = TRUE (not
  # used for the fixtures); the error message is not informative yet
  expect_error(suppressWarnings(plot(mce, data_scale = FALSE)))
  expect_no_error(plot(
    MC_error(fixture_load("lm")),
    plotpars = list(xlab = "MCE / SD", xlim = c(0, 1), yaxt = "s"),
    ablinepars = list(v = 0.1, lty = 2)
  ))
})

test_that("plot() of a fitted model: residuals vs fitted values", {
  expect_no_error(plot(fixture_load("lm")))
  expect_no_error(plot(fixture_load("glm_binomial")))
  expect_error(plot(fixture_load("clm_nonprop")), "no.*plotting method")
  expect_error(plot(fixture_load("jm")), "plotting method")
})

test_that("plot_imp_distr() of imputed data", {
  skip_if_not_installed("foreign")
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("ggpubr")
  impDF <- get_MIdat(fixture_load("lm"), m = 2, seed = 2020)
  expect_s3_class(plot_imp_distr(impDF, ncol = 3), "ggplot")

  impDF <- get_MIdat(fixture_load("lme"), m = 2, seed = 2020)
  expect_s3_class(plot_imp_distr(impDF, id = "id", nrow = 2), "ggplot")
})

# plots of the data --------------------------------------------------------------
test_that("plot_all() plots all variables", {
  expect_par_restored(expect_no_error(plot_all(wideDF)))
  expect_par_restored(expect_no_error(
    plot_all(longDF, idvars = "id", ncol = 5, breaks = 20, allNA = TRUE)
  ))
  # dates and logical variables
  df <- wideDF[, c("C1", "B1")]
  df$date <- as.Date("2020-01-01") + seq_len(nrow(df))
  df$lgl <- df$C1 > 0
  expect_no_error(plot_all(df, nrow = 2))
})

test_that("md_pattern() gives the missing data patterns", {
  pat <- md_pattern(wideDF, plot = FALSE, pattern = TRUE)
  npat <- nrow(pat) - 1L
  vars <- setdiff(colnames(pat), "Npat")

  # all columns, one row per pattern, number of rows per pattern
  expect_setequal(vars, names(wideDF))
  expect_identical(npat, nrow(unique(is.na(wideDF))))
  expect_equal(sum(pat[seq_len(npat), "Npat"]), nrow(wideDF))
  # last row: number of missing values per variable (sorted), and in total
  expect_equal(pat["Nmis", vars], colSums(is.na(wideDF))[vars])
  expect_false(is.unsorted(pat["Nmis", vars]))
  expect_equal(pat["Nmis", "Npat"], sum(is.na(wideDF)))
  # patterns sorted by frequency
  expect_false(is.unsorted(rev(pat[seq_len(npat), "Npat"])))

  pat <- md_pattern(wideDF, plot = FALSE, pattern = TRUE, sort_columns = FALSE)
  expect_identical(setdiff(colnames(pat), "Npat"), names(wideDF))
})

test_that("md_pattern() plots the missing data patterns", {
  skip_if_not_installed("ggplot2")
  expect_s3_class(md_pattern(wideDF), "ggplot")
  res <- md_pattern(
    wideDF,
    pattern = TRUE,
    print_xaxis = FALSE,
    print_yaxis = FALSE
  )
  expect_named(res, c("plot", "pattern"))
  expect_s3_class(res$plot, "ggplot")
})

# auto- and cross-correlation -----------------------------------------------------
test_that("auto_corr() per chain and for all chains", {
  object <- fixture_load("lm")
  coefs <- object$coef_list$y

  ac <- auto_corr(object, lags = 0:5)
  expect_length(ac, coda::nchain(object$MCMC))
  expect_identical(dim(ac[[1]]), c(6L, coda::nvar(object$MCMC)))
  expect_identical(rownames(ac[[1]]), paste("Lag", 0:5))
  # regression coefficients are named by variable (other parameters, e.g.
  # imputed values that do not vary, may have NaN)
  expect_true(all(coefs$varnam_print %in% colnames(ac[[1]])))
  expect_equal(
    unname(ac[[1]]["Lag 0", coefs$varnam_print]),
    rep(1, nrow(coefs))
  )

  ac <- auto_corr(object, lags = 0:5, by_chain = FALSE, start = 111, thin = 2)
  expect_true(is.matrix(ac))
  expect_identical(dim(ac), c(6L, coda::nvar(object$MCMC)))
})

test_that("auto_corr_plot() per chain and for all chains", {
  skip_if_not_installed("ggplot2")
  object <- fixture_load("lm")
  expect_s3_class(auto_corr_plot(object, lags = 0:5), "ggplot")
  expect_s3_class(
    auto_corr_plot(object, lags = 0:5, by_chain = FALSE),
    "ggplot"
  )
})

test_that("cross_corr() gives a correlation matrix of all parameters", {
  object <- fixture_load("lme")
  cc <- cross_corr(object)
  n <- coda::nvar(object$MCMC)
  expect_identical(dim(cc), c(n, n))
  expect_equal(unname(diag(cc)), rep(1, n))
  expect_equal(cc, t(cc))
  expect_true(all(object$coef_list$y$varnam_print %in% colnames(cc)))
})

test_that("cross_corr_plot() with corrplot and coda", {
  object <- fixture_load("glm_binomial")
  if (requireNamespace("corrplot", quietly = TRUE)) {
    expect_no_error(cross_corr_plot(object))
  }
  expect_no_error(cross_corr_plot(object, type = "coda", start = 111))
})

test_that("auto- and cross-correlation need a JointAI object with MCMC sample", {
  object <- fixture_load("lm")
  for (fun in list(auto_corr, auto_corr_plot, cross_corr, cross_corr_plot)) {
    expect_error(fun(object$MCMC), "must be of class 'JointAI'")
  }
  object$MCMC <- NULL
  for (fun in list(auto_corr, cross_corr, cross_corr_plot)) {
    expect_error(fun(object), "There is no MCMC sample")
  }
})
