
# Creates a list of parameters that will be passed to the functions generating the imputation models
get_imp_par_list <- function(impmeth, varname, Mlist, K_imp, dest_cols, trunc, models) {

  # intercept <- if (impmeth == "cumlogit") {
  #   ifelse(min(dest_cols[[varname]]$Xc) > 2, FALSE, TRUE)
  # } else if (impmeth == "clmm") {
  #   ifelse(ncol(Mlist$Xc) > 1 | min(dest_cols[[varname]]$Xl) > 2, FALSE, TRUE)
  # } else {
  #   TRUE
  # }

  varname_dum <- dummyfy(varname, Mlist$refs)
  intercept <- intercept_needed(impmeth,
                                nbasevars = get_nbasevars(varname_dum,
                                                          colnames(Mlist$Xc),
                                                          intercept = FALSE),
                                nlongvars = get_nlongvars(varname_dum,
                                                          colnames(Mlist$Xl),
                                                          intercept = FALSE))

  # get a dummy version of the names of "models"
  mod_dum <- sapply(names(models), dummyfy, Mlist$refs, simplify = FALSE)

  # mod_dum <- sapply(names(models), function(k) {
  #   if (k %in% names(Mlist$refs)) {
  #     attr(Mlist$refs[[k]], 'dummies')
  #   } else {
  #     k
  #   }
  # }, simplify = FALSE)


  i <- which(names(models) == varname)

  hcvar <- ifelse(names(Mlist$hc_list) %in% Mlist$trafos$X_var,
           Mlist$trafos$var[match(names(Mlist$hc_list), Mlist$trafos$X_var)],
           names(Mlist$hc_list))

  nam <- names(Mlist$hc_list)[which(!hcvar %in% unlist(mod_dum[i:length(mod_dum)]))]

  # columns in Xc to be used
  # Xc_cols = if (impmeth %in% c('lmm', 'glmm_lognorm', 'glmm_logit', 'glmm_gamma',
  #                              'glmm_poisson', 'clmm')) {
  #   if (1 + (!intercept) <= ncol(Mlist$Xc))
  #     (1 + (!intercept)):ncol(Mlist$Xc)
  # } else {
  #   (1 + (!intercept)):(min(dest_cols[[varname]]$Xc) - 1)
  # }

  Xc_cols <- get_basevar_cols(varname_dum, colnames(Mlist$Xc), intercept = intercept)


  # columns in Xl to be used
  # Xl_cols <- if (impmeth %in% c('lmm', 'glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')) {
  #   if (all(is.na(dest_cols[[varname]]$Xl[mod_dum[[varname]]]))) {
  #     wouldbe <- max(0, which(colnames(Mlist$Xl) %in% unlist(mod_dum[seq_along(models) < i]))) + 1
  #     if (wouldbe > 1) 1:(wouldbe - 1)
  #   } else  if (min(dest_cols[[varname]]$Xl, na.rm = TRUE) > 1) {
  #     1:(min(dest_cols[[varname]]$Xl, na.rm = TRUE) - 1)
  #   }
  # }
  Xl_cols <- get_longvar_cols(varname_dum, colnames(Mlist$Xl), intercept = intercept)

  # columns of Z to be used
  Z_cols = if (impmeth %in% c('lmm','glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')) {
    if (Mlist$nranef > 1) {
      which(!ifelse(colnames(Mlist$Z) %in% Mlist$trafos$X_var,
                    Mlist$trafos$var[match(colnames(Mlist$Z), Mlist$trafos$X_var)],
                    colnames(Mlist$Z)) %in% unlist(mod_dum[i:length(mod_dum)]))
    } else if (Mlist$nranef == 1) {
      1
    }
  }

  par_elmts <- if (impmeth == "multilogit") {
    sapply(names(dest_cols[[varname]]$Xc), function(i) {
      matrix(nrow = 1, ncol = 2, data = c(K_imp[i, 1], K_imp[i, 2]),
             byrow = T, dimnames = list('Xc', c('start', 'end')))
    }, simplify = FALSE)
  } else {
    K_imp_x <- matrix(nrow = 2 + length(nam), ncol = 2,
                      dimnames = list(c('Xc', 'Xl', nam),
                                      c('start', 'end')))

    if (length(Xc_cols) > 0)
      K_imp_x['Xc', ] <- K_imp[varname, 1] + c(1, length(Xc_cols)) - 1

    if (length(Xl_cols) > 0)
      K_imp_x['Xl', ] <- max(0, K_imp_x['Xc', 2], na.rm = TRUE) + c(1, length(Xl_cols))

    if (length(Z_cols) > 0)
      # K_imp_x['Z', ] <- max(K_imp_x, na.rm = T) + c(1, length(Z_cols) - 1)
      for (k in nam) {
        if (!is.null(Mlist$hc_list[[k]]))
          # K_imp_x[k, ] <- max(K_imp_x, na.rm = T) + c(1, sum(sapply(Mlist$hc_list[[k]],  "!=", varname)))
          K_imp_x[k, ] <- max(K_imp_x, na.rm = T) +
            c(1, sum(!sapply(Mlist$hc_list[[k]],
                            "%in%", unlist(mod_dum[i:length(mod_dum)]))
                     ))
      }
    K_imp_x
  }

  list(varname = varname,
       impmeth = impmeth,
       intercept = intercept,
       dest_mat = if (impmeth %in% c("multilogit", "cumlogit")) {
         "Xcat"
       } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         "Xtrafo"
       } else if (!is.na(dest_cols[[varname]]$Xltrafo)) {
         "Xltrafo"
       } else if (impmeth %in% c('lmm','glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson')) {
         varname_dum <- attr(Mlist$refs[[varname]], 'dummies')
         names(dest_cols[[varname]][which(sapply(dest_cols[[varname]],
                                                  function(k) any(!is.na(k[c(varname, varname_dum)]))
         ))])
       } else if (impmeth %in% c('clmm')) {
         "Xlcat"
       } else{"Xc"},
       dest_col = if (impmeth %in% c("multilogit", "cumlogit")) {
         dest_cols[[varname]]$Xcat
       } else if (impmeth %in% c('clmm', "mlmm")) {
         dest_cols[[varname]]$Xlcat
       } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         dest_cols[[varname]]$Xtrafo
       } else if (!is.na(dest_cols[[varname]]$Xltrafo)) {
         dest_cols[[varname]]$Xltrafo
       } else if (impmeth %in% c("lmm",'glmm_lognorm', "glmm_logit", "glmm_gamma", "glmm_poisson")) {
         varname_dum <- attr(Mlist$refs[[varname]], 'dummies')
         dc <- dest_cols[[varname]][[which(sapply(dest_cols[[varname]],
                                            function(k) any(!is.na(k[c(varname, varname_dum)]))
                                            ))]]
         dc[names(dc) %in% c(varname, varname_dum)]
       } else {
         dest_cols[[varname]]$Xc
       },
       par_elmts = par_elmts,
       Xc_cols = Xc_cols,
       Xl_cols = Xl_cols,
       Z_cols = Z_cols,
       dummy_mat = if (impmeth %in% c('clmm', 'mlmm')) {
         dm <- sapply(dest_cols[[varname]],
                      function(k) all(!is.na(k[attr(Mlist$refs[[varname]], 'dummies')])))

         names(dm[dm])
       },
       dummy_cols = if (impmeth %in% c("cumlogit", "multilogit")) {
         dest_cols[[varname]]$Xc
       } else if (impmeth %in% c('clmm', 'mlmm')) {
         dest_cols[[varname]][[names(dm[dm])]]
       },
       ncat = if (impmeth %in% c("cumlogit", "multilogit")) {
         length(dest_cols[[varname]]$Xc) + 1
       } else if (impmeth %in% c('clmm', "mlmm")) {
         length(dest_cols[[varname]]$Xl) + 1
       },
       refcat = if (impmeth %in% c("logit", "cumlogit", "multilogit",
                                   'glmm_logit',  'glmm_probit', 'clmm', 'mlmm')) {
         which(Mlist$refs[[varname]] == levels(Mlist$refs[[varname]]))
       },
       trafo_cols = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         dest_cols[[varname]]$Xc
       } else if (!is.na(dest_cols[[varname]]$Xltrafo) & !all(Mlist$trafos$compl[Mlist$trafos$var == varname])) {
         lapply(Mlist$trafos$X_var[which(Mlist$trafos$var == varname & !Mlist$trafos$dupl)], function(k) {
           Filter(Negate(is.null),
                  lapply(dest_cols[[varname]][names(dest_cols[[varname]]) != 'Xltrafo'], function(x) {
                    if (!is.na(x[match(k, names(x))]))
                      x[match(k, names(x))]
                  }))
         })
       },
       trfo_fct = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         sapply(which(Mlist$trafos$var == varname & !Mlist$trafos$dupl),
                get_trafo, Mlist$trafos, dest_cols)
       } else if (!is.na(dest_cols[[varname]]$Xltrafo) & !all(Mlist$trafos$compl[Mlist$trafos$var == varname])) {
                sapply(which(Mlist$trafos$var == varname & !Mlist$trafos$dupl),
                get_trafol, Mlist$trafos, dest_cols)
       },
       trunc = trunc[[varname]],
       trafos = Mlist$trafos,
       ppc = Mlist$ppc,
       nranef = sum(!ifelse(colnames(Mlist$Z) %in% Mlist$trafos$X_var,
                            Mlist$trafos$var[match(colnames(Mlist$Z), Mlist$trafos$X_var)],
                            colnames(Mlist$Z))
                    %in% unlist(mod_dum[i:length(mod_dum)])),
       N = Mlist$N,
       Ntot = nrow(Mlist$Z),
       hc_list = Mlist$hc_list[nam]
  )
}


