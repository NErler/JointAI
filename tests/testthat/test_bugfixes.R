context("bugfixes's")
library("JointAI")

test_that("bugfix parameters for ordinal", {
  expect_equal(class(clm_imp(O1 ~ C1 + B1, data = wideDF)), "JointAI")
  expect_equal(class(clm_imp(O1 ~ 1, data = wideDF)), "JointAI")
  expect_equal(class(clm_imp(O1 ~ C1 + B1 + C2, data = wideDF)), "JointAI")
})
