errormsg <- function(x, ...) {
  stop(strwrap(gettextf(x, ...), prefix = "\n"), call. = FALSE)
}


msg <- function(x, ...) {
  message(strwrap(gettextf(x, ...), prefix = "\n"))
}




# Check if a variable is time-varying ------------------------------------------
#' Check if a variable is time-varying
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @keywords internal
#' @return a logical value
# check_tvar <- function(x, idvar) {
#   sapply(idvar, function(k) {
#     !all(sapply(split(x, k),
#                 function(z) identical(unname(z), rep(unname(z[1]), length(z)))
#                 #all.equal(z == z[1], na.rm = TRUE)
#     ))
#   })
# }


get_groups <- function(idvar, data) {
  # idvar: vector of names of the id variables
  # data: a data.frame

  if (!is.null(idvar)) {
    groups <- sapply(idvar, function(i) {
      match(data[, i], unique(data[, i]))
    }, simplify = FALSE)

    # check for unnecessary nesting levels
    gr_length <- sapply(groups, function(x)length(unique(x))) == nrow(data)
    if (any(gr_length)) {
      if (sum(gr_length) == 1) {
        stop(strwrap(gettextf("\nThe grouping level %s seem to be unnecessary.
                              There are only unique observations at this level.",
                              names(gr_length[gr_length])
        ), prefix = "\n", initial = ''), call. = FALSE)
      } else {
        stop(strwrap(gettextf("\nThe grouping levels %s seem to be unnecessary.
                              There are only unique observations at these levels.",
             names(gr_length[gr_length])
             ), prefix = "\n", initial = ''), call. = FALSE)
      }
    }

    groups$levelone <- 1:nrow(data)

    # check for duplicate levels
    gr_dupl <- duplicated(groups)
    if (any(gr_dupl)) {
      gr_dupl2 <- duplicated(groups, fromLast = TRUE)
      stop(strwrap(gettextf("The grouping levels %s are duplicats.",
                            unique(names(groups)[gr_dupl], names(groups)[gr_dupl2])),
                   prefix = "\n", initial = ''), call. = FALSE)
    }
  } else {
    groups = list(levelone = 1:nrow(data))
  }

  groups
}


# check_cluster <- function(x, grouping) {
#   sapply(grouping, function(k) {
#     !all(sapply(split(x, k),
#                 function(z) identical(unname(z), rep(unname(z[1]), length(z)))
#     ))
#   })
# }

check_cluster <- function(x, grouping) {
  sapply(grouping, function(k) {
    !identical(unname(x[match(unique(k), k)][match(k, unique(k))]), unname(x))
  })
}


identify_level_relations <- function(grouping) {
  if (!is.list(grouping))
    grouping <- list(grouping)

  g <- do.call(cbind, grouping)
  res <- apply(g, 2, check_cluster, grouping = grouping)

  if (!is.matrix(res))
    res <- t(res)

  res
}

check_varlevel <- function(x, groups, group_lvls = NULL) {
  if (!is.list(groups))
    groups <- list('no_levels' = groups)


  clus <- check_cluster(x, grouping = groups)

  if (sum(!clus) > 1) {
    if (is.null(group_lvls))
      group_lvls <- identify_level_relations(groups)

    names(which.max(colSums(!group_lvls[!clus, !clus, drop = FALSE])))
  } else if (sum(!clus) == 1) {
    names(clus)[!clus]
  } else {
    'levelone'
  }
}



# used in divide_matrices (2020-03-04)
match_interaction <- function(inter, M) {
  Mnam <- sapply(M, colnames, simplify = FALSE)

  out <- sapply(inter, function(i) {
    elmts <- strsplit(i, ":")[[1]]

    if (!any(is.na(c(match(i, unlist(Mnam)),
                     sapply(elmts, match, unlist(Mnam)))))) {

      # find matrix and column containing the interaction term
      inter_match <- sapply(names(M), function(k) {
        if (!is.na(match(i, Mnam[[k]])))
          match(i, Mnam[[k]])
          # setNames(match(i, Mnam[[k]]), k)
      })


      # find matrices and columns of the elements
      elmt_match <- lapply(elmts, function(j) {
        # unname(
          sapply(names(M), function(k) {
            if (!is.na(match(j, Mnam[[k]]))) match(j, Mnam[[k]])
            # if (!is.na(match(j, Mnam[[k]]))) setNames(match(j, Mnam[[k]]), k)
          })
        # )
      })


      structure(
        list(
          interterm = unlist(inter_match),
          elmts = unlist(elmt_match)),
        interaction = i, elements = elmts,
        has_NAs = ifelse(any(sapply(M, function(x)
          any(is.na(x[, elmts[elmts %in% colnames(x)]])))
        ), TRUE, FALSE)
      )
    }}, simplify = FALSE)

  if (any(!sapply(out, is.null))) out[!sapply(out, is.null)]
}