#
# impmeth: covariate model type
# nbasevars: how many baseline covariates are in this covariate model
# prevlongvars: how many longitudinal covariates are in this covariate model
intercept_needed <- function(impmeth, nbasevars, nlongvars) {
  if (impmeth == "cumlogit") {
    ifelse(nbasevars > 0, FALSE, TRUE)
  } else if (impmeth == "clmm") {
    ifelse(nbasevars + nlongvars > 0, FALSE, TRUE)
  } else {
    TRUE
  }
}



# function that returns the names of the dummies of a variable name if they exist
# (used if a variable name needs to be matched to column names, e.g. in Xc or Xl)
# varname: the name or the original variable
# refs: list of reference categories; obtained from Mlist$refs
dummyfy <- function(varname, refs) {
  if (varname %in% names(refs)) attr(refs[[varname]], 'dummies') else varname
}

# function that counts how many variables (columns, excluding the intercept) from
# Xc should be included in the predictor for a given variable
# varname: dumified name of the covariate
# Xc_names: column names of Xc
get_basevar_cols <- function(varname, Xc_names, intercept = TRUE) {
  posXc <- if (!any(is.na(match(varname, Xc_names))))
    min(match(varname, Xc_names), na.rm = TRUE)

  posinterc <- match('(Intercept)', Xc_names)

  basevars <- if (!is.null(posXc)) {
    if (!intercept & !is.na(posinterc)) {
      (1:(posXc - 1))[-posinterc]
    } else {
      1:(posXc - 1)
    }
  } else {
    if(!intercept & !is.na(posinterc)) {
      (1:length(Xc_names))[-posinterc]
    } else {
      1:length(Xc_names)
    }
  }
  return(basevars)
}

