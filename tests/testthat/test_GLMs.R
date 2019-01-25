context("glm's")
library("JointAI")

test_that("intercept only models", {
  expect_equal(class(lm_imp(y ~ 1, data = wideDF)), 'JointAI')
  expect_equal(class(glm_imp(B1 ~ 1, data = wideDF, family = 'binomial')),
               "JointAI")
  expect_equal(class(glm_imp(C1 ~ 1, data = wideDF, family = Gamma(link = 'log'))),
               "JointAI")
  expect_equal(class(clm_imp(O1 ~ 1, data = wideDF)), "JointAI")
})


test_that("models work", {
  expect_equal(class(lm_imp(y ~ M2 + O2 * abs(C1 - C2) +  log(C1), data = wideDF)),
               'JointAI')

  expect_equal(class(glm_imp(B1 ~ M2 + O2 * abs(C1 - C2) +  log(C1),
                             data = wideDF, family = 'binomial')), "JointAI")

  expect_equal(class(glm_imp(C1 ~ 1, data = wideDF, family = Gamma(link = 'log'))),
               "JointAI")

  expect_equal(class(clm_imp(O1 ~ M2 + O2 * abs(C1 -C2) + log(C1),
                             data = wideDF)), "JointAI")
})

