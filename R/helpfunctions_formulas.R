
# used in many help functions, get_refs, *_imp, predict (2020-06-09)
check_formula_list <- function(formula) {
  # check if a formula is a list, and turn it into a list if it is not.

  # if formula is NULL, return NULL
  if (is.null(formula))
    return(NULL)

  # if formula is not a list, make it one
  if (!is.list(formula))
    formula <- list(formula)

  # check that all elements of formula are either formulas or NULL
  if (!all(sapply(formula, function(x) inherits(x, "formula") | is.null(x))))
    errormsg('At least one element of the provided formula is not of class
             "formula".')

  return(formula)
}



# used in divide_matrices, get_models, various help functions, predict (2020-06-09)
extract_id <- function(random, warn = TRUE) {
  # extract all id variables involved in a random effects formula

  # if random is not a list, make it one
  random <- check_formula_list(random)

  # check if random is a list of formulas
  if (!all(sapply(random, function(x) inherits(x, "formula") | is.null(x))))
    errormsg('At least one element of "random" is not of class "formula".')

  ids <- lapply(random, function(x) {
    # match (...|...)
    rdmatch <- gregexpr(pattern = "\\([^|]*\\|[^)]*\\)",
                        deparse(x, width.cutoff = 500))

    if (any(rdmatch[[1]] > 0)) {
      # remove "(... | " from the formula
      rd <- unlist(regmatches(deparse(x, width.cutoff = 500),
                              rdmatch, invert = FALSE))
      rdid <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*", rd)

      # extract and remove )
      id <- gsub(')', '', unlist(regmatches(rd, rdid, invert = TRUE)))

      # split by + * : /
      id <- unique(unlist(strsplit(id[id != ""],
                                   split = "[[:space:]]*[+*:/][[:space:]]*")))
    } else {
      rdmatch <- gregexpr(pattern = "[[:print:]]*\\|[ ]*",
                          deparse(x, width.cutoff = 500))

      if (any(rdmatch[[1]] > 0)) {
        # remove "... | " from the formula
        id <- unlist(regmatches(deparse(x, width.cutoff = 500),
                                rdmatch, invert = TRUE))
        id <- unique(unlist(strsplit(id[id != ""],
                                     split = "[[:space:]]*[+*:/][[:space:]]*")))

      } else {
        id <- NULL
      }
    }
    id
  })

  if (is.null(unlist(ids)) & !is.null(unlist(random)))
    if (warn)
      warnmsg('No "id" variable could be identified. I will assume that all
              observations are independent.')

  unique(unlist(ids))
}



# used in divide_matrices, get_models, and helpfunctions (2020-06-09)
extract_outcome <- function(fixed) {
  # Extract the names(s) of the outcome variable(s) from (a list of) fixed
  # effects formula(s)
  # - fixed: a two-sided formula object or a list of such objects

  # if fixed is not a list, turn into list
  fixed <- check_formula_list(fixed)

  out_nam_list <- lapply(fixed, function(x) {
    # get the LHS of the formula
    LHS <- extract_LHS(x)

    # names of the outcome variables
    outnam <- all.vars(as.formula(paste0(LHS, "~ 1")))

    if (any(length(outnam) == 0, is.na(outnam), is.null(outnam))) {
      errormsg("Unable to extract the outcome variable.")
    }
    outnam
  })

  names(out_nam_list) <- sapply(fixed, extract_LHS)

  out_nam_list
}


# used in various help functions (2020-06-09)
extract_LHS <- function(formula) {
  # Extract the outcome formula from a formula
  # (relevant for example for survival formulas, where Surv(...) is a formula)
  # - formula: two-sided formula (no list of formulas!!!)

  if (is.null(formula))
    return(NULL)

  # check that formula is a formula object
  if (!inherits(formula, "formula"))
    errormsg('The provided formula is not a "formula" object')


  # check that the formula has a LHS
  if (attr(terms(formula), "response") != 1)
    errormsg("Unable to extract response from the formula.")


  # get the LHS of the formula
  LHS <- sub("[[:space:]]*\\~[[:print:]]*", "",
             deparse(formula, width.cutoff = 500))

  return(LHS)
}


# used in divide_matrices, get_models and help functions (2020-06-09)
remove_LHS <- function(fmla) {
  # Remove the left hand side from a (list of) formula(s)

  # if fmla is not a list, turn into list
  fmla <- check_formula_list(fmla)
  if (is.null(fmla)) return(NULL)


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


# used in divide_matrices, get_models, and help functions (20120-06-09)
remove_grouping <- function(fmla) {
  # Remove grouping from formula
  # - fmla: a formula object or a list of formulas

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
          errormsg("The number of grouping variables in the random effects
                   formula does not match the number of separate formulas.
                   This may be a problem with the specification of multiple
                   random effects formula parts which include nested grouping.")
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


#
# combi_rd_list <- function(fmlas) {
#   # combine a list of RHS formulas into one RHS formula
#   as.formula(paste0("~ ",
#                     paste0(unique(unlist(
#                       lapply(fmlas, function(x)
#                         gsub("~", '', deparse(x, width.cutoff = 500))))),
#                       collapse = " + ")
#   ))
# }



# used in *_imp and help functions (2020-06-09)
split_formula <- function(formula) {
  # split a lme4 type formula into fixed and random part

  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  RHS <- paste(term_labels[!which_ranef], collapse = " + ")

  fixed <- paste0(as.character(formula)[2L], " ~ ",
                  ifelse(RHS == '', 1, RHS)
  )

  RHS2 <- paste0("(", term_labels[which_ranef], ")", collapse = " + ")
  random <- if (RHS2 != "()") as.formula(paste0(" ~ ", RHS2))

  return(list(fixed = as.formula(fixed),
              random = random)
  )
}


# used in *_imp() (2020-06-09)
split_formula_list <- function(formulas) {
  # split a list of formulas into a list with fixed effects formulas and a list
  # with random effects formulas

  l <- lapply(formulas, split_formula)
  names(l) <- sapply(formulas, function(x) as.character(x)[2L])

  return(list(fixed = lapply(l, "[[", "fixed"),
              random = lapply(l, "[[", "random"))
  )
}



# prep_string <- function(x) {
#   p <- gsub("\\.", "\\\\.", x)
#   # p <- gsub("\\.", "\\\\.", paste0("^", x, "$"))
#   p <- gsub("\\?", ".", gsub("\\*", ".*", p))
#   p <- gsub("\\+", "\\\\+", p)
#   p <- gsub("([^\\])\\(", "\\1\\\\(", p)
#   p <- gsub("([^\\])\\[", "\\1\\\\[", p)
#   p <- gsub("([^\\])\\{", "\\1\\\\{", p)
#   p
# }




# used in various functions (2020-06-09)
all_vars <- function(fmla) {
  if (is.list(fmla))
    unique(unlist(lapply(fmla, all.vars)))
  else all.vars(fmla)
}



# functions in formulas --------------------------------------------------------

# used in helpfunction extract_fcts (2020-06-09)
identify_functions <- function(formula) {
  # identify all functions in a list of formulas
  # - formula: a list of formulas, can contain fixed and random effects formulas,
  #            auxvars formula, ...

  formula <- check_formula_list(formula)

  if (is.null(formula))
    return(NULL)


  # get the term.labels from the formula and split by :
  termlabs <- unlist(lapply(formula, function(x)
    if (!is.null(x)) attr(terms(x), "term.labels")))
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



# used in extract_fcts() (2020-06-10)
get_varlist <- function(funlist) {
  # make a list per function type, listing all functions and their element variables
  # - funlist: a list of all functions by type (result of identify_functions())
  lapply(funlist, function(x) {
    sapply(x, function(z) all.vars(as.formula(paste("~", z))), simplify = FALSE)
  })
}


# used in extract_fcts() (2020-06-10)
make_fctDF <- function(varlist_elmt, data) {

  X_vars <- sapply(names(varlist_elmt), function(k)
    colnames(model.matrix(as.formula(paste0("~", k)), data))[-1],
    simplify = FALSE)


  df <- melt_list(varlist_elmt, varname = 'fct', valname = 'var')

  if (any(sapply(X_vars, length) > sapply(varlist_elmt, length)))
    df <- df[match(rep(names(X_vars), sapply(X_vars, length)), df$fct), ]

  df$colname <- unlist(X_vars)

  df[, c("var", "colname", 'fct')]
}


# used in extract_fcts() (2020-06-10)
get_fctDFList <- function(varlist, data) {
  # get data.frames per function type with info for transformations
  # - varlist: list with an element for each type of function; these elements
  #            are lists with an element per expressions using the function,
  #            which contains a vector of all variable names involved in the
  #            function, output from get_varlist()

  if (!unique(sapply(varlist, is.list)))
    varlist <- list(varlist)

  sapply(varlist, make_fctDF, data = data, simplify = FALSE)
}


# used in divide_matrices (2020-06-10)
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
      errormsg('Functions in the outcome are not allowed.')

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
      dupl <-
        duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl', 'matrix'))]) |
        duplicated(fctDF[, -which(names(fctDF) %in% c('var', 'compl', 'matrix'))],
                   fromLast = TRUE)

      fctDF$dupl <- FALSE

      # identify which rows relate to the same expression in the formula
      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'compl', 'matrix'))],
                 1, paste, collapse = "")

      for (k in which(dupl)) {
        eq <- which(p == p[k])
        ord <- order(fctDF$matrix[eq],
                     sapply(data[fctDF$var[eq]],
                            function(x) any(is.na(x))), decreasing = T)

        fctDF$dupl[eq[ord]] <- duplicated(p[eq[ord]])
      }

      # fctDF$dupl <- duplicated(fctDF[, -which(names(fctDF) == 'var')])

      p <- apply(fctDF[, -which(names(fctDF) %in% c('var', 'dupl', 'compl',
                                                    'matrix'))],
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

# used in extract_outcome_data() (2020-06-10)
split_outcome <- function(LHS, data) {
  if (missing(data))
    stop("No data provided")


  if (grepl("^cbind\\(", LHS)) {
    LHS2 <- gsub("\\)$", '', gsub('^cbind\\(', '', LHS))

    splitpos <- c(gregexpr(',', text = LHS2)[[1]], nchar(LHS2) + 1)

    if (splitpos[1] > 0) {
      start <- 1
      end <- splitpos[1] - 1
      i <- 1
      outlist <- list()

      while (start <= splitpos[length(splitpos)]) {
        fct <- substr(LHS2, start, end)
        fct <- gsub(" $", '', gsub("^ ", '', fct))
        var <- try(eval(parse(text = fct), envir = data), silent = TRUE)

        if (!inherits(var, 'try-error')) {
          var <- data.frame(var)
          names(var) <- if (ncol(var) > 1) {
            paste0(fct, 1:ncol(var))
          } else fct
          outlist <- c(outlist, var)
          start <- splitpos[i] + 1
          end <- splitpos[i + 1] - ifelse(splitpos[i + 1] == nchar(LHS2), 0, 1)
          i <- i + 1
        } else {
          end <- splitpos[i + 1] - 1
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




# used in divide_matrices and get_models (2020-06-10)
extract_outcome_data <- function(fixed, random = NULL, data,
                                 analysis_type = NULL, warn = TRUE) {

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

      if (any(is.na(outcomes[[i]])))
        errormsg("There are invalid values in the survival status.")

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
        } else {
          analysis_type
        }
      }
      names(fixed)[i] <- outnams[i]
    }
  }
  return(list(fixed = fixed, outcomes = outcomes, outnams = outnams))
}



# used in divide_matrices (2020-06-10)
get_terms_list <- function(fmla, data) {
  fmla <- fmla[!sapply(fmla, is.null)]

  fmla <- check_formula_list(fmla)

  # list of model.frames
  mf_list <- lapply(fmla, model.frame, data = data, na.action = na.pass)
  # list of term objects
  terms_list <- lapply(mf_list, terms)

  return(terms_list)
}


# used in divide_matrices and get_Mgk (2020-06-10)
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

  nosurv <- !sapply(outcomes$fixed, 'attr', 'type') %in% c('coxph', 'JM')
  outlist_nosurv <- unlist(unname(lapply(outcomes$outcomes[nosurv], as.list)),
                           recursive = FALSE)

  if (any(duplicated(outlist_nosurv))) {
    d1 <- duplicated(outlist_nosurv)
    d2 <- duplicated(outlist_nosurv, fromLast = TRUE)

    d <- unique(unlist(outcomes$outnams[nosurv])[d1 | d2])
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
