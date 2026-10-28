#' Prepare list of arguments for model_imp()
#'
#' @param analysis_type Type of analysis to be performed (from `*_imp()`)
#' @param family `family` object or character string specifying the error
#'                distribution and link function.
#' @param formals List of formal arguments for the function.
#' @param call The matched call as returned by `match.call()`.
#' @param sframe An environment (typically from `sys.frame(sys.nframe())`)
#'
#' @returns A list of arguments prepared for `model_imp()`, including the
#'          analysis type, family, formulas, and other relevant parameters.
#' @keywords internal
#'

# TODO: add tests for this function and/or refactor further
# TODO: add type checks for main function arguments to create more meaningful
# error messages when arguments are (accidentally) mis-used. Example: wrong
# closing parenthesis in list of formulas shifted the second formula to the
# df_basehaz argument in JM_imp()
prep_arglist <- function(
  analysis_type,
  family = NULL,
  formals = formals(),
  call = match.call(),
  sframe = sys.frame(sys.nframe())
) {
  # collect all arguments (defaults + user-specified)
  arglist <- merge_call_args(formals, call, sframe)

  # check that data is provided as a data.frame
  if (!inherits(arglist$data, "data.frame")) {
    errormsg(
      "Please provide a %s to the argument %s.",
      sQuote("data.frame"),
      dQuote("data")
    )
  }

  # add the analysis type to the argument list
  arglist$analysis_type <- analysis_type

  # In case the a variable (containing a formula) was passed to formula or
  # fixed in *_imp(), overwrite the name of the variable in the original call
  # with the actual formula
  if (inherits(arglist$thecall$formula, "name")) {
    arglist$thecall$formula <- arglist$formula
  }
  if (inherits(arglist$thecall$fixed, "name")) {
    arglist$thecall$fixed <- arglist$fixed
  }

  # resolve family object
  thefamily <- resolve_family_obj(family)
  attr(arglist$analysis_type, "family") <- thefamily

  # normalize formula arguments into lists of formulas
  normalize_formula_args(arglist)
}

#' Merge call arguments with default formals
#'
#' @param formals List of formal arguments for `*_imp()`.
#' @param call The matched call from `*_imp()` as returned by `match.call()`.
#' @param sframe The environment within `*_imp()`
#'               (obtained from `sys.frame(sys.nframe())`)
#'
#' @returns A list of arguments combining defaults and user-specified values.
#' @keywords internal
#' @note Helper function for [JointAI::prep_arglist].
#'
merge_call_args <- function(formals, call, sframe) {
  arglist <- mget(names(formals), sframe)
  call_list <- as.list(call)[-1L]
  extra <- call_list[!names(call_list) %in% names(arglist)]

  # Arguments passed via `...` are evaluated where they were specified. Their
  # expressions in `call` may refer to local variables of a calling function
  # or to `..1`, `..2`, ... of a function that passes on its own `...`.
  if (exists("...", envir = sframe, inherits = FALSE)) {
    dots <- eval(quote(list(...)), sframe)
    dotnames <- intersect(names(extra), names(dots))
    extra[dotnames] <- dots[dotnames]
  }

  arglist <- c(arglist, extra)

  arglist$thecall <- call

  arglist
}


#' Normalize formula arguments in arglist
#'
#' @param arglist A list containing at least `formula`, `fixed`, and `random`
#'                elements.
#' @returns The updated `arglist` with formulas converted to lists.
#' @keywords internal
#' @note Helper function used in [JointAI::prep_arglist()].
#'
normalize_formula_args <- function(arglist) {
  for (arg in c("formula", "fixed", "random")) {
    val <- arglist[[arg]]

    # the following is needed for lme4 type formulas; random is then an empty
    # symbol/name which causes problems later on
    if (missing(val)) {
      arglist[[arg]] <- NULL
    }

    if (missing(val) || is.null(val) || is.list(val)) {
      # do nothing; otherwise NULL would be converted to a list by as.formula()
      # below!
      next
    } else if (is.symbol(val)) {
      evaluated <- try(eval(arglist[[arg]]), silent = TRUE)
      if (inherits(evaluated, "try-error")) {
        arglist[[arg]] <- NULL
      } else {
        arglist[[arg]] <- evaluated
      }
    } else {
      arglist[[arg]] <- check_formula_list(as.formula(val))
    }
  }
  arglist
}

#' Resolve family object
#'
#' Converts a family specification (character string, function, or family
#' object) to a family object.
#'
#' @param family Family object, character string, or function.
#'
#' @returns A family object or NULL.
#' @keywords internal
#' @note Helper function used in [JointAI::prep_arglist()].
#'

