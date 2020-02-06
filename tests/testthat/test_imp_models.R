context("(Imputation) models")
library("JointAI")

test_that("no models when no missing values", {
  expect_equal(get_models(fixed = y ~ C1 + B1 + M1 + O1, data = wideDF),
               c(y = 'lm'))

  expect_equal(get_models(fixed = y ~ 1, data = wideDF),
               c(y = 'lm'))

  expect_equal(get_models(fixed = y ~ C1 + c1 + o1, data = longDF),
               c(y = 'lm'))

  expect_equal(get_models(fixed = y ~ C1 + c1 + o1 + time,
                          random = ~ 1|id, data = longDF),
               c(y = 'lmm'))

  expect_equal(get_models(fixed = y ~ C1 * c1 + o1 + time,
                          random = ~ time * o1|id, auxvars = ~B1,
                          data = longDF),
               c(y = 'lmm'))
})


test_that('model included when specified via models', {
  expect_equal(get_models(fixed = y ~ C1 + B1 + O1, data = wideDF,
                          models = c(B1 = 'logit')),
               c(y = 'lm', B1 = 'logit'))
})


test_that("error when unknown variable or missing part", {
  expect_error(get_models(fixed = y ~ Bb1 + M1 + O1, data = wideDF))

  expect_error(get_models(fixed = y ~ B1 + M1 + O1, data = wideDF, auxvars = 'other'))
  expect_error(get_models(fixed = y ~ B1 + M1 + O1, data = wideDF, auxvars = ~other))

  expect_error(get_models(fixed = y ~ B1 + M1 + O1, data = longDF,
                          random = ~1 |subj))
  expect_error(get_models(fixed = y ~ B1 + M1 + O1))
  expect_error(get_models(data = longDF, random = ~1 |subj, auxvars = ~ C2))
})


test_that("models for compl. long. variables are included ONLY when a baseline variable is missing", {
  expect_equal(get_models(fixed = y ~ c1 + C1, random = ~ time | id, data = longDF),
               c(y = 'lmm'))

  expect_equal(get_models(fixed = y ~ c1 + time + c2 + C1,
                          random = ~ time | id, data = longDF),
               c(y = 'lmm', c2 = 'lmm'))

  expect_equal(get_models(fixed = y ~ c1 + time + C2,
                          random = ~ time | id, data = longDF),
               c(y = 'lmm', c1 = 'lmm', time = 'lmm', C2 = 'lm'))

  expect_equal(get_models(fixed = y ~ c1 + time + c2 + C2,
                          random = ~ time | id, data = longDF),
               c(y = 'lmm', c2 = 'lmm', c1 = 'lmm', time = 'lmm', C2 = 'lm'))
})


test_that("no_model excludes the model, unless incomplete", {
  expect_equal(get_models(fixed = y ~ c1 + C1, random = ~ time | id, data = longDF, no_model = 'time'),
               c(y = 'lmm'))

  expect_equal(get_models(fixed = y ~ c1 + time + c2 + C1, no_model = 'time',
                          random = ~ time | id, data = longDF),
               c(y = 'lmm', c2 = 'lmm'))

  expect_error(get_models(fixed = y ~ c1 + time + c2 + C2, no_model = 'c2',
                          random = ~ time | id, data = longDF))
})


test_that("correct imputation methods are chosen", {
  expect_equal(get_models(fixed = y ~ c1 + C1 + M2 + O2 + C2 + c2,
                          random = ~ b1 + B2 + time | id, data = longDF, no_model = 'time'),
               c(y = 'lmm', c2 = 'lmm', c1 = 'lmm', b1 = 'glmm_binomial_logit',
                 M2 = 'mlogit', C2 = 'lm', O2 = 'clm', B2 = 'glm_binomial_logit'))

  expect_equal(get_models(fixed = y ~ c1 + C1 + M2 + O2 + C2 + c2 + o2,
                          random = ~ b1 + B2 + time | id, data = longDF, no_model = 'time'),
               c(y = 'lmm', c2 = 'lmm', o2 = 'clmm', c1 = 'lmm', b1 = 'glmm_binomial_logit',
                 M2 = 'mlogit', C2 = 'lm', O2 = 'clm', B2 = 'glm_binomial_logit'))


  expect_error(get_models(fixed = y ~ c1 + C1 + o1 + m2 + M2 + O2 + C2 + c2,
                          random = ~ b1 + B2 + time | id, data = longDF, no_model = 'time'))
})

