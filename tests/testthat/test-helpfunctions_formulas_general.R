# check_formula_list -----------------------------------------------------------

test_that('check_formula_list works', {
  # formula, default: convert to list
  expect_equal(check_formula_list(y ~ x + z), list(y ~ x + z))
  expect_equal(check_formula_list(y ~ x + z | id), list(y ~ x + z | id))

  # formula, do not convert to list
  expect_equal(check_formula_list(y ~ x + z, convert = FALSE), y ~ x + z)
  expect_equal(check_formula_list(y ~ x + z | id, convert = FALSE),
               y ~ x + z | id)

  # NULL
  expect_null(check_formula_list(NULL))

  # list of formulas
  expect_equal(check_formula_list(list(y = y ~ x + z, a = a ~ b + c)),
               list(y = y ~ x + z, a = a ~ b + c))

  # list of formulas and NULL elements
  expect_equal(check_formula_list(list(y ~ x + z, NULL)),
               list(y ~ x + z, NULL), ignore_formula_env = TRUE)

  # list of only NULL elements
  expect_equal(check_formula_list(list(NULL, NULL, NULL)),
               list(NULL, NULL, NULL), ignore_formula_env = TRUE)
})


test_that('check_formula_list gives error', {
  # other types of objects
  expect_error(check_formula_list("y ~ x + z"))
  expect_error(check_formula_list(33))
  expect_error(check_formula_list(TRUE))
  expect_error(check_formula_list(NA))
  expect_error(check_formula_list(expression(y ~ x + y)))

  # lists with non-formula, non-null elements
  expect_error(check_formula_list(list(y ~ x + z, NULL, 33)))
  expect_error(check_formula_list(list(y ~ x + z, NULL, "abc")))
  expect_error(check_formula_list(list(y ~ x + z, NULL, "y ~ abc")))
  expect_error(check_formula_list(list(y ~ x + z, NULL, NA)))

  # list of list of formulas
  expect_error(check_formula_list(list(y ~ x + z, list(a ~ b + c, d ~ e + f))))
})




# combine formula lists --------------------------------------------------------

test_that("joining fixed and random effects formulas works", {
  # no random effects
  expect_equal(combine_formula_lists(y ~ a + b, NULL),
               list(y ~ a + b),
               ignore_attr = TRUE)
  expect_equal(combine_formula_lists(list(y ~ a + b), NULL),
               list(y ~ a + b),
               ignore_attr = TRUE)
  expect_equal(combine_formula_lists(list(y = y ~ a + b), NULL),
               list(y ~ a + b),
               ignore_attr = TRUE)
  expect_equal(
    combine_formula_lists(list(y ~ a + b, x ~ b + c), NULL),
    list(y ~ a + b, x ~ b + c),
    ignore_attr = TRUE)

  # single fixed and single random effects formula
  expect_equal(combine_formula_lists(y ~ a + b, ~ 1 | id),
               list(y ~ a + b + (1 | id)),
               ignore_attr = TRUE)

  # more fixed effects than random effects (named lists)
  expect_equal(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          list(x = ~ 1 | id)),
    list(y ~ a + b, x ~ b + c + (1 | id)),
    ignore_attr = TRUE)


  # more fixed effects than random effects (random unnamed)
  expect_equal(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          ~ 1 | id, warn = FALSE),
    list(y ~ a + b + (1 | id), x ~ b + c),
    ignore_attr = TRUE)

  expect_equal(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          list(~ 1 | id), warn = FALSE),
    list(y ~ a + b + (1 | id), x ~ b + c),
    ignore_attr = TRUE)

  # equal length fixed and random (both unnamed)
  expect_equal(
    combine_formula_lists(list(y ~ a + b, x ~ b + c),
                          list(~1 | id, ~ 1 | id), warn = FALSE),
    list(y ~ a + b + (1 | id), x ~ b + c + (1 | id)),
    ignore_attr = TRUE)

  # equal length fixed and random (random unnamed)
  expect_equal(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          list(~1 | id, ~ 1 | id), warn = FALSE),
    list(y = y ~ a + b + (1 | id), x = x ~ b + c + (1 | id)),
    ignore_attr = TRUE)
})


test_that("joining fixed and random effects gives warning", {
  # more fixed effects than random effects (random unnamed)
  expect_warning(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          ~ 1 | id))
  expect_warning(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          list(~ 1 | id)))

  # equal length fixed and random (both unnamed)
  expect_warning(
    combine_formula_lists(list(y ~ a + b, x ~ b + c),
                          list(~1 | id, ~ 1 | id)))
  # equal length fixed and random (random unnamed)
  expect_warning(
    combine_formula_lists(list(y = y ~ a + b, x = x ~ b + c),
                          list(~1 | id, ~ 1 | id)))
})


