#' Melt a list of atomic vectors to a data.frame
#'
#' This function takes a list of atomic vectors and returns a melted
#' `data.frame`.
#'
#' @param l a `list` of atomic vectors
#' @param varname the name of the variable that will hold the names of the
#'                original list elements
#' @param valname the name of the variable that will hold the values of the
#'                original data frames; default is "value"
#' @return a melted `data.frame`
#'
#' @keywords internal
#' @noRd
#' @examples
#' melt_list(list(data.frame(a = 1:3), data.frame(b = 4:9)))

melt_list <- function(l, varname = "L1", valname = "value") {
  if (!inherits(l, "list")) {
    errormsg("In melt_list(): The input has to be a list.")
  }


  if (any(lapply(l, length) == 0)) {
    warnmsg(
      "In melt_list(): Element(s) %s has/have length zero.
             I will ignore this.",
      paste_and(names(Filter(\(x) length(x) == 0, x = l)),
                dQ = TRUE
      )
    )
    l <- Filter(Negate(\(x) length(x) == 0), l)
  }

  # Check for elements that cannot be converted to a data.frame or would
  # result in differing numbers of columns e.g., formulas, arrays, lists, ...
  if (any(lvapply(l, \(x) !is.atomic(x) | !is.vector(x)))) {
    errormsg(
      "In melt_list(): Not all elements are atomic vectors (%s).",
      paste_and(names(Filter(\(x) !is.atomic(x) | !is.vector(x), l)),
                dQ = TRUE
      )
    )
  }

  do.call(
    rbind,
    lapply(seq_along(l), function(k) {
      df <- as.data.frame(list(l[[k]]),
                          col.names = valname,
                          stringsAsFactors = FALSE
      )

      df[, varname] <- names(l)[k]
      df
    })
  )
}



#' Melt a `matrix` into a `data.frame`
#'
#' This function takes a `matrix` and returns a melted `data.frame`.
#'
#' @param x a `matrix`
#' @param varnames a character vector of length two giving the names of the
#'                 variables that will hold the row and column indices or names
#'                 of the original matrix;
#'                 optional (otherwise a default will be created)
#' @param valname the name of the variable that will hold the values of the
#'                original matrix; default is "value"
#' @return a melted `data.frame`
#'
#' @keywords internal
#' @noRd

