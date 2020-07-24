
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



# used in divide_matrices, get_models, various help functions,
# predict (2020-06-09)
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
                        deparse(x, width.cutoff = 500L))

    if (any(rdmatch[[1L]] > 0L)) {
      # remove "(... | " from the formula
      rd <- unlist(regmatches(deparse(x, width.cutoff = 500L),
                              rdmatch, invert = FALSE))
      rdid <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*", rd)

      # extract and remove )
      id <- gsub(')', '', unlist(regmatches(rd, rdid, invert = TRUE)))

      # split by + * : /
      id <- unique(unlist(strsplit(id[id != ""],
                                   split = "[[:space:]]*[+*:/][[:space:]]*")))
    } else {
      rdmatch <- gregexpr(pattern = "[[:print:]]*\\|[ ]*",
                          deparse(x, width.cutoff = 500L))

      if (any(rdmatch[[1L]] > 0L)) {
        # remove "... | " from the formula
        id <- unlist(regmatches(deparse(x, width.cutoff = 500L),
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
    lhs <- extract_lhs(x)

    # names of the outcome variables
    outnam <- all.vars(as.formula(paste0(lhs, "~ 1")))

    if (any(length(outnam) == 0L, is.na(outnam), is.null(outnam))) {
      errormsg("Unable to extract the outcome variable.")
    }
    outnam
  })

  names(out_nam_list) <- sapply(fixed, extract_lhs)

  out_nam_list
}


# used in various help functions (2020-06-09)
extract_lhs <- function(formula) {
  # Extract the outcome formula from a formula
  # (relevant for example for survival formulas, where Surv(...) is a formula)
  # - formula: two-sided formula (no list of formulas!!!)

  if (is.null(formula))
    return(NULL)

  # check that formula is a formula object
  if (!inherits(formula, "formula"))
    errormsg('The provided formula is not a "formula" object')


  # check that the formula has a LHS
  if (attr(terms(formula), "response") != 1L)
    errormsg("Unable to extract response from the formula.")


  # get the LHS of the formula
  lhs <- sub("[[:space:]]*\\~[[:print:]]*", "",
             deparse(formula, width.cutoff = 500L))

  return(lhs)
}


# used in divide_matrices, get_models and help functions (2020-06-09)
remove_lhs <- function(fmla) {
  # Remove the left hand side from a (list of) formula(s)

  # if fmla is not a list, turn into list
  fmla <- check_formula_list(fmla)
  if (is.null(fmla)) return(NULL)


  lapply(fmla, function(x) {
    if (!is.null(x)) {
      lhs <- try(extract_lhs(x), silent = TRUE)
      if (inherits(lhs, "try-error")) {
        x
      } else {
        clean_lhs <- gsub("([^\\])\\(", "\\1\\\\(", extract_lhs(x))
        as.formula(gsub(paste0("^", clean_lhs, "[[ ]]*~"), '~',
                        deparse(x, width.cutoff = 500L)))
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
                          deparse(x, width.cutoff = 500L))

      if (any(rdmatch[[1L]] > 0L)) {
        rd <- unlist(regmatches(deparse(x, width.cutoff = 500L),
                                rdmatch, invert = FALSE))
        # remove "|...) " from the formula
        rdid <- gregexpr(pattern = " *\\|[[:print:]]*", rd)

        # extract and remove (
        ranef <- lapply(regmatches(rd, rdid, invert = TRUE), gsub,
                        pattern = '^\\(', replacement =  '~ ' )
        ranef <- lapply(ranef, function(k) as.formula(k[k != ""]))

        nam <- extract_id(x, warn = FALSE)

        if (length(nam) > 1L & length(ranef) == 1L) {
          ranef <- rep(ranef, length(nam))
        } else if (length(nam) != length(ranef) & length(ranef) != 0L) {
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
                   deparse(x, width.cutoff = 500L))

      nam <- extract_id(x, warn = FALSE)

      l <- list(as.formula(ranef))
      names(l) <- nam
      l
      }
    }
  })

  if (length(fl) == 1L) fl[[1L]] else fl
}


# can probably be deleted!!!
# combi_rd_list <- function(fmlas) {
#   # combine a list of rhs formulas into one rhs formula
#   as.formula(paste0("~ ",
#                     paste0(unique(unlist(
#                       lapply(fmlas, function(x)
#                         gsub("~", '', deparse(x, width.cutoff = 500L))))),
#                       collapse = " + ")
#   ))
# }



# used in *_imp and help functions (2020-06-09)
split_formula <- function(formula) {
  # split a lme4 type formula into fixed and random part
  # - formula: formula of the form outcome ~ covars + (x | group) + (x | group2)

  # get all terms from the formula and identify which contain the vertical bar
  # (= random effects)
  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  # build fixed effects formula by combining all non-random effects terms with
  # a "+", and combine with the LHS
  rhs <- paste(c(term_labels[!which_ranef],
                 if (attr(terms(formula), 'intercept') == 0L) "0"),
               collapse = " + ")

  fixed <- paste0(as.character(formula)[2L], " ~ ",
                  ifelse(rhs == '', 1L, rhs)
  )

  # build random effects formula by pasting all random effects terms in brackets
  # (to separate different random effects terms from each other), and combine
  # them with "+"
  rhs2 <- paste0("(", term_labels[which_ranef], ")", collapse = " + ")
  # if there are random effects terms at all, combine with "~"  and convert to
  # formula object
  random <- if (rhs2 != "()") as.formula(paste0(" ~ ", rhs2))

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


# can probably be deleted!!!
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
  # extract all variables involved in a formula or list of formulas
  # - fmla: formula or list of formulas

  if (is.list(fmla))
    unique(unlist(lapply(fmla, all.vars)))
  else all.vars(fmla)
}



# functions in formulas --------------------------------------------------------

# used in divide_matrices (2020-06-10)
extract_fcts <- function(fixed, data, random = NULL, auxvars = NULL,
                         complete = FALSE, dsgn_mat_lvls) {
  # create a data.frame of all functions of variables used in the linear
  # predictors of the models
  # - fixed: list of fixed effects formulas or fixed effects formula
  # - data: data.frame containing the original (pre-processed) data
  # - random: optional list of random effects formulas or random effects formula
  # - auxvars: optional formula of auxiliary variables
  # - complete: should the output consider functions of variables that do not
  #             have missing values?
  # - dsgn_mat_lvls: vector identifying the levels of all variables in the different
  #          design matrices

  fixed <- check_formula_list(fixed)
  random <- check_formula_list(random)

  # identify all left hand sides of the non-survival fixed effects formulas
  lh_sides <- if (any(unlist(sapply(fixed, attr, "type")) %in%
                  c("survreg", "coxph"))) {
    lapply(
      fixed[!sapply(fixed, attr, "type") %in% c("survreg", "coxph")],
      extract_lhs
    )
  } else {
    lapply(fixed, extract_lhs)
  }

  # convert the lh_sides in RHSs formulas to be able to extract the functions
  # in the outcomes
  fmla_outcomes <- if (!is.null(unlist(lh_sides)))
    as.formula(paste("~", paste0(unique(unlist(lh_sides)), collapse = " + ")))

  # if there are any functions in non-survival outcomes, give an error since
  # this cannot be handled by JAGS
  if (any(names(identify_functions(fmla_outcomes)) != 'identity'))
    errormsg('Functions in the outcome are not allowed.')


  # list of functions in covariates and random effects variables
  funlist <- list(covars = identify_functions(remove_lhs(c(fixed, auxvars))),
                  ranef = identify_functions(unlist(remove_grouping(random)))
  )

  fct_df_list <- sapply(funlist, function(fl) {
    if (is.null(fl)) return(NULL)

    # make a list of data.frames, one for each function, containing the
    # expression and involved variables
    fct_list <- get_fct_df_list(varlist = get_varlist(fl), data = data)

    # convert to data.frame
    fct_df <- melt_list(fct_list, varname = 'type')

    # remove duplicates
    subset(fct_df,
           subset = !duplicated(
             subset(fct_df, select = !names(fct_df) %in% c("type", "fct"))))
  }, simplify = FALSE)


  if (any(!sapply(fct_df_list, is.null))) {
    fct_df <- melt_data.frame_list(fct_df_list,
                                  id.vars = c('var', 'colname', 'fct', 'type'))
    fct_df <- subset(fct_df, select = which(!names(fct_df) %in% "rowID"))

    # if chosen, remove functions only involving complete variables
    compl <- colSums(is.na(data[, fct_df$var, drop = FALSE])) == 0L
    partners <- sapply(fct_df$colname,
                       function(x) which(fct_df$colname %in% x),
                       simplify = FALSE)
    anymis <- sapply(partners, function(x) any(!compl[x]))

    fct_df$compl <- !anymis

    if (complete == FALSE)
      fct_df <- if (any(anymis)) fct_df[anymis, , drop = FALSE]


    if (!is.null(fct_df)) {
      fct_df$matrix <- dsgn_mat_lvls[fct_df$var]

      # look for functions that involve several variables and occur multiple
      # times in fct_df
      dupl <-
        duplicated(fct_df[, -which(names(fct_df) %in%
                                    c('var', 'compl', 'matrix'))]) |
        duplicated(fct_df[, -which(names(fct_df) %in%
                                    c('var', 'compl', 'matrix'))],
                   fromLast = TRUE)

      fct_df$dupl <- FALSE

      # identify which rows relate to the same expression in the formula
      p <- apply(fct_df[, -which(names(fct_df) %in% c('var', 'compl', 'matrix'))],
                 1L, paste, collapse = "")

      for (k in which(dupl)) {
        eq <- which(p == p[k])
        ord <- order(fct_df$matrix[eq],
                     sapply(data[fct_df$var[eq]],
                            function(x) any(is.na(x))), decreasing = TRUE)

        fct_df$dupl[eq[ord]] <- duplicated(p[eq[ord]])
      }

      # fct_df$dupl <- duplicated(fct_df[, -which(names(fct_df) == 'var')])

      p <- apply(fct_df[, -which(names(fct_df) %in% c('var', 'dupl', 'compl',
                                                    'matrix'))],
                 1L, paste, collapse = "")
      fct_df$dupl_rows <- NA
      fct_df$dupl_rows[which(dupl)] <- lapply(which(dupl), function(i) {
        m <- unname(which(p == p[i]))
        m[m != i]
      })

      fct_df
    }
  }
}


# used in help function extract_fcts() (2020-06-09)
identify_functions <- function(formula) {
  # identify all functions in a list of formulas
  # - formula: a list of formulas, can contain fixed and random effects
  #            formulas, auxvars formula, ...

  formula <- check_formula_list(formula)

  if (is.null(formula)) return(NULL)


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
  funs <- isfun[!names(isfun) %in% c("~", "+", "-", ":", "*", "(", "^",
                                     "/", "Surv",
                                     all_vars(formula)) & isfun]

  if (length(funs) > 0L) {
    # for each function, extract formula elements containing it
    funlist <- sapply(names(funs), function(f) {
      fl <- c(
        grep(paste0("^", f, "\\("), x = termlabs, value = TRUE),
        grep(paste0("[(+\\-\\*/] *", f, "\\("), x = termlabs, value = TRUE)
      )

      if (length(fl) > 0L) fl
    }, simplify = FALSE)

    # remove NULL elements
    funlist <- funlist[!sapply(funlist, is.null)]

    # ??????????
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
  # make a list per function type, listing all functions and their element
  # variables
  # - funlist: a list of all functions by type (result of identify_functions())

  lapply(funlist, function(x) {
    sapply(x, function(z) all.vars(as.formula(paste("~", z))),
           simplify = FALSE)
  })
}


# used in extract_fcts() (2020-06-10)
make_fct_df <- function(varlist_elmt, data) {

  vars <- sapply(names(varlist_elmt), function(k)
    colnames(model.matrix(as.formula(paste0("~", k)), data))[-1L],
    simplify = FALSE)


  df <- melt_list(varlist_elmt, varname = 'fct', valname = 'var')

  if (any(sapply(vars, length) > sapply(varlist_elmt, length)))
    df <- df[match(rep(names(vars), sapply(vars, length)), df$fct), ]

  df$colname <- unlist(vars)

  df[, c("var", "colname", 'fct')]
}


# used in extract_fcts() (2020-06-10)
get_fct_df_list <- function(varlist, data) {
  # get data.frames per function type with info for transformations
  # - varlist: list with an element for each type of function; these elements
  #            are lists with an element per expressions using the function,
  #            which contains a vector of all variable names involved in the
  #            function, output from get_varlist()

  if (!unique(sapply(varlist, is.list)))
    varlist <- list(varlist)

  sapply(varlist, make_fct_df, data = data, simplify = FALSE)
}