test_that("joining fixed and random effects formulas returns error", {
  # random has names not present in fixed
  expect_error(
    combine_formula_lists(list(y ~ a + b, x ~ b + c),
                          list(y = ~ 1 | id)))
  expect_error(
    combine_formula_lists(list(y  = y ~ a + b, x ~ b + c),
                          list(z = ~ 1 | id)))
  expect_error(
    combine_formula_lists(list(x ~ b + c),
                          list(x = ~1 | id, z = ~ 1 | id)))

  # random is longer than fixed
  expect_error(
    combine_formula_lists(list(x ~ b + c),
                          list(~1 | id, ~ 1 | id)))
})


# remove_lhs() ----------------------------------------------------------------

test_that("remove_lhs() works", {
  # single formula
  expect_equal(remove_lhs(y ~ a + b), ~ a + b)
  expect_equal(remove_lhs(y ~ a + b + (time | id)), ~ a + b + (time | id))
  expect_equal(remove_lhs(y ~ a + I(b^2/d)), ~ a + I(b^2/d))

  # no response
  expect_equal(remove_lhs(~ a + b), ~ a + b)

  # null
  expect_null(remove_lhs(NULL))

  # other type of object: covered by the tests for check_formula_list()

  # complex outcomes
  expect_equal(remove_lhs(Surv(time, status) ~ x + y), ~ x + y)
  expect_equal(remove_lhs(cbind(time, status) ~ x + y), ~ x + y)
  expect_equal(remove_lhs(Surv(time, status == 3) ~ x + y), ~ x + y)
  expect_equal(remove_lhs(log(a) ~ x + y), ~ x + y)
  expect_equal(remove_lhs(I(max(a, b, na.rm = TRUE)) ~ x + y), ~ x + y)

  # formula list
  expect_equal(remove_lhs(list(y ~ a + b, z ~ d + e)),
               list(~ a + b, ~ d + e))
})



# extract_lhs ------------------------------------------------------------------
test_that('extract_lhs returns lhs string', {
  # simple response
  expect_equal(extract_lhs_string(y ~ a + b), "y")

  # survival object
  expect_equal(extract_lhs_string(Surv(time, status) ~ a + b), "Surv(time, status)")
  expect_equal(extract_lhs_string(Surv(time, status == 3) ~ a + b),
               "Surv(time, status == 3)")

  # cbind response
  expect_equal(extract_lhs_string(cbind(a, b, c) ~ x), "cbind(a, b, c)")

  # function/trafo response
  expect_equal(extract_lhs_string(I(x^2) ~ y), "I(x^2)")
  expect_equal(extract_lhs_string(log(x^2) ~ y), "log(x^2)")
  expect_equal(extract_lhs_string(a + b ~ y + z), "a + b")
})

test_that("extract_lhs returns NULL for NULL object", {
    expect_null(extract_lhs_string(NULL))
})

test_that('extract_lhs returns error for one-sided formula', {
  # no response
  expect_error(extract_lhs_string(~ y + z))
})

test_that("extract_lhs returns error for non-formula objects", {
  # not a formula
  expect_error(extract_lhs_string("a ~ y + z"))
  expect_error(extract_lhs_string(NA))
  expect_error(extract_lhs_string(33))
  expect_error(extract_lhs_string(TRUE))
  expect_error(extract_lhs_string(expression(y ~ x + y)))

  # a list of formulas
  expect_error(extract_lhs_string(list(a ~ b + c, x ~ y + z)))
})


# split_formula-----------------------------------------------

library(testthat)

test_that("extract_fixef_formula throws error for non-formulas", {
  expect_error(extract_fixef_formula("not a formula"))
  expect_error(extract_fixef_formula(NA))
  expect_error(extract_fixef_formula(42))
  expect_error(extract_fixef_formula(expression(y ~ x)))
})

test_that("extract_ranef_formula throws error for non-formulas", {
  expect_error(extract_ranef_formula("not a formula"))
  expect_error(extract_ranef_formula(NA))
  expect_error(extract_ranef_formula(42))
  expect_error(extract_ranef_formula(expression(y ~ x)))
})



fmls <- list(
  list(fmla = y ~ a + b + (b | id),
       fixed = list(y = y ~ a + b),
       random = list(y = ~ (b | id))),
  list(fmla = y ~ (1|id),
       fixed = list(y = y ~ 1),
       random = list(y = ~ (1 | id))),
  list(fmla = y ~ a + (a + b|id),
       fixed = list(y = y ~ a),
       random = list(y = ~ (a + b |id))),
  list(fmla = y ~ a + I(a^2) + (a + I(a^2) | id),
       fixed = list(y = y ~ a + I(a^2)),
       random = list(y = ~ (a + I(a^2) | id))),
  list(fmla = y ~ x + (1| id/class),
       fixed = list(y = y ~ x),
       random = list(y = ~ (1 | id/class))),
  list(fmla = y ~ x + (1|id) + (1|class),
       fixed = list(y = y ~ x),
       random = list(y = ~ (1|id) + (1|class))),
  list(fmla = y ~ a + b + (id | group1 + group2),
       fixed = list(y = y ~ a + b),
       random = list(y = ~ (id | group1 + group2))),
  list(fmla = y ~ a + b - 1,
       fixed = list(y = y ~ 0 + a + b),
       random = list(y = NULL)),
  list(fmla = y ~ 0 + (1 | id),
       fixed = list(y = y ~ 0),
       random = list(y = ~ (1 | id)))
)


