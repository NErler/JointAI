context("main model functions")
library("JointAI")


test_that("Univariate glmm like models work", {
  longDF$xbeta <- runif(nrow(longDF), 0, 1)
  longDF$p1 <- rpois(n = nrow(longDF), lambda = 2)

  mod <- lme_imp(y ~ 1, random = ~ 1 | id, data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(y = 'glmm_gaussian_identity'))

  mod <- lmer_imp(y ~ 1 + (1 | id), data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(y = 'glmm_gaussian_identity'))


  mod <- glme_imp(b1 ~ c1, random = ~ 1 | id, data = longDF,
                  family = binomial())
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(b1 = 'glmm_binomial_logit'))

  mod <- glme_imp(xbeta ~ 1 + (1 | id), data = longDF, family = Gamma())
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(xbeta = 'glmm_gamma_inverse'))

  mod <- glme_imp(p1 ~ 1 + (1 | id), data = longDF, family = poisson())
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(p1 = 'glmm_poisson_log'))

  mod <- betamm_imp(xbeta ~ 1 + (1 | id), data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(xbeta = 'glmm_beta'))

  mod <- lognormmm_imp(time ~ 1 + (1 | id), data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(time = 'glmm_lognorm'))
#
#   mod <- mlogit_imp(M1 ~ 1, data = longDF)
#   expect_s3_class(mod, "JointAI")
#   expect_equal(mod$models, c(M1 = 'mlogit'))

  mod <- clmm_imp(o1 ~ C1 + (1 | id), data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(o1 = 'clmm'))

  mod <- clmm_imp(o1 ~ C1, random = ~ 1 | id, data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(o1 = 'clmm'))
})




test_that("Multivariate models work", {
  longDF$xbeta <- runif(nrow(longDF), 0, 1)
  longDF$p1 <- rpois(n = nrow(longDF), lambda = 2)

  mod <- lme_imp(list(y ~ C1 + B1 + c2 + (1 | id),
                      c1 ~ B1 + B2 + c2 + (1 | id),
                      B2 ~ C1), data = longDF)
  expect_s3_class(mod, "JointAI")
  expect_equal(mod$models, c(y = 'glmm_gaussian_identity', c1 = 'lmm',
                             B2 = 'glm_binomial_logit', c2 = 'lmm'))

})
