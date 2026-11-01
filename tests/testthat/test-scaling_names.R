# How the back-transformation of the scaling (R/scaling.R) finds parameters and
# scaling parameters by name. No JAGS: the models are the golden master cases.

skip_on_cran()

names_case <- function(case) {
  readRDS(test_path("golden", paste0(case, ".rds")))
}

# Random values for all regression coefficients, transformed back. `scale_pars`
# is changed by the tests below.
rescale_names_case <- function(fit, scale_pars) {
  coefs <- do.call(rbind, get_coef_names(fit$info_list))
  draws <- matrix(
    seq_len(3L * nrow(coefs)) / 7,
    nrow = 3L,
    dimnames = list(NULL, coefs$coef)
  )
  rescale(
    draws,
    coefs = coefs,
    scale_pars = scale_pars,
    info_list = fit$info_list,
    data_list = fit$data_list,
    groups = fit$Mlist$groups
  )
}


# Lookup of the scaling parameters ---------------------------------------------

test_that("the order of the rows of the scaling parameters does not matter", {
  fit <- names_case("lognormmm_random_slope")
  sp <- do.call(rbind, unname(fit$Mlist$scale_pars))

  expect_identical(
    rescale_names_case(fit, sp[rev(seq_len(nrow(sp))), ]),
    rescale_names_case(fit, sp)
  )
})

test_that("a column without scaling parameters gives NA", {
  fit <- names_case("lognormmm_random_slope")
  sp <- do.call(rbind, unname(fit$Mlist$scale_pars))
  # no other row starts with "c2"
  expect_identical(grep("^c2", rownames(sp), value = TRUE), "c2")

  res <- rescale_names_case(fit, sp[rownames(sp) != "c2", ])

  # the coefficient of c2 and the intercept of its linear predictor
  expect_true(all(is.na(res[, c("beta[1]", "beta[3]")])))
  # the others, and the sub-model in which c2 is the outcome
  others <- c("beta[2]", "beta[4]", "alpha[1]", "alpha[2]", "alpha[3]")
  expect_false(anyNA(res[, others]))
})

test_that("scale_pars_rows() only finds exact names", {
  sp <- data.frame(
    center = c(1, 2, 3),
    scale = c(4, 5, 6),
    row.names = c("age_sq", "chol", "chol:age_sq")
  )

  # in the order of the names, also when a name is repeated
  expect_identical(
    scale_pars_rows(sp, c("chol", "age_sq", "chol"))$center,
    c(2, 1, 2)
  )
  # no partial match: indexing the rows with sp["age", ] returns "age_sq"
  expect_identical(scale_pars_rows(sp, "age")$center, NA_real_)
  expect_identical(scale_pars_rows(sp, "age")$scale, NA_real_)
  # no names
  expect_identical(nrow(scale_pars_rows(sp, character(0L))), 0L)
})


# Parsing of parameter names ---------------------------------------------------

test_that("parameter names are split into node and index", {
  x <- c("alpha", "alpha[3]", "alpha[2:4]", "b_y_id[5,1:2]")

  expect_identical(par_node(x), c("alpha", "alpha", "alpha", "b_y_id"))
  expect_identical(par_index_text(x), c("alpha", "3", "2:4", "5,1:2"))
  expect_identical(
    is_node_element(x, "alpha"),
    c(FALSE, TRUE, TRUE, FALSE)
  )
  expect_false(is_node_element("alpha2[3]", "alpha"))
})

test_that("coef_is_monitored() recognises nodes, elements and ranges", {
  # the whole node
  expect_true(coef_is_monitored("alpha[3]", "alpha"))
  # the element itself
  expect_true(coef_is_monitored("alpha[3]", "alpha[3]"))
  # a range that contains the element (also at its limits)
  expect_true(coef_is_monitored("alpha[3]", c("beta", "alpha[2:4]")))
  expect_true(coef_is_monitored("alpha[3]", "alpha[3:5]"))
  expect_true(coef_is_monitored("alpha[3]", "alpha[1:3]"))
  expect_true(coef_is_monitored("alpha[13]", "alpha[12:14]"))

  # other elements and ranges
  expect_false(coef_is_monitored("alpha[3]", "alpha[4]"))
  expect_false(coef_is_monitored("alpha[3]", "alpha[4:5]"))
  expect_false(coef_is_monitored("alpha[3]", "alpha[33]"))
  # other nodes that start in the same way
  expect_false(coef_is_monitored("alpha[3]", "alpha2"))
  expect_false(coef_is_monitored("alpha[3]", "alpha2[2:4]"))
  # not a range of a vector
  expect_false(coef_is_monitored("alpha[3]", "alpha[3,1:2]"))

  # a single coefficient has no index
  expect_true(coef_is_monitored("beta", "beta"))
  expect_false(coef_is_monitored("beta", "beta[1]"))
  expect_false(coef_is_monitored("beta", "alpha"))
})

test_that("complete_ranef_monitoring() monitors the rows of single elements", {
  info_list <- names_case("lognormmm_random_slope")$info_list
  betas <- paste0("beta[", 1:4, "]")

  # one element, and an element of the same group
  expect_identical(
    complete_ranef_monitoring("b_L1_id[5,2]", info_list, mess = FALSE),
    c("b_L1_id[5,1:2]", betas)
  )
  expect_identical(
    complete_ranef_monitoring(
      c("b_L1_id[5,1]", "b_L1_id[5,2]", "b_L1_id[12,1]"),
      info_list,
      mess = FALSE
    ),
    c("b_L1_id[5,1:2]", "b_L1_id[12,1:2]", betas)
  )
  # a whole row stays as it is
  expect_identical(
    complete_ranef_monitoring("b_L1_id[7,1:2]", info_list, mess = FALSE),
    c("b_L1_id[7,1:2]", betas)
  )
  # another node that starts in the same way
  expect_identical(
    complete_ranef_monitoring("b_L1_id2[5,2]", info_list, mess = FALSE),
    "b_L1_id2[5,2]"
  )
})

test_that("complete_ranef_monitoring() monitors all elements of D", {
  info_list <- names_case("lognormmm_random_slope")$info_list
  D_all <- c("D_L1_id[1,1]", "D_L1_id[1,2]", "D_L1_id[2,2]")

  expect_setequal(
    complete_ranef_monitoring("D_L1_id[1,2]", info_list, mess = FALSE),
    D_all
  )
  # the whole node, or another node, is left alone
  expect_identical(
    complete_ranef_monitoring("D_L1_id", info_list, mess = FALSE),
    "D_L1_id"
  )
  expect_identical(
    complete_ranef_monitoring("D_L1_id2[1,2]", info_list, mess = FALSE),
    "D_L1_id2[1,2]"
  )
})

test_that("complete_coef_monitoring() recognises elements of other nodes", {
  info_list <- names_case("clm_ifelse_abs")$info_list
  clm <- Filter(function(info) info$modeltype == "clm", info_list)[[1L]]
  coefs <- do.call(rbind, get_coef_names(info_list))
  needed <- coefs$coef[coefs$outcome %in% clm$varname]
  expect_gt(length(needed), 0L)
  threshold <- paste0("gamma_", clm$varname)

  # an element of the thresholds needs all coefficients of the sub-model
  expect_setequal(
    complete_coef_monitoring(paste0(threshold, "[1]"), info_list, mess = FALSE),
    c(paste0(threshold, "[1]"), needed)
  )
  # another node that starts in the same way does not
  expect_identical(
    complete_coef_monitoring(
      paste0(threshold, "2[1]"),
      info_list,
      mess = FALSE
    ),
    paste0(threshold, "2[1]")
  )
})
