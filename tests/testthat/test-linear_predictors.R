# "JAGS as calculator": the linear predictors of the analysis and covariate
# models, computed by JAGS, compared with an independent computation in R.
#
# The regression coefficients, the random effects and the precision parameters
# are given to JAGS as data (fixed values); JAGS samples the missing values
# (one iteration) and computes the deterministic nodes, including dummy
# variables, functions and interactions of incomplete variables. In R, the
# linear predictors are computed with `model.matrix()` from the data completed
# with the sampled values. For each model and each row this checks that
# * every coefficient multiplies the column of its variable (`fit$coef_list`),
# * the columns computed in JAGS (dummies, functions, interactions) are right,
# * hierarchical centring adds up: the linear predictor is the part on the
#   level of the model plus, for each random effect, its mean (`mu_b_*`, the
#   part on the higher level) instead of the random effect itself.
# Which variables are predictors in which model is tested in
# test-model_structure.R.

skip_on_cran()

# helpers -----------------------------------------------------------------------
# One iteration of the JAGS model of `fit`, with fixed values of the regression
# coefficients (alpha, beta), the random effects (b_*) and the precision
# parameters (tau_*). Returns these values, the data matrices (M_*) with the
# sampled missing values, and the nodes of the linear predictors (mu_*, mu_b_*,
# eta_*, phi_*).
run_with_fixed_parameters <- function(fit, seed = 1) {
  set.seed(seed)

  # model: JAGS model as created by JointAI
  model <- fit$jagsmodel

  # fixed: list to hold the randomly sampled parameter values, to be given to JAGS as data
  fixed <- list()

  # randomly sample values for the regression coefficients
  coefs <- unlist(lapply(fit$coef_list, `[[`, "coef"))
  for (vec in c("alpha", "beta")) {
    index <- as.integer(gsub("\\D", "", coefs[startsWith(coefs, vec)]))
    if (length(index) > 0L) {
      fixed[[vec]] <- rnorm(max(index), sd = 0.3)
    }
  }

  # randomly sample values for the random effects
  # (search for patterns like "b_c2_id[ii, 1:1] ~")
  ranefs <- regmatches(model, gregexpr("\\bb_\\w+\\[i+, 1:\\d+\\] ~", model))
  for (r in ranefs[[1L]]) {
    name <- sub("\\[.*", "", r)
    ncol <- as.integer(sub(".*1:(\\d+)\\].*", "\\1", r))
    ngroups <- max(fit$data_list[[paste0("group_", sub(".*_", "", name))]])
    fixed[[name]] <- matrix(rnorm(ngroups * ncol, sd = 0.3), nrow = ngroups)
  }

  # randomly sample precision parameters
  taus <- regmatches(model, gregexpr("\\btau_\\w+(?= ~)", model, perl = TRUE))
  for (tau in taus[[1L]]) {
    fixed[[tau]] <- 4
  }

  # initiate the jags model; use as data the randomly sampled values (fixed)
  # and the data_list created by JointAI
  jags <- rjags::jags.model(
    textConnection(model),
    data = c(fit$data_list, fixed),
    inits = list(.RNG.name = "base::Mersenne-Twister", .RNG.seed = seed),
    n.chains = 1,
    n.adapt = 0,
    quiet = TRUE
  )

  # collect the data matrices from the data_list of JointAI
  M <- names(Filter(
    is.matrix,
    fit$data_list[startsWith(names(fit$data_list), "M_")]
  ))

  # find the names of all linear predictor nodes mentioned in the JAGS model
  linpreds <- regmatches(
    model,
    gregexpr("\\b(mu|eta|phi)_\\w+(?=\\[)", model, perl = TRUE)
  )
  # sample from the JAGS model and monitor the data matrices
  # (will contain imputed values) and linear predictor nodes
  res <- rjags::jags.samples(
    jags,
    c(M, unique(linpreds[[1L]])),
    n.iter = 1,
    progress.bar = "none"
  )

  # drop the dimensions of the iteration and the chain from the resulting arrays
  res <- lapply(res, function(x) {
    d <- dim(x)[seq_len(length(dim(x)) - 2L)]
    if (length(d) == 1L) as.vector(x) else array(x, d)
  })
  for (m in M) {
    dimnames(res[[m]]) <- dimnames(fit$data_list[[m]])
  }
  c(fixed, res)
}

# Create completed datasets by replacing the missing values in the data with the
# values sampled in `res`
completed_data <- function(fit, res) {
  dat <- fit$data[rownames(fit$data_list$M_lvlone), ]

  # loop over the data matrices (M_*) of the different levels in res
  for (m in names(Filter(is.matrix, res[startsWith(names(res), "M_")]))) {
    lvl <- sub("M_", "", m)

    # identify which rows of the data correspond to the level of the data matrix
    rows <- if (lvl == "lvlone") {
      seq_len(nrow(dat))
    } else {
      fit$data_list[[paste0("group_", lvl)]]
    }

    # for columns present in both the data frame and matrices from the MCMC,
    # replace the missing values in the data with the sampled values in "res"
    for (v in intersect(colnames(res[[m]]), names(dat))) {
      x <- res[[m]][rows, v]
      if (is.factor(dat[[v]])) {
        # binary variables are coded 0/1, other categorical variables 1, 2, ...
        lvls <- levels(dat[[v]])
        x <- factor(
          lvls[x + (length(lvls) == 2L)],
          levels = lvls,
          ordered = is.ordered(dat[[v]])
        )
      }
      dat[[v]] <- x
    }
  }
  dat
}

