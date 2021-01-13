library("JointAI")

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
