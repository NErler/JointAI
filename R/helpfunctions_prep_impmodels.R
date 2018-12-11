
# Creates a list of parameters that will be passed to the functions generating the imputation models
# @param impmeth character string specifying the imputation method
# @param varname name of the variable to be imputed
# @param Xc design matrix of time-constant covariates
# @param Xcat matrix of incomplete categorical covariates with more than 2 categories
# @param K_imp matrix specifying the range of elements of the vector of regression
# coefficients to be used in each imputation model
# @param dest_cols column numbers in Xc matrix
# @param refs list of reference values
# @param trafos matrix of transformations
# @export
get_imp_par_list <- function(impmeth, varname, Xc, Xcat, K_imp, dest_cols,
                             refs, trafos, trunc) {

  intercept = ifelse(impmeth %in% c("cumlogit"),
                     ifelse(min(dest_cols[[varname]]$Xc) > 2, F, T), T)

  list(varname = varname,
       impmeth = impmeth,
       intercept = intercept,
       dest_mat = if (impmeth %in% c("multilogit", "cumlogit")) {
         "Xcat"
       } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         "Xtrafo"
       } else {"Xc"},
       dest_col = if (impmeth %in% c("multilogit", "cumlogit")) {
         dest_cols[[varname]]$Xcat
       } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         dest_cols[[varname]]$Xtrafo
       } else {
         dest_cols[[varname]]$Xc
       },
       par_elmts = if (impmeth == "multilogit") {
         sapply(names(dest_cols[[varname]]$Xc), function(i) {
           K_imp[i, 1]:K_imp[i, 2]
         }, simplify = FALSE)
       } else {
         K_imp[varname, 1]:K_imp[varname, 2]
       },
       Xc_cols = (1 + (!intercept)):(min(dest_cols[[varname]]$Xc) - 1),
       dummy_cols = if (impmeth %in% c("cumlogit", "multilogit")) {
         dest_cols[[varname]]$Xc
       },
       ncat = if (impmeth %in% c("cumlogit", "multilogit")) {
         length(dest_cols[[varname]]$Xc) + 1
       },
       refcat = if (impmeth %in% c("logit", "cumlogit", "multilogit")) {
         which(refs[[varname]] == levels(refs[[varname]]))
       },
       trafo_cols = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         dest_cols[[varname]]$Xc
       },
       trfo_fct = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         sapply(which(trafos$var == varname & !trafos$dupl), get_trafo, trafos, dest_cols)
       },
       trunc = trunc[[varname]],
       trafos = trafos,
       par_name = "alpha")
}




get_trafo <- function(i, trafos, dest_cols) {
  if (trafos[i, "type"] == "identity") {
    ret <- paste0("Xtrafo[i, ", dest_cols[[trafos[i, "var"]]]$Xtrafo, "]")
  } else if (trafos[i, "type"] == "I") {
    is_power <- regexpr(paste0(trafos[i, "var"], "\\^[[:digit:]]+"),
                        trafos[i, "fct"]) > 0
    if (is_power) {
      pow <- gsub(paste0("I\\(", trafos[i, "var"], "\\^|\\)"), "", trafos[i, "fct"])
      ret <- paste0("pow(Xtrafo[i, ", dest_cols[[trafos[i, "var"]]]$Xtrafo, "], ", pow, ")")
    } else {
      ret <- gsub(trafos[i, "var"], paste0("Xtrafo[i, ",
                                           dest_cols[[trafos[i, "var"]]]$Xtrafo,
                                           "]"), trafos[i, "fct"])
      ret <- gsub("\\)$", "", gsub("^I\\(", "", ret))
    }
  } else {
    ret <- gsub(trafos[i, "var"], paste0("Xtrafo[i, ",
                                         dest_cols[[trafos[i, "var"]]]$Xtrafo,
                                         "]"), trafos[i, "fct"])
  }
  if (!is.na(trafos[i, 'dupl_rows'])) {
    other_vars <- trafos[unlist(trafos[i, 'dupl_rows']), 'var']
    for (k in seq_along(other_vars)) {
      ret <- gsub(other_vars[k],
                  paste0('Xtrafo[i, ', dest_cols[[other_vars[k]]]$Xtrafo, ']'), ret)
    }
  }
  ret
}



# Find which column in either Xc or Xcat contains the variable to be imputed
# @param impmeth imputation method
# @param varname variable name
# @param Xc_names column names of the design matrix of baseline effects
# @param Xcat_names column names of the matrix of categorical variables
get_dest_column <- function(varname, refs, Xc_names, Xcat_names, Xtrafo_names,
                            trafos) {
  nams <- if (varname %in% names(refs)) {
    attr(refs[[varname]], "dummies")
    # paste0(varname,
    #              levels(refs[[varname]])[levels(refs[[varname]]) !=
    #                                        refs[[varname]]])
  } else if (varname %in% trafos$var) {
    trafos$X_var[trafos$var == varname & !trafos$dupl]
  } else {
    varname
  }

  list("Xc" = setNames(match(make.names(nams), make.names(Xc_names)), nams),
       "Xcat" = setNames(match(make.names(varname), make.names(Xcat_names)), varname),
       "Xtrafo" = setNames(match(make.names(varname), make.names(Xtrafo_names)), varname))
}


