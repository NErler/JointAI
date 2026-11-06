# Names in survival outcomes:
# * Surv() with named arguments, e.g. Surv(futime, event = event), is the same
#   model as Surv(futime, event).
# * A survival time whose name is part of the name of the id variable (t and
#   patient) in a model with time-varying covariates.

skip_on_cran()

pbc <- PBC[PBC$id %in% unique(PBC$id)[1:30], ]
pbc$event <- pbc$status != "censored"
pbc1 <- pbc[!duplicated(pbc$id), ]

test_that("survreg_imp(): Surv() with named arguments", {
  ref <- survreg_imp(
    Surv(futime, event) ~ age + sex,
    data = pbc1,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )

  fit_event <- survreg_imp(
    Surv(futime, event = event) ~ age + sex,
    data = pbc1,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )
  expect_equal(fit_event$jagsmodel, ref$jagsmodel)
  expect_equal(fit_event$data_list, ref$data_list)

  fit_both <- survreg_imp(
    Surv(time = futime, event = event) ~ age + sex,
    data = pbc1,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )
  expect_equal(fit_both$jagsmodel, ref$jagsmodel)
  expect_equal(fit_both$data_list, ref$data_list)

  fit_time2 <- survreg_imp(
    Surv(futime, time2 = event) ~ age + sex,
    data = pbc1,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )
  expect_equal(fit_time2$jagsmodel, ref$jagsmodel)
  expect_equal(fit_time2$data_list, ref$data_list)
})

test_that("coxph_imp(): Surv() with named arguments", {
  ref <- coxph_imp(
    Surv(futime, event) ~ age + sex,
    data = pbc1,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )
  fit <- coxph_imp(
    Surv(time = futime, event = event) ~ age + sex,
    data = pbc1,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )
  expect_equal(fit$jagsmodel, ref$jagsmodel)
  expect_equal(fit$data_list, ref$data_list)
})

test_that("JM_imp(): survival time t and id variable patient", {
  ref <- JM_imp(
    list(
      Surv(futime, event) ~ age + chol,
      chol ~ day + age + (day | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )

  # the same data, with the survival time named t and the id named patient
  dat <- pbc
  names(dat)[names(dat) == "futime"] <- "t"
  names(dat)[names(dat) == "id"] <- "patient"
  fit <- JM_imp(
    list(
      Surv(t, event) ~ age + chol,
      chol ~ day + age + (day | patient)
    ),
    timevar = "day",
    data = dat,
    n.adapt = 1,
    n.iter = 0,
    seed = 1,
    mess = FALSE
  )

  expect_s3_class(fit$model, "jags")
  # the same data list as with the other names (only names differ: of the
  # elements, and the row and column names)
  expect_equal(fit$data_list, ref$data_list, ignore_attr = TRUE)
})
