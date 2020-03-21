#' Specify the default (imputation) model types
#' @inheritParams model_imp
#' @param analysis_type character sting identifying the type of analysis model;
#'                      currently only required for joint models for longitudinal
#'                      and survival data ("JM")
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

get_models <- function(fixed, random = NULL, data, auxvars = NULL,
                       timevar = NULL, no_model = NULL, models = NULL,
                       analysis_type = NULL, warn = TRUE) {

  if (missing(fixed))
    stop("No formula specified.", call. = FALSE)

  if (missing(data))
    stop("No dataset given.", call. = FALSE)

  if (!is.null(auxvars) & class(auxvars) != 'formula')
    stop(gettextf("The argument %s should be a formula.", dQuote("auxvars")), call. = FALSE)

  models_user <- models

  if (any(sapply(sapply(fixed, attr, 'type'), is.null)))
    fixed <- extract_outcome_data(fixed, random = random, data = data,
                                  analysis_type = analysis_type, warn = FALSE)$fixed

  # if there is a time variable, add it to no_model
  if (!is.null(timevar)) {
    no_model <- c(no_model, timevar)
  }

  # check that all variables are found in the data
  allvars <- unique(c(all_vars(fixed),
                      all_vars(random),
                      all_vars(auxvars),
                      names(models)))

  if (any(!allvars %in% names(data))) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
                  paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", ")),
                  call. = FALSE)
  }


  if (!is.null(no_model) && any(colSums(is.na(data[, no_model, drop = FALSE])) > 0)) {
    stop(gettextf("Variable(s) %s have missing values and imputation models are needed for these variables." ,
                  paste(dQuote(no_model[colSums(is.na(data[, no_model, drop = FALSE])) > 0]),
                        collapse = ", "),
                  call. = FALSE)
    )
  }


  # extract the id variable from the random effects formula and get groups
  idvar <- extract_id(random, warn = warn, allow_multiple = TRUE)
  groups <- get_groups(idvar, data)

  random2 <- remove_grouping(random)


  # new version of allvars, without the grouping variable
  allvars <- unique(c(
    names(fixed),
    all_vars(remove_LHS(fixed)),
    all_vars(random2),
    all_vars(auxvars),
    names(models)))

  group_lvls <- colSums(!identify_level_relations(groups))
  max_lvl <- max(group_lvls)

  if (length(allvars) > 0) {

    varinfo <- sapply(allvars, function(k) {
      x <- eval(parse(text = k), envir = data)
      out <- k %in% names(fixed)
      lvl <- group_lvls[check_varlevel(x, groups)]
      nmis <- sum(is.na(x[match(unique(groups[[names(lvl)]]), groups[[names(lvl)]])]))
      nlev <- length(levels(x))
      ordered <- is.ordered(x)
      data.frame(out = out, lvl = lvl, nmis = nmis, nlev = nlev, ordered = ordered, type = NA)
    }, simplify = FALSE)

    varinfo <- melt_data.frame_list(varinfo, id.vars = colnames(varinfo[[1]]))



    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & varinfo$ordered] <- 'clmm'
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & varinfo$ordered] <- 'clm'
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & !varinfo$ordered] <- 'mlogitmm'
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & !varinfo$ordered] <- 'mlogit'
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev == 2] <- 'glmm_binomial_logit'
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev == 2] <- 'glm_binomial_logit'
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev == 0] <- 'lmm'
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev == 0] <- 'lm'
    varinfo$type[varinfo$out] <- sapply(fixed, attr, 'type')


    varinfo <- varinfo[which(!varinfo$L1 %in% no_model), , drop = FALSE]

    types <- split(varinfo,
                   ifelse(varinfo$out, 'outcome',
                          ifelse(varinfo$nmis > 0,
                                 ifelse(!varinfo$lvl %in% max_lvl, 'incomplete_tvar', 'incomplete_baseline'),
                                 ifelse(!varinfo$lvl %in% max_lvl, 'complete_tvar', 'complete_baseline'))))


    types[which(names(types) != 'outcome')] <-
      lapply(types[which(names(types) != 'outcome')], function(x)
        x[order(-x$lvl, x$nmis, decreasing = TRUE), , drop = FALSE]
      )



    # unnecessary <- c(
    #   names(nmis[nmis == 0 & !tvar & names(nmis) %in% names(models)]),
    #   if (is.null(types$incomplete.baseline) & ((is.null(analysis_type) || analysis_type!= "JM")))
    #     types$complete.tvar[names(types$complete.tvar) %in% names(models)]
    # )
    #
    # if (length(unnecessary) > 0)
    #   message(gettextf(paste0("Note:\nModels have been specified for the variabe(s) %s.\n",
    #                   'These models are not needed for imputation and are likely ',
    #                   'to increase the computational time.'),
    #                   paste0(names(unnecessary), collapse = ', '))
    #                   )

    models <- rbind(types$outcome, types$incomplete_tvar,
                if (!is.null(types$incomplete_baseline))
                  types$complete_tvar,
                types$incomplete_baseline)

    models <- unlist(setNames(models$type, models$L1))


    models[names(models_user)] <- models_user

    if (any(models %in% c('mlogitmm'))) {
      stop(paste0("JointAI can't yet handle unordered longitudinal categorical covariates (>2 levels).\n",
                  "This feature is planned for the future."), call. = FALSE)
    }
  } else {
    models <- NULL
  }
  models
}
