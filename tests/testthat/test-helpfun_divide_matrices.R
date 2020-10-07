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


  expect_equal(
    check_rd_vcov_list(rd_vcov = list(full = c("a", "b"), full = c("c", "d")),
                       idvar = c("id", "center")),
    list(id = list(full = c("a", "b"), full = c("c", "d")),
         center = list(full = c("a", "b"), full = c("c", "d")))
  )

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


test_that('expand_rd_vcov_full', {
  expect_equal(
    expand_rd_vcov_full(rd_vcov = "full",
                        rd_outnam = list(id = c("a", "b"))),
    list(id = list(full = c("a", "b")))
  )

  expect_equal(
    expand_rd_vcov_full(rd_vcov = "full",
                        rd_outnam = list(id = c("a", "b"), center = "b")),
    list(id = list(full = c("a", "b")), center = list(full = "b"))
  )


  expect_equal(
    expand_rd_vcov_full(rd_vcov = list(id = "blockdiag", center = "full"),
                        rd_outnam = list(id = c("a", "b"), center = "b")),
    list(id = list(blockdiag = c("a", "b")), center = list(full = "b"))
  )

  expect_equal(
    expand_rd_vcov_full(rd_vcov = list(blockdiag = c("a", "b", "c")),
                        rd_outnam = list(id = c("a", "b", "c"),
                                         center = c("a", "b", "c"))),
    list(id = list(blockdiag = c("a", "b", "c")),
         center = list(blockdiag = c("a", "b", "c")))
  )



  expect_equal(
    expand_rd_vcov_full(rd_vcov = list(id = list(blockdiag = c("a", "b", "c")),
                                       center = "full"),
                        rd_outnam = list(id = c("a", "b", "c"),
                                         center = c("a", "b", "c"))),
    list(id = list(blockdiag = c("a", "b", "c")),
         center = list(full = c("a", "b", "c")))
  )

  expect_equal(
      expand_rd_vcov_full(rd_vcov = list(id = list(blockdiag = c("a", "b"),
                                                   indep = "c"),
                                         center = "full"),
                          rd_outnam = list(id = c("a", "b", "c"),
                                           center = c("a", "b"))),
      list(id = list(blockdiag = c("a", "b"),
                     indep = "c"),
           center = list(full = c("a", "b")))
    )


  ## rd_vcov and rd_outnam not matching
  expect_error(
    expand_rd_vcov_full(rd_vcov = list(full = c("a", "b"), full = c("c", "d")),
                        rd_outnam = list(id = c("a", "b", "c", "d"),
                                         center = c("a", "b", "d")))
  )

})


test_that("check_full_blockdiag", {
  expect_equal(
    check_full_blockdiag(rd_vcov = list(id = list(full = "a",
                                                  full = "b",
                                                  full = c("d", "e")))),
    list(id = list(blockdiag = "a",
                   blockdiag = "b",
                   full = c("d", "e")))
  )

  expect_error(
    check_full_blockdiag(rd_vcov = list(full = "a",
                                        full = "b",
                                        full = c("d", "e"))))
})


# check_rd_vcov ---------------------------------------------------------------
test_that("check_rd_vcov", {

  expect_equal(
    check_rd_vcov(rd_vcov = "full",
                  nranef = list(id = c(a = 3, b = 4))),
    list(id = list(full = structure(c("a", "b"),
                                    ranef_index = c(a = "1:3", b = "4:7"))))
  )

  expect_equal(
    check_rd_vcov(rd_vcov = "full",
                  nranef = list(id = c(a = 3, b = 4),
                                center = c(a = 1, b = 1))),
    list(id = list(full = structure(c("a", "b"),
                                    ranef_index = c(a = "1:3", b = "4:7"))),
         center = list(full = structure(c("a", "b"),
                                        ranef_index = c(a = 1, b = 2)))
    )
  )


  expect_equal(
    check_rd_vcov(rd_vcov = list(id = list(full = c("a", "b"),
                                           full = c("c", "d")),
                                 center = list(full = c("a", "b"),
                                               full = "d")),
                  nranef = list(id = c(a = 3, b = 4, c = 2, d = 2),
                                center = c(a = 1, b = 1, d = 2))),
    list(id = list(full = structure(c("a", "b"),
                                    ranef_index = c(a = "1:3", b = "4:7"),
                                    name = 1),
                   full = structure(c("c", "d"),
                                    ranef_index = c(c = "1:2", d = "3:4"),
                                    name = 2)),
         center = list(full = structure(c("a", "b"),
                                        ranef_index = c(a = 1, b = 2)),
                       blockdiag = "d"))
  )

  expect_equal(
    check_rd_vcov(rd_vcov = list(id = list(full = c("a", "b"),
                                           full = c("c", "d")),
                                 center = list(full = c("a", "b"),
                                               indep = "d")),
                  nranef = list(id = c(a = 3, b = 4, c = 2, d = 2),
                                center = c(a = 1, b = 1, d = 2))),
    list(id = list(full = structure(c("a", "b"),
                                    ranef_index = c(a = "1:3", b = "4:7"),
                                    name = 1),
                   full = structure(c("c", "d"),
                                    ranef_index = c(c = "1:2", d = "3:4"),
                                    name = 2)),
         center = list(full = structure(c("a", "b"),
                                        ranef_index = c(a = 1, b = 2)),
                       indep = "d"
         ))
  )


  expect_equal(
    check_rd_vcov(rd_vcov = list(id = list(blockdiag = c("a", "b"),
                                           indep = c("c", "d")),
                                 center = list(full = c("a", "b"),
                                               indep = "d")),
                  nranef = list(id = c(a = 3, b = 4, c = 2, d = 2),
                                center = c(a = 1, b = 1, d = 2))),
    list(id = list(blockdiag = c("a", "b"),
                   indep = c("c", "d")),
         center = list(full = structure(c("a", "b"),
                                        ranef_index = c(a = 1, b = 2)),
                       indep = "d")
    )
  )
})



test_that("get_nranef", {

  expect_equal(
    get_nranef(idvar = "id", random = ~ 1 | id, data = longDF),
    list(id = 1)
  )

  expect_equal(
    get_nranef(idvar = "id", random = list(~ 1 | id, ~ time | id),
               data = longDF),
    list(id = c(1, 2))
  )

  expect_equal(
    get_nranef(idvar = "id", random = list(a = ~ (1 | id),  b = ~ time | id),
               data = longDF),
    list(id = c(a = 1, b = 2))
  )

  expect_equal(
    get_nranef(idvar = "id",
               random = list(~ (1 | id),  ~ splines::ns(time, df = 3) | id),
               data = longDF),
    list(id = c(1, 4))
  )


  expect_equal(
    get_nranef(idvar = c("id", "center"), random = ~ 1 | id,
               data = longDF),
    list(id = 1, center = 0)
  )

})
