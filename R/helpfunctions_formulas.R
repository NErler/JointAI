check_formula_list <- function(formula) {

  # if formula is NULL, return NULL
  if (is.null(formula))
    return(NULL)

  # if formula is not a list, make it one
  if (!is.list(formula))
    formula <- list(formula)

  # check that all elements of formula are either formulas or NULL
  if (!all(sapply(formula, function(x) inherits(x, "formula") | is.null(x))))
    stop('At least one element of the provided formula is not of class "formula".',
         call. = FALSE)

  return(formula)
}


# Extract the id variable(s) from a random effects formula ------------------------
# random: formula object or a list of formulas;
#         formulas are expected to be in nlme format (random = ~ x | id)
# warn: logical
extract_id <- function(random, warn = TRUE) {

  # if random is not a list, make it one
  random <- check_formula_list(random)

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
    stop("Different grouping levels detected. JointAI can not yet handle this.", call. = FALSE)

  return(unique(unlist(ids)))
}


# Extract the names(s) of the outcome variable(s) from (a list of) fixed effects formula(s) ------
# fixed: a two-sided formula object or a list of such objects
extract_outcome <- function(fixed) {

  # if fixed is not a list, turn into list
  fixed <- check_formula_list(fixed)

  out_nam_list <- lapply(fixed, function(x) {
    # get the LHS of the formula
    LHS <- extract_LHS(x)

    # names of the outcome variables
    outnam <- all.vars(as.formula(paste0(LHS, "~ 1")))

    if (any(length(outnam) == 0, is.na(outnam), is.null(outnam))) {
      stop("Unable to extract the outcome variable.")
    }
    outnam
  })

  names(out_nam_list) <- sapply(fixed, extract_LHS)

  out_nam_list
}




# Extract the outcome formula from a formula ------------------
# (relevant for example for survival formulas, where Surv(...) is a formula)
# formula: two-sided formula (no list of formulas!!!)
extract_LHS <- function(formula) {

  # check that formula is a formula object
  if (!inherits(formula, "formula")) {
    stop('The provided formula is not a "formula" object', call. = FALSE)
  }

  # check that the formula has a LHS
  if (attr(terms(formula), "response") != 1) {
    stop("Unable to extract response from the formula.", call. = FALSE)
  }

  # get the LHS of the formula
  LHS <- sub("[[:space:]]*\\~[[:print:]]*", "",
             deparse(formula, width.cutoff = 500))

  return(LHS)
}


# Remove the left hand side from a (list of) formula(s) ------------------------
remove_LHS <- function(fmla) {

  # if fmla is not a list, turn into list
  fmla <- check_formula_list(fmla)
  if(is.null(fmla)) return(NULL)

  lapply(fmla, function(x) {
    if (!is.null(x)) {
      LHS <- try(extract_LHS(x), silent = TRUE)
      if (inherits(LHS, "try-error")) {
        x
      } else {
        as.formula(gsub(extract_LHS(x), '',
                        deparse(x, width.cutoff = 500), fixed = TRUE))
      }
    }
  })
}


# Remove grouping from formula -------------------------------------------------
# fmla: a formula object or a list of formulas
remove_grouping <- function(fmla) {

  # if fmla is not a list, turn into list
  fmla <- check_formula_list(fmla)
  if(is.null(fmla)) return(NULL)

  fl <- lapply(fmla, function(x) {
    if (!is.null(x)) {
      # remove " | ..." from the formula
      fmla2 <- sub("[[:space:]]*\\|[[:print:]]*", "",
                   deparse(x, width.cutoff = 500))

      as.formula(fmla2)
    }
  })

  if (length(fl) == 1) fl[[1]] else fl
}



