context("CLM Models")
library("JointAI")


run_clm_models <- function() {
  cat('\nRunning clm models...\n')
  sink(tempfile())
  on.exit(sink())
  invisible(force(suppressWarnings({

    models <- list(
      # no covariates
      m0a = clm_imp(O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m0b = clm_imp(O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),

      # only complete
      m1a = clm_imp(O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m1b = clm_imp(O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),

      # only incomplete
      m2a = clm_imp(O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m2b = clm_imp(O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),

      # as covariate
      m3a = lm_imp(C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m3b = lm_imp(C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),


      # complex structures
      m4a = clm_imp(O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020),
      m4b = clm_imp(O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) *
                      abs(C1 - C2) + log(C1), data = wideDF, warn = FALSE,
                    n.adapt = 5, n.iter = 10, seed = 2020),

      # non-proportional effects
      # - basic model
      m5a = clm_imp(O1 ~ C1 + C2 + M2 + O2, data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    nonprop = list(O1 = ~ C1 + C2),
                    monitor_params = list(other = "p_O1")),

      # - interaction in prop. effects
      m5b = clm_imp(O1 ~ C1 * C2 + M2 + O2, data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    nonprop = list(O1 = ~ C1 + C2),
                    monitor_params = list(other = "p_O1")),

      # - interaction in non-prop effects
      m5c = clm_imp(O1 ~ C1 * C2 + M2 + O2, data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    nonprop = list(O1 = ~ C1 * C2),
                    monitor_params = list(other = "p_O1")),

      # - interaction between non-prop and prop effects
      m5d = clm_imp(O1 ~ C1 + M2 * C2 + O2, data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    nonprop = list(O1 = ~ C1 + C2),
                    monitor_params = list(other = "p_O1")),

      # - all effects non-proportional
      m5e = clm_imp(O1 ~ C1 + M2 * C2 + O2, data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    nonprop = ~ C1 + M2 * C2 + O2,
                    monitor_params = list(other = "p_O1"))
    )

    models$m6a <- update(models$m5a, rev = "O1")
    models$m6b <- update(models$m5b, rev = "O1")
    models$m6c <- update(models$m5c, rev = "O1")
    models$m6d <- update(models$m5d, rev = "O1")
    models$m6e <- update(models$m5e, rev = "O1")
  }
  )
  ))
  models
}

models <- run_clm_models()


test_that("models run", {
  for (k in seq_along(models)) {
    expect_s3_class(models[[k]], "JointAI")
  }
})


test_that("there are no duplicate betas/alphas in the JAGSmodel", {
  expect_null(unlist(lapply(models, find_dupl_parms)))
})


test_that("MCMC is mcmc.list", {
  for (i in seq_along(models)) {
    expect_s3_class(models[[i]]$MCMC, "mcmc.list")
  }
})

test_that("MCMC samples can be plottet", {
  for (k in seq_along(models)) {
    expect_silent(traceplot(models[[k]]))
    expect_silent(densplot(models[[k]]))
    expect_silent(plot(MC_error(models[[k]])))
  }
})

test_that("GRcrit and MCerror give same result", {
  expect_snapshot_output(lapply(models, GR_crit, multivariate = FALSE))
  expect_snapshot_output(lapply(models, MC_error))
})


test_that("summary output remained the same", {
  expect_snapshot_output(lapply(models, print))
  expect_snapshot_output(lapply(models, coef))
  expect_snapshot_output(lapply(models, confint))
  expect_snapshot_output(lapply(models, summary))
  expect_snapshot_output(lapply(models, function(x) coef(summary(x))))
})


test_that("prediction works", {
  expect_is(predict(models$m4a, type = "lp")$fitted, "array")
  expect_is(predict(models$m4a, type = "prob", warn = FALSE)$fitted, "array")
  expect_s3_class(predict(models$m4a, type = "class", warn = FALSE)$fitted,
                  "data.frame")
  expect_s3_class(predict(models$m4a, type = "response", warn = FALSE)$fitted,
                  "data.frame")

  expect_s3_class(predict(models$m4a, type = "lp", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4a, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4a, type = "class", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4a, type = "response", warn = FALSE)$newdata,
                  "data.frame")

  expect_is(predict(models$m5d, type = "lp", warn = FALSE)$fitted, "array")
  expect_is(predict(models$m5d, type = "prob", warn = FALSE)$fitted, "array")
  expect_is(predict(models$m5d, type = "class", warn = FALSE)$fitted,
            "data.frame")
  expect_is(predict(models$m5d, type = "response", warn = FALSE)$fitted,
            "data.frame")

  expect_s3_class(predict(models$m5d, type = "lp", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m5d, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m5d, type = "class", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m5d, type = "response", warn = FALSE)$newdata,
                  "data.frame")


  expect_s3_class(predict(models$m5e, type = "prob", warn = FALSE)$newdata,
                  "data.frame")

  expect_equal(check_predprob(models$m5a), 0)
  expect_equal(check_predprob(models$m5b), 0)
  expect_equal(check_predprob(models$m5c), 0)
  expect_equal(check_predprob(models$m5d), 0)
  expect_equal(check_predprob(models$m5e), 0)

  expect_equal(check_predprob(models$m6a), 0)
  expect_equal(check_predprob(models$m6b), 0)
  expect_equal(check_predprob(models$m6c), 0)
  expect_equal(check_predprob(models$m6d), 0)
  expect_equal(check_predprob(models$m6e), 0)
})


test_that("residuals", {
  # residuals are not yet implemented
  expect_error(residuals(models$m4a, type = "working"))
})


test_that("model can be plottet", {
  for (i in seq_along(models)) {
    if (models[[i]]$analysis_type == "clm") {
      expect_error(plot(models[[i]]))
    } else {
      expect_silent(plot(models[[i]]))
    }
  }
})


test_that("wrong models give errors", {
  expect_error(clm_imp(y ~ O1 + C1 + C2, data = wideDF))
  expect_error(clm_imp(O2 ~ O1 + C1 + C2 + (1 | id), data = longDF))
  expect_error(clm_imp(O2 ~ O1 + C1 + C2 + (1 | id), data = wideDF))
  expect_s3_class(clm_imp(O2 ~ I(O1^2) + C1 + C2, data = wideDF),
                  "JointAI_errored")
  expect_error(clm_imp(O2 ~ O1 + C1, data = wideDF,
                       nonprop = list(O2 = ~ C2)))
})
