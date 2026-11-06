# Survival models (survreg, JM) with more than one random effect on a level
# above the subjects: a random intercept and a random slope of age per center.
# * The JAGS model compiles (it failed because the hyper-parameters of the
#   prior of the random effects covariance matrix were not in the data).
# * With fixed values of the parameters, JAGS computes the linear predictor
#   and the means of the random effects that the model should have.
# * With rd_vcov = "indep" (and no scaling), the covariances of the random
#   effects are zero.
# The re-scaling of these random effects is tested in test-scaling.R.

skip_on_cran()

# 60 subjects of PBC, in 5 centers; pbc1: one row per subject
pbc <- PBC[PBC$id %in% unique(PBC$id)[1:60], ]
pbc$center <- factor(as.integer(pbc$id) %% 5)
pbc$event <- pbc$status != "censored"
pbc1 <- pbc[!duplicated(pbc$id), ]

# each group number belongs to exactly one center and vice versa
expect_one_group_per_center <- function(group, center) {
  tab <- table(group, center) > 0
  expect_true(all(rowSums(tab) == 1) && all(colSums(tab) == 1))
}

for (rd_vcov in c("blockdiag", "indep")) {
  test_that(paste("survreg_imp() with a random slope per center:", rd_vcov), {
    fit <- survreg_imp(
      Surv(futime, event) ~ age + sex + (age | center),
      data = pbc1,
      rd_vcov = rd_vcov,
      n.adapt = 1,
      n.iter = 0,
      seed = 1,
      mess = FALSE,
      warn = FALSE
    )
    expect_s3_class(fit$model, "jags")
  })

  test_that(paste("JM_imp() with a random slope per center:", rd_vcov), {
    fit <- JM_imp(
      list(
        Surv(futime, event) ~ age + sex + chol + (age | center),
        chol ~ day + age + (day | id)
      ),
      timevar = "day",
      data = pbc,
      rd_vcov = rd_vcov,
      n.adapt = 1,
      n.iter = 0,
      seed = 1,
      mess = FALSE,
      warn = FALSE
    )
    expect_s3_class(fit$model, "jags")
  })
}

test_that("survreg_imp(): linear predictor with a random slope per center", {
  fit <- survreg_imp(
    Surv(futime, event) ~ age + sex + (age | center),
    data = pbc1,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE,
    warn = FALSE
  )
  coefs <- fit$coef_list[[1]]
  expect_equal(coefs$varname, c("(Intercept)", "age", "sexfemale"))
  expect_equal(coefs$coef, c("beta[1]", "beta[2]", "beta[3]"))

  # the data of the rows of the model, and their group (one group per center)
  dat <- fit$data[rownames(fit$data_list$M_lvlone), ]
  group <- fit$data_list$group_center
  expect_one_group_per_center(group, dat$center)

  # fixed values of the parameters, given to JAGS as data
  set.seed(3)
  beta <- c(7, 0.02, 0.4)
  b <- matrix(rnorm(10, sd = 0.3), nrow = 5)
  jags <- rjags::jags.model(
    textConnection(fit$jagsmodel),
    data = c(
      fit$data_list,
      list(
        beta = beta,
        b_Surv_futime_vnt_center = b,
        shape_Surv_futime_vnt = 1.2
      )
    ),
    n.chains = 1,
    n.adapt = 0,
    quiet = TRUE
  )
  res <- rjags::jags.samples(
    jags,
    c("rate_Surv_futime_vnt", "mu_b_Surv_futime_vnt_center"),
    n.iter = 1,
    progress.bar = "none"
  )

  # log(rate) = -(linear predictor), with the random intercept and slope of
  # the center; the means of the random effects are the intercept and the
  # coefficient of age
  expect_equal(
    log(as.vector(res$rate_Surv_futime_vnt)),
    -(b[group, 1] + b[group, 2] * dat$age + beta[3] * (dat$sex == "female"))
  )
  expect_equal(
    matrix(res$mu_b_Surv_futime_vnt_center, nrow = 5),
    matrix(beta[1:2], nrow = 5, ncol = 2, byrow = TRUE)
  )
})

test_that("JM_imp(): linear predictor with a random slope per center", {
  fit <- JM_imp(
    list(
      Surv(futime, event) ~ age + sex + chol + (age | center),
      chol ~ day + age + (day | id)
    ),
    timevar = "day",
    data = pbc,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    mess = FALSE,
    warn = FALSE
  )
  coefs <- fit$coef_list[[1]]
  expect_equal(coefs$varname, c("age", "sexfemale", "chol"))
  expect_equal(coefs$coef, c("beta[1]", "beta[2]", "beta[3]"))

  # the data of the subjects (one row per subject in M_id; JM_imp() re-sorts
  # the data), and the group of their center
  dat <- fit$data[rownames(fit$data_list$M_id), ]
  group <- fit$data_list$group_center[fit$data_list$pos_id]
  expect_one_group_per_center(group, dat$center)

  # fixed values of the parameters, given to JAGS as data
  set.seed(3)
  beta <- c(0.02, 0.4, 0.01, 200, 0.5, 0.1)
  b <- matrix(rnorm(10, sd = 0.3), nrow = 5)
  jags <- rjags::jags.model(
    textConnection(fit$jagsmodel),
    data = c(fit$data_list, list(beta = beta, b_Surv_futime_vnt_center = b)),
    n.chains = 1,
    n.adapt = 0,
    quiet = TRUE
  )
  res <- rjags::jags.samples(
    jags,
    c("eta_Surv_futime_vnt", "mu_b_Surv_futime_vnt_center"),
    n.iter = 1,
    progress.bar = "none"
  )

  # time-constant part of the linear predictor: random intercept and slope of
  # the center, and sex; the mean of the random intercept is 0 (the baseline
  # hazard takes the place of the intercept), the mean of the random slope is
  # the coefficient of age
  expect_equal(
    as.vector(res$eta_Surv_futime_vnt),
    b[group, 1] + b[group, 2] * dat$age + beta[2] * (dat$sex == "female")
  )
  expect_equal(
    matrix(res$mu_b_Surv_futime_vnt_center, nrow = 5),
    matrix(c(0, beta[1]), nrow = 5, ncol = 2, byrow = TRUE)
  )
})

# Without scaling: the random effects are independent on the scale on which
# they are modelled; after scaling of age, the back-transformation to the
# original scale gives covariances.
test_that("survreg_imp() with rd_vcov = 'indep': no covariances", {
  fit <- survreg_imp(
    Surv(futime, event) ~ age + sex + (age | center),
    data = pbc1,
    rd_vcov = "indep",
    scale_vars = FALSE,
    monitor_params = c(D_main = TRUE),
    n.adapt = 10,
    n.iter = 5,
    seed = 1,
    mess = FALSE,
    warn = FALSE
  )
  D <- as.matrix(fit$MCMC)
  expect_true(all(D[, "D_Surv_futime_vnt_center[1,2]"] == 0))
  expect_true(all(D[, "D_Surv_futime_vnt_center[1,1]"] > 0))
})
