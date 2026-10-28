# Scaling of continuous covariates (R/scaling.R and where the scaling
# parameters are used). The models are set up but not sampled (golden_fit()
# from helper-golden.R). Overview: dev/SCALING.md (local notes).

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

# design matrix of a linear predictor (rows of the lowest level), on the
# original or the scaled scale. Since each column is scaled separately, the
# invariance holds for any values; missing values are therefore replaced by
# random numbers.
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
  }
  X
}

# names of the parameters of each linear predictor of a sub-model (one per
# category for multinomial models)
lp_parameters <- function(info) {
  pe <- info$parelmts[names(info$lp)]
  idx <- if (any(vapply(pe, is.list, logical(1)))) {
    lapply(seq_along(pe[[1]]), function(j) unlist(lapply(pe, "[[", j)))
  } else {
    list(unlist(pe))
  }
  lapply(idx, function(i) paste0(info$parname, "[", i, "]"))
}

expect_lp_invariant <- function(fit, outcome) {
  info <- fit$info_list[[outcome]]
  draws <- scaled_draws(fit)
  rescaled <- rescale_draws(fit, draws)
  X <- design_mat(fit, info$lp, scaled = FALSE)
  X_scaled <- design_mat(fit, info$lp, scaled = TRUE)

  for (pars in lp_parameters(info)) {
    expect_equal(
      X %*% t(rescaled[, pars, drop = FALSE]),
      X_scaled %*% t(draws[, pars, drop = FALSE]),
      info = paste(outcome, pars[1])
    )
  }
}

# Not (yet) back-transformed correctly, tested in the PRs that fix them (see
# dev/SCALING.md): thresholds of ordinal models and the baseline hazard of
# survival models (F1); the intercept of survreg models (F6). Intercept-only
# models have nothing to re-scale.
lp_cases <- grep(
  "intercept$",
  names(golden_cases()),
  value = TRUE,
  invert = TRUE
)
lp_skip_types <- c("clm", "clmm", "coxph", "JM", "survreg")

for (case in lp_cases) {
  fit <- golden_case(case)
  types <- vapply(fit$info_list, "[[", "modeltype", FUN.VALUE = character(1))
  outcomes <- names(fit$info_list)[!types %in% lp_skip_types]
  if (length(outcomes) == 0) {
    next
  }
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
# Z b (Z: random effects design matrix) and Z D Z' must be the same on the
# original and the scaled scale. Not included: rd_vcov = "full" with several
# outcomes (lme_two_outcomes_full), where b and D are not re-scaled (F7).

z_mat <- function(fit, lvl_info, scaled) {
  z_names <- attr(lvl_info, "z_names")
  slopes <- lvl_info$rd_slope_coefs
  columns <- split(slopes$term, slopes$matrix)
  Z <- design_mat(fit, columns, scaled = scaled)
  if (attr(lvl_info, "rd_intercept")) {
    Z <- cbind("(Intercept)" = 1, Z)
  }
  Z[, z_names, drop = FALSE]
}

ranef_cases <- c(
  "glme_complex",
  "lme_indep",
  "lme_interaction_random",
  "lme_nested",
  "lme_spline_random",
  "lognormmm_random_slope",
  "mlogitmm_random_interaction",
  "jm_assoc_type"
)

expect_ranefs_invariant <- function(fit, outcome, lvl) {
  info <- fit$info_list[[outcome]]
  lvl_info <- info$hc_list$hcvars[[lvl]]
  nz <- length(attr(lvl_info, "z_names"))
  ng <- max(fit$Mlist$groups[[lvl]])
  b_names <- sprintf(
    "b_%s_%s[%d,%d]",
    info$varname,
    lvl,
    rep(seq_len(ng), nz),
    rep(seq_len(nz), each = ng)
  )
  ij <- which(upper.tri(diag(nz), diag = TRUE), arr.ind = TRUE)
  D_names <- sprintf("D_%s_%s[%d,%d]", info$varname, lvl, ij[, 1], ij[, 2])

  # D on the scaled scale must be positive definite
  draws <- scaled_draws(fit, extra = c(b_names, D_names))
  D_scaled <- lapply(seq_len(nrow(draws)), function(r) {
    crossprod(matrix(rnorm(nz^2), nz))
  })
  for (r in seq_len(nrow(draws))) {
    draws[r, D_names] <- D_scaled[[r]][ij]
  }
  rescaled <- rescale_draws(fit, draws)

  Z <- z_mat(fit, lvl_info, scaled = FALSE)
  Z_scaled <- z_mat(fit, lvl_info, scaled = TRUE)
  grp <- fit$Mlist$groups[[lvl]]
  for (r in seq_len(nrow(draws))) {
    b <- matrix(rescaled[r, b_names], ng)
    b_scaled <- matrix(draws[r, b_names], ng)
    expect_equal(
      rowSums(Z * b[grp, ]),
      rowSums(Z_scaled * b_scaled[grp, ]),
      info = paste(outcome, lvl)
    )

    D <- matrix(NA_real_, nz, nz)
    D[ij] <- rescaled[r, D_names]
    D[ij[, 2:1]] <- rescaled[r, D_names]
    expect_equal(
      Z %*% D %*% t(Z),
      Z_scaled %*% D_scaled[[r]] %*% t(Z_scaled),
      info = paste(outcome, lvl)
    )
  }
}

for (case in ranef_cases) {
  test_that(paste("re-scaled random effects and D are consistent:", case), {
    set.seed(2020)
    fit <- golden_case(case)
    for (outcome in names(fit$info_list)) {
      hcvars <- fit$info_list[[outcome]]$hc_list$hcvars
      for (lvl in names(hcvars)) {
        # random slopes only
        if (length(attr(hcvars[[lvl]], "z_names")) > 1) {
          expect_ranefs_invariant(fit, outcome, lvl)
        }
      }
    }
  })
}

test_that("random effects are not re-scaled if a random slope is incomplete", {
  set.seed(2020)
  fit <- golden_fit(
    quote(lme_imp(y ~ C1 + c2 + time + (c2 | id), data = longDF)),
    golden_data()
  )
  hc <- fit$info_list$y$hc_list
  expect_true(attr(hc$hcvars$id, "incomplete")[["c2"]])
  expect_false(is.na(fit$Mlist$scale_pars$M_lvlone["c2", "center"]))
  # warning that is shown in the summary
  expect_match(attr(hc, "warnings")$id, "not be possible to re-scale")

  ranefs <- c(
    sprintf("b_y_id[%d,%d]", 1:3, 1L),
    sprintf("b_y_id[%d,%d]", 1:3, 2L),
    "D_y_id[1,1]",
    "D_y_id[1,2]",
    "D_y_id[2,2]"
  )
  draws <- scaled_draws(fit, extra = ranefs)
  rescaled <- rescale_draws(fit, draws)
  expect_identical(rescaled[, ranefs], draws[, ranefs])
  # the fixed effects are re-scaled
  expect_lp_invariant(fit, "y")
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