resolve_family_obj <- function(family) {
  if (is.null(family)) {
    return(NULL)
  }

  thefamily <- if (is.character(family)) {
    get(family, mode = "function", envir = parent.frame())()
  } else if (is.function(family)) {
    family()
  } else if (inherits(family, "family")) {
    family
  } else {
    errormsg("Unsupported \"family\" specification.")
  }

  allowed_links <- c("identity", "log", "logit", "probit", "cloglog", "inverse")
  if (!thefamily$link %in% allowed_links) {
    errormsg("%s is not an allowed link function.", dQuote(thefamily$link))
  }
  return(thefamily)
}

#' Check whether fixed or formula contains a random effects specification
#'
#' Checks if the objects provided to the `formula` and `fixed` arguments contain
#' a random effects specification. This function is used in random effects
#' models.
#' In case the combined fixed and random effects formula is part of the `fixed`
#' element, it is moved into the `formula` element.
#'
#' @param arglist A list containing 'fixed', 'random', and 'formula' elements.
#'
#' @returns The updated arglist.arglist
#' @keywords internal
#'
check_fixed_random <- function(arglist) {
  if (!is.null(arglist$random)) {
    return(arglist)
  } else if (!is.null(arglist$formula)) {
    can_split <- try(split_formula_list(arglist$formula))
    if (inherits(can_split, 'try-error')) {
      errormsg(
        "I cannot split the %s into a fixed and random effects part.",
        dQuote("formula")
      )
    } else if (is.null(can_split$random[[1]])) {
      errormsg(
        "I cannot extract a random effects formula from %s.",
        dQuote("formula")
      )
    }
  } else if (!is.null(arglist$fixed)) {
    can_split <- try(split_formula_list(arglist$fixed), silent = TRUE)
    if (inherits(can_split, "try-error")) {
      errormsg(
        "I cannot split %s into a fixed and random effects part.",
        dQuote("fixed")
      )
    } else if (is.null(can_split$random[[1]])) {
      errormsg(
        "I cannot extract a random effects formula from %s.",
        dQuote("fixed")
      )
    } else {
      arglist$formula <- arglist$fixed
      arglist$fixed <- NULL
      arglist$random <- NULL
    }
  }

  if (length(arglist$fixed) == 0L && length(arglist$formula) == 0L) {
    errormsg("No fixed effects structure specified.")
  }

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
#'

# used in model_imp (2020-06-09)

check_vars_in_data <- function(
  datanames,
  fixed = NULL,
  random = NULL,
  auxvars = NULL,
  timevar = NULL
) {
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
check_classes <- function(
  data,
  fixed = NULL,
  random = NULL,
  auxvars = NULL,
  timevar = NULL,
  mess = TRUE
) {
  vars <- unique(all_vars(fixed, remove_grouping(random), auxvars, timevar))
  classes <- lapply(data[vars], class)
  known_classes <- c("numeric", "ordered", "factor", "logical", "integer")

  # Throw an error for variables of unknown classes. Variables are grouped by
  # their (complete) class, so that a variable with several classes is named
  # only once (#17).
  unknown <- Filter(function(cl) !all(cl %in% known_classes), classes)

  if (length(unknown) > 0L) {
    class_strings <- cvapply(unknown, paste, collapse = ", ")
    unknown_classes <- cvapply(
      split(names(class_strings), class_strings),
      function(x) {
        paste0(
          dQuote(class_strings[x[1L]]),
          " (variables: ",
          paste0(x, collapse = ", "),
          ")"
        )
      }
    )

    errormsg(
      "Variables of type %s can not be handled.",
      paste(unknown_classes, collapse = ", ")
    )
  }
}


#' Check for empty factor levels
#'
#' CHECKS if there are empty factor levels in any of the variables used in the
#' model.
#'
#' @section Note:
#' Originally, the function also dropped these levels. Then, I (accidentally?)
#' had commented out a line so that no check was performed.
#' Now, only create a warning if there are empty levels, but do not drop them.
#'
#' used in model_imp (2020-06-09)
#'
#' @param data a `data.frame`
#' @param allvars a character vector (of all variable names used in the model)
#' @param warn logical, if `TRUE` warnings are printed
#'
#' @returns the `data.frame` (unchanged)
#' @keywords internal
#'
drop_levels <- function(data, allvars, warn = TRUE, mess = NULL) {
  if (!is.null(mess)) {
    warning(
      "Argument 'mess' is deprecated in 'drop_levels()' and ignored.",
      call. = FALSE
    )
  }

  data_orig <- data
  data[allvars] <- droplevels(data[allvars])

  if (warn) {
    lvl1 <- sapply(data_orig[allvars], function(x) length(levels(x)))
    lvl2 <- sapply(data[allvars], function(x) length(levels(x)))

    if (any(lvl1 != lvl2)) {
      warnmsg(
        'The variable(s) %s has/have empty levels.
              Use `droplevels()` on your input data to remove empty levels.',
        paste_and(dQuote(names(lvl1)[which(lvl1 != lvl2)]))
      )
    }
  }
  return(data)
}


#' Replace ":" with "_" in a string
#'
#' Cleans up factor levels (or other strings) by replacing ":" with "_" to avoid
#' issues with the current implementation of identifying interactions (which looks
#' for ":" in model terms).
#'
#' used in this file (in convert_variables()) (2020-06-09)
#'
#' @param string a character string
#'
#' @returns the cleaned character string
#' @keywords internal
#'
clean_names <- function(string) {
  gsub(":", "_", string)
}


#' Convert variables
#'
#' Cleans up the data by
#' * changing `NaN` to `NA`
#' * converting continuous variables with just two values to factor
#' * converting logical variables to a factor
#' * cleaning factor labels (using `make.names()`)
#'
#' used in model_imp (2025-09-07)
#'
#' @param data a `data.frame`
#' @param allvars a character vector of the relevant variables in `data`
#' @param mess logical, if `TRUE` messages are printed
#'
#' @returns the cleaned `data.frame`
#' @keywords internal
#'
convert_variables <- function(data, allvars, mess = TRUE) {
  data_orig <- data

  for (k in allvars) {
    data[[k]] <- replace_nan_with_na(data[[k]])
    data[[k]] <- two_value_to_factor(data[[k]])

    # remove ":" from factor labels (otherwise dummies get confused with
    # interaction terms)
    if (is.factor(data[, k])) {
      levels(data[, k]) <- clean_names(levels(data[, k]))
    }
  }

  if (mess) {
    compare_data_structure(data_orig, data)
  }

  return(data)
}


#' Replace NaN values with NA
#'
#' @param x a vector (also works for matrices and scalars)
#'
#' @returns the vector (or object like the input) with `NaN` values replaced by
#'          `NA`
#' @keywords internal
#'
replace_nan_with_na <- function(x) {
  x[is.nan(x)] <- NA
  x
}

#' Convert two-value vectors to factors
#'
#' @param x a vector
#'
#' @returns the vector converted to a factor if it has exactly two unique
#'         (non-missing) values and is not already a factor; otherwise the input
#' @keywords internal
#'
two_value_to_factor <- function(x) {
  if (!inherits(x, 'factor') & length(unique(na.omit(x))) == 2) {
    x <- factor(x)
  }
  x
}

#' Compare the structure of two data.frames
#'
#' @param data1 a `data.frame`
#' @param data2 a `data.frame`
#'
#' @returns nothing, but prints messages if the class of any variable
#'         changed or if the levels of any factor variable changed
#' @keywords internal
#'
compare_data_structure <- function(data1, data2) {
  class_change <- mapply(
    function(x1, x2) any(x1 != x2),
    x1 = lapply(data1, class),
    x2 = lapply(data2, class)
  )
  class_change <- Filter(isTRUE, class_change)

  level_change <- mapply(
    function(x1, x2) !isTRUE(all.equal(x1, x2)),
    x1 = lapply(data1, levels),
    x2 = lapply(data2, levels)
  )
  level_change <- Filter(isTRUE, level_change)

  if (any(class_change)) {
    msg(
      "The variable(s) %s was/were changed to %s.",
      paste_and(dQuote(names(class_change))),
      paste_and(dQuote(sapply(data2[names(class_change)], class)))
    )
  }

  if (any(level_change)) {
    for (k in names(level_change)) {
      msg(
        "The levels of the variable %s was/were changed to %s.",
        dQuote(k),
        paste0(levels(data2[[k]]), collapse = ", ")
      )
    }
  }
}


#' Convert labelled variables
#'
#' Variables of class `"labelled"` (Hmisc, haven < 2.0.0) or `"haven_labelled"`
#' (haven >= 2.0.0), e.g., from data imported from SPSS, are converted:
#' - Variables with value labels (attribute `"labels"`) become unordered
#'   factors. Observed values without a label become levels named by their
#'   value; labels of values that do not occur in the data are not used.
#' - Variables without value labels keep their values; only the labelled
#'   class is removed.
#'
#' The variable label (attribute `"label"`) is kept. SPSS user-defined missing
#' values (class `"haven_labelled_spss"`) are not treated as missing.
#'
#' When `ref_data` is given (e.g., the data of a fitted model, when `data` is
#' new data for prediction), factors get the levels of the corresponding
#' factor in `ref_data`, and values without such a level become `NA` (with a
#' warning).
#'
#' @param data a `data.frame`
#' @param allvars vector of names of the variables used in the model
#' @param mess logical, if `TRUE` a message lists the variables that were
#'   converted to factors
#' @param ref_data optional `data.frame` with the reference factor levels
#'
#' @returns the `data.frame` with the converted variables
#' @keywords internal
#'
convert_labelled <- function(data, allvars, mess = TRUE, ref_data = NULL) {
  allvars <- unique(allvars)
  is_labelled <- lvapply(
    data[allvars],
    inherits,
    c("labelled", "haven_labelled")
  )

  to_factor <- character(0L)
  for (k in allvars[is_labelled]) {
    if (!is.null(attr(data[[k]], "labels"))) {
      ref_levels <- if (is.factor(ref_data[[k]])) levels(ref_data[[k]])
      x <- labelled_to_factor(data[[k]], levels = ref_levels)

      lost <- is.na(x) & !is.na(unclass(data[[k]]))
      if (!is.null(ref_levels) && any(lost)) {
        warnmsg(
          "Some values of %s do not correspond to a category in the data
          used to fit the model and were set to missing.",
          dQuote(k)
        )
      }

      data[[k]] <- x
      to_factor <- c(to_factor, k)
    } else {
      data[[k]] <- remove_labelled_class(data[[k]])
    }
  }

  if (mess && length(to_factor) > 0L) {
    msg(
      "The variable(s) %s has/have value labels and was/were converted to
      (unordered) factor(s).",
      paste_and(dQuote(to_factor))
    )
  }

  data
}


#' Convert a variable with value labels to a factor
#'
#' @param x a labelled vector with attribute `"labels"` (a named vector of
#'   values)
#' @param levels optional character vector of factor levels. If `NULL`, the
#'   levels are the (labels of the) observed values, sorted by value.
#'
#' @returns an unordered factor with the value labels as levels, keeping the
#'   `"label"` attribute of `x`
#' @keywords internal
#'
labelled_to_factor <- function(x, levels = NULL) {
  labels <- attr(x, "labels")
  var_label <- attr(x, "label")

  values <- x
  attributes(values) <- NULL

  # the label of each value, or the value itself if it has no label
  value_names <- function(v) {
    out <- as.character(v)
    idx <- match(v, labels)
    out[!is.na(idx)] <- names(labels)[idx[!is.na(idx)]]
    out
  }

  if (is.null(levels)) {
    levels <- unique(value_names(sort(unique(values[!is.na(values)]))))
  }

  out <- factor(value_names(values), levels = levels)
  attr(out, "label") <- var_label
  out
}


#' Remove the labelled class from a vector
#'
#' @param x a vector of class `"labelled"` or `"haven_labelled"`
#'
#' @returns `x` without the labelled classes (and without classes that only
#'   describe the base type), so that e.g. a numeric vector is plain numeric
#'   again; other attributes are kept
#' @keywords internal
#'
remove_labelled_class <- function(x) {
  cls <- setdiff(
    oldClass(x),
    c(
      "labelled",
      "haven_labelled",
      "vctrs_vctr",
      "double",
      "integer",
      "character",
      "logical",
      "numeric"
    )
  )
  oldClass(x) <- if (length(cls) > 0L) cls else NULL
  x
}


#' Run all data related checks
#'
#' Wrapper function to check that
#' - all used variables are present in the `data`
#' - converts labelled variables (e.g., from SPSS) to factors or plain vectors
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
  data <- as.data.frame(data)

  check_vars_in_data(
    names(data),
    fixed = fixed,
    random = random,
    auxvars = auxvars,
    timevar = timevar
  )

  var_labels <- lapply(data, attr, "label", exact = TRUE)

  # labelled variables (e.g., from haven or Hmisc) must be converted before the
  # class check (#17)
  data <- convert_labelled(
    data = data,
    allvars = all_vars(fixed, remove_grouping(random), auxvars),
    mess = mess
  )

  check_classes(data, fixed = fixed, random = random, auxvars = auxvars)

  data <- drop_levels(
    data = data,
    allvars = all_vars(fixed, random, auxvars),
    warn = warn
  )

  # convert variable with 2 different values (continuous, character or logical)
  # to factors
  data <- convert_variables(
    data = data,
    allvars = all_vars(fixed, random, auxvars),
    mess = mess
  )

  # some steps (e.g., droplevels()) remove the variable labels; restore them
  data <- restore_var_labels(data, var_labels)

  data
}


#' Restore variable labels
#'
#' @param data a `data.frame`
#' @param var_labels a named list of variable labels (the `"label"` attributes
#'   of the variables in the original data, `NULL` if there was none)
#'
#' @returns `data`, where variables that lost their `"label"` attribute have it
#'   again
#' @keywords internal
#'
restore_var_labels <- function(data, var_labels) {
  for (k in intersect(names(var_labels), names(data))) {
    if (!is.null(var_labels[[k]]) && is.null(attr(data[[k]], "label"))) {
      attr(data[[k]], "label") <- var_labels[[k]]
    }
  }
  data
}
