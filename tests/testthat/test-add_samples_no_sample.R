# add_samples() on a model that was adapted, but has no MCMC sample yet: there is
# nothing to add the new samples to, so they are the sample of the new object.

fit_without_sample <- function() {
  lm_imp(
    y ~ C1 + C2,
    data = wideDF,
    n.adapt = 10L,
    n.iter = 0L,
    n.chains = 2L,
    seed = 2026L,
    progress.bar = "none",
    mess = FALSE,
    warn = FALSE
  )
}

test_that("add = TRUE works for a model without sample", {
  old <- fit_without_sample()
  expect_null(old$MCMC)

  new <- add_samples(old, n.iter = 10L, progress.bar = "none", mess = FALSE)

  expect_s3_class(new, "JointAI")
  expect_s3_class(new$MCMC, "mcmc.list")
  expect_equal(coda::nchain(new$MCMC), 2L)
  expect_equal(coda::niter(new$MCMC), 10L)
  expect_setequal(
    coda::varnames(new$MCMC),
    c(paste0("beta[", 1:3, "]"), "sigma_y")
  )
})

test_that("samples can be added after the first sample was created", {
  old <- fit_without_sample()
  first <- add_samples(old, n.iter = 10L, progress.bar = "none", mess = FALSE)
  second <- add_samples(
    first,
    n.iter = 10L,
    progress.bar = "none",
    mess = FALSE
  )

  expect_equal(coda::niter(second$MCMC), 20L)
  expect_equal(
    as.matrix(second$MCMC[[1L]])[1:10, ],
    as.matrix(first$MCMC[[1L]]),
    ignore_attr = TRUE
  )
})

# keep_scaled_mcmc -------------------------------------------------------------

fit_keep_scaled <- function(n.iter, keep_scaled_mcmc = TRUE, thin = 1L) {
  lm_imp(
    y ~ C1 + C2,
    data = wideDF,
    n.adapt = 10L,
    n.iter = n.iter,
    thin = thin,
    n.chains = 1L,
    seed = 2026L,
    keep_scaled_mcmc = keep_scaled_mcmc,
    progress.bar = "none",
    mess = FALSE,
    warn = FALSE
  )
}

for (add in c(TRUE, FALSE)) {
  test_that(paste("keep_scaled_mcmc is respected without sample, add =", add), {
    old <- fit_keep_scaled(n.iter = 0L)
    expect_null(old$sample)

    new <- add_samples(
      old,
      n.iter = 10L,
      add = add,
      progress.bar = "none",
      mess = FALSE
    )

    expect_s3_class(new$sample, "mcmc.list")
    expect_equal(coda::niter(new$sample), 10L)
    expect_setequal(coda::varnames(new$sample), coda::varnames(new$MCMC))
    # the kept sample is on the scale used in JAGS, not on the scale of the data
    expect_false(isTRUE(all.equal(
      as.matrix(new$sample[[1L]]),
      as.matrix(new$MCMC[[1L]])
    )))
  })
}

test_that("the setting is still respected when samples are added again", {
  old <- fit_keep_scaled(n.iter = 0L)
  first <- add_samples(old, n.iter = 10L, progress.bar = "none", mess = FALSE)
  second <- add_samples(
    first,
    n.iter = 10L,
    progress.bar = "none",
    mess = FALSE
  )

  expect_equal(coda::niter(second$sample), 20L)
})

test_that("no scaled sample is kept without keep_scaled_mcmc", {
  old <- fit_keep_scaled(n.iter = 0L, keep_scaled_mcmc = FALSE)
  new <- add_samples(old, n.iter = 10L, progress.bar = "none", mess = FALSE)

  expect_null(new$sample)
})

test_that("the setting is only stored if a scaled sample is requested", {
  # (the objects of all other models stay as they are)
  fit <- fit_keep_scaled(n.iter = 0L, keep_scaled_mcmc = FALSE)
  expect_false("keep_scaled_mcmc" %in% names(fit$mcmc_settings))
})

test_that("samples are added to a scaled sample with thinning", {
  old <- fit_keep_scaled(n.iter = 10L, thin = 2L)
  new <- add_samples(old, n.iter = 10L, progress.bar = "none", mess = FALSE)

  expect_equal(coda::niter(new$sample), 10L)
  expect_equal(coda::thin(new$sample), 2L)
  expect_equal(attr(new$sample[[1L]], "mcpar"), attr(new$MCMC[[1L]], "mcpar"))
})

# no JAGS model ----------------------------------------------------------------

test_that("informative error without JAGS model", {
  no_sample <- lm_imp(
    y ~ C1,
    data = wideDF,
    n.adapt = 0L,
    n.iter = 0L,
    mess = FALSE
  )
  with_sample <- lm_imp(
    y ~ C1,
    data = wideDF,
    n.adapt = 0L,
    n.iter = 5L,
    n.chains = 1L,
    seed = 2026L,
    progress.bar = "none",
    mess = FALSE,
    warn = FALSE
  )

  expect_error(add_samples(no_sample, n.iter = 5L), "JAGS model")
  expect_error(add_samples(with_sample, n.iter = 5L), "JAGS model")
})
