# Scaling of continuous covariates (R/scaling.R and where the scaling
# parameters are used). The models are set up but not sampled (golden_fit()
# from helper-golden.R).

skip_on_cran()

# names of the columns that are scaled
scaled_columns <- function(fit) {
  sp <- do.call(rbind, unname(fit$Mlist$scale_pars))
  if (is.null(sp)) {
    return(character(0))
  }
  sort(rownames(sp)[!is.na(sp$center)])
}

scale_case <- function(scale_vars) {
  golden_fit(
    substitute(
      lm_imp(y ~ C1 * C2 + B2, scale_vars = SV, data = wideDF),
      list(SV = scale_vars)
    ),
    golden_data()
  )
}

test_that("scale_vars selects the columns that are scaled", {
  all_cols <- scaled_columns(scale_case(NULL))
  expect_true(all(c("C1", "C2", "C1:C2") %in% all_cols))

  # only the named columns
  expect_identical(scaled_columns(scale_case("C1")), "C1")
  expect_identical(
    scaled_columns(scale_case(c("C1", "C1:C2"))),
    sort(c("C1", "C1:C2"))
  )
  # TRUE is the same as the default, FALSE means no scaling
  expect_identical(scaled_columns(scale_case(TRUE)), all_cols)
  expect_identical(scaled_columns(scale_case(FALSE)), character(0))
})


# Which columns are scaled, and the scaling parameters -------------------------

test_that("continuous columns are scaled, dummies and factor interactions not", {
  fit <- golden_fit(
    quote(lm_imp(
      y ~ C1 * B2 + C2 + M2 + B2:M2 + ns(C1, df = 2),
      data = wideDF
    )),
    golden_data()
  )
  # the outcome is a column of the design matrix as well
  expect_setequal(
    scaled_columns(fit),
    c("y", "C1", "C2", "C1:B21", "ns(C1, df = 2)1", "ns(C1, df = 2)2")
  )

  # mean and sd of the column of the design matrix (the interaction column is
  # calculated in JAGS because B2 has missing values)
  sp <- fit$Mlist$scale_pars$M_lvlone
  M <- fit$data_list$M_lvlone
  M[, "C1:B21"] <- wideDF$C1 * (wideDF$B2 == "1")
  for (k in scaled_columns(fit)) {
    expect_equal(sp[k, "center"], mean(M[, k], na.rm = TRUE), info = k)
    expect_equal(sp[k, "scale"], sd(M[, k], na.rm = TRUE), info = k)
  }
  expect_equal(sp["C2", "center"], mean(wideDF$C2, na.rm = TRUE))
  expect_equal(sp["C2", "scale"], sd(wideDF$C2, na.rm = TRUE))
})

test_that("scaling parameters are calculated over the rows of the level", {
  dat <- golden_data()
  fit <- golden_fit(
    quote(lme_imp(y ~ C1 + c2 + time + (time | id), data = longDF)),
    dat
  )
  # baseline covariate: one value per subject
  C1_id <- dat$longDF$C1[!duplicated(dat$longDF$id)]
  expect_equal(fit$Mlist$scale_pars$M_id["C1", "center"], mean(C1_id))
  expect_equal(fit$Mlist$scale_pars$M_id["C1", "scale"], sd(C1_id))
  expect_false(isTRUE(all.equal(mean(C1_id), mean(dat$longDF$C1))))

  # time-varying covariate: all rows
  expect_equal(
    fit$Mlist$scale_pars$M_lvlone["c2", "center"],
    mean(dat$longDF$c2, na.rm = TRUE)
  )
  expect_equal(
    fit$Mlist$scale_pars$M_lvlone["c2", "scale"],
    sd(dat$longDF$c2, na.rm = TRUE)
  )
})


# Back-transformation of the MCMC sample (rescale()) ---------------------------
# Scaling must not change the model: for any values of the parameters on the
# scaled scale ("draws"), the linear predictor calculated from the original
# covariates and the re-scaled parameters must be the same as the linear
# predictor calculated from the scaled covariates and the parameters on the
# scaled scale. The golden master cases are used as models.

golden_case <- function(case) {
  readRDS(test_path("golden", paste0(case, ".rds")))
}

