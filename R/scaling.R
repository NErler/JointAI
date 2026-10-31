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


#' Columns that are scaled but must not be centred
#'
#' Centring a covariate moves part of its effect into a parameter that takes
#' the role of an intercept: the intercept, the thresholds (ordinal models),
#' the baseline hazard (proportional hazards models), or a random intercept.
#' Where there is no such parameter, centring changes the model (#66). These
#' columns are only scaled:
#' * all covariates of a sub-model without intercept (that is not an ordinal or
#'   proportional hazards model);
#' * the random-slope variables of a grouping level without random intercept;
#' * in a cross-level interaction `w:z` in the mean of a random slope
#'   (`get_slope_interactions()`): `z` if the main effect of `w` is not in the
#'   model, and `w` if the main effect of `z` is not in the model (the product
#'   of the centred variables contains `c_z * w` and `c_w * z`).
#'
#' A column is used by all sub-models, so it is not centred if one of them
#' needs this.
#'
#' @param info_list list with the model information of each sub-model
#'   (`get_model_info()`).
#' @param Mlist list of data matrices and related information
#'   (`divide_matrices()`).
#' @return Character vector of column names.
#' @keywords internal
get_uncentred_columns <- function(info_list, Mlist) {
  coefs <- do.call(rbind, get_coef_names(info_list))
  out <- character(0L)

  for (info in info_list) {
    model_coefs <- coefs[coefs$outcome %in% info$varname, ]

    # sub-model without intercept or intercept-like parameters
    no_intercept <- !any(model_coefs$varname == "(Intercept)") &&
      !info$modeltype %in% c("clm", "clmm", "coxph", "JM")
    if (no_intercept) {
      out <- c(out, model_coefs$varname)
    }

    # grouping levels with random slopes but without random intercept
    for (lvl_info in info$hc_list$hcvars) {
      if (!isTRUE(attr(lvl_info, "rd_intercept"))) {
        z_names <- attr(lvl_info, "z_names")
        out <- c(out, z_names[z_names != "(Intercept)"])
      }
    }
  }

  # cross-level interactions without a main effect
  slope_ia <- get_slope_interactions(info_list, Mlist$M)
  for (k in seq_len(nrow(slope_ia))) {
    in_model <- coefs$varname[coefs$outcome %in% slope_ia$outcome[k]]
    if (!slope_ia$w[k] %in% in_model) {
      out <- c(out, slope_ia$z[k])
    }
    if (!slope_ia$z[k] %in% in_model) {
      out <- c(out, slope_ia$w[k])
    }
  }

  unique(out)
}


#' Scale columns without centring them
#'
#' Sets the centre of the given columns to 0 and their scale to the root mean
#' square (as `scale(x, center = FALSE)`), calculated, like the other scaling
#' parameters, from one value per group of the level of the data matrix (the
#' data matrices in `Mlist` have one row per group). Columns that are not
#' scaled at all are not changed.
#'
#' @param scale_pars list of `data.frame`s of scaling parameters, one per data
#'   matrix (`Mlist$scale_pars`).
#' @param columns character vector of column names
#'   (`get_uncentred_columns()`).
#' @param Mlist list of data matrices and related information
#'   (`divide_matrices()`).
#' @return `scale_pars` with the changed rows.
#' @keywords internal
remove_centring <- function(scale_pars, columns, Mlist) {
  for (m in names(scale_pars)) {
    sp <- scale_pars[[m]]
    rows_to_change <- intersect(columns, rownames(sp)[!is.na(sp$center)])
    if (length(rows_to_change) == 0L) {
      next
    }

    for (k in rows_to_change) {
      x <- Mlist$M[[m]][, k]
      sp[k, "center"] <- 0
      sp[k, "scale"] <- attr(scale(x, center = FALSE), "scaled:scale")
    }
    scale_pars[[m]] <- sp
  }
  scale_pars
}


