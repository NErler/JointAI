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
#
# Each case (list `cases` below) gives the model call, the right-hand side of
# the design matrix (all variables of the model, as `model.matrix()` should
# create them), and, for each sub-model, what we expect it to be: the link
# function, the level of its outcome, and its random effects per grouping
# level. These expectations are written out explicitly and not taken from the
# fitted object, so that the test does not repeat a possible mistake of
# JointAI.
#
# Every sub-model of the fitted model has to be listed in its case (or, with a
# reason, in `not_compared`). A case with `known_bug` is skipped; to be
# switched on when the bug is fixed.

skip_on_cran()

# data -------------------------------------------------------------------------
# two levels, with an incomplete continuous variable on level id (C1) and an
# incomplete unordered factor on level one (m2)
dat2 <- longDF
dat2$C1[dat2$id %in% c(1, 5, 12, 40)] <- NA
dat2$m2 <- factor(dat2$o1, ordered = FALSE)
dat2$m2[c(2, 9, 30, 100, 200)] <- NA

# three nested levels: id in center, with an incomplete variable of center
dat3 <- longDF
dat3$center <- as.integer(dat3$id) %% 5L
set.seed(1)
dat3$Z <- rnorm(5)[dat3$center + 1L]
dat3$Z[dat3$center == 2L] <- NA

# crossed levels a and b, with incomplete variables of b and of the
# observations
set.seed(2)
datx <- expand.grid(a = 1:10, b = 1:8, rep = 1:3)
datx$A1 <- rnorm(10)[datx$a]
datx$B1 <- rnorm(8)[datx$b]
datx$x <- rnorm(nrow(datx))
datx$y <- datx$A1 + datx$B1 + datx$x + rnorm(nrow(datx))
datx$B1[datx$b == 3L] <- NA
datx$x[c(4L, 50L)] <- NA

# survival data with an incomplete variable of the subjects (W); time in years
# and age centred, so that the linear predictors stay in a range in which the
# inverse logit is not 0 or 1
pbc <- PBC[PBC$id %in% unique(PBC$id)[1:60], ]
pbc$day <- pbc$day / 365.25
pbc$futime <- pbc$futime / 365.25
pbc$age <- pbc$age - 50
set.seed(3)
pbc$W <- rnorm(60)[match(pbc$id, unique(pbc$id))]
pbc$W[pbc$id %in% unique(pbc$id)[c(2, 9, 30)]] <- NA

# helpers ----------------------------------------------------------------------
# Write down what we expect for one sub-model:
# * link: "identity", "logit", "probit", "log", "cumulative" (cumulative logit;
#   the linear predictor is `eta_*`) or "multinomial" (the linear predictors
#   are `log(phi_*)`, one per category),
# * level: the level of the outcome ("lvlone", "id", ...),
# * ...: the random effects, per grouping level, as a formula of the variables
#   that have a random effect (e.g. `id = ~ time`: random intercept and slope
#   of time for id).
submodel <- function(link, level, ...) {
  list(link = link, level = level, ranefs = list(...))
}

# Run one iteration of the JAGS model of `fit`, with fixed values of the
# regression coefficients (alpha, beta), the random effects (b_*) and the
# precision parameters (tau_*). Returns these values, the data matrices (M_*)
# with the sampled missing values, and the nodes of the linear predictors
# (mu_*, mu_b_*, eta_*, phi_*).
run_with_fixed_parameters <- function(fit, seed = 1) {
  set.seed(seed)

  # model: JAGS model as created by JointAI
  model <- fit$jagsmodel

  # fixed: list to hold the fixed parameter values, to be given to JAGS as data
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
    n_col <- as.integer(sub(".*1:(\\d+)\\].*", "\\1", r))
    ngroups <- max(fit$data_list[[paste0("group_", sub(".*_", "", name))]])
    fixed[[name]] <- matrix(rnorm(ngroups * n_col, sd = 0.3), nrow = ngroups)
  }

  # set the precision parameters to a fixed value
  # (search for patterns like "tau_c2 ~")
  taus <- regmatches(model, gregexpr("\\btau_\\w+(?= ~)", model, perl = TRUE))
  for (tau in taus[[1L]]) {
    fixed[[tau]] <- 4
  }

  # initiate the jags model; use as data the fixed parameter values (fixed)
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
    lvl <- sub("M_", "", m, fixed = TRUE)

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

