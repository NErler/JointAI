# message functions ------------------------------------------------------------
errormsg <- function(x, ...) {
  stop(strwrap(gettextf(x, ...), prefix = "\n"), call. = FALSE)
}


msg <- function(x, ..., exdent = 0) {
  message(strwrap(gettextf(x, ...), prefix = "\n", exdent = exdent))
}

warnmsg <- function(x, ..., exdent = 0) {
  warning(strwrap(gettextf(x, ...), prefix = "\n", exdent = exdent),
          call. = FALSE, immediate. = TRUE)
}

paste_and <- function(x) {
  x1 <- paste0(x[-length(x)], collapse = ", ")

  if (length(x) > 1) {
    paste(x1, x[length(x)], sep = " and ")
  } else {
    x
  }
}

# variable levels and grouping -------------------------------------------------

get_groups <- function(idvar, data) {
  # identify clusters/groups based on the id variables
  # - idvar: vector of names of the id variables
  # - data: a data.frame

  if (!is.null(idvar)) {
    groups <- sapply(idvar, function(i) {
      match(data[, i], unique(data[, i]))
    }, simplify = FALSE)

    # check for unnecessary nesting levels
    gr_length <- sapply(groups, function(x)length(unique(x))) == nrow(data)
    if (any(gr_length)) {
      if (sum(gr_length) == 1) {
        errormsg("The grouping level %s seem to be unnecessary.
                 There are only unique observations at this level.",
                 names(gr_length[gr_length]))
      } else {
        errormsg("The grouping levels %s seem to be unnecessary.
                 There are only unique observations at these levels.",
             names(gr_length[gr_length]))
      }
    }

    groups$lvlone <- seq_len(nrow(data))

    # check for duplicate levels
    gr_dupl <- duplicated(groups)
    if (any(gr_dupl)) {
      gr_dupl2 <- duplicated(groups, fromLast = TRUE)
      errormsg("The grouping levels %s are duplicats.",
               unique(names(groups)[gr_dupl], names(groups)[gr_dupl2]))
    }
  } else {
    groups <- list(lvlone = seq_len(nrow(data)))
  }

  groups
}


check_cluster <- function(x, grouping) {
  # check if a variable varies within one cluster
  # - x: a vector
  # - grouping: a list of grouping information (obtained from get_groups())


  sapply(grouping, function(k) {
    # for each level of grouping, compare the original vector with a
    # reconstructed vector in which the first element per group is repeated
    # for each group member
    !identical(unname(x[match(unique(k), k)][match(k, unique(k))]),
               unname(x))
  })

  # returns a logical vector with length = length(groups) were TRUE means that
  # the variable varies in the given level
}



identify_level_relations <- function(grouping) {
  # identify the ordering of the levels
  # - grouping: a list (or vector) of grouping information
  #  (obtained from get_groups())

  # if grouping is not yet a list, make it a list
  if (!is.list(grouping))
    grouping <- list(grouping)

  # turn the list into a matrix, with the different levels as columns
  g <- do.call(cbind, grouping)
  # check if the grouping information varies within each of the clusters
  res <- apply(g, 2, check_cluster, grouping = grouping)

  if (!is.matrix(res))
    res <- t(res)

  # res is a matrix with a row and column per grouping level, containing
  # TRUEs and FALSEs
  res
}


# used in divide_matrices, get_modeltypes, helpfunctions_checks,
# helpfunctions_formulas, plots, simulate_data (2020-06-09)
check_varlevel <- function(x, groups, group_lvls = NULL) {
  # identify the level of a variable
  # - x: a vector
  # - groups: a list of grouping information (obtained from get_groups())
  # - group_lvls: the grouping level matrix
  #               (obtained from identify_level_relations())

  # if there are no groups, make a list with group name 'no_levels' so that the
  # syntax does not fail for single-level models
  if (!is.list(groups))
    groups <- list('no_levels' = groups)

  # check the clustering of the variable
  clus <- check_cluster(x, grouping = groups)

  # clus is a logical vector, which is TRUE if x varies in a given level and
  # FALSE when x is constant in the level


  if (sum(!clus) > 1) {
    # if the variable is constant in more than one level, the exact level needs
    # to be determined using the level structure of the grouping
    if (is.null(group_lvls))
      group_lvls <- identify_level_relations(groups)

    names(which.max(colSums(!group_lvls[!clus, !clus, drop = FALSE])))
  } else if (sum(!clus) == 1) {
    # if the variable is constant in exactly one level, that level is the
    # level of the variable
    names(clus)[!clus]
  } else {
    # if the variable varies in all levels, it is from level one
    'lvlone'
  }
}





