# Tests for data with label metadata, as produced e.g. by importing SPSS data
# (GitHub issues #35 and #17). No JAGS needed.

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

lab_df <- wideDF
# value labels for 1-3; 4 occurs but has no label; 9 has a label but does not
# occur; some values are missing
lab_df$V <- haven_labelled(
  as.numeric(wideDF$M1),
  labels = c(low = 1, mid = 2, high = 3, refused = 9),
  label = "a variable with value labels"
)
lab_df$V[c(3, 7)] <- NA
# only a variable label
lab_df$W <- haven_labelled(wideDF$C2, label = "only a variable label")
# Hmisc-style numeric, and a factor that kept the class (as in #17)
lab_df$H <- structure(wideDF$C1, label = "Hmisc label",
                      class = c("labelled", "numeric"))
lab_df$F <- structure(wideDF$M2, label = "Hmisc label",
                      class = c("labelled", "factor"))
# haven < 2.0: class "labelled" with value labels
lab_df$O <- structure(as.numeric(wideDF$B1), labels = c(no = 1, yes = 2),
                      class = "labelled")

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