# Calculate the linear predictor of the sub-model for `x` in R: the design
# matrix `X` times the coefficients of the sub-model (the fixed values in
# `res`). For multinomial models: the linear predictor of category `outcat`.
linpred_from_coefs <- function(fit, res, X, x, outcat = NULL) {
  coefs <- fit$coef_list[[x]]
  if (!is.null(outcat)) {
    coefs <- coefs[coefs$outcat == outcat, ]
  }
  values <- res[[sub("\\[.*", "", coefs$coef[1L])]]
  index <- as.integer(gsub("\\D", "", coefs$coef))
  unname(drop(X[, coefs$varname, drop = FALSE] %*% values[index]))
}

# Calculate the full linear predictor of the sub-model for `x` from the nodes
# computed by JAGS: the linear predictor node (`node`; for multinomial models
# the column of one category) on the scale of the link function, plus, for
# each random effect, its mean minus the random effect itself, multiplied by
# the variable of the random effect (1 for a random intercept). `rows` are the
# rows of `dat` that belong to the outcome of the sub-model (one per group for
# outcomes on a higher level).
linpred_from_jags <- function(fit, res, dat, x, expected, rows, node) {
  # transform the node to the scale of the linear predictor
  inverse_link <- switch(
    expected$link,
    identity = identity,
    cumulative = identity,
    logit = qlogis,
    probit = qnorm,
    log = log,
    multinomial = log
  )
  lp <- inverse_link(node)

  # add, for each grouping level, the difference between the means of the
  # random effects and the random effects, times their variables
  for (lvl in names(expected$ranefs)) {
    Z <- model.matrix(expected$ranefs[[lvl]], dat)[rows, , drop = FALSE]
    group <- fit$data_list[[paste0("group_", lvl)]][rows]
    deviation <- res[[paste0("mu_b_", x, "_", lvl)]] -
      res[[paste0("b_", x, "_", lvl)]]
    lp <- lp + rowSums(deviation[group, , drop = FALSE] * Z)
  }
  unname(lp)
}

# Compare the linear predictors of the sub-model for `x` calculated two ways:
# from the nodes computed by JAGS and from the completed data in R
# (`expected`: the expectation for the sub-model, see `submodel()`). The
# expectations are written with `testthat::`, so that the linter (which does
# not know that testthat is attached in tests) finds them.
expect_linpreds_equal <- function(fit, res, dat, X, x, expected) {
  # identify the rows of the outcome: all rows for lvlone, otherwise the
  # first row of each group
  rows <- if (expected$level == "lvlone") {
    seq_len(nrow(dat))
  } else {
    group <- fit$data_list[[paste0("group_", expected$level)]]
    match(seq_len(max(group)), group)
  }

  if (expected$link == "multinomial") {
    # multinomial models have one linear predictor per category; the
    # first category is the reference (linear predictor 0)
    phi <- res[[paste0("phi_", x)]]
    testthat::expect_equal(log(phi[, 1L]), rep(0, length(rows)), label = x)
    categories <- levels(dat[[x]])
    for (k in seq_along(categories)[-1L]) {
      testthat::expect_equal(
        linpred_from_jags(fit, res, dat, x, expected, rows, phi[, k]),
        linpred_from_coefs(fit, res, X, x, paste0(x, categories[k]))[rows],
        label = paste0(x, ", category ", categories[k], " (JAGS)"),
        expected.label = "R"
      )
    }
  } else {
    # the linear predictor node is called eta_* in cumulative logit models
    # and mu_* in all other models
    prefix <- if (expected$link == "cumulative") "eta_" else "mu_"
    node <- res[[paste0(prefix, x)]]
    testthat::expect_equal(
      linpred_from_jags(fit, res, dat, x, expected, rows, node),
      linpred_from_coefs(fit, res, X, x)[rows],
      label = paste(x, "(JAGS)"),
      expected.label = "R"
    )
  }
}

