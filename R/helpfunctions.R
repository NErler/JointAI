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
  if (!is.null(idvar)) {
    groups <- sapply(idvar, function(i) {
      match(data[, i], unique(data[, i]))
    }, simplify = FALSE)
    groups$toplevel <- 1:nrow(data)
  } else {
    groups = list(toplevel = 1:nrow(data))
  }

  groups
}


check_cluster <- function(x, grouping) {
  sapply(grouping, function(k) {
    !all(sapply(split(x, k),
                function(z) identical(unname(z), rep(unname(z[1]), length(z)))
    ))
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

check_varlevel <- function(x, groups) {
  if (!is.list(groups))
    groups <- list('no_levels' = groups)

  clus <- check_cluster(x, grouping = groups)

  if (sum(!clus) > 1) {
    group_lvls <- identify_level_relations(groups)
    names(which.max(colSums(!group_lvls[!clus, !clus, drop = FALSE])))
  } else if (sum(!clus) == 1) {
    names(clus)[!clus]
  } else {
    'toplevel'
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
      data.frame(outcome = info$varname,
                 varname = names(unlist(unname(info$lp))),
                 coef = paste0(info$parname,
                               if(length(pars) > 1) paste0("[", unlist(info$parelmts), "]")
                 ),
                 stringsAsFactors = FALSE
      )
  }, simplify = FALSE)
}




get_locf <- function(fixed, newdata, data, idvar, group_lvls, groups, timevar, gk_data) {
  covars <- all_vars(remove_LHS(fixed))
  covar_lvls <- sapply(data[, covars], check_varlevel, groups = groups)

  longvars <- covars[group_lvls[covar_lvls] < group_lvls[idvar]]

  ld <- subset(newdata, select = c(idvar, timevar, longvars))
  ld <- ld[order(ld[, idvar]), ]
  ld$obstime <- unlist(lapply(table(droplevels(ld[, idvar, drop = FALSE])), function(k) 1:k))

  wd <- reshape(ld, direction = 'wide', v.names = c(timevar, longvars),
                timevar = 'obstime', idvar = idvar)

  gk_data$rowid <- 1:nrow(gk_data)
  md <- merge(subset(gk_data, select = c(idvar, timevar, 'rowid')), wd)


  locf <- sapply(1:nrow(md), function(i) {
    # identify which visit should be used
    valcol <-  max(cumsum(
      c(md[i, timevar] > md[i, grep(paste0("^", timevar, "."), colnames(md))])
    ) + 1, na.rm = TRUE)


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



get_Mlgk <- function(survrow, gkx, newdata, data, Mlist, lvl, timevar, td_cox = FALSE) {

  gk_data <- newdata[rep(survrow, each = length(gkx)), ]
  gk_data[, lvl] <- rep(newdata[survrow, lvl], each = length(gkx))
  gk_data[, timevar] <- c(t(outer(newdata[survrow, timevar]/2, gkx + 1)))


  if (td_cox) {
    gk_data <- get_locf(fixed = Mlist$fixed, newdata = newdata, data = data,
                        idvar = lvl, group_lvls = Mlist$group_lvls,
                        groups = Mlist$groups, timevar, gk_data)
  }

  Xgk <- model.matrix_combi(fmla = c(Mlist$fixed, remove_grouping(Mlist$random),
                                     Mlist$auxvars),
                            data = gk_data,
                            terms_list = Mlist$terms_list)

  Xgk_new <- matrix(nrow = length(survrow) * length(gkx),
                    ncol = ncol(Mlist$M$M_toplevel),
                    dimnames = list(c(), colnames(Mlist$M$M_toplevel)))

  Xgk_new[, colnames(Xgk)[colnames(Xgk) %in% colnames(Xgk_new)]] <-
    Xgk[, colnames(Xgk)[colnames(Xgk) %in% colnames(Xgk_new)]]

  lapply(1:length(gkx), function(k) {
    Xgk_new[length(gkx) * ((1:length(survrow)) - 1) + k, ]
  })

  # Mlgk <- array(data = unlist(Mlgk),
  #               dim = c(length(survrow), ncol(Mlgk[[1]]), length(gkx)),
  #               dimnames = list(c(), colnames(Mlist$Ml), c())
  # )
}

