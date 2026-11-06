# list_models() describes the whole model (#113): non-proportional effects,
# the coefficients of multinomial models per category, truncation, random
# effects and the covariance matrix of the random effects with its prior.
# The models are set up without JAGS run (n.adapt = 0, n.iter = 0).

skip_on_cran()

# coefficients of each category of a multinomial (mixed) model: the printed
# indices are those of coef_list
test_that("list_models(): coefficients of multinomial models per category", {
  dat <- longDF
  dat$m1 <- factor(dat$o1, ordered = FALSE)
  fit <- mlogitmm_imp(
    m1 ~ C1 + c1 + time + (time | id),
    data = dat,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  coefs <- fit$coef_list[["m1"]]

  for (category in unique(coefs$outcat)) {
    line <- grep(paste0("^  ", category, ": "), out, value = TRUE)
    expect_length(line, 1L)
    ranges <- regmatches(
      line,
      gregexpr("(?<=beta\\[)[0-9:]+(?=\\])", line, perl = TRUE)
    )[[1L]]
    printed <- unlist(lapply(ranges, function(r) eval(str2lang(r))))
    expected <- as.integer(gsub(
      "\\D",
      "",
      coefs$coef[coefs$outcat %in% category]
    ))
    expect_equal(sort(printed), sort(expected), info = category)
  }
})

test_that("list_models(): non-proportional effects", {
  fit <- clm_imp(
    O1 ~ C1 + C2,
    data = wideDF,
    nonprop = ~C1,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  coefs <- fit$coef_list[["O1"]]

  # C1 is listed as variable with non-proportional effects
  i <- which(out == "* Predictor variables with non-proportional effects:")
  expect_length(i, 1L)
  expect_identical(trimws(out[i + 1L]), "C1")

  # the coefficients of each category, as in coef_list
  i <- which(
    out == "* Regression coefficients of the non-proportional effects:"
  )
  expect_length(i, 1L)
  nonprop <- coefs[!is.na(coefs$outcat), ]
  expect_identical(
    out[i + seq_len(nrow(nonprop))],
    c(
      paste0(
        "  ",
        nonprop$outcat[-nrow(nonprop)],
        ": ",
        nonprop$coef[-nrow(nonprop)]
      ),
      paste0(
        "  ",
        nonprop$outcat[nrow(nonprop)],
        ": ",
        nonprop$coef[nrow(nonprop)],
        " (normal prior(s) with mean 0 and precision 1e-04) "
      )
    )
  )
  # the proportional effect (the first model is the model for O1)
  i <- which(out == "* Regression coefficients:")[1L]
  expect_identical(
    out[i + 1L],
    paste0(
      "  ",
      coefs$coef[is.na(coefs$outcat)],
      " (normal prior(s) with mean 0 and precision 1e-04) "
    )
  )
})

test_that("list_models(): truncation", {
  fit <- lm_imp(
    y ~ C1 + C2,
    data = wideDF,
    trunc = list(y = c(-5, 50), C2 = c(0, NA)),
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  expect_identical(
    out[which(out == "* Truncation:") + 1L],
    c("  lower limit -5, upper limit 50", "  lower limit 0")
  )
})

test_that("list_models(): random effects, block-diagonal covariance matrix", {
  fit <- lme_imp(
    y ~ C1 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  i <- which(out == "* Random effects on the level of \"id\":")
  expect_length(i, 1L)
  expect_identical(
    out[i + 1:5],
    c(
      "  b_y_id[, 1:2]: (Intercept), time",
      "* Covariance matrix of the random effects on the level of \"id\":",
      "  D_y_id[1:2, 1:2] = inverse(invD_y_id)",
      "  invD_y_id[1:2, 1:2] (Wishart prior with scale matrix RinvD_y_id and 3 degrees of freedom)",
      "  RinvD_y_id[1:2, 1:2] (diagonal; Gamma priors with shape parameter 0.01 and rate parameter 0.001)"
    )
  )
  # the numbers are those of the data list
  expect_equal(unname(fit$data_list$KinvD_y_id), 3)
  expect_equal(as.numeric(fit$data_list$shape_diag_RinvD), 0.01)
  expect_equal(as.numeric(fit$data_list$rate_diag_RinvD), 0.001)
})

test_that("list_models(): random effects, independent and single", {
  fit <- lme_imp(
    y ~ C1 + time + (time | id),
    data = longDF,
    rd_vcov = "indep",
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  i <- which(
    out == "* Covariance matrix of the random effects on the level of \"id\":"
  )
  expect_identical(
    out[i + 1:2],
    c(
      "  D_y_id[1:2, 1:2] = inverse(invD_y_id) (diagonal)",
      "  invD_y_id[1:2, 1:2] (diagonal; Gamma priors with shape parameter 0.01 and rate parameter 0.001)"
    )
  )

  # a random intercept as frailty in a proportional hazards model
  fit <- coxph_imp(
    Surv(time, status) ~ age + (1 | inst),
    data = survival::lung,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  i <- which(out == "* Random effects on the level of \"inst\":")
  expect_length(i, 1L)
  expect_identical(
    out[i + 1:4],
    c(
      "  b_Surv_time_stats_inst[, 1]: (Intercept)",
      "* Covariance matrix of the random effects on the level of \"inst\":",
      "  D_Surv_time_stats_inst[1, 1] = 1 / invD_Surv_time_stats_inst[1, 1]",
      "  invD_Surv_time_stats_inst[1, 1] (Gamma prior with shape parameter 0.01 and rate parameter 0.001)"
    )
  )
})

test_that("list_models(): random effects with a shared covariance matrix", {
  fit <- lme_imp(
    list(y ~ C1 + time + (time | id), c1 ~ time + (1 | id)),
    data = longDF,
    rd_vcov = "full",
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit))
  expect_identical(
    grep("^  b_id\\[", out, value = TRUE),
    c("  b_id[, 1:2]: (Intercept), time", "  b_id[, 3]: (Intercept)")
  )
  expect_identical(
    grep("shared by", out, value = TRUE),
    rep("  (shared by the random effects of \"y\" and \"c1\")", 2L)
  )
  expect_identical(
    unique(grep("^  D_id", out, value = TRUE)),
    "  D_id[1:3, 1:3] = inverse(invD_id)"
  )
})

test_that("list_models(): random effects follow otherpars and priors", {
  fit <- lme_imp(
    y ~ C1 + time + (time | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE
  )
  out <- capture.output(list_models(fit, otherpars = FALSE))
  expect_false(any(grepl("Random effects|Covariance matrix", out)))

  out <- capture.output(list_models(fit, priors = FALSE))
  expect_true(any(grepl("Random effects", out)))
  expect_false(any(grepl("prior|Wishart|RinvD", out)))
})

test_that("list_models(): layout", {
  out <- capture.output(list_models(fixture_load("jm")))
  # no double spaces and no space before the colon
  expect_false(any(grepl("\\S  \\S", out)))
  expect_false(any(grepl(" :$", out)))
  expect_true(any(out == "* Precision of \"chol\":"))
  # headings start with a capital letter
  headings <- grep("^\\* ", out, value = TRUE)
  expect_true(all(grepl("^\\* [A-Z]", headings)))
  # two empty lines between the models, also after the association types
  i <- which(out == "* Association types:")
  expect_identical(out[i + 1:3], c("  - chol: underl.value", "", ""))
  expect_match(out[i + 4L], "^Linear mixed model for")
})


# the helper functions ----------------------------------------------------------

test_that("print_trunc()", {
  expect_output(print_trunc(c(0, NA)), "^\\* Truncation:\n  lower limit 0$")
  expect_output(print_trunc(c(NA, 3)), "^\\* Truncation:\n  upper limit 3$")
  expect_output(
    print_trunc(c(-1, 1)),
    "^\\* Truncation:\n  lower limit -1, upper limit 1$"
  )
})

test_that("the helper functions print nothing when there is nothing to print", {
  info <- list(
    modeltype = "glm",
    family = "gaussian",
    parname = "beta",
    varname = "y",
    lp = list(M_lvlone = NULL),
    parelmts = list(M_lvlone = integer(0L)),
    hc_list = NULL
  )
  expect_silent(print_regcoef(info, list(), priors = TRUE))
  expect_silent(print_nonprop_predvars(info))
  expect_silent(print_nonprop_regcoef(info, list(), priors = TRUE))
  expect_silent(print_ranefs(info, list(), priors = TRUE))
})

test_that("print_regcoef(): one range, or one line per category", {
  data_list <- list(mu_reg_norm = 0, tau_reg_norm = 1e-04)
  info <- list(
    modeltype = "glm",
    family = "gaussian",
    parname = "alpha",
    parelmts = list(M_id = c(a = 3L, b = 4L), M_lvlone = c(c = 5L))
  )
  expect_identical(
    capture.output(print_regcoef(info, data_list, priors = FALSE)),
    c("* Regression coefficients:", "  alpha[3:5] ")
  )

  data_list <- list(mu_reg_multinomial = 0, tau_reg_multinomial = 1e-04)
  info <- list(
    modeltype = "mlogitmm",
    family = NULL,
    parname = "beta",
    parelmts = list(
      M_id = list(x2 = 1:2, x3 = 3:4),
      M_lvlone = list(x2 = 5L, x3 = 6L)
    )
  )
  expect_identical(
    capture.output(print_regcoef(info, data_list, priors = FALSE)),
    c(
      "* Regression coefficients:",
      "  x2: beta[1:2], beta[5]",
      "  x3: beta[3:4], beta[6] "
    )
  )
})
