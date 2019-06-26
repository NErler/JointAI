#' Penalized B-splines
#'
#' @export
ps <- function(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
               Boundary.knots = range(x, na.rm = TRUE)) {
  splines::bs(x, df = df, knots = knots, degree = degree, intercept = intercept,
              Boundary.knots = Boundary.knots)
}


get_knots <- function(spB) {
  sort(c(rep(attr(spB, "Boundary.knots"), attr(spB, "degree") + 1),
         attr(spB, 'knots')))
}

# get the difference / distance between knots
get_kndiff <- function(kn) {
  l <- sapply(1:attr(kn, "degree"), function(k) {
    pmax(1e-5, diff(kn, lag = k))
  })
  names(l) <- paste0("knd", 1:attr(kn, "degree"), "_", attr(kn, "varname"))
  l
}


write_pspline <- function(k, nam, indent, source_mat, source_col, index, nkn) {
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

ps_JAGS <- function(nam, indent, degree = 3, source_mat, source_col, index, nkn) { #dest_mat, dest_cols,
  paste0(
    c(paste0("sB", degree, "_", nam, "[", index, ", 2:", nkn - (degree + 1), "]"),
      paste0(tab(indent), "sB0_", nam, "[", index, ", 1:", nkn - 1, "] <- ifelse(kn_", nam, "[1:", nkn - 1, "] <= ",
             source_mat, "[", index, ", ", source_col, "] && ", source_mat,
             "[", index, ", ", source_col, "] <= kn_", nam, "[2:", nkn, "], 1, 0)"),
      sapply(1:degree, write_pspline, nam = nam, indent = indent,
             source_mat = source_mat, source_col = source_col, index = index, nkn = nkn)
      # paste0(tab(indent),
      #        dest_mat, "[", index, ", ", paste0(range(9:11), collapse = ":"),
      #        "] <- sB", degree, "_", nam, "[", index, ", 2:", nkn - (degree + 1), "]")
    ), collapse = "\n")
}

#
# cat(ps_JAGS(degree = 3, 'age', indent = 4, #dest_mat = "Xc", dest_cols = 9:11,
#             source_mat = "Xtrafo", source_col = 1, index = 'i', nkn = length(kn_age)))
#
#
# kn_age <- get_knots(x, df = 5) ######################### in data_list
# knd_age <- get_kndiff(kn_age, 3, 'age') ########################### in data_list


# DDal <- diag(df) ####### in data_list
# priorTau <- crossprod(diff(DDal, diff = 2)) + 1e-06 * DDal ########## in data_list
