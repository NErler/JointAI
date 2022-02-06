
# for JAGSmodel functions ------------------------------------------------------

add_dashes <- function(x, width = 95L) {
  # add separation lines between sub-models in JAGS model for readability
  # - x: name of the sub-model

  paste(x, paste0(rep("-", 80L - nchar(x)), collapse = ""))
}


#' Add line breaks to a linear predictor string
#'
#' Adds line breaks to a string, breaking it after a "+" sign to not exceed a
#' given width of characters and taking into account indentation.
#'
#' @param string a character string (linear predictor)
#' @param indent integer; number of characters the new line should be indented
#' @param width integer; the maximum number of characters per line
#'
#' @keywords internal

add_linebreaks <- function(string, indent, width = 90L) {

  if (is.null(string)) {
    return(NULL)
  }

  # identify position of "+"
  m <- gregexpr(" \\+ ", string)[[1L]]

  # if there is no "+", return the original string
  if (all(m < 0L)) {
    return(string)
  }

  # calculate the lengths of the sub-strings
  len <- c(as.numeric(m)[1L], diff(c(as.numeric(m), nchar(string))))


  # check how many sub-strings (and the indent) can be combined until reaching
  # the maximal width, and create a string of " + " (no break) and
  # " +\n" (break) to be pasted in afterwards
  # (there is probably a more elegant way to do this)
  i <- 1L
  br <- character(0L)
  while (i < length(len)) {
    cs <- cumsum(len[i:length(len)])
    nfit <- max(1L, which(cs <= (width - indent)))
    br <- c(
      br, rep(" + ", nfit - 1L),
      if ((i + nfit - 1L) < length(len)) paste0(" +\n", tab(indent))
    )
    i <- i + nfit
  }

  paste0(strsplit(string, " \\+ ")[[1L]], c(br, ""), collapse = "")
}





minmax <- function(x, max = "1-1e-10", min = "1e-10") {
  # wrap a character string into max(min(...)); min-max-trick in JAGSmodel
  paste0("max(", min, ", min(", max, ", ", x, "))")
}




tab <- function(times = 2L) {
  # creates a vector of spaces to facilitate indentation
  tb <- " "
  paste(rep(tb, times), collapse = "")
}
