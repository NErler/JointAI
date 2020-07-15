context("survreg models")
library("JointAI")

if (!dir.exists('outfiles')) {
  dir.create('outfiles')
}

PBC2 <- PBC[match(unique(PBC$id), PBC$id), ]
PBC2$center <- cut(as.numeric(PBC2$id), c(-Inf, seq(30, 270, 30), Inf))
PBC$center <- cut(as.numeric(PBC$id), c(-Inf, seq(30, 270, 30), Inf))

PBC2$futime2 <- PBC2$futime
PBC2$status2 <- PBC2$status
PBC2$futime2[1:10] <- NA
PBC2$status2[11:20] <- NA


# no covariates
m0a <- survreg_imp(Surv(futime, status != "censored") ~ 1, data = PBC2,
                   n.adapt = 5, n.iter = 10, seed = 2020)

# only complete
m1a <- survreg_imp(Surv(futime, status != "censored") ~ age + sex,
                   data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
m1b <- survreg_imp(Surv(futime, I(status != "censored")) ~ age + sex,
                   data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)

# only incomplete
m2a <- survreg_imp(Surv(futime, status != "censored") ~ copper, data = PBC2,
                   n.adapt = 5, n.iter = 10, seed = 2020)


# complex structures
m3a <- survreg_imp(Surv(futime, status != "censored") ~ copper + sex + age +
                     abs(age - copper) + log(trig),
                   data = PBC2, trunc = list(trig = c(0.0001, NA)),
                   n.adapt = 5, n.iter = 10, seed = 2020)

m3b <- survreg_imp(Surv(futime, status != "censored") ~ copper + sex + age +
                     abs(age - copper) + log(trig) + (1 | center),
                   data = PBC2, trunc = list(trig = c(0.0001, NA)),
                   n.adapt = 5, n.iter = 10, seed = 2020)


models <- list(m0a, m1a, m1b, m2a, m3a, m3b)


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
    "outfiles/test_survreg_MCMC.txt")
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
    "outfiles/test_survreg_GR_crit.txt")
  expect_known_output(
    print(lapply(models, MC_error)),
    "outfiles/test_survreg_MC_error.txt")
})


test_that("summary output remained the same", {
  expect_known_output(
    print(lapply(models, print)),
    file = "outfiles/test_survreg_print.txt")
  expect_known_output(
    print(lapply(models, coef)),
    file = "outfiles/test_survreg_coef.txt")
  expect_known_output(
    print(lapply(models, confint)),
    file = "outfiles/test_survreg_confint.txt")
  expect_known_output(
    print(lapply(models, summary)),
    file = "outfiles/test_survreg_summary.txt")
  expect_known_output(
    print(lapply(models, function(x) coef(summary(x)))),
    file = "outfiles/test_survreg_coefsummary.txt")
})


test_that("prediction works", {
  expect_s3_class(predict(m3b, type = "lp")$fitted, "data.frame")
  expect_s3_class(predict(m3b, type = "response", warn = FALSE)$fitted,
                  "data.frame")
})


test_that("residuals", {
  # residuals are not yet implemented
  expect_error(residuals(m3b, type = "working"))
  expect_error(residuals(m3b, type = "response"))
})


test_that("model can (not) be plottet", {
  for (i in seq_along(models)) {
    expect_error(plot(models[[i]]))
  }
})


test_that("wrong models give errors", {
  # time-varying covariate
  expect_error(survreg_imp(Surv(futime, status != "censored") ~ copper + sex +
                             albumin + (1 | id) + (1 | center), timevar = "day",
                           data = PBC, n.adapt = 5, n.iter = 10, seed = 2020))

  # more than two event types
  expect_error(survreg_imp(Surv(futime, status) ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020))

  # missing values in event time
  expect_error(survreg_imp(Surv(futime2, status != "censored") ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020))

  # missing values in event status
  expect_error(survreg_imp(Surv(futime, status2 != "censored") ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020))

  # wrong outcome
  expect_error(survreg_imp(futime ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020))

  # no argument formula
  expect_error(survreg_imp(fixed = futime ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020))

})
