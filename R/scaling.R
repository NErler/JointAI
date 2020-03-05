
# Function to find the names of columns in the model matrix that are not integers
# or have many different values
find_scalevars <- function(mat) {

  intgr <- apply(mat, 2, function(x) all(na.omit(as.integer(x) == x)))
  lvls <- apply(mat, 2, function(x) length(unique(na.omit(x))))

  return(!intgr | lvls > 20)
}


get_scale_pars <- function(mat, groups, scale_vars) {

  if (is.null(mat) | (!is.null(scale_vars) && !scale_vars))
    return(NULL)

  vars <- find_scalevars(mat)

  if (!is.null(scale_vars))
    vars[vars %in% scale_vars]


  do.call(rbind, sapply(names(vars), function(k) {

    rows <- match(unique(groups), groups)

    if (vars[k]) {
      scaled <- scale(mat[rows, k])
      data.frame(center = attr(scaled, 'scaled:center'),
                 scale = attr(scaled, 'scaled:scale')
      )
    } else {
      data.frame(center = NA, scale = NA)
    }
  }, simplify = FALSE))
}



