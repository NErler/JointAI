
# used in extract_fcts() and make_fctDF() (2020-06-11)
melt_list <- function(l, varname = "L1", valname = NULL) {

  do.call(rbind,
          lapply(seq_along(l), function(k) {
            if (is.vector(l[[k]]) & !is.null(valname))
              df <- as.data.frame(list(l[[k]]), col.names = valname,
                                  stringsAsFactors = FALSE)
            else
              df <- as.data.frame(l[[k]], stringsAsFactors = FALSE)

            df[, varname] <- names(l)[k]
            df
          }))
}


# used in melt_matrix_list(), md_pattern(), traceplot(), densplot(),
#  plot_imp_distr() (2020-06-11)
melt_matrix <- function(X, varnames = NULL, valname = 'value') {

  if (!inherits(X, 'matrix'))
    errormsg("This function may not work for objects that are not matrices.")

  dimnam <- if (is.null(varnames)) {
    if (is.null(names(dimnames(X)))) {
      paste0('V', seq_len(length(dim(X))))
    } else {
      names(dimnames(X))
    }
  } else {varnames}

  g <- lapply(seq_along(dimnam), function(k) {
    if (is.null(dimnames(X)[[k]]))
      seq_len(dim(X)[k])
    else dimnames(X)[[k]]
  })
  names(g) <- dimnam

  out <- expand.grid(g, stringsAsFactors = FALSE)
  out[, valname] <- c(X)

  attr(out, 'out.attrs') <- NULL
  return(out)
}




# used in traceplot() and densplot() (2020-06-10)
melt_matrix_list <- function(X, varnames = NULL) {
  if (!inherits(X, 'list') || !all(sapply(X, inherits, 'matrix')))
    errormsg("This function may not work for objects that are not a list
             of matrices.")

  Xnew <- lapply(X, melt_matrix, varnames = varnames)
  Xnew <- lapply(seq_along(Xnew), function(k) {
    cbind(Xnew[[k]], L1 = k)
  })

  out <- do.call(rbind, Xnew)

  attr(out, 'out.attrs') <- NULL
  return(out)
}


 # used in get_models(), plot_imp_distr(), melt_data.frame_list() (2020-06-10)
melt_data.frame <- function(data, id.vars = NULL, varnames = NULL,
                            valname = 'value') {
  if (!inherits(data, 'data.frame'))
    errormsg("This function may not work for objects that are not data.frames.")

  data$rowID <- paste0('rowID', seq_len(nrow(data)))
  X <- data[, !names(data) %in% c('rowID', id.vars), drop = FALSE]

  g <- list(rowID = data$rowID,
            variable = if (ncol(X) > 0) names(X)
  )

  out <- expand.grid(Filter(Negate(is.null), g), stringsAsFactors = FALSE)

  if (length(unique(sapply(X, class))) > 1) {
    out[, valname] <- unlist(lapply(X, as.character))
  } else {
    out[, valname] <- unlist(X)
  }

  mout <- merge(data[, c("rowID", id.vars)], out)

  attr(mout, 'out.attrs') <- NULL

  if (ncol(X) > 0) mout[order(mout$variable), -1] else mout
}


# used in get_models() and extract_fcts() (2020-06-10)
melt_data.frame_list <- function(X, id.vars = NULL, varnames = NULL,
                                 valname = 'value') {
  if (!inherits(X, 'list') || !all(sapply(X, inherits, 'data.frame') |
                                   sapply(X, inherits, 'NULL')))
    errormsg("This function may not work for objects that are not a
             list of data frames.")

  Xnew <- lapply(X[!sapply(X, is.null)],
                 melt_data.frame, varnames = varnames, id.vars = id.vars)

  if (is.null(names(Xnew)))
    names(Xnew) <- seq_along(Xnew)

  Xnew <- lapply(names(Xnew), function(k) {
    cbind(Xnew[[k]], L1 = k, stringsAsFactors = FALSE)
  })

  out <- do.call(rbind, Xnew)

  attr(out, 'out.attrs') <- NULL
  return(out)
}
