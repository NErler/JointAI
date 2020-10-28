


# input:
# - data
# - varname = k / varname = names(random)
# - Mlist$random
# - lvl = gsub("M_", "", info$resp_mat[length(info$resp_mat)])
# - lvls = Mlist$group_lvls (level relations)
# - parelmts (par elmts) parelmts = info$parelmts
# - Mlist$interactions

# - get random structure or make one if needed
# - find out if variables have random slopes or interactions with rd slope
# - sort parelmts in
#   - goes into rd intercept
#   - goes into rd slope: just beta or beta and data
#   - directly goes into linear predictor ("Z part")


# used in get_model1_info() (2020-06-11)
get_hc_info <- function(varname, resplvl, Mlist, parelmts, lp) {

  # - varname: variable name (unabbreviated form) of the outcome of the current
  #            sub-model
  # - resplvl: level of the response variable of the current sub-model,
  #            i.e., 'lvlone'
  # - Mlist: list of design matrices etc. (obtained from divide_matrices())
  # - parelmts: vector of parameter elements used in the current sub-model
  #             (from info_list)
  # - lp: linear predictor of the current sub-model (from info_list)


  all_lvls <- Mlist$group_lvls

  # identify relevant levels: all levels higher than the level of the response
  rel_lvls <- names(all_lvls)[all_lvls > all_lvls[resplvl]]

  # if there is no random effects structure specified, assume random intercepts
  # at the appropriate levels
  newrandom <- check_random_lvls(Mlist$random[[varname]], rel_lvls)

  if (length(newrandom) > 0) {
    hc_columns <- lapply(newrandom, get_hc_columns, Mlist = Mlist)

    structure(
      orga_hc_parelmts(
        resplvl,
        intersect(rel_lvls, names(newrandom)),
        all_lvls = all_lvls,
        hc_columns = hc_columns,
        parelmts = parelmts,
        lp = lp
      ),
      warnings = rescale_ranefs_warning(lapply(hc_columns, attr, "incomplete"),
                                        Mlist$scale_pars, varname))
  }
}



#' Create warning about not being able to re-scale the random effects
#'
#' When random slope variables or variables having an interaction with a random
#' slope variable are scaled during fitting the model the random effects and
#' their variance-covariance parameters need to be re-scaled afterwards.
#' This only possible if there are no missing values in the scaled variables.
#'
#' @param incompl list of logical vectors (one per random effects level)
#'                indicating for all random slope variables if they are
#'                incomplete
#' @param scale_pars list of scaling parameters, as obtained in
#'                   `divide_matrices()`
#' @param varname character string; name of the response variable
#'
#' @noRd
#'
rescale_ranefs_warning <- function(incompl, scale_pars, varname) {

  nlapply(names(incompl), function(lvl) {
    if (any(incompl[[lvl]]) &&
        any(!is.na(do.call(rbind, unname(
          scale_pars
        )))[names(incompl[[lvl]]), ])) {
      w <- warnmsg(
        "There are missing values in a variable for which a random effect
          is specified (%s). It will not be possible to re-scale the
          random effects %s and their variance covariance matrix %s back
          to the original scale of the data. If you are not interested in
          the estimated random effects or their (co)variances this is not a
          problem. The fixed effects estimates are not affected by this.
          If you are interested in the random effects or the (co)variances
          you need to specify that %s are not scaled (using the argument %s).",
        dQuote(names(incompl[[lvl]])[incompl[[lvl]]]),
        dQuote(paste0("b_", varname, "_", lvl)),
        dQuote(paste0("D_", varname, "_", lvl)),
        paste_and(dQuote(names(incompl[[lvl]]))),
        dQuote("scale_params")
      )
      w
    }
  })
}


#' Check and prepare the random effects structure for one sub-model
#'
#' @param random random effects formula (not a list of formulas)
#' @param rel_lvls character vector of the relevant grouping levels for that
#'                 response variable, i.e., all higher levels.
#'
#' @return a list of one-sided formulas (by grouping level). The formulas do not
#'         have any grouping specification any more.
#' @noRd
check_random_lvls <- function(random, rel_lvls) {
  if (length(rel_lvls) == 0L) {
    # here no error if random effects are specified for levels that are not
    # relevant, because this is the case in a time-dependent cox model.
    return(NULL)
  }

  if (is.null(random)) {
    nlapply(rel_lvls, function(x) ~ 1)
  } else {
    rd <- remove_grouping(random)

    if (any(!names(rd) %in% rel_lvls)) {
      errormsg("You have specified random effects for levels on which there
               should not be random effects (%s).",
               dQuote(setdiff(names(rd), rel_lvls)))
    } else {
      rd
    }
  }
}


