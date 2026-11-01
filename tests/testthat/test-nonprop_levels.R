# Non-proportional effects of an ordinal outcome on a level above the outcome,
# on the level of the outcome, or on both, in a cumulative logit mixed model and
# in the model for an ordinal time-varying covariate of a joint model. The JAGS
# model is set up (n.adapt = 0, n.iter = 0), and its text is checked.

nonprop_data <- function() {
  dat <- subset(PBC, id %in% unique(PBC$id)[1:30])
  set.seed(1)
  dat$O <- cut(
    dat$albumin + rnorm(nrow(dat), sd = 0.2),
    breaks = 3,
    labels = c("a", "b", "c"),
    ordered_result = TRUE
  )
  # a level above the subjects, with a covariate
  subjects <- unique(dat$id)
  centers <- sample(rep(1:5, length.out = length(subjects)))
  dat$center <- centers[match(dat$id, subjects)]
  dat$z <- c(0.1, 1.8, 2.0, -4.6, 0.7)[dat$center]
  dat
}

# the lines of the model text, with the linear predictors that were spread over
# multiple lines written on one line
model_lines <- function(fit) {
  text <- gsub("\\+[[:space:]]*\n[[:space:]]*", "+ ", fit$jagsmodel)
  trimws(strsplit(text, "\n")[[1L]])
}

# the line that defines a given node
get_definition <- function(lines, node) {
  lines[startsWith(lines, paste0(node, " <- "))]
}

# the numbers of the regression coefficients in a line
beta_numbers <- function(line) {
  as.integer(regmatches(
    line,
    gregexpr("(?<=beta\\[)[0-9]+(?=\\])", line, perl = TRUE)
  )[[1L]])
}

fit_clmm <- function(nonprop, fixed = O ~ age + day + (1 | id)) {
  clmm_imp(
    fixed,
    data = nonprop_data(),
    nonprop = list(O = nonprop),
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    overwrite = TRUE,
    mess = FALSE,
    warn = FALSE
  )
}

fit_jm <- function(nonprop, fixed = O ~ age + day + (1 | id)) {
  JM_imp(
    list(Surv(futime, status != "censored") ~ age + O, fixed),
    data = nonprop_data(),
    timevar = "day",
    nonprop = list(O = nonprop),
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    overwrite = TRUE,
    mess = FALSE,
    warn = FALSE
  )
}

# for each threshold: the expected variables in a linear predictor
expect_nonprop_terms <- function(line, present, absent = character(0)) {
  expect_length(line, 1L)
  for (term in present) {
    expect_true(grepl(term, line, fixed = TRUE), info = paste(term, "in", line))
  }
  for (term in absent) {
    expect_false(
      grepl(term, line, fixed = TRUE),
      info = paste(term, "in", line)
    )
  }
}

test_that("clmm: non-proportional effects from any level are used", {
  skip_on_cran()

  cases <- list(
    age = list(formula = ~age, present = "M_id[group_id[i], "),
    day = list(formula = ~day, present = "M_lvlone[i, "),
    both = list(
      formula = ~ age + day,
      present = c("M_id[group_id[i], ", "M_lvlone[i, ")
    )
  )

  for (case in cases) {
    lines <- model_lines(fit_clmm(case$formula))

    for (k in 1:2) {
      node <- sprintf("eta_O_%d[i]", k)
      expect_nonprop_terms(get_definition(lines, node), case$present)
      expect_length(
        grep(
          sprintf("logit(psum_O[i, %d])", k),
          grep(node, lines, fixed = TRUE, value = TRUE),
          fixed = TRUE
        ),
        1L
      )
    }
  }
})


