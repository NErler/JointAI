# The model information per sub-model (get_model_info(), get_model1_info() and
# their helpers in R/get_model_info.R). The models are set up but not sampled
# (n.adapt = 0, n.iter = 0). Overview of what is tested:
# dev/GET_MODEL_INFO.md (local notes).

skip_on_cran()

# set up a model without MCMC sampling
setup_model <- function(fun, ...) {
  suppressWarnings(fun(
    ...,
    n.adapt = 0,
    n.iter = 0,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  ))
}

# family and link --------------------------------------------------------------
test_that("binomial models with cloglog link use the cloglog link", {
  expect_identical(get_link("glm_binomial_cloglog"), "cloglog")
  expect_identical(get_link("glmm_binomial_cloglog"), "cloglog")

  mod <- setup_model(
    glme_imp,
    b1 ~ 1 + (1 | id),
    family = binomial(link = "cloglog"),
    data = longDF
  )
  expect_identical(mod$info_list$b1$link, "cloglog")
  expect_match(mod$jagsmodel, "cloglog(mu_b1[i])", fixed = TRUE)
})
