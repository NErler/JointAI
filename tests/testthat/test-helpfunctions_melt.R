


test_that("melt_list() works as expected", {
  # Test that melt_list() throws an error if input is not a list
  expect_error(melt_list(1))

  # Test that melt_list() ignores elements with length zero
  l <- list(a = c(1, 2), b = character(0))
  expect_equal(nrow(melt_list(l)), 2)

  # Test that melt_list() throws an error if not all elements are atomic vectors
  l <- list(formula = y ~ b,
            list = list(1:4, 3:5),
            array = array(1:12, dim = c(3, 2, 2)),
            expression = expression("something")
  )

  for (k in seq_along(l)) {
    expect_error(melt_list(l[k]))
  }

  # Test that melt_list() returns correct output for a simple case
  l <- list(a = c(1, 2), b = c(3, 4))
  expect_equal(nrow(melt_list(l)), 4)

  # Test that melt_list() returns correct output for a more complex case
  l <- list(a = 1:5, b = LETTERS[1:7], d = NA, e = NaN, f = -Inf)
  expect_equal(nrow(melt_list(l)), 15)
  expect_s3_class(melt_list(l), "data.frame")

  # default column names
  expect_equal(names(melt_list(l)), c("value", "L1"))

  # custom column names
  expect_equal(names(melt_list(l, varname = "the_variable",
                               valname = "the_value")),
               c("the_value", "the_variable"))

  # output for unnamed list has one column
  expect_equal(ncol(melt_list(unname(l))), 1)
  # output for partially unnamed list has two columns
  expect_equal(ncol(melt_list(c(unname(l), list(x = 1:4)))), 2)
})




test_that("melt_matrix() works as expected", {
  # Test that melt_matrix() returns an error when the input is not a matrix
  expect_error(melt_matrix(1:5))
  expect_error(melt_matrix(list(1:5)))
  expect_error(melt_matrix(NULL))
  expect_error(melt_matrix(NA))
  expect_error(melt_matrix(list(matrix())))
  expect_error(melt_matrix(data.frame()))


  # Test that melt_matrix() returns a data.frame for an empty matrix
  expect_s3_class(melt_matrix(matrix()), "data.frame")
  expect_equal(nrow(melt_matrix(matrix())), 1)


  # Test that melt_matrix() returns correct output
  m <- matrix(1:16, nrow = 4, ncol = 4)
  expect_s3_class(melt_matrix(m), "data.frame")
  expect_equal(dim(melt_matrix(m)), c(16, 3))

  expect_equal(names(melt_matrix(m)), c("V1", "V2", "value"))

  expect_equal(names(melt_matrix(m,
                                 varnames = c("abc", "def"),
                                 valname = "thevalue")),
               c("abc", "def", "thevalue")
  )

  # if there are no dimnames all output variables are integers
  expect_equal(sapply(melt_matrix(m), class),
               c("integer", "integer", "integer"),
               ignore_attr = TRUE)


  # set dimension names
  m2 <- m
  dimnames(m2) <- list(LETTERS[1:4],
                       letters[1:4])

  expect_equal(names(melt_matrix(m2)), c("V1", "V2", "value"))

  # if there are dimnames, the row and column indicator variables are character
  # strings
  expect_equal(sapply(melt_matrix(m2), class),
               c("character", "character", "integer"),
               ignore_attr = TRUE)

  m3 <- m2
  names(dimnames(m3)) <- c("rows", "cols")

  expect_equal(names(melt_matrix(m3)), c("rows", "cols", "value"))
})



test_that("melt_matrix_list() works as expected", {

  m <- m2 <- matrix(1:15, nrow = 5, ncol = 3)

  dimnames(m2) <- list(LETTERS[1:5],
                       letters[1:3])

  m3 <- m2
  names(dimnames(m3)) <- c("rows", "cols")


  # Test that melt_matrix_list() throws an error for objects of the wrong type
  expect_error(melt_matrix_list(m))
  expect_error(melt_matrix_list(list(1:3, m)))


  # Test that melt_matrix_list() throws an error for mismatching dimension names
  expect_error(melt_matrix_list(list(m, m3)))
  expect_error(melt_matrix_list(list(m2, m3)))
  expect_error(melt_matrix_list(list(m, m2, m3)))

  # Test that melt_matrix_list() returns correct output
  expect_s3_class(melt_matrix_list(list(m, m2)), "data.frame")
  expect_s3_class(melt_matrix_list(list(m, m3),
                                   varnames = c("abc", "def")), "data.frame")

  # correct dimensions
  expect_equal(dim(melt_matrix_list(list(m, m2))), c(30, 4))
  expect_equal(names(melt_matrix_list(list(m, m2))),
               c("V1", "V2", "value", "L1"))

  expect_equal(names(melt_matrix_list(list(m, m2),
                                      varnames = c("abc", "def"))),
               c("abc", "def", "value", "L1"))


  expect_equal(sapply(melt_matrix_list(list(m, m2)), class),
               c("character", "character", "integer", "character"),
               ignore_attr = TRUE)


  expect_equal(sapply(melt_matrix_list(list(M1 = m, M2 = m2)), class),
               c("character", "character", "integer", "character"),
               ignore_attr = TRUE)

})



test_that("melt_data_frame() works as expected", {

  # Test that melt_data_frame() throws an error for non-data.frame objects
  expect_error(melt_data_frame(1:4))
  expect_error(melt_data_frame(list(1:4)))
  expect_error(melt_data_frame(NULL))
  expect_error(melt_data_frame(NA))
  expect_error(melt_data_frame(matrix(2, 2, 0)))


  # Test that melt_data_frame() works as expected for regular data.frame's
  d <- data.frame(x = 1:5, id = LETTERS[1:5],
                  y = c(NA, rnorm(4)),
                  z = factor(sample(letters[1:3], 5, replace = TRUE))
  )

  expect_s3_class(melt_data_frame(d), "data.frame")
  expect_equal(dim(melt_data_frame(d)),
               c(nrow(d) * ncol(d), 2))

  expect_equal(dim(melt_data_frame(d, id_vars = "id")),
               c(nrow(d) * (ncol(d) - 1), 2 + 1))

  expect_equal(dim(melt_data_frame(d, id_vars = c("id", "x"))),
               c(nrow(d) * (ncol(d) - 2), 2 + 2))


  # Test that melt_data_frame() works as expected for irregular data.frame's
  d <- data.frame(id = LETTERS[1:5],
                  y = c(NA, rnorm(4)),
                  z = factor(NA, levels = 1:5)
  )
  d$x <- replicate(5, rnorm(2), simplify = FALSE)


  expect_s3_class(melt_data_frame(d), "data.frame")
  expect_equal(names(melt_data_frame(d)), c("variable", "value"))
  expect_equal(names(melt_data_frame(d, varname = "thevariable",
                                     valname = "thevalue")),
               c("thevariable", "thevalue"))


  # expect an error when data contain an array variable
  d$x2 <- matrix(nrow = 5, ncol = 3, data = 0)
  expect_error(melt_data_frame(d, id_vars = "id"))
  expect_error(melt_data_frame(d, id_vars = c("id", "x2")))

})
