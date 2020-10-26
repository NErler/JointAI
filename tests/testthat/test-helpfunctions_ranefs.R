context("help functions random effects")
library("JointAI")


# check_formula_list -----------------------------------------------------------
test_that('check_random_lvls', {

  expect_null(check_random_lvls(random = NULL, rel_lvls = NULL))
  expect_null(check_random_lvls(random = ~ time | id, rel_lvls = NULL))

  expect_equal(check_random_lvls(random = NULL, rel_lvls = c("id", "center")),
               list(id = ~ 1, center = ~ 1)
  )


  expect_equal(
    check_random_lvls(random = ~1 | center, rel_lvls = c("id", "center")),
    list(center = ~ 1)
  )

  expect_error(
    check_random_lvls(random = ~ (1 | center) + (1 | hospital),
                      rel_lvls = c("id", "center"))
  )
})
