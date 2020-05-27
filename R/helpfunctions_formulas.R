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
# extract_id <- function(random, warn = TRUE, allow_multiple = FALSE) {
#
#   # if random is not a list, make it one
#   random <- check_formula_list(random)
#
#   # check if random is a list of formulas
#   if (!all(sapply(random, function(x) inherits(x, "formula") | is.null(x))))
#     stop('At least one element of "random" is not of class "formula".', call. = FALSE)
#
#   ids <- lapply(random, function(x) {
#     # match the pattern "... | "
#     idmatch <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*",
#                        deparse(x, width.cutoff = 500))
#
#     if (any(idmatch > 0)) {
#       # remove "... | " from the formula
#       id <- unlist(regmatches(deparse(x, width.cutoff = 500),
#                               idmatch, invert = TRUE))
#       id <- strsplit(id[id != ""], split = "[[:space:]]*[+*:/][[:space:]]*")[[1]]
#     } else {
#       id <- NULL
#     }
#     id
#   })
#
#   if (is.null(unlist(ids)) & !is.null(unlist(random)))
#     if (warn)
#       warning('No "id" variable could be identified. I will assume that all observations are independent.',
#               call. = FALSE, immediate. = TRUE)
#
#   if (length(unique(unlist(ids))) > 1 & !allow_multiple)
#     stop("Different grouping levels detected. JointAI can not yet handle this.", call. = FALSE)
#
#   return(unique(unlist(ids)))
# }
#



extract_id <- function(random, warn = TRUE) {

  # if random is not a list, make it one
  random <- check_formula_list(random)

  # check if random is a list of formulas
  if (!all(sapply(random, function(x) inherits(x, "formula") | is.null(x))))
    stop('At least one element of "random" is not of class "formula".', call. = FALSE)

  ids <- lapply(random, function(x) {
    # match (...|...)
    rdmatch <- gregexpr(pattern = "\\([^|]*\\|[^)]*\\)", deparse(x, width.cutoff = 500))

    if (any(rdmatch[[1]] > 0)) {
      # remove "(... | " from the formula
      rd <- unlist(regmatches(deparse(x, width.cutoff = 500),
                              rdmatch, invert = FALSE))
      rdid <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*", rd)

      # extract and remove )
      id <- gsub(')', '', unlist(regmatches(rd, rdid, invert = TRUE)))

      # split by + * : /
      id <- unique(unlist(strsplit(id[id != ""], split = "[[:space:]]*[+*:/][[:space:]]*")))
    } else {
      rdmatch <- gregexpr(pattern = "[[:print:]]*\\|[ ]*", deparse(x, width.cutoff = 500))

      if (any(rdmatch[[1]] > 0)) {
        # remove "... | " from the formula
        id <- unlist(regmatches(deparse(x, width.cutoff = 500),
                                rdmatch, invert = TRUE))
        id <- unique(unlist(strsplit(id[id != ""], split = "[[:space:]]*[+*:/][[:space:]]*")))

      } else {
        id <- NULL
      }
    }
    id
  })

  if (is.null(unlist(ids)) & !is.null(unlist(random)))
    if (warn)
      warning('No "id" variable could be identified. I will assume that all observations are independent.',
              call. = FALSE, immediate. = TRUE)

  unique(unlist(ids))
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

  if(is.null(formula))
    return(NULL)

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
        clean_LHS <- gsub("([^\\])\\(", "\\1\\\\(", extract_LHS(x))
        as.formula(gsub(paste0("^", clean_LHS, "[[ ]]*~"), '~',
                        deparse(x, width.cutoff = 500)))
      }
    }
  })
}


