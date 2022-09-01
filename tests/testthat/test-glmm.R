library("JointAI")

# Sys.setenv(IS_CHECK = "true")
skip_on_cran()

if (identical(Sys.getenv("NOT_CRAN"), "true")) {

  set_seed(1234)
  longDF <- JointAI::longDF
  # gamma variables
  longDF$L1 <- rgamma(nrow(longDF), 2, 4)
  longDF$L1mis <- rgamma(nrow(longDF), 2, 4)
  longDF$L1mis[sample.int(nrow(longDF), 20)] <- NA

  # beta variables
  longDF$Be1 <- plogis(longDF$time - longDF$C1)
  longDF$Be2 <- plogis(longDF$y + longDF$c1)
  longDF$Be2[c(1:20) * 5] <- NA


  run_glmm_models <- function() {
    sink(tempfile())
    on.exit(sink())
    invisible(force(suppressWarnings({

      models = list(
        # no covariates
        m0a1 = lme_imp(y ~ 1 + (1 | id), data = longDF, n.adapt = 5, n.iter = 10,
                       seed = 2020, warn = FALSE, mess = FALSE),
        m0a2 = glme_imp(y ~ 1 + (1 | id), family = gaussian(link = "identity"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0a3 = glme_imp(y ~ 1 + (1 | id), family = gaussian(link = "log"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0a4 = glme_imp(y ~ 1 + (1 | id), family = gaussian(link = "inverse"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        m0b1 = glme_imp(b1 ~ 1 + (1 | id), family = binomial(link = "logit"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0b2 = glme_imp(b1 ~ 1 + (1 | id), family = binomial(link = "probit"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0b3 = glme_imp(b1 ~ 1 + (1 | id), family = binomial(link = "log"),
                        data = longDF, n.adapt = 50, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0b4 = glme_imp(b1 ~ 1 + (1 | id), family = binomial(link = "cloglog"),
                        data = longDF, n.adapt = 50, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        m0c1 = glme_imp(L1 ~ 1 + (1 | id), family = Gamma(link = "inverse"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0c2 = glme_imp(L1 ~ 1 + (1 | id), family = Gamma(link = "log"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        m0d1 = glme_imp(p1 ~ 1 + (1 | id), family = poisson(link = "log"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),
        m0d2 = glme_imp(p1 ~ 1 + (1 | id), family = poisson(link = "identity"),
                        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                        warn = FALSE, mess = FALSE),

        m0e1 = lognormmm_imp(L1 ~ 1 + (1 | id), data = longDF,
                             n.adapt = 5, n.iter = 10, seed = 2020,
                             warn = FALSE, mess = FALSE),
        m0f1 = betamm_imp(Be1 ~ 1 + (1 | id), data = longDF,
                          n.adapt = 5, n.iter = 10, seed = 2020,
                          warn = FALSE, mess = FALSE),

        # only complete
        m1a = lme_imp(y ~ C1 + (1 | id), data = longDF, n.adapt = 5,
                      n.iter = 10, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m1b = glme_imp(b1 ~ C1 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = binomial(),
                       warn = FALSE, mess = FALSE),
        m1c = glme_imp(L1 ~ C1 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = Gamma(),
                       warn = FALSE, mess = FALSE),
        m1d = glme_imp(p1 ~ C1 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = poisson(),
                       warn = FALSE, mess = FALSE),

        m1e = lognormmm_imp(L1 ~ C1 + (1 | id), data = longDF,
                            n.adapt = 5, n.iter = 10, seed = 2020,
                            warn = FALSE, mess = FALSE),
        m1f = betamm_imp(Be1 ~ C1 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         warn = FALSE, mess = FALSE),


        # only incomplete
        m2a = lme_imp(y ~ c2 + (1 | id), data = longDF, n.adapt = 5,
                      n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE),
        m2b = glme_imp(b2 ~ c2 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = binomial(),
                       warn = FALSE, mess = FALSE),
        m2c = glme_imp(L1mis ~ c2 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = Gamma(),
                       warn = FALSE, mess = FALSE),
        m2d = glme_imp(p2 ~ c2 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = poisson(),
                       warn = FALSE, mess = FALSE),

        m2e = lognormmm_imp(L1mis ~ c2 + (1 | id), data = longDF,
                            n.adapt = 5, n.iter = 10, seed = 2020,
                            warn = FALSE, mess = FALSE),
        m2f = betamm_imp(Be2 ~ c2 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         warn = FALSE, mess = FALSE),

        # no intercept
        m3a = lme_imp(y ~ 0 + C2 + (1 | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m3b = glme_imp(b2 ~ 0 + C2 + (1 | id), data = longDF,
                       family = binomial(), n.adapt = 5, n.iter = 10,
                       seed = 2020, warn = FALSE, mess = FALSE),
        m3c = glme_imp(L1mis ~ 0 + C2 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = Gamma(),
                       warn = FALSE, mess = FALSE),
        m3d = glme_imp(p2 ~ 0 + C2 + (1 | id), data = longDF, n.adapt = 5,
                       n.iter = 10, seed = 2020, family = poisson(),
                       warn = FALSE, mess = FALSE),

        m3e = lognormmm_imp(L1mis ~ 0 + C2 + (1 | id), data = longDF,
                            n.adapt = 5, n.iter = 10, seed = 2020,
                            warn = FALSE, mess = FALSE),
        m3f = betamm_imp(Be2 ~ 0 + C2 + (1 | id), data = longDF,
                         n.adapt = 5, n.iter = 10, seed = 2020,
                         warn = FALSE, mess = FALSE),


        # as covariate
        m4a = lme_imp(c1 ~ c2 + B2 + p2 + L1mis + Be2 + (1 | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020,
                      models = c(p2 = "glmm_poisson_log",
                                 L1mis = "glmm_gamma_inverse",
                                 Be2 = "glmm_beta"),
                      warn = FALSE, mess = FALSE),

        m4b = lme_imp(c1 ~ c2 + b2 + p2 + L1mis + (1 | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020,
                      models = c(c2 = "glmm_gaussian_inverse",
                                 p2 = "glmm_poisson_identity",
                                 b2 = "glmm_binomial_probit",
                                 L1mis = "glmm_lognorm"),
                      warn = FALSE, mess = FALSE),

        m4c = lme_imp(c1 ~ c2 + b2 + p2 + L1mis + (1 | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020, no_model = "time",
                      models = c(c2 = "glmm_gaussian_log",
                                 p2 = "glmm_poisson_identity",
                                 L1mis = "glmm_gamma_log",
                                 b2 = "glmm_binomial_log"),
                      warn = FALSE, mess = FALSE),

        m4d = lme_imp(c1 ~ c2 + b2 + p2 + L1mis + Be2 + (1 | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020,
                      trunc = list(Be2 = c(0, 1)),
                      shrinkage = "ridge",
                      models = c(c2 = "glmm_gaussian_log",
                                 p2 = "glmm_poisson_identity",
                                 L1mis = "glmm_gamma_log",
                                 b2 = "glmm_binomial_log"),
                      warn = FALSE, mess = FALSE),


        # complex structures
        m5a = lme_imp(y ~ M2 + o2 * abs(C1 - c2) + log(C1) + time + I(time^2) +
                        (time | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m5b = glme_imp(b1 ~ L1mis + abs(c1 - C2) + log(Be2) + time +
                         (time + I(time^2) | id),
                       data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                       models = c(C2 = "glm_gaussian_log",
                                  L1mis = "glmm_gamma_inverse",
                                  Be2 = "glmm_beta"), shrinkage = "ridge",
                       family = binomial(),
                       warn = FALSE, mess = FALSE),


        # no random intercept
        m6a = lme_imp(y ~ b2 + C1 + C2 + time + (0 + time | id), data = longDF,
                      n.adapt = 5, n.iter = 10, seed = 2020, no_model = "time",
                      warn = FALSE, mess = FALSE),

        m6b = glme_imp(b1 ~ c1 + C2 + B1 + time + (0 + time + I(time^2) | id),
                       data = longDF, n.adapt = 5, n.iter = 10, seed = 2020,
                       shrinkage = "ridge",
                       family = binomial(),
                       warn = FALSE, mess = FALSE),

        # spline random effects
        m7a = lme_imp(y ~ ns(time, df = 2), random = ~ ns(time, df = 2)|id,
                      data = longDF, n.iter = 10, adapt = 5, seed = 2020),
        m7b = lme_imp(y ~ bs(time, df = 3), random = ~ bs(time, df = 3)|id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m7c = lme_imp(y ~ C1 + c1 + ns(time, df = 3),
                      random = ~ ns(time, df = 3)|id, data = longDF,
                      n.iter = 10, nadapt = 5, seed = 2020),
        m7d = lme_imp(y ~ C1 + C2 + c1 + ns(time, df = 3), random = ~ time|id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m7e = lme_imp(y ~ C1 + C2 + c1 + ns(time, df = 3),
                      random = ~ ns(time, df = 3)|id, data = longDF,
                      no_model = "time", n.iter = 10, n.adapt = 5, seed = 2020),
        m7f = lme_imp(y ~ C1 + C2 + c1 + ns(time, df = 3), random = ~ time|id,
                      data = longDF,n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        # complex random effects
        m8a = lme_imp(y ~ c1 + c2 + time, random = ~ time + c2|id,
                      no_model = "time", data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8b = lme_imp(y ~ c1 + c2 + time, random = ~ time + c2|id,
                      data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8c = lme_imp(y ~ B2 * c1 + c2 + time, random = ~ time + c1|id,
                      data = longDF, no_model = "time",
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8d = lme_imp(y ~ B2 * c1 + c2 + time, random = ~ time + c1|id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8e = lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8f = lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                      data = longDF, no_model = "time",
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8g = lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                      data = longDF, no_model = c("time", "c1"),
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8h = lme_imp(y ~ C1 + B2 * c2 + c1 + time, random = ~ time + c1|id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),
        m8i = lme_imp(y ~ C1 + B2 * c2 + c1 + time, no_model = "time",
                      random = ~ time + c1|id,  data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m8j = lme_imp(y ~ C1 + B2 * c2 + c1 + time, random = ~ time + c2 | id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m8k = lme_imp(y ~ C1 + B2 * c2 + c1 + time, random = ~ time + c2 | id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        # 3-fold interaction on different levels with random slope variable
        m8l = lme_imp(y ~ C1 + B2 * c1 * time, random = ~ time + I(time^2) | id,
                      data = longDF, n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m8m = lme_imp(y ~ c1 * b1 + o1, random = ~b1|id, data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        m8n = lme_imp(y ~ c1 + C1 * time + b1 + B2,
                      random = ~C1 * time|id, data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        # only lvl-1 variables, crossed random effects
        m9a = lme_imp(y ~ c1 + b1 + time + (1|id) + (1 | o1), data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE),

        # bugfix: random slope and monitor analysis_random (issue with
        # re-scaling)
        m9b = lme_imp(y ~ C1 + C2 +  B1 + time + (time | id), data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE,
                      monitor_params = c(analysis_random = TRUE)),

        # bugfix: random intercept only (gave warning about failing to trace
        # monitor for RinvD)
        m9c = lme_imp(y ~ C1 + C2 +  B1 + (1 | id), data = longDF,
                      n.iter = 10, n.adapt = 5, seed = 2020,
                      warn = FALSE, mess = FALSE,
                      monitor_params = c(analysis_random = TRUE))
      )
    }
    )))
  }


  models <- run_glmm_models()
  models0 <- set0_list(models)



  test_that("models run", {
    for (k in seq_along(models)) {
      expect_s3_class(models[[k]], "JointAI")
    }
  })


  test_that("models have the correct model and analysis model type", {
    for (i in seq_along(models)) {
      expect_false(any(sapply(compare_modeltype(models), isFALSE)))
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
    expect_snapshot(lapply(models0, summary, missinfo = TRUE))
    expect_snapshot(lapply(models0, function(x) coef(summary(x))))
  })



  test_that("prediction works", {
    for (k in seq_along(models)) {

      expect_s3_class(predict(models[[k]], type = "link", warn = FALSE)$fitted,
                      "data.frame")
      expect_s3_class(predict(models[[k]], type = "response",
                              warn = FALSE)$fitted,
                      "data.frame")
    }

    # prediction without specifying the type
    expect_s3_class(predict(models$m5a, warn = FALSE)$fitted, "data.frame")

    # prediction with newdata
    ndf <- predDF(models$m5a, vars = ~ c2)
    expect_s3_class(ndf, "data.frame")
    expect_s3_class(predict(models$m5a, newdata = ndf, warn = FALSE)$fitted,
                    "data.frame")
  })



  test_that("residuals", {
    for (k in seq_along(models)[8]) {
      expect_type(residuals(models[[k]], type = "response", warn = FALSE),
                  "double")

      if (models[[k]]$analysis_type %in% c("beta", "glmm_beta")) {
        expect_error(residuals(models[[k]], type = "working", warn = FALSE))
        expect_error(residuals(models[[k]], type = "pearson", warn = FALSE))
      } else {
        expect_type(residuals(models[[k]], type = "working", warn = FALSE),
                    "double")
        expect_type(residuals(models[[k]], type = "pearson", warn = FALSE),
                    "double")
      }
    }
    expect_type(residuals(models$m5a, warn = FALSE), "double")
  })


  test_that("model can be plottet", {
    for (i in seq_along(models)) {
      if (models[[i]]$analysis_type %in% c("lognorm", "glmm_lognorm",
                                           "beta", "glmm_beta")) {
        expect_error(plot(models[[i]]))
      } else {
        expect_silent(plot(models[[i]]))
      }
    }
  })

}

# test_that("wrong models give errors", {
#
#   # cauchit link is not implemented
#   expect_error(glm_imp(B1 ~ 1, family = binomial(link = "cauchit"),
#                        data = wideDF, seed = 2020))
#
#   # sqrt is not an allowed link (not implemented)
#   expect_error(glm_imp(P1 ~ 1, family = poisson(link = "sqrt"), data = wideDF,
#                        seed = 2020))
#
#   # gives JAGS model error (no dedicated error message)
#   # glm_imp(time ~ 1, family = Gamma(link = "identity"), data = wideDF,
#   #                 n.adapt = 5, n.iter = 10, seed = 2020)
#
#   # no family specified
#   expect_error(glm_imp(B1 ~ C1, data = wideDF, seed = 2020))
#
#   # unknown covariate model type
#   expect_error(lm_imp(C1 ~ C2 + Be2, data = wideDF,
#                       n.adapt = 5, n.iter = 10, seed = 2020,
#                       models = c(Be2 = "betareg")))
# })

# Sys.setenv(IS_CHECK = "")
