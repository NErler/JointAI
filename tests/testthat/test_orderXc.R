library(JointAI)
library(splines)

context("Order of columns in data matrices")

test_that("Xc is ordered according to missing percentage",{
  DF <- sim_data(N = 100,
                 norm = c("C1", "C2"),
                 bin = c("B1", "B2"),
                 multi = c("M1", "M2"),
                 ord = c("O1", "O2"),
                 long = c("L1", "L2"),
                 misvar = c("C2", "B2", "M2", "O2", "L2"))

  fixed_list <- list(
    # main effects only
    y ~ C1 + C2 + B1 + B2 + M1 + M2 + O1 + O2 + L1 + time,
    # interaction terms
    y ~ C1 * C2 + C1 * B2 + M1*B1 + C2*M2 + O2*L1 + time,
    # non-linear effects: splines (and no missing values)
    y ~ ns(C1, df = 2) + bs(L1, df = 2) + ns(time, df = 2)
  )

  random_list <- list(
    NULL,
    ~1 | id,
    ~time | id
  )


  fmlas <- expand.grid(fixed_list, random_list)

  testout <- lapply(1:nrow(fmlas),
                    function(i) {
                      sum(diff(
                        colSums(is.na(
                          get_X(DF, fixed = fmlas$Var1[i][[1]],
                                random = fmlas$Var2[i][[1]])$Xc))) < 0)
                    })

  expect_equal(testout[[1]], 0)
  expect_equal(testout[[2]], 0)
  expect_equal(testout[[3]], 0)
  expect_equal(testout[[4]], 0)
  expect_equal(testout[[5]], 0)
  expect_equal(testout[[6]], 0)
  expect_equal(testout[[7]], 0)
  expect_equal(testout[[8]], 0)
  expect_equal(testout[[9]], 0)


})