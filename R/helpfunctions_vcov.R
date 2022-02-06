
#' First validation for rd_vcov
#'
#' Checks if `rd_vcov` is a `list` with elements for all grouping levels or does
#' not specify a grouping level.
#' If valid, this function also make sure that `rd_vcov` is a list per grouping
#' level by duplicating the contents if necessary.
#'
#' @param rd_vcov a character string or a list describing the the random effects
#'                variance covariance structure (provided by the user)
#' @param idvar vector with the names of all grouping variables
#'              (except "lvlone")
#'
#' @keywords internal
#'
#' @return A named list per grouping level where each elements contains
#'        information on how the random effects variance-covariance matrices on
#'        that level are structured.
#'        Per level it can be either a character string (e.g. `"full"`) or a
#'        list specifying structures per (groups) of
#'        variable(s) (e.g. `list(full = c("a", "b"), indep = "c")`)


check_rd_vcov_list <- function(rd_vcov, idvar) {

  if (inherits(rd_vcov, "character")) {
    if (!rd_vcov %in% c("blockdiag", "full", "indep")) {
      errormsg("The variance-covariance matrix for the random effects of the
               different models (supplied to the argument %s) can only be of
               type \"blockdiag\", \"indep\", or \"full\".
               To specify different structures for different models or levels,
               provide a list (details see documentation).", dQuote("rd_vcov"))
    }

    nlapply(idvar, function(x) rd_vcov)

  } else if (inherits(rd_vcov, "list")) {

    if (all(names(rd_vcov) %in% c("blockdiag", "full", "indep"))) {
      nlapply(idvar, function(x) rd_vcov)
    } else if (length(idvar) > 1L & any(!idvar %in% names(rd_vcov))) {
      errormsg("Please provide information on the variance-covariance structure
             of the random effects for all levels.")
    } else if (all(idvar %in% names(rd_vcov))) {
      rd_vcov
    } else {
      errormsg("You provided %s in a way I didn't anticipate. Please contact
               the package maintainer.", dQuote("rd_vcov"))
    }

  } else {
    errormsg("The argument %s should be specified as character string
             or a list.", dQuote("rd_vcov"))
  }
}




#' Expand rd_vcov using variable names in case "full" is used
#'
#'
#' @param rd_vcov the random effects variance covariance structure provided by
#'                the user (`check_rd_vcov_list()` is called internally)
#' @param rd_outnam list by grouping level of the names of the outcome variables
#'                  that have random effects on this level
#' @keywords internal
#' @return A named list per grouping level where each elements contains
#'        information on how the random effects variance-covariance matrices on
#'        that level are structured. Per level there is a list of grouping
#'        structures containing the names of variables in each structure
#'        (e.g. `list(full = c("a", "b"), indep = "c")`)

expand_rd_vcov_full <- function(rd_vcov, rd_outnam) {
  idvar <- names(rd_outnam)

  rd_vcov <- check_rd_vcov_list(rd_vcov, idvar)

  nlapply(idvar, function(lvl) {
    if (is.character(rd_vcov[[lvl]]) & length(rd_vcov[[lvl]]) == 1L) {

      setNames(list(rd_outnam[[lvl]]), rd_vcov[[lvl]])

    } else if (inherits(rd_vcov[[lvl]], "list")) {

      if (setequal(unlist(rd_vcov[[lvl]]), rd_outnam[[lvl]])) {
        rd_vcov[[lvl]]
      } else {
        errormsg("According to the random effects formulas, there are
                 random effects on the level %s for the models for %s but in
                 the structure specified for the random effects
                 variance-covariance matrices the variables %s have random
                 effects on this level.",
                 dQuote(lvl), paste_and(dQuote(rd_outnam[[lvl]])),
                 paste_and(dQuote(unlist(rd_vcov[[lvl]])))
        )
      }

    } else {
      errormsg("%s should be a character string or a list.",
               dQuote(paste0("rd_vcov[[\"", lvl, "\"]]")))
    }
  })
}


#' Replace a full with a block-diagonal variance covariance matrix
#' Check if a full random effects variance covariance matrix is specified
#' for a single variable. In that case, it is identical to a block-diagonal
#' matrix. Change the `rd_vcov` specification to `blockdiag` for clarity
#' (because then the variable name is used in the name of `b`, `D`, `invD`, ...)
#'
#' @param rd_vcov a valid random effects variance-covariance structure
#'                specification (i.e., checked using `expand_rd_vcov_full()`)
#' @return a valid random effects variance-covariance structure specification
#' @keywords internal

check_full_blockdiag <- function(rd_vcov) {

  if (!inherits(rd_vcov, "list") | any(!lvapply(rd_vcov, inherits, "list"))) {
    errormsg("%s should be a list (by grouping level) of lists
    (per covariance matrix).", dQuote("rd_vcov"))
  }

  nlapply(names(rd_vcov), function(lvl) {
    bd <- names(rd_vcov[[lvl]]) == "full" &
      ivapply(rd_vcov[[lvl]], length) == 1
    names(rd_vcov[[lvl]])[bd] <- "blockdiag"
    rd_vcov[[lvl]]
  })
}


#' Check / create the random effects variance-covariance matrix specification
#'
#' @param rd_vcov variance covariance specification provided by the user
#' @param nranef list by level with named vectors of number of random effects
#'               per variable (obtained by `get_nranef()`)
#' @keywords internal

check_rd_vcov <- function(rd_vcov, nranef) {

  idvar <- names(nranef)

  rd_vcov <- expand_rd_vcov_full(rd_vcov,
                                 rd_outnam = nlapply(nranef, function(r) {
                                   names(r)[r > 0L]}))

  rd_vcov <- check_full_blockdiag(rd_vcov)


  if (any(unlist(lapply(rd_vcov, names)) == "full")) {
    for (lvl in idvar) {

      ## if a full vcov is used, determine the number of random effects
      for (k in which(names(rd_vcov[[lvl]]) == "full")) {

        nrd <- nranef[[lvl]][rd_vcov[[lvl]][[k]]]

        ranef_nr <- print_seq(
          min = cumsum(c(1, nrd))[-(length(nrd) + 1)],
          max = cumsum(nrd)
        )

        attr(rd_vcov[[lvl]][[k]], "ranef_index") <-
          setNames(ranef_nr, rd_vcov[[lvl]][[k]])
      }

      ## if there is more than one full vcov, number them
      if (sum(names(rd_vcov[[lvl]]) %in% "full") > 1) {
        rd_full <- which(names(rd_vcov[[lvl]]) %in% "full")
        for (k in seq_along(rd_full)) {
          attr(rd_vcov[[lvl]][[rd_full[k]]], "name") <- k
        }
      }
    }
  }
  rd_vcov
}



#' Extract the number of random effects
#' @param idvar vector of the names of all id variables
#' @param random a random effect formula or list of random effects formulas
#' @param data a `data.frame`
#' @return a list by grouping level (`idvar`) with a named vector of the number
#'         of random effects per variable (=names).
#' @keywords internal
#'

get_nranef <- function(idvar, random, data) {

  nlapply(idvar, function(lvl) {

    if (inherits(random, "formula")) {

      rm_gr <- remove_grouping(random)

      if (lvl %in% names(rm_gr)) {
        ncol(model.matrix(remove_grouping(random)[[lvl]], data = data))
      } else 0L

    } else if (inherits(random, "list")) {

      if (length(random) == 1L) {
        rm_gr <- remove_grouping(random)
        nrd <- if (lvl %in% names(rm_gr)) {
          ncol(model.matrix(rm_gr[[lvl]], data = data))
        } else 0L

      } else {

        nrd <- ivapply(remove_grouping(random), function(x) {
          if (lvl %in% names(x)) {
            ncol(model.matrix(x[[lvl]], data = data))
          } else 0L
        })
      }

      names(nrd) <- names(random)
      nrd

    } else {
      errormsg("I expected either a formula or list of formulas.")
    }
  })
}
