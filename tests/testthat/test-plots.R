library("JointAI")


test_that('plots', {
  newDF <- longDF
  newDF$dat <- Sys.Date() - c(1:nrow(newDF))

  expect_silent({par(mar = c(2,2,1,0.1));
                plot_all(newDF, idvars = 'id', breaks = 50, ncol = 5)})
})

test_that('plot_imp_distr', {
  mod <- lme_imp(y ~ C1 + c2 + B2 + C2, random = ~ 1 | id, data = longDF,
                 n.iter = 100, monitor_params = c(imps = TRUE),
                 mess = FALSE, seed = 200)
  impDF <- get_MIdat(mod, m = 5, minspace = 1)

  expect_s3_class(get_MIdat(mod, m = 5, minspace = 1), 'data.frame')

  if ("ggpubr" %in% installed.packages()[, "Package"]) {
    expect_s3_class(plot_imp_distr(impDF, id = "id", ncol = 3), 'ggplot')
  } else {
    expect_null(plot_imp_distr(impDF, id = "id", ncol = 3))
  }
})



test_that('md_pattern', {
  expect_is(md_pattern(wideDF, plot = FALSE, pattern = TRUE), 'matrix')
  expect_silent(md_pattern(wideDF))
})
