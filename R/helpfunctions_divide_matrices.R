# survival data ----------------------------------------------------------------

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
  datlvls <- get_datlvls(data, groups)
  # datlvls <- cvapply(data, check_varlevel, groups = groups,
  #                   group_lvls = identify_level_relations(groups))

  # if there are multiple survival variables and some time-varying variables
  if (length(survinfo) > 0L & any(datlvls[unlist(survinfo)] != "lvlone")) {

    surv_lvls <- sapply(survinfo, function(x) {
      lvls <- datlvls[unlist(x)]
      if (length(unique(lvls)) > 1L)
        errormsg("The event time and status do not have the same level.")

      unique(lvls)
    })

    longlvls <- names(group_lvls)[group_lvls < min(group_lvls[surv_lvls])]

    # check if there are time-varying covariates in the survival models
    haslong <- lvapply(names(survinfo), function(k) {
      covar_lvls <- datlvls[all_vars(remove_lhs(fixed[[k]]))]
      any(covar_lvls %in% longlvls)
    })

    if (any(haslong)) {

      # error message if timevar is missing (there is an additional error
      # message in JM_imp, but not for coxph_imp)
      if (is.null(timevar))
        errormsg("For survival models with time-varying covariates the
                 argument %s needs to be specified.", dQuote("timevar"))

      survtimes <- cvapply(survinfo[haslong], "[[", 1L)

      datsurv <- unique(subset(data, select = c(idvar, unique(survtimes))))
      if (length(unique(survtimes)) > 1L) {
        datsurv <- reshape(datsurv, direction = "long",
                           varying = unique(survtimes),
                           v.names = timevar, idvar = unique(surv_lvls),
                           times = names(survtimes)[duplicated(survtimes)],
                           timevar = "eventtime")
      } else {
        names(datsurv) <- gsub(unique(survtimes), timevar, names(datsurv))
      }


      datlong <- subset(data,
                        select = c(idvar,
                                   names(datlvls)[datlvls %in% longlvls]))


      timedat <- merge(datlong, datsurv,
                       by.y = c(idvar, timevar),
                       by.x = c(idvar, timevar), all = TRUE)

      datbase <- unique(subset(data,
                               select = names(datlvls)[datlvls %in% idvar]))
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

  allvars <- unique(c(all_vars(c(fixed, random, auxvars)),
                      timevar))

  # identify survival outcomes and the related variables
  survout <- extract_outcome(fixed)[grepl("^Surv\\(", fixed)]

  # identify data levels
  # datlvls <- cvapply(data[, allvars], check_varlevel, groups = groups)
  datlvls <- get_datlvls(data[, allvars], groups)
  surv_lvl <- unique(datlvls[unlist(survout)])

  # identify covariates in the survival models
  covars <- unique(
    unlist(lapply(seq_along(survout), function(k) {
      all_vars(remove_lhs(fixed[[k]]))
    })
    ))

  # identify which of the covariates are time-varying
  longvars <- intersect(covars, names(datlvls)[datlvls == "lvlone"])

  if (length(longvars) == 0L) {
    return(data)
  }

  # add a variable identifying the original ordering of the rows in the data
  # (needed because otherwise "groups" would not fit any more after sorting)
  # and sort the data by the time variable
  data$rowiddd <- seq_len(nrow(data))
  data <- data[order(data[[timevar]]), ]

  # split the data by patient, and fill in values in the time-varying variables
  datlist <- lapply(split(data, data[surv_lvl]), function(x) {
    for (k in longvars) {

      # identify which values are missing and which are observed.
      isna <- which(is.na(x[k]))
      isobs <- which(!is.na(x[k]))

      # if there are both missing and observed values, find out which is the
      # last observed value before a missing value
      lastobs <- if (any(isna) & any(isobs)) {
        ivapply(isna, function(i) {
          if (any(isobs < i)) {
            max(isobs[isobs < i])
          } else if (any(isobs > i)) {
            min(isobs[isobs > i])
          } else {
            errormsg("There are no observed values of %s for %s. When using
                     last observation carried forward to model time-varying
                     covariates at least one value has to be observed.",
                     dQuote(k), paste(surv_lvl, "==", unique(x[surv_lvl])))
          }
        })
      }

      if (length(lastobs) > 0L) x[isna, k] <- x[lastobs, k]
    }
    x
  })

  datnew <- do.call(rbind, datlist)

  # restore the original order of the rows and return the data without the
  # sorting column
  datnew <- datnew[order(datnew$rowiddd), ]
  subset(datnew, select =  setdiff(names(datnew), "rowiddd"))
}



# outcome and covariate data ---------------------------------------------------
# * extract outcome data -------------------------------------------------------

# used in divide_matrices and get_models (2020-06-10)
extract_outcome_data <- function(fixed, random = NULL, data,
                                 analysis_type = NULL, warn = TRUE) {
  fixed <- check_formula_list(fixed)

  idvar <- extract_id(random, warn = warn)
  groups <- get_groups(idvar, data)

  lvls <- colSums(!identify_level_relations(groups))

  outcomes <- outnams <- extract_outcome(fixed)

  # set attribute "type" to identify survival outcomes
  for (i in seq_along(fixed)) {
    if (survival::is.Surv(eval(parse(text = names(outnams[i])),
                               envir = data))) {
      outcomes[[i]] <- as.data.frame.matrix(
        eval(parse(text = names(outnams[i])),
        envir = data
      ))

      if (any(is.na(outcomes[[i]]))) {
        errormsg("There are invalid values in the survival time or status.")
      }

      names(outcomes[[i]]) <- idSurv(names(outnams[i]))[c("time", "status")]
      nlev <- ivapply(outcomes[[i]], function(x) length(levels(x)))
      if (any(nlev > 2L)) {
        # ordinal variables have values 1, 2, 3, ...
        outcomes[[i]][which(nlev > 2L)] <- lapply(
          outcomes[[i]][which(nlev > 2L)],
          function(x) as.numeric(x)
        )
      } else if (any(nlev == 2L)) {
        # binary variables have values 0, 1
        outcomes[[i]][nlev == 2L] <- lapply(
          outcomes[[i]][nlev == 2L],
          function(x) as.numeric(x) - 1L
        )
      }

      attr(fixed[[i]], "type") <- if (analysis_type == "coxph") {
        "coxph"
      } else if (analysis_type == "JM") "JM" else "survreg"
      names(fixed)[i] <- names(outnams[i])
    } else {
      outcomes[[i]] <- split_outcome(lhs = extract_lhs(fixed[[i]]), data = data)
      nlev <- ivapply(outcomes[[i]], function(x) length(levels(x)))
      # varlvl <- cvapply(outcomes[[i]], check_varlevel, groups = groups)
      varlvl <- get_datlvls(outcomes[[i]], groups)


      if (any(nlev > 2L)) {
        # ordinal variables have values 1, 2, 3, ...
        outcomes[[i]][which(nlev > 2L)] <- lapply(
          outcomes[[i]][which(nlev > 2L)],
          function(x) as.numeric(x)
        )
        attr(fixed[[i]], "type") <- cvapply(
          lvls[varlvl] < max(lvls), function(q) {
            switch(as.character(q),
                   "TRUE" = "clmm",
                   "FALSE" = "clm")
          })
      } else if (any(nlev == 2L)) {
        # binary variables have values 0, 1
        outcomes[[i]][nlev == 2L] <- lapply(
          outcomes[[i]][nlev == 2L],
          function(x) as.numeric(x) - 1L
        )

        attr(fixed[[i]], "type") <- cvapply(
          lvls[varlvl] < max(lvls), function(q) {
            switch(as.character(q),
                   "TRUE" = "glmm_binomial_logit",
                   "FALSE" = "glm_binomial_logit")
          })
      } else if (any(nlev == 0L)) {
        # continuous variables
        attr(fixed[[i]], "type") <- cvapply(
          lvls[varlvl] < max(lvls), function(q) {
            switch(as.character(q),
                   "TRUE" = "lmm",
                   "FALSE" = "lm")
          })
      }
      if (i == 1L) {
        attr(fixed[[i]], "type") <- if (
          isTRUE(analysis_type %in% c("glm", "lm"))) {
          paste(gsub("^lm$", "glm", analysis_type),
            tolower(attr(analysis_type, "family")$family),
            attr(analysis_type, "family")$link,
            sep = "_"
          )
        } else if (isTRUE(analysis_type %in% c("glme", "lme"))) {
          paste(gsub("^[g]*lme$", "glmm", analysis_type),
            tolower(attr(analysis_type, "family")$family),
            attr(analysis_type, "family")$link,
            sep = "_"
          )
        } else {
          analysis_type
        }
      }
      names(fixed)[i] <- outnams[i]
    }
  }
  list(fixed = fixed, outcomes = outcomes, outnams = outnams)
}



# used in extract_outcome_data() (2020-06-10)
split_outcome <- function(lhs, data) {
  if (missing(data))
    stop("No data provided")


  if (grepl("^cbind\\(", lhs)) {
    lhs2 <- gsub("\\)$", "", gsub("^cbind\\(", "", lhs))

    splitpos <- c(gregexpr(",", text = lhs2)[[1L]], nchar(lhs2) + 1L)

    if (splitpos[1L] > 0L) {
      start <- 1L
      end <- splitpos[1L] - 1L
      i <- 1L
      outlist <- list()

      while (start <= splitpos[length(splitpos)]) {
        fct <- substr(lhs2, start, end)
        fct <- gsub(" $", "", gsub("^ ", "", fct))
        var <- try(eval(parse(text = fct), envir = data), silent = TRUE)

        if (!inherits(var, "try-error")) {
          var <- data.frame(var)
          names(var) <- if (ncol(var) > 1L) {
            paste0(fct, seq_len(ncol(var)))
          } else fct
          outlist <- c(outlist, var)
          start <- splitpos[i] + 1L
          end <- splitpos[i + 1L] -
            switch(as.character(splitpos[i + 1L] == nchar(lhs2)),
                   "TRUE" = 0L,
                   "FALSE" = 1L)
          i <- i + 1L
        } else {
          end <- splitpos[i + 1L] - 1L
          i <- i + 1L
        }
      }
      outdat <- as.data.frame(outlist)
      names(outdat) <- names(outlist)

    }} else {
      outdat <- as.data.frame(eval(parse(text = lhs), envir = data))
      names(outdat) <- lhs
    }

  outdat
}


# * prep outcome data ----------------------------------------------------------
# used in divide_matrices (2020-06-09)
outcomes_to_mat <- function(outcomes) {
  # make a design matrix from the outcomes of a list of formulas
  # - outcomes: list produced by extract_outcome_data()

  outlist <- unlist(unname(lapply(outcomes$outcomes, as.list)),
                    recursive = FALSE)

  nosurv <- !lapply(outcomes$fixed, "attr", "type") %in% c("coxph", "JM")
  outlist_nosurv <- unlist(unname(lapply(outcomes$outcomes[nosurv], as.list)),
                           recursive = FALSE)

  if (any(duplicated(outlist_nosurv))) {
    d1 <- duplicated(outlist_nosurv)
    d2 <- duplicated(outlist_nosurv, fromLast = TRUE)

    d <- unique(unlist(outcomes$outnams[nosurv])[d1 | d2])
    if (length(d) == 1L) {
      errormsg("You can only specify one model per outcome.
               The variable %s is used on the left hand side of more than one
               of the model formulas.", paste0(dQuote(d), collapse = ", "))
    } else {
      errormsg("You can only specify one model per outcome.
               The variables %s are used on the left hand side of more than
               one of the model formulas.", paste0(dQuote(d), collapse = ", "))
    }
  }

  data.matrix(as.data.frame(outlist, check.names = FALSE))
}


# used in divide_matrices (2020-06-09)
prep_covoutcomes <- function(dat) {
  # re-code data to a data.matrix, turning factors to numeric values in the
  # manner required by JAGS (binary: 0,1, multivariate/ordinal: 1,2,3,...)
  # - dat: a data.frame containing the relevant variables

  nlev <- ivapply(dat, function(x) length(levels(x)))

  if (any(nlev > 2L))
    # ordinal/multinomial variables have values 1, 2, 3, ...
    dat[nlev > 2L] <- vapply(dat[nlev > 2L], as.integer,
                             FUN.VALUE = integer(nrow(dat)))

  if (any(nlev == 2L))
    # binary variables have values 0, 1
    dat[nlev == 2L] <- vapply(dat[nlev == 2L], as.integer,
                              FUN.VALUE = integer(nrow(dat))) - 1L

  data.matrix(dat)
}



# * model matrix combi ---------------------------------------------------------

# used in divide_matrices and get_matgk (2020-06-10)
model_matrix_combi <- function(fmla, data, terms_list, refs) {
  # list of model.frames
  mf_list <- lapply(terms_list, model.frame, data = data, na.action = na.pass)


  mats <- mapply(function(object, data, contr) {
    # get the subset of contrast matrices corresponding to the current formula
    # to avoid warning messages
    covars <- cvapply(attr(terms(remove_lhs(object)),
                          "variables")[-1L], deparse, width.cutoff = 500L)
    contr_list <- contr[intersect(covars, names(contr))]

    # obtain the model matrix using the pre-specified contrast matrices
    model.matrix(object, data, contrasts.arg = contr_list)
  }, object = fmla, data = mf_list,
  MoreArgs = list(contr = lapply(refs, attr, "contr_matrix")),
  SIMPLIFY = FALSE)


  desgn_mat <- mats[[1L]]


  if (length(mats) > 1L) {
    for (i in seq_along(mats)[-1L]) {
      desgn_mat <- cbind(desgn_mat,
                         mats[[i]][, setdiff(colnames(mats[[i]]),
                                             colnames(desgn_mat)),
                                   drop = FALSE]
      )

      if (length(setdiff(colnames(mf_list[[i]]), colnames(desgn_mat))) > 0L) {
        # need to create matrix and check number of columns, because a spline
        # is one variable in the mf_list, but consists of multiple columns.
        # This gives an error when used in data.matrix(), and, moreover, is not
        # the point. We want to include the main effects (specifically for
        # factors) to enable the use some more unusual transformations.


        mf_mat <- mf_list[[i]][, setdiff(colnames(mf_list[[i]]),
                                         colnames(desgn_mat)),
                               drop = FALSE]
        mf_mat <- mf_mat[, lvapply(mf_mat, function(k) {
          !inherits(k, c("matrix", "Surv"))
        }), drop = FALSE]

        if (ncol(mf_mat) > 0L) {
          desgn_mat <- cbind(desgn_mat, data.matrix(mf_mat))
        }
      }
    }
  }

  desgn_mat
}


# used in divide_matrices (2020-06-10)
get_terms_list <- function(fmla, data) {
  fmla <- fmla[!lvapply(fmla, is.null)]

  fmla <- check_formula_list(fmla)

  # list of model.frames
  mf_list <- lapply(fmla, model.frame, data = data, na.action = na.pass)
  # list of term objects
  terms_list <- lapply(mf_list, terms)

  terms_list
}







# interactions -----------------------------------------------------------------

# used in divide_matrices (2020-03-04)
match_interaction <- function(inter, desgn_mat_list) {
  # match interaction terms to their separate elements and check if any of these
  # elements have missing values
  # - inter: character vector of interaction terms
  # - desgn_mat_list: list of design matrices of different levels

  desgn_mat_listnam <- nlapply(desgn_mat_list, colnames)

  out <- nlapply(inter, function(i) {
    elmts <- strsplit(i, ":")[[1L]]

    if (!any(
      is.na(c(match(i, unlist(desgn_mat_listnam)),
              ivapply(elmts, match, unlist(desgn_mat_listnam))
      )
      ))
    ) {

      # find matrix and column containing the interaction term
      inter_match <- sapply(names(desgn_mat_list), function(k) {
        if (!is.na(match(i, desgn_mat_listnam[[k]])))
          match(i, desgn_mat_listnam[[k]])
      })


      # find matrices and columns of the elements
      elmt_match <- lapply(elmts, function(j) {
        sapply(names(desgn_mat_list), function(k) {
          if (!is.na(match(j, desgn_mat_listnam[[k]])))
            match(j, desgn_mat_listnam[[k]])
        })
      })


      structure(
        list(
          interterm = unlist(inter_match),
          elmts = unlist(elmt_match)
        ),
        interaction = i, elements = elmts,
        has_NAs = if (any(lvapply(desgn_mat_list, function(x) {
          any(is.na(x[, elmts[elmts %in% colnames(x)]]))
        }))) {
          TRUE
        } else {
          FALSE
        }
      )
    }})

  if (any(!lvapply(out, is.null))) {
    out[!lvapply(out, is.null)]
  }
}



# linear predictor -------------------------------------------------------------

# used in divide_matrices (2020-06-10)
get_linpreds <- function(fixed, random, data, models, auxvars = NULL,
                         analysis_type = NULL, warn = TRUE, refs) {
  # obtain the linear predictor columns and variable names for all models
  # involved
  # - fixed: list of fixed effects formulas
  # - random: list of random effects formulas
  # - data: a data.frame with the pre-processed data
  # - models: named vector of all model types
  # - auxvars: optional formula of auxiliary variables
  # - analysis_type: type of analysis, including family as attribute if glm(m)
  # - warn: logical; should warning messages be given

  # check if fixed is a list and otherwise convert it to a list
  fixed <- check_formula_list(fixed)

  # extract the id variable and clustering structure from the random effects
  # formula and data
  idvar <- extract_id(random, warn = warn)
  groups <- get_groups(idvar, data)

  # identify all variables involved and those variables that are covariates
  allvars <- all_vars(c(fixed, remove_grouping(random), auxvars))

  # in order to be able to include functions in the auxiliary variables,
  # extract the term labels from auxvars and build the formula used
  # to create the design matrices for the covariate models using these
  # term labels.
  auxterms <- if (!is.null(auxvars)) attr(terms(auxvars), "term.labels")

  covar_terms <- unique(c(all_vars(c(remove_lhs(fixed),
                                     remove_grouping(random))),
                          auxterms))



  # identify the levels of all variables
  # lvl <- cvapply(data[, allvars, drop = FALSE], check_varlevel, groups = groups,
  #               group_lvls = identify_level_relations(groups))
  lvl <- get_datlvls(data[, allvars, drop = FALSE], groups)

  group_lvls <- colSums(!identify_level_relations(groups))

  # make a subset containing only covariates
  subdat <- subset(data,
                   select = setdiff(allvars, unlist(extract_outcome(fixed))))

  contr_list <- lapply(refs, attr, "contr_matrix")

  # for each fixed effects (main model) formula, get the column names of the
  # design matrix of the fixed effects
  lp <- nlapply(fixed, function(fmla) {
    covars <- cvapply(attr(terms(remove_lhs(fmla)),
                          "variables")[-1L], deparse, width.cutoff = 500L)


    contr_list0 <- contr_list[intersect(covars, names(contr_list))]


    if (attr(fmla, "type") %in% c("clm", "clmm", "coxph", "JM")) {
      # for ordinal and cox models, exclude the intercept
      colnam <- colnames(
        model.matrix(fmla, data, contrasts.arg = contr_list0))[-1L]
      if (length(colnam) > 0L) colnam
    } else {
      colnames(model.matrix(fmla, data, contrasts.arg = contr_list0))
    }
  })


  #  for all models that are not specified in fixed
  #  - identify if an intercept is needed (no intercept for ordinal and cox)
  #  - generate a RHS formula
  for (out in names(models)[!names(models) %in% names(fixed)]) {

    nointercept <- models[out] %in% c("clmm", "clm", "coxph")

    # identify variables that have
    # - level higher than the level of the outcome, or
    # - the same level (note: the same level name, not just the same value in
    #   the hierarchy. This is important in case of crossed random effects
    #   where two levels may have the same value in the hierarchy, but then
    #   the model should only include covariates from the same level, but not
    #   from the crossed level).
    relvars <- group_lvls[lvl[colnames(subdat)]] > group_lvls[lvl[out]] |
      lvl[colnames(subdat)] == lvl[out]


    testdat <- subset(subdat, select = relvars & (colnames(subdat) != out))

    keep_terms <- lvapply(covar_terms, function(k) {
      check_effect <- try(model.frame(paste0("~", k), testdat), silent = TRUE)
      !inherits(check_effect, "try-error") &
        all_vars(formula(paste("~", k))) %in% names(testdat)
    })

    covar_terms <- covar_terms[keep_terms]

    fmla <- as.formula(
      paste0(out, " ~ ",
             switch(as.character(length(covar_terms) == 0L),
                    "TRUE" = "1",
                    "FALSE" = paste0(covar_terms, collapse = " + ")),
             if (nointercept) "-1"))


    # get the names of the columns of the corresponding design matrix
    lp[[out]] <- colnames(
      model.matrix(fmla, subdat,
                   contrasts.arg = contr_list[intersect(all_vars(remove_lhs(fmla)),
                                                        names(contr_list))]))

    # if the linear predictor is empty, create an empty object, to make the
    # subsequent code work in any case
    if (is.null(lp[[out]])) lp <- c(lp, setNames(list(NULL), out))

    subdat <- subset(subdat, select = -c(get(out)))
  }
  lp
}




get_nonprop_lp <- function(nonprop, dsgn_mat_lvls, data, refs, fixed, lp_cols) {
  # get the linear predictors of covariates with non-proportional effects in
  # cumulative logit (mixed) models

  # if there are no non-proportional effects (default, and always the case for
  # all other model types)
  if (is.null(nonprop)) {
    return(NULL)
  }

  if (is.null(names(nonprop))) {
    if (length(fixed) == 1L & inherits(nonprop, "formula")) {
      nonprop <- list(nonprop)
      names(nonprop) <- names(fixed)
    } else if (length(fixed) == 1L & inherits(nonprop, "list")) {
      names(nonprop) <- names(fixed)
    } else {
      errormsg("Please provide a named list of formulas to the argument %s,
              where the names refer to the response variables of the ordinal
              models to which the provided formulas correspond.",
               dQuote("nonprop"))
    }
  }


  lapply(names(nonprop), function(k) {
    propvars <- cvapply(names(unlist(unname(lp_cols[[k]]))), replace_dummy, refs)
    if (any(!all_vars(nonprop[[k]]) %in% propvars)) {
      errormsg(
        "All variables that have non-proportional effect (specified via the
        argument %s also need to be part of the main model formula.",
        dQuote("nonprop")
      )
    }
  })

  # get the list of contrast matrices from refs
  contr_list <- lapply(refs, attr, "contr_matrix")

  # for each element of nonprop (i.e., per ordinal outcome):
  nlapply(nonprop, function(fmla) {

    if (!inherits(fmla, "formula"))
      errormsg("Covariates with non-proportional effects should be specified as
               one-sided formula.")

    # select the correct subset of the contrast matrices
    contr_list0 <- contr_list[intersect(all_vars(fmla), names(contr_list))]
    # get the column names of the design matrix
    nam <- colnames(model.matrix(fmla, data = data,
                                 contrasts.arg = contr_list0))[-1L]

    # divide the names by the hierarchical level of the variable
    nlapply(unique(dsgn_mat_lvls), function(k) {
      intersect(nam, names(dsgn_mat_lvls)[dsgn_mat_lvls == k])
    })

  })
}