# Remove grouping from formula -------------------------------------------------
# fmla: a formula object or a list of formulas
remove_grouping <- function(fmla) {

  # if fmla is not a list, turn into list
  fmla <- check_formula_list(fmla)

  if (is.null(fmla)) return(NULL)

  fl <- lapply(fmla, function(x) {
    if (!is.null(x)) {
      rdmatch <- gregexpr(pattern = "\\([^|]*\\|[^)]*\\)",
                          deparse(x, width.cutoff = 500))

      if (any(rdmatch[[1]] > 0)) {
        rd <- unlist(regmatches(deparse(x, width.cutoff = 500),
                                rdmatch, invert = FALSE))
        # remove "|...) " from the formula
        rdid <- gregexpr(pattern = " *\\|[[:print:]]*", rd)

        # extract and remove (
        ranef <- lapply(regmatches(rd, rdid, invert = TRUE), gsub,
                        pattern = '^\\(', replacement =  '~ ' )
        ranef <- lapply(ranef, function(k) as.formula(k[k != ""]))

        nam <- extract_id(x, warn = FALSE)

        if (length(nam) > 1 & length(ranef) == 1) {
          ranef <- rep(ranef, length(nam))
        } else if (length(nam) != length(ranef) & length(ranef) != 0) {
          stop(paste0(strwrap(
            "The number of grouping variables in the random effects formula
               does not the number of separate formulas. This may be a problem
               with the specification of multiple random effects formula parts
               which include nested grouping.", width = 80, exdent = 7),
            collapse = "\n"), call. = FALSE)
        }

        names(ranef) <- nam
        ranef

      } else {
      # remove " | ..." from the formula
      ranef <- sub("[[:space:]]*\\|[[:print:]]*", "",
                   deparse(x, width.cutoff = 500))

      nam <- extract_id(x, warn = FALSE)

      l <- list(as.formula(ranef))
      names(l) <- nam
      l
      }
    }
  })

  if (length(fl) == 1) fl[[1]] else fl
}



combi_rd_list <- function(fmlas) {
  as.formula(paste0("~ ",
                    paste0(unique(unlist(
                      lapply(fmlas, function(x) gsub("~", '', deparse(x, width.cutoff = 500))))),
                      collapse = " + ")
  ))
}


# split fixed and random -------------------------------------------------------
# split a lmer type formula into fixed and random part
split_formula <- function(formula) {
  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  RHS <- paste(term_labels[!which_ranef], collapse = " + ")

  fixed <- paste0(as.character(formula)[2L], " ~ ",
                  ifelse(RHS == '', 1, RHS)
  )

  # random <- if (any(which_ranef)) as.formula(
  #   paste0("~", paste(term_labels[which_ranef], collapse = ' + ')))

  # random <- gsub(prep_string(fixed), '', RHS) deparse(formula, width.cutoff = 500))
  # random <- gsub("^ *\\+", "~", random)
  # random <- if (random != "") as.formula(random)

  RHS2 <- paste0("(", term_labels[which_ranef], ")", collapse = " + ")
  random <- if (RHS2 != "()") as.formula(paste0(" ~ ", RHS2))

  return(list(fixed = as.formula(fixed),
              random = random)
  )
}


prep_string <- function(x) {
  p <- gsub("\\.", "\\\\.", x)
  # p <- gsub("\\.", "\\\\.", paste0("^", x, "$"))
  p <- gsub("\\?", ".", gsub("\\*", ".*", p))
  p <- gsub("\\+", "\\\\+", p)
  p <- gsub("([^\\])\\(", "\\1\\\\(", p)
  p <- gsub("([^\\])\\[", "\\1\\\\[", p)
  p <- gsub("([^\\])\\{", "\\1\\\\{", p)
  p
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
identify_functions <- function(formula) {

  formula <- check_formula_list(formula)

  if (is.null(formula))
    return(NULL)


  # get the term.labels from the formula and split by :
  termlabs <- unlist(lapply(formula, function(x)
    if(!is.null(x)) attr(terms(x), "term.labels")))
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
  funs <- isfun[!names(isfun) %in% c("~", "+", "-", ":", "*", "(", "^", "/", "Surv",
                                     all_vars(formula)) & isfun]

  if (length(funs) > 0) {
    # for each function, extract formula elements containing it
    funlist <- sapply(names(funs), function(f) {
      fl <- c(
        grep(paste0("^", f, "\\("), x = termlabs, value = TRUE),
        grep(paste0("[(+\\-\\*/] *", f, "\\("), x = termlabs, value = TRUE)
      )

      if (length(fl) > 0) fl
    }, simplify = FALSE)

    # remove NULL elements
    funlist <- funlist[!sapply(funlist, is.null)]

    # add main effects as function "identity"
    # (this is needed to be able to identify which variables need to occur in
    # multiple versions in the design matrices)
    # if (any(!termlabs %in% unlist(funlist)))
    #   funlist$identity <- termlabs[!termlabs %in% unlist(funlist)]

    funlist
  }
}


# make a list per function type, listing all functions and their element variables
# funlist: a list of all functions by type (result of identify_functions())
get_varlist <- function(funlist) {
  lapply(funlist, function(x) {
    sapply(x, function(z) all.vars(as.formula(paste("~", z))), simplify = FALSE)
  })
}




make_fctDF <- function(varlist_elmt, data) {

  X_vars <- sapply(names(varlist_elmt), function(k)
    # colnames(split_outcome(k, data = data)),
    colnames(model.matrix(as.formula(paste0("~", k)), data))[-1],
    simplify = FALSE)


  df <- melt_list(varlist_elmt, varname = 'fct', valname = 'var')

  if (any(sapply(X_vars, length) > sapply(varlist_elmt, length)))
    df <- df[match(rep(names(X_vars), sapply(X_vars, length)), df$fct), ]

  df$colname <- unlist(X_vars)
    # df$X_var <- rep(unlist(X_vars), sapply(varlist_elmt, length))

  df[, c("var", "colname", 'fct')]
}



# get data.frames per function type with infor for transformations
# varlist: list with an element for each type of function; these elements are lists
#          with an element per expressions using the function, which contains a
#          vector of all variable names involved in the function, output from get_varlist()
get_fctDFList <- function(varlist, data) {

  if (!unique(sapply(varlist, is.list)))
    varlist <- list(varlist)

  sapply(varlist, make_fctDF, data = data, simplify = FALSE)
}


extract_fcts <- function(fixed, data, random = NULL, complete = FALSE, Mlvls) {

  fixed <- check_formula_list(fixed)
  random <- check_formula_list(random)

  LHSs <- if (any(unlist(sapply(fixed, attr, 'type')) %in% c('survreg', 'coxph'))) {
    lapply(fixed[!sapply(fixed, attr, 'type') %in% c('survreg', 'coxph')],
           extract_LHS)
  } else {
    lapply(fixed, extract_LHS)
  }

  fmla_outcomes <- if (!is.null(unlist(LHSs)))
    as.formula(paste("~", paste0(unique(unlist(LHSs)), collapse = " + ")))

  if (any(names(identify_functions(fmla_outcomes)) != 'identity'))
      stop('Functions in the outcome are not allowed.')

  funlist <- list(covars = identify_functions(remove_LHS(fixed)),
                  ranef = identify_functions(unlist(remove_grouping(random)))
  )

  fctDFlist <- sapply(funlist, function(fl) {
    if (is.null(fl)) return(NULL)

    # make a list of data.frames, one for each function, containing the
    # expression and involved variables
    fctList <- get_fctDFList(varlist = get_varlist(fl), data = data)

    # convert to data.frame
    fctDF <- melt_list(fctList, varname = 'type')

    # remove duplicates
    subset(fctDF,
           subset = !duplicated(subset(fctDF,
                                       select = !names(fctDF) %in% c("type", "fct"))))
  }, simplify = FALSE)

  if (any(!sapply(fctDFlist, is.null))) {
    fctDF <- melt_data.frame_list(fctDFlist,
                                   id.vars = c('var', 'colname', 'fct', 'type'))
    fctDF <- subset(fctDF, select = which(!names(fctDF) %in% c("rowID")))

  # if chosen, remove functions only involving complete variables
    compl <- colSums(is.na(data[, fctDF$var, drop = FALSE])) == 0
    partners <- sapply(fctDF$colname,
                       function(x) which(fctDF$colname %in% x), simplify = FALSE)
    anymis <- sapply(partners, function(x) any(!compl[x]))

    fctDF$compl <- !anymis

    if (complete == FALSE)
      fctDF <- if (any(anymis)) fctDF[anymis, , drop = FALSE]


    if (!is.null(fctDF)) {
      fctDF$matrix <- Mlvls[fctDF$var]

      # look for functions that involve several variables and occur multiple times in fctDF
      dupl <- duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl', 'matrix'))]) |
        duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl', 'matrix'))], fromLast = TRUE)

      fctDF$dupl <- FALSE

      # identify which rows relate to the same expression in the formula
      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'compl', 'matrix'))], 1,
                 paste, collapse = "")

      for (k in which(dupl)) {
        eq <- which(p == p[k])
        ord <- order(fctDF$matrix[eq],
                     sapply(data[fctDF$var[eq]],
                            function(x) any(is.na(x))), decreasing = T)

        fctDF$dupl[eq[ord]] <- duplicated(p[eq[ord]])
      }

      # fctDF$dupl <- duplicated(fctDF[, -which(names(fctDF) == 'var')])

      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'dupl', 'compl', 'matrix'))],
                 1, paste, collapse = "")
      fctDF$dupl_rows <- NA
      fctDF$dupl_rows[which(dupl)] <- lapply(which(dupl), function(i) {
        m <- unname(which(p == p[i]))
        m[m != i]
      })

      fctDF
    }
  }
}



