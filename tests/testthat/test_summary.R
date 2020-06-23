context("Summaries")
library("JointAI")

mod <- lme_imp(y ~ C1 + c1 + B2 + c2 + O2 + time + (time  | id), data = longDF,
               n.adapt = 10, n.iter = 50)


test_that("main summary functions", {
  expect_s3_class(summary(mod), 'summary.JointAI')
  expect_type(coef(mod), 'list')
  expect_type(confint(mod), 'list')
  expect_type(coef(summary(mod)), 'list')
  expect_output(mod)
})


test_that('print functions work', {
  expect_output(list_models(mod))
  expect_s3_class(parameters(mod), 'data.frame')
})
