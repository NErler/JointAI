# message functions ------------------------------------------------------------
errormsg <- function(x, ...) {
  stop(strwrap(gettextf(x, ...), prefix = "\n"), call. = FALSE)
}


msg <- function(x, ..., exdent = 0L) {
  message(strwrap(gettextf(x, ...), prefix = "\n", exdent = exdent))
}

warnmsg <- function(x, ..., exdent = 0L) {
  warning(strwrap(gettextf(x, ...), prefix = "\n", exdent = exdent),
          call. = FALSE, immediate. = TRUE)
}

paste_and <- function(x, dQ = FALSE) {

  if (dQ)
    x <- dQuote(x)

  x1 <- paste0(x[-length(x)], collapse = ", ")

  if (length(x) > 1L) {
    paste(x1, x[length(x)], sep = " and ")
  } else {
    x
  }
}




nlapply <- function(x, fun, ...) {
  # a named version of lapply, intended to replace sapply(..., simplify = FALSE)

  l <- lapply(x, fun, ...)
  if (is.null(names(l)))
    if (!is.null(names(x))) {
      names(l) <- names(x)
    } else if (is.character(x)) {
      names(l) <- x
    }
  l
}

lvapply <- function(x, fun, ...) {
  vapply(x, fun, FUN.VALUE = logical(1L), ..., USE.NAMES = TRUE)
}

ivapply <- function(x, fun, ...) {
  vapply(x, fun, FUN.VALUE = integer(1L), ..., USE.NAMES = TRUE)
}

nvapply <- function(x, fun, ...) {
  vapply(x, fun, FUN.VALUE = numeric(1L), ..., USE.NAMES = TRUE)
}

cvapply <- function(x, fun, ...) {
  vapply(x, fun, FUN.VALUE = character(1L), ..., USE.NAMES = TRUE)
}


# variable levels and grouping -------------------------------------------------