# extract the outcome data from the fixed effects formula ----------------------

split_outcome <- function(LHS, data) {
  if(missing(data))
    stop("No data provided")


  if (grepl("^cbind\\(", LHS)) {
    LHS2 <- gsub("\\)$", '', gsub('^cbind\\(', '', LHS))

    splitpos <- c(gregexpr(',', text = LHS2)[[1]], nchar(LHS2) + 1)

    if (splitpos[1] > 0) {
      start <- 1
      end <- splitpos[1] - 1
      i <- 1
      outlist <- list()
      while(start <= splitpos[length(splitpos)]) {
        fct <- substr(LHS2, start, end)
        fct <- gsub(" $", '', gsub("^ ", '', fct))
        var <- try(eval(parse(text = fct), envir = data), silent = TRUE)
        if (!inherits(var, 'try-error')) {
          var <- data.frame(var)
          names(var) <- if(ncol(var) > 1) {
            paste0(fct, 1:ncol(var))
          } else fct
          outlist <- c(outlist, var)
          start <- splitpos[i] + 1
          end <- splitpos[i + 1] - ifelse(splitpos[i + 1] == nchar(LHS2), 0, 1)
          i <- i + 1
        } else {
          end <- splitpos[i + 1] - 1#ifelse(splitpos[i + 1] == nchar(LHS2), 0, 1)
          i <- i + 1
        }
      }
      outdat <- as.data.frame(outlist)
      names(outdat) <- names(outlist)

    }} else {
      outdat <- as.data.frame(eval(parse(text = LHS), envir = data))
      names(outdat) <- LHS
    }

  return(outdat)
}





