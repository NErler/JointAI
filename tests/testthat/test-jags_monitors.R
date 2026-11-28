# The nodes that JAGS monitors. rjags >= 5 (checked with rjags 5-5 and 5-6)
# cannot set a monitor on an element of a node whose name contains an
# underscore, letters and another underscore (e.g., D_y_id[1,2]), but it can
# monitor the whole node. With rjags >= 5, JointAI monitors the whole node and
# keeps the requested elements.

# get_monitor_nodes() ----------------------------------------------------------

test_that("get_monitor_nodes(): whole nodes for two underscores", {
  var_names <- c(
    "beta",
    "sigma_y",
    "D_y_id[1,1]",
    "D_y_id[1,2]",
    "D_y_id[2,2]",
    "M_lvlone[3,2]"
  )

  # D_y_id is monitored as a whole node (once); the other names, also the
  # element of M_lvlone (one underscore), as they are
  expect_equal(
    get_monitor_nodes(var_names, whole_nodes = TRUE),
    c("beta", "sigma_y", "D_y_id", "M_lvlone[3,2]")
  )

  # without whole nodes (rjags < 5), the names are not changed
  expect_equal(get_monitor_nodes(var_names, whole_nodes = FALSE), var_names)
})


# select_monitored_columns() ---------------------------------------------------

test_that("select_monitored_columns() keeps the requested elements in order", {
  # set-up: samples of two chains of beta and the whole 3 x 3 node D_y_id (in
  # the order in which JAGS returns them: first index fastest)
  cov_columns <- paste0(
    "D_y_id[",
    rep(1:3, times = 3),
    ",",
    rep(1:3, each = 3),
    "]"
  )
  columns <- c("beta[1]", "beta[2]", cov_columns)
  chain <- function(start) {
    coda::mcmc(
      matrix(
        start + seq_len(4L * length(columns)),
        nrow = 4L,
        dimnames = list(NULL, columns)
      )
    )
  }
  mcmc <- coda::mcmc.list(chain(0), chain(100))

  # the requested elements of D_y_id: the upper triangle, row by row
  requested <- c(
    "beta",
    "D_y_id[1,1]",
    "D_y_id[1,2]",
    "D_y_id[1,3]",
    "D_y_id[2,2]",
    "D_y_id[2,3]",
    "D_y_id[3,3]"
  )
  selected <- select_monitored_columns(
    mcmc,
    requested,
    monitor_nodes = c("beta", "D_y_id")
  )

  # the columns of beta and the requested elements, in the requested order,
  # with their values
  expected_columns <- c("beta[1]", "beta[2]", requested[-1L])
  expect_equal(colnames(selected[[1L]]), expected_columns)
  expect_equal(
    unclass(selected[[2L]])[, expected_columns],
    unclass(mcmc[[2L]])[, expected_columns],
    ignore_attr = TRUE
  )
  expect_s3_class(selected, "mcmc.list")
})


test_that("select_monitored_columns() names the column of a 1 x 1 node", {
  # set-up: the whole 1 x 1 node D_y_center was monitored; JAGS names its
  # column like the node
  mcmc <- coda::mcmc.list(coda::mcmc(
    matrix(1:6, nrow = 3L, dimnames = list(NULL, c("beta", "D_y_center")))
  ))

  selected <- select_monitored_columns(
    mcmc,
    c("beta", "D_y_center[1,1]"),
    monitor_nodes = c("beta", "D_y_center")
  )

  expect_equal(colnames(selected[[1L]]), c("beta", "D_y_center[1,1]"))
  expect_equal(as.vector(selected[[1L]][, "D_y_center[1,1]"]), 4:6)
})


test_that("select_monitored_columns() keeps ranges of elements", {
  # set-up: the whole node b_y_id (3 x 2) was monitored
  columns <- paste0(
    "b_y_id[",
    rep(1:3, times = 2),
    ",",
    rep(1:2, each = 3),
    "]"
  )
  mcmc <- coda::mcmc.list(coda::mcmc(
    matrix(seq_len(2L * 6L), nrow = 2L, dimnames = list(NULL, columns))
  ))

  # a range of the second index
  expect_equal(
    colnames(select_monitored_columns(mcmc, "b_y_id[3,1:2]", "b_y_id")[[1L]]),
    c("b_y_id[3,1]", "b_y_id[3,2]")
  )
})


test_that("expand_element_names() writes out ranges of elements", {
  # a single element, and ranges (the first index varies fastest)
  expect_equal(expand_element_names("D_y_id[1,2]"), "D_y_id[1,2]")
  expect_equal(
    expand_element_names("b_y_id[5, 1:2]"),
    c("b_y_id[5,1]", "b_y_id[5,2]")
  )
  expect_equal(
    expand_element_names("x[1:2,3:4]"),
    c("x[1,3]", "x[2,3]", "x[1,4]", "x[2,4]")
  )
})


# models -----------------------------------------------------------------------

test_that("the covariance matrix of the random effects is monitored", {
  skip_on_cran()
  # set-up: a model with a random intercept and slope, sampled shortly
  fit <- lme_imp(
    y ~ C1 + time + (time | id),
    data = longDF,
    n.adapt = 10,
    n.iter = 10,
    seed = 2020,
    mess = FALSE
  )

  # the upper triangle of D_y_id, as before
  expect_equal(
    grep("^D_y_id", colnames(fit$MCMC[[1L]]), value = TRUE),
    c("D_y_id[1,1]", "D_y_id[1,2]", "D_y_id[2,2]")
  )
  expect_no_error(rd_vcov(fit))
})
