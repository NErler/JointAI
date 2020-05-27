# helper functions ------------------------------------------------------------
clean_names <- function(string) {
  gsub(":", "_", string)
}


# check all variables are in the data ------------------------------------------
check_vars_in_data <- function(datanames, fixed = NULL, random = NULL, auxvars = NULL) {

  # make vector of any variable occuring in the formulas
  allvars <- unique(c(all_vars(fixed),
                      all_vars(random),
                      all_vars(auxvars))
  )

  if (any(!allvars %in% datanames)) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
                  paste(dQuote(allvars[!allvars %in% datanames]), collapse = ", ")),
         call. = FALSE)
  }
}



# check classes of covariates ----------------------------------------------
check_classes <- function(data, fixed = NULL, random = NULL, auxvars = NULL,
                          mess = TRUE) {

  vars <- unique(c(all_vars(fixed),
                   all_vars(remove_grouping(random)),
                   all_vars(auxvars)))

  covars <- unique(c(all_vars(remove_LHS(fixed)),
                     all_vars(remove_grouping(random)),
                     all_vars(auxvars)))

  classes <- unlist(sapply(data[vars], class))


  if (any(unlist(sapply(data[covars], class)) == "ordered") & mess) {
    message("Note: Ordered factors are included as dummy variables into the
            linear predictor (not as orthogonal polynomials).")
  }

  if (any(!classes %in% c('numeric', 'ordered', 'factor', 'logical', 'integer'))) {
    w <- which(!classes %in% c('numeric', 'ordered', 'factor', 'logical', 'integer'))

    pr <- sapply(split(classes[w], classes[w]), function(x) {
      paste0(dQuote(unique(x)), ' (variables: ', paste0(names(x), collapse = ", "), ")")
    })

    stop(gettextf("Variables of type %s can not be handled.",
                  paste(pr, collapse = ', ')), call. = FALSE)
  }
}





# drop empty levels ------------------------------------------------------------
drop_levels <- function(data, allvars, mess = TRUE) {
  data_orig <- data
  data[allvars] <- droplevels(data[allvars])

  if (mess) {
    lvl1 <- sapply(data_orig[allvars], function(x) length(levels(x)))
    lvl2 <- sapply(data[allvars], function(x) length(levels(x)))

    if (any(lvl1 != lvl2)) {
      message(gettextf('Empty levels were dropped from %s.',
                       dQuote(names(lvl1)[which(lvl1 != lvl2)])))
    }
  }
  return(data)
}


# convert variables to factors --------------------------------------------------
convert_variables <- function(data, allvars, mess = TRUE) {

  converted1 <- c()

  # convert binary continuous variable to factor
  for (k in allvars) {

    data[is.nan(data[, k]), k] <- NA

    if (all(class(data[, k]) != 'factor') & length(unique(na.omit(data[, k]))) == 2) {
      data[, k] <- factor(data[, k])
      converted1 <- c(converted1, k)
    }

    if ('logical' %in% class(data[, k])) {
      data[, k] <- factor(data[, k])
      converted1 <- c(converted1, k)
    }

    if (is.factor(data[, k])) {
      levels(data[, k]) <- clean_names(levels(data[, k]))
    }
  }

  if (mess & length(c(converted1)) > 0)
    message(gettextf(
      ifelse(length(c(converted1)) == 1,
             'The variable %s was converted to a factor.',
             'The variables %s were converted to factors.'),
      paste0(dQuote(converted1), collapse = ", ")))

  return(data)
}

reformat_longsurvdata <- function(data, fixed, random, timevar, idvar) {

  groups <- get_groups(idvar, data)
  group_lvls <- colSums(!identify_level_relations(groups))


  # survinfo <- lapply(sapply(fixed, extract_LHS)[grepl("^Surv\\(", fixed)], idSurv)
  survinfo <- extract_outcome(fixed)[grepl("^Surv\\(", fixed)]

  datlvls <- sapply(data, check_varlevel, groups = groups,
                    group_lvls = identify_level_relations(groups))

  # if there are multiple survival variables and some time-varying variables
  if (length(survinfo) > 0 & any(datlvls[unlist(survinfo)] != 'levelone')) {

    surv_lvls <- sapply(survinfo, function(x) {
      lvls <- datlvls[unlist(x)]
      if (length(unique(lvls)) > 1)
        stop('The event time and status do not have the same level.')

      unique(lvls)
    })

    longlvls <- names(group_lvls)[group_lvls < min(group_lvls[surv_lvls])]

    haslong <- sapply(names(survinfo), function(k) {
      covar_lvls <- datlvls[all_vars(remove_LHS(fixed[[k]]))]
      any(covar_lvls %in% longlvls)
    })

    if (any(haslong)) {

      if (is.null(timevar))
        stop(gettextf("For survival models with time-varying covariates the
                      argument %s needs to be specified.", dQuote("timevar")))

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


