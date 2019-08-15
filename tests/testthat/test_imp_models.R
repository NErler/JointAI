context("(Imputation) models")
library("JointAI")

test_that("no models when no missing values", {
  expect_equal(get_models(fixed = y ~ C1 + B1 + M1 + O1, data = wideDF),
               list(models = NULL, meth = NULL))

  expect_equal(get_models(fixed = y ~ 1, data = wideDF),
               list(models = NULL, meth = NULL))

  expect_equal(get_models(fixed = y ~ C1 + c1 + o1, data = longDF),
               list(models = NULL, meth = NULL))

  expect_equal(get_models(fixed = y ~ C1 + c1 + o1 + time,
                          random = ~ 1|id, data = longDF),
               list(models = NULL, meth = NULL))

  expect_equal(get_models(fixed = y ~ C1 * c1 + o1 + time,
                          random = ~ time * o1|id, auxvars = ~B1,
                          data = longDF),
               list(models = NULL, meth = NULL))
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
               list(models = NULL, meth = NULL))

  expect_equal(get_models(fixed = y ~ c1 + time + c2 + C1,
                          random = ~ time | id, data = longDF),
               list(models = c(c2 = 'lmm'), meth = c(c2 = 'lmm')))

  expect_equal(get_models(fixed = y ~ c1 + time + C2,
                          random = ~ time | id, data = longDF),
               list(models = c(C2 = 'norm', c1 = 'lmm', time = 'lmm'),
                    meth = c(C2 = 'norm')))

  expect_equal(get_models(fixed = y ~ c1 + time + c2 + C2,
                          random = ~ time | id, data = longDF),
               list(models = c(C2 = 'norm', c1 = 'lmm', time = 'lmm', c2 = 'lmm'),
                    meth = c(C2 = 'norm', c2 = 'lmm')))
})


test_that("no_model excludes the model, unless incomplete", {
  expect_equal(get_models(fixed = y ~ c1 + C1, random = ~ time | id, data = longDF, no_model = 'time'),
               list(models = NULL, meth = NULL))

  expect_equal(get_models(fixed = y ~ c1 + time + c2 + C1, no_model = 'time',
                          random = ~ time | id, data = longDF),
               list(models = c(c2 = 'lmm'), meth = c(c2 = 'lmm')))

  expect_error(get_models(fixed = y ~ c1 + time + c2 + C2, no_model = 'c2',
                          random = ~ time | id, data = longDF))
})


test_that("correct imputation methods are chosen", {
  expect_equal(get_models(fixed = y ~ c1 + C1 + M2 + O2 + C2 + c2,
                          random = ~ b1 + B2 + time | id, data = longDF, no_model = 'time'),
               list(models = c(B2 = 'logit', O2 = 'cumlogit', C2 = 'norm',  M2 = 'multilogit',
                               c1 = 'lmm', b1 = 'glmm_logit',
                               c2 = 'lmm'),
                    meth = c(B2 = 'logit', O2 = 'cumlogit', C2 = 'norm',  M2 = 'multilogit',
                             c2 = 'lmm')))

  expect_equal(get_models(fixed = y ~ c1 + C1 + M2 + O2 + C2 + c2 + o2,
                          random = ~ b1 + B2 + time | id, data = longDF, no_model = 'time'),
               list(models = c(B2 = 'logit', O2 = 'cumlogit', C2 = 'norm', M2 = 'multilogit',
                               c1 = 'lmm', b1 = 'glmm_logit', o2 = 'clmm',
                               c2 = 'lmm'),
                    meth = c(B2 = 'logit', O2 = 'cumlogit', C2 = 'norm', M2 = 'multilogit',
                             o2 = 'clmm', c2 = 'lmm')))


  expect_error(get_models(fixed = y ~ c1 + C1 + o1 + m2 + M2 + O2 + C2 + c2,
                          random = ~ b1 + B2 + time | id, data = longDF, no_model = 'time'))
})

test_that("auxvars are included", {
  expect_equal(get_models(fixed = y ~ c1 + C2, auxvars = ~ C1 + B2 + b1,
                          random = ~ time | id, data = longDF,
                          no_model = 'time'),
               list(models = c(B2 = 'logit', C2 = 'norm', c1 = 'lmm', b1 = 'glmm_logit'),
                    meth = c(B2 = 'logit', C2 = 'norm'))
  )
})


test_that("splines in random effects give an error when a model is needed for that variable", {
  library(splines)
  expect_equal(get_models(fixed = y ~ c1 + C1 + ns(time, df = 2),
                          random = ~ ns(time, df = 2) | id, data = longDF),
               list(models = NULL, meth = NULL)
  )

  expect_equal(get_models(fixed = y ~ c1 + C1 + C2 + ns(time, df = 2),
                          random = ~ ns(time, df = 2) | id, data = longDF,
                          no_model = 'time'),
               list(models = c(C2 = 'norm', c1 = 'lmm'), meth = c(C2 = 'norm'))
  )

  expect_equal(get_models(fixed = y ~ c1 + C1 + C2 + ns(time, df = 2),
                          random = ~ ns(time, df = 2) | id, data = longDF),
               list(models = c(C2 = 'norm', c1 = 'lmm', time = 'lmm'),
                    meth = c(C2 = 'norm'))
  )


  expect_equal(get_models(fixed = y ~ c1 + C1 + C2 + ns(time, df = 2),
                          random = ~ time + I(time^2) | id, data = longDF,
                          no_model = 'time'),
               list(models = c(C2 = 'norm', c1 = 'lmm'), meth = c(C2 = 'norm'))
  )
})