get_nbasevars <- function(varname, Xc_cols, intercept = TRUE) {
  length(get_basevar_cols(varname, Xc_cols, intercept))
}


# function that counts how many variables (columns, excluding the intercept) from
# Xl should be included in the predictor for a given variable
# varname: dumified name of the covariate
# Xl_names: column names of Xl
get_longvar_cols <- function(varname, Xl_names, intercept = TRUE) {

  posXl <- if (!any(is.na(match(varname, Xl_names))))
    min(match(varname, Xl_names), na.rm = TRUE)

  posinterc <- match('(Intercept)', Xl_names)

  longvars <- if (!is.null(posXl)) {
    if (!is.na(posinterc)) {
      (1:(posXl - 1))[-posinterc]
    } else {
      1:(posXl - 1)
    }
  }
  return(longvars)
}

get_nlongvars <- function(varname, Xl_names, intercept = TRUE) {
  length(get_longvar_cols(varname, Xl_names, intercept))
}

# replace_power <- function(a) {
#   # test if a power is involved
#   is_power <- regexpr("\\^[[:digit:]]+", a) > 0
#   while (is_power) {
#     # extract the power
#     pow <- gsub("\\^", '', regmatches(a, regexpr("\\^[[:digit:]]+", a), invert = FALSE)[[1]])
#
#     sep <- regmatches(a, regexpr("\\^[[:digit:]]+", a), invert = TRUE)[[1]]
#
#     front <- gsub("^I\\(", '', sep[1])
#     back <- gsub("\\)$", '', sep[2])
#
#     a <- if (substr(front, start = nchar(front), stop = nchar(front)) == ")") {
#       opening <- gregexpr("\\(", front)[[1]]
#       paste0(substr(front, start = 1, stop = opening[length(opening)] - 1),
#              "pow(",
#              substr(front, start = opening[length(opening)], stop = nchar(front)),
#              ", ", pow, ")", back)
#     } else {
#       vars <- strsplit(front, split = "[[:space:]]*[^_.[:^punct:]][[:space:]]*", perl = TRUE)[[1]]
#       paste0(gsub(vars[length(vars)], paste0('pow(', vars[length(vars)],
#                                              ", ", pow, ")"), front),
#              back)
#     }
#     is_power <- regexpr("\\^[[:digit:]]+", a) > 0
#   }
#   return(a)
# }



