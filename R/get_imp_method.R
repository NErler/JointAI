#' Find default imputation methods and order
#' @inheritParams model_imp
#' @return A named vector containing those variables in \code{data}
#'         that have missing values and their assigned default imputation methods,
#'         sorted by proportion of missing values.
#'
#'
#' @examples
#' get_imp_meth(y ~ C1 + C2 + B2 + O2 + M2, data = wideDF)
#'
#'
#' @export

get_imp_meth <- function(fixed, random = NULL, data,
                         auxvars = NULL, no_model = NULL){
  get_models(fixed = fixed, random = random, data = data, auxvars = auxvars,
             no_model = no_model)$meth
}



#' @rdname get_imp_meth
#' @export

get_models <- function(fixed, random = NULL, data,
                         auxvars = NULL, no_model = NULL){

  if (missing(fixed))
    stop("No formula specified.")

  if (missing(data))
    stop("No dataset given.")

  random2 <- remove_grouping(random)

  # try to extract id variable from random
  id <- extract_id(random)
  idvar <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }

  allvars <- unique(c(all.vars(fixed[[3]]),
                      all.vars(random2),
                      if (!is.null(auxvars))
                        all.vars(as.formula(paste('~',
                                                  paste(auxvars, collapse = "+")))
                        )
  ))

  # check that all variables are found in the data
  if (any(!allvars %in% names(data))) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
                  paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", "),
                  call. = FALSE)
    )
  }


  if (!is.null(no_model) && any(colSums(is.na(data[, no_model, drop = FALSE])) > 0)) {
    stop(gettextf("Variable(s) %s have missing values and imputation models are needed for these variables." ,
                  paste(dQuote(no_model[colSums(is.na(data[, no_model, drop = FALSE])) > 0]), collapse = ", "),
                  call. = FALSE)
    )
  }



  if (length(allvars) > 0) {
    tvar <- sapply(data[, allvars, drop = FALSE], check_tvar, idvar)

    nmis <- c(colSums(is.na(data[, names(tvar[tvar]), drop = FALSE])),
              colSums(is.na(data[match(unique(idvar), idvar), names(tvar[!tvar]), drop = FALSE]))
    )

    if (all(nmis == 0))
      return(list(models = NULL, meth = NULL))

    nmis <- nmis[!names(nmis) %in% no_model]
    tvar <- tvar[names(nmis)]

    types <- lapply(split(nmis, list(ifelse(nmis > 0, 'incomplete', 'complete'),
                                     ifelse(tvar, 'tvar', 'baseline'))),
                    function(x) if (length(x) > 0) sort(x)
    )

    models <- c(types$incomplete.baseline,
                if (!is.null(types$incomplete.baseline)) types$complete.tvar,
                types$incomplete.tvar)

    nlevel <- sapply(data[, names(models), drop = FALSE],
                     function(x) length(levels(x)))

    if (length(nlevel) > 0) {
      models[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
      models[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
      models[nlevel == 2 & !tvar[names(nlevel)]] <- "logit"
      models[nlevel == 2 &  tvar[names(nlevel)]] <- "glmm_logit"
      models[nlevel  > 2 & !tvar[names(nlevel)]] <- "multilogit"
      models[nlevel  > 2 &  tvar[names(nlevel)]] <- "not yet implemented"
      models[sapply(data[, names(nlevel), drop = FALSE], is.ordered) & !tvar[names(nlevel)]] <- "cumlogit"
      models[sapply(data[, names(nlevel), drop = FALSE], is.ordered) & tvar[names(nlevel)]] <- "clmm"
    }

    meth <- models[nmis[names(models)] > 0]

  } else {
    models <- NULL
    meth <- NULL
  }
  return(list(models = models, meth = meth))
}






# get_imp_meth <- function(fixed, random = NULL, data,
#                          auxvars = NULL){
#
#   if (missing(fixed))
#     stop("No formula specified.")
#
#   if (missing(data))
#     stop("No dataset given.")
#
#
#   random2 <- remove_grouping(random)
#
#   # try to extract id variable from random
#   id <- extract_id(random)
#   idvar <- if (!is.null(id)) {
#     data[, id]
#   } else {
#     1:nrow(data)
#   }
#
#   allvars <- unique(c(all.vars(fixed[[3]]),
#                       all.vars(random2[2]),
#                       if (!is.null(auxvars))
#                         all.vars(as.formula(paste('~',
#                                                   paste(auxvars, collapse = "+")))
#                         )
#   ))
#
#   if (any(!allvars %in% names(data))) {
#     stop(gettextf("Variable(s) %s were not found in the data." ,
#                   paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", "))
#     )
#   }
#
#   if (length(allvars) > 0) {
#     tvar <- sapply(data[, allvars, drop = FALSE], check_tvar, idvar)
#
#
#     # find predictor variables with missing values
#     misvar <- names(data[, allvars, drop = FALSE])[colSums(is.na(data[, allvars, drop = FALSE])) > 0]
#     # crossectional incomplete variables:
#     misvar_c <- misvar[misvar %in% names(tvar)[!tvar]]
#
#     # time-varying incomplete variables (not yet used)
#     misvar_l <- misvar[misvar %in% names(tvar)[tvar]]
#
#     # sort by number of missing values
#     misvar <- c(misvar_c[order(colSums(is.na(data[, misvar_c, drop = FALSE])))],
#                 misvar_l[order(colSums(is.na(data[, misvar_l, drop = FALSE])))]
#     )
#
#
#     # named vector to assign imputation model types
#     meth <- rep("", length(misvar))
#     names(meth) <- misvar
#
#     nlevel <- sapply(misvar, function(k) {
#       if (!is.factor(data[, k])) {
#         if (length(unique(na.omit(data[, k]))) == 2) {
#           2
#         } else {
#           0
#         }} else {
#           length(levels(data[, k]))
#         }
#     })
#
#     if (length(nlevel) > 0) {
#       meth[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
#       # meth[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
#       meth[nlevel == 2] <- "logit"
#       meth[nlevel  > 2] <- "multilogit"
#       meth[sapply(data[, names(nlevel), drop = FALSE], is.ordered)] <- "cumlogit"
#     }
#
#     if (length(meth) == 0)
#       meth <- NULL
#   } else {
#     meth <- NULL
#   }
#   return(meth = meth)
# }