# prepare the outcome for the data_list to be passed to JAGS
# outcomes: a data.frame containing covariates for which models are specified
# analysis_type: string specifying the type of model
prep_covoutcomes <- function(dat) {

  nlev <- sapply(dat, function(x) length(levels(x)))

  if (any(nlev > 2))
    # ordinal variables have values 1, 2, 3, ...
    dat[nlev > 2] <- sapply(dat[nlev > 2], as.numeric)

  if (any(nlev == 2))
    # binary variables have values 0, 1
    dat[nlev == 2] <- sapply(dat[nlev == 2], as.numeric) - 1

  data.matrix(dat)
}



replace_dummy <- function(nam, refs) {
  if (is.null(refs))
    return(nam)

  dummies <- lapply(refs, "attr",  "dummies")

  if (any(sapply(dummies, function(k) nam %in% k)))
    names(dummies)[sapply(dummies, function(k) nam %in% k)]
  else
    nam
}

replace_trafo <- function(nam, trafos) {
  if (nam %in% trafos$colname) {
    unique(trafos$var[trafos$colname %in% nam])
  } else {nam}
}




get_coef_names <- function(info_list) {
  sapply(info_list, function(info) {

    pars <- sapply(info_list, function(k) {
      if (k$parname %in% info$parname)
        unlist(k$parelmts)
    })

    if (any(!sapply(info$lp, is.null)))
      data.frame(outcome = unname(info$varname),
                 varname = names(unlist(unname(info$lp))),
                 coef = paste0(info$parname,
                               if (length(pars) > 1) paste0("[", unlist(info$parelmts), "]")
                 ),
                 stringsAsFactors = FALSE
      )
  }, simplify = FALSE)
}




get_locf <- function(fixed, data, idvar, group_lvls, groups, timevar,
                     longvars, gk_data) {

  ld <- subset(data, select = c(idvar, timevar, longvars))
  ld <- ld[order(ld[, idvar]), ]
  ld$obstime <- unlist(lapply(table(droplevels(ld[, idvar, drop = FALSE])),
                              function(k) 1:k))

  wd <- reshape(ld, direction = 'wide', v.names = c(timevar, longvars),
                timevar = 'obstime', idvar = idvar)

  gk_data$rowid <- 1:nrow(gk_data)
  md <- merge(subset(gk_data, select = c(idvar, timevar, 'rowid')), wd)


  locf <- sapply(1:nrow(md), function(i) {
    # identify which visit should be used
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
    names(out) = longvars
    out
  }, simplify = FALSE)

  md[, longvars] <- do.call(rbind, locf)

  gk_data_new <- merge(subset(gk_data, select = !names(gk_data) %in% longvars),
                       subset(md, select = c(idvar, timevar, longvars, 'rowid'))
  )
  gk_data_new[order(gk_data_new$rowid), ]
}



