context("bugfixes's")
library("JointAI")

test_that("bugfix parameters for ordinal", {
  expect_equal(class(clm_imp(O1 ~ C1 + B1, data = wideDF)), "JointAI")
  expect_equal(class(clm_imp(O1 ~ 1, data = wideDF)), "JointAI")
  expect_equal(class(clm_imp(O1 ~ C1 + B1 + C2, data = wideDF)), "JointAI")
})


test_that("bugfix in model with ordinal longitudinal covariate", {
  newlongDF <- longDF
  newlongDF$x <- factor(sample(1:4, nrow(longDF), replace = TRUE),
                        ordered = TRUE)
  newlongDF$x[sample(1:nrow(longDF), 50)] <- NA
  expect_s3_class(lme_imp(y ~ C1 + o1 + o2 + x + time, random = ~ 1|id,
                          data = newlongDF), 'JointAI')
})

test_that('parmeters for clmm models without baseline covarites work', {
  expect_s3_class(lme_imp(y ~ o2 + o1 + c2 + b2, data = longDF,
                          random = ~ 1|id),
                  'JointAI')
})


test_that('two-part trafo is pasted correctly', {
  library(splines)
  expect_s3_class(lm_imp(SBP ~ ns(age, df = 2) + gender + I(bili^2) + I(bili^3),
                         data = NHANES),
                  'JointAI')
})
