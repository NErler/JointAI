library("JointAI")

# Sys.setenv(IS_CHECK = "true")

skip_on_cran()

if (identical(Sys.getenv("NOT_CRAN"), "true")) {

  PBC2 <- PBC[match(unique(PBC$id), PBC$id), ]
  PBC2$center <- cut(as.numeric(PBC2$id), c(-Inf, seq(30, 270, 30), Inf))
  PBC$center <- cut(as.numeric(PBC$id), c(-Inf, seq(30, 270, 30), Inf))

  PBC2$futime2 <- PBC2$futime
  PBC2$status2 <- PBC2$status
  PBC2$futime2[1:10] <- NA
  PBC2$status2[11:20] <- NA


  run_coxph_models <- function() {

    sink(tempfile())
    on.exit(sink())
    invisible(force(suppressWarnings({

      models <- list(
        # no covariates
        m0a = coxph_imp(Surv(futime, status != "censored") ~ 1, data = PBC2,
                        n.adapt = 1, n.iter = 4, seed = 2020,
                        warn = FALSE, mess = FALSE),

        # only complete
        m1a = coxph_imp(Surv(futime, status != "censored") ~ age + sex,
                        data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m1b = coxph_imp(Surv(futime, I(status != "censored")) ~ age + sex,
                        data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020,
                        warn = FALSE, mess = FALSE),

        # only incomplete
        m2a = coxph_imp(Surv(futime, status != "censored") ~ copper,
                        data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020,
                        warn = FALSE, mess = FALSE),


        # complex structures
        m3a = coxph_imp(Surv(futime, status != "censored") ~ copper + sex +
                          age + abs(age - copper) + log(trig),
                        data = PBC2, trunc = list(trig = c(0.0001, NA)),
                        n.adapt = 2, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        m3b = coxph_imp(Surv(futime, status != "censored") ~ copper + sex +
                          age + abs(age - copper) + log(trig) + (1 | center),
                        data = PBC2, trunc = list(trig = c(0.0001, NA)),
                        n.adapt = 2, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),


        # time-varying covariates ---------------------------------------------
        # time-dep variables of different types
        m4a = coxph_imp(Surv(futime, status != "censored") ~ age + sex + trt +
                          albumin + platelet + stage + (1 | id), data = PBC,
                        timevar = "day", n.adapt = 2, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        # interaction between complete baseline and time-dep variable.
        # Note: interaction with incomplete baseline does not work!
        m4b = coxph_imp(Surv(futime, status != "censored") ~ age + sex * trt +
                          albumin + log(platelet) + (1 | id), data = PBC,
                        timevar = "day",
                        n.adapt = 2, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        # transformation of incomplete time-dep variable
        m4c = coxph_imp(Surv(futime, status != "censored") ~ age + sex +
                          albumin + log(platelet) + (1 | id) + (1 | center),
                        data = PBC, timevar = "day",
                        n.adapt = 2, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        m4d = coxph_imp(Surv(futime, status != "censored") ~ age + sex +
                          albumin + ns(platelet, df = 2) + (1 | id) +
                          (1 | center),
                        data = PBC, timevar = "day",
                        n.adapt = 2, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE)
      )
    }
    )))
    models
  }

  models <- run_coxph_models()
  models0 <- set0_list(models)


  test_that("models run", {
    for (k in seq_along(models)) {
      expect_s3_class(models[[k]], "JointAI")
    }
  })


  test_that("there are no duplicate betas/alphas in the jagsmodel", {
    expect_null(unlist(lapply(models[!grepl("m4[[:alpha:]]+", names(models))],
                              find_dupl_parms)))

    expect_equal(
      find_dupl_parms(models[[7]]),
      paste0("beta[", models[[7]]$par_index_main[[1]]["M_lvlone", 'start'] :
               models[[7]]$par_index_main[[1]]["M_lvlone", 'end'], "]")
    )

    expect_equal(
      find_dupl_parms(models[[8]]),
      paste0("beta[", models[[8]]$par_index_main[[1]]["M_lvlone", 'start'] :
               models[[8]]$par_index_main[[1]]["M_lvlone", 'end'], "]")
    )

    expect_equal(
      find_dupl_parms(models[[9]]),
      paste0("beta[", models[[9]]$par_index_main[[1]]["M_lvlone", 'start'] :
               models[[9]]$par_index_main[[1]]["M_lvlone", 'end'], "]")
    )
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

  # test_that("data_list remains the same", {
  #   skip_on_cran()
  #   expect_snapshot(lapply(models, "[[", "data_list"))
  # })

  test_that("jagsmodel remains the same", {
    expect_snapshot(lapply(models, "[[", "jagsmodel"))
  })


  test_that("GRcrit and MCerror give same result", {
    expect_snapshot(lapply(models0, GR_crit, multivariate = FALSE))
    expect_snapshot(lapply(models0, MC_error))
  })



  test_that("summary output remained the same", {
    skip_on_cran()
    expect_snapshot(lapply(models0, print))
    expect_snapshot(lapply(models0, coef))
    expect_snapshot(lapply(models0, confint))
    expect_snapshot(lapply(models0, summary))
    expect_snapshot(lapply(models0, function(x) coef(summary(x))))
  })


  test_that("prediction works", {
    expect_s3_class(predict(models$m3a, type = "lp", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m3b, type = "lp", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4a, type = "lp", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4b, type = "lp", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4c, type = "lp", warn = FALSE)$fitted,
                    "data.frame")

    expect_s3_class(predict(models$m3a, type = "survival", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m3b, type = "survival", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4a, type = "survival", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4b, type = "survival", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4c, type = "survival", warn = FALSE)$fitted,
                    "data.frame")

    expect_s3_class(predict(models$m3a, type = "risk", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m3b, type = "risk", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4a, type = "risk", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4b, type = "risk", warn = FALSE)$fitted
                    , "data.frame")
    expect_s3_class(predict(models$m4c, type = "risk", warn = FALSE)$fitted,
                    "data.frame")

    expect_s3_class(predict(models$m3a, type = "expected", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m3b, type = "expected", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4a, type = "expected", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4b, type = "expected", warn = FALSE)$fitted,
                    "data.frame")
    expect_s3_class(predict(models$m4c, type = "expected", warn = FALSE)$fitted,
                    "data.frame")
  })



  test_that("residuals", {
    # residuals are not yet implemented
    expect_error(residuals(models$m3b, type = "working", warn = FALSE))
    expect_error(residuals(models$m3b, type = "response", warn = FALSE))
  })


  test_that("model can (not) be plottet", {
    for (i in seq_along(models)) {
      expect_error(plot(models[[i]]))
    }
  })


  test_that("wrong models give errors", {
    # more than two event types
    expect_error(coxph_imp(Surv(futime, status) ~ copper + sex,
                           data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020))

    # missing values in event time
    expect_error(coxph_imp(Surv(futime2, status != "censored") ~ copper + sex,
                           data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020))

    # missing values in event status
    expect_error(coxph_imp(Surv(futime, status2 != "censored") ~ copper + sex,
                           data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020))

    # wrong outcome
    expect_error(coxph_imp(futime ~ copper + sex,
                           data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020))

    # no argument formula
    expect_error(coxph_imp(fixed = futime ~ copper + sex,
                           data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020))

    # time-varying covariates without observations for some subjects
    expect_error(coxph_imp(Surv(futime, status != "censored") ~ age + sex + trt +
                             albumin + chol + (1 | id), data = PBC,
                           timevar = "day",
                           n.adapt = 2, n.iter = 4, seed = 2020
    ))

    # interaction between time-varying covariates and incomplete baseline
    # variable
    expect_error(coxph_imp(Surv(futime, status != "censored") ~ age +
                             trig * platelet + (1 | id), data = PBC,
                           timevar = "day",
                           n.adapt = 2, n.iter = 4, seed = 2020)
    )

  })
}
# Sys.setenv(IS_CHECK = "")
