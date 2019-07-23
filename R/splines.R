#' Penalized B-splines
#'
#' @inheritParams splines::bs
#'
#' @export
ps <- function(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
               Boundary.knots = range(x, na.rm = TRUE)) {

  if (df < (degree + 1))
    stop('The number of degrees of freedom must be larger than the degree of the spline functions.')

  bbase(x, ndx = df - degree, deg = degree)
  # splines::bs(x, df = df, knots = knots, degree = degree, intercept = intercept,
  #             Boundary.knots = Boundary.knots)
}


tpower <- function(x, t, p) {
  # Function for truncated p-th power function
  (x - t) ^ p * (x > t)
}

bbase <- function(x, ndx, deg = 3){
  xl <- min(x, na.rm = TRUE)
  xr <- max(x, na.rm = TRUE)

  # Function for B-spline basis
  dx <- (xr - xl) / ndx
  # knots <- seq(xl - deg * dx, xr + deg * dx, by = dx)
  knots <- get_ps_knots(x, ndx, deg)
  P <- outer(x, knots, tpower, deg)
  D <- diff(diag(length(knots)), diff = deg + 1) / (gamma(deg + 1) * dx ^ deg)
  B <- (-1) ^ (deg + 1) * P %*% t(D)
  attr(B, "degree") <- deg
  attr(B, 'ndx') <- ndx
  attr(B, 'knots') <- knots
  attr(B, 'dx') <- dx
  B
}

get_ps_knots <- function(x, ndx, deg = 3){
  xl <- min(x, na.rm = TRUE)
  xr <- max(x, na.rm = TRUE)
  dx <- (xr - xl) / ndx
  seq(xl - deg * dx, xr + deg * dx, by = dx)
}


get_bs_knots <- function(spB) {
  sort(c(rep(attr(spB, "Boundary.knots"), attr(spB, "degree") + 1),
         attr(spB, 'knots')))
}

# get the difference / distance between knots
get_kndiff <- function(kn) {
  l <- sapply(1:attr(kn, "degree"), function(k) {
    pmax(1e-5, diff(kn, lag = k))
  }, simplify = FALSE)
  names(l) <- paste0("knd", 1:attr(kn, "degree"), "_", attr(kn, "varname"))
  l
}


write_bspline <- function(k, nam, indent, source_mat, source_col, index, nkn) {
  paste0(tab(indent),
         "sB", k, "_", nam, "[", index, ", 1:", nkn - (k + 1), "] <- (",
         source_mat, "[", index, ", ", source_col, "] - kn_", nam, "[1:", nkn - (k + 1), "])/knd", k, "_", nam,
         "[1:", nkn - (k + 1), "] * sB", k - 1, "_", nam, "[", index,
         ", 1:", nkn - (k + 1), "] +", "\n",
         tab(indent + 4 + nchar(nam) + 11 + nchar(nkn - 1)),
         "(kn_", nam, "[", k + 2,
         ":", nkn, "] - ", source_mat, "[", index, ", ", source_col, "])/knd", k, "_", nam,
         "[2:", nkn - k, "] * sB", k - 1, "_", nam, "[", index, ", 2:", nkn - k, "]")
}

bs_JAGS <- function(nam, indent, degree = 3, source_mat, source_col, index, nkn) {
  paste0(
    c(paste0("sB", degree, "_", nam, "[", index, ", 2:", nkn - (degree + 1), "]"),
      paste0(tab(indent), "sB0_", nam, "[", index, ", 1:", nkn - 1, "] <- ifelse(kn_", nam, "[1:", nkn - 1, "] <= ",
             source_mat, "[", index, ", ", source_col, "] && ", source_mat,
             "[", index, ", ", source_col, "] <= kn_", nam, "[2:", nkn, "], 1, 0)"),
      sapply(1:degree, write_bspline, nam = nam, indent = indent,
             source_mat = source_mat, source_col = source_col, index = index, nkn = nkn)
    ), collapse = "\n")
}

ps_JAGS <- function(nam, indent, degree = 3, source_mat, source_col, index, nkn) {
  paste0(
    "sB_", nam, "[", index, ", ]", "\n",
      tab(indent), "sP_", nam, "[i, 1:", nkn, "] <- (", source_mat, "[i, ", source_col,
                   "] - kn_", nam, "[])^", degree, " * (", source_mat, "[i, ",
                   source_col, "] > kn_", nam, "[])", "\n",
      tab(indent), "sB_", nam, "[", index, ", 1:", nkn - degree - 1,
                    "] <- (-1)^(", degree, " + 1) * sP_", nam, "[i, ] %*% t(sD_", nam,")"
    )
}