#' Create list of column numbers containing the variables involved in the random
#' effects
#'
#' @param rdfmla list of random effects formulas by grouping level. The formulas
#'               themselves do not have a grouping level any more (output of
#'               `check_random_lvls`)
#' @param Mlist list of data matrices and other info, obtained by
#'              `divide_matrices()`
#'
#' @return List of lists: for each random effect variable a list with elements
#'         "main" and "interact", each of the two a vector of column numbers
#'         (named with the name of the corresponding data matrix).
#'         Attributes indicate if there is a random intercept ("rd_intercept"),
#'         the column names of the corresponding (hypothetical) random effect
#'         design matrix ("z_names"), and if any of the involved variables
#'         have missing values ("incomplete").
#'
#' @noRd

get_hc_columns <- function(rdfmla, Mlist) {
  # used in get_hc_info() (2020-06-11)

  Mlvls <- Mlist$Mlvls
  Mnam <- nlapply(Mlist$M, colnames)

  # column names of random effect design matrices per required level
  z_names <- get_dsgnmat_names(rdfmla, Mlist$data, Mlist$refs)

  # check for involvement in interactions, i.e., interaction between random
  # slope variable and another variable
  inters <- Mlist$interactions[!names(Mlist$interactions) %in% z_names]

  # identify if there are elements of interaction in Z
  in_z <- if (length(inters) > 0L) {
    nlapply(z_names, function(x)
      lapply(lapply(inters, attr, 'elements'), `%in%`, x))
  }

  structure(
    nlapply(z_names, function(x) {
      list(
        # if the random effect is in the fixed effects, find the column of
        # the design matrix
        main = if (x %in% names(Mlvls)) {
          setNames(match(x, Mnam[[Mlvls[x]]]), Mlvls[x])
        },

        interact = if (any(unlist(in_z[[x]]))) {
          w <- sapply(in_z[[x]], any)
          inters[w]
        }
      )
    }),
    rd_intercept = attr(terms(rdfmla), 'intercept'),
    z_names = z_names,
    incomplete = lvapply(Mlist$data[, all_vars(rdfmla), drop = FALSE],
                         function(x) any(is.na(x)))
  )
}



#' Obtain the column names of a design matrix
#'
#' @param formula a formula or list of formulas
#' @param data a `data.frame`
#' @param refs a reference category object, as obtained from `divide_matrices()`
#'
#' @noRd

get_dsgnmat_names <- function(formula, data, refs) {

  contr_list <- lapply(refs, attr, "contr_matrix")

  colnames(
    model.matrix(formula, data,
                 contrasts.arg = contr_list[intersect(all_vars(formula),
                                                      names(contr_list))]))
}




#' Get info on the main effects in a random slope structure
#' for a given level and sub-model
#'
#' @param hc_cols list of lists (one per random effect), each containing a list
#'                with elements "main" and "interact" that contain information
#'                on the column number and name of the design matrix for the
#'                random effects variables or variables interacting with them
#' @param parelmts list (per design matrix) of indices of the regression
#'                 coefficients used for that sub-model (named with the
#'                 corresponding column name of the design matrix)
#' @return a `data.frame` with columns
#'
#' * `rd_effect`: name of the main random effect,
#' * `term`: the name of the random effect,
#' * `matrix`: the name of the design matrix,
#' * `cols`: the column index of the design matrix,
#' * `parelmts` (the index of the corresponding regression coefficient
#' and one row per (main) random effect
#'
#'
#' @details
#' Argument `hc_cols` should have the structure:
#' ```{r, eval = FALSE}
#' list(
#'   "(Intercept)" = list(main = c(M_id = 1),
#'                        interact = NULL),
#'   time = list(main = c(M_lvlone = 4),
#'               interact = list("C1:time" = list(interterm = c(M_lvlone = 6),
#'                                                elmts = c(M_id = 2,
#'                                                          M_lvlone = 4)),
#'                               "b21:time" = list(interterm = c(M_lvlone = 7),
#'                                                 elmts = c(M_lvlone = 3,
#'                                                           M_lvlone = 4))
#'               )
#'   ),
#'   "I(time^2)" = list(main = c(M_lvlone = 5),
#'                      interact = NULL)
#' )
#' ```
#'
#' Argument `parelmts` is a list of lists instead of a list of vectors in
#' case of a multinomial model or cumulative logit model with non-proportional
#' effects.
#'
#' @keywords internal

