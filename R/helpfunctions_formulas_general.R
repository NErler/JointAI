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
#' @return A `formula`, a `list` of `formula` (and/or `NULL`) objects, or `NULL`
#' @keywords internal

check_formula_list <- function(formula, convert = TRUE) {

  if (is.null(formula)) {
    return(NULL)
  }

  # if formula is a formula, turn it into a list
  if (inherits(formula, "formula")) {
    if (convert) {
      formula <- list(formula)
    }
  } else if (inherits(formula, "list")) {
    # check if all elements are either formulas or NULL
    fmla_elmt <- lvapply(formula, inherits, "formula")
    null_elmt <- lvapply(formula, is.null)

    if (!all(fmla_elmt | null_elmt)) {
      errormsg("At least one element of the provided object is not of class
             %s.", dQuote("formula"))
    }
  } else {
    errormsg("The provided object is not of class %s nor is it a %s.",
             dQuote("formula"), dQuote("list"))
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
    c(deparse(fixed, width.cutoff = 500L),
      if (!is.null(random)) {
        paste0(gsub("~", "(", deparse(random, width.cutoff = 500L)),
               ")")
      }), collapse = " + ")

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

  if (is.null(formula))
    return(NULL)

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
#' Relevant, for example, for survival formulas, where `Surv(...)` is a
#' `call`.
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
  if (!inherits(formula, "formula"))
    errormsg("The provided formula is not a %s object.", dQuote("formula"))


  # check that the formula has a LHS
  if (attr(terms(formula), "response") != 1L)
    errormsg("Unable to extract response from the formula.")


  if (length(formula) == 3L) {
    deparse(formula[[2L]], width.cutoff = 500L)
    # } else if (length(formula) == 2L) {
    # ""
  } else {
    # not sure this is ever needed... Can't come up with an example for a
    # formula that has a response and length 2.
    errormsg("Unable to extract a response from the formula.
             Formula is not of length 3.")
  }
}



#' Extract names of variables from a (list of) formula(s)
#'
#' Version of `all.vars()` that can handle lists of formulas.
#'
#'
#' @param fmla a formula or list of formulas
#' @export
#'
#' @keywords internal

all_vars <- function(fmla) {

  if (is.null(fmla))
    return(NULL)

  if (inherits(fmla, "list")) {
    unique(unlist(lapply(fmla, all_vars)))
  } else if (inherits(fmla, "formula")) {
    all.vars(fmla)
  } else {
    errormsg("The provided object is not a %s nor a list of %s objects.",
             dQuote("formula"), dQuote("formula"))
  }
}



#' Split a formula into fixed and random effects parts
#'
#' Split a lme4 style formula into nlme style formulas.
#'
#' Internal function, used in *_imp and help functions (2022-02-06)
#'
#' @param formula a `formula` object
#' @keywords internal
#'

split_formula <- function(formula) {

  # get all terms from the formula and identify which contain the vertical bar
  # (= random effects)
  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  # build fixed effects formula by combining all non-random effects terms with
  # a "+", and combine with the LHS
  rhs <- paste(c(term_labels[!which_ranef],
                 if (attr(terms(formula), "intercept") == 0L) "0"),
               collapse = " + ")

  fixed <- paste0(as.character(formula)[2L], " ~ ",
                  if (rhs == "") {
                    1L
                  } else {
                    rhs
                  })

  # build random effects formula by pasting all random effects terms in brackets
  # (to separate different random effects terms from each other), and combine
  # them with "+"
  rhs2 <- paste0("(", term_labels[which_ranef], ")", collapse = " + ")

  # if there are random effect terms at all, combine with "~" and convert to a
  # formula object
  random <- if (rhs2 != "()") as.formula(paste0(" ~ ", rhs2))

  list(fixed = as.formula(fixed),
       random = random)
}


#' Split a list of formulas into fixed and random effects parts.
#'
#' Calls `split_formula()` on each formula in a list to create one list of the
#' fixed effects formulas and one list containing the random effects formulas.
#'
#' Internal function, used in *_imp() (2022-02-06)
#'
#' @param formulas a `list` of `formula` objects
#' @keywords internal
#'

split_formula_list <- function(formulas) {

  formulas <- check_formula_list(formulas)

  l <- lapply(formulas, split_formula)
  names(l) <- cvapply(formulas, function(x) as.character(x)[2L])

  list(fixed = lapply(l, "[[", "fixed"),
       random = lapply(l, "[[", "random"))
}




#' Extract all id variables from a list of random effects formulas
#'
#' Internal function, used in `divide_matrices()`, `get_models()`,
#' various help functions, `predict()` (2022-02-06)
#'
#' @param random a one-sided random effects formula or a list of such formulas
#' @param warn logical; should warnings be printed?
#' @keywords internal
#'
#'
extract_id <- function(random, warn = TRUE) {

  random <- check_formula_list(random)

  ids <- lapply(random, function(x) {
    # match the vertical bar (...|...)
    rdmatch <- gregexpr(pattern = "\\([^|]*\\|[^)]*\\)",
                        deparse(x, width.cutoff = 500L))

    if (any(rdmatch[[1L]] > 0L)) {
      # remove "(... | " from the formula
      rd <- unlist(regmatches(deparse(x, width.cutoff = 500L),
                              rdmatch, invert = FALSE))
      rdid <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*", rd)

      # extract and remove )
      id <- gsub(")", "", unlist(regmatches(rd, rdid, invert = TRUE)))

      # split by + * : /
      id <- unique(unlist(strsplit(id[id != ""],
                                   split = "[[:space:]]*[+*:/][[:space:]]*")))
    } else {
      rdmatch <- gregexpr(pattern = "[[:print:]]*\\|[ ]*",
                          deparse(x, width.cutoff = 500L))

      if (any(rdmatch[[1L]] > 0L)) {
        # remove "... | " from the formula
        id <- unlist(regmatches(deparse(x, width.cutoff = 500L),
                                rdmatch, invert = TRUE))
        id <- unique(unlist(strsplit(id[id != ""],
                                     split = "[[:space:]]*[+*:/][[:space:]]*")))

      } else {
        id <- NULL
      }
    }
    id
  })

  if (is.null(unlist(ids)) & !is.null(unlist(random)))
    if (warn)
      warnmsg("No %s variable could be identified. I will assume that all
              observations are independent.", dQuote("id"))

  unique(unlist(ids))
}
