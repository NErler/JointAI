context("GLM Models")
library("JointAI")
library("splines")

set_seed(1234)
wideDF <- JointAI::wideDF

# poisson variables
wideDF$P1 <- rpois(nrow(wideDF), 3)
wideDF$P2 <- rpois(nrow(wideDF), 2)
wideDF$P2[sample.int(nrow(wideDF), 20)] <- NA

# gamma variables
wideDF$L1mis <- wideDF$L1
wideDF$L1mis[sample.int(nrow(wideDF), 20)] <- NA

wideDF$Be1 <- plogis(rnorm(nrow(wideDF)))
wideDF$Be2 <- plogis(rnorm(nrow(wideDF)))
wideDF$Be2[sample.int(nrow(wideDF), size = 20)] <- NA


run_glm_models <- function() {
  cat('\nRunning glm models...\n')
  sink(tempfile())
  on.exit(sink())
  invisible(force(suppressWarnings({

    models = list(
      # no covariates
      m0a1 = lm_imp(y ~ 1, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020),
      m0a2 = glm_imp(y ~ 1, family = gaussian(link = "identity"),
                     data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m0a3 = glm_imp(y ~ 1, family = gaussian(link = "log"),
                     data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m0a4 = glm_imp(y ~ 1, family = gaussian(link = "inverse"),
                     data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),

      m0b1 = glm_imp(B1 ~ 1, family = binomial(link = "logit"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m0b2 = glm_imp(B1 ~ 1, family = binomial(link = "probit"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m0b3 = glm_imp(B1 ~ 1, family = binomial(link = "log"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m0b4 = glm_imp(B1 ~ 1, family = binomial(link = "cloglog"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m0c1 = glm_imp(L1 ~ 1, family = Gamma(link = "inverse"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m0c2 = glm_imp(L1 ~ 1, family = Gamma(link = "log"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m0d1 = glm_imp(P1 ~ 1, family = poisson(link = "log"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m0d2 = glm_imp(P1 ~ 1, family = poisson(link = "identity"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m0e1 = lognorm_imp(L1 ~ 1, data = wideDF,
                         n.adapt = 5, n.iter = 10, seed = 2020),
      m0f1 = betareg_imp(Be1 ~ 1, data = wideDF,
                         n.adapt = 5, n.iter = 10, seed = 2020),

      # only complete
      m1a = lm_imp(y ~ C1, data = wideDF, n.adapt = 5, n.iter = 10,
                   seed = 2020),
      m1b = glm_imp(B1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020,
                    family = binomial()),
      m1c = glm_imp(L1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020,
                    family = Gamma()),
      m1d = glm_imp(P1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020,
                    family = poisson()),

      m1e = lognorm_imp(L1 ~ C1, data = wideDF,
                        n.adapt = 5, n.iter = 10, seed = 2020),
      m1f = betareg_imp(Be1 ~ C1, data = wideDF,
                        n.adapt = 5, n.iter = 10, seed = 2020),


      # only incomplete
      m2a = lm_imp(y ~ C2, data = wideDF, n.adapt = 5, n.iter = 10,
                   seed = 2020),
      m2b = glm_imp(B2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020,
                    family = binomial()),
      m2c = glm_imp(L1mis ~ C2, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020,
                    family = Gamma()),
      m2d = glm_imp(P2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10,
                    seed = 2020,
                    family = poisson()),

      m2e = lognorm_imp(L1mis ~ C2, data = wideDF,
                        n.adapt = 5, n.iter = 10, seed = 2020),
      m2f = betareg_imp(Be2 ~ C2, data = wideDF,
                        n.adapt = 5, n.iter = 10, seed = 2020),


      # as covariate
      m3a = lm_imp(C1 ~ C2 + B2 + P2 + L1mis + Be2, data = wideDF,
                   n.adapt = 5, n.iter = 10, seed = 2020,
                   models = c(P2 = "glm_poisson_log",
                              L1mis = "glm_gamma_inverse",
                              Be2 = "beta")),

      m3b = lm_imp(C1 ~ C2 + B2 + P2 + L1mis, data = wideDF,
                   n.adapt = 5, n.iter = 10, seed = 2020,
                   models = c(C2 = "glm_gaussian_inverse",
                              P2 = "glm_poisson_identity",
                              B2 = "glm_binomial_probit",
                              L1mis = "lognorm"),
      ),

      m3c = lm_imp(C1 ~ C2 + B2 + P2 + L1mis, data = wideDF,
                   n.adapt = 5, n.iter = 10, seed = 2020,
                   models = c(C2 = "glm_gaussian_log",
                              P2 = "glm_poisson_identity",
                              L1mis = "glm_gamma_log",
                              B2 = "glm_binomial_log")),

      m3d = lm_imp(C1 ~ C2 + B2 + P2 + L1mis + Be2, data = wideDF,
                   n.adapt = 5, n.iter = 10, seed = 2020,
                   trunc = list(Be2 = c(0, 1)),
                   models = c(C2 = "glm_gaussian_log",
                              P2 = "glm_poisson_identity",
                              L1mis = "glm_gamma_log",
                              B2 = "glm_binomial_log")),

      # complex structures
      m4a = lm_imp(y ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF,
                   n.adapt = 5, n.iter = 10, seed = 2020),

      m4b = glm_imp(B1 ~ L1mis + abs(C1 - C2) + log(Be2),
                    data = wideDF, warn = FALSE,
                    n.adapt = 5, n.iter = 10, seed = 2020,
                    models = c(C2 = "glm_gaussian_log",
                               L1mis = "glm_gamma_inverse",
                               Be2 = "beta"),
                    family = binomial()),

      # for prediction etc.
      m5a1 = lm_imp(y ~ C2 + B2 + B1 + O1, data = wideDF,
                    n.adapt = 5, n.iter = 10, seed = 2020),
      m5a2 = glm_imp(y ~ C2 + B2 + B1 + O1, family = gaussian(link = "log"),
                     data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),
      m5a3 = glm_imp(y ~ C2 + B2 + B1 + O1, family = gaussian(link = "inverse"),
                     data = wideDF, n.adapt = 5, n.iter = 10, seed = 2020),

      m5b1 = glm_imp(B1 ~ C2 + B2 + C1 + O1,
                     family = binomial(link = "logit"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m5b2 = glm_imp(B1 ~ C2 + B2 + C1 + O1,
                     family = binomial(link = "probit"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m5b3 = glm_imp(B1 ~ C2 + B2 + C1 + O1,
                     family = binomial(link = "log"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m5b4 = glm_imp(B1 ~ C2 + B2 + C1 + O1,
                     family = binomial(link = "cloglog"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m5c1 = glm_imp(L1 ~ C2 + B2 + B1 + O1,
                     family = Gamma(link = "inverse"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m5c2 = glm_imp(L1 ~ C2 + B2 + B1 + O1,
                     family = Gamma(link = "log"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m5d1 = glm_imp(P1 ~ C2 + B2 + B1 + O1,
                     family = poisson(link = "log"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),
      m5d2 = glm_imp(P1 ~ C2 + B2 + B1 + O1,
                     family = poisson(link = "identity"), data = wideDF,
                     n.adapt = 5, n.iter = 10, seed = 2020),

      m5e1 = lognorm_imp(L1 ~ C2 + B2 + B1 + O1, data = wideDF,
                         n.adapt = 5, n.iter = 10, seed = 2020),
      m5f1 = betareg_imp(Be1 ~ C2 + B2 + B1 + O1, data = wideDF,
                         n.adapt = 5, n.iter = 10, seed = 2020),


      # from previous test files
      m6a = lm_imp(y ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF,
                   n.adapt = 5, n.iter = 5, seed = 2020),
      m6b = glm_imp(B1 ~ M2 + O2 * abs(C1 - C2) +  log(C1), data = wideDF,
                    family = 'binomial', n.adapt = 5, n.iter = 5, seed = 2020),
      m6c = glm_imp(C1 ~ M2 + O2 * abs(y - C2), data = wideDF,
                    family = Gamma(link = 'log'),
                    n.adapt = 5, n.iter = 5, seed = 2020),
      m6d = lm_imp(SBP ~ age + gender + log(bili) + exp(creat),
                   trunc = list(bili = c(1e-5, 1e10)),
                   data = NHANES, mess = FALSE,
                   n.adapt = 5, n.iter = 5, seed = 2020),

      m6e = lm_imp(SBP ~ age + gender + log(bili) + exp(creat),
                   models = c(bili = 'lognorm', creat = 'lm'),
                   data = NHANES, mess = FALSE,
                   n.adapt = 5, n.iter = 5, seed = 2020),

      m6f = lm_imp(SBP ~ age + gender + log(bili) + exp(creat),
                   models = c(bili = 'glm_gamma_inverse', creat = 'lm'),
                   data = NHANES, mess = FALSE,
                   n.adapt = 5, n.iter = 5, seed = 2020),


      # from bug-fixes:
      # two-part trafo is pasted correctly
      mod7a = lm_imp(SBP ~ ns(age, df = 2) + gender + I(bili^2) + I(bili^3),
                     data = NHANES, n.adapt = 5, n.iter = 10, seed = 2020)

    )
  }
  )))
  models
}

models <- run_glm_models()


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
  expect_snapshot_output(lapply(models, summary, missinfo = TRUE))
  expect_snapshot_output(lapply(models, function(x) coef(summary(x))))
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
  expect_s3_class(predict(models$m5a1, warn = FALSE)$fitted, "data.frame")

  # prediction with newdata
  ndf <- predDF(models$m5a1, vars = ~ C2)
  expect_s3_class(ndf, "data.frame")
  expect_s3_class(predict(models$m5a1, newdata = ndf)$fitted, "data.frame")
})



test_that("residuals", {
  for (k in seq_along(models)) {
    expect_is(residuals(models[[k]], type = "response"),
              "numeric")

    if (models[[k]]$analysis_type == "beta") {
      expect_error(residuals(models[[k]], type = "working"))
      expect_error(residuals(models[[k]], type = "pearson"))
    } else {
      expect_is(residuals(models[[k]], type = "working"),
                "numeric")
      expect_is(residuals(models[[k]], type = "pearson"),
                "numeric")
    }
  }
  expect_is(residuals(models$m5a1), "numeric")
})


test_that("model can be plottet", {
  for (i in seq_along(models)[names(models) == "pred"]) {
    if (models[[i]]$analysis_type %in% c("lognorm", "beta")) {
      expect_error(plot(models[[i]]))
    } else {
      expect_silent(plot(models[[i]]))
    }
  }
})


test_that("wrong models give errors", {

  # cauchit link is not implemented
  expect_error(glm_imp(B1 ~ 1, family = binomial(link = "cauchit"),
                       data = wideDF, seed = 2020))

  # sqrt is not an allowed link (not implemented)
  expect_error(glm_imp(P1 ~ 1, family = poisson(link = "sqrt"), data = wideDF,
                       seed = 2020))

  # gives JAGS model error (no dedicated error message)
  # glm_imp(time ~ 1, family = Gamma(link = "identity"), data = wideDF,
  #                 n.adapt = 5, n.iter = 10, seed = 2020)

  # no family specified
  expect_error(glm_imp(B1 ~ C1, data = wideDF, seed = 2020))

  # unknown covariate model type
  expect_error(lm_imp(C1 ~ C2 + Be2, data = wideDF,
                      n.adapt = 5, n.iter = 10, seed = 2020,
                      models = c(Be2 = "betareg")))
})
