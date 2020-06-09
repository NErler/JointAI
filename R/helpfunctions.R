# message functions ------------------------------------------------------------
errormsg <- function(x, ...) {
  stop(strwrap(gettextf(x, ...), prefix = "\n"), call. = FALSE)
}


msg <- function(x, ..., exdent = 0) {
  message(strwrap(gettextf(x, ...), prefix = "\n", exdent = exdent))
}

warnmsg <- function(x, ..., exdent = 0) {
  warning(strwrap(gettextf(x, ...), prefix = "\n", exdent = exdent),
          call. = FALSE, immediate. = TRUE)
}



# variable levels and grouping -------------------------------------------------

get_groups <- function(idvar, data) {
  # identify clusters/groups based on the id variables
  # - idvar: vector of names of the id variables
  # - data: a data.frame

  if (!is.null(idvar)) {
    groups <- sapply(idvar, function(i) {
      match(data[, i], unique(data[, i]))
    }, simplify = FALSE)

    # check for unnecessary nesting levels
    gr_length <- sapply(groups, function(x)length(unique(x))) == nrow(data)
    if (any(gr_length)) {
      if (sum(gr_length) == 1) {
        errormsg("The grouping level %s seem to be unnecessary.
                 There are only unique observations at this level.",
                 names(gr_length[gr_length]))
      } else {
        errormsg("The grouping levels %s seem to be unnecessary.
                 There are only unique observations at these levels.",
             names(gr_length[gr_length]))
      }
    }

    groups$levelone <- 1:nrow(data)

    # check for duplicate levels
    gr_dupl <- duplicated(groups)
    if (any(gr_dupl)) {
      gr_dupl2 <- duplicated(groups, fromLast = TRUE)
      errormsg("The grouping levels %s are duplicats.",
               unique(names(groups)[gr_dupl], names(groups)[gr_dupl2]))
    }
  } else {
    groups = list(levelone = 1:nrow(data))
  }

  groups
}


check_cluster <- function(x, grouping) {
  # check if a variable varies within one cluster
  # - x: a vector
  # - grouping: a list of grouping information (obtained from get_groups())


  sapply(grouping, function(k) {
    # for each level of grouping, compare the original vector with a
    # reconstructed vector in which the first element per group is repeated
    # for each group member
    !identical(unname(x[match(unique(k), k)][match(k, unique(k))]),
               unname(x))
  })

  # returns a logical vector with length = length(groups) were TRUE means that
  # the variable varies in the given level
}



identify_level_relations <- function(grouping) {
  # identify the ordering of the levels
  # - grouping: a list (or vector) of grouping information
  #  (obtained from get_groups())

  # if grouping is not yet a list, make it a list
  if (!is.list(grouping))
    grouping <- list(grouping)

  # turn the list into a matrix, with the different levels as columns
  g <- do.call(cbind, grouping)
  # check if the grouping information varies within each of the clusters
  res <- apply(g, 2, check_cluster, grouping = grouping)

  if (!is.matrix(res))
    res <- t(res)

  # res is a matrix with a row and column per grouping level, containing
  # TRUEs and FALSEs
  res
}


# used in divide_matrices, get_modeltypes, helpfunctions_checks,
# helpfunctions_formulas, plots, simulate_data (2020-06-09)
check_varlevel <- function(x, groups, group_lvls = NULL) {
  # identify the level of a variable
  # - x: a vector
  # - groups: a list of grouping information (obtained from get_groups())
  # - group_lvls: the grouping level matrix
  #               (obtained from identify_level_relations())

  # if there are no groups, make a list with group name 'no_levels' so that the
  # syntax does not fail for single-level models
  if (!is.list(groups))
    groups <- list('no_levels' = groups)

  # check the clustering of the variable
  clus <- check_cluster(x, grouping = groups)

  # clus is a logical vector, which is TRUE if x varies in a given level and
  # FALSE when x is constant in the level


  if (sum(!clus) > 1) {
    # if the variable is constant in more than one level, the exact level needs
    # to be determined using the level structure of the grouping
    if (is.null(group_lvls))
      group_lvls <- identify_level_relations(groups)

    names(which.max(colSums(!group_lvls[!clus, !clus, drop = FALSE])))
  } else if (sum(!clus) == 1) {
    # if the variable is constant in exactly one level, that level is the
    # level of the variable
    names(clus)[!clus]
  } else {
    # if the variable varies in all levels, it is from level one
    'levelone'
  }
}




# divide_matrices helpers ------------------------------------------------------