# model_info helpers -----------------------------------------------------------

# used in get_model_info (2020-06-09)
replace_dummy <- function(nam, refs) {
  # check if a variable name is a dummy variable and replace it with the name
  # of the original variable
  # if the variable is a factor
  # - nam: one variable name
  # - refs: list of reference category information (part of Mlist)

  if (is.null(refs))
    return(nam)

  dummies <- lapply(refs, "attr",  "dummies")

  if (any(sapply(dummies, function(k) nam %in% k)))
    names(dummies)[sapply(dummies, function(k) nam %in% k)]
  else
    nam
}



# used in get_model_info()
paste_trafos <- function(Mlist, varname, index, isgk = FALSE) {
  # generate the strings that re-calculates trafos in the JAGS models
  # - Mlist: info on design matrices etc., obtained from divide_matrices()
  # - varname: name of the variabel for which the transformation syntax is being
  #            determined
  # - index: character string determining the index, i.e., 'i" or "ii"
  # - isgk: is this syntax part of the Gauss-Kronrod quadrature part?

  # if the output is being written in the Gauss-Kronrod quadrature part,
  # use "fcts_all" (i.e., all trafos, also those who only involve completely
  # observed variables), otherwise use "trafos" (i.e. only trafos that involve
  # incomplete variables)
  trafos <- if (isgk) Mlist$fcts_all else Mlist$trafos

  if (!any(trafos$var %in% varname)) return(NULL)


  trafolist <- sapply(which(trafos$var == varname), function(i) {
    # for each row in trafos that uses the current variable:
    x <- trafos[i, , drop = FALSE]

    if (!x$dupl) {
      # if this row is not a duplicate, determine the matrix and column the
      # transformed version of the variable is stored in
      dest_mat <- x$matrix
      dest_col <- match(x$colname, colnames(Mlist$M[[dest_mat]]))

      # if there is a duplicate version of the currently used row of trafo,
      # consider the current row and these duplicate rows, otherwise only the
      # current row
      if (!is.na(x$dupl_rows)) {
        xx <- trafos[c(i, unlist(x$dupl_rows)), ]
      } else {
        xx <- x
      }

      # identify the name of the original variable and the matrix containing it
      vars <- xx$var
      vars_mat <- xx$matrix
      # obtain the numbers of the columns containing the original variables
      vars_cols <- sapply(seq_along(vars), function(k)
        match(vars[k], colnames(Mlist$M[[vars_mat[k]]]))
      )

      fct <- x$fct

      # if the function is wrapped in the indicator function, remove this
      # indicator function
      if (x$type == "I") {
        fct <- gsub("\\)$", "", gsub("^I\\(", "", fct))
      }

      # remove the "as.numeric" used for comparing factors
      fct <- gsub('\\bas.numeric\\(', '(', fct)

      # if (x$type %in% c('ps', 'bs')) {
      #   sB <- eval(parse(text = fct), envir = Mlist$data)
      #   fct <- splineBas(x$var, degree = attr(sB, 'degree'), index = index,
      #                    nkn = length(attr(sB, 'knots')))
      #
      #   dcols <- grep(gsub("[[:digit:]]+$", "", x$colname),
      #                 colnames(Mlist$M[[dest_mat]]), fixed = TRUE)
      #   dest_col <- print_seq(min(dcols), max(dcols))
      # }


      lvls <- Mlist$group_lvls[gsub('M_', '', Mlist$Mlvls[vars])]

      for (k in seq_along(vars)) {
        if (lvls[k] == min(lvls)) {
          theindex <- index
        } else if (min(lvls) == 1) {
          theindex <- paste0('group_', names(lvls)[k], '[', index, ']')
        } else {
          theindex <- paste0('group_', names(lvls)[k], '[',
                             'pos_', names(lvls)[which.min(lvls)], "[",
                             index, ']]')
        }

        fct <- if (isgk) {
          gsub(paste0('\\b', vars[k], '\\b'),
               paste0(vars_mat[k], "gk[", theindex, ", ",
                      vars_cols[k], ", k]"), fct)
        } else {
          gsub(paste0('\\b', vars[k], '\\b'),
               paste0(vars_mat[k], "[", theindex, ", ",
                      vars_cols[k], "]"), fct)
        }
      }

      paste0(tab(4),
             dest_mat, if (isgk) "gk", "[", index, ", ", dest_col,
             if (isgk) ", k", "] <- ", fct, '\n')
    }
  })

  paste0('\n\n',
         paste0(Filter(Negate(is.null), unique(trafolist)), collapse = ''),
         '\n')
}


