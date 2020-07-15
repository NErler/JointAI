context("Survival Models")
library("JointAI")
library("survival")



test_that('Joint model with ordinal covariate works', {
  test <- JM_imp(list(Surv(futime, status != 'alive') ~ stage + age + sex,
                      stage ~ age + sex + (1 | id)),
                 data = PBC, timevar = "day",
                 n.adapt = 3, n.iter = 3, warn = FALSE)

  expect_s3_class(test, class = "JointAI")
})
