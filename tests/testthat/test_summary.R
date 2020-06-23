context("Summaries")
library("JointAI")

mymod <- lme_imp(y ~ C1 + c1 + B2 + c2 + O2 + time + (time  | id), data = longDF,
                 n.adapt = 10, n.iter = 50)

test_that("main summary functions", {

  expect_s3_class(summary(mymod), 'summary.JointAI')
  expect_type(coef(mymod), 'list')
  expect_type(confint(mymod), 'list')
  expect_output(print(mymod))
  expect_type(coef(summary(mymod)), 'list')

})

test_that('print functions', {
  expect_output(list_models(mymod))
  expect_s3_class(parameters(mymod), 'data.frame')
})
