#' Ensure object is a (list of) formula(s)
#'
#' Check if an object is NULL, a formula, or a list of formulas and (optionally)
#' convert it to a list of formulas. If the input is of unknown type or if it
#' is a list that has entries that are neither `formula` nor `NULL`, an error
#' is thrown.
#'
#' Internal function; used in many help functions, get_refs, *_imp, predict
#' (2022-02-05)
#'
#' @param formula An object expected to be either a formula, a list of formulas,
#'                or `NULL`.
#' @param convert Logical; if `TRUE`, a single formula is wrapped in a list.
#' @return A named `list` of `formula` (and/or `NULL`) objects, or `NULL`. If
#'        `convert` is `FALSE`, a single formula is returned as-is.
#' @keywords internal

check_formula_list <- function(formula, convert = TRUE) {

  if (is.null(formula)) {
    return(NULL)
  }

  # if formula is a formula, turn it into a list
  if (inherits(formula, "formula")) {
    if (convert) {
      formula <- list(formula)
    } else {
      return(formula)
    }
  }

  if (inherits(formula, "list")) {
    # check if all elements are either formulas or NULL
    fmla_elmt <- lvapply(formula, inherits, "formula")
    null_elmt <- lvapply(formula, is.null)

    if (!all(fmla_elmt | null_elmt)) {
      errormsg("At least one element of the provided object is not of class
             %s.", dQuote("formula"))
    }
  } else {
    errormsg(
      "The provided object is not of class %s nor is it a %s.",
      dQuote("formula"), dQuote("list")
    )
  }

  formula
}


#' Combine fixed and random effects formulas
#'
#' A function to combine nlme-style fixed and random effects formulas into
#' lme4 style formulas.
#'
#' Internal function.
#' Lists of formulas can be named or unnamed.
#' Uses `combine_formulas()`.
#'
#' @param fixed a fixed effects formula or list of such formulas
#' @param random a random effects formula (only RHS) or list of such formulas
#' @param warn logical; should the warning(s) be printed
#'
#' @keywords internal
#'

combine_formula_lists <- function(fixed, random, warn = TRUE) {

  # check if the input objects are lists and convert them to lists otherwise
  fixed <- check_formula_list(fixed)
  random <- check_formula_list(random)

  # check if there are any random effects formulas with names that do not
  # appear in the list of fixed effects formulas (if there any names)
  if (any(!names(random) %in% names(fixed))) {
    errormsg("There are random effects formulas for outcomes for which no fixed
             effects formula is specified.")
  }

  if (length(random) > length(fixed)) {
    errormsg("There are more random effects formulas than fixed effects
                 formulas.")
  }

  if ((!is.null(random) & is.null(names(random)) & length(fixed) > 1L) & warn) {
    warnmsg("I assume that the order of the fixed and random effects formulas
            matches each other.")
  }

  # if fixed and random have names, make sure they are in the same order by
  # sorting the elements of random
  if (!is.null(names(fixed)) & !is.null(names(random))) {
    random <- random[names(fixed)]
  }
  # if fixed is longer than random the previous step will have introduced NULL
  # elements in random (with names <NA>) so that they now have the same length

  # if fixed and random are not properly named and random is shorter than fixed,
  # random has to be filled up with NULL elements
  if (length(random) < length(fixed)) {
    random <- c(random, replicate(length(fixed) - length(random), NULL))
  }

  # overwrite names of random with those of fixed
  names(random) <- names(fixed)


  Map(combine_formulas, fixed, random)
}



#' Combine a fixed and random effects formula
#'
#' Combine a single fixed and random effects formula by pasting them together.
#'
#' Internal function, used in `combine_formula_lists()`.
#'
#' @param fixed fixed effects formula (two-sided `formula` object)
#' @param random random effects formula (one-sided `formula` object)
#' @keywords internal
#'
combine_formulas <- function(fixed, random) {
  fmla <- paste(
    c(
      deparse(fixed, width.cutoff = 500L),
      if (!is.null(random)) {
        paste0(
          gsub("~", "(", deparse(random, width.cutoff = 500L)),
          ")"
        )
      }
    ),
    collapse = " + "
  )

  as.formula(fmla)
}





#' Remove the left hand side of a (list of) formula(s)
#'
#' Internal function; used in divide_matrices, get_models and help functions
#'  (2022-02-05)
#'
#' @param formula a formula object or a list of formula objects
#'
#' @returns A `formula` object or a `list` of `formula` objects.
#'
#' @keywords internal
#'
remove_lhs <- function(formula) {
  formula <- check_formula_list(formula, convert = FALSE)

  if (is.null(formula)) {
    return(NULL)
  }

  if (inherits(formula, "list")) {
    lapply(formula, remove_lhs)
  } else {
    formula(delete.response(terms(formula)))
  }
}




#' Extract the left hand side of a formula
#'
#' Extracts the left hand side from a `formula` object and returns it as
#' character string.
#'
#' Internal; used in various help functions (2022-02-05)
#'
#' @param formula a `formula` object (NOT a `list` of formulas)
#'
#' @returns A character string.
#'
#' @keywords internal
#'
extract_lhs_string <- function(formula) {
  if (is.null(formula)) {
    return(NULL)
  }

  # check that formula is a formula object
  if (!inherits(formula, "formula")) {
    errormsg("The provided formula is not a %s object.", dQuote("formula"))
  }

  # check that the formula has a LHS
  if (attr(terms(formula), "response") != 1L) {
    errormsg("Unable to extract response from the formula.")
  }

  if (length(formula) == 3L) {
    deparse(formula[[2L]], width.cutoff = 500L)
  } else {
    # not sure this is ever needed... Can't come up with an example for a
    # formula that has a response and length 2.
    errormsg("Unable to extract a response from the formula.
             Formula is not of length 3.")
  }
}



#' Extract names of variables from several objects
#'
#' Version of `all.vars()` that can handle `formula`s, `lists` of `formulas` and
#' character strings.
#'
#'
#' @param ... `formula` objects, lists of formulas or character strings that are
#'            valid variable names (in the sense of `make.vars()`)
#' @export
#'
#' @keywords internal

# all_vars <- function(fmla) {
#   if (is.null(fmla)) {
#     return(NULL)
#   }
#
#   if (inherits(fmla, "list")) {
#     unique(unlist(lapply(fmla, all_vars)))
#   } else if (inherits(fmla, "formula")) {
#     all.vars(fmla)
#   } else {
#     errormsg(
#       "The provided object is not a %s nor a list of %s objects.",
#       dQuote("formula"), dQuote("formula")
#     )
#   }
# }

# all_vars <- function(...) {
#
#   input <- as.list(match.call())[-1L]
#   parent_envir <- parent.frame()
#   input_list <- unlist(lapply(input, eval, envir = parent_envir))
#
#   variable_list <- lapply(input_list, function(x) {
#
#     if (inherits(x, "formula")) {
#       all.vars(x)
#     } else {
#       x_char <- try(all.vars(parse(text = x)))
#       if (!inherits(x_char, "try-error")) {
#         is_variable_name <- isTRUE(all(make.names(x_char) == x_char))
#         x <- x_char
#       } else {
#         is_variable_name <- isTRUE(all(make.names(x) == x))
#       }
#       if (is_variable_name) {
#         x
#       } else {
#         errormsg("I don't know how to extract variable names from %s.",
#                  dQuote(x))
#       }
#     }
#   })
#   unique(unlist(variable_list))
# }

all_vars <- function(...) {

  input <- as.list(match.call())[-1L]
  parent_envir <- parent.frame()
  input_list <- unlist(lapply(input, eval, envir = parent_envir))

  variable_list <- lapply(input_list, function(x) {

    if (inherits(x, "formula")) {
      all.vars(x)
    } else {
      x_char <- try(all.vars(parse(text = x)))
      if (!inherits(x_char, "try-error")) {
        x_char
      } else {
        errormsg("I don't know how to extract variable names from %s.",
                 dQuote(x))
      }
    }
  })
  unique(unlist(variable_list))
}


#' Extract fixed effects formula from lme4-type formula
#'
#' @param formula a `formula` object (typically in lme4-style)
#'
#' @returns a `formula` object
#' @keywords internal
#'
extract_fixef_formula <- function(formula) {
  if (!inherits(formula, "formula")) {
    errormsg("The provided object is not a %s object.", dQuote("formula"))
  }

  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)
  intercept <- attr(terms(formula), "intercept")

  rhs <- paste(
    c(
      if (intercept == 0L || sum(!which_ranef) == 0L) intercept,
      term_labels[!which_ranef]
    ),
    collapse = " + "
  )

  as.formula(paste0(as.character(formula)[2L], " ~ ", rhs))
}


#' Extract random effects formula from lme4-type formula
#'
#' @param formula a `formula` object (typically in lme4-style)
#'
#' @returns a one-sided `formula` object (or `NULL` if there are no random
#'          effects)
#'
#' @keywords internal

extract_ranef_formula <- function(formula) {
  if (!inherits(formula, "formula")) {
    errormsg("The provided object is not a %s object.", dQuote("formula"))
  }

  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  # paste each random effects term in parentheses to separate them
  rhs <- paste0("(", term_labels[which_ranef], ")", collapse = " + ")

  if (any(which_ranef)) {
    as.formula(paste0(" ~ ", rhs))
  }
}



#' Split a list of formulas into fixed and random effects parts.
#'
#' Calls `extract_fixef_formula()` and `extract_ranef_formula()` on each
#' formula in a list to create one list of the
#' fixed effects formulas and one list containing the random effects formulas.
#'
#' Internal function, used in *_imp() (2022-02-06)
#'
#' @param formula a `formula` or a `list` of `formula` objects
#' @returns A `list` with two elements, `fixed` and `random`, each of which is a
#'          named `list` of `formula` objects (or `NULL`)
#' @keywords internal
#'

split_formula_list <- function(formula) {
  formula_list <- check_formula_list(formula)

  fixed <- lapply(formula_list, extract_fixef_formula)
  random <- lapply(formula_list, extract_ranef_formula)


  # extract lhs string as names for the list elements
  lhs_strings <- lapply(formula_list, extract_lhs_string)

  # If there are non-null elements, assign lhs of each formula as name of the
  # list element
  # Note: the "if" is needed to not assign "" names to only NULL lists
  if (any(!sapply(fixed, is.null)))
    names(fixed) <- gsub("NULL", "", lhs_strings)
  if (any(!sapply(random, is.null)))
    names(random) <- gsub("NULL", "", lhs_strings)


  list(
    fixed = fixed,
    random = random
  )
}






# extract_id <- function(random, warn = TRUE) {
#   random <- check_formula_list(random)
#
#   ids <- lapply(random, function(x) {
#     # match the vertical bar (...|...)
#     rdmatch <- gregexpr(
#       pattern = "\\([^|]*\\|[^)]*\\)",
#       deparse(x, width.cutoff = 500L)
#     )
#
#     if (any(rdmatch[[1L]] > 0L)) {
#       # remove "(... | " from the formula
#       rd <- unlist(regmatches(deparse(x, width.cutoff = 500L),
#                               rdmatch,
#                               invert = FALSE
#       ))
#       rdid <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*", rd)
#
#       # extract and remove )
#       id <- gsub(")", "", unlist(regmatches(rd, rdid, invert = TRUE)))
#
#       # split by + * : /
#       id <- unique(unlist(strsplit(id[id != ""],
#                                    split = "[[:space:]]*[+*:/][[:space:]]*"
#       )))
#     } else {
#       rdmatch <- gregexpr(
#         pattern = "[[:print:]]*\\|[ ]*",
#         deparse(x, width.cutoff = 500L)
#       )
#
#       if (any(rdmatch[[1L]] > 0L)) {
#         # remove "... | " from the formula
#         id <- unlist(regmatches(deparse(x, width.cutoff = 500L),
#                                 rdmatch,
#                                 invert = TRUE
#         ))
#         id <- unique(unlist(strsplit(id[id != ""],
#                                      split = "[[:space:]]*[+*:/][[:space:]]*"
#         )))
#       } else {
#         id <- NULL
#       }
#     }
#     id
#   })
#
#   if (is.null(unlist(ids)) & !is.null(unlist(random))) {
#     if (warn) {
#       warnmsg("No %s variable could be identified. I will assume that all
#               observations are independent.", dQuote("id"))
#     }
#   }
#
#   unique(unlist(ids))
# }
#



#' Extract grouping variables from a (list of) formula(s)
#'
#' Extracts the grouping variables (i.e., variables after `|`) from a model
#' formula or a list of such formulas
#'
#' @param formula a `formula` object or a `list` of `formula` objects
#' @param warn does nothing
#'
#' @returns a vector of character strings containing the unique grouping
#'          variable names found in any of the input formulas, or `NULL` if
#'          there is no grouping found
#' @keywords internal
#'
extract_grouping <- function(formula, warn = FALSE) {
  if (inherits(formula, "list")) {
    groupings <- lapply(formula, extract_grouping)
    return(unique(unlist(groupings)))
  }

  if (is.null(formula)) {
    return(NULL)
  }

  if (!inherits(formula, "formula")) {
    errormsg("The provided object is not a %s object.", dQuote("formula"))
  }

  formula_terms <- attr(terms(formula), "term.labels")
  rd_terms <- grep("\\|", formula_terms, value = TRUE)
  grouping_vars <- sapply(rd_terms, gsub, pattern = ".*\\| *", replace = "")

  if (length(grouping_vars) > 0L) {
    all.vars(parse(text = grouping_vars))
  }
}
