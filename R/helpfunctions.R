#' Extract id variable from fixed effects formula
#' @param random a formula describing random effects structure
#' @return a character string, giving the name of the id variable or NULL
#' @export
extract_id <- function(random) {
  idmatch <- regexpr(pattern = "[[:print:]]*\\|[[:space:]]*",
                     deparse(random, width.cutoff = 500))
  if (idmatch > 0) {
    id <- unlist(regmatches(deparse(random, width.cutoff = 500),
                            idmatch, invert = T))
    id <- id[id != ""]
  } else {
    id <- NULL
  }
  return(id)
}


#' Remove grouping from formula
#' @param fmla a formula object or a string describing a formula
#' @return returns the formula without the grouping part, i.e., with out
#'         anything behind "|"
#' @export
remove_grouping <- function(fmla){
  if (is.null(fmla)) return(NULL)

  fmla2 <- sub("[[:space:]]*\\|[[:print:]]*", "",
               deparse(fmla, width.cutoff = 500))
  if (class(fmla) == "formula") {
    as.formula(fmla2)
  } else {
    fmla2
  }
}



#' Check if a variable is time-varying
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @return a logical value
#' @export
check_tvar <- function(x, idvar) {
  !all(sapply(split(x, idvar),
              function(z) all(z == z[1], na.rm = T)
  )
  )
}


#' Find position of variable names in a vector of variable names
#' @param nams1 vector of variable name to look for
#' @param nams2 vector of variable names
#' @return integer
#' @export
find_positions <- function(nams1, nams2) {
  nams1 <- gsub("^", "\\^", nams1, fixed = TRUE)
  vals <- c(glob2rx(nams1), glob2rx(paste0(nams1, ":*")),
            glob2rx(paste0("*:", nams1)))
  out <- unique(unlist(lapply(vals, grep, x = nams2)))
  out
}



#' Find the position(s) of a variable in a model matrix
#' @param varname character string to look for
#' @param DF data frame containing the variable
#' @param X model matrix
#' @return named vector specifying the columns in X that relate to varname
#' @export
match_positions <- function(varname, DF, X) {
  if (is.factor(DF[, varname])) {
    contr <- list("contr.treatment")
    names(contr) <- varname
  } else {
    contr <- NULL
  }

  matches <- match(colnames(model.matrix(formula(paste("~", varname)),
                                         DF,
                                         contrasts.arg = contr))[-1L],
                   colnames(X))
  names(matches) <- colnames(X)[matches]
  return(matches)
}


