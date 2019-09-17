context("help functions")
library("JointAI")
library("survival")

test_that('extract_id works', {
  runs <- list(list(random = ~ 1 | id, ids = 'id'),
               list(random = ~ 0 | id, ids = 'id'),
               list(random = NULL, ids = NULL),
               list(random = y ~ time | id, ids = 'id'),
               list(random =  ~ a | id/class, ids = c('id', 'class')),
               list(random = ~ a | id + class, ids = c('id', 'class')),
               list(random = list(~a | id, ~ b | id2), ids = c('id', 'id2'))
  )

  for (i in seq_along(runs)) {
    expect_equal(extract_id(runs[[i]]$random), runs[[i]]$ids)
  }
})


test_that('extract_id results in error', {
  err <- list(
    "text",
    NA,
    TRUE,
    mean
  )

  for (i in seq_along(err)) {
    expect_error(extract_id(err[[i]]))
  }
})


test_that('extract_id results in warning', {
  rd_warn <- list(~1,
                  ~a + b + c,
                  y ~ a + b + c
  )

  for (i in seq_along(rd_warn)) {
    expect_warning(extract_id(rd_warn[[i]]))
  }
})



test_that('extract_outcome works', {
  ys <- list(list(fixed = y ~ a + b, out = 'y'),
             list(fixed = y ~ 1, out = 'y'),
             list(fixed = Surv(a, b) ~ 1, out = c('a', 'b')),
             list(fixed = Surv(a, b, d) ~ x + z, out = c('a', 'b', 'd')),
             list(fixed = cbind(a, b, d) ~ x + z, out = c('a', 'b', 'd'))
             # list(fixed = y + x ~ a + b, out = c("y + x"))
  )

  for (i in seq_along(ys)) {
    expect_equal(extract_outcome(ys[[i]]$fixed), ys[[i]]$out)
  }
})

# f1 <- Surv(time, status) ~ sex + age
# f2 <- cbind(time, status) ~ sex + age
# f3 <- I(time + age) ~ sex
# f4 <- cbind(age, I(time + age)) ~ sex
#
# out1 <- f1[2]
# out2 <- f2[2]
# out3 <- f3[2]
# out4 <- f4[2]
#
#
# head(as.matrix(with(lung, eval(as.list(out1)[[1]]))))
# head(as.matrix(with(lung, eval(as.list(out3)[[1]]))))
# head(as.matrix(with(lung, eval(as.list(out4)[[1]]))))
#
# gn(paste(out1)[1])
# gn(paste(out2)[1])
# gn(paste(out3)[1])
# gn(paste(out4)[1])
#
# gn <- function(x) {
#   n <- strsplit(substr(x,
#                   min(gregexpr(pattern = "\\(", x)[[1]]) + 1,
#                   max(gregexpr(pattern = "\\)", x)[[1]]) - 1
#   ), ',')[[1]]
#   gsub("^ | $", '', n)
# }



#
# test_that('extract_outcome gives error', {
#   ys <- list(y + x ~ a + b
#   )
#
#   for (i in seq_along(ys)) {
#     expect_equal(extract_outcome(ys[[i]]$fixed), ys[[i]]$out)
#   }
# })
