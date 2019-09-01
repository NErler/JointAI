context("Longitudinal Models")
library("JointAI")


test_that("model with no covariates work", {
  expect_equal(class(lme_imp(y ~ 1, random = ~1|id, data = longDF)), "JointAI")
  expect_equal(class(glme_imp(b1 ~ 1, random = ~1|id, data = longDF,
                              family = 'binomial')), "JointAI")
  expect_equal(class(glme_imp(p1 ~ 1, random = ~1|id, data = longDF,
                              family = poisson())), "JointAI")
  expect_equal(class(clmm_imp(o1 ~ 1, random = ~1|id, data = longDF)), "JointAI")
})


test_that("models with standard random effects structure work", {
  testthat::skip_on_cran()
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
                random = ~ time + I(time^2)|id, data = longDF, no_model = 'time')),
               "JointAI")

  expect_equal(class(lme_imp(y ~ M2 + O2 * abs(C1 -C2) + log(C1) + time,
                             random = ~ time + I(time^2)|id, data = longDF)),
               "JointAI")
})

test_that('models with spline random effects work', {
  testthat::skip_on_cran()
  library(splines)
  expect_equal(class(lme_imp(y ~ ns(time, df = 2),
                             random = ~ ns(time, df = 2)|id,
                             data = longDF)),
               "JointAI")

  expect_equal(class(lme_imp(y ~ bs(time, df = 3),
                             random = ~ bs(time, df = 3)|id,
                             data = longDF)),
               "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + c1 + ns(time, df = 3),
                             random = ~ ns(time, df = 3)|id,
                             data = longDF)),
               "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + C2 + c1 + ns(time, df = 3),
                             random = ~ time|id,
                             data = longDF)),
               "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + C2 + c1 + ns(time, df = 3),
                             random = ~ ns(time, df = 3)|id,
                             data = longDF, no_model = 'time')),
               "JointAI")

  testmod <- lme_imp(y ~ C1 + C2 + c1 + ns(time, df = 3),
                  random = ~ time|id,
                  data = longDF)

  expect_equal(testmod$K, matrix(nrow = 5, ncol = 2, byrow = TRUE,
                                 data = c(1, 3, rep(NA, 4), 4, 7, rep(NA, 2)),
                                 dimnames = list(c('Xc', 'Xic', 'time', 'Xl', 'Xil'),
                                                 c("start", 'end')))
  )

  expect_equal(testmod$K_imp, matrix(nrow = 3, ncol = 2, byrow = TRUE,
                                     data = c(1, 2, 3, 5, 6, 9),
                                     dimnames = list(c('C2', 'c1', 'time'),
                                                     c("start", 'end')))
  )

  expect_equal(testmod$imp_par_list$c1$par_elmts,
               matrix(nrow = 2, ncol = 2, byrow = TRUE,
                      data = c(3, 5, rep(NA, 2)),
                      dimnames = list(c('Xc', 'Xl'),
                                      c("start", 'end')))
  )

  expect_equal(testmod$imp_par_list$time$par_elmts,
               matrix(nrow = 2, ncol = 2, byrow = TRUE,
                      data = c(6, 8, 9, 9),
                      dimnames = list(c('Xc', 'Xl'),
                                      c("start", 'end')))
  )

  # fixed <- y ~ C1 + C2 + c1 + ns(time, df = 3)
  # random = ~ ns(time, df = 3)|id
  # models <- get_models(fixed, random, data = longDF)$models
  # Mlist <- JointAI:::divide_matrices(data = longDF, fixed = fixed,
  #                                    analysis_type = 'lme', models = models)
  #
  # K <- JointAI:::get_model_dim(Mlist$cols_main, Mlist$hc_list)
  # K_imp <- JointAI:::get_imp_dim(models, JointAI:::get_imp_pos(models, Mlist), Mlist)


})

test_that("models with complex random effects structure work", {
  testthat::skip_on_cran()
  expect_equal(class(lme_imp(y ~ c1 + c2 + time, random = ~ time + c2|id,
                             no_model = 'time', data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ B2 * c1 + c2 + time, random = ~ time + c1|id,
                             data = longDF, no_model = 'time')), "JointAI")

  expect_equal(class(lme_imp(y ~ B2 * c1 + c2 + time, random = ~ time + c1|id,
                             data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF)), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF, no_model = 'time')), "JointAI")

  expect_equal(class(lme_imp(y ~ C1 + B2 * c1 + c2 + time, random = ~ time + c2|id,
                             data = longDF, no_model = c('time', 'c1'))), "JointAI")

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


test_that('glme_imp', {
  testthat::skip_on_cran()
  expect_equal(class(glme_imp(b1 ~ C1 + B1, random = ~1 | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_equal(class(glme_imp(b1 ~ C1 + B1 + time, random = ~1 | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_equal(class(glme_imp(b1 ~ C1 + B1 + time, random = ~time | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_equal(class(glme_imp(b1 ~ C2 + B1 + time, random = ~time | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_equal(class(glme_imp(b1 ~ C2 + B1 + time + c2 + c1, random = ~time | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_equal(class(glme_imp(b1 ~ C2 + B1 + time + c2 + c1 + b2, random = ~time | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_equal(class(glme_imp(b1 ~ C2 + B1 + time + c2 + c1 + o2, random = ~time | id, data = longDF,
                              family = 'binomial')), 'JointAI')

  expect_error(glme_imp(b1 ~ C2 + B1 + time + c2 + c1 + m2, random = ~time | id, data = longDF,
                        family = 'binomial'))

})



test_that('poisson imputation', {
  testthat::skip_on_cran()
  expect_equal(class(lme_imp(y ~ C1 + C2 + p2 + time, random = ~time|id, data = longDF,
                             models = c(p2 = "glmm_poisson"), n.iter = 100)),
               "JointAI")
})


test_that('ordinal mixed models', {
  expect_s3_class(clmm_imp(o1 ~ C1 * time + I(time^2) + b2 * c1, random = ~ time | id,
                           data = longDF, n.iter = 10), class = "JointAI")

  expect_s3_class(clmm_imp(o1 ~ 1, random = ~ 1|id, data = longDF, n.iter = 10),
                  class = "JointAI")

  expect_s3_class(clmm_imp(o1 ~ C1 + log(time) + I(time^2) + p1, random = ~ 1 | id,
                           data = longDF, n.iter = 10, ridge = TRUE, parallel = TRUE, n.cores = 2),
                  class = "JointAI")
})
