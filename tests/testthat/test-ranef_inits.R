# Initial values for the precisions of random effects. Their prior is a
# truncated gamma distribution (for a single random effect, and for independent
# random effects). JAGS >= 5 starts such a bounded parameter at the mode of the
# prior, close to the lower bound 1e-16; the random effects then start at
# extreme values and the model cannot be initialised. With JAGS >= 5, JointAI
# therefore draws initial values for these precisions.

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


# add_ranef_inits() ------------------------------------------------------------

test_that("add_ranef_inits() draws a value per chain (JAGS >= 5)", {
  # set-up: the initial values of the random number generators of two chains
  inits <- get_rng(seed = 1, n_chains = 2)
  nodes <- c(invD_y_id = 2L, invD_c1_id = 1L)

  out <- add_ranef_inits(inits, nodes, seed = 1, jags5 = TRUE)

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
  expect_identical(add_ranef_inits(inits, nodes, seed = 1, jags5 = TRUE), out)
})


test_that("add_ranef_inits() keeps values the user supplied", {
  inits <- list(
    list(invD_y_id = matrix(3), .RNG.name = "base::Wichmann-Hill"),
    list(.RNG.name = "base::Wichmann-Hill")
  )

  out <- add_ranef_inits(inits, c(invD_y_id = 1L), seed = 1, jags5 = TRUE)

  expect_identical(out[[1L]], inits[[1L]])
  expect_true(out[[2L]]$invD_y_id >= 0.5)
})


test_that("add_ranef_inits() changes nothing with JAGS < 5", {
  inits <- get_rng(seed = 1, n_chains = 2)

  expect_identical(
    add_ranef_inits(inits, c(invD_y_id = 1L), seed = 1, jags5 = FALSE),
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
