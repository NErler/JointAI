context("CLMM Models")
library("JointAI")


run_clmm_models <- function() {
  cat('\nRunning clmm models...\n')
  sink(tempfile())
  on.exit(sink())
  invisible(force(suppressWarnings({

    models <- list(

      # no covariates
      m0a = clmm_imp(o1 ~ 1 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m0b = clmm_imp(o2 ~ 1 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      # only complete
      m1a = clmm_imp(o1 ~ C1 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m1b = clmm_imp(o2 ~ C1 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m1c = clmm_imp(o1 ~ c1 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m1d = clmm_imp(o2 ~ c1 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      # only incomplete
      m2a = clmm_imp(o1 ~ C2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m2b = clmm_imp(o2 ~ C2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m2c = clmm_imp(o1 ~ c2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m2d = clmm_imp(o2 ~ c2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      # as covariate
      m3a = lme_imp(c1 ~ o1 + (1 | id), data = longDF,
                    n.adapt = 5, n.iter = 10, seed = 2020),
      m3b = lme_imp(c1 ~ o2 + (1 | id), data = longDF,
                    n.adapt = 5, n.iter = 10, seed = 2020),


      # complex structures
      m4a = clmm_imp(o1 ~ M2 + o2 * abs(C1 - C2) + log(C1) + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m4b = clmm_imp(o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) *
                       abs(C1 - C2) + log(C1) + (1 | id),
                     data = longDF, warn = FALSE,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m4c = clmm_imp(o1 ~ time + c1 + C1 + B2 + (c1 * time | id),
                     data = longDF, warn = FALSE,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m4d = clmm_imp(o1 ~ C1 * time + I(time^2) + b2 * c1,
                     random = ~ time | id, data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m4e = clmm_imp(o1 ~ C1 + log(time) + I(time^2) + p1,
                     random = ~ 1 | id, data = longDF,
                     n.adapt = 5, n.iter = 10, shrinkage = "ridge",
                     parallel = TRUE, n.cores = 2, seed = 2020),



      # non-proportional effects
      # - basic model
      m5a = clmm_imp(o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020,
                     nonprop = list(o1 = ~ C1 + C2 + b2),
                     monitor_params = list(other = "p_o1")),

      # - interaction in prop. effects
      m5b = clmm_imp(o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020,
                     nonprop = list(o1 = ~ c1 + C2),
                     monitor_params = list(other = "p_o1")),

      # - interaction in non-prop effects
      m5c = clmm_imp(o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020,
                     nonprop = list(o1 = ~ c1 * C2),
                     monitor_params = list(other = "p_o1")),

      # - interaction between non-prop and prop effects
      m5d = clmm_imp(o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020,
                     nonprop = list(o1 = ~ c1 + C2),
                     monitor_params = list(other = "p_o1")),

      # - all effects non-proportional
      m5e = clmm_imp(o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF,
                     n.adapt = 5, n.iter = 10, seed = 2020,
                     nonprop = ~ c1 + M2 * C2 + O2,
                     monitor_params = list(other = "p_o1"))
    )

    models$m6a <- update(models$m5a, rev = "o1")
    models$m6b <- update(models$m5b, rev = "o1")
    models$m6c <- update(models$m5c, rev = "o1")
    models$m6d <- update(models$m5d, rev = "o1")
    models$m6e <- update(models$m5e, rev = "o1")
  }
  )
  ))
  models
}

models <- run_clmm_models()

# models <- list(m0a, m0b, m1a, m1b, m1c, m1d, m2a, m2b, m2c, m2d,
#                cov1 = m3a, cov2 = m3b, m4a, m4b, m4c, m4d, m4e,
#                m5a, m5b, m5c, m5d, m5e,
#                m6a, m6b, m6c, m6d, m6e)


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


test_that("summary output remained the same on Windows", {
  skip_on_os(c("mac", "linux", "solaris"))
  expect_snapshot_output(lapply(models, print))
  expect_snapshot_output(lapply(models, coef))
  expect_snapshot_output(lapply(models, confint))
  expect_snapshot_output(lapply(models, summary))
  expect_snapshot_output(lapply(models, function(x) coef(summary(x))))
})

# test_that("summary output remained the same on non-Windows", {
#   skip_on_os(c("windows"))
#   expect_snapshot_output(lapply(models, print))
#   expect_snapshot_output(lapply(models, coef))
#   expect_snapshot_output(lapply(models, confint))
#   expect_snapshot_output(lapply(models, summary))
#   expect_snapshot_output(lapply(models, function(x) coef(summary(x))))
# })


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

  # expect_equal(check_predprob(m5a), 0)
  # expect_equal(check_predprob(m5b), 0)
  # expect_equal(check_predprob(m5c), 0)
  # expect_equal(check_predprob(m5d), 0)
  # expect_equal(check_predprob(m5e), 0)
  #
  # expect_equal(check_predprob(m6a), 0)
  # expect_equal(check_predprob(m6b), 0)
  # expect_equal(check_predprob(m6c), 0)
  # expect_equal(check_predprob(m6d), 0)
  # expect_equal(check_predprob(m6e), 0)
})



test_that("residuals work if implemented", {
  # residuals are not yet implemented
  expect_error(residuals(models$m4a, type = "working"))
})



test_that("model can be plottet", {
  for (i in seq_along(models)) {
    if (models[[i]]$analysis_type == "clmm") {
      expect_error(plot(models[[i]]))
    } else {
      expect_silent(plot(models[[i]]))
    }
  }
})


test_that("wrong models give errors", {
  # wrong type of outcome variable
  expect_error(clmm_imp(y ~ O1 + C1 + C2 + (1 | id), data = longDF))
  # wrong model function used
  expect_error(clm_imp(o2 ~ O1 + C1 + C2 + (1 | id), data = longDF,
                       warn = FALSE))
  # variable not in data
  expect_error(clmm_imp(o2 ~ O1 + C1 + C2 + (1 | id), data = wideDF))
  # model formula that can't be used
  expect_s3_class(clmm_imp(o2 ~ I(O1^2) + C1 + C2 + (1 | id), warn = FALSE,
                           data = longDF), "JointAI_errored")
  # non-proportional effect not in main formula
  expect_error(clmm_imp(o2 ~ O1 + C1 + (1 | id), data = longDF,
                        nonprop = list(o2 = ~ C2)))
})