# cases ------------------------------------------------------------------------
cases <- list(
  two_levels = list(
    call = quote(lme_imp(
      y ~ C1 + C2 + B2 + M2 + O2 + c2 + b2 + time + (time | id),
      data = longDF
    )),
    design = ~ C1 + C2 + B2 + M2 + O2 + c2 + b2 + time,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~time),
      b2 = submodel("logit", "lvlone", id = ~1),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id"),
      B2 = submodel("logit", "id"),
      M2 = submodel("multinomial", "id"),
      O2 = submodel("cumulative", "id")
    )
  ),
  other_covariate_model_types = list(
    call = quote(lme_imp(
      y ~ C1 + B2 + P2 + o2 + m2 + p2 + time + (1 | id),
      data = dat2,
      models = c(
        C1 = "glm_gamma_log",
        B2 = "glm_binomial_probit",
        P2 = "glm_poisson_log",
        p2 = "glmm_poisson_log"
      )
    )),
    design = ~ C1 + B2 + P2 + o2 + m2 + p2 + time,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~1),
      p2 = submodel("log", "lvlone", id = ~1),
      o2 = submodel("cumulative", "lvlone", id = ~1),
      m2 = submodel("multinomial", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C1 = submodel("log", "id"),
      P2 = submodel("log", "id"),
      B2 = submodel("probit", "id")
    )
  ),
  three_levels = list(
    call = quote(lme_imp(
      y ~ C1 + C2 + Z + c2 + time + (time | id) + (1 | center),
      data = dat3
    )),
    design = ~ C1 + C2 + Z + c2 + time,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~time, center = ~1),
      c2 = submodel("identity", "lvlone", id = ~1, center = ~1),
      time = submodel("identity", "lvlone", id = ~1, center = ~1),
      C2 = submodel("identity", "id", center = ~1),
      C1 = submodel("identity", "id", center = ~1),
      Z = submodel("identity", "center")
    )
  ),
  crossed = list(
    call = quote(lme_imp(y ~ x + A1 + B1 + (1 | a) + (1 | b), data = datx)),
    design = ~ x + A1 + B1,
    submodels = list(
      y = submodel("identity", "lvlone", a = ~1, b = ~1),
      x = submodel("identity", "lvlone", a = ~1, b = ~1),
      B1 = submodel("identity", "b")
    )
  ),
  functions_interactions = list(
    call = quote(lme_imp(
      y ~ C2 * time + I(C2^2) + b2 * c2 + log(C1) + (1 | id),
      data = longDF
    )),
    design = ~ C2 * time + I(C2^2) + b2 * c2 + log(C1),
    submodels = list(
      y = submodel("identity", "lvlone", id = ~1),
      b2 = submodel("logit", "lvlone", id = ~1),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id")
    )
  ),
  functions_of_two_variables = list(
    # on one level (C1, C2) and across levels (c2, C2)
    call = quote(lme_imp(
      y ~ C1 + I(C2 / C1^2) + c2 + I(c2 - C2) + time + (1 | id),
      data = longDF
    )),
    design = ~ C1 + I(C2 / C1^2) + c2 + I(c2 - C2) + time,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~1),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id")
    )
  ),
  functions_in_interactions = list(
    call = quote(lme_imp(
      y ~ I(C2^2) * time + log(C1) + c2 + log(C1):c2 + b2 + (1 | id),
      data = longDF
    )),
    design = ~ I(C2^2) * time + log(C1) + c2 + log(C1):c2 + b2,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~1),
      b2 = submodel("logit", "lvlone", id = ~1),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id")
    )
  ),
  function_in_random_effects = list(
    call = quote(lme_imp(
      y ~ C2 + c2 + time + I(time^2) + (time + I(time^2) | id),
      data = longDF
    )),
    design = ~ C2 + c2 + time + I(time^2),
    submodels = list(
      y = submodel("identity", "lvlone", id = ~ time + I(time^2)),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id")
    )
  ),
  interaction_with_random_slope = list(
    call = quote(lme_imp(y ~ C2 * c2 + b2 + time + (c2 | id), data = longDF)),
    design = ~ C2 * c2 + b2 + time,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~c2),
      b2 = submodel("logit", "lvlone", id = ~1),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id")
    )
  ),
  function_and_interaction_in_random_effects = list(
    # a function of variables of two levels, and an interaction
    call = quote(lme_imp(
      y ~ C2 + c2 * time + I(c2 * C2) + (I(c2 * C2) + c2:time | id),
      data = longDF
    )),
    design = ~ C2 + c2 * time + I(c2 * C2),
    submodels = list(
      y = submodel("identity", "lvlone", id = ~ I(c2 * C2) + c2:time),
      c2 = submodel("identity", "lvlone", id = ~1),
      time = submodel("identity", "lvlone", id = ~1),
      C2 = submodel("identity", "id")
    )
  ),
  joint_model = list(
    call = quote(JM_imp(
      list(
        Surv(futime, status != "censored") ~ age + W + chol,
        chol ~ age + W + hepato + day + (day | id)
      ),
      timevar = "day",
      data = pbc
    )),
    design = ~ age + W + hepato + day,
    submodels = list(
      chol = submodel("identity", "lvlone", id = ~day),
      hepato = submodel("logit", "lvlone", id = ~1),
      W = submodel("identity", "id")
    ),
    # the survival model: its linear predictor is tested in
    # test-ranef_survival.R
    not_compared = 'Surv(futime, status != "censored")'
  ),
  factor_interaction_without_main_effect = list(
    call = quote(lme_imp(y ~ b2:c2 + (1 | id), data = longDF)),
    design = ~ b2:c2,
    submodels = list(
      y = submodel("identity", "lvlone", id = ~1),
      b2 = submodel("logit", "lvlone", id = ~1),
      c2 = submodel("identity", "lvlone", id = ~1)
    ),
    known_bug = "the column of the reference category (b20:c2) is not computed"
  )
)

