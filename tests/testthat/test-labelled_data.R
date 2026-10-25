# Tests for data with label metadata, as produced e.g. by importing SPSS data
# (GitHub issues #35 and #17). No JAGS needed.

# Issue #35 --------------------------------------------------------------------
# get_datlvls() compared the data with a copy rebuilt by subsetting, which
# drops attributes such as "label", so variables with such an attribute got no
# level (NA).

test_that("get_datlvls() ignores attributes that subsetting drops (#35)", {
  groups <- get_groups("id", longDF)
  dat <- longDF[, c("C1", "c1", "B2", "time", "y")]

  dat_attr <- dat
  attr(dat_attr$C1, "label") <- "a variable label"
  attr(dat_attr$c1, "comment") <- "a comment"

  expected <- c(C1 = "id", c1 = "lvlone", B2 = "id", time = "lvlone",
                y = "lvlone")
  expect_identical(get_datlvls(dat, groups), expected)
  expect_identical(get_datlvls(dat_attr, groups), expected)
})

test_that("get_models() works with label attributes (example from #35)", {
  toy_label <- wideDF
  for (v in c("C1", "C2", "L1", "L2")) {
    attr(toy_label[[v]], "label") <- paste("Continuous variable", v)
  }

  expect_identical(
    get_models(fixed = y ~ C1 + C2 + L1 + L2, data = toy_label),
    get_models(fixed = y ~ C1 + C2 + L1 + L2, data = wideDF)
  )
})

test_that("get_datlvls() gives an informative error if no level fits", {
  # c1 varies within id, and the lowest level is not given
  groups <- get_groups("id", longDF)["id"]
  expect_error(
    get_datlvls(longDF[, "c1", drop = FALSE], groups),
    "level"
  )
})
