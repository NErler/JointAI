# predict_glm() for Poisson models, without JAGS: the MCMC sample is a matrix
# of chosen coefficient values, so that the expected predictions are known.

poisson_data <- data.frame(
  cnt = c(0, 1, 0, 2, 1, 0, 1, 3, 0, 1),
  x = c(-2, -1.5, -1, -0.5, 0, 0.25, 0.5, 1, 1.5, 2)
)

poisson_args <- function(link = "log", MCMC) {
  list(
    formula = cnt ~ x,
    newdata = poisson_data,
    type = "response",
    data = poisson_data,
    MCMC = MCMC,
    varname = "cnt",
    coef_list = list(
      cnt = data.frame(
        coef = c("beta[1]", "beta[2]"),
        varname = c("(Intercept)", "x")
      )
    ),
    info_list = list(cnt = list(family = "poisson", link = link)),
    contr_list = setNames(list(), character(0)),
    Mlist = list(scale_pars = NULL)
  )
}

coef_sample <- function(...) {
  MCMC <- rbind(...)
  colnames(MCMC) <- c("beta[1]", "beta[2]")
  MCMC
}

test_that("Poisson response predictions are the expected counts (log link)", {
  # a constant sample at the glm() estimates must reproduce glm()
  fit_glm <- glm(cnt ~ x, family = poisson(), data = poisson_data)
  MCMC <- coef_sample(coef(fit_glm), coef(fit_glm), coef(fit_glm))

  res <- do.call(predict_glm, poisson_args(MCMC = MCMC))$res_df

  expect_equal(
    res$fit,
    unname(predict(fit_glm, type = "response")),
    tolerance = 1e-10
  )
})

test_that("Poisson response predictions are the expected counts (identity link)", {
  MCMC <- coef_sample(c(1.3, 0.2), c(1.5, 0.1))

  res <- do.call(predict_glm, poisson_args("identity", MCMC))$res_df

  expect_equal(res$fit, 1.4 + 0.15 * poisson_data$x, tolerance = 1e-10)
})

test_that("Poisson response predictions lie within their quantiles", {
  MCMC <- coef_sample(c(-0.9, 0.2), c(-0.7, 0.3), c(-0.8, 0.4))

  res <- do.call(predict_glm, poisson_args(MCMC = MCMC))$res_df

  expect_true(all(res$fit >= res[["2.5%"]] & res$fit <= res[["97.5%"]]))
})

test_that("the returned sample of Poisson response predictions is not rounded", {
  MCMC <- coef_sample(c(-0.9, 0.2), c(-0.7, 0.3))

  args <- c(poisson_args(MCMC = MCMC), return_sample = TRUE)
  s <- do.call(predict_glm, args)$sample

  X <- cbind(1, poisson_data$x)
  expect_equal(sort(s$value), sort(c(exp(MCMC %*% t(X)))), tolerance = 1e-10)
})