hc_rdslope_info <- function(hc_cols, parelmts) {

  hc_cols <- hc_cols[names(hc_cols) != "(Intercept)"]

  rd_slope_list <- lapply(names(hc_cols), function(var) {

    M_lvl <- names(hc_cols[[var]]$main)
    elmts <- parelmts[[M_lvl]]

    if (is.list(elmts)) {
      data.frame(rd_effect = var,
                 term = var,
                 matrix = M_lvl,
                 cols = hc_cols[[var]]$main,
                 parelmts = NA,
                 stringsAsFactors = FALSE
      )
    } else {
      data.frame(rd_effect = var,
                 term = var,
                 matrix = M_lvl,
                 cols = hc_cols[[var]]$main,
                 parelmts = ifelse(is.null(elmts[var]), NA, unname(elmts[var])),
                 stringsAsFactors = FALSE
      )
    }
  })

  do.call(rbind, rd_slope_list)
}




#' Get info on the interactions with random slopes for a given level and sub-model
#'
#' @param hc_cols list of lists (one per random effect), each containing a list
#'                with elements "main" and "interact" that contain information
#'                on the column number and name of the design matrix for the
#'                random effects variables or variables interacting with them
#' @param parelmts list (per design matrix) of indices of the regression
#'                 coefficients used for that sub-model (named with the
#'                 corresponding column name of the design matrix)
#' @return a `data.frame` with columns
#'
#' * `rd_effect`: name of the main random effect,
#' * `term`: the name of the random effect,
#' * `matrix`: the name of the design matrix,
#' * `cols`: the column index of the design matrix,
#' * `parelmts` (the index of the corresponding regression coefficient
#' and one row per (main) random effect
#'
#'
#' @details
#' Argument `hc_cols` should have the structure:
#' ```{r, eval = FALSE}
#' list(
#'   "(Intercept)" = list(main = c(M_id = 1),
#'                        interact = NULL),
#'   time = list(main = c(M_lvlone = 4),
#'               interact = list("C1:time" = list(interterm = c(M_lvlone = 6),
#'                                                elmts = c(M_id = 2,
#'                                                          M_lvlone = 4)),
#'                               "b21:time" = list(interterm = c(M_lvlone = 7),
#'                                                 elmts = c(M_lvlone = 3,
#'                                                           M_lvlone = 4))
#'               )
#'   ),
#'   "I(time^2)" = list(main = c(M_lvlone = 5),
#'                      interact = NULL)
#' )
#' ```
#'
#' Argument `parelmts` is a list of lists instead of a list of vectors in
#' case of a multinomial model or cumulative logit model with non-proportional
#' effects.
#'
#' @keywords internal

hc_rdslope_interact <- function(hc_cols, parelmts, lvls) {

  hc_cols <- hc_cols[names(hc_cols) != "(Intercept)"]

  rd_slope_interact_coefs <- lapply(names(hc_cols), function(var) {

    if (any(lvapply(parelmts, is.list))) {
      do.call(rbind,
              lapply(hc_cols[[var]]$interact, function(x) {
                data.frame(rd_effect = var,
                           term = attr(x, 'interaction'),
                           matrix = names(x$elmts[attr(x, 'elements') != var]),
                           cols = x$elmts[attr(x, 'elements') != var],
                           parelmts = NA,
                           stringsAsFactors = FALSE
                )
              })
      )
    } else {
      do.call(rbind,
              lapply(hc_cols[[var]]$interact, function(x) {
                mat <- names(x$elmts)[attr(x, 'elements') != var]

                data.frame(rd_effect = var,
                           term = attr(x, 'interaction'),
                           matrix = mat,
                           cols = x$elmts[mat],
                           parelmts = unname(parelmts[[names(x$interterm)]][
                             attr(x, "interaction")]),
                           stringsAsFactors = FALSE
                )
              })
      )
    }
  })

  rd_slope_interact_coefs <- do.call(rbind, rd_slope_interact_coefs)

  if (!is.null(rd_slope_interact_coefs)) {
    subset(rd_slope_interact_coefs, matrix %in% paste0('M_', lvls))
  }
}

