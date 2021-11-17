library("JointAI")


# check_formula_list -----------------------------------------------------------
test_that("check_random_lvls", {

  expect_null(check_random_lvls(random = NULL, rel_lvls = NULL))
  expect_null(check_random_lvls(random = ~ time | id, rel_lvls = NULL))

  expect_equal(check_random_lvls(random = NULL, rel_lvls = c("id", "center")),
               list(id = ~ 1, center = ~ 1), ignore_attr = TRUE
  )


  expect_equal(
    check_random_lvls(random = ~1 | center, rel_lvls = c("id", "center")),
    list(center = ~ 1), ignore_attr = TRUE
  )

  expect_error(
    check_random_lvls(random = ~ (1 | center) + (1 | hospital),
                      rel_lvls = c("id", "center"))
  )
})


test_that("get_rds_lp", {

  # no random slope
  expect_equal(get_rds_lp(rd_slope_coefs = NULL,
                          index = NULL, lvl = NULL,
                          parname = NULL),
               list()
  )

  # random slope with corresponding fixed effect
  expect_equal(
    get_rds_lp(rd_slope_coefs = data.frame(rd_effect = "time",
                                           parelmts = 1),
               parname = "beta", index = NULL, lvl = NULL),
    list(time = c("beta[1]")))

    # random slope without fixed effect
  expect_equal(
    get_rds_lp(rd_slope_coefs = data.frame(rd_effect = "time",
                                           parelmts = NA),
               parname = "beta", index = NULL, lvl = NULL),
    list(time = c("0")))

  # multiple random slopes
  expect_equal(
    get_rds_lp(rd_slope_coefs =
                 data.frame(rd_effect = c("time", "time2"),
                            parelmts = c(3, 6)),
               parname = "beta", index = NULL, lvl = NULL),
    list(time = "beta[3]", time2 = "beta[6]"))

  # multiple random slopes, some with, some without fixed effects
  expect_equal(
    get_rds_lp(rd_slope_coefs =
                 data.frame(rd_effect = c("time", "time2"),
                            parelmts = c(3, NA)),
               parname = "beta", index = NULL, lvl = NULL),
    list(time = "beta[3]", time2 = "0"))

  # random slope with corresponding fixed effect & interaction
  expect_equal(
    get_rds_lp(rd_slope_coefs = data.frame(rd_effect = "time",
                                           parelmts = 1),
               rd_slope_interact_coefs = data.frame(rd_effect = "time",
                                                    matrix = "M_id",
                                                    parelmts = 2,
                                                    cols = 3),
               lvl = "id", parname = "beta", index = c(id = "i")),
    list(time = "beta[1] + M_id[i, 3] * beta[2]")
  )

  # interaction with multiple variables
  expect_equal(
    get_rds_lp(rd_slope_coefs = data.frame(rd_effect = "time",
                                           parelmts = 1),
               rd_slope_interact_coefs = data.frame(rd_effect = "time",
                                                    matrix = "M_id",
                                                    parelmts = c(2, 3),
                                                    cols = c(3, 4)),
               lvl = "id", parname = "beta", index = c(id = "i")),
    list(time = "beta[1] + M_id[i, 3] * beta[2] + M_id[i, 4] * beta[3]")
  )


  # combination of random slopes with/out corresponding fixed effect &
  # (no) interaction
  expect_equal(
    get_rds_lp(
      rd_slope_coefs = data.frame(rd_effect = c("time", "time2", "time3"),
                                  parelmts = c(1, 2, NA)),
      rd_slope_interact_coefs = data.frame(rd_effect = "time",
                                           matrix = "M_id",
                                           parelmts = c(4, 5),
                                           cols = c(3, 4)),
      lvl = "id", parname = "beta", index = c(id = "i")),
    list(time = "beta[1] + M_id[i, 3] * beta[4] + M_id[i, 4] * beta[5]",
         time2 = "beta[2]",
         time3 = "0")
  )



  expect_equal(
    get_rds_lp(
      rd_slope_coefs = data.frame(rd_effect = "time",
                                  parelmts = NA),
      rd_slope_interact_coefs = data.frame(rd_effect = "time",
                                           matrix = "M_id",
                                           parelmts = NA,
                                           cols = 2),
      lvl = "id", parname = "beta", index = c(id = "i")),
    list(time = "0")
  )

})



# hc_rdslope_info(list(time = list(main = c(M_lvlone = 3),
#                                  interact = NULL)),
#                 parelmts = list(M_id = c("(Intercept)" = 1,
#                                          C1 = 2),
#                                 M_lvlone = c(b21 = 3,
#                                              time = 4)
#                 )
# )