get_trafo <- function(i, trafos, dest_cols) {
  if (trafos[i, "type"] == "identity") {
    ret <- paste0("Xtrafo[i, ", dest_cols[[trafos[i, "var"]]]$Xtrafo, "]")
  } else if (trafos[i, "type"] == "I") {
      ret <- gsub(trafos[i, "var"], paste0("Xtrafo[i, ",
                                           dest_cols[[trafos[i, "var"]]]$Xtrafo,
                                           "]"), trafos[i, "fct"])
      ret <- gsub("\\)$", "", gsub("^I\\(", "", ret))
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


get_trafol <- function(i, trafos, dest_cols) {
  if (trafos[i, "type"] == "identity") {
    ret <- paste0("Xltrafo[j, ", dest_cols[[trafos[i, "var"]]]$Xltrafo, "]")
  } else if (trafos[i, "type"] == "I") {
    ret <- gsub(trafos[i, "var"], paste0("Xltrafo[j, ",
                                         dest_cols[[trafos[i, "var"]]]$Xltrafo,
                                         "]"), trafos[i, "fct"])
    ret <- gsub("\\)$", "", gsub("^I\\(", "", ret))
  } else {
    ret <- gsub(trafos[i, "var"], paste0("Xltrafo[j, ",
                                         dest_cols[[trafos[i, "var"]]]$Xltrafo,
                                         "]"), trafos[i, "fct"])
  }
  if (!is.na(trafos[i, 'dupl_rows'])) {
    other_vars <- trafos[unlist(trafos[i, 'dupl_rows']), 'var']
    for (k in seq_along(other_vars)) {
      ret <- gsub(other_vars[k],
                  paste0('Xltrafo[j, ', dest_cols[[other_vars[k]]]$Xltrafo, ']'), ret)
    }
  }
  ret
}



# Find which column in either Xc or Xcat contains the variable to be imputed
get_dest_column <- function(varname, Mlist) {
  nams <- if (varname %in% names(Mlist$refs)) {
    attr(Mlist$refs[[varname]], "dummies")
  } else if (varname %in% Mlist$trafos$var) {
    Mlist$trafos$X_var[Mlist$trafos$var == varname & !Mlist$trafos$dupl]
  } else {
    varname
  }

  list("Xc" = setNames(match(make.names(nams),
                             make.names(colnames(Mlist$Xc))), nams),
       "Xcat" = setNames(match(make.names(varname),
                               make.names(colnames(Mlist$Xcat))), varname),
       "Xtrafo" = setNames(match(make.names(varname),
                                 make.names(colnames(Mlist$Xtrafo))), varname),
       "Xltrafo" = setNames(match(make.names(varname),
                                 make.names(colnames(Mlist$Xltrafo))), varname),
       "Xl" = setNames(match(make.names(nams),
                             make.names(colnames(Mlist$Xl))), nams),
       "Xlcat" = setNames(match(make.names(varname),
                               make.names(colnames(Mlist$Xlcat))), varname),
       "Z" = setNames(match(make.names(nams),
                             make.names(colnames(Mlist$Z))), nams)
  )
}


# Hierarchical centering structure ---------------------------------------------
get_hc_list <- function(X2, Xc, Xic, Z, Z2, Xlong) {
  # find all occurences of the random effects variables in the the fixed effects
  rd_effect <- hc_names <- if (ncol(Z2) > 1) {
    lapply(sapply(colnames(Z2)[-1], gen_pat, simplify = FALSE),
           grep_names, colnames(X2))
  }

  for (i in 1:length(hc_names)) {
    if (length(hc_names[[i]]) > 0) {
      # identify which are interactions
      rd_effect[[i]] <- as.list(gsub(paste(gen_pat(names(hc_names)[i]), collapse = "|"),
                                     '', hc_names[[i]]))
      rd_effect[[i]][rd_effect[[i]] == ''] <- names(rd_effect)[i]

      for (k in seq_along(rd_effect[[i]])) {
        mat <- sapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), function(x){
          rd_effect[[i]][[k]] %in% colnames(x)
        })
        attr(rd_effect[[i]][[k]], 'matrix') <- names(mat[mat])
        attr(rd_effect[[i]][[k]], 'column') <- match(rd_effect[[i]][[k]],
                                                     colnames(get(names(mat)[mat])))
      }
      names(rd_effect[[i]]) <- hc_names[[i]]
    }
  }
  return(rd_effect)
}