test_that("extract_fixef_formula works", {
  for (i in seq_along(fmls)) {
    expect_equal(extract_fixef_formula(fmls[[i]]$fmla),
                 fmls[[i]]$fixed[[1]],
                 ignore_formula_env = TRUE)
  }
})

test_that("extract_ranef_formula works", {
  for (i in seq_along(fmls)) {
    expect_equal(extract_ranef_formula(fmls[[i]]$fmla),
                 fmls[[i]]$random[[1]],
                 ignore_formula_env = TRUE)
  }
})




# split_formula_list --------------------------------------------------
test_that('split_formula_list works', {
  expect_equal(
    split_formula_list(lapply(fmls, "[[", "fmla")),
    list(fixed = unlist(lapply(fmls, "[[", 'fixed')),
         random = unlist(lapply(fmls, "[[", 'random'), recursive = FALSE)),
    ignore_formula_env = TRUE)
})



# extract_grouping--------------------------------------------------------------

test_that('extract_grouping works', {
  # single formula
  expect_equal(extract_grouping(~ 1 | id), "id")
  expect_equal(extract_grouping(~ 0 | id), "id")
  expect_equal(extract_grouping(~ time | id), "id")
  expect_equal(extract_grouping(~ 1 | id/center), c("id", "center"))
  expect_equal(extract_grouping(~ 1 | id + center), c("id", "center"))
  expect_equal(extract_grouping(~ (1 | id) + (time | center)), c("id", "center"))


  expect_null(extract_grouping(NULL))
  expect_null(extract_grouping(~ a + b, warn = FALSE), NULL)


  # list of formulas
  expect_equal(extract_grouping(list(a = ~ time | id,
                               b = y ~ (time | id) + (1 | center),
                               d = NULL,
                               e = ~ 1 | group)),
               c("id", "center", "group"))


})


test_that('extract_grouping returns NULL when no grouping term', {
  # edit 2025-09-04: refactoring extract_id() to extract_grouping() does not
  # return warnings any more for formulas without any grouping terms. This
  # is intentional; too many warnings are irritating.
  expect_null(extract_grouping(~ a + b + c))
  expect_null(extract_grouping(~ 0))
  expect_null(extract_grouping(~ 1))
})



test_that('extract_grouping gives in error', {
  expect_error(extract_grouping("~ 1 | id"))
  expect_error(extract_grouping(NA))
})



test_that('extract_grouping works', {
  runs <- list(list(random = ~ 1 | id, ids = 'id'),
               list(random = ~ 0 | id, ids = 'id'),
               list(random = y ~ a + b + c, ids = NULL),
               list(random = y ~ time | id, ids = 'id'),
               list(random =  ~ a | id/class, ids = c('id', 'class')),
               list(random = ~ a | id + class, ids = c('id', 'class')),
               list(random = ~(a | id) + (b | id2), ids = c('id', 'id2'))
  )

  for (i in seq_along(runs)[-3]) {
    expect_equal(extract_grouping(runs[[i]]$random), runs[[i]]$ids)
  }

  expect_null(extract_grouping(runs[[3]]$random))

  expect_equal(extract_grouping(lapply(runs, "[[", "random")),
               unique(unlist(lapply(runs, "[[", "ids"))))
})


test_that('extract_grouping results in error', {
  err <- list(
    "text",
    NA,
    TRUE,
    mean
  )

  for (i in seq_along(err)) {
    expect_error(extract_grouping(err[[i]]))
  }
})


# test_that('extract_grouping results in warning', {
#   rd_warn <- list(~1,
#                   ~a + b + c,
#                   ~ NULL)
#
#   for (i in seq_along(rd_warn)) {
#     expect_warning(extract_grouping(rd_warn[[i]]))
#   }
# })



# all_vars ---------------------------------------------------------------------
test_that("all_vars works", {
  expect_null(all_vars(NULL))

  expect_equal(all_vars(y ~ a + B + I(c/d^2) + ns(time, df = 3) +
                          (1 | id/center)),
               c("y", "a", "B", "c", "d", "time", "id", "center"))
  expect_equal(all_vars(list(Surv(etime, status == 3) ~ a + B + I(c/d^2),
                             a ~ c + ns(time, df = 3) + (1 | id/center))),
               c("etime", "status", "a", "B", "c", "d", "time", "id", "center"))

  expect_equal(all_vars(c("a", "b", "c")), c("a", "b", "c"))
  expect_equal(all_vars("abc"), "abc")
  expect_equal(all_vars(list(NULL, 1, "abc", ~ b + c)),
               c("abc", "b", "c"))
  })

test_that("all_vars gives returns empty string", {
  expect_equal(all_vars(NA), character(0))
  expect_equal(all_vars(1), character(0))
})



# test_that("all_vars gives an error", {
#   expect_error(all_vars(NA))
#   expect_error(all_vars(1))
#   expect_error(all_vars(list(NULL, 1, "abc", ~ b + c)))
# })