coef_table <- function(fit) {
  do.call(rbind, get_coef_names(fit$info_list))
}

# random values for all regression coefficients and the parameters in `extra`
scaled_draws <- function(fit, extra = character(0), n = 3) {
  nam <- c(coef_table(fit)$coef, extra)
  matrix(rnorm(n * length(nam)), nrow = n, dimnames = list(NULL, nam))
}

rescale_draws <- function(fit, draws) {
  rescale(
    draws,
    coefs = coef_table(fit),
    scale_pars = do.call(rbind, unname(fit$Mlist$scale_pars)),
    info_list = fit$info_list,
    data_list = fit$data_list,
    groups = fit$Mlist$groups
  )
}

# Cross-level interactions in the mean of a random slope (hierarchical
# centring), e.g. `C1:time` with `(time | id)`, enter the JAGS model as the
# product of the separately scaled variables, w (higher level) and z (random
# slope variable), not as a scaled column: one row per such term.
slope_interactions <- function(fit) {
  do.call(
    rbind,
    lapply(fit$info_list, function(info) {
      do.call(
        rbind,
        lapply(info$hc_list$hcvars, function(lvl) {
          ia <- lvl$rd_slope_interact_coefs
          if (NROW(ia) == 0) {
            return(NULL)
          }
          z <- lvl$rd_slope_coefs[
            match(ia$rd_effect, lvl$rd_slope_coefs$rd_effect),
          ]
          data.frame(
            term = ia$term,
            w_matrix = ia$matrix,
            w_col = ia$cols,
            z_matrix = z$matrix,
            z_col = z$cols
          )
        })
      )
    })
  )
}

# one scaled column of a data matrix (rows of the lowest level)
scaled_column <- function(fit, matrix, col, sp) {
  x <- fit$data_list[[matrix]][fit$Mlist$groups[[sub("^M_", "", matrix)]], col]
  nam <- colnames(fit$data_list[[matrix]])[col]
  (x - sp[nam, "center"]) / sp[nam, "scale"]
}

# design matrix of a linear predictor (rows of the lowest level), on the
# original or the scaled scale, as in the JAGS model. Since each column is
# scaled separately, the invariance holds for any values; missing values are
# therefore replaced by random numbers (except in the variables of
# cross-level interactions, which must be complete).
design_mat <- function(fit, columns, scaled) {
  sp <- do.call(rbind, unname(fit$Mlist$scale_pars))
  sp$center[is.na(sp$center)] <- 0
  sp$scale[is.na(sp$scale)] <- 1

  X <- do.call(
    cbind,
    lapply(names(columns), function(m) {
      fit$data_list[[m]][
        fit$Mlist$groups[[sub("^M_", "", m)]],
        columns[[m]],
        drop = FALSE
      ]
    })
  )
  set.seed(2020)
  X[is.na(X)] <- rnorm(sum(is.na(X)))
  if (scaled) {
    X <- sweep(X, 2, sp[colnames(X), "center"])
    X <- sweep(X, 2, sp[colnames(X), "scale"], "/")

    ia <- slope_interactions(fit)
    for (k in which(ia$term %in% colnames(X))) {
      X[, ia$term[k]] <-
        scaled_column(fit, ia$w_matrix[k], ia$w_col[k], sp) *
        scaled_column(fit, ia$z_matrix[k], ia$z_col[k], sp)
    }
  }
  X
}

