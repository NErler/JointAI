# Helper functions around running JAGS (R/helpfunctions_JAGS.R) that do not
# need JAGS.

skip_on_cran()

secs <- function(x) as.difftime(x, units = "secs")

# computational duration as stored in object$comp_info$duration: one row per
# run, one column per chain (parallel) or a column "total" (sequential)
duration_object <- function(adapt, sample, parallel) {
  runs <- paste("run", seq_len(nrow(adapt)))
  list(
    comp_info = list(
      parallel = rep(parallel, length(runs)),
      duration = list(
        adapt = `rownames<-`(adapt, runs),
        sample = `rownames<-`(sample, runs)
      )
    )
  )
}

test_that("sum_duration() of sequential runs adds up all durations", {
  obj <- duration_object(
    adapt = data.frame(total = secs(c(1, 2))),
    sample = data.frame(total = secs(c(10, 20))),
    parallel = FALSE
  )
  expect_equal(as.numeric(sum_duration(obj)), 33)
  expect_equal(
    lapply(sum_duration(obj, by = "phase"), as.numeric),
    list(adapt = 3, sample = 30)
  )
  expect_equal(
    as.numeric(sum_duration(obj, by = "run")),
    c(11, 22)
  )
  expect_equal(
    lapply(sum_duration(obj, by = "phase and run"), as.numeric),
    list(adapt = c(1, 2), sample = c(10, 20))
  )
})

test_that("sum_duration() of parallel chains uses the longest chain", {
  obj <- duration_object(
    adapt = data.frame(chain1 = secs(c(1, 2)), chain2 = secs(c(3, 4))),
    sample = data.frame(chain1 = secs(c(10, 20)), chain2 = secs(c(30, 5))),
    parallel = TRUE
  )
  # per phase and run, the longest chain: adapt 3, 4; sample 30, 20
  expect_equal(as.numeric(sum_duration(obj)), 57)
  expect_equal(
    lapply(sum_duration(obj, by = "phase"), as.numeric),
    list(adapt = 7, sample = 50)
  )
  expect_equal(
    lapply(sum_duration(obj, by = "phase and run"), as.numeric),
    list(adapt = c(3, 4), sample = c(30, 20))
  )
  # per chain, over phases and runs
  expect_equal(as.numeric(sum_duration(obj, by = "chain")), c(33, 42))
})

test_that("sum_duration(by = \"run\") of parallel chains adds up the phases", {
  obj <- duration_object(
    adapt = data.frame(chain1 = secs(c(1, 2)), chain2 = secs(c(3, 4))),
    sample = data.frame(chain1 = secs(c(10, 20)), chain2 = secs(c(30, 5))),
    parallel = TRUE
  )
  # per run, the longest chain of each phase: adapt 3, 4; sample 30, 20
  expect_equal(as.numeric(sum_duration(obj, by = "run")), c(33, 24))
  # the runs add up to the total
  expect_equal(
    sum(as.numeric(sum_duration(obj, by = "run"))),
    as.numeric(sum_duration(obj))
  )
})

test_that("reformat_difftime() chooses the unit of the shortest duration", {
  expect_identical(units(reformat_difftime(secs(c(0.5, 30)))), "secs")
  expect_identical(units(reformat_difftime(secs(c(90, 4000)))), "mins")
  expect_identical(units(reformat_difftime(secs(c(4000, 9000)))), "hours")
  expect_identical(units(reformat_difftime(secs(2e5))), "days")
  expect_equal(as.numeric(reformat_difftime(secs(c(90, 120)))), c(1.5, 2))
})

test_that("sum_duration() keeps the runs in their numeric order", {
  # 11 runs: sorted as text, "run 10" and "run 11" would come before "run 2"
  obj <- duration_object(
    adapt = data.frame(total = secs(1:11)),
    sample = data.frame(total = secs(10 * (1:11))),
    parallel = FALSE
  )
  runs <- paste("run", 1:11)
  expect_named(sum_duration(obj, by = "run"), runs)
  expect_equal(as.numeric(sum_duration(obj, by = "run")), 11 * (1:11))
  expect_named(sum_duration(obj, by = "phase and run")$sample, runs)
  expect_equal(
    as.numeric(sum_duration(obj, by = "phase and run")$sample),
    10 * (1:11)
  )
})
