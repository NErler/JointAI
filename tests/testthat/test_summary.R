context("Summaries")
library("JointAI")

mymod <- lme_imp(y ~ C1 + c1 + B2 + c2 + O2 + time + (time  | id),
                 data = longDF, n.adapt = 10, n.iter = 10,
                 monitor_parms = c(other_models = TRUE),
                 parallel = TRUE, n.cores = 2, n.chains = 2,
                 keep_scaled_mcmc = TRUE, seed = 2020, warn = FALSE)


test_that("main summary functions", {

  expect_s3_class(summary(mymod, missinfo = TRUE), 'summary.JointAI')
  expect_type(coef(mymod), 'list')
  expect_type(confint(mymod), 'list')
  expect_output(print(mymod))
  expect_type(coef(summary(mymod)), 'list')

})

test_that('plots', {
  newDF <- longDF
  newDF$dat <- Sys.Date() - c(1:nrow(newDF))
  # newDF$dat2 <- as.POSIXct.Date(Sys.Date() - c(1:nrow(newDF)))

  expect_silent(traceplot(mymod, thin = 2))
  expect_silent(densplot(mymod))
  expect_s3_class(traceplot(mymod, use_ggplot = TRUE), 'ggplot')
  expect_s3_class(densplot(mymod, use_ggplot = TRUE, start = 11, end = 19),
                  'ggplot')
  expect_s3_class(densplot(mymod, use_ggplot = TRUE, joined = TRUE), 'ggplot')
  expect_silent({par(mar = c(2,2,1,0.1));
                plot_all(newDF, idvars = 'id', breaks = 50, ncol = 5)})
  expect_silent(plot(MC_error(mymod)))
})

test_that('print functions', {
  expect_output(list_models(mymod))
  expect_s3_class(parameters(mymod), 'data.frame')
})


test_that('subset', {
  expect_s3_class(summary(mymod, subset = c(other_models = TRUE,
                                            analysis_main = FALSE)),
                  'summary.JointAI')
  expect_output(print(summary(mymod)))
})

test_that('longmodel', {
  longDF$x <- factor(longDF$o1, ordered = FALSE)
  mmod <- mlogitmm_imp(x ~ C1 + p1 + B2 + O2 + c2 + y * time + (time | id),
                       data = longDF,
                       n.adapt = 10, n.iter = 10,
                       monitor_parms = c(other_models = TRUE),
                       parallel = TRUE, n.cores = 2, n.chains = 2,
                       models = c(p1 = 'glmm_poisson_log'),
                       refcats = c(O2 = 3), warn = FALSE)
  expect_s3_class(mmod, 'JointAI')
  expect_output(list_models(mmod))
  expect_s3_class(parameters(mmod), 'data.frame')
})



test_that('plot_imp_distr', {
  mod <- lme_imp(y ~ C1 + c2 + B2 + C2, random = ~ 1 | id, data = longDF,
                 n.iter = 100, monitor_params = c(imps = TRUE),
                 mess = FALSE, seed = 200)
  impDF <- get_MIdat(mod, m = 5, minspace = 1)

  expect_s3_class(get_MIdat(mod, m = 5, minspace = 1), 'data.frame')
  expect_s3_class(plot_imp_distr(impDF, id = "id", ncol = 3), 'ggplot')
})


test_that('JM', {
  mod <- JM_imp(list(Surv(futime, status) ~ age + sex + chol + stage + hepato + (1 | id),
                     hepato ~ day + (1 | id),
                     chol ~ day + (1 | id),
                     stage ~ age + (1 | id)),
                timevar = 'day', data = JointAI::PBC, n.iter = 5, n.adapt = 2)
  expect_s3_class(mod, 'JointAI')
  expect_output(list_models(mod))
  expect_s3_class(parameters(mod), 'data.frame')
  expect_s3_class(summary(mod), 'summary.JointAI')
})

test_that('md_pattern', {
  expect_is(md_pattern(wideDF, plot = FALSE, pattern = TRUE), 'matrix')
  expect_silent(md_pattern(wideDF))
})


test_that("fill_locf works", {
  locfdat <- JointAI:::fill_locf(data = JointAI::PBC,
                                 fixed = list(Surv(futime, status) ~
                                                age + sex + hepato + platelet),
                                 auxvars = NULL,
                                 random = ~ 1 | id, timevar = 'day',
                                 groups = JointAI:::get_groups('id',
                                                               JointAI::PBC))

  expect_s3_class(locfdat, 'data.frame')
  expect_equal(colSums(is.na(locfdat[, c('hepato', 'platelet')])),
               c('hepato' = 0, 'platelet' = 0))
})