get_Mgk <- function(Mlist, gkx, surv_lvl, survinfo, data, rows = NULL, td_cox = FALSE) {

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



  if (td_cox) {
    gk_data <- get_locf(fixed = Mlist$fixed, data = data,
                        idvar = surv_lvl,
                        group_lvls = Mlist$group_lvls, groups = Mlist$groups,
                        timevar = Mlist$timevar,
                        longvars = unique(unlist(lapply(survinfo, "[[", 'longvars'))),
                        gk_data)
  } else {

    for (k in unique(unlist(lapply(survinfo, "[[", "tv_vars")))) {
      gk_data[, k] <- if (is.factor(gk_data[, k])) {
        factor(NA, levels = levels(gk_data[, k]))
      } else NA * gk_data[, k]
    }

  }



  X <- model.matrix_combi(fmla = c(Mlist$fixed, unlist(remove_grouping(Mlist$random)),
                                   Mlist$auxvars),
                          data = gk_data,
                          terms_list = Mlist$terms_list)

  Xnew <- matrix(nrow = length(rows) * length(gkx),
                 ncol = ncol(Mlist$M$M_levelone),
                 dimnames = list(c(), colnames(Mlist$M$M_levelone)))

  Xnew[, colnames(X)[colnames(X) %in% colnames(Xnew)]] <-
    X[, colnames(X)[colnames(X) %in% colnames(Xnew)]]

  lapply(1:length(gkx), function(k) {
    Xnew[length(gkx) * ((1:length(rows)) - 1) + k, ]
  })
}


# get_Mlgk <- function(survrow, gkx, newdata, data, Mlist, surv_lvl, timevar, td_cox = FALSE) {
#
#   gk_data <- newdata[rep(survrow, each = length(gkx)), ]
#   gk_data[, lvl] <- rep(newdata[survrow, lvl], each = length(gkx))
#   gk_data[, timevar] <- c(t(outer(newdata[survrow, timevar]/2, gkx + 1)))
#
#
#   if (td_cox) {
#     gk_data <- get_locf(fixed = Mlist$fixed, newdata = newdata, data = data,
#                         idvar = lvl, group_lvls = Mlist$group_lvls,
#                         groups = Mlist$groups, timevar, gk_data)
#   }
#
#   Xgk <- model.matrix_combi(fmla = c(Mlist$fixed, remove_grouping(Mlist$random),
#                                      Mlist$auxvars),
#                             data = gk_data,
#                             terms_list = Mlist$terms_list)
#
#   Xgk_new <- matrix(nrow = length(survrow) * length(gkx),
#                     ncol = ncol(Mlist$M$M_levelone),
#                     dimnames = list(c(), colnames(Mlist$M$M_levelone)))
#
#   Xgk_new[, colnames(Xgk)[colnames(Xgk) %in% colnames(Xgk_new)]] <-
#     Xgk[, colnames(Xgk)[colnames(Xgk) %in% colnames(Xgk_new)]]
#
#   lapply(1:length(gkx), function(k) {
#     Xgk_new[length(gkx) * ((1:length(survrow)) - 1) + k, ]
#   })
#
#   # Mlgk <- array(data = unlist(Mlgk),
#   #               dim = c(length(survrow), ncol(Mlgk[[1]]), length(gkx)),
#   #               dimnames = list(c(), colnames(Mlist$Ml), c())
#   # )
# }



get_survinfo <- function(info_list, Mlist) {
  modeltypes <- sapply(info_list, "[[", 'modeltype')
  sapply(names(info_list[modeltypes %in% c('coxph', 'JM')]), function(k) {

    x <- info_list[[k]]

    surv_lvl = gsub("M_", "" , x$resp_mat[2])
    longlvls <- names(Mlist$group_lvls)[Mlist$group_lvls < Mlist$group_lvls[surv_lvl]]

    if (any(longlvls != "levelone"))
      stop("There can be only one level of observations below the level on which survival is measured.")


    covars <- all_vars(remove_LHS(Mlist$fixed[[k]]))
    covar_lvls <- sapply(Mlist$data[, covars], check_varlevel, groups = Mlist$groups,
                         group_lvls = identify_level_relations(Mlist$groups))
    longvars <- names(covar_lvls)[covar_lvls %in% longlvls]


    list(varname = x$varname,
         modeltype = x$modeltype,
         surv_lvl = surv_lvl,
         longlvls = longlvls,
         longvars = longvars,
         haslong = isTRUE(!is.null(unlist(x$lp[paste0('M_', longlvls)]))),
         tv_vars = names(x$tv_vars),

         # name of the variable containing the time of the repeated measurements:
         time_name = Mlist$outcomes$outnams[[k]][1],
         survtime = Mlist$M[[x$resp_mat[1]]][, x$resp_col[1]],
         survevent = Mlist$M[[x$resp_mat[2]]][, x$resp_col[2]]

    )
  }, simplify = FALSE)
}




