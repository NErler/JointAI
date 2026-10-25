# Tests for data with label metadata, as produced e.g. by importing SPSS data
# (GitHub issues #35 and #17). Only the predict() test needs JAGS.

# Issue #35 --------------------------------------------------------------------
# get_datlvls() compared the data with a copy rebuilt by subsetting, which
# drops attributes such as "label", so variables with such an attribute got no
# level (NA).

test_that("get_datlvls() ignores attributes that subsetting drops (#35)", {
  groups <- get_groups("id", longDF)
  dat <- longDF[, c("C1", "c1", "B2", "time", "y")]

  dat_attr <- dat
  attr(dat_attr$C1, "label") <- "a variable label"
  attr(dat_attr$c1, "comment") <- "a comment"

  expected <- c(C1 = "id", c1 = "lvlone", B2 = "id", time = "lvlone",
                y = "lvlone")
  expect_identical(get_datlvls(dat, groups), expected)
  expect_identical(get_datlvls(dat_attr, groups), expected)
})

test_that("get_models() works with label attributes (example from #35)", {
  toy_label <- wideDF
  for (v in c("C1", "C2", "L1", "L2")) {
    attr(toy_label[[v]], "label") <- paste("Continuous variable", v)
  }

  expect_identical(
    get_models(fixed = y ~ C1 + C2 + L1 + L2, data = toy_label),
    get_models(fixed = y ~ C1 + C2 + L1 + L2, data = wideDF)
  )
})

test_that("get_datlvls() gives an informative error if no level fits", {
  # c1 varies within id, and the lowest level is not given
  groups <- get_groups("id", longDF)["id"]
  expect_error(
    get_datlvls(longDF[, "c1", drop = FALSE], groups),
    "level"
  )
})


# Issue #17 --------------------------------------------------------------------
# Variables with class "labelled" (Hmisc, haven < 2.0) or "haven_labelled"
# (haven >= 2.0) were rejected by check_classes(). Variables with value labels
# are now converted to (unordered) factors; other labelled variables keep their
# underlying values. Variable labels ("label" attribute) are kept.

run_check_data <- function(data, formula, mess = FALSE) {
  formula <- check_formula_list(formula)
  check_data(
    data,
    fixed = split_formula_list(formula)$fixed,
    random = split_formula_list(formula)$random,
    auxvars = NULL,
    timevar = NULL,
    mess = mess,
    warn = FALSE
  )
}

# objects with the class and attributes that haven / Hmisc create
haven_labelled <- function(x, labels = NULL, label = NULL) {
  structure(x, labels = labels, label = label,
            class = c("haven_labelled", "vctrs_vctr", class(x)))
}

# Without haven loaded, `[` drops the class and attributes of these objects, so
# subsets of the data are created with this function instead of by subsetting.
make_lab_df <- function(rows = seq_len(nrow(wideDF))) {
  d <- wideDF[rows, ]
  # value labels for 1-3; 4 occurs but has no label; 9 has a label but does
  # not occur; some values are missing
  V <- as.numeric(d$M1)
  V[rows %in% c(3, 7)] <- NA
  d$V <- haven_labelled(
    V,
    labels = c(low = 1, mid = 2, high = 3, refused = 9),
    label = "a variable with value labels"
  )
  # only a variable label
  d$W <- haven_labelled(d$C2, label = "only a variable label")
  # Hmisc-style numeric, and a factor that kept the class (as in #17)
  d$H <- structure(d$C1, label = "Hmisc label",
                   class = c("labelled", "numeric"))
  d$F <- structure(d$M2, label = "Hmisc label",
                   class = c("labelled", "factor"))
  # haven < 2.0: class "labelled" with value labels
  d$O <- structure(as.numeric(d$B1), labels = c(no = 1, yes = 2),
                   class = "labelled")
  d
}

lab_df <- make_lab_df()

form17 <- y ~ C1 + V + W + H + F + O

test_that("check_data() accepts labelled variables (#17)", {
  expect_no_error(run_check_data(lab_df, form17))
})

