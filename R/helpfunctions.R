# Check if a variable is time-varying ------------------------------------------
#' Check if a variable is time-varying
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @keywords internal
#' @return a logical value
check_tvar <- function(x, idvar) {
  !all(sapply(split(x, idvar),
              function(z) all(z == z[1], na.rm = TRUE)
  ))
}


# Find the position(s) of a variable in a model matrix -------------------------
match_positions <- function(varname, DF, colnams) {
  XX <- model.matrix(formula(paste("~", varname)), DF)[, -1L, drop = FALSE]
  matches <- match(colnames(XX), colnams)
  names(matches) <- colnams[matches]

  return(if (any(!is.na(matches))) matches)
}






# Generate pattern (used in get_hc_list) ---------------------------------------
gen_pat <- function(nam) {
  nam <- gsub("^", "\\^", nam, fixed = TRUE)
  glob2rx(c(nam,
            paste0("*:", nam),
            paste0(nam, ":*")), trim.head = TRUE)
}

# Find names in a vector of names (used in get_hc_list) ------------------------
grep_names <- function(nams1, nams2){
  res <- unique(unlist(sapply(nams1, grep, nams2, value = TRUE, simplify = FALSE)))
  if (length(res) > 0) res
}




melt_matrix <- function(X, varnames = NULL, valname = 'value') {
  if (!inherits(X, 'matrix'))
    stop("This function may not work for objects that are not matrices.")

  dimnam <- if (is.null(varnames)) {
    if (is.null(names(dimnames(X)))) {
      paste0('V', 1:length(dim(X)))
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

melt_matrix_list <- function(X, varnames = NULL) {
  if (!inherits(X, 'list') || !all(sapply(X, inherits, 'matrix')))
    stop("This function may not work for objects that are not a list of matrices.")

  Xnew <- lapply(X, melt_matrix, varnames = varnames)
  Xnew <- lapply(seq_along(Xnew), function(k) {
    cbind(Xnew[[k]], L1 = k)
  })

  out <- do.call(rbind, Xnew)

  attr(out, 'out.attrs') <- NULL
  return(out)
}


melt_data.frame <- function(data, id.vars = NULL, varnames = NULL, valname = 'value') {
  if (!inherits(data, 'data.frame'))
    stop("This function may not work for objects that are not data.frames.")

  data$rowID <- paste0('rowID', 1:nrow(data))
  X <- data[, !names(data) %in% c('rowID', id.vars)]

  g <- list(rowID = data$rowID,
            variable = names(X)
  )

  out <- expand.grid(g, stringsAsFactors = FALSE)

  if (length(unique(sapply(X, class))) > 1) {
    out[, valname] <- unlist(lapply(X, as.character))
  } else {
    out[, valname] <- unlist(X)
  }

  mout <- merge(data[, c("rowID", id.vars)], out)

  attr(mout, 'out.attrs') <- NULL
  return(mout[order(mout$variable), -1])
}





sort_cols <- function(mat, fct_all, auxvars) {
  istrafo <- ifelse(colnames(mat) %in% fct_all$X_var[fct_all$type != 'identity'], 'fct', 'main')
  names(istrafo) <- colnames(mat)

  hasmain <- sapply(colnames(mat), function(k) {
    if (istrafo[k] == 'main') 'asmain'
    else {
      if (any(fct_all$var[fct_all$X_var == k] %in% colnames(mat))) {
        if (k %in% if (!is.null(auxvars)) attr(terms(auxvars), 'term.labels')) {
          TRUE
        } else {
          FALSE
        }
      } else {
        'asmain'
      }
    }
  })



  l <- split(colnames(mat), hasmain)
  l <- lapply(l, function(x)
    x[order(colSums(is.na(mat[, x, drop = FALSE])))]
  )
  out <- unlist(l[c('asmain', 'FALSE')])

  if (any(hasmain == TRUE)) {
    for (k in names(hasmain[hasmain == TRUE])) {
      out <- append(out, k, after = max(match(fct_all$var[fct_all$X_var == k], out)))
    }
  }

  if (length(setdiff(colnames(mat), out)) > 0) {
    stop('Some columns were lost!')
  }
  out
}



print_seq <- function(min, max) {
  if (min == max)
    max
  else
    paste0(min, ":", max)
}



add_breaks <- function(string) {
  m <- gregexpr(", ", string)[[1]]
  br <- ifelse(c(0, diff(as.numeric(m) %/% getOption('width'))) > 0, "\n", "")
  gsub("\n, ", ",\n  ", paste0(strsplit(string, ", ")[[1]], br, collapse = ", "))
}


clean_names <- function(string) {
  gsub(":", "_", string)
}


gauss_kronrod <- function() {
  m <- matrix(nrow = 15, ncol = 2, byrow = TRUE,
              data = c(-0.9914553711208126392069,	0.0229353220105292249637,
                       -0.9491079123427585245262,	0.0630920926299785532907,
                       -0.8648644233597690727897,	0.1047900103222501838399,
                       -0.7415311855993944398639,	0.140653259715525918745,
                       -0.5860872354676911302941,	0.1690047266392679028266,
                       -0.4058451513773971669066,	0.1903505780647854099133,
                       -0.2077849550078984676007,	0.2044329400752988924142,
                       0,	0.209482141084727828013,
                       0.2077849550078984676007,	0.2044329400752988924142,
                       0.4058451513773971669066,	0.190350578064785409913,
                       0.5860872354676911302941,	0.1690047266392679028266,
                       0.7415311855993944398639,	0.1406532597155259187452,
                       0.8648644233597690727897,	0.10479001032225018384,
                       0.9491079123427585245262,	0.0630920926299785532907,
                       0.9914553711208126392069,	0.02293532201052922496373))
  return(list(gkx = m[, 1], gkw = m[, 2]))
}


get_knots_h0 <- function(nkn, Time, event, gkx, obs_kn = TRUE) {
  pp <- seq(0, 1, length.out = nkn + 2)
  pp <- tail(head(pp, -1), -1) # remove first and last
  tt <- if (obs_kn) { # use only event times or all times
    Time
  } else {
    Time[event == 1]
  }
  kn <- quantile(tt, pp, names = FALSE)

  kn <- kn[kn < max(Time)]
  sort(c(rep(range(Time, outer(Time/2, gkx + 1)), 4), kn))
}
