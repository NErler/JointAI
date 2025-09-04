# helper functions ------------------------------------------------------------

# used in this file (in convert_variables()) (2020-06-09)
clean_names <- function(string) {
  gsub(":", "_", string)
}


# other functions --------------------------------------------------------------
prep_arglist <- function(analysis_type, family = NULL, formals = formals(),
                         call = match.call(), sframe = sys.frame(sys.nframe())) {
  arglist <- mget(names(formals), sframe)

  thiscall <- as.list(call)[-1L]
  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])

  arglist$thecall <- call

  if (inherits(arglist$thecall$formula, "name")) {
    # arglist$thecall$formula <- eval(arglist$thecall$formula)
    arglist$thecall$formula <- arglist$formula
  }
  if (inherits(arglist$thecall$fixed, "name")) {
    # arglist$thecall$fixed <- eval(arglist$thecall$fixed)
    arglist$thecall$fixed <- arglist$fixed
  }


  if (!inherits(arglist$data, 'data.frame'))
    errormsg("Please provide a %s to the argument %s.",
             sQuote('data.frame'), dQuote('data'))

  # analysis type
  arglist$analysis_type <- analysis_type

  # family
  if (!is.null(family)) {
    if (is.character(family)) {
      family <- get(family, mode = "function", envir = parent.frame())
      thefamily <- family()
    } else if (is.function(family)) {
      thefamily <- family()
    } else if (inherits(family, "family")) {
      thefamily <- family
    }

    if (!thefamily$link %in%
        c("identity", "log", "logit", "probit", "log", "cloglog", "inverse"))
      errormsg("%s is not an allowed link function.", dQuote(thefamily$link))

    attr(arglist$analysis_type, "family") <- thefamily
  }

  # convert formulas (formula, fixed, random) to lists
  for (arg in c('formula', 'fixed', 'random')) {
    if (is.null(arglist[[arg]]) | is.list(arglist[[arg]])) {

    } else if (is.symbol(arglist[[arg]])) {
      arglist[[arg]] <- try(eval(arglist[[arg]]), silent = TRUE)
      if (inherits(arglist[[arg]], "try-error")) {
        arglist[[arg]] <- NULL
      }
    } else {
      arglist[[arg]] <- check_formula_list(as.formula(arglist[[arg]]))
    }
  }

  arglist
}



check_fixed_random <- function(arglist) {

  # if there is a "fixed" effects formula, but no "random" , check if "fixed"
  # contains the fixed and random effects
  if (!is.null(arglist$fixed) & is.null(arglist$random)) {
    can_split <- try(split_formula_list(arglist$fixed))

    if (!inherits(can_split, 'try-error') & !is.null(can_split$random[[1]])) {
      arglist$formula <- arglist$fixed
      arglist$fixed <- NULL
      arglist$random <- NULL
    }
  } else if (!is.null(arglist$formula) & is.null(arglist$random)) {
    can_split <- try(split_formula_list(arglist$formula))

    if (inherits(can_split, 'try-error')) {
      errormsg("I cannot split the %s into a fixed and random effects part.",
               dQuote("formula"))
    } else if (is.null(can_split$random[[1]])) {
      errormsg("I cannot extract a random effects formula from %s.",
               dQuote("formula"))
    }
  }


  if (is.null(arglist$fixed) & length(arglist$formula) == 0)
    errormsg("No fixed effects structure specified.")

  if (is.null(arglist$random) & length(arglist$formula) == 0)
    errormsg("No random effects structure specified.")

  arglist
}



#' Check that all variables in formulas are in the data
#'
#' @param datanames a character vector (of all variable names in the data)
#' @param fixed the fixed effects formula (or list of formulas)
#' @param random the random effects formula (or list of formulas)
#' @param auxvars one-sided formula of auxiliary variables
#' @param timevar a character string (name of the time variable, used in joint models)
#'
#' @returns nothing, but throws an error if a variable is missing
#' @keywords internal
#' used in model_imp (2020-06-09)
#'
check_vars_in_data <- function(datanames, fixed = NULL, random = NULL,
                               auxvars = NULL, timevar = NULL) {

  # make vector of any variable occurring in the formulas
  allvars <- all_vars(fixed, random, auxvars, timevar)

  if (any(!allvars %in% datanames)) {
    errormsg(
      "Variable(s) %s were not found in the data.",
      paste(dQuote(allvars[!allvars %in% datanames]), collapse = ", ")
    )
  }
}


