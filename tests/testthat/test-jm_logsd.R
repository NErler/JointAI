# Sub-models for the log of a residual standard deviation in a joint model:
# `logsd(y) ~ ...` in the list of model formulas of JM_imp().

skip_on_cran()

logsd_data <- function() {
  d <- golden_data()$PBC_small
  d$y <- log(d$bili)
  d
}

logsd_setup <- function(
  survfml = Surv(futime, status != "censored") ~ age + y + exp(logsd(y)),
  logsdfml = logsd(y) ~ day + (day | id),
  yfml = y ~ day + (day | id),
  ...,
  n.adapt = 0L,
  n.iter = 0L
) {
  JM_imp(
    list(survfml, yfml, logsdfml),
    timevar = "day",
    data = logsd_data(),
    n.adapt = n.adapt,
    n.iter = n.iter,
    n.chains = 1L,
    seed = 1234L,
    ...
  )
}

model_lines <- function(fit) {
  strsplit(fit$jagsmodel, "\n", fixed = TRUE)[[1L]]
}

test_that("replace_logsd_calls() replaces the calls in all parts of a formula", {
  expect_identical(
    replace_logsd_calls(quote(age + exp(logsd(y)) + age:logsd(x))),
    quote(age + exp(logsd.y) + age:logsd.x)
  )
  expect_identical(replace_logsd_calls(quote(a + b)), quote(a + b))
  expect_error(replace_logsd_calls(quote(logsd(log(y)))), "one variable")
})

test_that("models without logsd() are not changed", {
  fmla <- list(y ~ day + (day | id))
  d <- logsd_data()
  res <- prepare_logsd_models(fmla, d, "JM")

  expect_identical(res$formula, fmla)
  expect_identical(res$data, d)
  expect_null(res$logsd_of)
})

test_that("the model text has a precision calculated from the log standard deviation", {
  fit <- logsd_setup()
  lines <- trimws(model_lines(fit))

  # the model for the outcome
  expect_true(any(grepl("~ dnorm(mu_y[i], tau_y[i])", lines, fixed = TRUE)))
  expect_true("tau_y[i] <- 1/(exp(mu_logsd.y[i])^2)" %in% lines)
  expect_true(any(grepl(
    "~ dnorm(mugk_y[ii, k], taugk_y[ii, k])",
    lines,
    fixed = TRUE
  )))
  expect_true("taugk_y[ii, k] <- 1/(exp(mugk_logsd.y[ii, k])^2)" %in% lines)

  # the log standard deviation has no distribution
  col <- match("logsd.y", colnames(fit$data_list$M_lvlone))
  expect_true(paste0("M_lvlone[i, ", col, "] <- mu_logsd.y[i]") %in% lines)
  expect_true(
    paste0("M_lvlonegk[ii, ", col, ", k] <- mugk_logsd.y[ii, k]") %in% lines
  )

  # no precision as a parameter
  expect_false(any(grepl("dgamma(shape_tau_norm", lines, fixed = TRUE)))
  expect_false(any(grepl("sigma_", lines, fixed = TRUE)))
  expect_false("shape_tau_norm" %in% names(fit$data_list))
})

test_that("the log standard deviation is not data and is not scaled", {
  fit <- logsd_setup()
  M <- fit$data_list$M_lvlone
  sp <- fit$data_list$spM_lvlone

  expect_true(all(is.na(M[, c("logsd.y", "exp(logsd.y)")])))
  expect_true(all(is.na(sp[c("logsd.y", "exp(logsd.y)"), ])))
  expect_false(anyNA(sp["y", ]))
  col <- match("logsd.y", colnames(M))
  expect_true(all(is.na(fit$data_list$M_lvlonegk[, col, ])))
  expect_true(all(is.na(fit$data$logsd.y)))
  expect_identical(fit$Mlist$logsd_of, c(logsd.y = "y"))
})

test_that("functions and interactions of the log standard deviation are not scaled", {
  fit <- logsd_setup(
    survfml = Surv(futime, status != "censored") ~ age +
      logsd(y) +
      age:logsd(y)
  )
  M <- fit$data_list$M_lvlone
  sp <- fit$data_list$spM_lvlone

  expect_true(all(is.na(M[, "age:logsd.y"])))
  expect_true(all(is.na(sp[c("logsd.y", "age:logsd.y"), ])))
})

