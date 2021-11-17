library("JointAI")

if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  test_that('Joint model with ordinal covariate works', {
    test <- JM_imp(list(Surv(futime, status != 'censored') ~ stage + age + sex,
                        stage ~ age + sex + day + (day | id)),
                   data = PBC, timevar = "day",
                   n.adapt = 3, n.iter = 3, warn = FALSE, seed = 2020,
                   mess = FALSE)

    expect_s3_class(test, class = "JointAI")
  })

  test_that('JM', {
    mod <- JM_imp(list(Surv(futime, status != "censored") ~ age + sex + chol +
                         stage + hepato + (1 | id),
                       hepato ~ day + (1 | id),
                       chol ~ day + (1 | id),
                       stage ~ age + (1 | id)),
                  timevar = 'day', data = JointAI::PBC,
                  warn = FALSE, n.iter = 5, n.adapt = 2)
    expect_s3_class(mod, 'JointAI')
    expect_output(list_models(mod))
    expect_s3_class(parameters(mod), 'data.frame')
    expect_s3_class(summary(mod), 'summary.JointAI')
  })


  test_that("fill_locf works", {
    locfdat <- JointAI:::fill_locf(data = JointAI::PBC,
                                   fixed = list(Surv(futime, status != "censored") ~
                                                  age + sex + hepato + platelet),
                                   auxvars = NULL,
                                   random = ~ 1 | id, timevar = 'day',
                                   groups = JointAI:::get_groups('id',
                                                                 JointAI::PBC))

    expect_s3_class(locfdat, 'data.frame')
    expect_equal(colSums(is.na(locfdat[, c('hepato', 'platelet')])),
                 c('hepato' = 0, 'platelet' = 0))
  })
}