# used in get_model_info (2020-06-09)
replace_trafo <- function(nam, trafos) {
  # replace a variable name with the string used in the transformation of this
  # variable, if this variable is being transformed in the model
  # - nam: a variable name
  # - trafos: trafos info obtained from Mlist

  if (nam %in% trafos$colname) {
    unique(trafos$var[trafos$colname %in% nam])
  } else {nam}
}


# used in get_model_info and predict (2020-09-06)
#' Convert a survival outcome to a model name
#'
#' A helper function that converts the "name of a survival model"
#' (the \code{"Surv(time, status)"} specification) into a valid variable name
#' so that it can be used in the JAGS model syntax.
#'
#' @param x a character string
#'
#' @examples
#' clean_survname("Surv(eventtime, event != 'censored')")
#'
#' @export

clean_survname <- function(x) {
  # replace symbols not allowed in variable names to create a valid variable
  # name replacing the survival model outcome string in the JAGS model.
  x <- gsub(',* *type * = * [[:print:]]*', '', x)
  x <- gsub("[)\'\"]", '', x)
  x <- gsub("[[:punct:]]* *I\\(", "_", x)
  x <- gsub(' *== *', '_', x)
  x <- gsub(' *!= *', '_', x)
  x <- gsub(' *<=* *', '_', x)
  x <- gsub(' *>=* *', '_', x)
  x <- gsub(' *, *', "_", x)
  x <- gsub("\\(", "_", x)

  abbreviate(x, minlength = 15, use.classes = TRUE)
}


# model_imp helpers ------------------------------------------------------------

# used in add_samples, get_params, model_imp (2020-06-09)
get_coef_names <- function(info_list) {
  # extract the names of the regression coefficients and the corresponding
  # variable names
  # - info_list: a model info list (obtained from get_model_info())

  sapply(info_list, function(info) {

    # find all parameter elements with the same parameter name to find
    # out if this parameter needs to get indexed or not
    pars <- sapply(info_list, function(k) {
      if (k$parname %in% info$parname)
        unlist(c(k$parelmts, lapply(k$parelmts, "attr", "nonprop")))
    })


    parelmts <- unlist(unname(info$parelmts), recursive = FALSE)

    if (!is.list(parelmts)) {
      parelmts <- list(parelmts)
      names(parelmts) <- NA
    }


    out <- if (any(sapply(info$lp, length) > 0)) {
      data.frame(outcome = unname(info$varname),
                 outcat = rep(names(parelmts), sapply(parelmts, length)),
                 varname = names(unlist(unname(parelmts))),
                 coef = paste0(info$parname,
                               if (length(unlist(pars)) > 1)
                                 paste0("[", unlist(parelmts), "]")
                 ),
                 stringsAsFactors = FALSE
      )
    }

    nonprop <- unlist(unname(lapply(info$parelmts, attr, 'nonprop')),
                      recursive = FALSE)

    if (!is.null(unlist(nonprop))) {
      out <- rbind(out,
                   data.frame(outcome = unname(info$varname),
                              outcat = rep(names(nonprop),
                                           sapply(nonprop, length)),
                              varname = unlist(lapply(nonprop, names)),
                              coef = paste0(info$parname,
                                            paste0("[", unlist(nonprop), "]")),
                              stringsAsFactors = FALSE)
      )
    }

    out$varnam_print <- ifelse(is.na(out$outcat), out$varname,
                               paste0(out$outcat, ": ", out$varname))

    rownames(out) <- NULL
    out
  }, simplify = FALSE)
}



# data_list helpers --------------------------------------------------------