extract_outcome_data <- function(fixed, random = NULL, data, analysis_type = NULL, warn = TRUE) {

  fixed <- check_formula_list(fixed)

  idvar <- extract_id(random, warn = warn)
  groups <- get_groups(idvar, data)

  lvls <- colSums(!identify_level_relations(groups))

  outcomes <- outnams <- extract_outcome(fixed)

  # set attribute "type" to identify survival outcomes
  for (i in seq_along(fixed)) {
    if (survival::is.Surv(eval(parse(text = names(outnams[i])), envir = data))) {

      outcomes[[i]] <- as.data.frame.matrix(eval(parse(text = names(outnams[i])),
                                                 envir = data))
      names(outcomes[[i]]) <- idSurv(names(outnams[i]))[c('time', 'status')]
      nlev <- sapply(outcomes[[i]], function(x) length(levels(x)))
      if (any(nlev > 2)) {
        # ordinal variables have values 1, 2, 3, ...
        outcomes[[i]][which(nlev > 2)] <- lapply(outcomes[[i]][which(nlev > 2)],
                                                 function(x) as.numeric(x))
      } else if (any(nlev == 2)) {
        # binary variables have values 0, 1
        outcomes[[i]][nlev == 2] <- lapply(outcomes[[i]][nlev == 2],
                                           function(x) as.numeric(x) - 1)
      }

      attr(fixed[[i]], "type") <- if (analysis_type == 'coxph') 'coxph'
      else if (analysis_type == 'JM') "JM" else "survreg"
      names(fixed)[i] <- names(outnams[i])
    } else {
      outcomes[[i]] <- split_outcome(LHS = extract_LHS(fixed[[i]]), data = data)
      nlev <- sapply(outcomes[[i]], function(x) length(levels(x)))
      varlvl <- sapply(outcomes[[i]], check_varlevel, groups = groups)

      if (any(nlev > 2)) {
        # ordinal variables have values 1, 2, 3, ...
        outcomes[[i]][which(nlev > 2)] <- lapply(outcomes[[i]][which(nlev > 2)],
                                                 function(x) as.numeric(x))
        attr(fixed[[i]], "type") <- ifelse(lvls[varlvl] < max(lvls), 'clmm', 'clm')
      } else if (any(nlev == 2)) {
          # binary variables have values 0, 1
          outcomes[[i]][nlev == 2] <- lapply(outcomes[[i]][nlev == 2],
                                             function(x) as.numeric(x) - 1)

          attr(fixed[[i]], "type") <- ifelse(lvls[varlvl] < max(lvls),
                                             'glmm_binomial_logit', 'glm_binomial_logit')
      } else if (any(nlev == 0)) {
          # continuous variables
          attr(fixed[[i]], "type") <- ifelse(lvls[varlvl] < max(lvls), 'lmm', 'lm')
      }
      if (i == 1) {
        attr(fixed[[i]], 'type') <- if (isTRUE(analysis_type %in% c('glm', 'lm'))) {
        paste(gsub("^lm$", "glm", analysis_type),
              tolower(attr(analysis_type, 'family')$family),
              attr(analysis_type, 'family')$link, sep = "_")
        } else if (isTRUE(analysis_type %in% c('glme', 'lme'))) {
          paste(gsub("^[g]*lme$", "glmm", analysis_type),
                tolower(attr(analysis_type, 'family')$family),
                attr(analysis_type, 'family')$link, sep = "_")
        # } else if (analysis_type %in% 'betareg') {
        #   'beta'
        # } else if (analysis_type %in% 'betamm') {
        #   'glmm_beta'
        # } else if (analysis_type %in% 'lognormal') {
        #   'lognorm'
        } else {
          analysis_type
        }
      }
      names(fixed)[i] <- outnams[i]
    }
  }
  return(list(fixed = fixed, outcomes = outcomes, outnams = outnams))
}




