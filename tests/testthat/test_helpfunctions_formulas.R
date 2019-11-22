context("help functions for formulas")
library("JointAI")
library("survival")


# check_formula_list -----------------------------------------------------------
test_that('check_formula_list works', {
  expect_equal(check_formula_list(y ~ x + z),
               list(y ~ x + z))
  expect_equal(check_formula_list(y ~ x + z | id),
               list(y ~ x + z | id))
  expect_equal(check_formula_list(NULL),
               NULL)
  expect_equal(check_formula_list(list(y ~ x + z, NULL)),
               list(y ~ x + z, NULL))
})


test_that('check_formula_list gives error', {
  expect_error(check_formula_list("y ~ x + z"))
  expect_error(check_formula_list(33))
  expect_error(check_formula_list(log(y)))
  expect_error(check_formula_list(list(y ~ x + z, NULL, 33)))
  expect_error(check_formula_list(list(y ~ x + z, NULL, "abc")))
  expect_error(check_formula_list(list(y ~ x + z, NULL, "y ~ abc")))
})



# extract_id--------------------------------------------------------------
runs <- list(list(random = ~ 1 | id, ids = 'id', RHS = list(~ 1 | id), nogroup = ~ 1),
             list(random = ~ 0 | id, ids = 'id', RHS = list(~ 0 | id), nogroup = ~ 0),
             list(random = NULL, ids = NULL, RHS = NULL, nogroup = NULL),
             list(random = y ~ a + b + c, ids = NULL, RHS = list(~a + b + c), nogroup = y ~ a + b + c),
             list(random = y ~ time | id, ids = 'id', RHS = list(~time | id), nogroup = y ~ time),
             list(random = y ~ 0, ids = NULL, RHS = list(~ 0), nogroup = y ~ 0)
)

test_that('extract_id works', {
  for (i in seq_along(runs)) {
    expect_equal(extract_id(runs[[i]]$random), runs[[i]]$ids)
  }

  # test all together
  expect_equal(extract_id(lapply(runs, "[[", 'random')),
               unlist(unique(lapply(runs, "[[", 'ids'))))
})


test_that('extract_id results in error', {
  err <- list(
    "text",
    NA,
    TRUE,
    mean,
    list(random =  ~ a | id/class, ids = c('id', 'class')),
    list(random = ~ a | id + class, ids = c('id', 'class')),
    list(random = list(~a | id, ~ b | id2), ids = c('id', 'id2'))
  )

  for (i in seq_along(err)) {
    expect_error(extract_id(err[[i]]))
  }
})


test_that('extract_id results in warning', {
  rd_warn <- list(~1,
                  ~a + b + c)

  for (i in seq_along(rd_warn)) {
    expect_warning(extract_id(rd_warn[[i]]))
  }
})


# extract_outcome ----------------------------------------------------------
ys <- list(list(fixed = y ~ a + b, out = list(y = 'y'), LHS = "y", RHS = list(~ a + b)),
           list(fixed = y ~ 1, out = list(y = 'y'), LHS = "y", RHS = list(~1)),
           list(fixed = Surv(a, b) ~ 1, out = list("Surv(a, b)" = c('a', 'b')),
                LHS = "Surv(a, b)", RHS = list(~1)),
           list(fixed = Surv(a, b, d) ~ x + z,
                out = list("Surv(a, b, d)" = c('a', 'b', 'd')),
                LHS = "Surv(a, b, d)", RHS = list(~ x + z)),
           list(fixed = cbind(a, b, d) ~ x + z,
                out = list("cbind(a, b, d)" = c('a', 'b', 'd')),
                LHS = "cbind(a, b, d)", RHS = list(~ x + z))
           # list(fixed = y + x ~ a + b, out = c("y + x"))
)

test_that('extract_outcome works', {
  for (i in seq_along(ys)) {
    expect_equal(extract_outcome(ys[[i]]$fixed), ys[[i]]$out)
  }

  # test whole list of formulas
  expect_equal(extract_outcome(lapply(ys, "[[", "fixed")),
               sapply(ys, "[[", "out"))
})


