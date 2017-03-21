write_SPSS <- function(df, datafile, codefile)
{
  dfn <- lapply(df, function(x) if (is.factor(x))
    as.numeric(x)
    else x)
  write.table(dfn, file = datafile, row.names = FALSE, col.names = FALSE,
              sep = ";", dec = ",", quote = FALSE, na = "", eol = ";\n")
  varlabels <- names(df)
  # if (is.null(varnames)) {
  #   varnames <- abbreviate(names(df), 8L)
  #   if (any(sapply(varnames, nchar) > 8L))
  #     stop("I cannot abbreviate the variable names to eight or fewer letters")
  #   if (any(varnames != varlabels))
  #     warning("some variable names were abbreviated")
  # }
  varnames <- gsub("[^[:alnum:]_\\$@#]", "\\.", names(df))
  dl.varnames <- varnames
  if (any(chv <- sapply(df, is.character))) {
    lengths <- sapply(df[chv], function(v) max(nchar(v)))
    if (any(lengths > 255L))
      stop("Cannot handle character variables longer than 255")
    lengths <- paste0("(A", lengths, ")")
    star <- ifelse(c(TRUE, diff(which(chv) > 1L)), " *",
                   " ")
    dl.varnames[chv] <- paste(star, dl.varnames[chv], lengths)
  }
  cat("DATA LIST FILE=", adQuote(datafile), " free (\";\")\n",
      file = codefile)
  cat("/", dl.varnames, " .\n\n", file = codefile, append = TRUE)
  cat("VARIABLE LABELS\n", file = codefile, append = TRUE)
  cat(paste(varnames, adQuote(varlabels), "\n"), ".\n", file = codefile,
      append = TRUE)
  factors <- sapply(df, is.factor)
  if (any(factors)) {
    cat("\nVALUE LABELS\n", file = codefile, append = TRUE)
    for (v in which(factors)) {
      cat("/\n", file = codefile, append = TRUE)
      cat(varnames[v], " \n", file = codefile, append = TRUE,
          sep = "")
      levs <- levels(df[[v]])
      cat(paste(seq_along(levs), adQuote(levs), "\n", sep = " "),
          file = codefile, append = TRUE)
    }
    cat(".\n", file = codefile, append = TRUE)
  }
  cat("\nEXECUTE.\n", file = codefile, append = TRUE)
}

adQuote <- function (x){paste("\"", x, "\"", sep = "")}