test_that("variables with value labels become unordered factors", {
  res <- run_check_data(lab_df, form17)

  expect_s3_class(res$V, "factor", exact = TRUE)
  expect_identical(levels(res$V), c("low", "mid", "high", "4"))
  expected <- c("low", "mid", "high", "4")[as.numeric(wideDF$M1)]
  expected[c(3, 7)] <- NA
  expect_identical(as.character(res$V), expected)
  expect_identical(attr(res$V, "label"), "a variable with value labels")

  expect_s3_class(res$O, "factor", exact = TRUE)
  expect_identical(levels(res$O), c("no", "yes"))
})

test_that("labelled variables without value labels keep their values", {
  res <- run_check_data(lab_df, form17)

  expect_identical(class(res$W), "numeric")
  expect_identical(as.vector(res$W), wideDF$C2)
  expect_identical(attr(res$W, "label"), "only a variable label")

  expect_identical(class(res$H), "numeric")
  expect_identical(as.vector(res$H), wideDF$C1)

  expect_s3_class(res$F, "factor", exact = TRUE)
  expect_identical(levels(res$F), levels(wideDF$M2))
  expect_identical(attr(res$F, "label"), "Hmisc label")
})

test_that("a message reports the conversion to factor", {
  expect_message(run_check_data(lab_df, form17, mess = TRUE), "value labels")
  expect_no_message(run_check_data(lab_df, y ~ C1 + W + H, mess = TRUE))
})

test_that("check_classes() names the variables with unsupported classes", {
  dat <- wideDF
  dat$P <- as.POSIXct("2020-01-01", tz = "UTC") + seq_len(nrow(dat))
  dat$D <- as.Date("2020-01-01") + seq_len(nrow(dat))

  # the message is line-wrapped; compare it without line breaks
  err <- tryCatch(check_classes(dat, fixed = list(y = y ~ C1 + P + D)),
                  error = function(e) gsub("\\s+", " ", conditionMessage(e)))
  expect_match(err, "variables: P)", fixed = TRUE)
  expect_match(err, "variables: D)", fixed = TRUE)
  expect_no_match(err, "P1|P2")
})


# predict() with labelled newdata ----------------------------------------------
# newdata is converted like the data used for fitting, but with the factor
# levels of the fitted model (newdata may not contain all values).

test_that("convert_labelled() can use the factor levels of reference data", {
  ref <- run_check_data(lab_df, form17)

  # rows in which the value 4 (unlabelled level "4") does not occur
  rows <- which(as.numeric(wideDF$M1) != 4)[1:5]
  res <- convert_labelled(
    make_lab_df(rows),
    allvars = c("V", "O"),
    mess = FALSE,
    ref_data = ref
  )

  expect_identical(levels(res$V), levels(ref$V))
  expect_identical(as.character(res$V), as.character(ref$V[rows]))
  expect_identical(levels(res$O), levels(ref$O))
})

test_that("predict() works with labelled newdata", {
  skip_on_cran()

  mod <- suppressWarnings(lm_imp(
    y ~ C1 + V + H,
    data = lab_df,
    n.adapt = 5,
    n.iter = 10,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  ))

  # all rows, and rows in which the value 4 of V does not occur
  for (rows in list(
    seq_len(nrow(lab_df)),
    which(as.numeric(wideDF$M1) != 4)[1:10]
  )) {
    expect_identical(
      predict(mod, newdata = make_lab_df(rows), warn = FALSE)$fitted,
      predict(mod, newdata = mod$data[rows, ], warn = FALSE)$fitted
    )
  }
})

test_that("values without a category in the reference data become NA", {
  # reference data in which the value 4 does not occur
  rows <- which(as.numeric(wideDF$M1) != 4)
  ref <- run_check_data(make_lab_df(rows), form17)
  expect_false("4" %in% levels(ref$V))

  expect_warning(
    res <- convert_labelled(
      make_lab_df(),
      allvars = "V",
      mess = FALSE,
      ref_data = ref
    ),
    "set to missing"
  )
  expect_identical(levels(res$V), levels(ref$V))
  expect_true(all(is.na(res$V[as.numeric(wideDF$M1) == 4])))
})
