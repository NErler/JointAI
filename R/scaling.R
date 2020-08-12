
# used in divide_matrices() (2020-06-13)
get_scale_pars <- function(mat, groups, scale_vars, refs, fcts_all,
                           interactions, data) {
  # create a list of matrices containing the scaling parameters corresponding
  # to each of the design matrices

  if (is.null(mat) | (!is.null(scale_vars) && !scale_vars))
    return(NULL)

  vars <- find_scalevars(mat, refs, fcts_all, interactions, data)

  if (!is.null(scale_vars))
    vars <- intersect(vars, scale_vars)

  rows <- match(unique(groups), groups)

  do.call(rbind, sapply(colnames(mat), function(k) {
    if (k %in% vars) {
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
find_scalevars <- function(mat, refs, fcts_all, interactions, data) {
  # Find the names of columns in the model matrix that are not integers
  # or have many different values

  vars <- lapply(colnames(mat), function(k) {

    k <- replace_dummy(k, refs)

    if (k %in% names(data)) {
      if (is.numeric(data[, k])) k
    } else if (k %in% fcts_all$colname) {
      # When splines are used, "k" can't be evaluated, so we use the column
      # 'fct' instead. The result of "eval" for splines is then a matrix,
      # but since this is also numeric the test "is.numeric()" works.
      # This might not work though for some other functions....
      fct <- unique(fcts_all$fct[fcts_all$colname == k])
      if (is.numeric(eval(parse(text = fct), envir = data))) k
    } else if (k %in% names(interactions)) {
      elmts <- sapply(attr(interactions[[k]], 'elements'), replace_dummy, refs)

      isnum <- sapply(elmts, function(x) {
        if (x %in% names(data)) {
          is.numeric(data[, x])
        } else {
          if (x %in% fcts_all$colname) {
            fct <- unique(fcts_all$fct[fcts_all$colname == x])
            is.numeric(eval(parse(text = fct), envir = data))
          }
        }
      })
      if (any(isnum)) k
    }
  })

  unlist(vars)
}


# re-scale ---------------------------------------------------------------------
rescale <- function(MCMC, coefs, scale_pars, info_list, data_list, groups) {
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

  MCMC <- sapply(colnames(MCMC), function(k) {
    if (k %in% coefs$coef) {

      # variable name
      varnam <- coefs$varname[which(coefs$coef == k)]

      if (varnam == "(Intercept)") {
        outcome <- coefs$outcome[which(coefs$coef == k)]
        k_nr <- gsub("[[:alpha:]]+\\[*|\\]*", "", k)

        parelmts <- info_list[[outcome]]$parelmts

        parelmts <- if (any(sapply(parelmts, is.list))) {
          lapply(1:max(sapply(parelmts, length)), function(j) {
            pe <- unlist(unname(lapply(parelmts, "[[", j)))
            if (k_nr %in% pe)
              pe
          })
        } else {
          unlist(unname(parelmts))
        }

        parnames <- if (length(parelmts) > 1) {
          parnames <- sapply(unlist(parelmts), gsub, pattern = k_nr, x = k)
          setdiff(parnames, k)
        }

        if (length(parnames) > 0) {
          scaled_covs <- sapply(parnames, function(j) {
            covname <- coefs$varname[coefs$coef == j]
            MCMC[, j, drop = FALSE] * scale_pars[covname, 'center'] /
              scale_pars[covname, 'scale']
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

  rdvcov_scale <- get_rdvcov_scalemat(scale_pars, info_list, data_list, groups)
  rescale_rd_vcov(MCMC, rdvcov_scale)
}


get_rdvcov_scalemat <- function(scale_pars, info_list, data_list, groups) {

  if (all(lvapply(info_list, function(x) is.null(x$hc_list)))) {
    return(NULL)
  }


  lapply(info_list, function(hc) {
    if (!is.null(hc)) {
      lapply(hc$hc_list$hcvars, function(lvl) {
        rd_desgn_mat <- do.call(cbind,
                                lapply(lvl$rd_slope_coefs, function(rds_info) {
                                  data_list[[rds_info$matrix]][
                                    groups[[gsub("M_", "", rds_info$matrix)]],
                                    rds_info$cols, drop = FALSE]
                                }))
        if (attr(lvl, "rd_intercept")) {
          rd_desgn_mat <- cbind("(Intercept)" = 1, rd_desgn_mat)
        }

        scle <- t(scale_pars[colnames(rd_desgn_mat), "scale", drop = FALSE]
        )[rep(1L, nrow(rd_desgn_mat)), , drop = FALSE]
        centr <- t(scale_pars[colnames(rd_desgn_mat), "center", drop = FALSE]
        )[rep(1L, nrow(rd_desgn_mat)), , drop = FALSE]

        MASS::ginv(rd_desgn_mat) %*% ((rd_desgn_mat - centr)/scle)
      })
    }
  })
}


rescale_rd_vcov <- function(MCMC, rdvcov_scale) {
  if (!is.null(unlist(rdvcov_scale))) {
    for (var in names(rdvcov_scale)) {
      for(lvl in names(rdvcov_scale[[var]])) {
        colnams <- grep(paste0("D_", var, "_", lvl, "\\["),
                        colnames(MCMC), value = TRUE)

        if (length(colnams) > 0) {

          pos <- do.call(rbind,
                         strsplit(gsub("[[:print:]]+\\[|]", "", colnams),
                                  split = ",")
          )

          pos <- data.frame(apply(pos, 2, as.numeric))
          pos$name <- colnams


          vcov <- array(dim = c(nrow(MCMC),
                                nrow(rdvcov_scale[[var]][[lvl]]),
                                ncol(rdvcov_scale[[var]][[lvl]])))

          for (k in seq_len(nrow(pos))) {
            vcov[, pos[k, "X1"], pos[k, "X2"]] <- MCMC[, pos[k, "name"]]
            if (pos[k, "X1"] != pos[k, "X2"]) {
              vcov[, pos[k, "X2"], pos[k, "X1"]] <- MCMC[, pos[k, "name"]]
            }
          }

          vcov_new <- vapply(seq_len(nrow(MCMC)), function(k) {
            rdvcov_scale[[var]][[lvl]] %*% vcov[k, , ] %*%
              t(rdvcov_scale[[var]][[lvl]])
          }, FUN.VALUE = matrix(data = NA_real_,
                                nrow = dim(vcov)[2],
                                ncol = dim(vcov)[3]))


          for (k in seq_len(nrow(pos))) {
            MCMC[, pos[k, "name"]] <- vcov_new[pos[k, "X1"], pos[k, "X2"], ]
          }
        }
      }
    }
  }
  MCMC
}
