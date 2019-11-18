# Extract the id variable(s) from a random effects formula ------------------------
# random: formula object or a list of formulas
# warn: logical
extract_id <- function(random, warn = TRUE) {

  # if random is not a list, make it one
  if (!is.list(random))
    random <- list(random)

  # check if random is a list of formulas
  if (!all(sapply(random, function(x) inherits(x, "formula") | is.null(x))))
    stop('At least one element of "random" is not of class "formula".', call. = FALSE)

  ids <- lapply(random, function(x) {
    # match the pattern "... | "
    idmatch <- regexpr(pattern = "[[:print:]]*\\|[[:space:]]*",
                       deparse(x, width.cutoff = 500))

    if (idmatch > 0) {
      # remove "... | " from the formula
      id <- unlist(regmatches(deparse(x, width.cutoff = 500),
                              idmatch, invert = TRUE))
      id <- strsplit(id[id != ""], split = "[[:space:]]*[+*:/][[:space:]]*")[[1]]
    } else {
      id <- NULL
    }
    id
  })

  if (is.null(unlist(ids)) & !is.null(unlist(random)))
    if (warn)
      warning('No "id" variable could be identified. I will assume that all observations are independent.',
              call. = FALSE, immediate. = TRUE)

  if (length(unique(unlist(ids))) > 1)
    stop("Different grouping levels detected.", call. = FALSE)

  return(unique(unlist(ids)))
}


# Extract the names(s) of the outcome variable(s) from fixed effects formula ------
extract_outcome <- function(fixed) {
  # if fixed is not a list, turn into list
  if (!is.list(fixed)) fixed <- list(fixed)

  out_nam_list <- lapply(fixed, function(x) {
    if (!inherits(x, "formula"))
      x <- try(as.formula(x))

    if (inherits(x, "try-error"))
      stop("Please provide a valid (fixed effects) formula.", call. = FALSE)

    if (attr(terms(x), "response") != 1) {
      stop("Unable to extract response from model formula.", call. = FALSE)
    }

    # get the LHS of the formula
    LHS <- sub("[[:space:]]*\\~[[:print:]]*", "",
               deparse(x, width.cutoff = 500))

    # names of the outcome variables
    outnam <- all.vars(as.formula(paste0(LHS, "~ 1")))

    if (any(length(outnam) == 0, is.na(outnam), is.null(outnam))) {
      stop("Unable to extract the outcome variable.")
    }
    outnam
  })

  if (length(out_nam_list) == 1) out_nam_list[[1]] else out_nam_list
}


# Extract the names(s) of the outcome formula from fixed effects formula ------
extract_outcome_fmla <- function(fixed) {

  if (!inherits(fixed, "formula")) {
    fixed <- as.formula(fixed)
  }

  # get the LHS of the formula
  LHS <- sub("[[:space:]]*\\~[[:print:]]*", "",
             deparse(fixed, width.cutoff = 500))

  # if (any(length(outnam) == 0, is.na(outnam), is.null(outnam))) {
  #   stop("Unable to extract the outcome variable.")
  # }

  return(LHS)
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

      X_vars <- sapply(colnames(x), function(k)
        colnames(model.matrix(as.formula(paste("~", k)), data))[-1],
        simplify = FALSE)

      df <- melt_matrix(x,
                        valname = 'var',
                        varnames = c('rownames', 'fct'))

      if (any(sapply(X_vars, length) > 1))
        df <- df[match(rep(names(X_vars), sapply(X_vars, length)), df$fct), ]

      df$X_var <- unlist(X_vars)

      df[, c("X_var", "var", 'fct')]
    }, simplify = FALSE)

    # convert to data.frame
    fctDF <- do.call(rbind, fctList)
    fctDF$type <- rep(names(fctList), sapply(fctList, nrow))

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
    } else {
      fctDF$compl <- colSums(is.na(data[, fctDF$var, drop = FALSE])) == 0
    }

    if (!is.null(fctDF)) {
      # look for functions that involve several variables and occur multiple times in fctDF
      dupl <- duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl'))]) |
              duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl'))], fromLast = TRUE)

      fctDF$dupl <- FALSE

      # identify which rows relate to the same expression in the formula
      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'compl'))], 1, paste, collapse = "")

      for (k in which(dupl)) {
        eq <- which(p == p[k])
        ord <- order(sapply(data[fctDF$var[eq]], function(x)any(is.na(x))), decreasing = T)

        fctDF$dupl[eq[ord]] <- duplicated(p[eq[ord]])
      }

      # fctDF$dupl <- duplicated(fctDF[, -which(names(fctDF) == 'var')])

      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'dupl', 'compl'))], 1, paste, collapse = "")
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
remove_grouping <- function(fmla) {
  if (!is.list(fmla)) fmla <- list(fmla)

  fl <- lapply(fmla, function(x) {
    if (!is.null(x)) {
      fmla2 <- sub("[[:space:]]*\\|[[:print:]]*", "",
                   deparse(x, width.cutoff = 500))

      if (class(x) == "formula") {
        as.formula(fmla2)
      } else {
        fmla2
      }
    }
  })

  if (length(fl) == 1) fl[[1]] else fl
}

# Remove the left hand side from formula -------------------------------------------------
remove_LHS <- function(fmla) {
  if (!is.list(fmla)) fmla <- list(fmla)

  fl <- lapply(fmla, function(x) {
    if (!is.null(x))
      as.formula(paste0("~ ", paste(attr(terms(x), "term.labels"),
                                    collapse = " + ")))
  })

  if (length(fl) == 1) fl[[1]] else fl
}

# split a lmer type formula into fixed and random part
split_formula <- function(formula) {
  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  fixed = paste0(as.character(formula)[2L], " ~ ",
                 paste(term_labels[!which_ranef], collapse = " + ")
  )

  random = if(any(which_ranef)) as.formula(paste0("~", term_labels[which_ranef]))

  return(list(fixed = as.formula(fixed),
              random = random)
  )
}

# split a list of formulas into a list with fixed effects formulas and a list
# with random effects formulas
split_formula_list <- function(formulas) {
  l <- lapply(formulas, split_formula)
  names(l) <- sapply(formulas, function(x) as.character(x)[2L])

  return(list(fixed = lapply(l, "[[", "fixed"),
              random = lapply(l, "[[", "random"))
  )
}


all_vars <- function(fmla) {
  if (is.list(fmla))
    unique(unlist(lapply(fmla, all.vars)))
  else all.vars(fmla)
}