# tests ------------------------------------------------------------------------
for (case in names(cases)) {
  test_that(paste("linear predictors:", case), {
    spec <- cases[[case]]
    if (!is.null(spec$known_bug)) {
      skip(paste("known bug:", spec$known_bug))
    }

    # set up the JointAI model without scaling (so that the data in JAGS are
    # the data in R), and without adaptation or sampling
    model_call <- as.call(c(
      as.list(spec$call),
      list(
        scale_vars = FALSE,
        n.adapt = 0,
        n.iter = 0,
        mess = FALSE,
        warn = FALSE
      )
    ))
    fit <- eval(model_call)

    # every sub-model of the fitted model should be listed in the case (or
    # excluded explicitly in `not_compared`), so that none is left out
    expect_setequal(
      names(fit$coef_list),
      c(names(spec$submodels), spec$not_compared)
    )

    # run JAGS with fixed parameters and complete the data with the sampled
    # values; the completed data should not have missing values
    res <- run_with_fixed_parameters(fit)
    dat <- completed_data(fit, res)
    expect_false(anyNA(dat[, all.vars(spec$design)]))

    # create the design matrix in R, with dummy variables (treatment contrasts,
    # as in JointAI) also for ordered factors; add the columns of the
    # variables themselves, because covariate models use the variables, not
    # the functions of them (e.g. C2 instead of I(C2^2))
    ordered_factors <- Filter(is.ordered, dat[, all.vars(spec$design)])
    contrasts <- lapply(ordered_factors, function(x) "contr.treatment")
    X <- cbind(
      model.matrix(spec$design, dat, contrasts.arg = contrasts),
      model.matrix(
        reformulate(all.vars(spec$design)),
        dat,
        contrasts.arg = contrasts
      )
    )

    # compare, for each sub-model, the linear predictors calculated two ways:
    # from the nodes computed by JAGS and from the completed data in R
    for (x in names(spec$submodels)) {
      expect_linpreds_equal(fit, res, dat, X, x, spec$submodels[[x]])
    }
  })
}
