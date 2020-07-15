context("CLM Models")
library("JointAI")

if (!dir.exists('outfiles')) {
  dir.create('outfiles')
}


# no covariates
m0a <- clm_imp(O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)
m0b <- clm_imp(O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)

# only complete
m1a <- clm_imp(O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)
m1b <- clm_imp(O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)

# only incomplete
m2a <- clm_imp(O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)
m2b <- clm_imp(O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)

# as covariate
m3a <- lm_imp(C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)
m3b <- lm_imp(C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020)


# complex structures
m4a <- clm_imp(O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF,
               n.adapt = 5, n.iter = 10, seed = 2020)
m4b <- clm_imp(O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) *
                 abs(C1 - C2) + log(C1), data = wideDF, warn = FALSE,
               n.adapt = 5, n.iter = 10, seed = 2020)

# non-proportional effects
# - basic model
m5a <- clm_imp(O1 ~ C1 + C2 + M2 + O2, data = wideDF,
               n.adapt = 5, n.iter = 10, seed = 2020,
               nonprop = list(O1 = ~ C1 + C2))

# - interaction in prop. effects
m5b <- clm_imp(O1 ~ C1 * C2 + M2 + O2, data = wideDF,
               n.adapt = 5, n.iter = 10, seed = 2020,
               nonprop = list(O1 = ~ C1 + C2))

# - interaction in non-prop effects
m5c <- clm_imp(O1 ~ C1 * C2 + M2 + O2, data = wideDF,
               n.adapt = 5, n.iter = 10, seed = 2020,
               nonprop = list(O1 = ~ C1 * C2))

# - interaction between non-prop and prop effects
m5d <- clm_imp(O1 ~ C1 + M2 * C2 + O2, data = wideDF,
               n.adapt = 5, n.iter = 10, seed = 2020,
               nonprop = list(O1 = ~ C1 + C2))



models <- list(m0a, m0b, m1a, m1b, m2a, m2b,
               cov1 = m3a, cov2 = m3b,
               m4a, m4b,
               m5a, m5b, m5c, m5d)


test_that("models run", {
  for (k in seq_along(models)) {
    expect_s3_class(models[[k]], "JointAI")
  }
})


test_that("there are no duplicate betas/alphas in the JAGSmodel", {
  expect_null(unlist(lapply(models, find_dupl_parms)))
})


test_that("models give same result as before", {
  expect_known_output(
    print(lapply(models, "[[", "MCMC")),
    "outfiles/test_clm_MCMC.txt")
})


test_that("MCMC samples can be plottet", {
  for (k in seq_along(models)) {
    expect_silent(traceplot(models[[k]]))
    expect_silent(densplot(models[[k]]))
    expect_silent(plot(MC_error(models[[k]])))
  }
})

test_that("GRcrit and MCerror give same result", {
  expect_known_output(
    print(lapply(models, GR_crit)),
    "outfiles/test_clm_GR_crit.txt")
  expect_known_output(
    print(lapply(models, MC_error)),
    "outfiles/test_clm_MC_error.txt")
})


test_that("summary output remained the same", {
  expect_known_output(
    print(lapply(models, print)),
    file = "outfiles/test_clm_print.txt")
  expect_known_output(
    print(lapply(models, coef)),
    file = "outfiles/test_clm_coef.txt")
  expect_known_output(
    print(lapply(models, confint)),
    file = "outfiles/test_clm_confint.txt")
  expect_known_output(
    print(lapply(models, summary)),
    file = "outfiles/test_clm_summary.txt")
  expect_known_output(
    print(lapply(models, function(x) coef(summary(x)))),
    file = "outfiles/test_clm_coefsummary.txt")
})


test_that("prediction works", {
  expect_is(predict(m4a, type = "lp")$fitted, "array")
  expect_is(predict(m4a, type = "prob", warn = FALSE)$fitted, "array")
  expect_s3_class(predict(m4a, type = "class", warn = FALSE)$fitted,
                  "data.frame")
  expect_s3_class(predict(m4a, type = "response", warn = FALSE)$fitted,
                  "data.frame")

  expect_s3_class(predict(m4a, type = "lp", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(m4a, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(m4a, type = "class", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(m4a, type = "response", warn = FALSE)$newdata,
                  "data.frame")

  expect_is(predict(m5d, type = "lp", warn = FALSE)$fitted, "array")
  expect_is(predict(m5d, type = "prob", warn = FALSE)$fitted, "array")
  expect_is(predict(m5d, type = "class", warn = FALSE)$fitted, "data.frame")
  expect_is(predict(m5d, type = "response", warn = FALSE)$fitted, "data.frame")

  expect_s3_class(predict(m5d, type = "lp", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(m5d, type = "prob", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(m5d, type = "class", warn = FALSE)$newdata,
                  "data.frame")
  expect_s3_class(predict(m5d, type = "response", warn = FALSE)$newdata,
                  "data.frame")
})


test_that("residuals", {
  # residuals are not yet implemented
  expect_error(residuals(m4a, type = "working"))
})


test_that("model can be plottet", {
  for (i in seq_along(models)[names(models) == ""]) {
    expect_error(plot(models[[i]]))
  }
})


test_that("wrong models give errors", {
  expect_error(clm_imp(y ~ O1 + C1 + C2, data = wideDF))
  expect_error(clm_imp(O2 ~ O1 + C1 + C2 + (1 | id), data = longDF))
  expect_error(clm_imp(O2 ~ O1 + C1 + C2 + (1 | id), data = wideDF))
  expect_s3_class(clm_imp(O2 ~ I(O1^2) + C1 + C2, data = wideDF)$model,
                  "try-error")
  expect_error(clm_imp(O2 ~ O1 + C1, data = wideDF,
                       nonprop = list(O2 = ~ C2)))
})
