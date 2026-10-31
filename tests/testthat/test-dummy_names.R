# Variable names that are equal to the name of a dummy variable of a factor
# (#75). The design-matrix columns are identified by name, so such a variable
# and the dummy would be merged into one column. Model fitting must stop with
# an informative error before JAGS is run.

skip_on_cran()

# factor B1 (levels 0, 1) has the dummy B11
dat <- wideDF
dat$B11 <- dat$C1 + 1

test_that("a variable named like a dummy of a complete factor gives an error", {
  expect_error(
    lm_imp(y ~ B1 + B11 + C1, data = dat, n.adapt = 0, n.iter = 0),
    "B11"
  )
})

test_that("a variable named like a dummy of an incomplete factor gives an error", {
  dat$B1[1:5] <- NA
  expect_error(
    lm_imp(y ~ B1 + B11 + C1, data = dat, n.adapt = 0, n.iter = 0),
    "B11"
  )
})

test_that("an auxiliary variable named like a dummy gives an error", {
  dat$B1[1:5] <- NA
  expect_error(
    lm_imp(y ~ C1, auxvars = ~ B1 + B11, data = dat, n.adapt = 0, n.iter = 0),
    "B11"
  )
})

test_that("an outcome named like a dummy gives an error", {
  expect_error(
    lm_imp(B11 ~ B1 + C1, data = dat, n.adapt = 0, n.iter = 0),
    "B11"
  )
})

test_that("two factors with dummies of the same name give an error", {
  # factor B (levels a, 11) has the dummy B11, like B1
  dat$B <- factor(ifelse(dat$C2 > 0, "11", "a"), levels = c("a", "11"))
  expect_error(
    lm_imp(y ~ B1 + B + C1, data = dat, n.adapt = 0, n.iter = 0),
    "B11"
  )
})
