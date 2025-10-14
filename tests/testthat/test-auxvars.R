
library("JointAI")
library("testthat")

m1 <- lm_imp(y ~ C1 + C2 + B2, auxvars = ~I(C1^2),
              data = wideDF, n.iter = 0, n.adapt = 0)


test_that("functions in auxiliary variables works", {
  expect_s3_class(m1, "JointAI")
})
