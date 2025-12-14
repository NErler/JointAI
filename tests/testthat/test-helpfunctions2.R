test_that("check_groups_vary_within_lvl() works for single level", {
  grouping <- list(id = 1:10)
  expect_equal(
    check_groups_vary_within_lvl(grouping[[1]], as.data.frame(grouping)),
    c(id = FALSE)
  )
})


test_that("check_groups_vary_within_lvl works for nested", {
  groups <- list(
    lvlone = 1:10,
    id = rep(1:5, 2),
    cluster = rep(1, 10)
  )

  expect_equal(
    check_groups_vary_within_lvl(groups$lvlone, as.data.frame(groups)),
    c(lvlone = FALSE, id = FALSE, cluster = FALSE)
  )

  expect_equal(
    check_groups_vary_within_lvl(groups$id, as.data.frame(groups)),
    c(lvlone = TRUE, id = FALSE, cluster = FALSE)
  )
  expect_equal(
    check_groups_vary_within_lvl(groups$cluster, as.data.frame(groups)),
    c(lvlone = TRUE, id = TRUE, cluster = FALSE)
  )
})

test_that("check_groups_vary_within_lvl works for crossed", {
  grouping <- list(
    lvlone = 1:10,
    cluster = c(1, 3, 3, 2, 1, 1, 2, 1, 3, 3),
    cluster2 = c(1, 1, 1, 1, 2, 2, 2, 2, 2, 2)
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$lvlone, as.data.frame(grouping)),
    c(lvlone = FALSE, cluster = FALSE, cluster2 = FALSE)
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$cluster, as.data.frame(grouping)),
    c(lvlone = TRUE, cluster = FALSE, cluster2 = TRUE)
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$cluster2, as.data.frame(grouping)),
    c(lvlone = TRUE, cluster = TRUE, cluster2 = FALSE)
  )
})

test_that("check_groups_vary_within_lvl works for complicated structure", {
  grouping <- list(
    lvlone = 1:40,
    id = rep(1:20, each = 2),
    cluster = rep(c(1, 2), each = 20),
    cluster2 = rep(c(1, 1, 2, 2), 10),
    cluster3 = rep(1, 40)
  )

  expect_equal(
    check_groups_vary_within_lvl(grouping$lvlone, as.data.frame(grouping)),
    c(
      lvlone = FALSE,
      id = FALSE,
      cluster = FALSE,
      cluster2 = FALSE,
      cluster3 = FALSE
    )
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$id, as.data.frame(grouping)),
    c(
      lvlone = TRUE,
      id = FALSE,
      cluster = FALSE,
      cluster2 = FALSE,
      cluster3 = FALSE
    )
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$cluster, as.data.frame(grouping)),
    c(
      lvlone = TRUE,
      id = TRUE,
      cluster = FALSE,
      cluster2 = TRUE,
      cluster3 = FALSE
    )
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$cluster2, as.data.frame(grouping)),
    c(
      lvlone = TRUE,
      id = TRUE,
      cluster = TRUE,
      cluster2 = FALSE,
      cluster3 = FALSE
    )
  )
  expect_equal(
    check_groups_vary_within_lvl(grouping$cluster3, as.data.frame(grouping)),
    c(
      lvlone = TRUE,
      id = TRUE,
      cluster = TRUE,
      cluster2 = TRUE,
      cluster3 = FALSE
    )
  )
})

# --- get_grouping_levels ---------------------------------------------------
test_that("get_grouping_levels works for nested", {
  groups <- data.frame(
    lvlone = 1:10,
    id = rep(1:5, 2),
    cluster = rep(1, 10)
  )

  expect_equal(get_grouping_levels(groups), c(lvlone = 1, id = 2, cluster = 3))
})

test_that("get_grouping_levels works for crossed", {
  grouping <- data.frame(
    lvlone = 1:10,
    cluster = c(1, 3, 3, 2, 1, 1, 2, 1, 3, 3),
    cluster2 = c(1, 1, 1, 1, 2, 2, 2, 2, 2, 2)
  )

  expect_equal(
    get_grouping_levels(grouping),
    c(lvlone = 1, cluster = 2, cluster2 = 2)
  )

  grouping2 <- data.frame(
    lvlone = 1:40,
    id = rep(1:20, each = 2),
    cluster = rep(c(1, 2), each = 20),
    cluster2 = rep(c(1, 1, 2, 2), 10),
    cluster3 = rep(1, 40)
  )

  expect_equal(
    get_grouping_levels(grouping2),
    c(lvlone = 1, id = 2, cluster = 3, cluster2 = 3, cluster3 = 5)
  )
})


test_that("get_grouping_levels works for single level", {
  grouping <- data.frame(lvlone = 1:10)

  expect_equal(get_grouping_levels(grouping), c(lvlone = 1))
})


test_that("ordering of grouping levels for nested", {
  groups <- data.frame(
    lvlone = 1:10,
    id = rep(1:5, 2),
    cluster = rep(1, 10)
  )
  res <- c(lvlone = 1, id = 2, cluster = 3)

  expect_equal(get_grouping_levels(groups), res)
  expect_equal(get_grouping_levels(groups[c(3, 2, 1)]), res)
  expect_equal(get_grouping_levels(groups[c(2, 1, 3)]), res)
})

test_that("ordering of grouping levels for crossed", {
  grouping2 <- data.frame(
    lvlone = 1:40,
    id = rep(1:20, each = 2),
    cluster = rep(c(1, 2), each = 20),
    cluster2 = rep(c(1, 1, 2, 2), 10),
    cluster3 = rep(1, 40)
  )
  res <- c(lvlone = 1, id = 2, cluster = 3, cluster2 = 3, cluster3 = 5)

  expect_equal(get_grouping_levels(grouping2), res)
  expect_equal(get_grouping_levels(grouping2[c(3, 1, 4, 2, 5)]), res)
  expect_equal(get_grouping_levels(grouping2[c(5, 4, 3, 2, 1)]), res)
  expect_equal(get_grouping_levels(grouping2[c(1, 3, 5, 4, 2)]), res)
})
