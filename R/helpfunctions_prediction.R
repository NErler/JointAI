

calc_lp <- function(design_mat, regcoefs, scale_pars) {
  # calculate the linear predictor from a design matrix and matrix of MCMC samples
  # of the regression coefficients, taking into account that for a model without
  # intercept the centering of the design matrix needs to be taken into account

  sapply(seq_len(nrow(design_mat)), function(i) {

    if (!is.null(scale_pars)) {
      centers <- scale_pars$center[match(colnames(design_mat),
                                         rownames(scale_pars))]
      regcoefs %*% (design_mat[i, ] - centers)
    } else {
      regcoefs %*% design_mat[i, ]
    }
  })
}


minmax_mat <- function(mat, minval = 1e-10, maxval = 1 - 1e-10) {
  apply(mat, 2, function(x) {
    pmax(minval, pmin(maxval, x))
  })
}
