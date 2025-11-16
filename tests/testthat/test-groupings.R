# check_redundant_lvls -------------------------------------------
test_that(
  "check_redundant_lvls throws error when grouping has only unique values",
  {
    groups <- list(id = 1:5)

    expect_error(check_redundant_lvls(groups, 5))
  }
)

test_that("check_redundant_lvls does not throw error when grouping
          levels are meaningful", {
  groups <- list(group = rep(1:2, each = 3))

  expect_silent(check_redundant_lvls(groups, length(groups$group)))
})

test_that("check_redundant_lvls() handles multiple grouping levels
          correctly", {
  groups <- list(
    id = 1:6,
    group = rep(1:2, each = 3)
  )
  expect_error(check_redundant_lvls(groups, 6))
})


# check_duplicate_groupings ----------------------------------------------------
test_that("throws error when duplicate grouping levels are found", {
  groups <- list(
    group1 = c(1, 2, 1, 2),
    group2 = c(1, 2, 1, 2) # duplicate of group1
  )

  expect_error(check_duplicate_groupings(groups))
})

test_that("does not throw error when grouping levels are distinct", {
  groups <- list(
    group1 = c(1, 2, 1, 2),
    group2 = c(1, 1, 1, 2)
  )

  expect_silent(check_duplicate_groupings(groups))
})


# --- get_groups ----

test_that("get_groups() returns lvlone when idvars is NULL", {
  data <- data.frame(a = 1:3, b = 4:6)
  result <- get_groups(NULL, data)

  expect_type(result, "list")
  expect_named(result, "lvlone")
  expect_equal(result$lvlone, seq_len(nrow(data)))
})

test_that("get_groups() returns correct groups when idvars are provided", {
  data <- data.frame(group1 = c("a", "b", "a", "b"), group2 = c(1, 1, 1, 2))
  result <- get_groups(c("group1", "group2"), data)

  expect_type(result, "list")
  expect_named(result, c("group1", "group2", "lvlone"))
  expect_equal(result$lvlone, seq_len(nrow(data)))
  expect_equal(result$group1, match(data$group1, unique(data$group1)))
  expect_equal(result$group2, match(data$group2, unique(data$group2)))
})

test_that("get_group() throws error for unnecessary grouping levels", {
  data <- data.frame(id = 1:5)
  expect_error(
    get_groups("id", data),
    regexp = "unnecessary"
  )
})

test_that("get_groups() throws error for duplicate grouping levels", {
  data <- data.frame(group1 = c(1, 2, 1, 2), group2 = c(1, 2, 1, 2))
  expect_error(
    get_groups(c("group1", "group2"), data),
    regexp = "duplicates"
  )
})


# --- check_na_groupings --------
test_that("check_na_groupings() throws error when NA values are present", {
  groups <- list(
    group1 = c(1, 2, NA, 2),
    group2 = c("A", "B", "A", "B")
  )

  expect_error(check_na_groupings(groups))
})

test_that(
  "check_na_groupings() throws error when there are NaN values in id variables",
  {
    groups <- list(
      group1 = c(1, 2, NaN, 2),
      group2 = c("A", "B", "A", "B")
    )

    expect_error(check_na_groupings(groups))
  }
)

test_that(
  "check_na_groupings() doesn't throw error when no NA values are present",
  {
    groups <- list(
      group1 = c(1, 2, 1, 2),
      group2 = c("A", "B", "A", "B")
    )

    expect_silent(check_na_groupings(groups))
  }
)
