context("Longitudinal Models")
library("JointAI")


test_that("model with no covariates", {
  expect_equal(class(lme_imp(y ~ 1, random = ~1|id, data = longDF)), "JointAI")
  expect_equal(class(glme_imp(b1 ~ 1, random = ~1|id, data = longDF,
                              family = 'binomial')), "JointAI")
  expect_equal(class(glme_imp(c2 ~ 1, random = ~1|id, data = longDF,
                              family = Gamma(link = 'log'))), "JointAI")
  expect_equal(class(clmm_imp(o1 ~ 1, random = ~1|id, data = longDF)), "JointAI")
})


test_that("models with simple random effects structure work"{
  expect_equal(class(lme_imp(y ~ c1 + c2 + C1 + C2 + O2 + M2,
                             random = ~1|id, data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1),
                             random = ~ 1|id, data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1),
                             random = ~ time|id, data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1) + time,
                             random = ~ time|id, data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1) + time + I(time^2),
                             random = ~ time|id, data = longDF, no_model = 'time')),
               "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1) + time + I(time^2),
                             random = ~ time|id, data = longDF)),
               "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1) + time,
                random = ~ time + I(time^2)|id, data = longDF, no_model= 'time')),
               "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1) + time,
                             random = ~ time + I(time^2)|id, data = longDF)),
               "JointAI")
})

test_that("models with complex random effects structure work"{
  expect_equal(class(lme_imp(y ~ c1 + c2 + time, random = ~ time + c2|id,
                             no_model = 'time', data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ B2 * c1 + c2 + time, random = ~ time + c1|id,
                             data = longDF, no_model = 'time')), "JointAI")

  expect_equal(class(lme_imp(y ~ B2 * c1 + c2 + time, random = ~ time + c1|id,
                             data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF)), "class")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF, no_model = 'time')), "class")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF, no_model = c('time', 'c1')), "class")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c2 + c1 + time,
                             random = ~ time + c1|id,  data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c2 + c1 + time, no_model = "time",
                             random = ~ time + c1|id,  data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c2 + c1 + time, random = ~ time + c2|id,
                             data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c2 + c1 + time, random = ~ time + c2|id,
                             data = longDF)), "JointAI", no_model = "time")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 * time, random = ~ time + I(time^2)|id,
                             data = longDF)), "JointAI")
})