# extract_LHS ------------------------------------------------------------------
test_that('extract_LHS works', {
  for (i in seq_along(ys)) {
    expect_equal( extract_LHS(ys[[i]]$fixed), ys[[i]]$LHS)
  }
})

# remove_LHS -------------------------------------------------------------------
test_that('remove_LHS works', {
  for (i in seq_along(ys)) {
    expect_equal(remove_LHS(ys[[i]]$fixed), ys[[i]]$RHS)
  }
  for (i in seq_along(runs)) {
    expect_equal(remove_LHS(runs[[i]]$random), runs[[i]]$RHS)
  }
})


# remove grouping --------------------------------------------------------------
test_that('remove_grouping works', {
  for (i in seq_along(runs)) {
    expect_equal(remove_grouping(runs[[i]]$random), runs[[i]]$nogroup)
  }

  # test all together
  expect_equal(remove_grouping(lapply(runs, "[[", 'random')),
               lapply(runs, "[[", 'nogroup'))
})


# split_formula-----------------------------------------------
fmls <- list(
  list(fmla = y ~ a + b + (b | id),
       fixed = y ~ a + b,
       random = ~ b | id),
  list(fmla = y ~ (1|id),
       fixed = y ~ 1,
       random = ~ 1 | id),
  list(fmla = y ~ a + (a + b|id),
       fixed = y ~ a,
       random = ~a + b |id),
  list(fmla = y ~ a + I(a^2) + (a + I(a^2) | id),
       fixed = y ~ a + I(a^2),
       random = ~a + I(a^2) | id),
  list(fmla = y ~ x + (1| id/class),
       fixed = y ~ x,
       random = ~1 | id/class),
  list(fmla = y ~ x + (1|id) + (1|class),
       fixed = y ~ x,
       random = ~ 1|id + 1|class))

test_that('split_formula works', {
  for(i in seq_along(fmls)) {
    expect_equal(split_formula(fmls[[i]]$fmla),
                 list(fixed = fmls[[i]]$fixed, random = fmls[[i]]$random)
    )
  }
})

# split_formula_list --------------------------------------------------
test_that('split_formula_list works', {
  expect_equal(
    unname(lapply(split_formula_list(lapply(fmls, "[[", "fmla")), unname)),
               list(lapply(fmls, "[[", 'fixed'),
                    lapply(fmls, "[[", 'random'))
  )

})


# identify_functions ------------------------------------------------------------
library(splines)
fmls <- list(list(formula = y ~ I(a^2) + b + log(a),
                  fcts = list(I = "I(a^2)", log = "log(a)", identity = "b")),
             list(formula = out ~ log(x) + log(y) + log(x + z) + y*z,
                  fcts = list(log = c("log(x)", "log(y)", "log(x + z)"),
                              identity = c('y', 'z'))),
             list(formula = y ~ ns(a, df = 3)*exp(log(z)) + ns(b, df = 2) + I(a^2/log(x) + 23*x*z),
                  fcts = list(ns = c("ns(a, df = 3)", "ns(b, df = 2)"),
                              exp = "exp(log(z))",
                              log = c("exp(log(z))", "I(a^2/log(x) + 23 * x * z)"),
                              I = "I(a^2/log(x) + 23 * x * z)")),
             list(formula = log(abc) ~ xy + zb + bs(a, df = 2),
                  fcts = list(bs = "bs(a, df = 2)", identity = c('xy', 'zb'))),
             list(formula = Surv(time, status) ~ (x+z+k)^3 + plogis(m),
                  fcts = list(plogis = "plogis(m)", identity = c('x', 'z', 'k'))),
             list(formula = NULL, fcts = NULL)
)

test_that('identify_functions works', {
  for(i in seq_along(fmls)) {
    expect_equal(identify_functions(fmls[[i]]$formula),
                 fmls[[i]]$fcts)
  }
})

