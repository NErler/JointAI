# context("Summaries")
# library("JointAI")
#
#
#
# mymod <- lme_imp(y ~ C1 + c1 + B2 + c2 + O2 + time + (time  | id),
#                  data = longDF, n.adapt = 10, n.iter = 10,
#                  monitor_parms = c(other_models = TRUE),
#                  parallel = TRUE, n.cores = 2, n.chains = 2,
#                  keep_scaled_mcmc = TRUE, seed = 2020, warn = FALSE)
#
#
# test_that('plots', {
#   newDF <- longDF
#   newDF$dat <- Sys.Date() - c(1:nrow(newDF))
#   # newDF$dat2 <- as.POSIXct.Date(Sys.Date() - c(1:nrow(newDF)))
#
#   expect_silent({par(mar = c(2,2,1,0.1));
#                 plot_all(newDF, idvars = 'id', breaks = 50, ncol = 5)})
# })
#
# test_that('print functions', {
#   expect_output(list_models(mymod))
#   expect_s3_class(parameters(mymod), 'data.frame')
# })
#
#
# test_that('subset', {
#   expect_s3_class(summary(mymod, subset = c(other_models = TRUE,
#                                             analysis_main = FALSE)),
#                   'summary.JointAI')
#   expect_output(print(summary(mymod)))
# })
#
# test_that('longmodel', {
#   longDF$x <- factor(longDF$o1, ordered = FALSE)
#   mmod <- mlogitmm_imp(x ~ C1 + p1 + B2 + O2 + c2 + y * time + (time | id),
#                        data = longDF,
#                        n.adapt = 10, n.iter = 10,
#                        monitor_parms = c(other_models = TRUE),
#                        parallel = TRUE, n.cores = 2, n.chains = 2,
#                        models = c(p1 = 'glmm_poisson_log'),
#                        refcats = c(O2 = 3), warn = FALSE)
#   expect_s3_class(mmod, 'JointAI')
#   expect_output(list_models(mmod))
#   expect_s3_class(parameters(mmod), 'data.frame')
# })
#
#
#
# test_that('plot_imp_distr', {
#   mod <- lme_imp(y ~ C1 + c2 + B2 + C2, random = ~ 1 | id, data = longDF,
#                  n.iter = 100, monitor_params = c(imps = TRUE),
#                  mess = FALSE, seed = 200)
#   impDF <- get_MIdat(mod, m = 5, minspace = 1)
#
#   expect_s3_class(get_MIdat(mod, m = 5, minspace = 1), 'data.frame')
#   expect_s3_class(plot_imp_distr(impDF, id = "id", ncol = 3), 'ggplot')
# })
#
#
#
# test_that('md_pattern', {
#   expect_is(md_pattern(wideDF, plot = FALSE, pattern = TRUE), 'matrix')
#   expect_silent(md_pattern(wideDF))
# })
#
