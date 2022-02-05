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
               list(y ~ x + z, NULL))

  # list of only NULL elements
  expect_equal(check_formula_list(list(NULL, NULL, NULL)),
               list(NULL, NULL, NULL))
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
test_that('extract_lhs works', {
  # simple response
  expect_equal(extract_lhs(y ~ a + b), "y")

  # survival object
  expect_equal(extract_lhs(Surv(time, status) ~ a + b), "Surv(time, status)")
  expect_equal(extract_lhs(Surv(time, status == 3) ~ a + b),
               "Surv(time, status == 3)")

  # cbind response
  expect_equal(extract_lhs(cbind(a, b, c) ~ x), "cbind(a, b, c)")

  # function/trafo response
  expect_equal(extract_lhs(I(x^2) ~ y), "I(x^2)")
  expect_equal(extract_lhs(log(x^2) ~ y), "log(x^2)")
  expect_equal(extract_lhs(a + b ~ y + z), "a + b")

  # null
  expect_null(extract_lhs(NULL))

})


test_that('extract_lhs returns error', {
  # no response
  expect_error(extract_lhs(~ y + z))

  # not a formula
  expect_error(extract_lhs("a ~ y + z"))
  expect_error(extract_lhs(NA))

  # a list of formulas
  expect_error(extract_lhs(list(a ~ b + c, x ~ y + z)))
})

# y ~ a + b
# y ~ 1
# Surv(a, b) ~ 1
# Surv(a, b, d) ~ x + z
# cbind(a, b, d) ~ x + z
# y ~ C2 + ns(C1, df = 3, Boundary.knots = quantile(C1, c(0.025, 0.975)))