# used in get_data_list and predict (2020-06-09)
get_Mgk <- function(Mlist, gkx, surv_lvl, survinfo, data, rows = NULL,
                    td_cox = FALSE) {
  # get the Gauss-Kronrod quadrature version of the level one design matrix,
  # needed for a JM and coxph with time-varying covariates
  # - Mlist: the output of divide_matrices()
  # - gkx: vector of quadrature points
  # - surv_lvl: name of the grouping level of the survival outcome
  # - survinfo: list of relevant information of the survival models (obtained
  #             from get_survinfo())
  # - data: the original data when used in get_data_list, and the newdata when
  #          used in prediction
  # - rows: the rows of the longitudinal variables corresponding to the survival
  #         times (or 1:nrow(newdata when used in prediction)
  # - td_cox: logical; is this for a time-dependent cox model?

  # rows to replicate when setting up gk_data
  if (is.null(rows))
    rows <- match(unique(data[, surv_lvl]), data[, surv_lvl])

  # base-version of gk_data: one row per unit of the survival outcome level
  gk_data <- data[rep(rows, each = length(gkx)), ]

  # replace the id variable on the survival outcome level
  gk_data[, surv_lvl] <- rep(data[rows, surv_lvl], each = length(gkx))


  # replace the survival time with the Gauss-Kronrod version of it
  surv_time_name <- unique(sapply(survinfo, "[[", "time_name"))
  gk_data[, Mlist$timevar] <- c(t(outer(data[rows, surv_time_name]/2, gkx + 1)))


  # for a time-dependent cox model: use last-observation carried forward to fill
  # in the time-varying covariate values at the time-points that were determined
  # based on Gauss-Kronrod quadrature
  if (td_cox) {
    gk_data <- get_locf(fixed = Mlist$fixed, data = data,
                        idvar = surv_lvl,
                        group_lvls = Mlist$group_lvls, groups = Mlist$groups,
                        timevar = Mlist$timevar,
                        longvars = unique(unlist(lapply(survinfo, "[[",
                                                        'longvars'))),
                        gk_data)
  } else {

    for (k in unique(unlist(lapply(survinfo, "[[", "tv_vars")))) {
      gk_data[, k] <- if (is.factor(gk_data[, k])) {
        factor(NA, levels = levels(gk_data[, k]))
      } else NA * gk_data[, k]
    }

  }



  X <- model.matrix_combi(fmla = c(Mlist$fixed,
                                   unlist(remove_grouping(Mlist$random)),
                                   Mlist$auxvars),
                          data = gk_data, refs = Mlist$refs,
                          terms_list = Mlist$terms_list)

  Xnew <- matrix(nrow = length(rows) * length(gkx),
                 ncol = ncol(Mlist$M$M_lvlone),
                 dimnames = list(c(), colnames(Mlist$M$M_lvlone)))

  Xnew[, colnames(X)[colnames(X) %in% colnames(Xnew)]] <-
    X[, colnames(X)[colnames(X) %in% colnames(Xnew)]]

  lapply(seq_len(length(gkx)), function(k) {
    Xnew[length(gkx) * ((seq_len(length(rows))) - 1) + k, ]
  })
}