get_terms_list <- function(fmla, data) {
  fmla <- fmla[!sapply(fmla, is.null)]

  fmla <- check_formula_list(fmla)

  # list of model.frames
  mf_list <- lapply(fmla, model.frame, data = data, na.action = na.pass)
  # list of term objects
  terms_list <- lapply(mf_list, terms)

  return(terms_list)
}


model.matrix_combi <- function(fmla, data, terms_list) {
  # list of model.frames
  mf_list <- lapply(terms_list, model.frame, data = data, na.action = na.pass)

  mats <- mapply(model.matrix, object = fmla, data = mf_list, SIMPLIFY = FALSE)

  X <- mats[[1]]

  if (length(mats) > 1) {
    for (i in seq_along(mats)[-1]) {
      X <- cbind(X, mats[[i]][, setdiff(colnames(mats[[i]]), colnames(X)), drop = FALSE])
    }
  }

  return(X)
}


# make a design matrix from a list of formulas
# model.matrix_combi <- function(fmla, data) {
#   fmla <- fmla[!sapply(fmla, is.null)]
#
#   fmla <- check_formula_list(fmla)
#
#   # list of model.frames
#   mf_list <- lapply(fmla, model.frame, data = data, na.action = na.pass)
#   # list of term objects
#   # terms_list <- lapply(mf_list, terms)
#
#   mats <- mapply(model.matrix, object = fmla, data = mf_list, SIMPLIFY = FALSE)
#
#   X <- mats[[1]]
#
#   if (length(mats) > 1) {
#     for (i in seq_along(mats)[-1]) {
#       X <- cbind(X, mats[[i]][, setdiff(colnames(mats[[i]]), colnames(X)), drop = FALSE])
#     }
#   }
#
#   return(X)
# }


