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

fit_clmm <- function(nonprop) {
  clmm_imp(
    O ~ age + day + (1 | id),
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

fit_jm <- function(nonprop) {
  JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + O,
      O ~ age + day + (1 | id)
    ),
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
