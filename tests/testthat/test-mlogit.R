context("mlogit Models")
library("JointAI")


run_mlogit_models <- function() {
  cat('\nRunning mlogit models...\n')
  sink(tempfile())
  on.exit(sink())
  invisible(force(suppressWarnings({

    models <- list(
      # no covariates
      m0a = mlogit_imp(M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10,
                       seed = 2020),
      m0b = mlogit_imp(M2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10,
                       seed = 2020),

      # only complete
      m1a = mlogit_imp(M1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10,
                       seed = 2020),
      m1b = mlogit_imp(M2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10,
                       seed = 2020),

      # only incomplete
      m2a = mlogit_imp(M1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10,
                       seed = 2020),
      m2b = mlogit_imp(M2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10,
                       seed = 2020),

      # as covariate
      m3a = lm_imp(C1 ~ M1, data = wideDF, n.adapt = 5, n.iter = 10,
                   seed = 2020),
      m3b = lm_imp(C1 ~ M2, data = wideDF, n.adapt = 5, n.iter = 10,
                   seed = 2020),


      # complex structures
      m4a = mlogit_imp(M1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    monitor_params = list(other = "p_M1")),
      m4b = mlogit_imp(M1 ~ ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) *
                      abs(C1 - C2) + log(C1), data = wideDF, warn = FALSE,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    monitor_params = list(other = "p_M1"))
    )
  }
  )))
  models
}

models <- run_mlogit_models()


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
  skip_on_cran()
  expect_snapshot_output(lapply(models, GR_crit, multivariate = FALSE))
  expect_snapshot_output(lapply(models, MC_error))
})


test_that("summary output remained the same", {
  skip_on_cran()
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

  expect_is(predict(models$m4b, type = "lp")$fitted, "array")
  expect_is(predict(models$m4b, type = "prob", warn = FALSE)$fitted, "array")
  expect_s3_class(predict(models$m4b, type = "class", warn = FALSE)$fitted,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "response", warn = FALSE)$fitted,
                  "data.frame")

  expect_s3_class(predict(models$m4b, type = "lp", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "class", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "response", warn = FALSE)$newdata,
                  "data.frame")


  expect_equal(check_predprob(models$m4a), 0)
  expect_equal(check_predprob(models$m4b), 0)
})


test_that("residuals", {
  # residuals are not yet implemented
  expect_error(residuals(models$m4a, type = "working"))
})


test_that("model can be plottet", {
  for (i in seq_along(models)) {
    if (models[[i]]$analysis_type == "mlogit") {
      expect_error(plot(models[[i]]))
    } else {
      expect_silent(plot(models[[i]]))
    }
  }
})


test_that("wrong models give errors", {
  # wrong type of outcome
  expect_error(mlogit_imp(y ~ O1 + C1 + C2, data = wideDF))
  expect_error(mlogit_imp(B1 ~ O1 + C1 + C2, data = wideDF))

  # use of random effects structure
  expect_error(mlogit_imp(M1 ~ O1 + C1 + C2 + (1 | id), data = longDF))
  expect_error(mlogit_imp(M1 ~ O1 + C1 + C2 + (1 | id), data = wideDF))
})
