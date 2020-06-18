
# used in divide_matrices() (2020-06-13)
get_scale_pars <- function(mat, groups, scale_vars) {
  # create a list of matrices containing the scaling parameters corresponding
  # to each of the design matrices

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


# used in get_scale_pars() (2020-06-13)
find_scalevars <- function(mat) {
  # Find the names of columns in the model matrix that are not integers
  # or have many different values

  intgr <- apply(mat, 2, function(x) all(na.omit(as.integer(x) == x)))
  lvls <- apply(mat, 2, function(x) length(unique(na.omit(x))))

  return(!intgr | lvls > 20)
}


# re-scale ---------------------------------------------------------------------
rescale <- function(MCMC, coefs, scale_pars, info_list) {
  # After the MCMC has been obtained from rjags, regression coefficients
  # relating to variables that were scaled in the JAGS model need to be scaled
  # back to the scale of the original variables
  # - MCMC: a mcmc object (only one element of the mcmc.list)
  # - coefs: combined coef_list (do.call(rbind, coef_list))
  # - scale_pars: combined scaling parameters
  #               (do.call(rbind, unname(Mlist$scale_pars)))
  # - info_list: list of model info used to create the JAGS syntax; used here
  #              to get the names of the covariates used in each sub-model

  scale_pars$center[is.na(scale_pars$center)] <- 0
  scale_pars$scale[is.na(scale_pars$scale)] <- 1

  sapply(colnames(MCMC), function(k) {
    if (k %in% coefs$coef) {

      # variable name
      varnam <- coefs$varname[which(coefs$coef == k)]

      if (varnam == "(Intercept)") {
        outcome <- coefs$outcome[which(coefs$coef == k)]
        covnames <- names(unlist(unname(info_list[[outcome]]$lp)))
        covnames <- covnames[which(!covnames %in% "(Intercept)")]

        if (length(covnames) > 0) {
          scaled_covs <- sapply(covnames, function(j) {
            MCMC[, coefs$coef[which(j == coefs$varname & outcome == coefs$outcome)],
                 drop = FALSE] * scale_pars[j, 'center']/scale_pars[j, 'scale']
          })

          MCMC[, k] - rowSums(scaled_covs)
        } else {
          MCMC[, k]
        }
      } else {
        # scaling parameters
        sp <- scale_pars[varnam, ]

        MCMC[, k] / sp$scale
      }
    } else {
      MCMC[, k]
    }
  })
}
