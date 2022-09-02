library("JointAI")

skip_on_cran()

test_that('lme model', {
  mymod <- lme_imp(y ~ C1 + c1 + B2 + c2 + O2 + time + (time  | id),
                   data = longDF, n.adapt = 10, n.iter = 10,
                   monitor_parms = c(other_models = TRUE),
                   seed = 2020, warn = FALSE)

  expect_output(list_models(mymod))
  expect_s3_class(parameters(mymod), 'data.frame')
  expect_snapshot(list_models(mymod))
  expect_snapshot(parameters(mymod))
})


test_that('mlogitmm', {
  longDF$x <- factor(longDF$o1, ordered = FALSE)
  mmod <- mlogitmm_imp(x ~ C1 + p1 + B2 + O2 + c2 + y * time + (time | id),
                       data = longDF,
                       n.adapt = 10, n.iter = 10, seed = 2020,
                       monitor_parms = c(other_models = TRUE),
                       models = c(p1 = 'glmm_poisson_log'),
                       refcats = c(O2 = 3), warn = FALSE)

  expect_output(list_models(mmod))
  expect_s3_class(parameters(mmod), 'data.frame')
  expect_snapshot(list_models(mmod))
  expect_snapshot(parameters(mmod))
})
