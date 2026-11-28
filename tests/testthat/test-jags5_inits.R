# Initial values that JointAI draws with JAGS >= 5. JAGS >= 5 sets initial
# values from the prior: the mode for a bounded parameter, the mean of many
# draws for an unbounded parameter. For two kinds of parameters this does not
# work, and the model cannot be initialised:
# - the precisions of random effects with a truncated gamma prior (a single
#   random effect, or independent random effects) start close to the lower
#   bound 1e-16, so that the random effects start at extreme values;
# - the shape parameter of a Weibull survival model starts at about 100, so
#   that the survival time to the power of the shape overflows.

# get_ranef_precision_nodes() --------------------------------------------------

test_that("get_ranef_precision_nodes(): a single random effect", {
  fit <- lme_imp(
    y ~ C1 + (1 | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )

  # the node of the precision and the number of random effects
  expect_identical(
    get_ranef_precision_nodes(fit$info_list),
    c(invD_y_id = 1L)
  )
})


test_that("get_ranef_precision_nodes(): independent random effects", {
  fit <- lme_imp(
    y ~ C1 + time + (time | id),
    data = longDF,
    rd_vcov = "indep",
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )

  expect_identical(
    get_ranef_precision_nodes(fit$info_list),
    c(invD_y_id = 2L)
  )
})


test_that("get_ranef_precision_nodes(): no node for a Wishart prior", {
  # set-up: two correlated random effects (block-diagonal; Wishart prior, no
  # truncation) and the model for the incomplete covariate c2, with a random
  # intercept
  fit <- lme_imp(
    y ~ c2 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )

  # only the random intercept of the model for c2
  expect_identical(
    get_ranef_precision_nodes(fit$info_list),
    c(invD_c2_id = 1L)
  )
})


test_that("get_ranef_precision_nodes(): none without random effects", {
  fit <- lm_imp(y ~ C1, data = wideDF, n.adapt = 0, n.iter = 0, mess = FALSE)

  expect_length(get_ranef_precision_nodes(fit$info_list), 0L)
})


# get_survreg_shape_nodes() ----------------------------------------------------

test_that("get_survreg_shape_nodes(): the shape of a Weibull model", {
  fit <- survreg_imp(
    Surv(futime, status != "censored") ~ age + sex,
    data = PBC[match(unique(PBC$id), PBC$id), ],
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )

  # the node of the shape; 0L stands for a single value
  expect_identical(
    get_survreg_shape_nodes(fit$info_list),
    c(shape_Srv_ftm_stts_cn = 0L)
  )
})


test_that("get_survreg_shape_nodes(): none in other models", {
  fit <- lme_imp(
    y ~ C1 + (1 | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )

  expect_length(get_survreg_shape_nodes(fit$info_list), 0L)
  # get_jags5_init_nodes() combines the nodes of both kinds
  expect_identical(get_jags5_init_nodes(fit$info_list), c(invD_y_id = 1L))
})


# add_jags5_inits() ------------------------------------------------------------

test_that("add_jags5_inits() draws a value per chain (JAGS >= 5)", {
  # set-up: the initial values of the random number generators of two chains
  inits <- get_rng(seed = 1, n_chains = 2)
  nodes <- c(invD_y_id = 2L, invD_c1_id = 1L)

  out <- add_jags5_inits(inits, nodes, seed = 1, jags5 = TRUE)

  # the generators are kept, the precisions added as matrices with the values
  # on the diagonal (the off-diagonal elements are data or not used)
  expect_identical(out[[1L]][1:2], inits[[1L]])
  expect_named(out[[1L]], c(".RNG.name", ".RNG.seed", names(nodes)))
  expect_identical(dim(out[[1L]]$invD_y_id), c(2L, 2L))
  expect_true(all(is.na(out[[1L]]$invD_y_id[c(2L, 3L)])))

  # the values are between 0.5 and 2 and differ between the chains
  values <- unlist(lapply(out, function(x) {
    c(diag(x$invD_y_id), x$invD_c1_id)
  }))
  expect_true(all(values >= 0.5 & values <= 2))
  expect_false(identical(out[[1L]]$invD_y_id, out[[2L]]$invD_y_id))

  # the same seed gives the same values
  expect_identical(add_jags5_inits(inits, nodes, seed = 1, jags5 = TRUE), out)
})


test_that("add_jags5_inits() draws a single value for size 0", {
  inits <- get_rng(seed = 1, n_chains = 2)

  out <- add_jags5_inits(inits, c(shape_y = 0L), seed = 1, jags5 = TRUE)

  # a single number (no matrix), between 0.5 and 2
  expect_null(dim(out[[1L]]$shape_y))
  expect_length(out[[1L]]$shape_y, 1L)
  expect_true(out[[1L]]$shape_y >= 0.5 && out[[1L]]$shape_y <= 2)
})


test_that("add_jags5_inits() keeps values the user supplied", {
  inits <- list(
    list(invD_y_id = matrix(3), .RNG.name = "base::Wichmann-Hill"),
    list(.RNG.name = "base::Wichmann-Hill")
  )

  out <- add_jags5_inits(inits, c(invD_y_id = 1L), seed = 1, jags5 = TRUE)

  expect_identical(out[[1L]], inits[[1L]])
  expect_true(out[[2L]]$invD_y_id >= 0.5)
})


test_that("add_jags5_inits() changes nothing with JAGS < 5", {
  inits <- get_rng(seed = 1, n_chains = 2)

  expect_identical(
    add_jags5_inits(inits, c(invD_y_id = 1L), seed = 1, jags5 = FALSE),
    inits
  )
})


# models -----------------------------------------------------------------------

test_that("a model with random intercepts in several sub-models runs", {
  skip_on_cran()
  # set-up: a proportional hazards model with a random intercept per center;
  # the incomplete covariates trig and copper get models with a random
  # intercept per center, too. With JAGS 5 and its own initial values, this
  # model could not be initialised ("Node inconsistent with parents").
  pbc_base <- PBC[match(unique(PBC$id), PBC$id), ]
  pbc_base$center <- cut(
    as.numeric(pbc_base$id),
    c(-Inf, seq(30, 270, 30), Inf)
  )

  fit <- coxph_imp(
    Surv(futime, status != "censored") ~ copper +
      sex +
      age +
      abs(age - copper) +
      log(trig) +
      (1 | center),
    data = pbc_base,
    n.adapt = 2,
    n.iter = 10,
    seed = 2020,
    trunc = list(trig = c(1e-04, NA)),
    warn = FALSE,
    mess = FALSE
  )

  expect_s3_class(fit, "JointAI")
  expect_s3_class(fit$MCMC, "mcmc.list")
})


test_that("a Weibull survival model can be initialised", {
  skip_on_cran()
  # set-up: a Weibull model of the time to death in PBC (times up to about
  # 4800 days). With JAGS 5 and its own initial value of the shape (about
  # 100), this model could not be initialised ("Node inconsistent with
  # parents").
  fit <- survreg_imp(
    Surv(futime, status != "censored") ~ age + sex,
    data = PBC[match(unique(PBC$id), PBC$id), ],
    n.adapt = 10,
    n.iter = 20,
    seed = 2020,
    warn = FALSE,
    mess = FALSE
  )

  expect_s3_class(fit, "JointAI")
  expect_s3_class(fit$MCMC, "mcmc.list")
})
