# get_outcome_data(): the outcomes of the formulas, their names and the model
# types. The expected values are derived from the data and from the rules for
# the default model types (by type of the outcome and whether it is on the
# highest level).

# correctness ------------------------------------------------------------------
test_that("outcomes of a multilevel model: names, types and coding", {
  ds <- get_data_structure(longDF, idvar = "id")
  analysis_type <- "lme"
  attr(analysis_type, "family") <- gaussian()
  res <- get_outcome_data(
    list(y ~ C1 + c2, c2 ~ C1, b1 ~ C1, o1 ~ C1, B2 ~ C1, M2 ~ C1, O2 ~ C1),
    data = longDF,
    data_structure = ds,
    analysis_type = analysis_type
  )

  # the formulas are named by their outcome
  outcomes <- c("y", "c2", "b1", "o1", "B2", "M2", "O2")
  expect_identical(names(res$fixed), outcomes)
  expect_identical(names(res$outcomes), outcomes)
  expect_identical(unlist(res$outnams), setNames(outcomes, outcomes))

  # the first formula has the analysis type; the others a default type: with
  # random effects (lmm, glmm, clmm) for outcomes on level one, without for
  # outcomes on the highest level (id)
  expect_identical(
    vapply(res$fixed, attr, "", "type"),
    c(
      y = "glmm_gaussian_identity",
      c2 = "lmm",
      b1 = "glmm_binomial_logit",
      o1 = "clmm",
      B2 = "glm_binomial_logit",
      M2 = "mlogit",
      O2 = "clm"
    )
  )

  # continuous outcomes unchanged; binary factors coded 0/1, other factors
  # 1, 2, ...; missing values kept
  expect_identical(res$outcomes$c2$c2, longDF$c2)
  expect_identical(res$outcomes$b1$b1, as.integer(longDF$b1 == "1"))
  expect_identical(res$outcomes$B2$B2, as.integer(longDF$B2 == "1"))
  expect_identical(res$outcomes$o1$o1, match(longDF$o1, levels(longDF$o1)))
  expect_identical(res$outcomes$M2$M2, match(longDF$M2, levels(longDF$M2)))
})

test_that("survival outcome: time and status, type from the analysis", {
  pbc1 <- PBC[!duplicated(PBC$id), ]
  ds <- get_data_structure(pbc1, idvar = NULL)
  fixed <- list(Surv(futime, status != "censored") ~ age + sex)
  survname <- "Surv(futime, status != \"censored\")"

  for (type in c("survreg", "coxph", "JM")) {
    res <- get_outcome_data(
      fixed,
      data = pbc1,
      data_structure = ds,
      analysis_type = type
    )
    expect_identical(names(res$fixed), survname)
    expect_identical(attr(res$fixed[[1L]], "type"), type)
  }

  # the outcome: the time and the event indicator (1 = event), named by the
  # arguments of Surv()
  out <- res$outcomes[[survname]]
  expect_identical(names(out), c("futime", "status != \"censored\""))
  expect_equal(out$futime, pbc1$futime)
  expect_equal(out[[2L]], as.numeric(pbc1$status != "censored"))
})

test_that("errors: missing survival times, more than one column", {
  pbc1 <- PBC[!duplicated(PBC$id), ]
  pbc1$futime[3L] <- NA
  expect_error(
    get_outcome_data(
      list(Surv(futime, status != "censored") ~ age),
      data = pbc1,
      data_structure = get_data_structure(pbc1, idvar = NULL),
      analysis_type = "survreg"
    ),
    "missing values in the survival time or status"
  )

  expect_error(
    get_outcome_data(
      list(cbind(C1, C2) ~ B1),
      data = wideDF,
      data_structure = get_data_structure(wideDF, idvar = NULL),
      analysis_type = "lm"
    ),
    "one-column response"
  )
})

# same result as the version kept for remiod -----------------------------
test_that("get_outcome_data() gives the result of extract_outcome_data()", {
  # the new function and the version kept for remiod
  specs <- list(
    list(fixed = list(y ~ C1 + c2, c2 ~ C1), random = NULL, type = "lmm"),
    list(
      fixed = list(y ~ C1 + b1 + o1, b1 ~ C1, o1 ~ C1),
      random = list(~ 1 | id, ~ 1 | id, ~ 1 | id),
      type = "lmm"
    ),
    list(
      fixed = list(Surv(futime, status != "censored") ~ age + sex),
      random = NULL,
      type = "survreg",
      data = PBC[!duplicated(PBC$id), ]
    )
  )
  for (spec in specs) {
    data <- if (is.null(spec$data)) longDF else spec$data
    ds <- get_data_structure(data, extract_grouping(spec$random))
    expect_identical(
      get_outcome_data(
        spec$fixed,
        data = data,
        data_structure = ds,
        analysis_type = spec$type
      ),
      extract_outcome_data(
        spec$fixed,
        random = spec$random,
        data = data,
        analysis_type = spec$type
      )
    )
  }
})