# The linear predictors of a sub-model (one per category for multinomial
# models, one per threshold for ordinal models). For each: a data.frame with
# the design-matrix column and the name of its coefficient, and the names of
# the "offsets", i.e., intercept-like parameters that are added to it: the
# thresholds of ordinal models (each with the non-proportional effects of its
# category) and the coefficients of the baseline hazard of proportional
# hazards models (each enters with weight 1, because the rows of the B-spline
# basis sum to 1).
linear_predictors <- function(info) {
  terms_df <- function(cols, pe) {
    do.call(
      rbind,
      lapply(names(cols), function(m) {
        data.frame(
          matrix = rep(m, length(cols[[m]])),
          column = names(cols[[m]]),
          par = sprintf("%s[%d]", info$parname, pe[[m]][names(cols[[m]])])
        )
      })
    )
  }

  pe <- info$parelmts[names(info$lp)]
  if (any(vapply(pe, is.list, logical(1)))) {
    return(lapply(seq_along(pe[[1]]), function(j) {
      list(
        terms = terms_df(info$lp, lapply(pe, "[[", j)),
        offsets = character(0)
      )
    }))
  }

  lp <- list(terms = terms_df(info$lp, pe), offsets = character(0))

  if (info$modeltype %in% c("coxph", "JM")) {
    lp$offsets <- sprintf(
      "beta_Bh0_%s[%d]",
      info$varname,
      seq_len(info$df_basehaz)
    )
  }

  if (info$modeltype %in% c("clm", "clmm")) {
    np_cols <- attr(info$lp, "nonprop")
    return(lapply(seq_len(info$ncat - 1), function(k) {
      np_pe <- lapply(info$parelmts[names(np_cols)], function(x) {
        attr(x, "nonprop")[[k]]
      })
      list(
        terms = rbind(lp$terms, terms_df(np_cols, np_pe)),
        offsets = sprintf("gamma_%s[%d]", info$varname, k)
      )
    }))
  }
  list(lp)
}

# linear predictor X %*% beta for each draw (columns: draws)
lp_values <- function(fit, terms, draws, scaled) {
  if (nrow(terms) == 0) {
    return(0)
  }
  X <- design_mat(fit, split(terms$column, terms$matrix), scaled = scaled)
  X %*% t(draws[, unlist(split(terms$par, terms$matrix)), drop = FALSE])
}

# the linear predictor plus each offset must be the same on both scales
expect_offsets_invariant <- function(
  eta,
  eta_scaled,
  lp,
  rescaled,
  draws,
  info
) {
  if (length(lp$offsets) == 0) {
    expect_equal(eta, eta_scaled, info = info)
  }
  for (o in lp$offsets) {
    expect_equal(
      sweep(eta, 2, rescaled[, o], "+"),
      sweep(eta_scaled, 2, draws[, o], "+"),
      info = paste(info, o)
    )
  }
}

expect_lp_invariant <- function(fit, outcome) {
  lps <- linear_predictors(fit$info_list[[outcome]])
  draws <- scaled_draws(fit, extra = unlist(lapply(lps, "[[", "offsets")))
  rescaled <- rescale_draws(fit, draws)

  for (lp in lps) {
    expect_offsets_invariant(
      eta = lp_values(fit, lp$terms, rescaled, scaled = FALSE),
      eta_scaled = lp_values(fit, lp$terms, draws, scaled = TRUE),
      lp = lp,
      rescaled = rescaled,
      draws = draws,
      info = paste(outcome, lp$terms$par[1])
    )
  }
}

# Intercept-only models have nothing to re-scale.
lp_cases <- grep(
  "intercept$",
  names(golden_cases()),
  value = TRUE,
  invert = TRUE
)

for (case in lp_cases) {
  fit <- golden_case(case)
  outcomes <- names(fit$info_list)
  test_that(
    paste("re-scaled coefficients give the same linear predictor:", case),
    {
      set.seed(2020)
      for (outcome in outcomes) {
        expect_lp_invariant(fit, outcome)
      }
    }
  )
}

test_that("cross-level interactions with a random slope are re-scaled (#74)", {
  # continuous and binary higher-level covariate; three-way interaction (the
  # higher-level part, C1:B1, is a scaled column); spline of the random-slope
  # variable (one product per spline column); binomial model; ordinal model
  # (thresholds instead of an intercept). The variables of the interactions
  # are complete.
  cases <- list(
    quote(lme_imp(
      y ~ C1 * time + B1 * time + c1 + (time | id),
      data = longDF
    )),
    quote(lme_imp(y ~ C1 * B1 * time + (time | id), data = longDF)),
    quote(lme_imp(
      y ~ ns(time, df = 2) * C1 + (ns(time, df = 2) | id),
      data = longDF
    )),
    quote(glme_imp(
      b1 ~ C1 * time + (time | id),
      family = binomial(),
      data = longDF
    )),
    quote(clmm_imp(o1 ~ C1 * time + (time | id), data = longDF))
  )
  set.seed(2020)
  for (case in cases) {
    fit <- golden_fit(case, list(longDF = JointAI::longDF))
    expect_gt(NROW(slope_interactions(fit)), 0)
    expect_lp_invariant(fit, names(fit$info_list)[1])
  }
})