# make a design matrix from the outcomes of a list of formulas
# (used in divide_matrices.R)
# outcomes: list produced by extract_outcome_data()
outcomes_to_mat <- function(outcomes) {

  outlist <- unlist(unname(lapply(outcomes$outcomes, as.list)), recursive = FALSE)

  if (any(duplicated(outlist))) {
    d1 <- duplicated(outlist)
    d2 <- duplicated(outlist, fromLast = TRUE)

    d <- unique(unlist(outcomes$outnams)[d1 | d2])
    stop(paste0("You can only specify one model per outcome.\n",
                gettextf(
                  if (length(d) == 1) {
                    "The variable %s is used on the left hand side of more than one of the model formulas."
                  } else {
                    "The variables %s are used on the left hand side of more than one of the model formulas."
                  }, paste0(dQuote(d), collapse = ", "))),
         call. = FALSE)
  }

  return(data.matrix(as.data.frame(outlist, check.names = FALSE)))
}



get_linpreds <- function(fixed, random, data, models, auxvars = NULL,
                         analysis_type = NULL, warn = TRUE) {

  fixed <- check_formula_list(fixed)

  # extract the id variable from the random effects formula
  idvar <- extract_id(random, warn = warn)
  groups <- get_groups(idvar, data)

  allvars <- unique(c(all_vars(fixed),
                      all_vars(remove_grouping(random)),
                      all_vars(auxvars)))

  covars <- allvars[!allvars %in% unlist(extract_outcome(fixed))]

  lvl <- sapply(data[, allvars, drop = FALSE], check_varlevel, groups = groups,
                group_lvls = identify_level_relations(groups))
  group_lvls <- colSums(!identify_level_relations(groups))

  subdat <- subset(data, select = covars)

  lp <- sapply(fixed, function(fmla) {
    if (attr(fmla, 'type') %in% c('clm', 'clmm', 'coxph', "JM")) {
      colnam <- colnames(model.matrix(fmla, data))[-1]
      if (length(colnam) > 0) colnam
    } else {
      colnames(model.matrix(fmla, data))
    }
  }, simplify = FALSE)



  for (out in names(models)[!names(models) %in% names(fixed)]) {
    nointercept <- models[out] %in% c('clmm', 'clm', 'coxph')
    fmla <- as.formula(paste0(out, " ~ .", if (nointercept) '-1'))

    lp[[out]] <- colnames(
      model.matrix(fmla, subset(subdat,
                                select = group_lvls[lvl[colnames(subdat)]] > group_lvls[lvl[out]] |
                                  lvl[colnames(subdat)] == lvl[out]
                                ))
    )

    if (is.null(lp[[out]])) {
      lp <- c(lp, setNames(list(NULL), out))
    }

    subdat <- subset(subdat, select = - c(get(out)))
  }
  lp
}
