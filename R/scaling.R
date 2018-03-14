# calculate scaled data matrix
# @param X a matrix
# @param scale_vars a vector of variable names or FALSE
# @param scale_pars a matrix of scaling parameters or FALSE or NULL
# @param meth
# @export

scale_matrix <- function(X, scale_vars, scale_pars, meth) {
  Xsc <- X
  if (!is.null(X) & any(scale_vars %in% colnames(X))) {

    if (is.null(scale_pars)) {
      scale_pars <- matrix(nrow = 2,
                           ncol = length(scale_vars[scale_vars %in% colnames(X)]),
                           dimnames = list(c("scale", "center"),
                                           scale_vars[scale_vars %in% colnames(X)]))
      for (k in scale_vars[scale_vars %in% colnames(X)]) {
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
  return(list(X = Xsc,
              scale_pars = scale_pars))
}


# function for scaling
# @export
get_scaling <- function(Mlist, scale_pars, meth, data) {
  varnams <- unique(unlist(strsplit(colnames(model.matrix(Mlist$fixed2, data)),
                                    "[:|*]")))
  scale_pars_new <- matrix(nrow = 2, ncol = length(varnams),
                           data = c(1, 0),
                           dimnames = list(c("scale", "center"),
                                           varnams))


  scaled_dat <- sapply(Mlist[c("Xc", "Xl", "Z")], scale_matrix,
                       scale_vars = Mlist$scale_vars,
                       scale_pars = scale_pars,
                       meth = meth, simplify = F)


  scale_pars <- do.call(cbind, sapply(scaled_dat, "[[", 2))
  if (any(duplicated(colnames(scale_pars))))
    stop("Duplicate scale parameters found.")

  if (!any(colnames(scale_pars) %in% colnames(scale_pars_new)))
    stop("Scale parameters could not be matched to variables.")

  scale_pars_new[c("scale", "center"), colnames(scale_pars)] <-
    scale_pars[c("scale", "center"), ]

  return(list(scaled_matrices = sapply(scaled_dat, "[[", 1, simplify = F),
              scale_pars = scale_pars_new))
}