# longDF with subjects nested in 5 centers and a covariate of the center level
longDF_center <- function() {
  df <- golden_data()$longDF
  set.seed(2020)
  Zc <- rnorm(nlevels(df$center), 5, 2)
  df$Zc <- Zc[as.integer(df$center)]
  df
}

higher_level_case <- quote(lme_imp(
  y ~ Zc * time + C1 + (time | id) + (1 | center),
  data = longDF
))

test_that("a higher-level covariate in the mean of a random slope (#77)", {
  set.seed(2020)
  fit <- golden_fit(higher_level_case, list(longDF = longDF_center()))

  # Zc (column 2 of M_center) is indexed via the rows of the lowest level and
  # scaled as in the mean of the random intercept of the center level (long
  # lines of the model are wrapped, so whitespace is collapsed first)
  jagsmodel <- gsub("\\s+", " ", fit$jagsmodel)
  expect_match(
    jagsmodel,
    paste0(
      "mu_b_y_id[ii, 2] <- beta[4] + ",
      "(M_center[group_center[pos_id[ii]], 2] - spM_center[2, 1])/",
      "spM_center[2, 2] * beta[5]"
    ),
    fixed = TRUE
  )
  expect_match(
    jagsmodel,
    "(M_center[iii, 2] - spM_center[2, 1])/spM_center[2, 2] * beta[2]",
    fixed = TRUE
  )

  expect_gt(NROW(slope_interactions(fit)), 0)
  expect_lp_invariant(fit, "y")
})

test_that("a model with a higher-level covariate in a random-slope mean runs (#77)", {
  # before the fix, JAGS stopped with "Index out of range" (more subjects
  # than centers)
  fit <- lme_imp(
    y ~ Zc * time + C1 + (time | id) + (1 | center),
    data = longDF_center(),
    n.adapt = 5,
    n.iter = 5,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  )
  expect_s3_class(fit$MCMC, "mcmc.list")
  expect_equal(coda::niter(fit$MCMC), 5)
})

test_that("rescale() changes coefficients only", {
  set.seed(2020)
  fit <- golden_case("lm_spline_powers")
  draws <- scaled_draws(fit, extra = c("sigma_SBP", "tau_bili"))
  rescaled <- rescale_draws(fit, draws)

  expect_identical(colnames(rescaled), colnames(draws))
  expect_identical(
    rescaled[, c("sigma_SBP", "tau_bili")],
    draws[, c("sigma_SBP", "tau_bili")]
  )
  # coefficients of columns that are not scaled are unchanged, except
  # intercepts
  coefs <- coef_table(fit)
  sp <- do.call(rbind, unname(fit$Mlist$scale_pars))
  unscaled <- coefs$coef[
    coefs$varname != "(Intercept)" & is.na(sp[coefs$varname, "center"])
  ]
  expect_true(length(unscaled) > 0)
  expect_identical(rescaled[, unscaled], draws[, unscaled])
})


# Random effects and their variance-covariance matrix --------------------------
# The random effects b and their variance-covariance matrix D are transformed
# back to the original scale. Tested via what must not change:
# * Z D Z' (Z: random-effects design matrix, rows of the lowest level),
# * Z b, up to a constant that is the same for all rows (also rows that are not
#   in the data),
# * the linear predictor of a subject: offset + sum over the levels of Z b +
#   X beta, with X the covariates that are not in the means of the random
#   effects (hierarchical centring).

z_mat <- function(fit, lvl_info, scaled) {
  z_names <- attr(lvl_info, "z_names")
  slopes <- lvl_info$rd_slope_coefs
  n <- length(fit$Mlist$groups[[1]])
  Z <- if (NROW(slopes) > 0) {
    design_mat(fit, split(slopes$term, slopes$matrix), scaled = scaled)
  } else {
    matrix(nrow = n, ncol = 0)
  }
  if (attr(lvl_info, "rd_intercept")) {
    Z <- cbind("(Intercept)" = rep(1, nrow(Z)), Z)
  }
  Z[, z_names, drop = FALSE]
}