test_that("the parameters are those of an ordinary sub-model", {
  fit <- logsd_setup()
  monitored <- fit$mcmc_settings$variable.names

  expect_true(any(grepl("^D_logsd\\.y_id\\[", monitored)))
  expect_false(any(grepl("^(sigma|tau)_", monitored)))
  expect_setequal(fit$coef_list$logsd.y$varname, c("(Intercept)", "day"))
  expect_match(fit$coef_list$logsd.y$coef, "^beta\\[")
  expect_true(
    "b_logsd.y_id[ii, 1:2] ~ dmnorm(mu_b_logsd.y_id[ii, ], invD_logsd.y_id[ , ])" %in%
      trimws(model_lines(fit))
  )
  expect_true(all(
    c("RinvD_logsd.y_id", "KinvD_logsd.y_id") %in% names(fit$data_list)
  ))
})

test_that("JAGS accepts the different ways of using the log standard deviation", {
  fmls <- list(
    log_sd = Surv(futime, status != "censored") ~ age + y + logsd(y),
    sd_only = Surv(futime, status != "censored") ~ age + exp(logsd(y)),
    not_used = Surv(futime, status != "censored") ~ age + y
  )
  for (fml in fmls) {
    fit <- logsd_setup(survfml = fml)
    expect_true(any(grepl(
      "mugk_logsd.y[ii, k] <-",
      model_lines(fit),
      fixed = TRUE
    )))
    expect_s3_class(
      rjags::jags.model(
        textConnection(fit$jagsmodel),
        data = fit$data_list,
        inits = fit$mcmc_settings$inits[1L],
        n.chains = 1L,
        n.adapt = 0L,
        quiet = TRUE
      ),
      "jags"
    )
  }
})

test_that("no warning about an unlinked outcome for the outcome or its log standard deviation", {
  expect_no_warning(
    logsd_setup(survfml = Surv(futime, status != "censored") ~ age + y),
    message = "assumed to be independent"
  )
  expect_no_warning(
    logsd_setup(survfml = Surv(futime, status != "censored") ~ age + logsd(y)),
    message = "assumed to be independent"
  )
})

# the message of an error, on one line (error messages are wrapped)
error_text <- function(expr) {
  msg <- tryCatch(
    {
      expr
      NA_character_
    },
    error = function(e) conditionMessage(e)
  )
  gsub("\\s+", " ", msg)
}

test_that("informative errors", {
  d <- logsd_data()
  surv <- Surv(futime, status != "censored") ~ age + y + exp(logsd(y))

  # only in joint models
  expect_match(
    error_text(lme_imp(
      list(y ~ day + (day | id), logsd(y) ~ day + (day | id)),
      data = d,
      n.adapt = 0L
    )),
    "only available in joint models",
    fixed = TRUE
  )

  # used without a model
  expect_match(
    error_text(JM_imp(
      list(surv, y ~ day + (day | id)),
      timevar = "day",
      data = d
    )),
    "there is no model for it",
    fixed = TRUE
  )

  # no model for the outcome
  expect_match(
    error_text(JM_imp(
      list(
        Surv(futime, status != "censored") ~ age + logsd(y),
        logsd(y) ~ day + (day | id)
      ),
      timevar = "day",
      data = d
    )),
    "needs a model for",
    fixed = TRUE
  )

  # name in the data
  d2 <- d
  d2$logsd.y <- 1
  expect_match(
    error_text(JM_imp(
      list(surv, y ~ day + (day | id), logsd(y) ~ day + (day | id)),
      timevar = "day",
      data = d2
    )),
    "column of this name",
    fixed = TRUE
  )

  # no random effects
  expect_match(
    error_text(logsd_setup(logsdfml = logsd(y) ~ day)),
    "needs linear mixed models",
    fixed = TRUE
  )

  # not a linear mixed model for the outcome
  expect_match(
    error_text(logsd_setup(models = c(y = "glmm_gamma_log"))),
    "needs linear mixed models",
    fixed = TRUE
  )
})


