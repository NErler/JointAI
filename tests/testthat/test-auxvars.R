
library("JointAI")
library("testthat")

m1 <- lm_imp(y ~ C1 + C2 + B2, auxvars = ~I(C1^2),
              data = wideDF, n.iter = 0, n.adapt = 0)


test_that("functions in auxiliary variables works", {
  expect_s3_class(m1, "JointAI")
})



m2 <- lm_imp(y ~ C1 + I(time/C2), auxvars = ~I(C1^2),
              data = wideDF, n.iter = 0, n.adapt = 0)

mod7a <- lm_imp(SBP ~ ns(age, df = 2) + gender + I(bili^2) + I(bili/age),
               data = NHANES, n.adapt = 5, n.iter = 10, seed = 2020,
               warn = FALSE, mess = FALSE)

test_that("using function type twice with different number of variables works",
          {
            expect_s3_class(m2, "JointAI")
            expect_s3_class(mod7a, "JointAI")
          })


