# The structure of the data (get_data_structure(), get_variable_table()): the
# groupings of the rows, the ranks and the nesting relation of the grouping
# levels, and the level and other properties of the variables. The expected
# values are derived from how the data are constructed.

# data -------------------------------------------------------------------------
# three nested levels: id in center
dat3 <- longDF
dat3$center <- as.integer(dat3$id) %% 5L
set.seed(1)
dat3$Z <- rnorm(5L)[dat3$center + 1L]

# crossed levels a and b, with a variable of b
datx <- expand.grid(a = 1:4, b = 1:3, rep = 1:2)
datx$B1 <- c(0.5, 1.2, -0.3)[datx$b]

# get_data_structure() ---------------------------------------------------------
test_that("one level: only lvlone", {
  ds <- get_data_structure(wideDF, idvar = NULL)
  expect_s3_class(ds, "JointAI_data_structure")
  expect_identical(names(ds$groups), "lvlone")
  expect_identical(ds$groups$lvlone, seq_len(nrow(wideDF)))
  expect_equal(ds$group_lvls, c(lvlone = 1))
  expect_identical(unname(ds$nested_in), matrix(TRUE))
})

test_that("two levels: groups, ranks and nesting", {
  ds <- get_data_structure(longDF, idvar = "id")

  # the group index of each row, sorted from the highest level
  expect_identical(names(ds$groups), c("id", "lvlone"))
  expect_identical(ds$groups$id, match(longDF$id, unique(longDF$id)))

  expect_equal(ds$group_lvls, c(id = 2, lvlone = 1))

  # rows are nested in subjects, not the other way round
  expect_true(ds$nested_in["lvlone", "id"])
  expect_false(ds$nested_in["id", "lvlone"])
  expect_true(all(diag(ds$nested_in)))
})

test_that("three nested levels: center above id", {
  ds <- get_data_structure(dat3, idvar = c("id", "center"))
  expect_identical(names(ds$groups), c("center", "id", "lvlone"))
  expect_equal(ds$group_lvls, c(center = 3, id = 2, lvlone = 1))

  # id and lvlone are nested in center, center is nested in neither
  expect_true(ds$nested_in["id", "center"])
  expect_true(ds$nested_in["lvlone", "center"])
  expect_false(ds$nested_in["center", "id"])

  # the rank of a level is the number of levels nested in it
  expect_equal(colSums(ds$nested_in)[names(ds$group_lvls)], ds$group_lvls)
})

test_that("crossed levels: same rank, not nested in each other", {
  ds <- get_data_structure(datx, idvar = c("a", "b"))
  expect_equal(ds$group_lvls[c("a", "b")], c(a = 2, b = 2))
  expect_false(ds$nested_in["a", "b"])
  expect_false(ds$nested_in["b", "a"])
  expect_true(ds$nested_in["lvlone", "a"])
  expect_true(ds$nested_in["lvlone", "b"])
  expect_equal(colSums(ds$nested_in)[names(ds$group_lvls)], ds$group_lvls)
})

# get_variable_table() ---------------------------------------------------------
test_that("variable table: level, missing values, categories, ordered", {
  ds <- get_data_structure(longDF, idvar = "id")
  vars <- c("C1", "C2", "B2", "M2", "O2", "c1", "c2", "time")
  tab <- get_variable_table(longDF, ds, vars)

  expect_identical(rownames(tab), vars)
  expect_identical(
    tab$level,
    c("id", "id", "id", "id", "id", "lvlone", "lvlone", "lvlone")
  )

  # missing values of a subject-level variable are counted once per subject,
  # those of a level-one variable once per row
  first_rows <- !duplicated(longDF$id)
  expect_identical(tab["C2", "n_missing"], sum(is.na(longDF$C2[first_rows])))
  expect_identical(tab["c2", "n_missing"], sum(is.na(longDF$c2)))
  expect_identical(tab["C1", "n_missing"], 0L)

  expect_identical(tab$n_categories, c(0L, 0L, 2L, 4L, 3L, 0L, 0L, 0L))
  expect_identical(
    tab$ordered,
    c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE)
  )
})

test_that("variable table: higher and crossed levels", {
  ds3 <- get_data_structure(dat3, idvar = c("id", "center"))
  tab3 <- get_variable_table(dat3, ds3, c("Z", "C1", "c1"))
  expect_identical(tab3$level, c("center", "id", "lvlone"))

  dsx <- get_data_structure(datx, idvar = c("a", "b"))
  expect_identical(get_variable_table(datx, dsx, "B1")$level, "b")
})

test_that("variable table: missing values count as values", {
  # C1 is constant within each subject; with one missing value in a subject
  # that also has observed values it is a level-one variable
  dat <- longDF
  dat$C1[2L] <- NA
  ds <- get_data_structure(dat, idvar = "id")
  expect_identical(get_variable_table(dat, ds, "C1")$level, "lvlone")
})

# get_datlvls() with given ranks -----------------------------------------------
test_that("get_datlvls(): the order of the given ranks does not matter", {
  ds <- get_data_structure(dat3, idvar = c("id", "center"))
  vars <- dat3[, c("Z", "C1", "c1")]
  expected <- get_datlvls(vars, ds$groups)
  expect_identical(
    get_datlvls(vars, ds$groups, group_lvls = ds$group_lvls),
    expected
  )
  expect_identical(
    get_datlvls(vars, ds$groups, group_lvls = rev(ds$group_lvls)),
    expected
  )
})
