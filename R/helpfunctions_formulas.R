# Extract the id variable from a random effects formula ------------------------
extract_id <- function(random, warn = TRUE) {

  # match the |... pattern
  idmatch <- regexpr(pattern = "[[:print:]]*\\|[[:space:]]*",
                     deparse(random, width.cutoff = 500))

  if (idmatch > 0) {
    id <- unlist(regmatches(deparse(random, width.cutoff = 500),
                            idmatch, invert = TRUE))
    id <- id[id != ""]
  } else {
    id <- NULL
  }

  if (is.null(id) & !is.null(random))
    if (warn)
      warning('No "id" variable could be identified. I will assume that all observations are independent.',
              call. = FALSE, immediate. = TRUE)
  return(id)
}


# Extract the names(s) of the outcome variable(s) from fixed effects formula ------
extract_outcome <- function(fixed) {

  if (!inherits(fixed, "formula")) {
    fixed <- as.formula(fixed)
  }

  # get the LHS of the formula
  LHS <- sub("[[:space:]]*\\~[[:print:]]*", "",
             deparse(fixed, width.cutoff = 500))

  # names of the outcome variables
  outnam <- all.vars(as.formula(paste0(LHS, "~ 1")))


  if (any(length(outnam) == 0, is.na(outnam), is.null(outnam))) {
    stop("Unable to extract the outcome variable.")
  }

  return(outnam)
}


# Extract functions from a formula ---------------------------------------------
extract_fcts <- function(formula, data, random = NULL, complete = FALSE, ...) {
  # get the term.labels from the formula and split by :
  termlabs <- c(attr(terms(formula), "term.labels"),
                if (!is.null(random))
                  attr(terms(remove_grouping(random)), "term.labels"))
  termlabs <- unique(unlist(strsplit(termlabs, ":")))

  # check for each element of the formula if it is a function
  isfun <- sapply(c(all.names(formula, unique = TRUE),
                    all.names(remove_grouping(random), unique = TRUE)), function(x) {
    g <- try(get(x, envir = .GlobalEnv), silent = TRUE)
    if (!inherits(g, 'try-error'))
      is.function(g)
    else
      FALSE
  })

  # select only functions that are not operators or variable names
  funs <- isfun[!names(isfun) %in% c("~", "+", "-", ":", "*", "(", "^", "/",
                                     all.vars(formula)) & isfun]

  if (length(funs) > 0) {
    # for each function, extract formula elements containing it
    funlist <- sapply(names(funs), function(f) {
      fl <- c(grep(paste0("\\(", f, "\\("), x = termlabs, value = TRUE),
              grep(paste0("^", f, "\\("), x = termlabs, value = TRUE))
      if (length(fl) > 0)
        fl
    }, simplify = FALSE)

    funlist <- funlist[!sapply(funlist, is.null)]

    if (length(funlist) == 0)
      return(NULL)

    # for each function, get all variables used in the expression
    varlist <- lapply(funlist, function(x1) {
      sapply(x1, function(x2) all.vars(as.formula(paste("~", x2))))
    })

    # make a list of data.frames, one for each function, containing the
    # expression and involved variables
    fctList <- sapply(varlist, function(x) {
      if (inherits(x, 'character'))
        x <- t(as.matrix(x))
      df <- melt_matrix(x,
                        valname = 'var',
                        varnames = c('rownames', 'X_var'))
      if (is.null(df$X_var))
        df$X_var <- rownames(df)

      df[, c("X_var", "var")]
    }, simplify = FALSE)

    # convert to data.frame
    fctDF <- do.call(rbind, fctList)
    fctDF$type <- rep(names(fctList), sapply(fctList, nrow))
    fctDF$fct <- fctDF$X_var

    # remove duplicates
    fctDF <- fctDF[!duplicated(fctDF[, -which(names(fctDF) == 'type')]), ]

    # find variables that are included without transofrmation and assign 'identity' function
    if (any(fctDF$var %in% termlabs)) {
      add_ident <- fctDF[fctDF$var %in% termlabs, ]
      add_ident$X_var <- add_ident$fct <- add_ident$var
      add_ident$type = 'identity'
      fctDF <- rbind(fctDF, unique(add_ident))
    }

    # if chosen, remove functions only involving complete variables
    if (complete == FALSE & nrow(fctDF) > 0) {
      compl <- colSums(is.na(data[, fctDF$var, drop = FALSE])) == 0
      partners <- sapply(fctDF$X_var,
                         function(x) which(fctDF$X_var %in% x), simplify = FALSE)
      anymis <- sapply(partners, function(x) any(!compl[x]))
      fctDF <- if (any(anymis)) {
        fctDF[anymis, , drop = FALSE]
      }
    }

    if (!is.null(fctDF)) {
      # look for functions that involve several variables and occur multiple times in fctDF
      dupl <- duplicated(fctDF[, -which(names(fctDF) == 'var')]) |
              duplicated(fctDF[, -which(names(fctDF) == 'var')], fromLast = TRUE)

      fctDF$dupl <- FALSE

      # identify which rows relate to the same expression in the formula
      p <- apply(fctDF[, -which(names(fctDF) == 'var')], 1, paste, collapse = "")

      for (k in which(dupl)) {
        eq <- which(p == p[k])
        ord <- order(sapply(data[fctDF$var[eq]], function(x)any(is.na(x))), decreasing = T)

        fctDF$dupl[ord] <- duplicated(p[ord])
      }

      # fctDF$dupl <- duplicated(fctDF[, -which(names(fctDF) == 'var')])

      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'dupl'))], 1, paste, collapse = "")
      fctDF$dupl_rows <- NA
      fctDF$dupl_rows[which(dupl)] <- lapply(which(dupl), function(i) {
        m <- unname(which(p == p[i]))
        m[m != i]
      })

      fctDF
    }
  }
}


# Remove grouping from formula -------------------------------------------------
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
