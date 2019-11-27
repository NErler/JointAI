# check all variables are in the data ------------------------------------------
check_vars_in_data <- function(datanames, fixed = NULL, random = NULL, auxvars = NULL) {

  # make vector of any variable occuring in the formulas
  allvars <- unique(c(all_vars(fixed),
                      all_vars(random),
                      all_vars(auxvars))
  )

  if (any(!allvars %in% datanames)) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
                  paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", ")),
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
      ifelse(length(c(converted1) == 1,
             'The variable %s was converted to a factor.',
             'The variables %s were converted to factors.'),
      paste0(dQuote(converted1), collapse = ", "))))

  return(data)
}
