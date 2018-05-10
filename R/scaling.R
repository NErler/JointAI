# calculate scaled data matrix
# @param X a matrix
# @param scale_vars a vector of variable names or FALSE
# @param scale_pars a matrix of scaling parameters or FALSE or NULL
# @param meth
# @export

scale_matrix <- function(X, scale_vars, scale_pars, meth) {
  Xsc <- X
  if (!is.null(X)) {
    Xsub <- X[, apply(X, 2, function(x)(any(!is.na(x)))), drop = FALSE]

    if (any(scale_vars %in% colnames(Xsub))) {

      if (is.null(scale_pars)) {
        scale_pars <- matrix(nrow = 2,
                             ncol = length(scale_vars[scale_vars %in% colnames(Xsub)]),
                             dimnames = list(c("scale", "center"),
                                             scale_vars[scale_vars %in% colnames(Xsub)]))
        for (k in scale_vars[scale_vars %in% colnames(Xsub)]) {
          usecenter <- if (!k %in% names(meth)) TRUE else meth[k] != "lognorm"
          xsc <- scale(X[, k], center = usecenter)
          Xsc[, k] <- xsc
          scale_pars["scale", k] <- ifelse(!is.null(attr(xsc, "scaled:scale")),
                                           attr(xsc, "scaled:scale"), 1)
          scale_pars["center", k] <- ifelse(!is.null(attr(xsc, "scaled:center")),
                                            attr(xsc, "scaled:center"), 0)
        }
      } else {
        if (is.matrix(scale_pars)) {
          for (k in colnames(scale_pars)) {
            Xsc[, k] <- (X[, k] - scale_pars["center", k])/scale_pars["scale", k]
          }
        } else stop("Scale matrix could not be recognized.")
      }
    }
  }
  return(list(X = Xsc,
              scale_pars = scale_pars))
}


# function for scaling
# @export
get_scaling <- function(Mlist, scale_pars, meth, data) {
  varnams <- unique(unlist(strsplit(colnames(model.matrix(Mlist$fixed2, data)),
                                    "[:|*]")))
  scale_pars_new <- if (!is.null(Mlist$scale_vars))
    matrix(nrow = 2, ncol = length(varnams),
           data = c(1, 0),
           dimnames = list(c("scale", "center"),
                           varnams))


  scaled_dat <- sapply(Mlist[c("Xc", "Xtrafo", "Xl", "Z")], scale_matrix,
                       scale_vars = Mlist$scale_vars,
                       scale_pars = scale_pars,
                       meth = meth, simplify = FALSE)


  scale_pars <- do.call(cbind, lapply(scaled_dat, "[[", 2))

  # remove identical duplicate columns
  dupl <- lapply(unique(colnames(scale_pars)), function(x) {
    t(unique(t(scale_pars[, which(colnames(scale_pars) == x), drop = FALSE])))
  })

  if (any(sapply(dupl, ncol) > 1)) {
    stop("Duplicate scale parameters found.")
  } else {
    scale_pars <- do.call(cbind, dupl)
  }

  if (!is.null(scale_pars) & !is.null(scale_pars_new)) {
    if (!any(colnames(scale_pars) %in% colnames(scale_pars_new)))
      stop("Scale parameters could not be matched to variables.")

    scale_pars_new[c("scale", "center"), colnames(scale_pars)] <-
      scale_pars[c("scale", "center"), ]
  } else {scale_pars_new <- NULL}

  if (any(Mlist$trafos$fct == paste0(Mlist$trafos$var, "^2"))) {
    sqrs <- which(Mlist$trafos$fct == paste0(Mlist$trafos$var, "^2"))
    xvars <- Mlist$trafos$var[sqrs]
    xsqr <- Mlist$trafos$Xc_var[sqrs]
    scale_pars_new[, xsqr] <- scale_pars_new[, xvars]^2
    scale_pars_new["center", xsqr] <- -scale_pars_new["center", xsqr]
  }

  return(list(scaled_matrices = sapply(scaled_dat, "[[", 1, simplify = FALSE),
              scale_pars = scale_pars_new))
}