# Names of the random effects of an outcome at a grouping level (matrix: one
# row per group, one column per random effect), the name of their
# variance-covariance matrix, and the columns of that matrix that belong to the
# outcome. With rd_vcov = "full", the random effects of several outcomes form
# one vector b_<lvl> with covariance matrix D_<lvl>; "ranef_index" gives the
# columns of each outcome (e.g. "1:2").
ranef_names <- function(fit, outcome, lvl) {
  info <- fit$info_list[[outcome]]
  nz <- length(attr(info$hc_list$hcvars[[lvl]], "z_names"))
  ng <- max(fit$Mlist$groups[[lvl]])
  rd_vcov <- info$rd_vcov[[lvl]]

  if (identical(as.character(rd_vcov), "full")) {
    name <- lvl
    cols <- eval(str2lang(attr(rd_vcov, "ranef_index")[[outcome]]))
  } else {
    name <- paste0(info$varname, "_", lvl)
    cols <- seq_len(nz)
  }

  b <- sprintf(
    "b_%s[%d,%d]",
    name,
    rep(seq_len(ng), nz),
    rep(cols, each = ng)
  )
  list(b = matrix(b, nrow = ng), D = paste0("D_", name), cols = cols)
}

# Z b for each draw (rows: lowest level; columns: draws)
zb_values <- function(fit, lvl_info, grp, b_names, draws, scaled) {
  Z <- z_mat(fit, lvl_info, scaled = scaled)
  out <- matrix(NA_real_, nrow(Z), nrow(draws))
  for (r in seq_len(nrow(draws))) {
    b <- matrix(draws[r, b_names], ncol = ncol(Z))
    out[, r] <- rowSums(Z * b[grp, , drop = FALSE])
  }
  out
}

# Z D Z' for all outcomes that share one D (one outcome, or several with
# rd_vcov = "full"), including the blocks between outcomes; Z b, and Z b at
# rows with arbitrary values of the random-slope variables
expect_ranefs_invariant <- function(fit, outcomes, lvl) {
  rn <- lapply(outcomes, function(o) ranef_names(fit, o, lvl))
  nz <- max(unlist(lapply(rn, "[[", "cols")))
  ij <- which(upper.tri(diag(nz), diag = TRUE), arr.ind = TRUE)
  D_names <- sprintf("%s[%d,%d]", rn[[1]]$D, ij[, 1], ij[, 2])

  # D on the scaled scale must be positive definite
  draws <- scaled_draws(
    fit,
    extra = c(unlist(lapply(rn, "[[", "b")), D_names)
  )
  D_scaled <- lapply(seq_len(nrow(draws)), function(r) {
    crossprod(matrix(rnorm(nz^2), nz))
  })
  for (r in seq_len(nrow(draws))) {
    draws[r, D_names] <- D_scaled[[r]][ij]
  }
  rescaled <- rescale_draws(fit, draws)

  lvl_infos <- lapply(outcomes, function(o) {
    fit$info_list[[o]]$hc_list$hcvars[[lvl]]
  })
  Z <- lapply(lvl_infos, z_mat, fit = fit, scaled = FALSE)
  Z_scaled <- lapply(lvl_infos, z_mat, fit = fit, scaled = TRUE)

  for (r in seq_len(nrow(draws))) {
    D <- matrix(NA_real_, nz, nz)
    D[ij] <- rescaled[r, D_names]
    D[ij[, 2:1]] <- rescaled[r, D_names]
    for (o in seq_along(outcomes)) {
      for (p in seq_along(outcomes)) {
        co <- rn[[o]]$cols
        cp <- rn[[p]]$cols
        expect_equal(
          Z[[o]] %*% D[co, cp, drop = FALSE] %*% t(Z[[p]]),
          Z_scaled[[o]] %*%
            D_scaled[[r]][co, cp, drop = FALSE] %*%
            t(Z_scaled[[p]]),
          info = paste(outcomes[o], outcomes[p], lvl)
        )
      }
    }
  }

  # Z b on the original scale differs from Z b on the scaled scale by a
  # constant (the part of the fixed effects that moves into the random
  # intercepts), also for values of the random-slope variables that are not
  # in the data
  for (o in seq_along(outcomes)) {
    z_names <- attr(lvl_infos[[o]], "z_names")
    ng <- nrow(rn[[o]]$b)
    grp <- rep(seq_len(ng), 2)
    sp <- do.call(rbind, unname(fit$Mlist$scale_pars))
    sp$center[is.na(sp$center)] <- 0
    sp$scale[is.na(sp$scale)] <- 1
    Z_new <- matrix(
      rnorm(length(grp) * length(z_names), 0, 3),
      ncol = length(z_names),
      dimnames = list(NULL, z_names)
    )
    Z_new[, z_names == "(Intercept)"] <- 1
    Z_new_scaled <- sweep(Z_new, 2, sp[z_names, "center"])
    Z_new_scaled <- sweep(Z_new_scaled, 2, sp[z_names, "scale"], "/")
    for (r in seq_len(nrow(draws))) {
      b <- matrix(rescaled[r, rn[[o]]$b], ng)
      b_scaled <- matrix(draws[r, rn[[o]]$b], ng)
      d <- rowSums(Z_new * b[grp, , drop = FALSE]) -
        rowSums(Z_new_scaled * b_scaled[grp, , drop = FALSE])
      expect_equal(d, rep(d[1], length(d)), info = paste(outcomes[o], lvl))
    }
  }
}

