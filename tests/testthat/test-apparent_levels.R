# Variables that seem to belong to a higher level: their observed values are
# constant within the groups of a grouping level, but some groups have both
# observed and missing values (find_apparent_levels(), warn_apparent_levels()).
# Such a variable is treated as a lower-level variable; the user gets a warning
# with an expression that fills in the missing values.

# data -------------------------------------------------------------------------
# three nested levels: id in center; Zc constant within center, Zi constant
# within id (and varying between the ids of a center)
dat3 <- longDF
dat3$center <- as.integer(dat3$id) %% 5L
dat3$Zc <- c(0.1, 0.2, 0.3, 0.4, 0.5)[dat3$center + 1L]
dat3$Zi <- dat3$C1

# crossed levels a and b, with a variable of b
datx <- expand.grid(a = 1:4, b = 1:3, rep = 1:2)
datx$B1 <- c(0.5, 1.2, -0.3)[datx$b]

# is_partly_observed_constant() ------------------------------------------------
test_that("constant observed values and a partly missing group", {
  group <- c(1L, 1L, 2L, 2L, 3L, 3L)
  expect_true(is_partly_observed_constant(c(1, NA, 2, 2, 3, 3), group))
  # also with only one observed value per group
  expect_true(is_partly_observed_constant(c(1, NA, 2, NA, NA, NA), group))

  # observed values that vary within a group
  expect_false(is_partly_observed_constant(c(1, 5, 2, NA, 3, 3), group))
  # missing values only in completely missing groups
  expect_false(is_partly_observed_constant(c(1, 1, NA, NA, 3, 3), group))
  # no missing values
  expect_false(is_partly_observed_constant(c(1, 1, 2, 2, 3, 3), group))
})

# find_apparent_levels() -------------------------------------------------------
test_that("two levels: a subject-level variable with a missing value", {
  dat <- longDF
  dat$C1[2L] <- NA
  ds <- get_data_structure(dat, idvar = "id")
  ds$variables <- get_variable_table(dat, ds, c("C1", "C2", "c1", "time"))

  # C1 is reported; C2 (missing in whole subjects) and the level-one variables
  # are not
  expect_identical(find_apparent_levels(dat, ds), list(C1 = "id"))
})

test_that("two levels: only the first value of each subject observed", {
  dat <- longDF
  dat$x <- dat$c1
  dat$x[duplicated(dat$id)] <- NA
  ds <- get_data_structure(dat, idvar = "id")
  ds$variables <- get_variable_table(dat, ds, c("x", "c1"))
  expect_identical(find_apparent_levels(dat, ds), list(x = "id"))
})

test_that("no reports without such variables", {
  ds <- get_data_structure(longDF, idvar = "id")
  ds$variables <- get_variable_table(
    longDF,
    ds,
    c("C1", "C2", "B2", "M2", "c1", "c2", "b2", "time")
  )
  expect_identical(find_apparent_levels(longDF, ds), list())
})

test_that("three levels: the highest level is reported", {
  dat <- dat3
  dat$Zc[c(1L, 50L)] <- NA
  dat$Zi[c(2L, 60L)] <- NA
  ds <- get_data_structure(dat, idvar = c("id", "center"))
  ds$variables <- get_variable_table(dat, ds, c("Zc", "Zi"))

  # Zc is constant within center and within id: only center is reported; Zi
  # varies between the ids of a center: id is reported
  expect_identical(
    find_apparent_levels(dat, ds),
    list(Zc = "center", Zi = "id")
  )
})

test_that("crossed levels", {
  dat <- datx
  dat$B1[1L] <- NA
  ds <- get_data_structure(dat, idvar = c("a", "b"))
  ds$variables <- get_variable_table(dat, ds, "B1")
  expect_identical(find_apparent_levels(dat, ds), list(B1 = "b"))
})

# the warning in the model set-up ----------------------------------------------
test_that("warning with an expression that fills in the values", {
  dat <- dat3
  dat$Zc[c(1L, 50L)] <- NA

  # the expression uses the variable and its grouping variable
  expect_warning(
    lme_imp(
      y ~ Zc + time + (1 | id) + (1 | center),
      data = dat,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE
    ),
    "data[[\"Zc\"]] <- ave(data[[\"Zc\"]], data[[\"center\"]],",
    fixed = TRUE
  )

  # no warning with warn = FALSE
  expect_no_warning(
    lme_imp(
      y ~ Zc + time + (1 | id) + (1 | center),
      data = dat,
      n.adapt = 0,
      n.iter = 0,
      mess = FALSE,
      warn = FALSE
    )
  )
})

test_that("the expression in the warning fills in the missing values", {
  data <- dat3
  data$Zc[c(1L, 50L)] <- NA
  ds <- get_data_structure(data, idvar = c("id", "center"))
  ds$variables <- get_variable_table(data, ds, "Zc")

  # evaluate the last line of the warning
  warning_text <- tryCatch(
    warn_apparent_levels(find_apparent_levels(data, ds)),
    warning = conditionMessage
  )
  fill_in <- trimws(utils::tail(
    strsplit(warning_text, "\n", fixed = TRUE)[[1L]],
    1L
  ))
  eval(parse(text = fill_in))

  # Zc is complete and a variable of center again
  expect_identical(data$Zc, dat3$Zc)
  expect_identical(get_variable_table(data, ds, "Zc")$level, "center")
})
