
get_refs <- function(fmla, data, refcats = NULL) {

  covars <- all.vars(fmla)[all.vars(fmla) != extract_y(fmla)]
  factors <- covars[sapply(data[, covars, drop = FALSE], is.factor)]

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
    if (is.character(refcats[[x]]) & !refcats[[x]] %in% c("first", "last", "largest")) {
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
    res <- factor(levels(data[, x])[as.numeric(refcats[x])], levels(data[, x]))
    attr(res, "dummies") <- paste0(x, levels(res)[levels(res) != res])
    res
  }, simplify = FALSE)

  if (any(is.na(out))) {
    stop(gettextf("\nThe reference category for %s could not be set.",
             dQuote(names(out)[is.na(out)])))
  }
  return(out)
}


#' Set the reference categories for all categorical covariates in the model
#' The function asks questions and, depending on the answers given by the user,
#' returns the input for the argument 'refcats' in the functions
#' \code{\link{lm_imp}}, \code{\link{glm_imp}} and \code{link{lme_imp}}.
#'
#' @param data a \code{data.frame}
#' @param formula optional; model formula (used to select subset of relevant colums of \code{data})
#' @param covars optional; vector containing the names of relevant columns of \code{data}
#' @param auxvars optional; vector containing the names of relevant columns of
#'                \code{data} that shoud be considred additionally to the columns
#'                occuring in the \code{formula}
#'
#' @examples
#' set_refcat(data = NHANES)
#' 3
#' mod1 <- lm_imp(SBP ~ age + race + creat + educ, data = NHANES, refcats = 'largest')
#'
#'
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
#' mod2 <- lm_imp(formula = fmla, data = NHANES, refcats = ref_mod2, n.adapt = 0)
#'
#' @export
set_refcat <- function(data, formula, covars, auxvars) {
  if (missing(formula) & missing(covars) & missing(auxvars)) {
    covars <- colnames(data)
  } else  if (missing(covars) & !missing(formula)) {
    covars <- all.vars(formula)[all.vars(formula) != extract_y(formula)]
  }
  if (!missing(auxvars))
    covars <- unique(c(covars, auxvars))

  factors <- covars[sapply(data[, covars, drop = FALSE], is.factor)]

  message(gettextf("The categorical variables are:\n%s",
                   paste('-', sapply(factors, dQuote), collapse = "\n")))

  q1 <- menu(c('Use the first category for each variable.',
               'Use the last category for each variabe.',
               'Use the largest category for each variable.',
               'Specify the reference categories individually.'),
             title = "\nHow do you want to specify the reference categories?")

  if(q1 == 4) {
    q2 <- setNames(numeric(length(factors)), factors)
    for(i in seq_along(factors)) {
      q2[i] <- menu(levels(data[, factors[i]]),
                    title = gettextf("The reference category for %s should be", dQuote(factors[i]))
      )
    }
    out <- paste0("refcats = c(", paste(names(q2),  "=", q2, collapse = ", "), ")")
  } else {
    q2 <- switch(q1,
                 "1" = 'first',
                 "2" = 'last',
                 "3" = 'largest')
    out <- paste0("refcats = '", q2, "'")
  }

  message(gettextf("In the JointAI model specify:\n %s\n\nor use the output of this function.", out))
  return(invisible(q2))
}

