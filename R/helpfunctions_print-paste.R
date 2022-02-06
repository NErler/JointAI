
# for JAGSmodel functions ------------------------------------------------------

add_dashes <- function(x, width = 95L) {
  # add separation lines between sub-models in JAGS model for readability
  # - x: name of the sub-model

  paste(x, paste0(rep("-", 80L - nchar(x)), collapse = ""))
}



add_linebreaks <- function(string, indent, width = 90L) {
  # add linebreaks to a string, breaking it after a "+" sign
  # - string: the linear predictor string to be broken
  # - indent: in case of a linebreak, how much should the new line be indented?
  # - width: output width

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