test_that("auxvars are included", {
  expect_equal(get_models(fixed = y ~ c1 + C2, auxvars = ~ C1 + B2 + b1,
                          random = ~ time | id, data = longDF,
                          no_model = 'time'),
               c(y = 'lmm', c1 = 'lmm', b1 = 'glmm_binomial_logit', C2 = 'lm', B2 = 'glm_binomial_logit')
  )
})


test_that("splines in random effects give an error when a model is needed for that variable", {
  library(splines)
  expect_equal(get_models(fixed = y ~ c1 + C1 + ns(time, df = 2),
                          random = ~ ns(time, df = 2) | id, data = longDF),
               c(y = 'lmm')
  )

  expect_equal(get_models(fixed = y ~ c1 + C1 + C2 + ns(time, df = 2),
                          random = ~ ns(time, df = 2) | id, data = longDF,
                          no_model = 'time'),
               c(y = 'lmm', c1 = 'lmm', C2 = 'lm')
  )

  expect_equal(get_models(fixed = y ~ c1 + C1 + C2 + ns(time, df = 2),
                          random = ~ ns(time, df = 2) | id, data = longDF),
               c(y = 'lmm', c1 = 'lmm', time = 'lmm', C2 = 'lm')
  )


  expect_equal(get_models(fixed = y ~ c1 + C1 + C2 + ns(time, df = 2),
                          random = ~ time + I(time^2) | id, data = longDF,
                          no_model = 'time'),
               c(y = 'lmm', c1 = 'lmm', C2 = 'lm')
  )
})


# test_that("all longitudinal variables are included when the analysis model is a JM", {
#   library(survival)
#   expect_equal(get_models(fixed = Surv(futime, status == 2) ~ age + sex + bili, random = ~ 1|id,
#                           data = pbcseq, analysis_type = 'coxph'),
#                c('Surv(futime, status == 2)' = 'coxph'))
#
#   expect_equal(get_models(fixed = Surv(futime , status == 2) ~ age + sex + bili,
#                           random = ~ 1|id, analysis_type = 'JM',
#                           data = pbcseq),
#                c('Surv(futime, status == 2)' = 'JM'))
#
#   expect_equal(get_models(fixed = Surv(futime, status == 2) ~ age + sex + bili + chol,
#                           random = ~ 1|id, analysis_type = 'JM',
#                           data = pbcseq),
#                c('Surv(futime, status == 2)' = 'JM', chol = 'lmm'))
#
#   expect_equal(get_models(fixed = Surv(futime, status == 2) ~ age + sex + bili + chol,
#                           random = ~ 1|id,
#                           data = pbcseq, analysis_type = 'survreg'),
#                c('Surv(futime, status == 2)' = 'survreg', chol = 'lmm'))
#
#   expect_equal(get_models(fixed = Surv(futime, status == 2) ~ age + sex + bili + chol + day,
#                           random = ~ 1|id, analysis_type = 'JM',
#                           data = pbcseq),
#                c('Surv(futime, status == 2)' = 'JM', chol = 'lmm'))
#
#   expect_equal(get_models(fixed = Surv(futime , status) ~ age + sex + bili + chol + day,
#                           random = ~ 1|id, analysis_type = 'JM',
#                           data = pbcseq, timevar = 'day'),
#                list(models = c(bili = 'lmm', chol = 'lmm'),
#                     meth = c(chol = 'lmm')))
# })



