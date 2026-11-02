# Coefficients of a level above the lowest level with random effects, in models
# without a random intercept on that level, or with random effects that cannot
# take them (#133). The intercept and the covariates of that level cannot be in
# the means of the random effects, so they must be in the linear predictor.
# The JAGS model is set up (n.adapt = 0, n.iter = 0), and its text is checked.

skip_on_cran()

higher_level_data <- function() {
  set.seed(1)
  subjects <- data.frame(id = 1:40)
  subjects$center <- sample(rep(1:8, length.out = 40))
  subjects$region <- ceiling(subjects$center / 4)
  subjects$z <- rnorm(8)[subjects$center]
  subjects$r <- rnorm(2)[subjects$region]
  subjects$age <- rnorm(40)

  dat <- subjects[rep(1:40, each = 4), ]
  dat$time <- rep(0:3, 40) + rnorm(160, sd = 0.1)
  dat$y <- 1 + 0.5 * dat$z + 0.3 * dat$age + 0.2 * dat$time + rnorm(160)
  dat$x <- rnorm(160)
  dat$b <- factor(rbinom(160, 1, 0.5))
  dat$m <- factor(sample(c("a", "b", "c"), 160, replace = TRUE))
  dat$o <- factor(
    sample(c("a", "b", "c"), 160, replace = TRUE),
    ordered = TRUE
  )
  dat
}

setup_higher_level <- function(fun, ...) {
  fun(
    ...,
    data = higher_level_data(),
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    overwrite = TRUE,
    mess = FALSE,
    warn = FALSE
  )
}

# the lines of the model text, with the linear predictors that were spread over
# multiple lines written on one line, without the lines of the priors
model_equations <- function(fit) {
  text <- gsub("\\+[[:space:]]*\n[[:space:]]*", "+ ", fit$jagsmodel)
  lines <- trimws(strsplit(text, "\n")[[1L]])
  lines[!grepl("~", lines, fixed = TRUE)]
}

# the numbers of the regression coefficients in a set of lines, with repeats
beta_numbers <- function(lines) {
  as.integer(unlist(regmatches(
    lines,
    gregexpr("(?<=beta\\[)[0-9]+(?=\\])", lines, perl = TRUE)
  )))
}

# the numbers of all regression coefficients of the model
coef_numbers <- function(fit) {
  sort(as.integer(unlist(lapply(fit$info_list, function(info) {
    if (info$parname == "beta") {
      c(unlist(info$parelmts), unlist(lapply(info$parelmts, attr, "nonprop")))
    }
  }))))
}

expect_each_coef_once <- function(fit, label) {
  expect_identical(
    sort(beta_numbers(model_equations(fit))),
    coef_numbers(fit),
    label = label
  )
}

test_that("every coefficient is once in the model: linear mixed models", {
  cases <- list(
    y ~ z + age + time + (1 | id) + (0 + time | center),
    y ~ z + age + time + (0 + time | id) + (0 + time | center),
    # three levels
    y ~ z + r + age + time + (1 | center) + (0 + time | region),
    # the coefficients go into the means of the random effects
    y ~ z + age + time + (0 + time | id) + (1 | center),
    y ~ z + age + time + (time | id) + (time | center),
    y ~ z + age + time + (0 + time | id),
    y ~ z + age + time + (0 + time | center),
    # only an intercept on the higher level
    y ~ age + time + (0 + time | id) + (0 + time | center),
    y ~ 1 + (0 + time | id) + (0 + time | center)
  )
  for (fixed in cases) {
    fit <- setup_higher_level(lme_imp, fixed)
    expect_each_coef_once(fit, deparse1(fixed))
  }
})

test_that("every coefficient is once in the model: other model types", {
  fixed <- ~ z + age + time + (0 + time | id) + (0 + time | center)

  fit <- setup_higher_level(glme_imp, update(fixed, b ~ .), family = binomial())
  expect_each_coef_once(fit, "glme")

  fit <- setup_higher_level(clmm_imp, update(fixed, o ~ .))
  expect_each_coef_once(fit, "clmm")

  fit <- setup_higher_level(mlogitmm_imp, update(fixed, m ~ .))
  expect_each_coef_once(fit, "mlogitmm")
})

test_that("every coefficient is once in a multinomial mixed model with random intercepts", {
  # the random effects of a multinomial model never have coefficients in their
  # means, so also a random intercept on the higher level does not take them
  fit <- setup_higher_level(
    mlogitmm_imp,
    m ~ z + age + time + (1 | id) + (1 | center)
  )
  expect_each_coef_once(fit, "mlogitmm, random intercepts")
})

test_that("every coefficient is once if only another sub-model uses the higher level", {
  # the center level exists because of y; x has no random effects on it
  fit <- setup_higher_level(
    lme_imp,
    list(
      y ~ z + age + time + (1 | id) + (1 | center),
      x ~ z + age + time + (1 | id)
    )
  )
  expect_each_coef_once(fit, "second outcome")

  # the same for a level between two levels with random effects
  fit <- setup_higher_level(
    lme_imp,
    list(
      y ~ z + r + age + time + (1 | id) + (1 | center) + (1 | region),
      x ~ z + r + age + time + (1 | id) + (1 | region)
    )
  )
  expect_each_coef_once(fit, "second outcome, level in the middle")
})

test_that("the coefficients of the higher level are in both parts of a joint model", {
  # the model of a time-varying covariate is written twice: for the observations
  # and for the quadrature points
  dat <- subset(PBC, id %in% unique(PBC$id)[1:30])
  subjects <- unique(dat$id)
  dat$center <- rep(1:5, length.out = length(subjects))[
    match(dat$id, subjects)
  ]
  dat$z <- c(0.1, 1.8, 2.0, -4.6, 0.7)[dat$center]

  fit <- JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + albumin,
      albumin ~ age + z + day + (0 + day | id) + (0 + day | center)
    ),
    data = dat,
    timevar = "day",
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    overwrite = TRUE,
    mess = FALSE,
    warn = FALSE
  )

  coefs <- fit$info_list$albumin$parelmts$M_center
  equations <- model_equations(fit)
  mu <- equations[startsWith(equations, "mu_albumin[i] <- ")]
  mugk <- equations[startsWith(equations, "mugk_albumin[ii, k] <- ")]

  expect_true(all(coefs %in% beta_numbers(mu)))
  expect_true(all(coefs %in% beta_numbers(mugk)))
  # the level above the survival outcome has an index of its own
  expect_match(mugk, "M_center[group_center[pos_id[ii]], 1]", fixed = TRUE)
})

test_that("the coefficients of the higher level are in the linear predictor", {
  fit <- setup_higher_level(
    lme_imp,
    y ~ z + age + time + (1 | id) + (0 + time | center)
  )
  coefs <- fit$info_list$y$parelmts$M_center
  equations <- model_equations(fit)
  mu_y <- equations[startsWith(equations, "mu_y[i] <- ")]

  # the intercept and z, with the index of the level
  expect_match(
    mu_y,
    sprintf("beta[%d] * M_center[group_center[i], 1]", coefs[["(Intercept)"]]),
    fixed = TRUE
  )
  expect_match(
    mu_y,
    sprintf("beta[%d] * (M_center[group_center[i], 2]", coefs[["z"]]),
    fixed = TRUE
  )
})