# used in get_hc_info() (2020-06-11)
orga_hc_parelmts <- function(resplvl, lvls, all_lvls, hc_columns, parelmts, lp) {
  # - resplvl: level of the outcome variable of the current sub-model
  # - lvls: grouping levels in the current sub-model
  # - hc_columns: obtained from get_hc_columns()
  # - parelmts: vector of parameter elements (from info_list)
  # - lp: linear predictor (from info_list)

  hc_vars <- nlapply(lvls, function(lvl) {

    rd_slope_coefs <- hc_rdslope_info(hc_cols = hc_columns[[lvl]], parelmts)
    rd_slope_interact_coefs <- hc_rdslope_interact(hc_columns[[lvl]], parelmts)

    elmts <- parelmts[[paste0("M_", lvl)]][
      !parelmts[[paste0("M_", lvl)]] %in%
        rbind(rd_slope_coefs, rd_slope_interact_coefs)$parelmts]

    rd_intercept_coefs <- if (!is.null(elmts) &
                              attr(hc_columns[[lvl]], 'rd_intercept') == 1) {
      if (is.list(elmts) | length(elmts) == 0) {
        # in case of a multinomial mixed model, there should not be
        # hierarchical centring of the random intercept.
        # If we don't have any parameters in here (by setting NULL), they
        # will end up in "othervars".
        NULL
      } else {
        data.frame(
          rd_effect = "(Intercept)",
          term = names(elmts),
          matrix = paste0("M_", lvl),
          cols = lp[[paste0("M_", lvl)]][names(elmts)],
          parelmts = elmts,
          stringsAsFactors = FALSE
        )
      }
    }

    structure(
      list(rd_intercept_coefs = rd_intercept_coefs,
           rd_slope_coefs = rd_slope_coefs,
           rd_slope_interact_coefs = rd_slope_interact_coefs
      ),
      rd_intercept = "(Intercept)" %in% names(hc_columns[[lvl]]),
      incomplete = attr(hc_columns[[lvl]], "incomplete"),
      z_names = attr(hc_columns[[lvl]], "z_names")
    )
  })



  used <- lapply(nlapply(hc_vars, do.call, what = rbind), "[[", "parelmts")


othervars <- sapply(
  names(all_lvls)[all_lvls <= min(all_lvls[lvls])], function(lvl) {

    other <- get_othervars_mat(lvl, parelmts, lp)
    nonprop <- get_othervars_mat(lvl, lapply(parelmts, 'attr', 'nonprop'),
                                 attr(lp, 'nonprop'))

    if (!inherits(other, 'list'))
      other <- other[!other$parelmts %in% unlist(used), ]

    list(
      other = if (all(dim(other) > 0))
        other,
      nonprop = nonprop
    )
  }, simplify = FALSE)

  list(hcvars = hc_vars,
       othervars = lapply(othervars, "[[", "other"),
       nonprop = lapply(othervars, "[[", "nonprop")
  )
}


get_othervars_mat <- function(lvl, parelmts, lp) {

  pe <- parelmts[[paste0("M_", lvl)]]
  linpred <- lp[[paste0("M_", lvl)]]

  if (length(pe) == 0) {
    NULL
  } else if (is.list(pe)) {
    # pe is a list for multinomial logit models that have multiple linear
    # predictors with separate parameters.
    # In that case: return a list of data.frames
    lapply(pe, function(p) {
      data.frame(term = names(p),
                 matrix = if (!is.null(linpred)) paste0("M_", lvl),
                 cols = linpred[names(p)],
                 parelmts = p,
                 stringsAsFactors = FALSE)
    })
  } else {
    data.frame(term = names(pe),
               matrix = if (!is.null(linpred)) paste0("M_", lvl),
               cols = linpred,
               parelmts = pe,
               stringsAsFactors = FALSE)
  }
}
