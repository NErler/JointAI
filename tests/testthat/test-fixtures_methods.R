# S3 methods and small exported functions for fitted models, tested on stored
# fixtures (no JAGS run). Fixtures and helpers: helper-fixtures.R.

skip_on_cran()

test_that("formula() returns the model formula(s)", {
  for (k in names(fixture_cases())) {
    object <- fixture_load(k)
    expect_identical(formula(object), object$formula, label = k)
  }
  expect_s3_class(formula(fixture_load("lm")), "formula")
  expect_type(formula(fixture_load("jm")), "list")
  expect_error(formula.JointAI(list()), "Use only")
})

test_that("family() returns the family of the analysis model", {
  fam <- family(fixture_load("glm_binomial"))
  expect_s3_class(fam, "family")
  expect_identical(c(fam$family, fam$link), c("binomial", "logit"))
  expect_identical(family(fixture_load("lm"))$family, "gaussian")
  # no family for ordinal and survival models
  expect_null(family(fixture_load("clm_nonprop")))
  expect_null(family(fixture_load("coxph")))
})

test_that("predDF() for a formula gives the same data as for the model", {
  object <- fixture_load("lm")
  expected <- predDF(object, vars = ~C1)
  expect_identical(
    predDF(formula(object), data = object$data, vars = ~C1),
    expected
  )
  expect_identical(nrow(expected), 100L)
  expect_identical(
    range(expected$C1),
    range(object$data$C1, na.rm = TRUE)
  )
  expect_error(predDF.formula(list(), vars = ~C1), "Use only with 'formula'")
})

test_that("sum_duration() of a fitted model", {
  object <- fixture_load("lm")
  dur <- object$comp_info$duration
  total <- sum_duration(object)

  expect_s3_class(total, "difftime")
  expect_equal(
    as.numeric(total),
    as.numeric(dur$adapt$total + dur$sample$total)
  )

  phase <- sum_duration(object, by = "phase")
  expect_named(phase, c("adapt", "sample"))
  expect_equal(as.numeric(phase$adapt + phase$sample), as.numeric(total))
  for (by in c("run", "chain")) {
    expect_equal(
      as.numeric(sum(sum_duration(object, by = by))),
      as.numeric(total),
      label = by
    )
  }
})

test_that("rd_vcov() includes monitored covariate models with random effects", {
  # fixture lme monitors the random-effects covariance matrices of the
  # analysis model (y) and of the covariate models (b2, c2)
  object <- fixture_load("lme")
  vcov <- rd_vcov(object, mess = FALSE, warn = FALSE)
  expect_named(vcov, c("y", "b2", "c2"))

  MCMC <- do.call(rbind, object$MCMC)
  for (k in names(vcov)) {
    D <- vcov[[k]]$id
    expect_s3_class(D, "Dmat")
    expect_equal(D[1L, 1L], mean(MCMC[, paste0("D_", k, "_id[1,1]")]))
  }
  expect_equal(dim(vcov$y$id), c(2L, 2L))
  expect_equal(vcov$y$id[1L, 2L], vcov$y$id[2L, 1L])
  expect_equal(vcov$y$id[1L, 2L], mean(MCMC[, "D_y_id[1,2]"]))
})