# outcomes with random effects, by grouping level and covariance matrix
ranef_groups <- function(fit) {
  out <- list()
  for (outcome in names(fit$info_list)) {
    for (lvl in names(fit$info_list[[outcome]]$hc_list$hcvars)) {
      key <- paste(lvl, ranef_names(fit, outcome, lvl)$D)
      out[[key]] <- list(lvl = lvl, outcomes = c(out[[key]]$outcomes, outcome))
    }
  }
  out
}

ranef_cases <- c(
  "glme_complex",
  "lme_indep",
  "lme_interaction_random",
  "lme_nested",
  "lme_spline_random",
  "lme_two_outcomes_full",
  "lognormmm_random_slope",
  "mlogitmm_random_interaction",
  "jm_assoc_type"
)

for (case in ranef_cases) {
  test_that(paste("re-scaled random effects and D are consistent:", case), {
    set.seed(2020)
    fit <- golden_case(case)
    for (g in ranef_groups(fit)) {
      expect_ranefs_invariant(fit, g$outcomes, g$lvl)
    }
  })
}

# Linear predictor of a subject: offset + sum over the levels of Z b + X beta,
# with X the covariates that are not in the means of the random effects
# (these enter through b).
expect_subject_lp_invariant <- function(fit, outcome) {
  info <- fit$info_list[[outcome]]
  hcvars <- info$hc_list$hcvars
  rn <- lapply(names(hcvars), function(lvl) ranef_names(fit, outcome, lvl))

  mean_terms <- character(0)
  for (lvl_info in hcvars) {
    slopes <- lvl_info$rd_slope_coefs
    mean_terms <- c(
      mean_terms,
      lvl_info$rd_intercept_coefs$term,
      slopes$term[!is.na(slopes$parelmts)],
      lvl_info$rd_slope_interact_coefs$term
    )
  }

  # random effects of all outcomes that share a covariance matrix with this
  # outcome (rd_vcov = "full"): they are transformed back together
  b_shared <- character(0)
  for (g in ranef_groups(fit)) {
    if (outcome %in% g$outcomes) {
      for (o in g$outcomes) {
        b_shared <- c(b_shared, ranef_names(fit, o, g$lvl)$b)
      }
    }
  }

  lps <- linear_predictors(info)
  draws <- scaled_draws(
    fit,
    extra = c(unlist(lapply(lps, "[[", "offsets")), b_shared)
  )
  rescaled <- rescale_draws(fit, draws)

  zb_all <- function(d, scaled) {
    out <- 0
    for (k in seq_along(hcvars)) {
      grp <- fit$Mlist$groups[[names(hcvars)[k]]]
      out <- out + zb_values(fit, hcvars[[k]], grp, rn[[k]]$b, d, scaled)
    }
    out
  }

  for (lp in lps) {
    terms <- lp$terms[!lp$terms$column %in% mean_terms, ]
    expect_offsets_invariant(
      eta = lp_values(fit, terms, rescaled, scaled = FALSE) +
        zb_all(rescaled, scaled = FALSE),
      eta_scaled = lp_values(fit, terms, draws, scaled = TRUE) +
        zb_all(draws, scaled = TRUE),
      lp = lp,
      rescaled = rescaled,
      draws = draws,
      info = paste(outcome, "subject level")
    )
  }
}

