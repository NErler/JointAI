context("help functions divide_matrices")
library("JointAI")

test_that('check_rd_vcov_list', {
  # rd_vcov is string
  expect_equal(
    check_rd_vcov_list(rd_vcov = "full", idvar = "id"),
    list(id = "full"))

  expect_equal(
    check_rd_vcov_list(rd_vcov = "blockdiag", idvar = "id"),
    list(id = "blockdiag"))

  expect_equal(
    check_rd_vcov_list(rd_vcov = "indep", idvar = c("id", "center")),
    list(id = "indep", center = "indep"))


  # rd_vcov is list of model structures (no level specified)
  expect_equal(
    check_rd_vcov_list(rd_vcov = list(full = c("a", "b")), idvar = "id"),
    list(id = list(full = c("a", "b")))
  )

  expect_equal(
    check_rd_vcov_list(rd_vcov = list(blockdiag = c("a", "b")),
                       idvar = c("id", "center")),
    list(id = list(blockdiag = c("a", "b")),
         center = list(blockdiag = c("a", "b"))))

  # rd_vcov has levels specified
  expect_equal(
    check_rd_vcov_list(rd_vcov = list(id = "full"), idvar = "id"),
    list(id = "full")
  )

  expect_equal(
    check_rd_vcov_list(rd_vcov = list(id = "full", center = "full"),
                       idvar = c("id", "center")),
    list(id = "full", center = "full"))

  expect_equal(
    check_rd_vcov_list(rd_vcov = list(id = list(full = c("a", "b"),
                                                indep = "c"),
                                      center = "full"),
                       idvar = c("id", "center")),
    list(id = list(full = c("a", "b"), indep = "c"),
         center = "full"))

  expect_error(
    check_rd_vcov_list(rd_vcov = list(id = "full"), idvar = c("id", "center"))
  )

})
