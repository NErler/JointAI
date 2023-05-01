# Specify the default (imputation) model types
get_models <- function(fixed, random = NULL, data, auxvars = NULL,
                       timevar = NULL, no_model = NULL, models = NULL,
                       analysis_type = NULL, warn = TRUE) {

  if (missing(fixed))
    errormsg("No formula specified.")

  if (missing(data))
    errormsg("No dataset given.")

  if (!is.null(auxvars) & !inherits(auxvars, "formula"))
    errormsg("The argument %s should be a formula.", dQuote("auxvars"))

  models_user <- models

  if (is.null(attr(fixed[[1]], 'type')))
    fixed <- extract_outcome_data(fixed, random = random, data = data,
                                  analysis_type = analysis_type,
                                  warn = FALSE)$fixed


  # if there is a time variable, add it to no_model
  if (!is.null(timevar)) {
    no_model <- c(no_model, timevar)
  }

  # check that all variables are found in the data
  allvars <- unique(c(all_vars(c(fixed, random, auxvars)), timevar))

  if (any(!names(models) %in% names(data))) {
    errormsg("Variable(s) %s were not found in the data." ,
             paste_and(dQuote(names(models)[!names(models) %in% names(data)])))
  }


  if (!is.null(no_model) &&
      any(colSums(is.na(data[, no_model, drop = FALSE])) > 0)) {
    errormsg("Variable(s) %s have missing values and imputation models are
             needed for these variables." ,
             paste(dQuote(no_model[colSums(is.na(data[, no_model,
                                                      drop = FALSE])) > 0]),
                   collapse = ", "))
  }

  if (any(!names(models_user) %in% allvars)) {
    errormsg("You have specified covariate model types for the variable(s) %s
             which are not part of the model.",
             paste_and(dQuote(names(models_user)[
               !names(models_user) %in% allvars])))
  }



  # extract the id variable from the random effects formula and get groups
  idvar <- extract_id(random, warn = warn)
  groups <- get_groups(idvar, data)

  random2 <- remove_grouping(random)


  # new version of allvars, without the grouping variable
  allvars <- unique(c(names(fixed),
                      all_vars(c(remove_lhs(fixed), random2, auxvars)),
                      names(models), timevar))

  group_lvls <- colSums(!identify_level_relations(groups))
  max_lvl <- max(group_lvls)


  dat_all <- if (any(!allvars %in% names(data))) {
    cbind(data[, allvars[allvars %in% names(data)], drop = FALSE],
          sapply(allvars[!allvars %in% names(data)], function(x) {
            eval(parse(text = x), envir = data)
          }, simplify = FALSE)
    )
  } else {
    data[, allvars, drop = FALSE]
  }

    all_lvls <- get_datlvls(dat_all, groups)




  if (length(allvars) > 0) {

    varinfo <- sapply(allvars, function(k) {
      x <- eval(parse(text = k), envir = data)
      out <- k %in% names(fixed)
      lvl <- group_lvls[all_lvls[k]]
      nmis <- sum(is.na(x[match(unique(groups[[names(lvl)]]),
                                groups[[names(lvl)]])]))
      nlev <- length(levels(x))
      ordered <- is.ordered(x)
      data.frame(out = out, lvl = lvl, nmis = nmis, nlev = nlev,
                 ordered = ordered, type = NA)
    }, simplify = FALSE)

    varinfo <- melt_data_frame_list(varinfo, id_vars = colnames(varinfo[[1]]))



    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev > 2 &
                   varinfo$ordered] <- "clmm"
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev > 2 &
                   varinfo$ordered] <- "clm"
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev > 2 &
                   !varinfo$ordered] <- "mlogitmm"
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev > 2 &
                   !varinfo$ordered] <- "mlogit"
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev == 2] <-
      "glmm_binomial_logit"
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev == 2] <-
      "glm_binomial_logit"
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev == 0] <- "lmm"
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev == 0] <- "lm"

    survmods <- sapply(fixed, 'attr', 'type') %in% c('coxph', 'survreg', 'JM')
    if (any(survmods)) {
      varinfo$type[varinfo$L1 %in% names(fixed[survmods])] <-
        sapply(fixed[survmods], 'attr', 'type')
    }

    if (!is.null(attr(fixed[[1]], 'type')))
      varinfo$type[varinfo$L1 %in% names(fixed)[1]] <- attr(fixed[[1]], 'type')

    varinfo <- varinfo[which(!varinfo$L1 %in% no_model), , drop = FALSE]


    types <- split(varinfo,
                   ifelse(varinfo$out, 'outcome',
                          ifelse(varinfo$nmis > 0,
                                 paste0('incomplete_lvl', varinfo$lvl),
                                 paste0('complete_lvl', varinfo$lvl)
                          )))


    types[which(names(types) != 'outcome')] <-
      lapply(types[which(names(types) != 'outcome')], function(x)
        x[order(-x$lvl, x$nmis, decreasing = TRUE), , drop = FALSE]
      )



    NA_lvls <- unique(varinfo$lvl[varinfo$nmis > 0])


    models <- do.call(rbind,
                      c(types['outcome'],
                        if (any(!varinfo$out) & length(NA_lvls) > 0)
                        lapply(1:max(NA_lvls), function(k) {
                          set <- if (k == max(NA_lvls)) {
                            c('incomplete_lvl')
                          } else {
                            c('incomplete_lvl', 'complete_lvl')
                          }
                          do.call(rbind, types[paste0(set, k)])
                        })
                      ))

    models <- unlist(setNames(models$type, models$L1))


    models[names(models_user)] <- models_user

  } else {
    models <- NULL
  }
  models
}
