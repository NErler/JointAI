context("add_samples")
library("JointAI")

test_that('add_samples works in simple setting',{
  lm1 <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 50)
  expect_s3_class(add_samples(lm1, add = TRUE, n.iter = 50), class = "JointAI")
  expect_s3_class(add_samples(lm1, add = FALSE, n.iter = 50), class = "JointAI")
  expect_error(add_samples(lm1, add = TRUE, monitor_params = c(imps = TRUE),
                              n.iter = 50))
})

test_that('add_samples works in parallel', {
  future::plan(future::cluster, workers = 2)
  lm2 <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 50, parallel = TRUE,
                n.cores = 2)
  expect_s3_class(add_samples(lm2, add = TRUE, n.iter = 50), class = "JointAI")
  expect_s3_class(add_samples(lm2, add = FALSE, n.iter = 50), class = "JointAI")
  expect_error(add_samples(lm2, add = TRUE, monitor_params = c(imps = TRUE),
                           n.iter = 50))

  future::plan(future::sequential)
})


test_that('change thinning',{
  lm3 <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 150, thin = 3)
  expect_s3_class(add_samples(lm3, add = FALSE, n.iter = 50, thin = 2),
                  class = "JointAI")
  expect_message(add_samples(lm3, add = TRUE, n.iter = 50, thin = 2))
})
