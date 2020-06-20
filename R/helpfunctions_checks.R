# helper functions ------------------------------------------------------------

# used in this file (in convert_variables()) (2020-06-09)
clean_names <- function(string) {
  gsub(":", "_", string)
}


# used in model_imp (2020-06-09)
check_vars_in_data <- function(datanames, fixed = NULL, random = NULL,
                               auxvars = NULL, timevar = NULL) {

  # make vector of any variable occurring in the formulas
  allvars <- unique(c(all_vars(c(fixed, random, auxvars)),
                      timevar)
  )

  if (any(!allvars %in% datanames))
    errormsg("Variable(s) %s were not found in the data." ,
             paste(dQuote(allvars[!allvars %in% datanames]), collapse = ", "))
}


# used in model_imp (2020-06-09)
check_classes <- function(data, fixed = NULL, random = NULL, auxvars = NULL,
                          timevar = NULL, mess = TRUE) {

  # check classes of covariates
  vars <- unique(c(all_vars(c(fixed, remove_grouping(random), auxvars)),
                   timevar))

  covars <- unique(c(all_vars(c(remove_LHS(fixed), remove_grouping(random),
                                auxvars)),
                     timevar))

  classes <- unlist(sapply(data[vars], class))


  # error for variables of unknown classes
  if (any(!classes %in% c('numeric', 'ordered', 'factor', 'logical',
                          'integer'))) {
    w <- which(!classes %in% c('numeric', 'ordered', 'factor', 'logical',
                               'integer'))

    pr <- sapply(split(classes[w], classes[w]), function(x) {
      paste0(dQuote(unique(x)), ' (variables: ',
             paste0(names(x), collapse = ", "), ")")
    })

    errormsg("Variables of type %s can not be handled.",
             paste(pr, collapse = ', '))
  }
}



# used in model_imp (2020-06-09
drop_levels <- function(data, allvars, mess = TRUE) {

  data_orig <- data
  data[allvars] <- droplevels(data[allvars])

  if (mess) {
    lvl1 <- sapply(data_orig[allvars], function(x) length(levels(x)))
    lvl2 <- sapply(data[allvars], function(x) length(levels(x)))

    if (any(lvl1 != lvl2))
      msg('Empty levels were dropped from %s.',
          dQuote(names(lvl1)[which(lvl1 != lvl2)]))
  }
  return(data)
}



# used in model_imp (2020-06-09)
convert_variables <- function(data, allvars, mess = TRUE, data_orig = NULL) {
# clean up data:
# * change NaN to NA
# * convert continuous variables with just two values to factor
# * convert logical variables to a factor
# * convert factor labels (exclude special characters)

  converted1 <- c()

  # convert binary continuous variable to factor
  for (k in allvars) {

    # replace NaN values with NA
    data[is.nan(data[, k]), k] <- NA

    # set continuous variables with just two values to binary
    if (all(class(data[, k]) != 'factor') &
        length(unique(na.omit(data[, k]))) == 2 & is.null(data_orig)) {
      data[, k] <- factor(data[, k])
      converted1 <- c(converted1, k)
    } else if (!is.null(data_orig)) {
      if (class(data_orig[, k]) == 'factor' &
          all(class(data[, k]) != 'factor')) {
        data[, k] <- factor(data[, k], levels = levels(data_orig[, k]))
        converted1 <- c(converted1, k)
      }
    }

    # set logical variables to factors
    if ('logical' %in% class(data[, k])) {
      data[, k] <- factor(data[, k])
      converted1 <- c(converted1, k)
    }

    # clean factor labels
    if (is.factor(data[, k])) {
      levels(data[, k]) <- clean_names(levels(data[, k]))
    }
  }

  if (mess & length(c(converted1)) > 0)
    msg(
      ifelse(length(c(converted1)) == 1,
             'The variable %s was converted to a factor.',
             'The variables %s were converted to factors.'),
      paste0(dQuote(converted1), collapse = ", "))

  return(data)
}