# re-scale ---------------------------------------------------------------------
#' Transform the MCMC sample back to the scale of the original data
#'
#' Continuous covariates are centred and scaled before they are passed to
#' JAGS (see `get_scale_pars()`). After sampling, all parameters that depend
#' on this scaling are transformed back, so that they refer to the original
#' variables: the regression coefficients, thresholds of ordinal models and
#' coefficients of the baseline hazard (`rescale_coefs()`), and the random
#' effects and their variance-covariance matrices (`rescale_ranefs()`).
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
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#' @param groups list of grouping information (`Mlist$groups`; for the number
#'   of groups per level).
#'
#' @return Matrix with the same columns as `MCMC`, on the original scale.
#' @keywords internal
rescale <- function(MCMC, coefs, scale_pars, info_list, data_list, groups) {
  # NA: column not scaled; centre 0 and scale 1 leave it unchanged
  scale_pars$center[is.na(scale_pars$center)] <- 0
  scale_pars$scale[is.na(scale_pars$scale)] <- 1

  rescaled <- rescale_coefs(MCMC, coefs, scale_pars, info_list, data_list)

  # the random effects need the coefficients on both scales
  rescale_ranefs(
    rescaled,
    MCMC,
    coefs,
    scale_pars,
    info_list,
    data_list,
    groups
  )
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
#' @param MCMC MCMC sample of one chain (`mcmc` object or matrix), on the
#'   scale used in JAGS.
#' @param coefs `data.frame` with one row per regression coefficient
#'   (`do.call(rbind, get_coef_names(info_list))`).
#' @param scale_pars `data.frame` of scaling parameters (columns `center` and
#'   `scale`, one row per design-matrix column, named by the column), as in
#'   `rescale()`, but without missing values (centre 0 and scale 1 for
#'   columns that are not scaled).
#' @param info_list list with the model info of each sub-model.
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#'
#' @return Matrix with the same columns as `MCMC`; the regression
#'   coefficients, thresholds and coefficients of the baseline hazard are
#'   transformed back, all other parameters are unchanged.
#' @keywords internal
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
#' @param info_list list with the model info of each sub-model (uses the
#'   random-effects information in `hc_list`).
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#' @return `data.frame` with one row per such term: `outcome` (name of the
#'   outcome as in `coefs`), `term` (column name of the interaction), `w` and
#'   `z` (column names of the two variables); no rows if there are none.
#' @keywords internal
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
#' @return Character vector of length `n` with the names of the elements.
#' @keywords internal
par_names <- function(name, n) {
  if (n == 1L) {
    return(name)
  }
  paste0(name, "[", seq_len(n), "]")
}


#' Transform random effects and their covariance matrices back
#'
#' In JAGS, the random effects `b` of a grouping level enter the linear
#' predictor as `sum_j b_j * (z_j - c_j) / s_j`, with `z_1 = 1` (random
#' intercept) and the random-slope variables `z_j`, each centred and scaled
#' separately. Written as a function of the original `z`, this gives the random
#' effects on the original scale:
#'
#'     b = A b_s + delta,     D = A D_s A'
#'
#' * `A` undoes the scaling of the random slopes; the centring is constant
#'   within a group and moves to the random intercept
#'   (`ranef_transformation()`).
#' * `delta`: with hierarchical centring, the means of the random effects
#'   contain fixed effects. These are transformed back separately
#'   (`rescale_coefs()`, e.g. the intercept takes the centring of all
#'   covariates); `delta` keeps `b` consistent with them (`ranef_shift()`).
#'
#' `A` does not need the data, so the random effects are transformed back
#' also when a random-slope variable has missing values. `delta` usually does
#' not need the data either. If it depends on covariates (see
#' `ranef_covariate_shift()`), the values of each group are used: observed or,
#' if missing, imputed values (if they were monitored). Without them, the
#' random effects of that group are set to `NA`, with a warning.
#'
#' The random effects are transformed per "block": the random effects that
#' share one covariance matrix (`get_ranef_blocks()`). Usually, a block holds
#' the random effects of one outcome at one grouping level; with
#' `rd_vcov = "full"`, it holds those of several outcomes, and `A` then has one
#' submatrix on the diagonal per outcome (zero elsewhere).
#'
#' @param rescaled MCMC sample (matrix) in which the coefficients are already
#'   transformed back (`rescale_coefs()`).
#' @param MCMC MCMC sample of one chain on the scale used in JAGS (`mcmc`
#'   object or matrix).
#' @param coefs `data.frame` with one row per regression coefficient
#'   (`do.call(rbind, get_coef_names(info_list))`); used to find the
#'   coefficients in the means of the random effects.
#' @param scale_pars `data.frame` of scaling parameters (columns `center` and
#'   `scale`, one row per design-matrix column, named by the column), with
#'   centre 0 and scale 1 for columns that are not scaled.
#' @param info_list list with the model information of each sub-model
#'   (`get_model_info()`).
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#' @param groups list of grouping information (`Mlist$groups`; for the number
#'   of groups per level, and to find the rows of covariates per group).
#'
#' @return `rescaled`, with the random effects and their covariance matrices
#'   transformed back.
#' @keywords internal
rescale_ranefs <- function(
  rescaled,
  MCMC,
  coefs,
  scale_pars,
  info_list,
  data_list,
  groups
) {
  MCMC <- as.matrix(MCMC)

  # iterate through the blocks of random effects, where a block consists of
  # all random effects that share a covariance matrix:
  for (block in get_ranef_blocks(info_list)) {
    # build A for the block: one submatrix on the diagonal per outcome (at the
    # positions `cols` of the outcome's random effects), zero elsewhere
    # nz: dimension of A, i.e., the number of random effects in the block,
    # determined as the largest position
    nz <- max(unlist(lapply(block$parts, "[[", "cols")))
    A <- matrix(0, nz, nz)
    for (part in block$parts) {
      # for each outcome (part), its submatrix of A from the scaling
      # parameters of its random-slope variables
      A[part$cols, part$cols] <- ranef_transformation(
        part$lvl_info,
        scale_pars
      )
    }

    # transform the covariance matrix of the random effects of this block back
    # (basically calculates D = A D_s A')
    rescaled <- rescale_vcov(rescaled, paste0("D_", block$name), A)

    # random effects back transformation
    # ng: number of groups at the block's level
    ng <- max(groups[[block$lvl]])
    # construct the names of the random effect columns in the mcmc sample
    b_cols <- lapply(seq_len(ng), function(g) {
      sprintf("b_%s[%d,%d]", block$name, g, seq_len(nz))
    })
    # for each group: are all its random effects (one row of b) in the sample?
    monitored <- vapply(
      b_cols,
      function(cols) all(cols %in% colnames(MCMC)),
      logical(1L)
    )
    if (!any(monitored)) {
      next
    }

    # construct the shift (delta) of the random effects of this block, and
    # the parts of the shift that depend on covariates (usually none)
    delta <- matrix(0, nrow(MCMC), nz)
    cov_shifts <- list()
    for (part in block$parts) {
      A_part <- A[part$cols, part$cols, drop = FALSE]
      delta[, part$cols] <- ranef_shift(
        part,
        A_part,
        MCMC,
        rescaled,
        coefs,
        scale_pars,
        data_list
      )
      part_shifts <- ranef_covariate_shift(
        part,
        A_part,
        MCMC,
        rescaled,
        coefs,
        scale_pars,
        data_list
      )
      for (cs in part_shifts) {
        cs$cols <- part$cols
        cov_shifts <- c(cov_shifts, list(cs))
      }
    }

    # apply scaling and shift to the random effects estimates, per group
    missing_covs <- character(0L)
    n_missing <- 0L
    for (g in which(monitored)) {
      delta_g <- delta
      for (cs in cov_shifts) {
        x <- group_covariate_values(
          cs,
          g,
          block$lvl,
          groups,
          MCMC,
          data_list
        )
        delta_g[, cs$cols] <- delta_g[, cs$cols] + cs$slope * x
        if (anyNA(x)) {
          missing_covs <- union(missing_covs, cs$w)
        }
      }
      if (anyNA(delta_g)) {
        n_missing <- n_missing + 1L
      }
      cols <- b_cols[[g]]
      rescaled[, cols] <- MCMC[, cols, drop = FALSE] %*% t(A) + delta_g
    }

    if (n_missing > 0L) {
      warnmsg(
        paste(
          "The random effects of %d group(s) of the level %s could not be",
          "transformed back to the original scale and are set to NA:",
          "the covariate(s) %s have missing values, and their imputed",
          "values were not monitored. Monitor the imputed values",
          "(%s) to transform these random effects back."
        ),
        n_missing,
        dQuote(block$lvl),
        paste_and(missing_covs, dQ = TRUE),
        dQuote("monitor_params = c(imps = TRUE)")
      )
    }
  }
  rescaled
}


#' Random effects that share one covariance matrix
#'
#' Usually, each outcome has its own random effects per grouping level,
#' `b_<outcome>_<lvl>`, with covariance matrix `D_<outcome>_<lvl>`. With
#' `rd_vcov = "full"`, the random effects of several outcomes form one vector
#' `b_<lvl>` with covariance matrix `D_<lvl>`; the attribute "ranef_index" of
#' `rd_vcov` gives the positions of each outcome in it (e.g. `"1:2"`).
#'
#' @param info_list list with the model information of each sub-model
#'   (`get_model_info()`).
#' @return List with one element per covariance matrix: `name` (`b_<name>`,
#'   `D_<name>`), `lvl` (grouping level), and `parts`, one per outcome, with
#'   `info` (model info), `lvl_info` (hierarchical-centring information of the
#'   level) and `cols` (positions of the outcome's random effects).
#' @keywords internal
get_ranef_blocks <- function(info_list) {
  blocks <- list()

  for (outcome in names(info_list)) {
    info <- info_list[[outcome]]

    for (lvl in names(info$hc_list$hcvars)) {
      lvl_info <- info$hc_list$hcvars[[lvl]]
      rd_vcov <- info$rd_vcov[[lvl]]

      if (identical(as.character(rd_vcov), "full")) {
        name <- lvl
        cols <- index_range(attr(rd_vcov, "ranef_index")[[outcome]])
      } else {
        name <- paste0(info$varname, "_", lvl)
        cols <- seq_along(attr(lvl_info, "z_names"))
      }

      if (is.null(blocks[[name]])) {
        blocks[[name]] <- list(name = name, lvl = lvl, parts = list())
      }
      part <- list(info = info, lvl_info = lvl_info, cols = cols)
      blocks[[name]]$parts <- c(blocks[[name]]$parts, list(part))
    }
  }
  blocks
}


#' Complete the monitored parameters for transforming random effects back
#'
#' With scaled covariates, the random effects and their covariance matrices are
#' transformed back after sampling (`rescale_ranefs()`). This needs, per block
#' of random effects (`get_ranef_blocks()`):
#' * all random effects of a monitored group (one row of `b`), because `A`
#'   combines the random effects of a group,
#' * all elements of the covariance matrix `D`, because `D = A D_s A'`,
#' * the regression coefficients of the sub-model, for the shift `delta`.
#'
#' Only these are added: if some random effects of a few groups are monitored
#' (e.g. `b_y_id[5,2]`), only the rest of their rows is added (`b_y_id[5,1:2]`),
#' not the random effects of all groups.
#'
#' @param var_names character vector of the parameters (nodes) to monitor, as
#'   passed to JAGS (`get_params()`).
#' @param info_list list with the model information of each sub-model
#'   (`get_model_info()`).
#' @param mess logical; show a message about the added parameters?
#' @return `var_names` with the parameters that need to be added.
#' @keywords internal
complete_ranef_monitoring <- function(var_names, info_list, mess = TRUE) {
  coefs <- do.call(rbind, get_coef_names(info_list))
  added <- character(0L)

  for (block in get_ranef_blocks(info_list)) {
    # number of random effects in the block (see `rescale_ranefs()`)
    nz <- max(unlist(lapply(block$parts, "[[", "cols")))
    b_node <- paste0("b_", block$name)
    D_node <- paste0("D_", block$name)

    # covariance matrix: if some of its elements are monitored, monitor all
    # elements of the upper triangle (as when D is monitored by default)
    if (any(startsWith(var_names, paste0(D_node, "[")))) {
      ij <- which(upper.tri(diag(nz), diag = TRUE), arr.ind = TRUE)
      D_all <- sprintf("%s[%d,%d]", D_node, ij[, 1L], ij[, 2L])
      new <- setdiff(D_all, var_names)
      var_names <- c(var_names, new)
      added <- c(added, new)
    }

    # random effects: if single elements are monitored, e.g. "b_y_id[5,2]",
    # monitor the whole row of these groups instead, e.g. "b_y_id[5,1:2]"
    is_b_element <- startsWith(var_names, paste0(b_node, "["))
    for (k in which(is_b_element)) {
      inside <- sub("^[^[]*\\[(.*)\\]$", "\\1", var_names[k])
      group_index <- sub(",.*$", "", inside)
      row <- sprintf("%s[%s,1:%d]", b_node, group_index, nz)
      if (row != var_names[k]) {
        var_names[k] <- row
        added <- c(added, row)
      }
    }
    var_names <- unique(var_names)

    # regression coefficients of the sub-models whose random effects are
    # monitored (needed for the shift delta)
    if (b_node %in% var_names || any(is_b_element)) {
      for (part in block$parts) {
        if (part$info$parname %in% var_names) {
          next
        }
        needed <- coefs$coef[coefs$outcome %in% part$info$varname]
        new <- setdiff(needed, var_names)
        var_names <- c(var_names, new)
        added <- c(added, new)
      }
    }
  }

  if (mess && length(added) > 0L) {
    msg(
      "Note: To transform the monitored random effects and/or their
      covariance matrices back to the scale of the original (unscaled)
      covariates, the following parameters were added to the monitored
      parameters: %s.",
      paste_and(dQuote(unique(added)))
    )
  }
  var_names
}


#' Complete the monitored parameters for transforming coefficients back
#'
#' With scaled covariates, the coefficients are transformed back after
#' sampling (`rescale_coefs()`). The intercept, the thresholds (ordinal models)
#' and the coefficients of the baseline hazard (proportional hazards models)
#' of a sub-model take the centring of all its covariates, and the
#' coefficients of the variables in cross-level interactions are corrected
#' with the coefficients of the interactions. Therefore, if a coefficient, a
#' threshold or a coefficient of the baseline hazard of a sub-model is
#' monitored, all regression coefficients of that sub-model are monitored
#' (not those of other sub-models).
#'
#' @param var_names character vector of the parameters (nodes) to monitor, as
#'   passed to JAGS (`get_params()`).
#' @param info_list list with the model information of each sub-model
#'   (`get_model_info()`).
#' @param mess logical; show a message about the added parameters?
#' @return `var_names` with the parameters that need to be added.
#' @keywords internal
complete_coef_monitoring <- function(var_names, info_list, mess = TRUE) {
  # nothing monitored
  if (length(var_names) == 0L) {
    return(var_names)
  }

  coefs <- do.call(rbind, get_coef_names(info_list))
  added <- character(0L)

  for (info in info_list) {
    model_coefs <- coefs$coef[coefs$outcome %in% info$varname]
    # no coefficients, or all of them are monitored (whole node)
    if (length(model_coefs) == 0L || info$parname %in% var_names) {
      next
    }

    is_monitored <- vapply(
      model_coefs,
      coef_is_monitored,
      logical(1L),
      var_names = var_names
    )

    # thresholds and baseline hazard, as whole node or single elements
    other_nodes <- paste0(c("gamma_", "beta_Bh0_"), info$varname)
    uses_coefs <- any(is_monitored)
    for (node in other_nodes) {
      if (
        node %in% var_names || any(startsWith(var_names, paste0(node, "[")))
      ) {
        uses_coefs <- TRUE
      }
    }

    if (uses_coefs && !all(is_monitored)) {
      new <- model_coefs[!is_monitored]
      var_names <- c(var_names, new)
      added <- c(added, new)
    }
  }

  if (mess && length(added) > 0L) {
    msg(
      "Note: To transform the monitored parameters back to the scale of the
      original (unscaled) covariates, the following parameters were added to
      the monitored parameters: %s.",
      paste_and(dQuote(added))
    )
  }
  var_names
}


#' Is a regression coefficient monitored?
#'
#' @param coef name of the coefficient, e.g. `"alpha[3]"` (or `"beta"` for a
#'   single coefficient, as in `coef_list`).
#' @param var_names character vector of the parameters (nodes) to monitor.
#' @return `TRUE` if the coefficient is monitored, as the whole node (e.g.
#'   `"alpha"`), as element (`"alpha[3]"`), or as part of a range of elements
#'   (`"alpha[2:4]"`).
#' @keywords internal
coef_is_monitored <- function(coef, var_names) {
  node <- sub("\\[.*$", "", coef)
  if (coef %in% var_names || node %in% var_names) {
    return(TRUE)
  }
  # a single coefficient without index (named like the node)
  if (coef == node) {
    return(FALSE)
  }

  # ranges of elements of the same node
  index <- as.integer(sub("^.*\\[([0-9]+)\\]$", "\\1", coef))
  ranges <- var_names[startsWith(var_names, paste0(node, "["))]
  ranges <- sub("^[^[]*\\[(.*)\\]$", "\\1", ranges)
  ranges <- ranges[grepl("^[0-9]+:[0-9]+$", ranges)]
  for (r in ranges) {
    if (index %in% index_range(r)) {
      return(TRUE)
    }
  }
  FALSE
}


#' Positions given as text
#'
#' @param x character string with one position (e.g. `"3"`) or a range of
#'   positions (e.g. `"1:2"`), as in the attribute "ranef_index" of `rd_vcov`.
#' @return Integer vector of the positions.
#' @keywords internal
index_range <- function(x) {
  bounds <- as.integer(strsplit(x, ":", fixed = TRUE)[[1L]])
  seq(bounds[1L], bounds[length(bounds)])
}


#' Transformation matrix A for the random effects of one outcome and level
#'
#' The random-slope variables enter JAGS as `(z_j - c_j) / s_j`, so
#' `sum_j b_s,j * (z_j - c_j) / s_j = sum_j (A b_s)_j * z_j` with
#' `A[j, j] = 1 / s_j` and, in the row of the random intercept,
#' `A[1, j] = -c_j / s_j`: the centring is the same for all observations of a
#' group and moves to the random intercept.
#'
#' Without random intercept, the random-slope variables are not centred
#' (`get_uncentred_columns()`), so that only the scaling is undone here.
#'
#' @param lvl_info hierarchical-centring information of one grouping level
#'   (element of `hc_list$hcvars` of a sub-model).
#' @param scale_pars `data.frame` of scaling parameters (columns `center` and
#'   `scale`, one row per design-matrix column, named by the column), with
#'   centre 0 and scale 1 for columns that are not scaled.
#' @return Square matrix, one row and column per random effect.
#' @keywords internal
ranef_transformation <- function(lvl_info, scale_pars) {
  z_names <- attr(lvl_info, "z_names")
  sp <- scale_pars[match(z_names, rownames(scale_pars)), ]
  # the random intercept is not scaled
  sp$center[z_names == "(Intercept)"] <- 0
  sp$scale[z_names == "(Intercept)"] <- 1

  A <- diag(1 / sp$scale, nrow = length(z_names))
  if (attr(lvl_info, "rd_intercept")) {
    intercept <- which(z_names == "(Intercept)")
    A[intercept, ] <- A[intercept, ] - sp$center / sp$scale
  }
  A
}


#' Fixed-effects terms in the means of the random effects
#'
#' With hierarchical centring, the mean of a random effect contains fixed
#' effects: the intercept and covariates of the level (random intercept), the
#' coefficient of the random-slope variable and its cross-level interactions
#' (random slopes).
#'
#' @param lvl_info hierarchical-centring information of one grouping level
#'   (element of `hc_list$hcvars` of a sub-model).
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#' @return `data.frame` with one row per term: `rd_effect` (the random effect
#'   whose mean contains the term), `coef_term` (column name of the term, to
#'   find its coefficient), `w` (column name of the covariate the
#'   coefficient is multiplied with; `NA` for a constant, i.e. the intercept or
#'   the coefficient of the random-slope variable itself), and `w_matrix` and
#'   `w_col` (data matrix and column number of `w`; `NA` for a constant).
#' @keywords internal
ranef_mean_terms <- function(lvl_info, data_list) {
  column_names <- function(coefs) {
    vapply(
      seq_len(nrow(coefs)),
      function(k) colnames(data_list[[coefs$matrix[k]]])[coefs$cols[k]],
      character(1L)
    )
  }

  out <- data.frame(
    rd_effect = character(0L),
    coef_term = character(0L),
    w = character(0L),
    w_matrix = character(0L),
    w_col = integer(0L)
  )

  # random intercept: intercept (constant) and covariates of the level
  ic <- lvl_info$rd_intercept_coefs
  if (NROW(ic) > 0L) {
    ic <- ic[!is.na(ic$parelmts), ]
    is_const <- ic$term == "(Intercept)"
    w <- column_names(ic)
    w[is_const] <- NA
    out <- rbind(
      out,
      data.frame(
        rd_effect = ic$rd_effect,
        coef_term = ic$term,
        w = w,
        w_matrix = ifelse(is_const, NA_character_, ic$matrix),
        w_col = ifelse(is_const, NA_integer_, as.integer(ic$cols))
      )
    )
  }

  # random slopes: the coefficient of the random-slope variable (constant)
  sc <- lvl_info$rd_slope_coefs
  if (NROW(sc) > 0L) {
    sc <- sc[!is.na(sc$parelmts), ]
    out <- rbind(
      out,
      data.frame(
        rd_effect = sc$rd_effect,
        coef_term = sc$term,
        w = rep(NA_character_, nrow(sc)),
        w_matrix = rep(NA_character_, nrow(sc)),
        w_col = rep(NA_integer_, nrow(sc))
      )
    )
  }

  # random slopes: cross-level interactions (covariate of a higher level)
  ia <- lvl_info$rd_slope_interact_coefs
  if (NROW(ia) > 0L) {
    ia <- ia[!is.na(ia$parelmts), ]
    out <- rbind(
      out,
      data.frame(
        rd_effect = ia$rd_effect,
        coef_term = ia$term,
        w = column_names(ia),
        w_matrix = ia$matrix,
        w_col = as.integer(ia$cols)
      )
    )
  }
  out
}


#' Shift delta of the random effects of one outcome and level
#'
#' `b = A b_s + delta` with `delta = mu(0) - A mu_s(0)`: the difference between
#' the means of the random effects on the original and the scaled scale,
#' evaluated at covariate values 0 (the covariates drop out when the fixed
#' effects are transformed consistently, so any value would do). On the
#' original scale, only the constant terms remain; on the scaled scale, a
#' covariate `w` at 0 has the value `-c_w / s_w`.
#'
#' @param part one outcome of a block of random effects: element of the
#'   `parts` of a block (`get_ranef_blocks()`), with `info`, `lvl_info` and
#'   `cols`.
#' @param A_part transformation matrix of the random effects of this outcome
#'   (`ranef_transformation()`).
#' @param MCMC MCMC sample (matrix) on the scale used in JAGS.
#' @param rescaled MCMC sample (matrix) in which the coefficients are already
#'   transformed back (`rescale_coefs()`).
#' @param coefs `data.frame` with one row per regression coefficient
#'   (`do.call(rbind, get_coef_names(info_list))`); used to find the
#'   coefficients in the means of the random effects.
#' @param scale_pars `data.frame` of scaling parameters (columns `center` and
#'   `scale`, one row per design-matrix column, named by the column), with
#'   centre 0 and scale 1 for columns that are not scaled.
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#' @return Matrix with one row per iteration and one column per random effect.
#' @keywords internal
ranef_shift <- function(
  part,
  A_part,
  MCMC,
  rescaled,
  coefs,
  scale_pars,
  data_list
) {
  z_names <- attr(part$lvl_info, "z_names")
  terms <- ranef_mean_terms(part$lvl_info, data_list)
  model_coefs <- coefs[
    coefs$outcome %in% part$info$varname & is.na(coefs$outcat),
  ]

  mu_s <- matrix(0, nrow(MCMC), length(z_names))
  mu <- matrix(0, nrow(MCMC), length(z_names))

  for (k in seq_len(nrow(terms))) {
    j <- match(terms$rd_effect[k], z_names)
    coef <- model_coefs$coef[match(terms$coef_term[k], model_coefs$varname)]

    if (is.na(terms$w[k])) {
      # constant term: value 1 on both scales
      mu_s[, j] <- mu_s[, j] + MCMC[, coef]
      mu[, j] <- mu[, j] + rescaled[, coef]
    } else {
      # covariate at 0: (0 - c_w) / s_w on the scaled scale, 0 on the original
      sp_w <- scale_pars[match(terms$w[k], rownames(scale_pars)), ]
      mu_s[, j] <- mu_s[, j] + MCMC[, coef] * (-sp_w$center / sp_w$scale)
    }
  }

  mu - mu_s %*% t(A_part)
}


#' Part of the shift of the random effects that depends on covariates
#'
#' The shift of the random effects of group `g` is
#' `delta_g = mu(x_g) - A mu_s(x_g)`, with `x_g` the covariates in the means
#' of the random effects of that group. It is affine in `x_g`:
#' `delta_g = delta + sum_w slope_w * x_gw`, with `delta` from
#' `ranef_shift()`. Usually, `slope_w` is zero for each covariate (the
#' covariates drop out, because the fixed effects are transformed back
#' consistently), so that the data are not needed. It is not zero, e.g., in
#' `y ~ C1 * time + (time | id) + (C1 | center)`: the part of `C1:time` that
#' the back-transformation moves into the coefficient of C1 belongs to the
#' center-level random slope of C1, not to the id-level random intercept.
#'
#' @param part one outcome of a block of random effects: element of the
#'   `parts` of a block (`get_ranef_blocks()`), with `info`, `lvl_info` and
#'   `cols`.
#' @param A_part transformation matrix of the random effects of this outcome
#'   (`ranef_transformation()`).
#' @param MCMC MCMC sample (matrix) on the scale used in JAGS.
#' @param rescaled MCMC sample (matrix) in which the coefficients are already
#'   transformed back (`rescale_coefs()`).
#' @param coefs `data.frame` with one row per regression coefficient
#'   (`do.call(rbind, get_coef_names(info_list))`); used to find the
#'   coefficients in the means of the random effects.
#' @param scale_pars `data.frame` of scaling parameters (columns `center` and
#'   `scale`, one row per design-matrix column, named by the column), with
#'   centre 0 and scale 1 for columns that are not scaled.
#' @param data_list data list passed to JAGS (for the names of design-matrix
#'   columns).
#' @return List with one element per covariate for which `slope_w` is not
#'   zero: `w` (column name), `matrix` and `col` (data matrix and column
#'   number), and `slope` (matrix with one row per iteration and one column
#'   per random effect of this outcome).
#' @keywords internal
ranef_covariate_shift <- function(
  part,
  A_part,
  MCMC,
  rescaled,
  coefs,
  scale_pars,
  data_list
) {
  z_names <- attr(part$lvl_info, "z_names")
  terms <- ranef_mean_terms(part$lvl_info, data_list)
  terms <- terms[!is.na(terms$w), ]
  model_coefs <- coefs[
    coefs$outcome %in% part$info$varname & is.na(coefs$outcat),
  ]

  out <- list()
  for (w in unique(terms$w)) {
    w_terms <- terms[terms$w == w, ]
    sp_w <- scale_pars[match(w, rownames(scale_pars)), ]

    # coefficient of w in mu(x) - A mu_s(x): the coefficient on the original
    # scale in the mean of random effect j, minus column j of A times the
    # coefficient on the scaled scale divided by the scale of w (the scaled
    # covariate is (w - c_w) / s_w)
    slope <- matrix(0, nrow(MCMC), length(z_names))
    # sum of the absolute values of the parts, to judge if slope is zero
    size <- matrix(0, nrow(MCMC), length(z_names))
    for (k in seq_len(nrow(w_terms))) {
      j <- match(w_terms$rd_effect[k], z_names)
      coef <- model_coefs$coef[match(w_terms$coef_term[k], model_coefs$varname)]

      on_original <- matrix(0, nrow(MCMC), length(z_names))
      on_original[, j] <- rescaled[, coef]
      on_scaled <- outer(MCMC[, coef] / sp_w$scale, A_part[, j])

      slope <- slope + on_original - on_scaled
      size <- size + abs(on_original) + abs(on_scaled)
    }

    if (all(abs(slope) <= sqrt(.Machine$double.eps) * size)) {
      next
    }
    out[[w]] <- list(
      w = w,
      matrix = w_terms$w_matrix[1L],
      col = w_terms$w_col[1L],
      slope = slope
    )
  }
  out
}


#' Values of a covariate for one group, per iteration
#'
#' @param cov_shift element of the output of `ranef_covariate_shift()` (with
#'   `matrix` and `col`).
#' @param g integer; the group (row of the random effects).
#' @param lvl grouping level of the random effects.
#' @param groups `data.frame` of grouping information (`Mlist$groups`; one
#'   row per row of the lowest level).
#' @param MCMC MCMC sample (matrix); contains the imputed values of the
#'   covariate if they were monitored (columns `<matrix>[<row>,<col>]`).
#' @param data_list data list passed to JAGS.
#' @return Vector with one value per iteration: the observed value, the
#'   imputed values, or `NA` if the value is missing and the imputed values
#'   were not monitored.
#' @keywords internal
group_covariate_values <- function(
  cov_shift,
  g,
  lvl,
  groups,
  MCMC,
  data_list
) {
  # row of the data matrix of the covariate (same or higher level) that
  # belongs to group g, via the rows of the lowest level
  matrix_lvl <- sub("^M_", "", cov_shift$matrix)
  row <- groups[[matrix_lvl]][match(g, groups[[lvl]])]

  x <- data_list[[cov_shift$matrix]][row, cov_shift$col]
  if (!is.na(x)) {
    return(rep(x, nrow(MCMC)))
  }

  imp <- sprintf("%s[%d,%d]", cov_shift$matrix, row, cov_shift$col)
  if (imp %in% colnames(MCMC)) {
    MCMC[, imp]
  } else {
    rep(NA_real_, nrow(MCMC))
  }
}


#' Transform the covariance matrix of random effects back: D = A D_s A'
#'
#' @param MCMC MCMC sample (matrix); the elements of the covariance matrix are
#'   the columns `<D_name>[i,j]` with `i <= j` (as monitored in JAGS).
#' @param D_name name of the covariance matrix, e.g. `"D_y_id"`.
#' @param A transformation matrix (`ranef_transformation()`).
#' @return `MCMC` with the covariance matrix transformed back, in each
#'   iteration; unchanged if the matrix is not (completely) in the sample.
#' @keywords internal
rescale_vcov <- function(MCMC, D_name, A) {
  nz <- nrow(A)
  ij <- which(upper.tri(diag(nz), diag = TRUE), arr.ind = TRUE)
  cols <- sprintf("%s[%d,%d]", D_name, ij[, 1L], ij[, 2L])
  if (!all(cols %in% colnames(MCMC))) {
    return(MCMC)
  }

  for (r in seq_len(nrow(MCMC))) {
    D_s <- matrix(0, nz, nz)
    D_s[ij] <- MCMC[r, cols]
    D_s[ij[, 2:1, drop = FALSE]] <- MCMC[r, cols]
    MCMC[r, cols] <- (A %*% D_s %*% t(A))[ij]
  }
  MCMC
}