test_that("JM: the quadrature part has the non-proportional effects", {
  skip_on_cran()

  # In the quadrature part, only the lowest level has a "gk" data matrix; the
  # level of the survival outcome has one row per subject.
  cases <- list(
    age = list(formula = ~age, present = "M_id[ii, "),
    day = list(formula = ~day, present = "M_lvlonegk[ii, "),
    both = list(
      formula = ~ age + day,
      present = c("M_id[ii, ", "M_lvlonegk[ii, ")
    )
  )

  for (case in cases) {
    lines <- model_lines(fit_jm(case$formula))

    for (k in 1:2) {
      node_gk <- sprintf("etagk_O_%d[ii, k]", k)
      line_gk <- get_definition(lines, node_gk)

      expect_nonprop_terms(line_gk, case$present, absent = "M_idgk")

      # the coefficients are the same as in the longitudinal part of the model
      expect_identical(
        beta_numbers(line_gk),
        beta_numbers(get_definition(lines, sprintf("eta_O_%d[i]", k)))
      )

      # the linear predictor is used for the probabilities of this threshold
      logit <- grep(
        sprintf("logit(psumgk_O[ii, %d, k])", k),
        lines,
        fixed = TRUE,
        value = TRUE
      )
      expect_nonprop_terms(logit, node_gk)
    }
  }
})


test_that("JM without non-proportional effects has no such terms", {
  skip_on_cran()

  fit <- JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + O,
      O ~ age + day + (1 | id)
    ),
    data = nonprop_data(),
    timevar = "day",
    n.adapt = 0,
    n.iter = 0,
    seed = 1,
    overwrite = TRUE,
    mess = FALSE,
    warn = FALSE
  )

  expect_false(any(grepl("eta(gk)?_O_[0-9]", model_lines(fit))))
})


test_that("clmm: non-proportional effects from a level with random effects", {
  skip_on_cran()

  lines <- model_lines(fit_clmm(
    ~ z + age + day,
    fixed = O ~ z + age + day + (1 | id) + (1 | center)
  ))

  for (k in 1:2) {
    expect_nonprop_terms(
      get_definition(lines, sprintf("eta_O_%d[i]", k)),
      c("M_center[group_center[i], ", "M_id[group_id[i], ", "M_lvlone[i, ")
    )
  }
})


test_that("JM: non-proportional effects from a level above the survival outcome", {
  skip_on_cran()

  fit <- fit_jm(
    ~ z + age + day,
    fixed = O ~ z + age + day + (1 | id) + (1 | center)
  )
  lines <- model_lines(fit)

  for (k in 1:2) {
    line <- get_definition(lines, sprintf("eta_O_%d[i]", k))
    line_gk <- get_definition(lines, sprintf("etagk_O_%d[ii, k]", k))

    expect_nonprop_terms(
      line,
      c("M_center[group_center[i], ", "M_id[group_id[i], ", "M_lvlone[i, ")
    )
    expect_nonprop_terms(
      line_gk,
      c(
        "M_center[group_center[pos_id[ii]], ",
        "M_id[ii, ",
        "M_lvlonegk[ii, "
      )
    )
    expect_identical(beta_numbers(line_gk), beta_numbers(line))
  }
})


test_that("JM: baseline covariates in the quadrature part, no random intercept", {
  skip_on_cran()

  # the baseline covariates are not in the means of the random effects, so they
  # are in the linear predictor; there is no M_idgk
  cases <- list(
    ordinal = list(
      formula = O ~ age + day + (0 + day | id),
      survival = Surv(futime, status != "censored") ~ O,
      node = "etagk_O[ii, k]"
    ),
    gaussian = list(
      formula = albumin ~ age + day + (0 + day | id),
      survival = Surv(futime, status != "censored") ~ albumin,
      node = "mugk_albumin[ii, k]"
    )
  )

  for (case in cases) {
    fit <- JM_imp(
      list(case$survival, case$formula),
      data = nonprop_data(),
      timevar = "day",
      n.adapt = 2,
      n.iter = 2,
      seed = 1,
      overwrite = TRUE,
      mess = FALSE,
      warn = FALSE
    )

    expect_nonprop_terms(
      get_definition(model_lines(fit), case$node),
      "M_id[ii, ",
      absent = "M_idgk"
    )
    # JAGS can compile the model
    expect_false(is.null(fit$MCMC))
  }
})