# used in divide_matrices (2020-06-09)
prep_covoutcomes <- function(dat) {
  # re-code data to a data.matrix, turning factors to numeric values in the
  # manner required by JAGS (binary: 0,1, multivariate/ordinal: 1,2,3,...)
  # - dat: a data.frame containing the relevant variables

  nlev <- sapply(dat, function(x) length(levels(x)))

  if (any(nlev > 2))
    # ordinal/multinomial variables have values 1, 2, 3, ...
    dat[nlev > 2] <- sapply(dat[nlev > 2], as.numeric)

  if (any(nlev == 2))
    # binary variables have values 0, 1
    dat[nlev == 2] <- sapply(dat[nlev == 2], as.numeric) - 1

  data.matrix(dat)
}



# used in divide_matrices (2020-06-09)
reformat_longsurvdata <- function(data, fixed, random, timevar, idvar) {
  # merge the event times into the observation times of a time-varying covariate
  # - data: the original data, with separate columns for the survival event,
  #         survival time, longitudinal follow-up time ("timevar") and
  #         longitudinal covariates
  # - fixed: list of fixed effects formulas
  # - random: list of random effects formulas
  # - timevar: name of the time variable for the time-varying covariates
  # - idvar: vector of id (grouping) variables


  # identify groups and group levels
  groups <- get_groups(idvar, data)
  group_lvls <- colSums(!identify_level_relations(groups))

  # gather names of outcomes of survival models
  survinfo <- extract_outcome(fixed)[grepl("^Surv\\(", fixed)]

  # identify levels of all variables in the data
  datlvls <- sapply(data, check_varlevel, groups = groups,
                    group_lvls = identify_level_relations(groups))

  # if there are multiple survival variables and some time-varying variables
  if (length(survinfo) > 0 & any(datlvls[unlist(survinfo)] != 'levelone')) {

    surv_lvls <- sapply(survinfo, function(x) {
      lvls <- datlvls[unlist(x)]
      if (length(unique(lvls)) > 1)
        errormsg('The event time and status do not have the same level.')

      unique(lvls)
    })

    longlvls <- names(group_lvls)[group_lvls < min(group_lvls[surv_lvls])]

    # check if there are time-varying covariates in the survival models
    haslong <- sapply(names(survinfo), function(k) {
      covar_lvls <- datlvls[all_vars(remove_LHS(fixed[[k]]))]
      any(covar_lvls %in% longlvls)
    })

    if (any(haslong)) {

      # error message if timevar is missing (there is an additional error
      # message in JM_imp, but not for coxph_imp)
      if (is.null(timevar))
        errormsg("For survival models with time-varying covariates the
                 argument %s needs to be specified.", dQuote("timevar"))

      survtimes <- sapply(survinfo[haslong], "[[", 1)

      datsurv <- unique(subset(data, select = c(idvar, unique(survtimes))))
      if (length(unique(survtimes)) > 1) {
        datsurv <- reshape(datsurv, direction = 'long', varying = unique(survtimes),
                           v.names = timevar, idvar = unique(surv_lvls),
                           times = names(survtimes)[duplicated(survtimes)],
                           timevar = 'eventtime')
      } else {
        names(datsurv) <- gsub(unique(survtimes), timevar, names(datsurv))
      }


      datlong <- subset(data, select = c(idvar, names(datlvls)[datlvls %in% longlvls]))


      timedat <- merge(datlong, datsurv,
                       by.y = c(idvar, timevar),
                       by.x = c(idvar, timevar), all = TRUE)

      datbase <- unique(subset(data, select = names(datlvls)[datlvls %in% idvar]))
      merge(timedat, datbase)
    } else {
      data
    }
  } else {
    data
  }
}


# used in divide_matrices (2020-06-09)
fill_locf <- function(data, fixed, random, auxvars, timevar, groups) {
  # fill in values of missing values in time-varying covariates in cox models
  # following the last-observation-carried-forward principle. If there are no
  # observed values before the first missing value, the first observation is
  # carried backwards.
  # - data: the re-formatted (using reformat_longsurvdata()) data
  # - fixed: list of fixed effects formulas
  # - random: list of random effects formulas (can be NULL)
  # - auxvars: formula of auxiliary variables (can be NULL)
  # - timevar: name of the time variable of the time-varying covariates
  # - groups: list of grouping information (as in Mlist)

  allvars <- unique(c(all_vars(fixed),
                      all_vars(random),
                      all_vars(auxvars),
                      timevar))

  # identify survival outcomes and the related variables
  survout <- extract_outcome(fixed)[grepl("^Surv\\(", fixed)]

  # identify data levels
  datlvls <- sapply(data[, allvars], check_varlevel, groups = groups)
  surv_lvl <- unique(datlvls[unlist(survout)])

  # identify covariates in the survival models
  covars <- unique(
    unlist(lapply(names(survout), function(k) {
      all_vars(remove_LHS(fixed[[k]]))
    })
    ))

  # identify which of the covariates are time-varying
  longvars <- intersect(covars, names(datlvls)[datlvls == 'levelone'])

  if (length(longvars) == 0)
    return(data)

  # add a variable identifying the original ordering of the rows in the data
  # (needed because otherwise "groups" would not fit any more after sorting)
  # and sort the data by the time variable
  data$.rowid <- 1:nrow(data)
  data <- data[order(data[timevar]), ]

  # split the data by patient, and fill in values in the time-varying variables
  datlist <- lapply(split(data, data[surv_lvl]), function(x) {
    for (k in longvars) {

      # identify which values are missing and which are observed.
      isna <- which(is.na(x[k]))
      isobs <- which(!is.na(x[k]))

      # if there are both missing and observed values, find out which is the last
      # observed value before a missing value
      lastobs <- if (any(isna) & any(isobs)) {
        sapply(isna, function(i) {
          if (any(isobs < i)) {
            max(isobs[isobs < i])
          } else if (any(isobs > i)) {
            min(isobs[isobs > i])
          } else {
            errormsg('There are no observed values of %s for %s. When using
                     last observation carried forward to model time-varying
                     covariates at least one value has to be observed.',
                     dQuote(k), paste(surv_lvl, "==", unique(x[surv_lvl])))
          }
        })
      }

      if (length(lastobs) > 0) x[isna, k] <- x[lastobs, k]
    }
    x
  })

  datnew <- do.call(rbind, datlist)

  # restore the original order of the rows and return the data without the
  # sorting column
  datnew <- datnew[order(datnew$.rowid), ]
  subset(datnew, select =  -c(.rowid))
}



# used in divide_matrices (2020-03-04)
match_interaction <- function(inter, M) {
  # match interaction terms to their separate elements and check if any of these
  # elements have missing values
  # - inter: character vector of interaction terms
  # - M: list of design matrices of different levels

  Mnam <- sapply(M, colnames, simplify = FALSE)

  out <- sapply(inter, function(i) {
    elmts <- strsplit(i, ":")[[1]]

    if (!any(is.na(c(match(i, unlist(Mnam)),
                     sapply(elmts, match, unlist(Mnam)))))) {

      # find matrix and column containing the interaction term
      inter_match <- sapply(names(M), function(k) {
        if (!is.na(match(i, Mnam[[k]]))) match(i, Mnam[[k]])
      })


      # find matrices and columns of the elements
      elmt_match <- lapply(elmts, function(j) {
        sapply(names(M), function(k) {
          if (!is.na(match(j, Mnam[[k]]))) match(j, Mnam[[k]])
        })
      })


      structure(
        list(
          interterm = unlist(inter_match),
          elmts = unlist(elmt_match)
        ),
        interaction = i, elements = elmts,
        has_NAs = ifelse(any(sapply(M, function(x)
          any(is.na(x[, elmts[elmts %in% colnames(x)]])))
        ), TRUE, FALSE)
      )
    }}, simplify = FALSE)

  if (any(!sapply(out, is.null))) out[!sapply(out, is.null)]
}




# model_info helpers -----------------------------------------------------------

# used in get_model_info (2020-06-09)
replace_dummy <- function(nam, refs) {
  # replace a variable name with the names of the corresponding dummy variables
  # if the variable is a factor
  # - nam: vector of variable names
  # - refs: list of reference category information (part of Mlist)

  if (is.null(refs))
    return(nam)

  dummies <- lapply(refs, "attr",  "dummies")

  if (any(sapply(dummies, function(k) nam %in% k)))
    names(dummies)[sapply(dummies, function(k) nam %in% k)]
  else
    nam
}


# used in get_model_info (2020-06-09)
replace_trafo <- function(nam, trafos) {
  # replace a variable name with the string used in the transformation of this
  # variable, if this variable is being transformed in the model
  # - nam: a variable name
  # - trafos: trafos info obtained from Mlist

  if (nam %in% trafos$colname) {
    unique(trafos$var[trafos$colname %in% nam])
  } else {nam}
}


# used in get_model_info and predict (2020-09-06)
#' Clean Survival Name
#'
#' A helper function that converts the "name of a survival model"
#' (the \code{"Surv(time, status)"} specification) into a valid variable name
#' so that it can be used in the JAGS model syntax.
#'
#' @param x a character string
#'
#' @examples
#' clean_survname("Surv(eventtime, event != 'censored')")
#'
#' @export

clean_survname <- function(x) {
  # replace symbols not allowed in variable names to create a valid variable
  # name replacing the survival model outcome string in the JAGS model.
  x <- gsub(',* *type * = * [[:print:]]*', '', x)
  x <- gsub("[)\'\"]", '', x)
  x <- gsub("[[:punct:]]* *I\\(", "_", x)
  x <- gsub(' *== *', '_', x)
  x <- gsub(' *!= *', '_', x)
  x <- gsub(' *<=* *', '_', x)
  x <- gsub(' *>=* *', '_', x)
  x <- gsub(' *, *', "_", x)
  x <- gsub("\\(", "_", x)

  abbreviate(x, minlength = 15, use.classes = TRUE)
}


# model_imp helpers ------------------------------------------------------------

# used in add_samples, get_params, model_imp (2020-06-09)
get_coef_names <- function(info_list) {
  # extract the names of the regression coefficients and the corresponding
  # variable names
  # - info_list: a model info list (obtained from get_model_info())

  sapply(info_list, function(info) {

    pars <- sapply(info_list, function(k) {
      if (k$parname %in% info$parname) unlist(k$parelmts)
    })

    if (any(!sapply(info$lp, is.null)))
      data.frame(outcome = unname(info$varname),
                 varname = names(unlist(unname(info$lp))),
                 coef = paste0(info$parname,
                               if (length(pars) > 1)
                                 paste0("[", unlist(info$parelmts), "]")
                 ),
                 stringsAsFactors = FALSE
      )
  }, simplify = FALSE)
}



# data_list helpers --------------------------------------------------------

# used in get_data_list and predict (2020-06-09)
get_Mgk <- function(Mlist, gkx, surv_lvl, survinfo, data, rows = NULL, td_cox = FALSE) {
  # get the Gauss-Kronrod quadrature version of the level one design matrix,
  # needed for a JM and coxph with time-varying covariates
  # - Mlist: the output of divide_matrices()
  # - gkx: vector of quadrature points
  # - surv_lvl: name of the grouping level of the survival outcome
  # - survinfo: list of relevant information of the survival models (obtained
  #             from get_survinfo())
  # - data: the original data when used in get_data_list, and the newdata when
  #          used in prediction
  # - rows: the rows of the longitudinal variables corresponding to the survival
  #         times (or 1:nrow(newdata when used in prediction)
  # - td_cox: logical; is this for a time-dependent cox model?

  # rows to replicate when setting up gk_data
  if (is.null(rows))
    rows <- match(unique(data[, surv_lvl]), data[, surv_lvl])

  # base-version of gk_data: one row per unit of the survival outcome level
  gk_data <- data[rep(rows, each = length(gkx)), ]

  # replace the id variable on the survival outcome level
  gk_data[, surv_lvl] <- rep(data[rows, surv_lvl], each = length(gkx))


  # replace the survival time with the Gauss-Kronrod version of it
  surv_time_name <- unique(sapply(survinfo, "[[", "time_name"))
  gk_data[, Mlist$timevar] <- c(t(outer(data[rows, surv_time_name]/2, gkx + 1)))


  # for a time-dependent cox model: use last-observation carried forward to fill
  # in the time-varying covariate values at the time-points that were determined
  # based on Gauss-Kronrod quadrature
  if (td_cox) {
    gk_data <- get_locf(fixed = Mlist$fixed, data = data,
                        idvar = surv_lvl,
                        group_lvls = Mlist$group_lvls, groups = Mlist$groups,
                        timevar = Mlist$timevar,
                        longvars = unique(unlist(lapply(survinfo, "[[", 'longvars'))),
                        gk_data)
  } else {

    for (k in unique(unlist(lapply(survinfo, "[[", "tv_vars")))) {
      gk_data[, k] <- if (is.factor(gk_data[, k])) {
        factor(NA, levels = levels(gk_data[, k]))
      } else NA * gk_data[, k]
    }

  }



  X <- model.matrix_combi(fmla = c(Mlist$fixed, unlist(remove_grouping(Mlist$random)),
                                   Mlist$auxvars),
                          data = gk_data,
                          terms_list = Mlist$terms_list)

  Xnew <- matrix(nrow = length(rows) * length(gkx),
                 ncol = ncol(Mlist$M$M_levelone),
                 dimnames = list(c(), colnames(Mlist$M$M_levelone)))

  Xnew[, colnames(X)[colnames(X) %in% colnames(Xnew)]] <-
    X[, colnames(X)[colnames(X) %in% colnames(Xnew)]]

  lapply(1:length(gkx), function(k) {
    Xnew[length(gkx) * ((1:length(rows)) - 1) + k, ]
  })
}



# used here, in get_Mgk() (2020-06-09)
get_locf <- function(fixed, data, idvar, group_lvls, groups, timevar,
                     longvars, gk_data) {

  # Fill in the longitudinal covariate values in the Gauss-Kronrod version of
  # the design matrix for level one using last-observation-carried-forward.
  # !!! If there is no observation of the longitudinal covariate at baseline
  #     (at timevar = 0) the first available value will be used.
  # - fixed: a list of fixed effects formulas
  # - data: the original or newdata (in case of prediction)
  # - idvar: the level of the survival outcome
  # - group_lvls: the ordering of the different levels of grouping in the data
  # - groups: list of grouping information
  # - timevar: name of the time variable of the longitudinal variables
  # - longvars: vector of names of the time-varying covariates
  # - gk_data: data.frame of the Gauss-Kronrod version of the level one design
  #             matrix

  # long data
  ld <- subset(data, select = c(idvar, timevar, longvars))
  # sort by id variable
  ld <- ld[order(ld[, idvar]), ]
  # add column with observation time indicator ("visit number" per patient)
  ld$obstime <- unlist(lapply(table(droplevels(ld[, idvar, drop = FALSE])),
                              function(k) 1:k))

  # turn long data into wide format, one column per visit
  wd <- reshape(ld, direction = 'wide', v.names = c(timevar, longvars),
                timevar = 'obstime', idvar = idvar)

  # add a colum identifying the original ordering of the rows to gk_data
  gk_data$rowid <- 1:nrow(gk_data)

  # merge gk_data with wide format version of the time-varying covariates
  md <- merge(subset(gk_data, select = c(idvar, timevar, 'rowid')), wd)


  locf <- sapply(1:nrow(md), function(i) {
    # identify which visit should be used
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # if there is no baseline visit (i.e., the first time with an observed value
    # is larger than the time in the Gauss-Kronrod version of the time) the
    # first available measurement will be used ('first value carried backward')
    valcol <- max(1, which(
      c(md[i, timevar] > md[i, grep(paste0("^", timevar, "."), colnames(md))])
    ), na.rm = TRUE)


    # identify which columns have the covariate values of the correct visit
    covcols <- sapply(longvars, function(k) {
      grep(paste0("^", k, "."), colnames(md))[valcol]
    })

    out <- md[i, covcols, drop = FALSE]
    names(out) = longvars
    out
  }, simplify = FALSE)

  md[, longvars] <- do.call(rbind, locf)

  gk_data_new <- merge(subset(gk_data, select = !names(gk_data) %in% longvars),
                       subset(md, select = c(idvar, timevar, longvars, 'rowid'))
  )
  gk_data_new[order(gk_data_new$rowid), ]
}




# used in get_data_list and predict (2020-06-09)
get_survinfo <- function(info_list, Mlist) {
  # make a list containing relevant information of survival outcomes, to
  # make subsequent syntax easier to handle/read
  # - info_list: list of model info as obtained from get_model info()
  # - Mlist: as obtained from divide_matrics()

  modeltypes <- sapply(info_list, "[[", 'modeltype')

  sapply(names(info_list[modeltypes %in% c('coxph', 'JM')]), function(k) {

    x <- info_list[[k]]

    surv_lvl = gsub("M_", "" , x$resp_mat[2])
    longlvls <- names(Mlist$group_lvls)[Mlist$group_lvls < Mlist$group_lvls[surv_lvl]]

    if (any(longlvls != "levelone"))
      errormsg("There can be only one level of observations below the level
               on which survival is measured.")


    covars <- all_vars(remove_LHS(Mlist$fixed[[k]]))
    covar_lvls <- sapply(Mlist$data[, covars], check_varlevel, groups = Mlist$groups,
                         group_lvls = identify_level_relations(Mlist$groups))
    longvars <- names(covar_lvls)[covar_lvls %in% longlvls]


    list(varname = x$varname,
         modeltype = x$modeltype,
         surv_lvl = surv_lvl,
         longlvls = longlvls,
         longvars = longvars,
         haslong = isTRUE(!is.null(unlist(x$lp[paste0('M_', longlvls)]))),
         tv_vars = names(x$tv_vars),

         # name of the variable containing the time of the repeated measurements:
         time_name = Mlist$outcomes$outnams[[k]][1],
         survtime = Mlist$M[[x$resp_mat[1]]][, x$resp_col[1]],
         survevent = Mlist$M[[x$resp_mat[2]]][, x$resp_col[2]]

    )
  }, simplify = FALSE)
}


