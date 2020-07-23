context("survreg models")
library("JointAI")

Sys.setenv(IS_CHECK = "true")

PBC2 <- PBC[match(unique(PBC$id), PBC$id), ]
PBC2$center <- cut(as.numeric(PBC2$id), c(-Inf, seq(30, 270, 30), Inf))
PBC$center <- cut(as.numeric(PBC$id), c(-Inf, seq(30, 270, 30), Inf))

PBC2$futime2 <- PBC2$futime
PBC2$status2 <- PBC2$status
PBC2$futime2[1:10] <- NA
PBC2$status2[11:20] <- NA


run_survreg_models <- function() {
  cat('\nRunning survreg models...\n')

  sink(tempfile())
  on.exit(sink())
  invisible(force(suppressWarnings({

    models <- list(

      # no covariates
      m0a = survreg_imp(Surv(futime, status != "censored") ~ 1, data = PBC2,
                        n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

      # only complete
      m1a = survreg_imp(Surv(futime, status != "censored") ~ age + sex,
                        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
      m1b = survreg_imp(Surv(futime, I(status != "censored")) ~ age + sex,
                        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

      # only incomplete
      m2a = survreg_imp(Surv(futime, status != "censored") ~ copper, data = PBC2,
                        n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),


      # complex structures
      m3a = survreg_imp(Surv(futime, status != "censored") ~ copper + sex + age +
                          abs(age - copper) + log(trig),
                        data = PBC2, trunc = list(trig = c(0.0001, NA)),
                        n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

      m3b = survreg_imp(Surv(futime, status != "censored") ~ copper + sex + age +
                          abs(age - copper) + log(trig) + (1 | center),
                        data = PBC2, trunc = list(trig = c(0.0001, NA)),
                        n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE)
    )
  }
  )
  ))
  models
}

models <- run_survreg_models()
models0 <- set0_list(models)


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


test_that("data_list remaines the same", {
  skip_on_cran()
  print_output(lapply(models, "[[", "data_list"))
})

test_that("JAGSmodel remaines the same", {
  skip_on_cran()
  print_output(lapply(models, "[[", "JAGSmodel"))
})


test_that("GRcrit and MCerror give same result", {
  skip_on_cran()
  print_output(lapply(models0, GR_crit, multivariate = FALSE))
  print_output(lapply(models0, MC_error))
})


test_that("summary output remained the same", {
  skip_on_cran()
  print_output(lapply(models0, print))
  print_output(lapply(models0, coef))
  print_output(lapply(models0, confint))
  print_output(lapply(models0, summary))
  print_output(lapply(models0, function(x) coef(summary(x))))
})



test_that("prediction works", {
  expect_s3_class(predict(models$m3b, type = "lp")$fitted, "data.frame")
  expect_s3_class(predict(models$m3b, type = "response", warn = FALSE)$fitted,
                  "data.frame")
})


test_that("residuals", {
  # residuals are not yet implemented
  expect_error(residuals(models$m3b, type = "working"))
  expect_error(residuals(models$m3b, type = "response"))
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
                           data = PBC, n.adapt = 5, n.iter = 10, seed = 2020,
                           warn = FALSE, mess = FALSE))

  # more than two event types
  expect_error(survreg_imp(Surv(futime, status) ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                           warn = FALSE, mess = FALSE))

  # missing values in event time
  expect_error(survreg_imp(Surv(futime2, status != "censored") ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                           warn = FALSE, mess = FALSE))

  # missing values in event status
  expect_error(survreg_imp(Surv(futime, status2 != "censored") ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                           warn = FALSE, mess = FALSE))

  # wrong outcome
  expect_error(survreg_imp(futime ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                           warn = FALSE, mess = FALSE))

  # no argument formula
  expect_error(survreg_imp(fixed = futime ~ copper + sex,
                           data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020,
                           warn = FALSE, mess = FALSE))

})

Sys.setenv(IS_CHECK = "")
