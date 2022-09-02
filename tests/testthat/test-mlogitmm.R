library("JointAI")

# Sys.setenv(IS_CHECK = "true")

skip_on_cran()

cat("ON CRAN:", testthat:::on_cran(), "\n")

set_seed(2020)
longDF$m1 <- factor(sample(c('A', 'B', 'C'), size = nrow(longDF),
                           replace = TRUE))
longDF$m2 <- factor(sample(c('A', 'B', 'C'), size = nrow(longDF),
                           replace = TRUE))

longDF$m2[sample.int(nrow(longDF), 50)] <- NA

run_mlogitmm_models <- function() {
  sink(tempfile())
  on.exit(sink())
  invisible(force(suppressWarnings({


    models <- list(

      # no covariates
      m0a = mlogitmm_imp(m1 ~ 1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m0b = mlogitmm_imp(m2 ~ 1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),

      # only complete
      m1a = mlogitmm_imp(m1 ~ C1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m1b = mlogitmm_imp(m2 ~ C1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m1c = mlogitmm_imp(m1 ~ c1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m1d = mlogitmm_imp(m2 ~ c1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),

      # only incomplete
      m2a = mlogitmm_imp(m1 ~ C2 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m2b = mlogitmm_imp(m2 ~ C2 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m2c = mlogitmm_imp(m1 ~ c2 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m2d = mlogitmm_imp(m2 ~ c2 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),

      # as covariate
      m3a = lme_imp(c1 ~ m1 + (1 | id), data = longDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    mess = FALSE, warn = FALSE),
      m3b = lme_imp(c1 ~ m2 + (1 | id), data = longDF,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    mess = FALSE, warn = FALSE),


      # complex structures
      m4a = mlogitmm_imp(m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + (1 | id),
                         data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),
      m4b = mlogitmm_imp(m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) *
                           abs(C1 - C2) + log(C1) + (1 | id),
                         data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),

      m4c = mlogitmm_imp(m1 ~ time + c1 + C1 + B2 + (c1 * time | id),
                         data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),

      m4d = mlogitmm_imp(m1 ~ C1 * time + I(time^2) + b2 * c1,
                         random = ~ time | id, data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         mess = FALSE, warn = FALSE),

      m4e = mlogitmm_imp(m1 ~ C1 + log(time) + I(time^2) + p1,
                         random = ~ 1 | id, data = longDF,
                         n.adapt = 5, n.iter = 10, shrinkage = "ridge",
                         seed = 2020, mess = FALSE, warn = FALSE)
    )
  }
  )))
  models
}

models <- run_mlogitmm_models()
models0 <- set0_list(models)


test_that("models run", {
  for (k in seq_along(models)) {
    expect_s3_class(models[[k]], "JointAI")
  }
})


test_that("there are no duplicate betas/alphas in the jagsmodel", {
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

test_that("data_list remains the same", {
  expect_snapshot(lapply(models, "[[", "data_list"))
})

test_that("jagsmodel remains the same", {
  expect_snapshot(lapply(models, "[[", "jagsmodel"))
})

test_that("GRcrit and MCerror give same result", {
  expect_snapshot(lapply(models0, GR_crit, multivariate = FALSE))
  expect_snapshot(lapply(models0, MC_error))
})


test_that("summary output remained the same", {
  expect_snapshot(lapply(models0, print))
  expect_snapshot(lapply(models0, coef))
  expect_snapshot(lapply(models0, confint))
  expect_snapshot(lapply(models0, summary))
  expect_snapshot(lapply(models0, function(x) coef(summary(x))))
})


test_that("prediction works", {

  expect_warning(
    expect_warning(predict(models$m4a, type = "lp")$fitted,
                   "Prediction in multi-level settings")
  )

  expect_warning(
    expect_warning(predict(models$m4a, type = "prob")$fitted,
                   "cases with missing covariates")
  )


  expect_equal(class(predict(models$m4a, type = "lp", warn = FALSE)$fitted),
               "array")
  expect_equal(class(predict(models$m4a, type = "prob", warn = FALSE)$fitted),
               "array")

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

  expect_equal(class(predict(models$m4e, type = "lp", warn = FALSE)$fitted),
                     "array")
  expect_equal(class(predict(models$m4e, type = "prob", warn = FALSE)$fitted),
               "array")
  expect_s3_class(predict(models$m4e, type = "class", warn = FALSE)$fitted,
                  "data.frame")
  expect_s3_class(predict(models$m4e, type = "response", warn = FALSE)$fitted,
                  "data.frame")

  expect_s3_class(predict(models$m4b, type = "lp", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "class", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(models$m4b, type = "response", warn = FALSE)$newdata,
                  "data.frame")

  expect_s3_class(predict(models$m4c, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
})



test_that("residuals work if implemented", {
  # residuals are not yet implemented
  expect_error(residuals(models$m4a, type = "working", warn = FALSE),
               "not yet implemented")
})



test_that("model can be plottet", {
  for (i in seq_along(models)) {
    if (models[[i]]$analysis_type == "mlogitmm") {
      expect_error(plot(models[[i]]))
    } else {
      expect_silent(plot(models[[i]]))
    }
  }
})


test_that("wrong models give errors", {
  # wrong type of outcome variable
  expect_error(mlogitmm_imp(y ~ O1 + C1 + C2 + (1 | id), data = longDF))
  # wrong model function used
  expect_error(mlogit_imp(m2 ~ O1 + C1 + C2 + (1 | id), data = longDF,
                          warn = FALSE))
  # variable not in data
  expect_error(mlogitmm_imp(m2 ~ O1 + C1 + C2 + (1 | id), data = wideDF))

  # model formula that can't be used
  expect_s3_class(mlogitmm_imp(m2 ~ I(O1^2) + C1 + C2 + (1 | id), warn = FALSE,
                               data = longDF), "JointAI_errored")

})
# Sys.setenv(IS_CHECK = "")
