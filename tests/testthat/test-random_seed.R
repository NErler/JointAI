# Functions that set a seed save the state of the random number generator
# (`.Random.seed`) and restore it on exit. In a session in which no random
# numbers were drawn yet, `.Random.seed` does not exist; the functions must
# work then as well, and must not leave a `.Random.seed` behind.
# Fixtures and helpers: helper-fixtures.R.

skip_on_cran()

has_seed <- function() {
  exists(".Random.seed", envir = globalenv(), inherits = FALSE)
}

# Evaluate `code` without `.Random.seed`; afterwards, restore the previous
# state. Returns whether a `.Random.seed` existed after evaluating `code`.
seed_left_behind <- function(code) {
  genv <- globalenv()
  had_seed <- has_seed()
  if (had_seed) {
    oldseed <- get(".Random.seed", envir = genv, inherits = FALSE)
    rm(".Random.seed", envir = genv)
  }
  on.exit({
    if (had_seed) {
      assign(".Random.seed", oldseed, envir = genv)
    } else if (has_seed()) {
      rm(".Random.seed", envir = genv)
    }
  })
  code
  has_seed()
}

# without .Random.seed ---------------------------------------------------------
test_that("get_rng() works without .Random.seed", {
  expect_false(seed_left_behind(
    expect_length(get_rng(seed = NULL, n_chains = 2), 2)
  ))
  expect_false(seed_left_behind(
    expect_length(get_rng(seed = 1, n_chains = 2), 2)
  ))
})

test_that("get_initial_values() with an inits function works without .Random.seed", {
  inits <- function() list(b = 1)
  expect_false(seed_left_behind(
    expect_length(
      get_initial_values(inits, seed = 1, n_chains = 2, warn = FALSE),
      2
    )
  ))
})

test_that("get_MIdat() works without .Random.seed", {
  skip_if_not_installed("foreign")
  object <- fixture_load("lm")
  # same call as type "get_MIdat" of fixture_results()
  expect_false(seed_left_behind(
    expect_equal(
      get_MIdat(object, m = 2, seed = 2020),
      fixture_expected("lm", "get_MIdat")
    )
  ))
})

# with .Random.seed ------------------------------------------------------------
test_that("an existing .Random.seed is restored", {
  skip_if_not_installed("foreign")
  object <- fixture_load("lm")
  set.seed(123)
  seed_before <- .Random.seed

  get_rng(seed = 1, n_chains = 2)
  expect_identical(.Random.seed, seed_before)
  get_initial_values(
    function() list(b = 1),
    seed = 1,
    n_chains = 2,
    warn = FALSE
  )
  expect_identical(.Random.seed, seed_before)
  get_MIdat(object, m = 2, seed = 2020)
  expect_identical(.Random.seed, seed_before)
})
