context("Survival Models")
library("JointAI")
library("survival")

test_that('survreg models work', {
  expect_s3_class(survreg_imp(Surv(time, status) ~ 1, data = lung,
                              n.iter = 10),
                  class = 'JointAI')

  expect_s3_class(survreg_imp(Surv(stop, I(status > 0)) ~ 1,
                              data = bladder1[bladder1$stop > 0, ],
                              n.iter = 10),
                  class = 'JointAI')

  expect_s3_class(survreg_imp(Surv(time, status) ~ wt.loss + meal.cal +
                                ph.ecog, data = lung, n.iter = 10),
                  class = 'JointAI')

  expect_s3_class(survreg_imp(Surv(time, status) ~ wt.loss * meal.cal +
                                ph.ecog*sex + I(age^2),
                              auxvars = ~ ph.karno, data = lung, n.iter = 10),
                  class = 'JointAI')
})


test_that('coxph models work', {
  expect_s3_class(coxph_imp(Surv(time, status) ~ 1, data = lung, n.iter = 10),
                  class = 'JointAI')

  expect_s3_class(coxph_imp(Surv(stop, I(status > 0)) ~ 1,
                            data = bladder1[bladder1$stop > 0, ], n.iter = 10),
                  class = 'JointAI')

  expect_s3_class(coxph_imp(Surv(time, status) ~ wt.loss + meal.cal + ph.ecog,
                            data = lung, n.iter = 10),
                  class = 'JointAI')

  expect_s3_class(coxph_imp(Surv(time, status) ~ wt.loss * meal.cal +
                              ph.ecog*sex + I(age^2),
                              auxvars = ~ ph.karno, data = lung, n.iter = 10),
                  class = 'JointAI')

})
