
get_refs <- function(fmla, data, refcats = NULL, warn = TRUE) {

  # check if fmla is a list of formulas, otherwise make it a list
  fmla <- check_formula_list(fmla)

  allvars <- all_vars(fmla)


  if (length(allvars) > 0) {
    factors <- allvars[sapply(data[allvars], is.factor)]

    default <- "first"

    if (is.null(refcats)) {
      refcats <- rep(default, length(factors))
      names(refcats) <- factors
    } else {
      if (!is.list(refcats)) refcats <- as.list(refcats)
      if (length(refcats) == 1 & is.null(attr(refcats, "names"))) {
        refcats <- setNames(rep(refcats, length(factors)), factors)
      } else if (any(!factors %in% names(refcats))) {
        add <- factors[!factors %in% names(refcats)]
        refcats <- c(refcats,  setNames(rep(default, length(add)), add))
      }
    }

    out <- sapply(factors, function(x){
      if (is.character(refcats[[x]]) & !refcats[[x]] %in%
          c("first", "last", "largest")) {
        newrefcats <- match(refcats[[x]], levels(data[, x]))
        if (is.na(newrefcats) & regexpr("^[[:digit:]]*$", refcats[[x]]) > 0) {
          refcats[[x]] <- as.numeric(refcats[[x]])
        } else {
          refcats[[x]] <- match(refcats[[x]], levels(data[, x]))
        }
      } else if (refcats[[x]] == 'first') {
        refcats[[x]] <- 1
      } else if (refcats[[x]] == 'last') {
        refcats[[x]] <- length(levels(data[, x]))
      } else if (refcats[[x]] == 'largest') {
        refcats[[x]] <- which.max(table(data[, x]))
      }
      res <- factor(levels(data[, x])[as.numeric(refcats[x])],
                    levels(data[, x]))
      attr(res, "dummies") <- paste0(x, levels(res)[levels(res) != res])
      attr(res, "ordered") <- inherits(data[, x], 'ordered')

      attr(res, "contrasts") <- if (inherits(data[, x], 'ordered'))
        options()$contrasts[2] else options()$contrasts[1]

      # check that contrasts specified for incomplete covariates are of a type
      # for which the conversion to "dummy" variables is implemented
      if (!attr(res, "contrasts") %in% c('contr.treatment', 'contr.sum') &
          any(is.na(data[, x])) & warn) {
        warnmsg("It is currently not possible to use %s for incomplete
                categorical covariates. I will use %s instead.
                You can specify (globally) which types of contrasts are
                used by changing %s.", dQuote(attr(res, "contrasts")),
                dQuote('contr.treatment'), dQuote("options('contrasts')"))

        attr(res, "contrasts") <- 'contr.treatment'
      }

      contr_matrix <- if (attr(res, "contrasts") == 'contr.treatment') {
        contr.treatment(levels(res), base = which(levels(res) == res))
      } else if (attr(res, 'contrasts') == 'contr.sum') {
        contr_matrix <- contr.sum(levels(res))
        contr_matrix[match(levels(res),
                           c(setdiff(levels(res), res), as.character(res))),
        drop = FALSE]
      } else {
        get(attr(res, "contrasts"))(levels(res))
      }

      attr(res, "contr_matrix") <- contr_matrix

      res
    }, simplify = FALSE)

    if (any(is.na(out))) {
      errormsg("The reference category for %s could not be set.",
               dQuote(names(out)[is.na(out)]))
    }

  } else {
    out <- NULL
  }
  return(out)
}


#' Specify reference categories for all categorical covariates in the model
#'
#' The function is a helper function that asks questions and, depending on the
#' answers given by the user,
#' returns the input for the argument \code{refcats} in the main analysis
#' functions
#' \code{\link[JointAI:model_imp]{*_imp}}.
#'
#' The arguments \code{formula}, \code{covars} and \code{auxvars} can be used
#' to specify a subset of the \code{data} to be considered. If non of these
#' arguments is specified, all variables in \code{data} will be considered.
#'
#' @param data a \code{data.frame}
#' @param formula optional; model formula or a list of formulas
#'                (used to select subset of relevant columns of \code{data})
#' @param covars optional; vector containing the names of relevant columns of
#'               \code{data}
#' @param auxvars optional; formula containing the names of relevant columns of
#'                \code{data} that should be considered additionally to the
#'                columns occurring in the \code{formula}
#'
#' @examples
#' \dontrun{
#' # Example 1: set reference categories for the whole dataset and choose
#' # answer option 3:
#' set_refcat(data = NHANES)
#' 3
#'
#' # insert the returned string as argument refcats
#' mod1 <- lm_imp(SBP ~ age + race + creat + educ, data = NHANES,
#'                refcats = 'largest')
#'
#' # Example 2:
#' # specify a model formula
#' fmla <- SBP ~ age + gender + race + bili + smoke + alc
#'
#' # write the output of set_refcat to an object
#' ref_mod2 <- set_refcat(data = NHANES, formula = fmla)
#' 4
#' 2
#' 5
#' 1
#' 1
#'
#' # enter the output in the model specification
#' mod2 <- lm_imp(formula = fmla, data = NHANES, refcats = ref_mod2,
#'                n.adapt = 0)
#'}
#'
#' @export

set_refcat <- function(data, formula, covars, auxvars = NULL) {

  if (missing(formula) & missing(covars) & is.null(auxvars)) {
    covars <- colnames(data)
  } else  if (missing(covars) & !missing(formula)) {
    covars <- all_vars(remove_LHS(formula))
  }
  if (!is.null(auxvars))
    covars <- unique(c(covars, all_vars(auxvars)))

  factors <- covars[sapply(data[covars], is.factor)]

  msg("The categorical variables are:\n\n%s",
      paste0('-', sapply(factors, dQuote), collapse = "\n\n"))

  q1 <- menu(c('Use the first category for each variable.',
               'Use the last category for each variabe.',
               'Use the largest category for each variable.',
               'Specify the reference categories individually.'),
             title = "\nHow do you want to specify the reference categories?")

  if (q1 == 4) {
    q2 <- q3 <- setNames(numeric(length(factors)), factors)
    for (i in seq_along(factors)) {
      q2[i] <- menu(levels(data[factors[i]]),
                    title = gettextf("The reference category for %s should be",
                                     dQuote(factors[i]))
      )
      q3[i] <- levels(data[factors[i]])[q2[i]]
    }

    out <- paste0("refcats = c(", paste0(names(q3),  " = '", q3, "'",
                                         collapse = ", "), ")")
  } else {
    q2 <- switch(q1,
                 "1" = 'first',
                 "2" = 'last',
                 "3" = 'largest')
    q3 <- q2
    out <- paste0("refcats = '", q2, "'")
  }

  msg("In the JointAI model specify:\n %s\n\nor use the output of this
      function.", out)

  return(invisible(q2))
}