# Calculate a linear predictor from a vector of coefficients (from `res`, i.e.,
# the MCMC sample) and a design matrix `X`
linpred <- function(fit, res, X, x, outcat = NULL) {
  coefs <- fit$coef_list[[x]]
  if (!is.null(outcat)) {
    coefs <- coefs[coefs$outcat == outcat, ]
  }
  values <- res[[sub("\\[.*", "", coefs$coef[1L])]]
  index <- as.integer(gsub("\\D", "", coefs$coef))
  unname(drop(X[, coefs$varname, drop = FALSE] %*% values[index]))
}

# tests -------------------------------------------------------------------------
test_that("two levels: default covariate models on both levels", {
  fit <- lme_imp(
    y ~ C1 + C2 + B2 + M2 + O2 + c2 + b2 + time + (time | id),
    data = longDF,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  res <- run_with_fixed_parameters(fit)
  dat <- completed_data(fit, res)
  # completed data should not have missing values:
  expect_false(anyNA(dat[, c("C2", "B2", "M2", "O2", "c2", "b2")]))

  # compare linear predictors calculated two ways: from the completed data in R and from the JAGS model
  X <- model.matrix(
    ~ C1 + C2 + B2 + M2 + O2 + c2 + b2 + time,
    dat,
    contrasts.arg = list(O2 = "contr.treatment")
  )
  g <- fit$data_list$group_id
  first <- match(seq_len(max(g)), g) # the first row of each id

  # linear predictors on lvlone: random intercept (and slope of time for y)
  d_y <- res$mu_b_y_id - res$b_y_id
  expect_equal(
    res$mu_y + d_y[g, 1] + d_y[g, 2] * dat$time,
    linpred(fit, res, X, "y")
  )
  expect_equal(
    qlogis(res$mu_b2) + (res$mu_b_b2_id - res$b_b2_id)[g],
    linpred(fit, res, X, "b2")
  )
  expect_equal(
    res$mu_c2 + (res$mu_b_c2_id - res$b_c2_id)[g],
    linpred(fit, res, X, "c2")
  )
  expect_equal(
    res$mu_time + (res$mu_b_time_id - res$b_time_id)[g],
    linpred(fit, res, X, "time")
  )

  # linear predictors on level id
  expect_equal(res$mu_C2, linpred(fit, res, X, "C2")[first])
  expect_equal(qlogis(res$mu_B2), linpred(fit, res, X, "B2")[first])
  expect_equal(res$eta_O2, linpred(fit, res, X, "O2")[first])
  expect_equal(log(res$phi_M2[, 1]), rep(0, max(g)))
  for (k in 2:4) {
    expect_equal(
      log(res$phi_M2[, k]),
      linpred(fit, res, X, "M2", paste0("M2", k))[first]
    )
  }
})

test_that("two levels: other types of covariate models", {
  dat <- longDF
  dat$C1[dat$id %in% c(1, 5, 12, 40)] <- NA
  dat$m2 <- factor(dat$o1, ordered = FALSE)
  dat$m2[c(2, 9, 30, 100, 200)] <- NA

  fit <- lme_imp(
    y ~ C1 + B2 + P2 + o2 + m2 + p2 + time + (1 | id),
    data = dat,
    models = c(
      C1 = "glm_gamma_log",
      B2 = "glm_binomial_probit",
      P2 = "glm_poisson_log",
      p2 = "glmm_poisson_log"
    ),
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  expect_equal(
    unname(fit$models[c("o2", "m2")]),
    c("clmm", "mlogitmm")
  )
  res <- run_with_fixed_parameters(fit)
  dat <- completed_data(fit, res)
  expect_false(anyNA(dat[, c("C1", "B2", "P2", "o2", "m2", "p2")]))
  X <- model.matrix(
    ~ C1 + B2 + P2 + o2 + m2 + p2 + time,
    dat,
    contrasts.arg = list(o2 = "contr.treatment")
  )
  g <- fit$data_list$group_id
  first <- match(seq_len(max(g)), g)

  # lvlone
  expect_equal(
    log(res$mu_p2) + (res$mu_b_p2_id - res$b_p2_id)[g],
    linpred(fit, res, X, "p2")
  )
  expect_equal(
    res$eta_o2 + (res$mu_b_o2_id - res$b_o2_id)[g],
    linpred(fit, res, X, "o2")
  )
  for (k in 2:3) {
    expect_equal(
      log(res$phi_m2[, k]) + (res$mu_b_m2_id - res$b_m2_id)[g],
      linpred(fit, res, X, "m2", paste0("m2", k))
    )
  }

  # level id
  expect_equal(log(res$mu_C1), linpred(fit, res, X, "C1")[first])
  expect_equal(log(res$mu_P2), linpred(fit, res, X, "P2")[first])
  expect_equal(qnorm(res$mu_B2), linpred(fit, res, X, "B2")[first])
})

test_that("three nested levels", {
  dat <- longDF
  dat$center <- as.integer(dat$id) %% 5L
  set.seed(1)
  dat$Z <- rnorm(5)[dat$center + 1L]
  dat$Z[dat$center == 2L] <- NA

  fit <- lme_imp(
    y ~ C1 + C2 + Z + c2 + time + (time | id) + (1 | center),
    data = dat,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  res <- run_with_fixed_parameters(fit)
  dat <- completed_data(fit, res)
  expect_false(anyNA(dat[, c("C2", "Z", "c2")]))
  X <- model.matrix(~ C1 + C2 + Z + c2 + time, dat)
  g <- fit$data_list$group_id
  gc <- fit$data_list$group_center
  first <- match(seq_len(max(g)), g)
  first_c <- match(seq_len(max(gc)), gc)

  # lvlone: random effects of id and of center
  d_y <- res$mu_b_y_id - res$b_y_id
  expect_equal(
    res$mu_y +
      d_y[g, 1] +
      d_y[g, 2] * dat$time +
      (res$mu_b_y_center - res$b_y_center)[gc],
    linpred(fit, res, X, "y")
  )
  expect_equal(
    res$mu_c2 +
      (res$mu_b_c2_id - res$b_c2_id)[g] +
      (res$mu_b_c2_center - res$b_c2_center)[gc],
    linpred(fit, res, X, "c2")
  )

  # level id: random intercept of center
  expect_equal(
    res$mu_C2 + (res$mu_b_C2_center - res$b_C2_center)[gc[first]],
    linpred(fit, res, X, "C2")[first]
  )

  # level center
  expect_equal(res$mu_Z, linpred(fit, res, X, "Z")[first_c])
})

test_that("functions and interactions of incomplete variables", {
  fit <- lme_imp(
    y ~ C2 * time + I(C2^2) + b2 * c2 + log(C1) + (1 | id),
    data = longDF,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  res <- run_with_fixed_parameters(fit)
  dat <- completed_data(fit, res)
  expect_false(anyNA(dat[, c("C2", "b2", "c2")]))
  X <- model.matrix(~ C2 * time + I(C2^2) + b2 * c2 + log(C1), dat)
  g <- fit$data_list$group_id

  expect_equal(
    res$mu_y + (res$mu_b_y_id - res$b_y_id)[g],
    linpred(fit, res, X, "y")
  )
})

test_that("joint model: covariate models", {
  # time in years and age centred, so that the linear predictors stay in a
  # range in which the inverse logit is not 0 or 1
  pbc <- PBC[PBC$id %in% unique(PBC$id)[1:60], ]
  pbc$day <- pbc$day / 365.25
  pbc$futime <- pbc$futime / 365.25
  pbc$age <- pbc$age - 50
  set.seed(3)
  pbc$W <- rnorm(60)[match(pbc$id, unique(pbc$id))]
  pbc$W[pbc$id %in% unique(pbc$id)[c(2, 9, 30)]] <- NA

  fit <- JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + W + chol,
      chol ~ age + W + hepato + day + (day | id)
    ),
    timevar = "day",
    data = pbc,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  res <- run_with_fixed_parameters(fit)
  dat <- completed_data(fit, res)
  expect_false(anyNA(dat[, c("W", "hepato", "chol")]))
  X <- model.matrix(~ age + W + hepato + day, dat)
  g <- fit$data_list$group_id
  first <- match(seq_len(max(g)), g)

  d_chol <- res$mu_b_chol_id - res$b_chol_id
  expect_equal(
    res$mu_chol + d_chol[g, 1] + d_chol[g, 2] * dat$day,
    linpred(fit, res, X, "chol")
  )
  expect_equal(
    qlogis(res$mu_hepato) + (res$mu_b_hepato_id - res$b_hepato_id)[g],
    linpred(fit, res, X, "hepato")
  )
  expect_equal(res$mu_W, linpred(fit, res, X, "W")[first])
})

# known bugs --------------------------------------------------------------------
test_that("interaction of an incomplete factor without its main effect", {
  skip(
    "known bug: the column of the reference category (b20:c2) is not computed"
  )
  fit <- lme_imp(
    y ~ b2:c2 + (1 | id),
    data = longDF,
    scale_vars = FALSE,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  res <- run_with_fixed_parameters(fit)
  dat <- completed_data(fit, res)
  X <- model.matrix(~ b2:c2, dat)
  g <- fit$data_list$group_id
  expect_equal(
    res$mu_y + (res$mu_b_y_id - res$b_y_id)[g],
    linpred(fit, res, X, "y")
  )
})
