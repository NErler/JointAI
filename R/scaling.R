# used in divide_matrices() (2020-06-13)
get_scale_pars <- function(
  mat,
  groups,
  scale_vars,
  refs,
  fcts_all,
  interactions,
  data
) {
  # create a list of matrices containing the scaling parameters corresponding
  # to each of the design matrices

  # scale_vars: NULL or TRUE (all eligible columns), FALSE (none), or the
  # names of the columns to be scaled
  if (is.null(mat) || isFALSE(scale_vars)) {
    return(NULL)
  }

  vars <- find_scalevars(mat, refs, fcts_all, interactions, data)

  if (is.character(scale_vars)) {
    vars <- intersect(vars, scale_vars)
  }

  rows <- match(unique(groups), groups)

  do.call(
    rbind,
    sapply(
      colnames(mat),
      function(k) {
        if (k %in% vars) {
          scaled <- scale(mat[rows, k])
          data.frame(
            center = attr(scaled, 'scaled:center'),
            scale = attr(scaled, 'scaled:scale')
          )
        } else {
          data.frame(center = NA, scale = NA)
        }
      },
      simplify = FALSE
    )
  )
}


# used in get_scale_pars() (2020-06-13)
find_scalevars <- function(mat, refs, fcts_all, interactions, data) {
  # Find the names of columns in the model matrix that are not integers
  # or have many different values

  vars <- lapply(colnames(mat), function(k) {
    k <- replace_dummy(k, refs)

    if (k %in% names(data)) {
      if (is.numeric(data[, k]) & any(!is.na(data[, k]))) k
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
#' Transform the MCMC sample back to the scale of the original data
#'
#' Continuous covariates are centred and scaled before they are passed to
#' JAGS (see `get_scale_pars()`). After sampling, all parameters that depend
#' on this scaling are transformed back, so that they refer to the original
#' variables: the regression coefficients, thresholds of ordinal models and
#' coefficients of the baseline hazard (`rescale_coefs()`), and the random
#' effects and their variance-covariance matrices (`rescale_rd_vcov()`,
#' `rescale_ranefs()`).
#'
#' Used by `model_imp()` and `add_samples()`, and by the package remiod
#' (frozen: the arguments and the returned object must not change).
#'
#' @param MCMC MCMC sample of one chain (`mcmc` object or matrix), on the
#'   scale used in JAGS.
#' @param coefs `data.frame` with one row per regression coefficient
#'   (`do.call(rbind, get_coef_names(info_list))`).
#' @param scale_pars `data.frame` of scaling parameters (columns `center` and
#'   `scale`, one row per design-matrix column, named by the column;
#'   `do.call(rbind, unname(Mlist$scale_pars))`). `NA` means not scaled.
#' @param info_list list with the model info of each sub-model.
#' @param data_list data list passed to JAGS (for the random-effects design
#'   matrices).
#' @param groups list of grouping information (`Mlist$groups`).
#'
#' @return Matrix with the same columns as `MCMC`, on the original scale.
#' @noRd
rescale <- function(MCMC, coefs, scale_pars, info_list, data_list, groups) {
  # NA: column not scaled; centre 0 and scale 1 leave it unchanged
  scale_pars$center[is.na(scale_pars$center)] <- 0
  scale_pars$scale[is.na(scale_pars$scale)] <- 1

  MCMC <- rescale_coefs(MCMC, coefs, scale_pars, info_list, data_list)

  rdvcov_scale <- get_rdvcov_scalemat(scale_pars, info_list, data_list, groups)
  MCMC <- rescale_rd_vcov(MCMC, rdvcov_scale)
  rescale_ranefs(MCMC, rdvcov_scale, groups)
}


#' Transform regression coefficients back to the original scale
#'
#' In JAGS, a covariate `x` enters a linear predictor as
#' `(x - center) / scale`, with coefficient `beta_s`. On the original scale:
#' * coefficient of a covariate: `beta = beta_s / scale`
#' * intercept: `beta0 = beta0_s - sum(beta_s * center / scale)`, summing over
#'   all covariate coefficients of the same linear predictor.
#'
#' Models without intercept have other parameters that take the role of the
#' intercept and are shifted in the same way: the thresholds of ordinal models
#' (`gamma_<y>[k]`; with the non-proportional effects of category `k`) and the
#' coefficients of the baseline hazard of proportional hazards and joint models
#' (`beta_Bh0_<y>`; all by the same amount, because the rows of the B-spline
#' basis sum to 1).
#'
#' Cross-level interactions in the mean of a random slope (hierarchical
#' centring; e.g. `C1:time` with `(time | id)`) enter JAGS as the product of
#' the separately scaled variables `w` (higher level) and `z` (random-slope
#' variable): `(w - c_w) / s_w * (z - c_z) / s_z`. The coefficient is divided by
#' `s_w * s_z`, the coefficients of `w` and `z` change by
#' `-beta_s * c_z / (s_w * s_z)` and `-beta_s * c_w / (s_w * s_z)`, and the
#' intercept by `+beta_s * c_w * c_z / (s_w * s_z)`.
#'
#' A linear predictor is identified by the outcome and, for models with
#' category-specific coefficients (e.g. multinomial models), the category
#' (`coefs$outcat`; `NA` otherwise). All matching is done by name: parameters
#' by their name in `MCMC` (`coefs$coef`), scaling parameters by the name of
#' the design-matrix column (`coefs$varname`).
#'
#' @inheritParams rescale
#' @param scale_pars as in `rescale()`, but without missing values.
#'
#' @return Matrix with the same columns as `MCMC`; all other parameters are
#'   unchanged.
#' @noRd
rescale_coefs <- function(MCMC, coefs, scale_pars, info_list, data_list) {
  rescaled <- matrix(
    MCMC,
    nrow = nrow(MCMC),
    dimnames = list(NULL, colnames(MCMC))
  )

  # no regression coefficients (e.g., ordinal model without covariates)
  if (NROW(coefs) == 0L) {
    return(rescaled)
  }

  # Cross-level interactions w:z in the mean of a random slope (see the
  # documentation above): for these coefficients, `w` and `z` are the names of
  # the higher-level variable and the random-slope variable; NA for all other
  # coefficients. Matched by outcome and column name.
  slope_ia <- get_slope_interactions(info_list, data_list)
  ia_row <- match(
    paste(coefs$outcome, coefs$varname),
    paste(slope_ia$outcome, slope_ia$term)
  )
  coefs$w <- slope_ia$w[ia_row]
  coefs$z <- slope_ia$z[ia_row]
  is_product <- !is.na(coefs$w)

  # How each coefficient enters the linear predictor in JAGS:
  # beta_s * (x - center) / divisor.
  # * Usual coefficients: x is the column of the design matrix, `center` and
  #   `divisor` are its scaling parameters.
  # * Cross-level interactions: beta_s * (w - c_w) / s_w * (z - c_z) / s_z
  #     = beta_s * (w * z - c_z * w - c_w * z + c_w * c_z) / (s_w * s_z),
  #   i.e., x = w * z, center = -c_w * c_z and divisor = s_w * s_z. The terms
  #   -c_z * w and -c_w * z belong to the coefficients of w and z; they are
  #   added further below.
  coefs$center <- scale_pars[coefs$varname, "center"]
  coefs$divisor <- scale_pars[coefs$varname, "scale"]

  sp_w <- scale_pars[coefs$w[is_product], ]
  sp_z <- scale_pars[coefs$z[is_product], ]
  coefs$center[is_product] <- -sp_w$center * sp_z$center
  coefs$divisor[is_product] <- sp_w$scale * sp_z$scale

  # Shift of a linear predictor caused by the centring, sum(beta_s * center /
  # divisor), from the coefficients on the scale used in JAGS. It needs all
  # coefficients of the linear predictor: if one was not monitored, this fails.
  lp_shift <- function(lp_coefs) {
    beta_s <- MCMC[, lp_coefs$coef, drop = FALSE]
    shift <- t(t(beta_s) * lp_coefs$center / lp_coefs$divisor)
    rowSums(shift)
  }

  is_intercept <- coefs$varname == "(Intercept)"
  monitored <- coefs$coef %in% colnames(MCMC)

  # Intercepts
  for (i in which(is_intercept & monitored)) {
    # all other coefficients from the same linear predictor (`%in%`, so that
    # NA matches NA)
    same_lp <- coefs$outcome == coefs$outcome[i] &
      coefs$outcat %in% coefs$outcat[i] &
      !is_intercept
    rescaled[, coefs$coef[i]] <- MCMC[, coefs$coef[i]] -
      lp_shift(coefs[same_lp, ])
  }

  # Models without intercept: thresholds and baseline hazard
  for (info in info_list) {
    model_coefs <- coefs[coefs$outcome %in% info$varname, ]
    if (any(model_coefs$varname == "(Intercept)")) {
      next
    }

    if (info$modeltype %in% c("clm", "clmm")) {
      # categories with non-proportional effects, in the order of the
      # thresholds (as in the JAGS model)
      nonprop <- lapply(info$parelmts, attr, "nonprop")
      categories <- unique(names(unlist(unname(nonprop), recursive = FALSE)))
      gammas <- par_names(paste0("gamma_", info$varname), info$ncat - 1L)

      for (k in which(gammas %in% colnames(MCMC))) {
        lp_coefs <- model_coefs[
          is.na(model_coefs$outcat) | model_coefs$outcat %in% categories[k],
        ]
        rescaled[, gammas[k]] <- MCMC[, gammas[k]] - lp_shift(lp_coefs)
      }
    }

    if (info$modeltype %in% c("coxph", "JM")) {
      bh0 <- par_names(paste0("beta_Bh0_", info$varname), info$df_basehaz)
      bh0 <- intersect(bh0, colnames(MCMC))
      if (length(bh0) > 0L) {
        rescaled[, bh0] <- MCMC[, bh0] - lp_shift(model_coefs)
      }
    }
  }

  # Coefficients of covariates
  covar_coefs <- coefs[!is_intercept & monitored, ]
  rescaled[, covar_coefs$coef] <- t(
    t(MCMC[, covar_coefs$coef, drop = FALSE]) / covar_coefs$divisor
  )

  # Cross-level interactions: the terms -c_z * w and -c_w * z of the product
  # (see above) change the coefficients of w and z of the same linear
  # predictor by -beta_s * c_z / (s_w * s_z) and -beta_s * c_w / (s_w * s_z).
  for (k in which(is_product & monitored)) {
    same_lp <- coefs$outcome == coefs$outcome[k] &
      coefs$outcat %in% coefs$outcat[k]
    beta_s <- MCMC[, coefs$coef[k]]

    # the variable whose coefficient changes, and the centre of the other one
    changes <- list(
      list(var = coefs$w[k], other_center = scale_pars[coefs$z[k], "center"]),
      list(var = coefs$z[k], other_center = scale_pars[coefs$w[k], "center"])
    )
    for (change in changes) {
      target <- coefs$coef[same_lp & coefs$varname == change$var]
      # not in the model (no main effect) or not monitored
      if (length(target) == 0L || !target %in% colnames(MCMC)) {
        next
      }
      rescaled[, target] <- rescaled[, target] -
        beta_s * change$other_center / coefs$divisor[k]
    }
  }

  rescaled
}


#' Cross-level interactions in the means of random slopes
#'
#' With hierarchical centring, an interaction of a covariate `w` of a higher
#' level with a random-slope variable `z` enters the mean of that random slope,
#' so that the JAGS model contains `beta * w * z` with `w` and `z` scaled
#' separately (not the scaled column `w:z`).
#'
#' @inheritParams rescale
#' @return `data.frame` with one row per such term: `outcome` (name of the
#'   outcome as in `coefs`), `term` (column name of the interaction), `w` and
#'   `z` (column names of the two variables); no rows if there are none.
#' @noRd
get_slope_interactions <- function(info_list, data_list) {
  out <- data.frame(
    outcome = character(0L),
    term = character(0L),
    w = character(0L),
    z = character(0L)
  )

  for (info in info_list) {
    # one element per grouping level with random effects
    for (lvl in info$hc_list$hcvars) {
      ia <- lvl$rd_slope_interact_coefs
      if (NROW(ia) == 0L) {
        next
      }

      # w: the column of the higher-level design matrix (given by its number)
      w <- character(nrow(ia))
      for (k in seq_len(nrow(ia))) {
        w[k] <- colnames(data_list[[ia$matrix[k]]])[ia$cols[k]]
      }

      # z: the variable of the random slope whose mean contains the term
      slopes <- lvl$rd_slope_coefs
      z <- slopes$term[match(ia$rd_effect, slopes$rd_effect)]

      out <- rbind(
        out,
        data.frame(outcome = unname(info$varname), term = ia$term, w = w, z = z)
      )
    }
  }
  out
}


#' Names of the elements of a parameter vector in the MCMC sample
#'
#' JAGS names the elements `name[1]`, `name[2]`, ..., but a vector of length 1
#' just `name`.
#'
#' @param name character string; name of the parameter vector
#' @param n integer; length of the parameter vector
#' @noRd
par_names <- function(name, n) {
  if (n == 1L) {
    return(name)
  }
  paste0(name, "[", seq_len(n), "]")
}


get_rdvcov_scalemat <- function(scale_pars, info_list, data_list, groups) {
  if (all(lvapply(info_list, function(x) is.null(x$hc_list)))) {
    return(NULL)
  }

  lapply(info_list, function(hc) {
    if (!is.null(hc)) {
      lapply(hc$hc_list$hcvars, function(lvl) {
        if (
          all(!attr(lvl, "incomplete")) & isTRUE(nrow(lvl$rd_slope_coefs) > 0L)
        ) {
          rd_desgn_mat <- do.call(
            cbind,
            lapply(seq_len(nrow(lvl$rd_slope_coefs)), function(i) {
              data_list[[lvl$rd_slope_coefs$matrix[i]]][
                groups[[gsub("M_", "", lvl$rd_slope_coefs$matrix[i])]],
                lvl$rd_slope_coefs$cols[i],
                drop = FALSE
              ]
            })
          )
          if (attr(lvl, "rd_intercept")) {
            rd_desgn_mat <- cbind("(Intercept)" = 1, rd_desgn_mat)
          }

          scle <- t(scale_pars[colnames(rd_desgn_mat), "scale", drop = FALSE])[
            rep(1L, nrow(rd_desgn_mat)),
            ,
            drop = FALSE
          ]
          centr <- t(scale_pars[
            colnames(rd_desgn_mat),
            "center",
            drop = FALSE
          ])[rep(1L, nrow(rd_desgn_mat)), , drop = FALSE]

          list(
            z = rd_desgn_mat,
            z_inv = MASS::ginv(rd_desgn_mat),
            z_scaled = ((rd_desgn_mat - centr) / scle)
          )
        }
      })
    }
  })
}


rescale_rd_vcov <- function(MCMC, rdvcov_scale) {
  if (!is.null(unlist(rdvcov_scale))) {
    for (var in names(rdvcov_scale)) {
      for (lvl in names(rdvcov_scale[[var]])) {
        if (!is.null(rdvcov_scale[[var]][[lvl]])) {
          colnams <- grep(
            paste0("D_", var, "_", lvl, "\\["),
            colnames(MCMC),
            value = TRUE
          )

          if (length(colnams) > 0) {
            pos <- do.call(
              rbind,
              strsplit(gsub("[[:print:]]+\\[|]", "", colnams), split = ",")
            )

            pos <- data.frame(t(vapply(
              seq_len(nrow(pos)),
              function(j) {
                as.numeric(pos[j, ])
              },
              FUN.VALUE = numeric(2)
            )))
            pos$name <- colnams

            scale_mat <- rdvcov_scale[[var]][[lvl]]$z_inv %*%
              rdvcov_scale[[var]][[lvl]]$z_scaled

            vcov <- array(dim = c(nrow(MCMC), nrow(scale_mat), ncol(scale_mat)))

            for (k in seq_len(nrow(pos))) {
              vcov[, pos[k, "X1"], pos[k, "X2"]] <- MCMC[, pos[k, "name"]]
              if (pos[k, "X1"] != pos[k, "X2"]) {
                vcov[, pos[k, "X2"], pos[k, "X1"]] <- MCMC[, pos[k, "name"]]
              }
            }

            vcov_new <- vapply(
              seq_len(nrow(MCMC)),
              function(k) {
                scale_mat %*% vcov[k, , ] %*% t(scale_mat)
              },
              FUN.VALUE = matrix(
                data = NA_real_,
                nrow = dim(vcov)[2],
                ncol = dim(vcov)[3]
              )
            )
            # for a 1 x 1 matrix, vapply() returns a vector; the iterations
            # are in the last dimension
            if (!inherits(vcov_new, "array")) {
              vcov_new <- array(vcov_new, dim = c(dim(vcov)[2:3], nrow(MCMC)))
            }

            for (k in seq_len(nrow(pos))) {
              MCMC[, pos[k, "name"]] <- vcov_new[pos[k, "X1"], pos[k, "X2"], ]
            }
          }
        }
      }
    }
  }
  MCMC
}


rescale_ranefs <- function(MCMC, rdvcov_scale, groups) {
  if (!is.null(unlist(rdvcov_scale))) {
    for (var in names(rdvcov_scale)) {
      for (lvl in names(rdvcov_scale[[var]])) {
        colnams <- grep(
          paste0("b_", var, "_", lvl, "\\["),
          colnames(MCMC),
          value = TRUE
        )

        if (length(colnams) > 0) {
          pos <- do.call(
            rbind,
            strsplit(gsub("[[:print:]]+\\[|]", "", colnams), split = ",")
          )

          pos <- data.frame(apply(pos, 2, as.numeric))
          pos$name <- colnams

          for (i in unique(groups[[lvl]])) {
            MCMC[, pos$name[pos$X1 == i]] <-
              MCMC[, pos$name[pos$X1 == i]] %*%
              t(
                MASS::ginv(rdvcov_scale[[var]][[lvl]]$z[
                  groups[[lvl]] == i,
                  ,
                  drop = FALSE
                ]) %*%
                  rdvcov_scale[[var]][[lvl]]$z_scaled[groups[[lvl]] == i, ]
              )
          }
        }
      }
    }
  }
  MCMC
}