#' Check classes of all variables used in the model
#'
#' Runs a check that all variables that are used in the model are of a known
#' class (numeric, ordered, factor, logical, integer) so that type-appropriate
#' models can be specified.
#' Note: This function does not check the type of grouping variables, which
#'       may be character strings.
#'
#' used in model_imp (2020-06-09)
#'
#' @param data a `data.frame`
#' @param fixed a `formula`
#' @param random a `formula`
#' @param auxvars a one-sided `formula`
#' @param timevar a character string (name of the time variable, used in joint
#'                models)
#' @param mess logical, if `TRUE` messages are printed
#'
#' @returns nothing, but throws an error if a variable is of an unknown class
#' @keywords internal
#'
check_classes <- function(data,
                          fixed = NULL,
                          random = NULL,
                          auxvars = NULL,
                          timevar = NULL,
                          mess = TRUE) {
  # check classes of covariates
  vars <- all_vars(fixed, remove_grouping(random), auxvars, timevar)

  classes <- unlist(sapply(data[vars], class))
  known_classes <- c("numeric", "ordered", "factor", "logical", "integer")

  # Throw an error for variables of unknown classes
  if (any(w <- which(!classes %in% known_classes))) {

    unknown_classes <- sapply(split(classes[w], classes[w]), function(x) {
      paste0(
        dQuote(unique(x)),
        " (variables: ", paste0(names(x), collapse = ", "), ")"
      )
    })

    errormsg(
      "Variables of type %s can not be handled.",
      paste(unknown_classes, collapse = ", ")
    )
  }
}



# used in model_imp (2020-06-09
drop_levels <- function(data, allvars, warn = TRUE) {

  data_orig <- data
  data[allvars] <- droplevels(data[allvars])

  if (warn) {
    lvl1 <- sapply(data_orig[allvars], function(x) length(levels(x)))
    lvl2 <- sapply(data[allvars], function(x) length(levels(x)))

    if (any(lvl1 != lvl2))
      warnmsg('The variable(s) %s has/have empty levels.
              Use `droplevels()` on your input data to remove empty levels.',
          paste_and(dQuote(names(lvl1)[which(lvl1 != lvl2)])))
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

  converted1 <- NULL

  # convert binary continuous variable to factor
  for (k in allvars) {

    # replace NaN values with NA
    data[is.nan(data[, k]), k] <- NA

    # set continuous variables with just two values to binary
    if (!inherits(data[, k], 'factor') &
        length(unique(na.omit(data[, k]))) == 2 & is.null(data_orig)) {
      data[, k] <- factor(data[, k])
      converted1 <- c(converted1, k)
    } else if (!is.null(data_orig)) {
      if (inherits(data_orig[, k], 'factor') &
          !inherits(data[, k], 'factor')) {
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



#' Run all data related checks
#'
#' Wrapper function to check that
#' - all used variables are present in the `data`
#' - that the classes of the variables are of a type for which default model
#'   types are defined
#' - checks for empty variable levels
#' - converts binary continuous variables and logical variables to factors
#'
#' used in `model_imp()` (2025-09-04)
#' @param data a `data.frame`
#' @param fixed a `formula` (or list of formulas)
#' @param random a one-sided `formula` (or list of one-sided formulas)
#' @param auxvars a one-sided `formula`
#' @param timevar a character string (name of the time variable, used in joint
#'               models)
#' @param mess logical, if `TRUE` messages are printed
#' @param warn logical, if `TRUE` warnings are printed
#'
#' @returns the cleaned `data.frame`
#' @keywords internal
#'
check_data <- function(data, fixed, random, auxvars, timevar, mess, warn) {
  # run all data related checks

  check_vars_in_data(names(data), fixed = fixed, random = random,
                     auxvars = auxvars, timevar = timevar)

  # check classes of covariates
  check_classes(data, fixed = fixed, random = random, auxvars = auxvars)

  # drop empty levels
  data <- drop_levels(data = data,
                      allvars = all_vars(fixed, random, auxvars),
                      warn = warn)


  # convert continuous variable with 2 different values and logical variables
  # to factors
  data <- convert_variables(data = data,
                            allvars = all_vars(fixed, random, auxvars),
                            mess = mess)

  data
}
