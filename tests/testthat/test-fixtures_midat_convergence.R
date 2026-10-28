# get_MIdat(), GR_crit(), MC_error() and the preparation of the MCMC sample
# for traceplot() and densplot() (plot_prep(), get_plotmain()), tested on
# stored fixtures (no JAGS run). The results themselves are compared with
# stored results in test-fixtures_summary.R (types "get_MIdat", "GR_crit",
# "MC_error" and "plot_titles" of fixture_results()); here: properties that
# must hold independently of the stored values, and the arguments. The plots
# themselves are not tested. Fixtures and helpers: helper-fixtures.R.

skip_on_cran()

# MCMC sample of all chains, as one matrix
combined <- function(mcmc) do.call(rbind, lapply(mcmc, as.matrix))


# get_MIdat() ------------------------------------------------------------------

# fixtures with monitored imputed values
for (k in c("lm", "lme")) {
  test_that(paste("get_MIdat() completes the data:", k), {
    object <- fixture_load(k)
    data <- object$data
    imp <- get_MIdat(object, m = 2, seed = 2020)

    expect_s3_class(imp, "data.frame")
    expect_equal(imp$Imputation_, rep(0:2, each = nrow(data)))
    expect_equal(imp$.rownr, rep(seq_len(nrow(data)), 3))
    # an id variable is only added for data without grouping
    expect_equal(".id" %in% names(imp), k == "lm")

    # imputation 0 is the original data
    expect_equal(
      imp[imp$Imputation_ == 0, names(data)],
      data,
      ignore_attr = "row.names"
    )

    imputed <- intersect(names(object$models), names(data))
    for (i in 1:2) {
      dat_i <- imp[imp$Imputation_ == i, names(data)]
      # observed values are unchanged, variable types and levels are kept
      for (v in names(data)) {
        obs <- !is.na(data[[v]])
        expect_equal(dat_i[[v]][obs], data[[v]][obs], label = v)
        expect_equal(class(dat_i[[v]]), class(data[[v]]), label = v)
        expect_equal(levels(dat_i[[v]]), levels(data[[v]]), label = v)
      }
      # the variables with a model have no missing values
      expect_false(anyNA(dat_i[imputed]))
    }
  })
}

test_that("get_MIdat(include = FALSE) leaves out the original data", {
  object <- fixture_load("lm")
  with_orig <- get_MIdat(object, m = 2, seed = 2020)
  imp <- get_MIdat(object, m = 2, seed = 2020, include = FALSE)
  expect_equal(
    imp,
    with_orig[with_orig$Imputation_ > 0, ],
    ignore_attr = "row.names"
  )
})

test_that("get_MIdat() uses the seed and restores the random state", {
  object <- fixture_load("lm")
  # minspace = 1: with the default, m = 2 always selects the same iterations
  # (an existing random state is needed to check that it is restored; the case
  # without one is tested in test-random_seed.R)
  set.seed(123)
  seed_before <- .Random.seed
  imp1 <- get_MIdat(object, m = 2, minspace = 1, seed = 1)
  expect_identical(.Random.seed, seed_before)
  expect_identical(get_MIdat(object, m = 2, minspace = 1, seed = 1), imp1)
  expect_false(identical(
    get_MIdat(object, m = 2, minspace = 1, seed = 2),
    imp1
  ))
})

test_that("get_MIdat() gives an error when it cannot select imputations", {
  object <- fixture_load("lm")
  expect_error(get_MIdat(object), "too small")
  expect_error(get_MIdat(object, m = 2, start = 140), "too small")
  object$MCMC <- NULL
  expect_error(get_MIdat(object, m = 2), "MCMC")
})

test_that("get_MIdat() exports the data to SPSS", {
  skip_if_not_installed("foreign")
  dir <- tempfile("midat")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE))
  imp <- get_MIdat(
    fixture_load("lm"),
    m = 2,
    seed = 2020,
    export_to_SPSS = TRUE,
    resdir = dir,
    filename = "imp"
  )
  expect_setequal(list.files(dir), c("imp.txt", "imp.sps"))
  expect_equal(length(readLines(file.path(dir, "imp.txt"))), nrow(imp))
})


# GR_crit() and MC_error() -----------------------------------------------------

for (k in names(fixture_cases())) {
  test_that(paste("GR_crit() and MC_error() have a row per node:", k), {
    object <- fixture_load(k)
    mcmc <- get_subset(object, subset = NULL, mess = FALSE)
    titles <- get_plotmain(object, colnames(mcmc[[1L]]), ylab = TRUE)

    gr <- suppressWarnings(GR_crit(object, warn = FALSE, mess = FALSE))
    expect_s3_class(gr, "gelman.diag")
    expect_equal(rownames(gr$psrf), titles)

    mce <- MC_error(object, warn = FALSE, mess = FALSE)
    expect_s3_class(mce, "MCElist")
    expect_named(mce, c("data_scale", "sampling_scale", "digits"))
    expect_equal(rownames(mce$data_scale), titles)
    expect_equal(colnames(mce$data_scale), c("est", "MCSE", "SD", "MCSE/SD"))
    # posterior mean and SD over all chains
    expect_equal(
      mce$data_scale[, "est"],
      colMeans(combined(mcmc)),
      ignore_attr = "names"
    )
    expect_equal(
      mce$data_scale[, "SD"],
      apply(combined(mcmc), 2, sd),
      ignore_attr = "names"
    )
    expect_equal(
      mce$data_scale[, "MCSE/SD"],
      mce$data_scale[, "MCSE"] / mce$data_scale[, "SD"]
    )
    # the scaled sample is not kept in the fixtures
    expect_null(mce$sampling_scale)
  })
}

