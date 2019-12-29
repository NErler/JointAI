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




      if (any(is.na(Mc[, elmts[elmts %in% Mcnam]]),
              is.na(Ml[, elmts[elmts %in% Mlnam]]))) {
        structure(
          list(
            interterm = inter_match,
            elmts = unlist(elmt_match)),
          interaction = i, elements = elmts
        )
      }
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


#
# outcome1 <- list(y = data.frame(y = rgamma(10, 1, 0.1)))
# outcome2 <- list(y = data.frame(y = factor(sample(0:1, size = 10, replace = TRUE))))
# outcome3 <- list(y = data.frame(y = factor(sample(1:4, size = 20, replace = TRUE), ordered = TRUE)))
# outcome4 <- list(y = data.frame(y = factor(sample(1:4, size = 20, replace = TRUE), ordered = FALSE)))
# outcome5 <- list("Surv(time, status)" = as.data.frame.matrix(survival::Surv(rgamma(10, 1, 0.1), rbinom(10, 1, 0.5))))
# outcome6 <- list("cbind(x,y)" = data.frame(x = rnorm(10), y = rnorm(10)))
# outcome7 <- list(x = data.frame(x = rnorm(10)),
#                  y = data.frame(y = rnorm(10)))
#
# df <- data.frame(x = rnorm(10), y = rnorm(10), z = factor(rbinom(10, 1, 0.5)), a = factor(sample(1:3, 10, replace = T)))
# outcome8 <- list("cbind(x,y)" = with(df, data.frame(x, y)),
#                  "cbind(x,z)" = with(df, data.frame(x, z)),
#                  "cbind(x,a)" = with(df, data.frame(x, a, z)))
# outcome9 <- list("Surv(time, status)" = as.data.frame.matrix(survival::Surv(rgamma(10, 1, 0.1), rbinom(10, 1, 0.5))),
#                  x = data.frame(x = rnorm(30)))
#
#
# prep_outcome(outcomes = outcome1)
# prep_outcome(outcomes = outcome2)
# prep_outcome(outcomes = outcome3)
# prep_outcome(outcomes = outcome4)
# prep_outcome(outcomes = outcome5)
# prep_outcome(outcomes = outcome6)
# prep_outcome(outcomes = outcome7)
# prep_outcome(outcomes = outcome8)
# prep_outcome(outcomes = outcome9)

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