melt_matrix <- function(x, varnames = NULL, valname = "value") {

  if (!inherits(x, "matrix")) {
    errormsg("In melt_matrix():
             This function has to be used with matrices.")
  }

  # if no varnames are given, use the names of the dimension names of x
  # (if present) or create variable names of the format v[[:digit:]]
  dimnam <- if (is.null(varnames)) {
    if (is.null(names(dimnames(x)))) {
      paste0("V", seq_len(length(dim(x))))
    } else {
      names(dimnames(x))
    }
  } else {
    varnames
  }

  # create a named list of the dimension names of x
  g <- lapply(seq_along(dimnam), function(k) {
    if (is.null(dimnames(x)[[k]])) {
      seq_len(dim(x)[k])
    } else {
      dimnames(x)[[k]]
    }
  })
  names(g) <- dimnam

  out <- expand.grid(g, stringsAsFactors = FALSE)
  out[, valname] <- c(x)

  out
  # attr(out, "out.attrs") <- NULL
  # return(out)
}




#' Melt a list of matrices into a `data.frame`
#'
#'
#' @param l a `list` of matrices
#' @param varnames a character vector of length two giving the names of the
#'                 variables that will hold the row and column indices or names
#'                 of the original matrices;
#'                 optional (otherwise a default will be created)
#' @return a melted `data.frame`
#'
#' @keywords internal
#' @noRd

melt_matrix_list <- function(l, varnames = NULL) {
  if (!inherits(l, "list") || !all(sapply(l, inherits, "matrix"))) {
    errormsg("This function may not work for objects that are not a list
             of matrices.")
  }


  if (is.null(varnames) &&
      length(unique(lapply(l, \(x) names(dimnames(x))))) > 1L) {
    errormsg("In melt_matrix_list(): When the argument %s is not provided,
             all matrices must have the same names of their %s.",
             dQuote("varnames"), dQuote("dimnames"))
  }

  if (is.null(names(l))) {
    names(l) <- seq_along(l)
  }

  # Melt each element of l separately and add the "L1" column to indicate the
  # element index
  lnew <- lapply(names(l), \(k) {
    cbind(melt_matrix(l[[k]], varnames = varnames), L1 = k)
  })


  # check if there are differences in variable classes between data.frames
  types <- ivapply(names(lnew[[1]]), function(n) {
    length(unique(lapply(lnew, \(m) class(m[[n]]))))
  })

  # if there are any differences in variable classes, convert those variables
  # to characters to prevent issues with rbind()
  if (any(types > 1)) {
    lnew <- lapply(lnew, \(x) {
      x[which(types > 1)] <- lapply(x[which(types > 1)], as.character)
      x
    })
  }

  do.call(rbind, lnew)

  # out <- do.call(rbind, lnew)
  # attr(out, "out.attrs") <- NULL
  # return(out)
}


#' Melt a `data.frame`
#'
#' This function takes a `data.frame` and returns a melted `data.frame`.
#'
#' @param data a `data.frame`
#' @param id_vars optional vector of names of variables that should not be
#'                melted
#' @param varnames a character vector of length two giving the names of the
#'                 variables that will hold the row and column indices or names
#'                 of the original matrix;
#'                 optional (otherwise a default will be created)
#' @param valname the name of the variable that will hold the values of the
#'                original matrix; default is "value"
#' @return a melted `data.frame`
#'
#' @keywords internal
#' @noRd

melt_data_frame <- function(data, id_vars = NULL, varname = NULL,
                            valname = "value") {
  if (!inherits(data, "data.frame")) {
    errormsg("In melt_data_frame:
             This function requires a data.frame as input.")
  }

  if (setequal(id_vars, names(data))) {
    return(data)
  }

  data$rowID <- paste0("rowID", seq_len(nrow(data)))
  x <- data[, !names(data) %in% c("rowID", id_vars), drop = FALSE]

  g <- list(
    rowID = data$rowID,
    variable = if (ncol(x) > 0) names(x)
  )

  out <- expand.grid(Filter(Negate(is.null), g), stringsAsFactors = FALSE)

  if (length(unique(sapply(x, class))) > 1) {
    out[, valname] <- unlist(lapply(x, as.character))
  } else {
    out[, valname] <- unlist(x)
  }

  mout <- merge(data[, c("rowID", id_vars)], out)

  # attr(mout, "out.attrs") <- NULL

  if (ncol(x) > 0) mout[order(mout$variable), -1] else mout
}


# used in get_models() and extract_fcts() (2020-06-10)
melt_data_frame_list <- function(l, id_vars = NULL, varname = NULL,
                                 valname = "value", lname = "L1") {
  if (!inherits(l, "list") || !all(sapply(l, inherits, "data.frame") |
    sapply(l, inherits, "NULL"))) {
    errormsg("This function may not work for objects that are not a
             list of data frames.")
  }

  lnew <- lapply(l[!sapply(l, is.null)],
    melt_data_frame,
    varname = varname, id_vars = id_vars
  )

  if (is.null(names(lnew))) {
    names(lnew) <- seq_along(lnew)
  }

  lnew <- lapply(names(lnew), function(k) {
    lnew[[k]][[lname]] <- k
    lnew[[k]]
    # cbind(lnew[[k]], L1 = k, stringsAsFactors = FALSE)
  })

  do.call(rbind, lnew)

  # out <- do.call(rbind, lnew)
  # attr(out, "out.attrs") <- NULL
  # return(out)
}
