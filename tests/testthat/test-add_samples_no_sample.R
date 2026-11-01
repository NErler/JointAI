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