mixed_outcomes <- function(fit) {
  Filter(
    function(o) !is.null(fit$info_list[[o]]$hc_list$hcvars),
    names(fit$info_list)
  )
}

for (case in lp_cases) {
  fit <- golden_case(case)
  outcomes <- mixed_outcomes(fit)
  if (length(outcomes) == 0) {
    next
  }
  test_that(paste("linear predictor of a subject is the same:", case), {
    set.seed(2020)
    for (outcome in outcomes) {
      expect_subject_lp_invariant(fit, outcome)
    }
  })
}

test_that("linear predictor of a subject with a cross-level interaction", {
  set.seed(2020)
  fit <- golden_fit(
    quote(lme_imp(y ~ C1 * time + B1 * time + c1 + (time | id), data = longDF)),
    list(longDF = JointAI::longDF)
  )
  expect_subject_lp_invariant(fit, "y")
})

test_that("random effects are re-scaled if a random slope is incomplete", {
  set.seed(2020)
  fit <- golden_fit(
    quote(lme_imp(y ~ C1 + c2 + time + (c2 | id), data = longDF)),
    golden_data()
  )
  hc <- fit$info_list$y$hc_list
  expect_true(attr(hc$hcvars$id, "incomplete")[["c2"]])
  expect_false(is.na(fit$Mlist$scale_pars$M_lvlone["c2", "center"]))
  # no warning any more (the summary shows the warnings)
  expect_null(unlist(attr(hc, "warnings")))

  expect_ranefs_invariant(fit, "y", "id")
  expect_subject_lp_invariant(fit, "y")
})

test_that("random effects are re-scaled if a coefficient could be in two levels (#76)", {
  # the coefficient is in the means of the random effects of the highest
  # level only (center). The issue example, `C1 * time + (time | id) +
  # (C1 | center)`, is not included: with the interaction C1:time in the mean
  # of the random slope of time, the random effects of the center level are
  # not transformed back correctly (also before #76; F21 in the dev notes).
  cases <- list(
    quote(lme_imp(y ~ C1 + time + (time | id) + (C1 | center), data = longDF)),
    quote(lme_imp(y ~ time + (time | id) + (time | center), data = longDF)),
    quote(lme_imp(
      y ~ C1 * time + (time | id) + (C1 * time | center),
      data = longDF
    ))
  )
  set.seed(2020)
  for (case in cases) {
    fit <- golden_fit(case, golden_data())
    expect_lp_invariant(fit, "y")
    for (g in ranef_groups(fit)) {
      expect_ranefs_invariant(fit, g$outcomes, g$lvl)
    }
    expect_subject_lp_invariant(fit, "y")
  }
})

test_that("rescale_vcov() transforms each iteration of D (#67)", {
  # 1 x 1 (occurs for a random slope without random intercept)
  MCMC <- cbind("D_y_id[1,1]" = c(1, 2, 3), other = c(5, 6, 7))
  rescaled <- rescale_vcov(MCMC, "D_y_id", A = matrix(2))
  expect_equal(rescaled[, "D_y_id[1,1]"], c(4, 8, 12))
  expect_identical(rescaled[, "other"], MCMC[, "other"])

  # 2 x 2: A D A' per iteration
  A <- matrix(c(1, 0.5, 0, 2), 2)
  D_names <- c("D_y_id[1,1]", "D_y_id[1,2]", "D_y_id[2,2]")
  MCMC <- rbind(c(1, 0.2, 2), c(3, -0.5, 1))
  colnames(MCMC) <- D_names
  rescaled <- rescale_vcov(MCMC, "D_y_id", A = A)
  for (r in 1:2) {
    D <- matrix(MCMC[r, c(1, 2, 2, 3)], 2)
    expect_equal(
      rescaled[r, D_names],
      (A %*% D %*% t(A))[c(1, 3, 4)],
      ignore_attr = TRUE
    )
  }
})


