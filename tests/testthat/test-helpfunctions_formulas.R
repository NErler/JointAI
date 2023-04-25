
library("JointAI")
library("survival")




runs <- list(list(random = ~ 1 | id, ids = 'id', RHS = list(~ 1 | id),
                  nogroup = list(id = ~ 1)),
             list(random = ~ 0 | id, ids = 'id', RHS = list(~ 0 | id),
                  nogroup = list(id = ~ 0)),
             list(random = NULL, ids = NULL, RHS = NULL, nogroup = NULL),
             list(random = y ~ a + b + c, ids = NULL, RHS = list(~a + b + c),
                  nogroup = list(y ~ a + b + c)),
             list(random = y ~ time | id, ids = 'id', RHS = list(~time | id),
                  nogroup = list(id = y ~ time)),
             list(random = y ~ 0, ids = NULL, RHS = list(~ 0),
                  nogroup = list(y ~ 0))
)



# extract_outcome ----------------------------------------------------------
library(splines)
ys <- list(list(fixed = y ~ a + b, out = list(y = 'y'), LHS = "y",
                RHS = list(~ a + b)),
           list(fixed = y ~ 1, out = list(y = 'y'), LHS = "y", RHS = list(~1)),
           list(fixed = Surv(a, b) ~ 1, out = list("Surv(a, b)" = c('a', 'b')),
                LHS = "Surv(a, b)", RHS = list(~1)),
           list(fixed = Surv(a, b, d) ~ x + z,
                out = list("Surv(a, b, d)" = c('a', 'b', 'd')),
                LHS = "Surv(a, b, d)", RHS = list(~ x + z)),
           list(fixed = cbind(a, b, d) ~ x + z,
                out = list("cbind(a, b, d)" = c('a', 'b', 'd')),
                LHS = "cbind(a, b, d)", RHS = list(~ x + z)),
           list(fixed = y ~ C2 +
                  ns(C1, df = 3,
                     Boundary.knots = quantile(C1, c(0.025, 0.975))),
                out = list(y = 'y'), LHS = 'y',
                RHS = list( ~ C2 +
                              ns(C1, df = 3,
                                 Boundary.knots = quantile(C1,
                                                           c(0.025, 0.975)))))
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







# remove grouping --------------------------------------------------------------
test_that('remove_grouping works', {
  for (i in seq_along(runs)) {
    expect_equal(remove_grouping(runs[[i]]$random), runs[[i]]$nogroup,
                 ignore_formula_env = TRUE)
  }

  # test all together
  expect_equal(remove_grouping(lapply(runs, "[[", 'random')),
               lapply(runs, "[[", 'nogroup'),
               ignore_formula_env = TRUE)
})




# identify_functions -----------------------------------------------------------
library(splines)
fmls <- list(list(formula = y ~ I(a^2) + b + log(a),
                  fcts = list(I = "I(a^2)", log = "log(a)")),
             list(formula = out ~ log(x) + log(y) + log(x + z) + y*z,
                  fcts = list(log = c("log(x)", "log(y)", "log(x + z)"))),
             list(formula = y ~ ns(a, df = 3)*exp(log(z)) + ns(b, df = 2) +
                    I(a^2/log(x) + 23*x*z),
                  fcts = list(ns = c("ns(a, df = 3)", "ns(b, df = 2)"),
                              exp = "exp(log(z))",
                              log = c("exp(log(z))",
                                      "I(a^2/log(x) + 23 * x * z)"),
                              I = "I(a^2/log(x) + 23 * x * z)")),
             list(formula = log(abc) ~ xy + zb + bs(a, df = 2),
                  fcts = list(bs = "bs(a, df = 2)")),
             list(formula = structure(Surv(time, status) ~ (x+z+k)^3 +
                                        plogis(m), type = 'survival'),
                  fcts = list(plogis = "plogis(m)")),
             list(formula = NULL, fcts = NULL)
)

test_that('identify_functions works', {
  for (i in seq_along(fmls)) {
    expect_equal(identify_functions(fmls[[i]]$formula),
                 fmls[[i]]$fcts)
  }
})


# !!! test for get_varlist --------------------------------------------------


# !!! test for get_fct_dfList ------------------------------------------------
# funlist <- list(log = c('log(p1)', "log(C1 + p1)"),
#                 sqrt = c("sqrt(C1)"),
#                 bs = c("bs(C1, df = 3)"),
#                 I = c("I(C1 + plogis(C2)^2)"),
#                 plogis = c("I(C1 + plogis(C2)^2)")
# )
#
#
# varlist <- get_varlist(funlist)
#
# DFlist <- list(log = data.frame(X_var = ))
#
# for(i in seq_along(varlist)) {
#   get_fct_dfList(varlist[[i]], data = longDF)
# }
#
# get_fct_dfList(varlist, data = longDF)


# !!! tests for extract_fcts() -----------------------------------------------


# !!! test for split_outcome() -------------------------------------------------

# extract_outcome_data() -------------------------------------------------------
survout <- as.data.frame.matrix(with(longDF, Surv(c1, b1)))
names(survout) <- c('c1', 'b1')

fmla <- list('C1' = list(fixed = C1 ~ C2 + B1,
                         outcome = data.frame(C1 = longDF$C1)),
             'cbind(C2, B1)' = list(fixed = cbind(C2, B1) ~ M2,
                                    outcome = data.frame(
                                      C2 = longDF$C2,
                                      B1 = as.numeric(longDF$B1) - 1)),
             'Surv(c1, b1)' = list(fixed = Surv(c1, b1) ~ O1 + C1,
                                   outcome = survout),
             'log(p2)' = list(fixed = log(p2) ~ c1 + b1,
                              outcome = data.frame(
                                `log(p2)` = log(longDF$p2),
                                check.names = FALSE)),
             'cbind(c2, log(p1))' = list(fixed = cbind(c2, log(p1)) ~ M2,
                                         outcome = data.frame(
                                           c2 = longDF$c2,
                                           'log(p1)' = log(longDF$p1),
                                           check.names = FALSE))
)

test_that("extract_outcome_data works", {
  for (i in seq_along(fmla)) {
    expect_equal(extract_outcome_data(fmla[[i]]$fixed, data = longDF,
                                      analysis_type = "something")$outcome[[1]],
                 fmla[[i]]$outcome)
  }

  expect_equal(extract_outcome_data(lapply(fmla, "[[", "fixed"), data = longDF,
                                    analysis_type = 'something')$outcome,
               lapply(fmla, "[[", 'outcome'))
})

# model_matrix_combi() ---------------------------------------------------------

# test_that('model_matrix_combi works', {
#   opt <- options(contrasts = rep("contr.treatment", 2))
#
#   fmla_combi <- as.formula(paste("~", paste0(unique(unlist(
#     lapply(fmla, function(x) attr(terms(x$fixed), 'term.labels')))),
#     collapse = " + ")))
#
#   X <- model.matrix(fmla_combi,
#                     model.frame(fmla_combi, data = longDF,
#                     na.action = na.pass),
#                     )
#
#   attr(X, 'assign') <- NULL
#   attr(X, 'contrasts') <- NULL
#
#   expect_equal(
#     model_matrix_combi(fmla = lapply(fmla, "[[", 'fixed'), data = longDF),
#     X
#   )
#   options(opt)
# })


# outcomes_to_mat() ------------------------------------------------------------
test_that("outcomes_to_mat works", {
  mat <- data.matrix(do.call(cbind, unname(lapply(fmla, "[[", "outcome"))))
  dimnames(mat) <- list(NULL, dimnames(mat)[[2]])
  expect_equal(outcomes_to_mat(
    extract_outcome_data(lapply(fmla, "[[", "fixed"),
                         data = longDF,
                         analysis_type = 'something')),
    mat)
})

test_that("outcomes_to_mat gives error with duplicate outcome", {
  fmla_err <- list('C1' = list(fixed = C1 ~ C2 + B1,
                           outcome = subset(longDF, select = "C1")),
               'cbind(C1, B1)' = list(fixed = cbind(C1, B1) ~ M2,
                                      outcome = subset(longDF,
                                                       select = c("C1", "B1"))),
               'Surv(c1, B1)' = list(fixed = Surv(c1, B1) ~ O1 + C1,
                                     outcome = as.data.frame.matrix(
                                       with(longDF, Surv(c1, B1))))
  )

  expect_error(outcomes_to_mat(
    extract_outcome_data(lapply(fmla_err,
                                "[[", "fixed"), data = longDF)))
})



#
# outcome1 <- list(y = data.frame(y = rgamma(10, 1, 0.1)))
# outcome2 <- list(y = data.frame(y = factor(sample(0:1, size = 10,
#  replace = TRUE))))
# outcome3 <- list(y = data.frame(y = factor(sample(1:4, size = 20,
# replace = TRUE), ordered = TRUE)))
# outcome4 <- list(y = data.frame(y = factor(sample(1:4, size = 20,
# replace = TRUE), ordered = FALSE)))
# outcome5 <- list("Surv(time, status)" = as.data.frame.matrix(
# survival::Surv(rgamma(10, 1, 0.1), rbinom(10, 1, 0.5))))
# outcome6 <- list("cbind(x,y)" = data.frame(x = rnorm(10), y = rnorm(10)))
# outcome7 <- list(x = data.frame(x = rnorm(10)),
#                  y = data.frame(y = rnorm(10)))
#
# df <- data.frame(x = rnorm(10), y = rnorm(10),
# z = factor(rbinom(10, 1, 0.5)), a = factor(sample(1:3, 10, replace = T)))
# outcome8 <- list("cbind(x,y)" = with(df, data.frame(x, y)),
#                  "cbind(x,z)" = with(df, data.frame(x, z)),
#                  "cbind(x,a)" = with(df, data.frame(x, a, z)))
# outcome9 <- list("Surv(time, status)" = as.data.frame.matrix(
# survival::Surv(rgamma(10, 1, 0.1), rbinom(10, 1, 0.5))),
#                  x = data.frame(x = rnorm(30)))
#
#
# prep_outcome(outcomes = outcome1)
# prep_outcome(outcomes = outcome2)
# prep_outcome(outcomes = outcome3)
# prep_outcome(outcomes = outcome4)
# prep_outcome(outcomes = outcome5)
# prep_outcome(outcomes = outcome6)
# prep_outcome(outcomes = outcome7)
# prep_outcome(outcomes = outcome8)
# prep_outcome(outcomes = outcome9)

