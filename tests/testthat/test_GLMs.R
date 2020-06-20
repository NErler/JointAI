context("glm's")
library("JointAI")

test_that("intercept only GLMs", {
  expect_equal(class(lm_imp(y ~ 1, data = wideDF)), 'JointAI')
  expect_equal(class(glm_imp(B1 ~ 1, data = wideDF, family = 'binomial')),
               "JointAI")
  expect_equal(class(glm_imp(C1 ~ 1, data = wideDF,
                             family = Gamma(link = 'log'))),
               "JointAI")
  expect_equal(class(clm_imp(O1 ~ 1, data = wideDF)), "JointAI")
})


test_that("models work", {
  testthat::skip_on_cran()
  expect_equal(class(lm_imp(y ~ M2 + O2 * abs(C1 - C2) + log(C1),
                            data = wideDF)),
               'JointAI')

  expect_equal(class(glm_imp(B1 ~ M2 + O2 * abs(C1 - C2) +  log(C1),
                             data = wideDF, family = 'binomial')), "JointAI")

  expect_equal(class(glm_imp(C1 ~ M2 + O2 * abs(y - C2), data = wideDF,
                             family = Gamma(link = 'log'))),
               "JointAI")

  expect_equal(class(clm_imp(O1 ~ M2 + O2 * abs(C1 -C2) + log(C1),
                             data = wideDF)), "JointAI")
})


test_that('non-standard imputation models', {
  testthat::skip_on_cran()
  expect_equal(class(lm_imp(SBP ~ age + gender + log(bili) + exp(creat),
                            trunc = list(bili = c(1e-5, 1e10)),
                            data = NHANES, mess = FALSE)), "JointAI")

  expect_equal(class(lm_imp(SBP ~ age + gender + log(bili) + exp(creat),
                            models = c(bili = 'lognorm', creat = 'lm'),
                            data = NHANES, mess = FALSE)), "JointAI")

  expect_equal(class(lm_imp(SBP ~ age + gender + log(bili) + exp(creat),
                            models = c(bili = 'glm_gamma_inverse',
                                       creat = 'lm'),
                            data = NHANES, mess = FALSE)), "JointAI")

})

