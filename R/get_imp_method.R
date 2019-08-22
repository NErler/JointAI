#' Specify the default (imputation) model types
#' @inheritParams model_imp
#'
#' @return \code{get_models()} returns a list of two vectors named \code{models}
#'         and \code{meth}.\cr
#'         \code{models} is a named vector containing the names of covariates
#'         that either have missing values and/or are longitudinal (level-1)
#'         covariates and the corresponding (imputation) models as well
#'         as models for variables for which the user has specified a model.\cr
#'         \code{meth} is a subset of \code{models} containing only the variables
#'         that have missing values.
#'
#'
#' @examples
#' get_models(y ~ C1 + C2 + B2 + O2 + M2, data = wideDF)
#'
#' get_models(y ~ C1 + O2 + c2 + b1 + o2 + time, random = ~ 1 | id, data = longDF)
#'
#' get_models(y ~ C1 + O2 + c2 + b1 + o2 + time, random = ~ 1 | id,
#'            no_model = 'time', data = longDF)
#'
#' get_models(y ~ C1 + O2 + c2 + b1 + o2 + time, random = ~ 1 | id,
#'            no_model = 'time', data = longDF, models = c(C1 = 'norm'))
#'
#' @export

get_models <- function(fixed, random = NULL, data,
                         auxvars = NULL, no_model = NULL, models = NULL){

  if (missing(fixed))
    stop("No formula specified.", call. = FALSE)

  if (missing(data))
    stop("No dataset given.", call. = FALSE)

  if (!is.null(auxvars) & class(auxvars) != 'formula')
    stop(gettextf("The argument %s should be a formula.", dQuote("auxvars")), call. = FALSE)

  # check that all variables are found in the data
  allvars <- unique(c(all.vars(fixed[[3]]),
                      all.vars(random),
                      all.vars(auxvars),
                      names(models)))

  if (any(!allvars %in% names(data))) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
                  paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", ")),
                  call. = FALSE)
  }


  if (!is.null(no_model) && any(colSums(is.na(data[, no_model, drop = FALSE])) > 0)) {
    stop(gettextf("Variable(s) %s have missing values and imputation models are needed for these variables." ,
                  paste(dQuote(no_model[colSums(is.na(data[, no_model, drop = FALSE])) > 0]), collapse = ", "),
                  call. = FALSE)
    )
  }


  # try to extract id variable from random
  id <- extract_id(random)
  idvar <- if (!is.null(id)) {
    data[, id]
  } else {
    1:nrow(data)
  }
  random2 <- remove_grouping(random)


  allvars <- unique(c(all.vars(fixed[[3]]),
                      all.vars(random2),
                      all.vars(auxvars),
                      names(models)))


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

    unnecessary <- c(names(nmis[nmis == 0 & !tvar & names(nmis) %in% names(models)]),
                     if (is.null(types$incomplete.baseline))
                       types$complete.tvar[names(types$complete.tvar) %in% names(models)]
                     )

    if (length(unnecessary) > 0)
      message(gettextf(paste0("Note:\nModels have been specified for the variabe(s) %s.\n",
                      'These models are not needed for imputation and are likely ',
                      'to increase the computational time.'),
                      paste0(unnecessary, collapse = ', '))
                      )

    models_user <- models

    models <- c(if(any(names(models) %in% names(types$complete.baseline))) types$complete.baseline,
                types$incomplete.baseline,
                if (!is.null(types$incomplete.baseline)) {
                  types$complete.tvar
                } else {
                  if (any(names(models) %in% names(types$complete.tvar)))
                  types$complete.tvar[names(types$complete.tvar) %in% names(models)]
                },
                types$incomplete.tvar)

    nlevel <- sapply(data[, names(models), drop = FALSE],
                     function(x) length(levels(x)))

    if (length(nlevel) > 0) {
      models[nlevel == 0 & !tvar[names(nlevel)]] <- "norm"
      models[nlevel == 0 &  tvar[names(nlevel)]] <- "lmm"
      models[nlevel == 2 & !tvar[names(nlevel)]] <- "logit"
      models[nlevel == 2 &  tvar[names(nlevel)]] <- "glmm_logit"
      models[nlevel  > 2 & !tvar[names(nlevel)]] <- "multilogit"
      models[nlevel  > 2 &  tvar[names(nlevel)]] <- "mlmm"
      models[sapply(data[, names(nlevel), drop = FALSE], is.ordered) & !tvar[names(nlevel)]] <- "cumlogit"
      models[sapply(data[, names(nlevel), drop = FALSE], is.ordered) & tvar[names(nlevel)]] <- "clmm"
    }

    models[names(models_user)] <- models_user

    meth <- models[nmis[names(models)] > 0]

    if (any(models %in% c('mlmm'))) {
      stop(paste0("JointAI can't yet handle unordered longitudinal categorical covariates (>2 levels).\n",
                  "This feature is planned for the future."), call. = FALSE)
    }
  } else {
    models <- NULL
    meth <- NULL
  }
  return(list(models = models, meth = meth))
}



# #' @rdname get_models
# #' @export
# get_imp_meth <- function(fixed, random = NULL, data,
#                          auxvars = NULL, no_model = NULL, models = NULL){
#   get_models(fixed = fixed, random = random, data = data, auxvars = auxvars,
#              no_model = no_model, models = models)$meth
# }