get_groups <- function(idvar, data) {
  # identify clusters/groups based on the id variables
  # - idvar: vector of names of the id variables
  # - data: a data.frame

  if (!is.null(idvar)) {
    groups <- nlapply(idvar, function(i) {
      match(data[, i], unique(data[, i]))
    })

    # check for unnecessary nesting levels
    gr_length <- ivapply(groups, function(x) length(unique(x))) == nrow(data)
    if (any(gr_length)) {
      if (sum(gr_length) == 1L) {
        errormsg("The grouping level %s seem to be unnecessary.
                 There are only unique observations at this level.",
                 dQuote(names(gr_length[gr_length])))
      } else {
        errormsg("The grouping levels %s seem to be unnecessary.
                 There are only unique observations at these levels.",
                 paste_and(dQuote(names(gr_length[gr_length]))))
      }
    }

    groups$lvlone <- seq_len(nrow(data))

    # check for duplicate levels
    gr_dupl <- duplicated(groups)
    if (any(gr_dupl)) {
      gr_dupl2 <- duplicated(groups, fromLast = TRUE)
      errormsg("The grouping levels %s are duplicates.",
               paste_and(dQuote(unique(c(names(groups)[gr_dupl],
                                         names(groups)[gr_dupl2])))))
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

  attributes(x) <- NULL

  lvapply(grouping, function(k) {
    # for each level of grouping, compare the original vector with a
    # reconstructed vector in which the first element per group is repeated
    # for each group member
    !identical(x[match(unique(k), k)][match(k, unique(k))],
               x)
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
  res <- apply(g, 2L, check_cluster, grouping = grouping, simplify = FALSE)
  res <- do.call(cbind, res)

  if (!is.matrix(res))
    res <- t(res)

  # res is a matrix with a row and column per grouping level, containing
  # TRUEs and FALSEs
  res
}



# More efficient alternative to running check_varlevel for each column of a
# data.frame separately
get_datlvls <- function(data, groups) {

  if (!inherits(data, "data.frame"))
    data <- as.data.frame(data)



  clus <- lapply(groups, function(k) {
    # for each level of grouping, compare the original vector with a
    # reconstructed vector in which the first element per group is repeated
    # for each group member
    d_rep <- data[match(unique(k), k)[match(k, unique(k))], , drop = FALSE]
    !unlist(Map(identical, d_rep, data))
  })
  clus <- do.call(cbind, clus)

  lvl_rel <- identify_level_relations(groups)

  k <- match(
    data.frame(t(clus)),
    data.frame(lvl_rel[colnames(clus), ])
  )

  k[is.na(k)] <- which.max(colSums(!lvl_rel))
  setNames(colnames(clus)[k], rownames(clus))

}



# used in divide_matrices, get_modeltypes, helpfunctions_checks,
# helpfunctions_formulas, plots, simulate_data (2020-06-09)
check_varlevel <- function(x, groups, group_lvls = NULL) {
  # identify the level of a variable
  # - x: a vector
  # - groups: a list of grouping information (obtained from get_groups())
  # - group_lvls: the grouping level matrix
  #               (obtained from identify_level_relations())

  # if there are no groups, make a list with group name "no_levels" so that the
  # syntax does not fail for single-level models
  if (!is.list(groups))
    groups <- list("no_levels" = groups)

  # check the clustering of the variable
  clus <- check_cluster(x, grouping = groups)

  # clus is a logical vector, which is TRUE if x varies in a given level and
  # FALSE when x is constant in the level


  if (sum(!clus) > 1L) {
    # if the variable is constant in more than one level, the exact level needs
    # to be determined using the level structure of the grouping
    if (is.null(group_lvls))
      group_lvls <- identify_level_relations(groups)

    names(which.max(colSums(!group_lvls[!clus, !clus, drop = FALSE])))
  } else if (sum(!clus) == 1L) {
    # if the variable is constant in exactly one level, that level is the
    # level of the variable
    names(clus)[!clus]
  } else {
    # if the variable varies in all levels, it is from level one
    "lvlone"
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

  if (is.null(refs)) {
    return(nam)
  }

  dummies <- lapply(refs, "attr",  "dummies")

  if (any(lvapply(dummies, function(k) nam %in% k))) {
    names(dummies)[lvapply(dummies, function(k) nam %in% k)]
  } else {
    nam
  }
}



# used in get_model_info()
paste_trafos <- function(Mlist, varname, index, isgk = FALSE) {
  # generate the strings that re-calculates trafos in the JAGS models
  # - Mlist: info on design matrices etc., obtained from divide_matrices()
  # - varname: name of the variabel for which the transformation syntax is being
  #            determined
  # - index: character string determining the index, i.e., "i" or "ii"
  # - isgk: is this syntax part of the Gauss-Kronrod quadrature part?

  # if the output is being written in the Gauss-Kronrod quadrature part,
  # use "fcts_all" (i.e., all trafos, also those who only involve completely
  # observed variables), otherwise use "trafos" (i.e. only trafos that involve
  # incomplete variables)
  trafos <- if (isgk) Mlist$fcts_all else Mlist$trafos

  if (!any(trafos$var %in% varname)) {
    return(NULL)
  }


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
      vars_cols <- ivapply(seq_along(vars), function(k)
        match(vars[k], colnames(Mlist$M[[vars_mat[k]]]))
      )

      fct <- x$fct

      # if the function is wrapped in the indicator function, remove this
      # indicator function
      if (x$type == "I") {
        fct <- gsub("\\)$", "", gsub("^I\\(", "", fct))
      }

      # remove the "as.numeric" used for comparing factors
      fct <- gsub("\\bas.numeric\\(", "(", fct)

      # if (x$type %in% c("ps", "bs")) {
      #   sB <- eval(parse(text = fct), envir = Mlist$data)
      #   fct <- splineBas(x$var, degree = attr(sB, "degree"), index = index,
      #                    nkn = length(attr(sB, "knots")))
      #
      #   dcols <- grep(gsub("[[:digit:]]+$", "", x$colname),
      #                 colnames(Mlist$M[[dest_mat]]), fixed = TRUE)
      #   dest_col <- print_seq(min(dcols), max(dcols))
      # }


      lvls <- Mlist$group_lvls[gsub("M_", "", Mlist$Mlvls[vars])]

      for (k in seq_along(vars)) {
        if (lvls[k] == min(lvls)) {
          theindex <- index
        } else if (min(lvls) == 1L) {
          theindex <- paste0("group_", names(lvls)[k], "[", index, "]")
        } else {
          theindex <- paste0("group_", names(lvls)[k], "[",
                             "pos_", names(lvls)[which.min(lvls)], "[",
                             index, "]]")
        }

        fct <- if (isgk) {
          gsub(paste0("\\b", vars[k], "\\b"),
               paste0(vars_mat[k], "gk[", theindex, ", ",
                      vars_cols[k], ", k]"), fct)
        } else {
          gsub(paste0("\\b", vars[k], "\\b"),
               paste0(vars_mat[k], "[", theindex, ", ",
                      vars_cols[k], "]"), fct)
        }
      }

      paste0(tab(4L),
             dest_mat, if (isgk) "gk", "[", index, ", ", dest_col,
             if (isgk) ", k", "] <- ", fct, "\n")
    }
  })

  paste0("\n\n",
         paste0(Filter(Negate(is.null), unique(trafolist)), collapse = ""),
         "\n")
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


replace_interaction <- function(nam, interactions) {
  if (nam %in% names(interactions)) {
    attr(interactions[[nam]], "elements")
  } else {
    nam
  }
}

# used in get_model_info and predict (2020-09-06)
#' Convert a survival outcome to a model name
#'
#' A helper function that converts the "name of a survival model"
#' (the \code{"Surv(time, status)"} specification) into a valid variable name
#' so that it can be used in the JAGS model syntax.
#'
#' @param x a character string or vector of character strings
#'
#' @examples
#' clean_survname("Surv(eventtime, event != 'censored')")
#'
#' @export

clean_survname <- function(x) {

  # use cvapply in case x is a vector of variable names
  cvapply(x, function(z) {
    is_surv <- grepl("^Surv\\(", z)

    if (is_surv) {

      # replace symbols not allowed in variable names to create a valid variable
      # name replacing the survival model outcome string in the JAGS model.
      z <- gsub(",* *type * = * [[:print:]]*", "", z)
      z <- gsub("[)\'\"]", "", z)
      z <- gsub("[[:punct:]]* *I\\(", "_", z)
      z <- gsub(" *== *", "_", z)
      z <- gsub(" *!= *", "_", z)
      z <- gsub(" *<=* *", "_", z)
      z <- gsub(" *>=* *", "_", z)
      z <- gsub(" *, *", "_", z)
      z <- gsub("\\(", "_", z)

      abbreviate(z, minlength = 15L, use.classes = TRUE)
    } else {
      z
    }
  })
}


# model_imp helpers ------------------------------------------------------------

# used in add_samples, get_params, model_imp (2020-06-09)
get_coef_names <- function(info_list) {
  # extract the names of the regression coefficients and the corresponding
  # variable names
  # - info_list: a model info list (obtained from get_model_info())

  nlapply(info_list, function(info) {

    # find all parameter elements with the same parameter name to find
    # out if this parameter needs to get indexed or not
    pars <- nlapply(info_list, function(k) {
      if (k$parname %in% info$parname)
        unlist(c(k$parelmts, lapply(k$parelmts, "attr", "nonprop")))
    })


    parelmts <- unlist(unname(info$parelmts), recursive = FALSE)

    if (!is.list(parelmts)) {
      parelmts <- list(parelmts)
      names(parelmts) <- NA
    }


    out <- if (any(ivapply(info$lp, length) > 0L)) {
      data.frame(outcome = unname(info$varname),
                 outcat = rep(names(parelmts), ivapply(parelmts, length)),
                 varname = names(unlist(unname(parelmts))),
                 coef = paste0(info$parname,
                               if (length(unlist(pars)) > 1L)
                                 paste0("[", unlist(parelmts), "]")
                 ),
                 stringsAsFactors = FALSE
      )
    }

    nonprop <- unlist(unname(lapply(info$parelmts, attr, "nonprop")),
                      recursive = FALSE)

    if (!is.null(unlist(nonprop))) {
      out <- rbind(out,
                   data.frame(outcome = unname(info$varname),
                              outcat = rep(names(nonprop),
                                           ivapply(nonprop, length)),
                              varname = unlist(lapply(nonprop, names)),
                              coef = paste0(info$parname,
                                            paste0("[", unlist(nonprop), "]")),
                              stringsAsFactors = FALSE)
      )
    }

    if (!is.null(out)) {
      out$varnam_print <- cvapply(seq_along(out$outcat), function(k) {
        switch(as.character(is.na(out$outcat[k])),
               "TRUE" = out$varname[k],
               "FALSE" = paste0(out$outcat[k], ": ", out$varname[k])
        )
      })
    }

    rownames(out) <- NULL
    out
  })
}



# data_list helpers --------------------------------------------------------

# used in get_data_list and predict (2020-06-09)
get_matgk <- function(Mlist, gkx, surv_lvl, survinfo, data, rows = NULL,
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
  #         times (or 1L:nrow(newdata when used in prediction)
  # - td_cox: logical; is this for a time-dependent cox model?

  # rows to replicate when setting up gk_data
  if (is.null(rows))
    rows <- match(unique(data[, surv_lvl]), data[, surv_lvl])

  # base-version of gk_data: one row per unit of the survival outcome level
  gk_data <- data[rep(rows, each = length(gkx)), ]

  # replace the id variable on the survival outcome level
  gk_data[, surv_lvl] <- rep(data[rows, surv_lvl], each = length(gkx))


  # replace the survival time with the Gauss-Kronrod version of it
  surv_time_name <- unique(cvapply(survinfo, "[[", "time_name"))
  gk_data[, Mlist$timevar] <- c(t(outer(data[rows, surv_time_name] / 2L,
                                        gkx + 1L)))


  # for a time-dependent cox model: use last-observation carried forward to fill
  # in the time-varying covariate values at the time-points that were determined
  # based on Gauss-Kronrod quadrature
  if (td_cox) {
    gk_data <- get_locf(fixed = Mlist$fixed, data = data,
                        idvar = surv_lvl,
                        group_lvls = Mlist$group_lvls, groups = Mlist$groups,
                        timevar = Mlist$timevar,
                        longvars = unique(unlist(lapply(survinfo, "[[",
                                                        "longvars"))),
                        gk_data)
  } else {

    for (k in unique(unlist(lapply(survinfo, "[[", "tv_vars")))) {
      gk_data[, k] <- if (is.factor(gk_data[, k])) {
        factor(NA, levels = levels(gk_data[, k]))
      } else NA * gk_data[, k]
    }

  }



  dsgn_mat <- model_matrix_combi(fmla = c(Mlist$fixed,
                                          unlist(remove_grouping(Mlist$random)),
                                          Mlist$auxvars),
                                 data = gk_data, refs = Mlist$refs,
                                 terms_list = Mlist$terms_list)

  dsgn_mat_new <- matrix(nrow = length(rows) * length(gkx),
                         ncol = ncol(Mlist$M$M_lvlone),
                         dimnames = list(NULL, colnames(Mlist$M$M_lvlone)))

  dsgn_mat_new[, colnames(dsgn_mat)[
    colnames(dsgn_mat) %in% colnames(dsgn_mat_new)]] <-
    dsgn_mat[, colnames(dsgn_mat)[
      colnames(dsgn_mat) %in% colnames(dsgn_mat_new)]]

  lapply(seq_len(length(gkx)), function(k) {
    dsgn_mat_new[length(gkx) * ((seq_len(length(rows))) - 1L) + k, ]
  })
}



# used here, in get_matgk() (2020-06-09)
get_locf <- function(fixed, data, idvar, group_lvls, groups, timevar,
                     longvars, gk_data) {

  # Fill in the longitudinal covariate values in the Gauss-Kronrod version of
  # the design matrix for level one using last-observation-carried-forward.
  # !!! If there is no observation of the longitudinal covariate at baseline
  #     (at timevar = 0L) the first available value will be used.
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
                              function(k) 1L:k))

  # turn long data into wide format, one column per visit
  wd <- reshape(ld, direction = "wide", v.names = c(timevar, longvars),
                timevar = "obstime", idvar = idvar)

  # check if there are variables for which some subjects have no observation
  anymis <- lvapply(longvars, function(v) {
    obs <- rowSums(!is.na(wd[, grep(paste0("^", v, ".[[:digit:]]*$"),
                                    names(wd))]))
    any(obs == 0L)
  })

  if (any(anymis)) {
    errormsg("There are subjects without any observations in the time-varying
             variable(s) %s.", paste_and(dQuote(names(anymis)[anymis])))
  }

  # add a column identifying the original ordering of the rows to gk_data
  gk_data$rowid <- seq_len(nrow(gk_data))

  # merge gk_data with wide format version of the time-varying covariates
  md <- merge(subset(gk_data, select = c(idvar, timevar, "rowid")), wd)



  valcol_nrs = vapply(longvars, function(k) {
    grep(paste0("^", k, "."), colnames(md))
  }, FUN.VALUE = integer(max(ld$obstime)))


  md_list <- lapply(seq_len(nrow(md)), get_row, dat = md)
  locf <- lapply(md_list, find_locf_cols,
              gk_time = which(names(md) == timevar),
              time_cols = grep(paste0("^", timevar, "."), colnames(md)),
              val_cols = valcol_nrs, longvars = longvars)


  # locf <- nlapply(seq_len(nrow(md)), function(i) {
  #   # identify which visit should be used
  #   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  #   # if there is no baseline visit (i.e., the first time with an observed value
  #   # is larger than the time in the Gauss-Kronrod version of the time) the
  #   # first available measurement will be used ("first value carried backward")
  #   valcol <- max(1L, which(
  #     c(md[i, timevar] >= md[i, grep(paste0("^", timevar, "."), colnames(md))])
  #   ), na.rm = TRUE)
  #
  #
  #   # identify which columns have the covariate values of the correct visit
  #   covcols <- ivapply(longvars, function(k) {
  #     grep(paste0("^", k, "."), colnames(md))[valcol]
  #   })
  #
  #   out <- md[i, covcols, drop = FALSE]
  #   names(out) <- longvars
  #   out
  # })

  md[, longvars] <- do.call(rbind, locf)

  gk_data_new <- merge(subset(gk_data, select = !names(gk_data) %in% longvars),
                       subset(md, select = c(idvar, timevar, longvars, "rowid"))
  )
  gk_data_new[order(gk_data_new$rowid), ]
}




# used in get_data_list and predict (2020-06-09)
get_survinfo <- function(info_list, Mlist) {
  # make a list containing relevant information of survival outcomes, to
  # make subsequent syntax easier to handle/read
  # - info_list: list of model info as obtained from get_model info()
  # - Mlist: as obtained from divide_matrics()

  modeltypes <- cvapply(info_list, "[[", "modeltype")

  nlapply(names(info_list[modeltypes %in% c("coxph", "JM")]), function(k) {

    x <- info_list[[k]]

    surv_lvl <- gsub("M_", "", x$resp_mat[2L])
    longlvls <- names(Mlist$group_lvls)[Mlist$group_lvls <
                                          Mlist$group_lvls[surv_lvl]]

    if (any(longlvls != "lvlone"))
      errormsg("There can be only one level of observations below the level
               on which survival is measured.")


    covars <- all_vars(remove_lhs(Mlist$fixed[[k]]))
    covar_lvls <- cvapply(Mlist$data[, covars, drop = FALSE], check_varlevel,
                          groups = Mlist$groups,
                          group_lvls = identify_level_relations(Mlist$groups))
    longvars <- names(covar_lvls)[covar_lvls %in% longlvls]

    survevent <- Mlist$M[[x$resp_mat[2L]]][, x$resp_col[2L]]

    if (any(!survevent %in% c(0L, 1L))) {
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
         haslong = isTRUE(!is.null(unlist(x$lp[paste0("M_", longlvls)]))),
         tv_vars = names(x$tv_vars),

         # name of the variable containing time of the repeated measurements:
         time_name = Mlist$outcomes$outnams[[k]][1L],
         survtime = Mlist$M[[x$resp_mat[1L]]][, x$resp_col[1L]],
         survevent = Mlist$M[[x$resp_mat[2L]]][, x$resp_col[2L]]

    )
  })
}


find_locf_cols <- function(vec, gk_time, time_cols, val_cols, longvars) {
  valcol <- max(1L, which(c(as.numeric(vec[gk_time]) >=
                              as.numeric(vec[time_cols]))), na.rm = TRUE)
  setNames(vec[val_cols[valcol, ]], longvars)
}


get_row <- function(dat, i) {
  row <- lapply(1:ncol(dat), function(j) {.subset2(dat, j)[i]})
  names(row) <- names(dat)
  attr(row, "class") <- "data.frame"
  attr(row, "row.names") <- 1L
  row
}


# seed value
set_seed <- function(seed) {
  if ((R.version$major > 3L |
       (R.version$major == 3L & R.version$minor >= 6.0)) &
      Sys.getenv("IS_CHECK") == "true") {
    suppressWarnings(set.seed(seed, sample.kind = "Rounding"))
  } else {
    set.seed(seed)
  }
}