test_that("MC_error() and GR_crit() use the selected chains and iterations", {
  object <- fixture_load("lm")
  mcmc <- get_subset(object, subset = NULL, mess = FALSE)

  mce <- MC_error(object, exclude_chains = 2, mess = FALSE)
  expect_equal(
    mce$data_scale[, "est"],
    colMeans(as.matrix(mcmc[[1L]])),
    ignore_attr = "names"
  )
  mce <- MC_error(object, start = 121, end = 140, thin = 2, mess = FALSE)
  expect_equal(
    mce$data_scale[, "est"],
    colMeans(combined(window(mcmc, start = 121, end = 140, thin = 2))),
    ignore_attr = "names"
  )

  # subset = FALSE: all monitored nodes (mcmcse prints a note for imputed
  # values that do not vary)
  capture.output(mce <- MC_error(object, subset = FALSE, mess = FALSE))
  expect_equal(nrow(mce$data_scale), ncol(object$MCMC[[1L]]))

  # the Gelman-Rubin criterion needs at least two chains
  expect_error(GR_crit(object, exclude_chains = 2, mess = FALSE))
  gr <- GR_crit(object, start = 121, autoburnin = FALSE, mess = FALSE)
  mcmc <- window(mcmc, start = 121)
  coda::varnames(mcmc) <- rownames(gr$psrf)
  expect_equal(gr, coda::gelman.diag(mcmc, autoburnin = FALSE))
})

test_that("GR_crit() and MC_error() give errors for unsuitable objects", {
  expect_error(GR_crit(list(a = 1)), "JointAI")
  expect_error(MC_error(list(a = 1)), "JointAI")
  object <- fixture_load("lm")
  object$MCMC <- NULL
  expect_error(GR_crit(object), "No MCMC sample")
  expect_error(MC_error(object), "No MCMC sample")
})

test_that("print.MCElist() prints the data-scale results", {
  mce <- MC_error(fixture_load("survreg"), mess = FALSE)
  expect_equal(
    capture.output(print(mce)),
    capture.output(print(mce$data_scale, digits = 2))
  )
})


# plot_prep() and get_plotmain() -----------------------------------------------

test_that("plot_prep() selects nodes, chains and iterations", {
  object <- fixture_load("lme")
  mcmc <- get_subset(object, subset = NULL, mess = FALSE)

  prep <- plot_prep(object, mess = FALSE)
  expect_named(prep, c("MCMC", "nrow", "ncol", "thin", "time", "subset"))
  expect_equal(prep$MCMC, mcmc)
  expect_equal(as.numeric(prep$time), 101:150)

  prep <- plot_prep(object, exclude_chains = 1, mess = FALSE)
  expect_equal(prep$MCMC, mcmc[2L])

  prep <- plot_prep(object, start = 111, end = 130, thin = 2, mess = FALSE)
  expect_equal(prep$MCMC, window(mcmc, start = 111, end = 130, thin = 2))
  expect_equal(as.numeric(prep$time), seq(111, 129, by = 2))
  expect_equal(prep$thin, 2)

  prep <- plot_prep(object, subset = FALSE, mess = FALSE)
  expect_equal(prep$MCMC, object$MCMC)

  object$MCMC <- NULL
  expect_error(plot_prep(object), "no MCMC sample")
})

test_that("plot_prep() arranges the plots in a grid", {
  object <- fixture_load("lme")
  # 10 nodes of the analysis model
  dims <- function(...) unlist(plot_prep(object, mess = FALSE, ...)[2:3])
  expect_equal(dims(), c(nrow = 4, ncol = 3))
  expect_equal(dims(ncol = 4), c(nrow = 3, ncol = 4))
  expect_equal(dims(nrow = 4), c(nrow = 4, ncol = 3))
  expect_equal(dims(nrow = 1, ncol = 2), c(nrow = 1, ncol = 2))
  # more than 36 nodes: at most 36 per page
  expect_equal(dims(subset = FALSE), c(nrow = 6, ncol = 6))
})

test_that("plot_prep(outcome = ) selects the nodes of one sub-model", {
  object <- fixture_load("jm")
  params <- parameters(object, expand_ranef = TRUE, mess = FALSE)
  for (i in 1:2) {
    outcome <- internal_clean_survname(names(object$fixed)[i])
    prep <- plot_prep(object, outcome = i, mess = FALSE)
    expect_setequal(
      colnames(prep$MCMC[[1L]]),
      params$coef[params$outcome %in% outcome]
    )
  }
})

test_that("get_plotmain() replaces coefficient names by variable names", {
  # one outcome (nodes of the analysis model): the variable name only
  object <- fixture_load("lme")
  nams <- colnames(get_subset(object, subset = NULL, mess = FALSE)[[1L]])
  coefs <- object$coef_list$y
  titles <- get_plotmain(object, nams)
  expect_equal(titles[match(coefs$coef, nams)], coefs$varnam_print)
  other <- !nams %in% unlist(lapply(object$coef_list, "[[", "coef"))
  expect_equal(titles[other], nams[other])

  # several outcomes: variable and outcome, in two lines or as one label
  object <- fixture_load("jm")
  coefs <- do.call(rbind, object$coef_list)
  nams <- coefs$coef
  expect_equal(
    get_plotmain(object, nams),
    paste0(coefs$varnam_print, "\n(", coefs$outcome, ")")
  )
  expect_equal(
    get_plotmain(object, nams, ylab = TRUE),
    paste0(coefs$outcome, ": ", coefs$varnam_print)
  )
})