# split a lmer type formula into fixed and random part
split_formula <- function(formula) {
  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  RHS <- paste(term_labels[!which_ranef], collapse = " + ")

  fixed <- paste0(as.character(formula)[2L], " ~ ",
                  ifelse(RHS == '', 1, RHS)
  )

  random <- if(any(which_ranef)) as.formula(
    paste0("~", paste(term_labels[which_ranef], collapse = ' + ')))

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



# identify all functions in fixed and random effects formulas ------------------
# fixed: two-sided formula or list of two-sided formulas
# random: optional; one-sided formula or list of one-sided formulas
identify_functions <- function(formula, random = NULL) {

  formula <- c(remove_LHS(formula),
               remove_grouping(check_formula_list(random)))

  if (is.null(formula))
    return(NULL)


  # get the term.labels from the formula and split by :
  termlabs <- unlist(lapply(formula, function(x) attr(terms(x), "term.labels")))
  termlabs <- unique(unlist(strsplit(termlabs, ":")))


  # check for each element of the formula if it is a function
  isfun <- sapply(unique(unlist(lapply(formula, all.names, unique = TRUE))),
                  function(x) {
                    g <- try(get(x, envir = .GlobalEnv), silent = TRUE)
                    if (!inherits(g, 'try-error'))
                      is.function(g)
                    else
                      FALSE
                  })


  # select only functions that are not operators or variable names
  funs <- isfun[!names(isfun) %in% c("~", "+", "-", ":", "*", "(", "^", "/",
                                     all_vars(formula)) & isfun]

  if (length(funs) > 0) {
    # for each function, extract formula elements containing it
    funlist <- sapply(names(funs), function(f) {
      fl <- c(#grep(paste0("\\(", f, "\\("), x = termlabs, value = TRUE),
        grep(paste0("^", f, "\\("), x = termlabs, value = TRUE),
        grep(paste0("[(+\\-\\*/] *", f, "\\("), x = termlabs, value = TRUE)
      )

      if (length(fl) > 0) fl
    }, simplify = FALSE)

    # remove NULL elements
    funlist <- funlist[!sapply(funlist, is.null)]

    # add main effects as function "identity"
    if (any(!termlabs %in% unlist(funlist)))
      funlist$identity <- termlabs[!termlabs %in% unlist(funlist)]

    funlist
  }
}


extract_fcts <- function(formula, data, random = NULL, complete = FALSE) {
  funlist <- identify_functions(formula, random = random)

  if (is.null(funlist)) return(NULL)

  # for each function, get all variables used in the expression
  varlist <- lapply(funlist, function(x) {
    sapply(x, function(z) all.vars(as.formula(paste("~", z))), simplify = FALSE)
  })

  # make a list of data.frames, one for each function, containing the
  # expression and involved variables
  fctList <- sapply(varlist, function(x) {
    X_vars <- sapply(names(x), function(k)
      colnames(model.matrix(as.formula(paste("~", k)), data))[-1],
      simplify = FALSE)

    df <- melt_list(x, varname = 'fct', valname = 'var')

    if (any(sapply(X_vars, length) > 1))
      df <- df[match(rep(names(X_vars), sapply(X_vars, length)), df$fct), ]

    df$X_var <- unlist(X_vars)

    df[, c("X_var", "var", 'fct')]
  }, simplify = FALSE)


  # convert to data.frame
  fctDF <- melt_list(fctList, varname = 'type')

  # remove duplicates
  fctDF <- subset(fctDF, subset= !duplicated(subset(fctDF, select = -type)))

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


# # Extract functions from a formula ---------------------------------------------
# extract_fcts <- function(formula, data, random = NULL, complete = FALSE, ...) {
#   # get the term.labels from the formula and split by :
#   termlabs <- c(attr(terms(formula), "term.labels"),
#                 if (!is.null(random))
#                   attr(terms(remove_grouping(random)), "term.labels"))
#   termlabs <- unique(unlist(strsplit(termlabs, ":")))
#
#   # check for each element of the formula if it is a function
#   isfun <- sapply(c(all.names(formula, unique = TRUE),
#                     all.names(remove_grouping(random), unique = TRUE)), function(x) {
#     g <- try(get(x, envir = .GlobalEnv), silent = TRUE)
#     if (!inherits(g, 'try-error'))
#       is.function(g)
#     else
#       FALSE
#   })
#
#   # select only functions that are not operators or variable names
#   funs <- isfun[!names(isfun) %in% c("~", "+", "-", ":", "*", "(", "^", "/",
#                                      all.vars(formula)) & isfun]
#
#   if (length(funs) > 0) {
#     # for each function, extract formula elements containing it
#     funlist <- sapply(names(funs), function(f) {
#       fl <- c(grep(paste0("\\(", f, "\\("), x = termlabs, value = TRUE),
#               grep(paste0("^", f, "\\("), x = termlabs, value = TRUE))
#       if (length(fl) > 0)
#         fl
#     }, simplify = FALSE)
#
#     funlist <- funlist[!sapply(funlist, is.null)]
#
#     if (length(funlist) == 0)
#       return(NULL)
#
#     # for each function, get all variables used in the expression
#     varlist <- lapply(funlist, function(x1) {
#       sapply(x1, function(x2) all.vars(as.formula(paste("~", x2))))
#     })
#
#     # make a list of data.frames, one for each function, containing the
#     # expression and involved variables
#     fctList <- sapply(varlist, function(x) {
#       if (inherits(x, 'character'))
#         x <- t(as.matrix(x))
#
#       X_vars <- sapply(colnames(x), function(k)
#         colnames(model.matrix(as.formula(paste("~", k)), data))[-1],
#         simplify = FALSE)
#
#       df <- melt_matrix(x,
#                         valname = 'var',
#                         varnames = c('rownames', 'fct'))
#
#       if (any(sapply(X_vars, length) > 1))
#         df <- df[match(rep(names(X_vars), sapply(X_vars, length)), df$fct), ]
#
#       df$X_var <- unlist(X_vars)
#
#       df[, c("X_var", "var", 'fct')]
#     }, simplify = FALSE)
#
#     # convert to data.frame
#     fctDF <- do.call(rbind, fctList)
#     fctDF$type <- rep(names(fctList), sapply(fctList, nrow))
#
#     # remove duplicates
#     fctDF <- fctDF[!duplicated(fctDF[, -which(names(fctDF) == 'type')]), ]
#
#     # find variables that are included without transformation and assign 'identity' function
#     if (any(fctDF$var %in% termlabs)) {
#       add_ident <- fctDF[fctDF$var %in% termlabs, ]
#       add_ident$X_var <- add_ident$fct <- add_ident$var
#       add_ident$type = 'identity'
#       fctDF <- rbind(fctDF, unique(add_ident))
#     }
#
#     # if chosen, remove functions only involving complete variables
#     if (complete == FALSE & nrow(fctDF) > 0) {
#       compl <- colSums(is.na(data[, fctDF$var, drop = FALSE])) == 0
#       partners <- sapply(fctDF$X_var,
#                          function(x) which(fctDF$X_var %in% x), simplify = FALSE)
#       anymis <- sapply(partners, function(x) any(!compl[x]))
#       fctDF <- if (any(anymis)) {
#         fctDF[anymis, , drop = FALSE]
#       }
#     } else {
#       fctDF$compl <- colSums(is.na(data[, fctDF$var, drop = FALSE])) == 0
#     }
#
#     if (!is.null(fctDF)) {
#       # look for functions that involve several variables and occur multiple times in fctDF
#       dupl <- duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl'))]) |
#               duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl'))], fromLast = TRUE)
#
#       fctDF$dupl <- FALSE
#
#       # identify which rows relate to the same expression in the formula
#       p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'compl'))], 1, paste, collapse = "")
#
#       for (k in which(dupl)) {
#         eq <- which(p == p[k])
#         ord <- order(sapply(data[fctDF$var[eq]], function(x)any(is.na(x))), decreasing = T)
#
#         fctDF$dupl[eq[ord]] <- duplicated(p[eq[ord]])
#       }
#
#       # fctDF$dupl <- duplicated(fctDF[, -which(names(fctDF) == 'var')])
#
#       p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'dupl', 'compl'))], 1, paste, collapse = "")
#       fctDF$dupl_rows <- NA
#       fctDF$dupl_rows[which(dupl)] <- lapply(which(dupl), function(i) {
#         m <- unname(which(p == p[i]))
#         m[m != i]
#       })
#
#       fctDF
#     }
#   }
# }
#
#



# extract the outcome data from the fixed effects formula ----------------------
extract_outcome_data <- function(fixed, data) {

  fixed <- check_formula_list(fixed)

  outcomes <- outnams <- extract_outcome(fixed)

  # set attribute "type" to identify survival outcomes
  for (i in seq_along(outnams)) {
    if (survival::is.Surv(eval(parse(text = names(outnams[i])), env = data))) {
      outcomes[[i]] <- as.data.frame.matrix(eval(parse(text = names(outnams[i])), env = data))
      attr(fixed[[i]], "type") <- "survival"
    } else {
      outcomes[[i]] <- as.data.frame(eval(parse(text = names(outnams[i])), env = data))
      names(outcomes[[i]]) <- outnams[i]
      attr(fixed[[i]], "type") <- "other"
      names(fixed)[i] <- outnams[i]
    }
  }
  return(list(fixed = fixed, outcomes = outcomes))
}



# if (analysis_type %in% c('survreg', 'coxph', 'JM')) {
#   out <- outcomes[[which(sapply(outnam, 'attr', 'type') ==  'survival')]]
#
#   if (ncol(out) == 2) {
#     out <- cbind(data[, id, drop = FALSE], out, rownr = 1:nrow(out))
#
#     out_lr <- do.call(rbind, lapply(split(out, out[, id]), function(x) {
#
#       x[nrow(x), ]
#     }))
#     y <- out_lr[, "time", drop = FALSE]
#     event <- out_lr[, "status", drop = FALSE]
#     survrow <- out_lr[, 'rownr']
#   } else if (ncol(out) == 3) {
#     out <- cbind(id = data[, id], out, rownr = 1:nrow(out))
#
#     out_lr <- do.call(rbind, lapply(split(out, out[, id]), function(x) {
#
#       if (sum(x$status, na.rm = TRUE) > 1)
#         stop("At least one subject has multiple events.")
#
#       x[nrow(x), ]
#     }))
#     y <- out_lr[, 'stop', drop = FALSE]
#     event <- out_lr[, 'status', drop = FALSE]
#     survrow <- out_lr[, 'rownr']
#   } else {
#     stop("Expected two or three outcome variables.")
#   }
#   if (!is.null(timevar)) names(y) <- timevar
#   else timevar <- names(y)
#
# } else {
#   y <- data[, unlist(outnam), drop = FALSE]
#   event <- NULL
# }



# make a design matrix from a list of formulas
model.matrix_combi <- function(fmla, data) {

  mats <- mapply(model.matrix, object = fmla,
                 data = lapply(fmla, model.frame, data = data, na.action = na.pass),
                 SIMPLIFY = FALSE)

  X <- mats[[1]]

  if (length(mats) > 1) {
    for (i in seq_along(mats)[-1]) {
      X <- cbind(X, mats[[i]][, setdiff(colnames(mats[[i]]), colnames(X)), drop = FALSE])
    }
  }

  return(X)
}
