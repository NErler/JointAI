# Check if a variable is time-varying ------------------------------------------
#' Check if a variable is time-varying
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @keywords internal
#' @return a logical value
check_tvar <- function(x, idvar) {
  !all(sapply(split(x, idvar),
              function(z) identical(unname(z), rep(unname(z[1]), length(z)))
              #all.equal(z == z[1], na.rm = TRUE)
  ))
}



# used in divide_matrices (2019-12-26)
match_interaction <- function(inter, Mc, Ml) {
  Mcnam <- colnames(Mc)
  Mlnam <- colnames(Ml)

  out <- sapply(inter, function(i) {
    elmts <- strsplit(i, ":")[[1]]

    if (!any(is.na(c(match(i, c(Mcnam, Mlnam)),
                     sapply(elmts, match, c(Mcnam, Mlnam)))))) {

      # find matrix and column containing the interaction term
      inter_match <- c(
        if (!is.na(match(i, Mcnam)))
          setNames(match(i, Mcnam), 'Mc'),
        if (!is.na(match(i, Mlnam)))
          setNames(match(i, Mlnam), 'Ml')
      )

      # find matrices and columns of the elements
      elmt_match <- lapply(elmts, function(k) {
        c(
          if (!is.na(match(k, Mcnam)))
            setNames(match(k, Mcnam), 'Mc'),
          if (!is.na(match(k, Mlnam)))
            setNames(match(k, Mlnam), 'Ml')
        )})


      structure(
        list(
          interterm = inter_match,
          elmts = unlist(elmt_match)),
        interaction = i, elements = elmts,
        has_NAs = ifelse(any(is.na(Mc[, elmts[elmts %in% Mcnam]]),
                           is.na(Ml[, elmts[elmts %in% Mlnam]])), TRUE, FALSE)
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




get_locf <- function(fixed, newdata, data, idvar, timevar, gk_data) {
  covars <- all_vars(remove_LHS(fixed))
  longvars <- covars[sapply(data[, covars], check_tvar, idvar = data[, idvar])]

  ld <- subset(newdata, select = c(idvar, timevar, longvars))
  ld$obstime <- unlist(lapply(table(ld[, idvar]), function(k) 1:k))

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



get_Mlgk <- function(survrow, gkx, newdata, data, Mlist, timevar, td_cox = FALSE) {

  gk_data <- newdata[rep(survrow, each = length(gkx)), ]
  gk_data[, Mlist$idvar] <- rep(newdata[survrow, Mlist$idvar], each = length(gkx))
  gk_data[, timevar] <- c(t(outer(newdata[survrow, timevar]/2, gkx + 1)))


  if (td_cox) {
    gk_data <- get_locf(fixed = Mlist$fixed, newdata = newdata, data = data,
                        idvar = Mlist$idvar, timevar, gk_data)
  }

  Xgk <- model.matrix_combi(fmla = c(Mlist$fixed, Mlist$auxvars),
                            data = gk_data,
                            terms_list = Mlist$terms_list)

  Xgk_new <- matrix(nrow = length(survrow) * length(gkx),
                    ncol = ncol(Mlist$Ml),
                    dimnames = list(c(), colnames(Mlist$Ml)))

  Xgk_new[, colnames(Xgk)[colnames(Xgk) %in% colnames(Xgk_new)]] <-
    Xgk[, colnames(Xgk)[colnames(Xgk) %in% colnames(Xgk_new)]]

  Mlgk <- lapply(1:length(gkx), function(k) {
    Xgk_new[length(gkx) * ((1:length(survrow)) - 1) + k, ]
  })

  Mlgk <- array(data = unlist(Mlgk),
                dim = c(length(survrow), ncol(Mlgk[[1]]), length(gkx)),
                dimnames = list(c(), colnames(Mlist$Ml), c())
  )
}

