# Only right-censored survival outcomes can be modelled. Other types of `Surv()`
# objects need an informative error, before any model is written. The checks use
# the call: JointAI turns a binary event indicator into a factor first, and
# `Surv()` with a factor event ignores its `type` (and returns type "mright").

surv_dat <- data.frame(
  t1 = c(1.2, 0.7, 2.5, 3.1, 0.4, 1.9, 2.2, 0.9, 1.5, 2.8),
  t2 = c(2.1, 1.3, 3.0, 4.4, 1.1, 2.6, 3.7, 1.8, 2.4, 3.9),
  e = c(1L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L),
  x = c(0.3, -1.2, 0.8, 1.5, -0.4, 0.1, -0.9, 1.1, 0.6, -0.2)
)
surv_dat$e_fct <- factor(surv_dat$e, labels = c("censored", "event"))
surv_dat$e_lgl <- surv_dat$e == 1L
surv_dat$e_3 <- factor(rep(c("censored", "a", "b"), length.out = 10))

unsupported <- list(
  left = list(lhs = "Surv(t1, e, type = 'left')", type = "left"),
  left_fct = list(lhs = "Surv(t1, e_fct, type = 'left')", type = "left"),
  left_abbrev = list(lhs = "Surv(t1, e, ty = 'l')", type = "left"),
  left_position = list(lhs = "Surv(t1, , e, 'left')", type = "left"),
  counting = list(lhs = "Surv(t1, t2, e)", type = "counting"),
  counting_fct = list(lhs = "Surv(t1, t2, e_fct)", type = "counting"),
  counting_named = list(
    lhs = "Surv(t1, t2, e, type = 'counting')",
    type = "counting"
  ),
  mstate_start = list(
    lhs = "Surv(t1, t2, e_3, type = 'mstate')",
    type = "counting"
  ),
  interval = list(
    lhs = "Surv(t1, t2, e, type = 'interval')",
    type = "interval"
  ),
  interval_fct = list(
    lhs = "Surv(t1, t2, e_fct, type = 'interval')",
    type = "interval"
  ),
  interval2 = list(lhs = "Surv(t1, t2, type = 'interval2')", type = "interval2")
)

extract_surv <- function(lhs, analysis_type = "survreg") {
  extract_outcome_data(
    as.formula(paste(lhs, "~ x")),
    data = surv_dat,
    analysis_type = analysis_type
  )
}

test_that("survival outcomes that are not right-censored give an error", {
  for (case in unsupported) {
    for (analysis_type in c("survreg", "coxph", "JM")) {
      err <- expect_error(extract_surv(case$lhs, analysis_type))
      expect_match(err$message, "right-censored", info = case$lhs)
      expect_match(err$message, paste0('"', case$type, '"'), fixed = TRUE)
      expect_false(grepl("competing risks", err$message))
    }
  }
})

test_that("survreg_imp() and coxph_imp() do not fit other censoring types", {
  # `e` is converted to a factor before the outcome is extracted
  for (lhs in c("Surv(t1, e, type = 'left')", "Surv(t1, t2, e)")) {
    fmla <- as.formula(paste(lhs, "~ x"))
    args <- list(formula = fmla, data = surv_dat, n.adapt = 0, n.iter = 0)
    expect_error(do.call(survreg_imp, args), "right-censored", info = lhs)
    expect_error(do.call(coxph_imp, args), "right-censored", info = lhs)
  }
})

test_that("right-censored survival outcomes are still accepted", {
  expected_status <- list(
    "Surv(t1, e)" = surv_dat$e,
    "Surv(t1, e, type = 'right')" = surv_dat$e,
    "Surv(t1, e, type = 'r')" = surv_dat$e,
    "Surv(t1, e_fct)" = surv_dat$e,
    "Surv(t1, e_fct, type = 'right')" = surv_dat$e,
    "Surv(t1, e_lgl)" = surv_dat$e,
    "Surv(t1, I(e == 1))" = surv_dat$e
  )

  for (lhs in names(expected_status)) {
    outcome <- extract_surv(lhs)$outcomes[[1]]
    expect_equal(outcome[[1]], surv_dat$t1, info = lhs)
    expect_equal(outcome[[2]], expected_status[[lhs]], info = lhs)
  }

  # the deprecated type "mstate" without a start time is a right-censored
  # outcome if the event has two categories (`Surv()` warns)
  lhs <- "Surv(t1, e_fct, type = 'mstate')"
  outcome <- suppressWarnings(extract_surv(lhs))$outcomes[[1]]
  expect_equal(outcome[[2]], surv_dat$e)
})

test_that("an event with more than two categories still mentions competing risks", {
  expect_error(
    survreg_imp(Surv(t1, e_3) ~ x, data = surv_dat, n.adapt = 0, n.iter = 0),
    "competing risks"
  )
})