# used here, in get_Mgk() (2020-06-09)
get_locf <- function(fixed, data, idvar, group_lvls, groups, timevar,
                     longvars, gk_data) {

  # Fill in the longitudinal covariate values in the Gauss-Kronrod version of
  # the design matrix for level one using last-observation-carried-forward.
  # !!! If there is no observation of the longitudinal covariate at baseline
  #     (at timevar = 0) the first available value will be used.
  # - fixed: a list of fixed effects formulas
  # - data: the original or newdata (in case of prediction)
  # - idvar: the level of the survival outcome
  # - group_lvls: the ordering of the different levels of grouping in the data
  # - groups: list of grouping information
  # - timevar: name of the time variable of the longitudinal variables
  # - longvars: vector of names of the time-varying covariates
  # - gk_data: data.frame of the Gauss-Kronrod version of the level one design
  #             matrix

  # long data
  ld <- subset(data, select = c(idvar, timevar, longvars))
  # sort by id variable
  ld <- ld[order(ld[, idvar]), ]
  # add column with observation time indicator ("visit number" per patient)
  ld$obstime <- unlist(lapply(table(droplevels(ld[, idvar, drop = FALSE])),
                              function(k) 1:k))

  # turn long data into wide format, one column per visit
  wd <- reshape(ld, direction = 'wide', v.names = c(timevar, longvars),
                timevar = 'obstime', idvar = idvar)

  # check if there are variables for which some subjects have no observation
  anymis <- sapply(longvars, function(v) {
    obs <- rowSums(!is.na(wd[, grep(paste0("^", v, ".[[:digit:]]*$"),
                                    names(wd))]))
    any(obs == 0)
  })

  if (any(anymis)) {
    errormsg('There are subjects without any observations in the time-varying
             variable(s) %s.', paste_and(dQuote(names(anymis)[anymis])))
  }

  # add a column identifying the original ordering of the rows to gk_data
  gk_data$rowid <- seq_len(nrow(gk_data))

  # merge gk_data with wide format version of the time-varying covariates
  md <- merge(subset(gk_data, select = c(idvar, timevar, 'rowid')), wd)


  locf <- sapply(seq_len(nrow(md)), function(i) {
    # identify which visit should be used
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # if there is no baseline visit (i.e., the first time with an observed value
    # is larger than the time in the Gauss-Kronrod version of the time) the
    # first available measurement will be used ('first value carried backward')
    valcol <- max(1, which(
      c(md[i, timevar] > md[i, grep(paste0("^", timevar, "."), colnames(md))])
    ), na.rm = TRUE)


    # identify which columns have the covariate values of the correct visit
    covcols <- sapply(longvars, function(k) {
      grep(paste0("^", k, "."), colnames(md))[valcol]
    })

    out <- md[i, covcols, drop = FALSE]
    names(out) <- longvars
    out
  }, simplify = FALSE)

  md[, longvars] <- do.call(rbind, locf)

  gk_data_new <- merge(subset(gk_data, select = !names(gk_data) %in% longvars),
                       subset(md, select = c(idvar, timevar, longvars, 'rowid'))
  )
  gk_data_new[order(gk_data_new$rowid), ]
}




# used in get_data_list and predict (2020-06-09)
get_survinfo <- function(info_list, Mlist) {
  # make a list containing relevant information of survival outcomes, to
  # make subsequent syntax easier to handle/read
  # - info_list: list of model info as obtained from get_model info()
  # - Mlist: as obtained from divide_matrics()

  modeltypes <- sapply(info_list, "[[", 'modeltype')

  sapply(names(info_list[modeltypes %in% c('coxph', 'JM')]), function(k) {

    x <- info_list[[k]]

    surv_lvl <- gsub("M_", "" , x$resp_mat[2])
    longlvls <- names(Mlist$group_lvls)[Mlist$group_lvls <
                                          Mlist$group_lvls[surv_lvl]]

    if (any(longlvls != "lvlone"))
      errormsg("There can be only one level of observations below the level
               on which survival is measured.")


    covars <- all_vars(remove_LHS(Mlist$fixed[[k]]))
    covar_lvls <- sapply(Mlist$data[, covars], check_varlevel,
                         groups = Mlist$groups,
                         group_lvls = identify_level_relations(Mlist$groups))
    longvars <- names(covar_lvls)[covar_lvls %in% longlvls]

    survevent = Mlist$M[[x$resp_mat[2]]][, x$resp_col[2]]

    if (any(!survevent %in% c(0, 1))) {
      errormsg("The event indicator should only contain 2 distinct values
                 but I found %s. Note that it is currently not possible to fit
                 survival models with competing risks.",
               length(unique(survevent))
      )
    }

    list(varname = x$varname,
         modeltype = x$modeltype,
         surv_lvl = surv_lvl,
         longlvls = longlvls,
         longvars = longvars,
         haslong = isTRUE(!is.null(unlist(x$lp[paste0('M_', longlvls)]))),
         tv_vars = names(x$tv_vars),

         # name of the variable containing time of the repeated measurements:
         time_name = Mlist$outcomes$outnams[[k]][1],
         survtime = Mlist$M[[x$resp_mat[1]]][, x$resp_col[1]],
         survevent = Mlist$M[[x$resp_mat[2]]][, x$resp_col[2]]

    )
  }, simplify = FALSE)
}


