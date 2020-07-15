context("Beta Regression")
library("JointAI")


wideDF$x <- plogis(wideDF$y)
longDF$x <- plogis(longDF$y)

test_that('minimal models work', {
  # no covariates
  expect_s3_class(betamm_imp(x ~ 1 + (1 | id), data = longDF, n.adapt = 1),
                  'JointAI')

  # one complete covariate
  expect_s3_class(betamm_imp(x ~ C1 + (1 | id), data = longDF, n.adapt = 1),
                  'JointAI')

  # one incomplete covariate
  expect_s3_class(betamm_imp(x ~ C2 + (1 | id), data = longDF, n.adapt = 1),
                  'JointAI')

  # no intercept
  expect_s3_class(betareg_imp(x ~ C1 - 1, data = wideDF, n.adapt = 1), 'JointAI')
  expect_s3_class(betamm_imp(x ~ C1 - 1 + (1 | id), data = longDF, n.adapt = 1),
                  'JointAI')

  # no random intercept
  expect_s3_class(betamm_imp(x ~ C1 - 1 + (time + 0 | id), data = longDF,
                             n.adapt = 1), 'JointAI')
})


test_that('parameter selection work', {
  mod <- betareg_imp(x ~ C1 + B2 + O1 + C2, data = wideDF, n.iter = 2, n.adapt = 1)
  expect_equal(mod$mcmc_settings$variable.names, c('beta', 'tau_x'))

  mod2 <- betareg_imp(x ~ C1 + B2 + O1 + C2, data = wideDF, n.adapt = 0,
                      monitor_params = c(analysis_main = TRUE, tau_main = FALSE))
  expect_equal(mod2$mcmc_settings$variable.names, c('beta'))

  mod3 <- betareg_imp(x ~ C1 + B2 + O1 + C2, data = wideDF, n.adapt = 0,
                      monitor_params = c(tau_main = TRUE, analysis_main = FALSE,
                                         sigma_main = TRUE))
  expect_equal(mod3$mcmc_settings$variable.names, c('tau_x'))

})