# JAGS as calculator ----------------------------------------------------------
# With all parameters fixed as data, the model text is compared with an
# independent calculation in R of the intended model.
test_that("the precision and the survival part are the intended functions", {
  fit <- logsd_setup()
  dl <- fit$data_list
  surv <- fit$info_list[[1L]]$varname
  coefs <- fit$coef_list[[1L]]
  n <- nrow(dl$M_id)

  set.seed(2345L)
  beta <- rnorm(
    max(as.integer(gsub(
      "\\D",
      "",
      unlist(
        lapply(fit$coef_list, "[[", "coef")
      )
    ))),
    sd = 0.2
  )
  beta_h0 <- rnorm(fit$Mlist$df_basehaz, mean = -1, sd = 0.2)
  b_y <- matrix(rnorm(2L * n, sd = 0.3), ncol = 2L)
  b_logsd <- matrix(rnorm(2L * n, sd = 0.3), ncol = 2L)

  dl$beta <- beta
  dl[[paste0("beta_Bh0_", surv)]] <- beta_h0
  dl$b_y_id <- b_y
  dl$b_logsd.y_id <- b_logsd

  model <- rjags::jags.model(
    textConnection(fit$jagsmodel),
    data = dl,
    inits = fit$mcmc_settings$inits[1L],
    n.chains = 1L,
    n.adapt = 0L,
    quiet = TRUE
  )
  res <- rjags::jags.samples(
    model,
    variable.names = c(
      "tau_y",
      "taugk_y",
      paste0("logh_", surv),
      paste0("Surv_", surv)
    ),
    n.iter = 1L,
    progress.bar = "none"
  )
  value <- function(name) drop(res[[name]])

  # coefficient per column of the survival part
  beta_of <- function(column) {
    beta[as.integer(gsub("\\D", "", coefs$coef[coefs$varname == column]))]
  }
  scaled <- function(x, column, sp) {
    (x - sp[column, "center"]) / sp[column, "scale"]
  }

  # at the observations
  sp <- dl$spM_lvlone
  time <- scaled(dl$M_lvlone[, "day"], "day", sp)
  group <- dl$group_id
  mu <- b_y[group, 1L] + b_y[group, 2L] * time
  logsd <- b_logsd[group, 1L] + b_logsd[group, 2L] * time

  expect_equal(as.numeric(value("tau_y")), unname(1 / exp(logsd)^2))

  # the log hazard at the event times
  srow <- dl[[paste0("srow_", surv)]]
  age <- scaled(dl$M_id[, "age"], "age", dl$spM_id)
  logh0 <- drop(dl[[paste0("Bh0_", surv)]] %*% beta_h0)
  expect_equal(
    as.numeric(value(paste0("logh_", surv))),
    unname(
      logh0 +
        age * beta_of("age") +
        scaled(mu[srow], "y", sp) * beta_of("y") +
        exp(logsd[srow]) * beta_of("exp(logsd.y)")
    )
  )

  # at the quadrature points
  gk_time <- scaled(
    dl$M_lvlonegk[, match("day", colnames(dl$M_lvlone)), ],
    "day",
    sp
  )
  mu_gk <- b_y[, 1L] + b_y[, 2L] * gk_time
  logsd_gk <- b_logsd[, 1L] + b_logsd[, 2L] * gk_time

  expect_equal(as.numeric(value("taugk_y")), as.numeric(1 / exp(logsd_gk)^2))

  bsh0 <- dl[[paste0("Bsh0_", surv)]]
  expected_surv <- matrix(nrow = n, ncol = 15L)
  for (ii in seq_len(n)) {
    logh0s <- drop(bsh0[, ii, ] %*% beta_h0)
    expected_surv[ii, ] <- dl$gkw *
      exp(
        logh0s +
          scaled(mu_gk[ii, ], "y", sp) * beta_of("y") +
          exp(logsd_gk[ii, ]) * beta_of("exp(logsd.y)")
      )
  }
  expect_equal(
    matrix(as.numeric(value(paste0("Surv_", surv))), nrow = n),
    expected_surv
  )
})


# after sampling --------------------------------------------------------------
test_that("each sub-model has its own parameters in the summary", {
  fit <- suppressWarnings(logsd_setup(n.adapt = 10L, n.iter = 10L))
  res <- summary(fit)$res

  expect_named(res, c(names(fit$info_list)))

  expect_identical(
    rownames(res$y$rd_vcov$id),
    c("D_y_id[1,1]", "D_y_id[1,2]", "D_y_id[2,2]")
  )
  expect_identical(
    rownames(res$logsd.y$rd_vcov$id),
    c("D_logsd.y_id[1,1]", "D_logsd.y_id[1,2]", "D_logsd.y_id[2,2]")
  )
  expect_null(res$y$sigma)
  expect_null(res$y$otherpars)
  expect_null(res$logsd.y$sigma)
  expect_null(res$logsd.y$otherpars)
  expect_identical(rownames(res$logsd.y$regcoef), c("(Intercept)", "day"))
  expect_true("exp(logsd.y)" %in% rownames(res[[1L]]$regcoef))
})

test_that("add_samples() works", {
  fit <- suppressWarnings(logsd_setup(n.adapt = 10L, n.iter = 5L))
  fit2 <- suppressWarnings(add_samples(fit, n.iter = 5L))
  expect_identical(nrow(fit2$MCMC[[1L]]), 10L)
})
