# Penalized B-splines
#
# @inheritParams splines::bs
#
# @export
# ps <- function(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
#                Boundary.knots = range(x, na.rm = TRUE)) {
#
#   if (df < (degree + 1))
#     errormsg('The number of degrees of freedom must be larger than the degree
#              of the spline functions.')
#
#   bbase(x, ndx = df - degree, deg = degree)
# }


# B-splines
#
# @inheritParams splines::bs
#
# @export
# bs <- function(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
#                Boundary.knots = range(x, na.rm = TRUE)) {
#
#   if (df < (degree + 1))
#     errormsg('The number of degrees of freedom must be larger than the degree
#              of the spline functions.')
#
#   bbase(x, ndx = df - degree, deg = degree)
# }

#
# bbase <- function(x, ndx, deg = 3){
#   xl <- min(x, na.rm = TRUE)
#   xr <- max(x, na.rm = TRUE)
#
#   # Function for B-spline basis
#   dx <- (xr - xl) / ndx
#   # knots <- seq(xl - deg * dx, xr + deg * dx, by = dx)
#   knots <- get_ps_knots(x, ndx, deg)
#   P <- outer(x, knots, tpower, deg)
#   D <- diff(diag(length(knots)), diff = deg + 1) / (gamma(deg + 1) * dx ^ deg)
#   B <- (-1) ^ (deg + 1) * P %*% t(D)
#   attr(B, "degree") <- deg
#   attr(B, 'ndx') <- ndx
#   attr(B, 'knots') <- knots
#   attr(B, 'dx') <- dx
#   B
# }
#
#
#
# tpower <- function(x, t, p) {
#   # Function for truncated p-th power function
#   (x - t) ^ p * (x > t)
# }
#
#
# get_ps_knots <- function(x, ndx, deg = 3){
#   xl <- min(x, na.rm = TRUE)
#   xr <- max(x, na.rm = TRUE)
#   dx <- (xr - xl) / ndx
#   seq(xl - deg * dx, xr + deg * dx, by = dx)
# }
#
#
# splineBas <- function(nam, degree = 3, index, nkn) {
#   paste0(
#     "sB_", nam, "[", index, ", ]", "\n",
#     tab(4), "sP_", nam, "[", index, ", 1:", nkn, "] <- (", nam, " - kn_", nam,
#     "[])^", degree, " * (", nam, " > kn_", nam, "[])", "\n",
#     tab(4), "sB_", nam, "[", index, ", 1:", nkn - degree - 1,
#     "] <- (-1)^(", degree, " + 1) * sP_", nam, "[i, ] %*% t(sD_", nam,")"
#   )
# }
#