# Parameters to monitor --------------------------------------------------------

test_that("all betas are monitored if one beta is monitored and covariates are scaled", {
  setup <- function(scale_vars) {
    lm_imp(
      y ~ C1 + C2,
      data = wideDF,
      monitor_params = c(analysis_main = FALSE, other = "beta[2]"),
      scale_vars = scale_vars,
      n.adapt = 0,
      n.iter = 0,
      seed = 2020,
      warn = FALSE
    )
  }
  # (suppressMessages() for the note that no MCMC sample is created)
  suppressMessages(expect_message(fit <- setup(NULL), "betas = TRUE"))
  expect_true("beta" %in% fit$mcmc_settings$variable.names)

  suppressMessages(
    expect_no_message(fit <- setup(FALSE), message = "betas = TRUE")
  )
  expect_identical(fit$mcmc_settings$variable.names, "beta[2]")
})

# With scaled covariates, transforming random effects back needs the whole row
# of b of a group (A mixes the random effects of a group), the whole covariance
# matrix (D = A D_s A'), and the regression coefficients of the sub-model (for
# delta). Only these are added to the monitored parameters, not all random
# effects.
setup_monitor <- function(other, analysis_main = TRUE, scale_vars = NULL) {
  lme_imp(
    y ~ C1 + c1 + time + (time | id),
    data = longDF,
    monitor_params = list(analysis_main = analysis_main, other = other),
    scale_vars = scale_vars,
    n.adapt = 0,
    n.iter = 0,
    seed = 2020,
    warn = FALSE
  )
}

test_that("monitoring of random effects is completed for re-scaling", {
  # (suppressMessages() for the note that no MCMC sample is created)

  # one element of b: the rest of its row is added
  suppressMessages(expect_message(
    fit <- setup_monitor("b_y_id[5,2]"),
    "b_y_id\\[5,1:2\\]"
  ))
  vn <- fit$mcmc_settings$variable.names
  expect_true("b_y_id[5,1:2]" %in% vn)
  expect_false("b_y_id[5,2]" %in% vn)

  # random effects without the regression coefficients: the coefficients of
  # the sub-model are added
  suppressMessages(expect_message(
    fit <- setup_monitor("b_y_id", analysis_main = FALSE),
    "beta\\[1\\]"
  ))
  vn <- fit$mcmc_settings$variable.names
  expect_true("b_y_id" %in% vn)
  expect_true(all(fit$coef_list$y$coef %in% vn))

  # one element of D: the whole matrix (upper triangle, as monitored by
  # default) is added
  suppressMessages(expect_message(
    fit <- setup_monitor("D_y_id[1,2]", analysis_main = FALSE),
    "D_y_id\\[1,1\\]"
  ))
  vn <- fit$mcmc_settings$variable.names
  expect_true(all(c("D_y_id[1,1]", "D_y_id[1,2]", "D_y_id[2,2]") %in% vn))

  # without scaling, nothing is added
  suppressMessages(expect_no_message(
    fit <- setup_monitor("b_y_id[5,2]", scale_vars = FALSE),
    message = "re-scal"
  ))
  expect_identical(
    sort(fit$mcmc_settings$variable.names),
    sort(c(
      "beta",
      "sigma_y",
      "D_y_id[1,1]",
      "D_y_id[1,2]",
      "D_y_id[2,2]",
      "b_y_id[5,2]"
    ))
  )
})

test_that("monitored random effects are transformed back (short MCMC run)", {
  fit <- suppressMessages(suppressWarnings(lme_imp(
    y ~ C1 + c1 + time + (time | id),
    data = longDF,
    monitor_params = list(analysis_main = FALSE, other = "b_y_id[5,2]"),
    n.adapt = 10,
    n.iter = 5,
    seed = 2020,
    keep_scaled_mcmc = TRUE,
    mess = FALSE
  )))
  # the transformed value differs from the one on the scaled scale
  expect_false(isTRUE(all.equal(
    fit$MCMC[[1]][, "b_y_id[5,2]"],
    fit$sample[[1]][, "b_y_id[5,2]"]
  )))
})
