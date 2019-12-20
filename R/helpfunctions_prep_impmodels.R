
# # Creates a list of parameters that will be passed to the functions generating the imputation models
# get_imp_par_list <- function(impmeth, varname, Mlist, K_imp, K, dest_cols, trunc, models) {
#
#   intercept <- if (impmeth == "cumlogit") {
#     ifelse(min(dest_cols[[varname]]$Xc) > 2, FALSE, TRUE)
#   } else if (impmeth == "clmm") {
#     ifelse(ncol(Mlist$Xc) > 1 | min(dest_cols[[varname]]$Xl) > 2, FALSE, TRUE)
#   } else {
#     TRUE
#   }
#
#   i <- which(names(models) == varname)
#   mod_dum <- sapply(names(models), function(k) {
#     if (k %in% names(Mlist$refs)) {
#       attr(Mlist$refs[[k]], 'dummies')
#     } else {
#       k
#     }
#   }, simplify = FALSE)
#
#   hcvar <- ifelse(names(Mlist$hc_list) %in% Mlist$trafos$X_var,
#            Mlist$trafos$var[match(names(Mlist$hc_list), Mlist$trafos$X_var)],
#            names(Mlist$hc_list))
#
#
#
#   if (varname %in% rownames(K_imp)) {
#
#     nam <- names(Mlist$hc_list)[which(!hcvar %in% unlist(mod_dum[i:length(mod_dum)]))]
#
#     # columns in Xc to be used
#     Xc_cols = if (impmeth %in% c('lmm', 'glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')) {
#       if(1 + (!intercept) <= ncol(Mlist$Xc))
#         (1 + (!intercept)):ncol(Mlist$Xc)
#     } else {
#       (1 + (!intercept)):(min(dest_cols[[varname]]$Xc) - 1)
#     }
#
#     # columns in Xl to be used
#     Xl_cols <- if (impmeth %in% c('lmm', 'glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')) {
#       if (all(is.na(dest_cols[[varname]]$Xl[mod_dum[[varname]]]))) {
#         wouldbe <- max(0, which(colnames(Mlist$Xl) %in% unlist(mod_dum[seq_along(models) < i]))) + 1
#         if (wouldbe > 1) 1:(wouldbe - 1)
#       } else  if (min(dest_cols[[varname]]$Xl, na.rm = TRUE) > 1) {
#         1:(min(dest_cols[[varname]]$Xl, na.rm = TRUE) - 1)
#       }
#     }
#
#     # columns of Z to be used
#     Z_cols = if (impmeth %in% c('lmm','glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')) {
#       if (Mlist$nranef > 1) {
#         which(!ifelse(colnames(Mlist$Z) %in% Mlist$trafos$X_var,
#                       Mlist$trafos$var[match(colnames(Mlist$Z), Mlist$trafos$X_var)],
#                       colnames(Mlist$Z)) %in% unlist(mod_dum[i:length(mod_dum)]))
#       } else if (Mlist$nranef == 1) {
#         1
#       }
#     }
#     parname = 'alpha'
#   } else {
#     nam <- names(Mlist$hc_list)[names(Mlist$hc_list) %in% Mlist$names_main[[varname]]$Z]
#     parname <- "beta"
#     Xc_cols <- Mlist$cols_main[[varname]]$Xc
#     Xl_cols <- Mlist$cols_main[[varname]]$Xl
#     Z_cols <- Mlist$cols_main[[varname]]$Z
#   }
#
#   par_elmts <- if (varname %in% rownames(K_imp)) {
#     if (impmeth == "multilogit") {
#       sapply(names(dest_cols[[varname]]$Xc), function(i) {
#         matrix(nrow = 1, ncol = 2, data = c(K_imp[i, 1], K_imp[i, 2]),
#                byrow = T, dimnames = list('Xc', c('start', 'end')))
#       }, simplify = FALSE)
#     } else {
#       K_imp_x <- matrix(nrow = 2 + length(nam), ncol = 2,
#                         dimnames = list(c('Xc', 'Xl', nam),
#                                         c('start', 'end')))
#
#       if (length(Xc_cols) > 0)
#         K_imp_x['Xc', ] <- K_imp[varname, 1] + c(1, length(Xc_cols)) - 1
#
#       if (length(Xl_cols) > 0)
#         K_imp_x['Xl', ] <- max(0, K_imp_x['Xc', 2], na.rm = TRUE) + c(1, length(Xl_cols))
#
#       if (length(Z_cols) > 0)
#         # K_imp_x['Z', ] <- max(K_imp_x, na.rm = T) + c(1, length(Z_cols) - 1)
#         for (k in nam) {
#           if (!is.null(Mlist$hc_list[[k]]))
#             # K_imp_x[k, ] <- max(K_imp_x, na.rm = T) + c(1, sum(sapply(Mlist$hc_list[[k]],  "!=", varname)))
#             K_imp_x[k, ] <- max(K_imp_x, na.rm = T) +
#               c(1, sum(!sapply(Mlist$hc_list[[k]],
#                                "%in%", unlist(mod_dum[i:length(mod_dum)]))
#               ))
#         }
#       K_imp_x
#     }
#   } else {
#     K[[varname]]
#   }
#
#   list(varname = varname,
#        impmeth = impmeth,
#        intercept = intercept,
#        dest_mat = if (impmeth %in% c("multilogit", "cumlogit")) {
#          "Xcat"
#        } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
#          "Xtrafo"
#        } else if (!is.na(dest_cols[[varname]]$Xltrafo)) {
#          "Xltrafo"
#        } else if (impmeth %in% c('lmm','glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson')) {
#          varname_dum <- attr(Mlist$refs[[varname]], 'dummies')
#          names(dest_cols[[varname]][which(sapply(dest_cols[[varname]],
#                                                   function(k) any(!is.na(k[c(varname, varname_dum)]))
#          ))])
#        } else if (impmeth %in% c('clmm')) {
#          "Xlcat"
#        } else{"Xc"},
#        dest_col = if (impmeth %in% c("multilogit", "cumlogit")) {
#          dest_cols[[varname]]$Xcat
#        } else if (impmeth %in% c('clmm', "mlmm")) {
#          dest_cols[[varname]]$Xlcat
#        } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
#          dest_cols[[varname]]$Xtrafo
#        } else if (!is.na(dest_cols[[varname]]$Xltrafo)) {
#          dest_cols[[varname]]$Xltrafo
#        } else if (impmeth %in% c("lmm",'glmm_lognorm', "glmm_logit", "glmm_gamma", "glmm_poisson")) {
#          varname_dum <- attr(Mlist$refs[[varname]], 'dummies')
#          dc <- dest_cols[[varname]][[which(sapply(dest_cols[[varname]],
#                                             function(k) any(!is.na(k[c(varname, varname_dum)]))
#                                             ))]]
#          dc[names(dc) %in% c(varname, varname_dum)]
#        } else {
#          dest_cols[[varname]]$Xc
#        },
#        par_elmts = par_elmts,
#        Xc_cols = Xc_cols,
#        Xl_cols = Xl_cols,
#        Z_cols = Z_cols,
#        dummy_mat = if (impmeth %in% c('clmm', 'mlmm')) {
#          dm <- sapply(dest_cols[[varname]],
#                       function(k) all(!is.na(k[attr(Mlist$refs[[varname]], 'dummies')])))
#
#          names(dm[dm])
#        },
#        dummy_cols = if (impmeth %in% c("cumlogit", "multilogit")) {
#          dest_cols[[varname]]$Xc
#        } else if (impmeth %in% c('clmm', 'mlmm')) {
#          dest_cols[[varname]][[names(dm[dm])]]
#        },
#        ncat = if (impmeth %in% c("cumlogit", "multilogit")) {
#          length(dest_cols[[varname]]$Xc) + 1
#        } else if (impmeth %in% c('clmm', "mlmm")) {
#          length(dest_cols[[varname]]$Xl) + 1
#        },
#        refcat = if (impmeth %in% c("logit", "cumlogit", "multilogit",
#                                    'glmm_logit',  'glmm_probit', 'clmm', 'mlmm')) {
#          which(Mlist$refs[[varname]] == levels(Mlist$refs[[varname]]))
#        },
#        trafo_cols = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
#          dest_cols[[varname]]$Xc
#        } else if (!is.na(dest_cols[[varname]]$Xltrafo) & !all(Mlist$trafos$compl[Mlist$trafos$var == varname])) {
#          lapply(Mlist$trafos$X_var[which(Mlist$trafos$var == varname & !Mlist$trafos$dupl)], function(k) {
#            Filter(Negate(is.null),
#                   lapply(dest_cols[[varname]][names(dest_cols[[varname]]) != 'Xltrafo'], function(x) {
#                     if (!is.na(x[match(k, names(x))]))
#                       x[match(k, names(x))]
#                   }))
#          })
#        },
#        trfo_fct = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
#          sapply(which(Mlist$trafos$var == varname & !Mlist$trafos$dupl),
#                 get_trafo, Mlist$trafos, dest_cols)
#        } else if (!is.na(dest_cols[[varname]]$Xltrafo) & !all(Mlist$trafos$compl[Mlist$trafos$var == varname])) {
#                 sapply(which(Mlist$trafos$var == varname & !Mlist$trafos$dupl),
#                 get_trafol, Mlist$trafos, dest_cols)
#        },
#        trunc = trunc[[varname]],
#        trafos = Mlist$trafos,
#        ppc = Mlist$ppc,
#        parname = parname,
#        nranef = length(Z_cols),
#        # nranef = sum(!ifelse(colnames(Mlist$Z) %in% Mlist$trafos$X_var,
#        #                      Mlist$trafos$var[match(colnames(Mlist$Z), Mlist$trafos$X_var)],
#        #                      colnames(Mlist$Z))
#        #              %in% unlist(mod_dum[i:length(mod_dum)])),
#        N = Mlist$N,
#        Ntot = nrow(Mlist$Z),
#        hc_list = Mlist$hc_list[nam]
#   )
# }
#


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


#
# get_trafo <- function(i, trafos, dest_cols) {
#   if (trafos[i, "type"] == "identity") {
#     ret <- paste0("Xtrafo[i, ", dest_cols[[trafos[i, "var"]]]$Xtrafo, "]")
#   } else if (trafos[i, "type"] == "I") {
#       ret <- gsub(trafos[i, "var"], paste0("Xtrafo[i, ",
#                                            dest_cols[[trafos[i, "var"]]]$Xtrafo,
#                                            "]"), trafos[i, "fct"])
#       ret <- gsub("\\)$", "", gsub("^I\\(", "", ret))
#   } else {
#     ret <- gsub(trafos[i, "var"], paste0("Xtrafo[i, ",
#                                          dest_cols[[trafos[i, "var"]]]$Xtrafo,
#                                          "]"), trafos[i, "fct"])
#   }
#   if (!is.na(trafos[i, 'dupl_rows'])) {
#     other_vars <- trafos[unlist(trafos[i, 'dupl_rows']), 'var']
#     for (k in seq_along(other_vars)) {
#       ret <- gsub(other_vars[k],
#                   paste0('Xtrafo[i, ', dest_cols[[other_vars[k]]]$Xtrafo, ']'), ret)
#     }
#   }
#   ret
# }


paste_trafos <- function(Mlist, varname, index) {

  if (!any(Mlist$trafos$var %in% varname))
    return(NULL)

  sapply(which(Mlist$trafos$var == varname), function(i) {
    x <- Mlist$trafos[i, ]

    if (!x$dupl) {
      dest_mat <- if (x$colname %in% colnames(Mlist$Mc)) 'Mc' else 'Ml'
      dest_col <- match(x$colname, colnames(Mlist[[dest_mat]]))

      if (!is.na(x$dupl_rows)) {
        xx <- Mlist$trafos[c(i, unlist(x$dupl_rows)), ]
      } else {
        xx <- x
      }
      vars <- xx$var
      vars_mat <- ifelse(xx$var%in% colnames(Mlist$Mc), 'Mc', 'Ml')
      vars_cols <- sapply(seq_along(vars), function(k)
        match(xx$var[k], colnames(Mlist[[vars_mat[k]]]))
      )

      fct <- x$fct
      for (k in seq_along(vars)) {
        fct <- gsub(paste0('\\b', vars[k], '\\b'),
                    paste0(vars_mat[k], "[", index, ", ", vars_cols[k], "]"), fct)
      }

      paste0('\n\n', tab(4),
             dest_mat, "[", index, ", ", dest_col, "] <- ", fct, '\n')
    }
  })
}



# get_trafol <- function(i, trafos, dest_cols) {
#   if (trafos[i, "type"] == "identity") {
#     ret <- paste0("Xltrafo[j, ", dest_cols[[trafos[i, "var"]]]$Xltrafo, "]")
#   } else if (trafos[i, "type"] == "I") {
#     ret <- gsub(trafos[i, "var"], paste0("Xltrafo[j, ",
#                                          dest_cols[[trafos[i, "var"]]]$Xltrafo,
#                                          "]"), trafos[i, "fct"])
#     ret <- gsub("\\)$", "", gsub("^I\\(", "", ret))
#   } else {
#     ret <- gsub(trafos[i, "var"], paste0("Xltrafo[j, ",
#                                          dest_cols[[trafos[i, "var"]]]$Xltrafo,
#                                          "]"), trafos[i, "fct"])
#   }
#   if (!is.na(trafos[i, 'dupl_rows'])) {
#     other_vars <- trafos[unlist(trafos[i, 'dupl_rows']), 'var']
#     for (k in seq_along(other_vars)) {
#       ret <- gsub(other_vars[k],
#                   paste0('Xltrafo[j, ', dest_cols[[other_vars[k]]]$Xltrafo, ']'), ret)
#     }
#   }
#   ret
# }

#
#
# # Find which column in either Xc or Xcat contains the variable to be imputed
# get_dest_column <- function(varname, Mlist) {
#   nams <- if (varname %in% names(Mlist$refs)) {
#     attr(Mlist$refs[[varname]], "dummies")
#   } else if (varname %in% Mlist$trafos$var) {
#     Mlist$trafos$X_var[Mlist$trafos$var == varname & !Mlist$trafos$dupl]
#   } else {
#     varname
#   }
#
#   list("Xc" = setNames(match(make.names(nams),
#                              make.names(colnames(Mlist$Xc))), nams),
#        "Xcat" = setNames(match(make.names(varname),
#                                make.names(colnames(Mlist$Xcat))), varname),
#        "Xtrafo" = setNames(match(make.names(varname),
#                                  make.names(colnames(Mlist$Xtrafo))), varname),
#        "Xltrafo" = setNames(match(make.names(varname),
#                                  make.names(colnames(Mlist$Xltrafo))), varname),
#        "Xl" = setNames(match(make.names(nams),
#                              make.names(colnames(Mlist$Xl))), nams),
#        "Xlcat" = setNames(match(make.names(varname),
#                                make.names(colnames(Mlist$Xlcat))), varname),
#        "Z" = setNames(match(make.names(nams),
#                              make.names(colnames(Mlist$Z))), nams)
#   )
# }
#
#
# # Hierarchical centering structure ---------------------------------------------
# get_hc_list <- function(X2, Xc, Xic, Z, Z2, Xlong) {
#   # find all occurences of the random effects variables in the the fixed effects
#   rd_effect <- hc_names <- if (ncol(Z2) > 1) {
#     lapply(sapply(colnames(Z2)[-1], gen_pat, simplify = FALSE),
#            grep_names, colnames(X2))
#   }
#
#   for (i in 1:length(hc_names)) {
#     if (length(hc_names[[i]]) > 0) {
#       # identify which are interactions
#       rd_effect[[i]] <- as.list(gsub(paste(gen_pat(names(hc_names)[i]), collapse = "|"),
#                                      '', hc_names[[i]]))
#       rd_effect[[i]][rd_effect[[i]] == ''] <- names(rd_effect)[i]
#
#       for (k in seq_along(rd_effect[[i]])) {
#         mat <- sapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), function(x){
#           rd_effect[[i]][[k]] %in% colnames(x)
#         })
#         attr(rd_effect[[i]][[k]], 'matrix') <- names(mat[mat])
#         attr(rd_effect[[i]][[k]], 'column') <- match(rd_effect[[i]][[k]],
#                                                      colnames(get(names(mat)[mat])))
#       }
#       names(rd_effect[[i]]) <- hc_names[[i]]
#     }
#   }
#   return(rd_effect)
# }
#


HC <- function(fixed, random, data, interactions, Mcnam, Mlnam) {

  # for each random effects formula:
  hc <- sapply(seq_along(random), function(k) {
    # make the design matrices
    print('before Z')
    Z <- model.matrix(remove_grouping(random[[k]]), data)
    X <- model.matrix(fixed[[k]], data)
print('after X')
    # identify interactions from fixed
    inters <- interactions[names(interactions) %in% colnames(X)]

    # identify if there are elements of interaction in Z
    inZ <- if (length(inters) > 0)
      sapply(colnames(Z), function(x)
        lapply(lapply(inters, attr, 'elements'), `%in%`, x), simplify = FALSE)

    sapply(colnames(Z), function(x) {
      list(
        main = #if (x %in% colnames(X)) {
          # if the ranom effect is in the fixed effects, find the column of the design matrix
          c(
            if (!is.na(match(x, Mcnam)))
              setNames(match(x, Mcnam), 'Mc'),
            if (!is.na(match(x, Mlnam)))
              setNames(match(x, Mlnam), 'Ml')
          ),
          # if the random effect is not in the fixed effects, return 0
          # } else 0,

        interact = if (any(unlist(inZ[[x]]))) {
          w <- sapply(inZ[[x]], any)
          inters[w]
        }
      )
    }, simplify = FALSE)
  }, simplify = FALSE)
  names(hc) <- names(random)
  return(hc)
}



get_model_info <- function(Mlist, K, K_imp, trunc) {
  sapply(names(Mlist$lp_cols), function(k) {
    # Matrix and column of the response variable
      resp_mat = if (k %in% colnames(Mlist$Mc)) {
        'Mc'
      } else if (k %in% colnames(Mlist$Ml)) {
        "Ml"
      } else {
        stop(gettextf("I can't find the variable %s in neither of the matrices Mc and Ml.",
                      dQuote(k)))
      }
    resp_col = match(k, colnames(Mlist[[resp_mat]]))

    # linear predictor columns
    lp <- Mlist$lp_cols[[k]]

    # linear predictor index values
    parelmts <- if (k %in% names(Mlist$fixed)) {
      sapply(rownames(K[[k]]), function(i) {
        if (!any(is.na(K[[k]][i, ]))) {
          if (Mlist$models[k] %in% c('mlogit', 'mlogitmm')) {
            split(K[[k]][i, 1]:K[[k]][i, 2],
                  rep(1:length(levels(Mlist$refs[[k]])[-1]),
                      each = length(lp[[i]])))
          } else {
            K[[k]][i, 1]:K[[k]][i, 2]
          }
        }
      }, simplify = FALSE)
    } else {
      sapply(rownames(K_imp[[k]]), function(i) {
        if (!any(is.na(K_imp[[k]][i, ]))) {
          if (Mlist$models[k] %in% c('mlogit', 'mlogitmm')) {
            split(K_imp[[k]][i, 1]:K_imp[[k]][i, 2],
                  rep(1:length(levels(Mlist$refs[[k]])[-1]),
                      each = length(lp[[i]])))
          } else {
            K_imp[[k]][i, 1]:K_imp[[k]][i, 2]
          }
        }
      }, simplify = FALSE)
    }


    scale_pars <- list(Mc = Mlist$scale_pars$Mc[lp$Mc, ],
                       Ml = Mlist$scale_pars$Ml[lp$Ml, ])


    dummy_cols <- if (k %in% names(Mlist$refs) & any(is.na(Mlist[[resp_mat]][, resp_col]))) {
      match(attr(Mlist$refs[[k]], 'dummies'), colnames(Mlist[[resp_mat]]))
    }

    categories <- if (k %in% names(Mlist$refs) & any(is.na(Mlist[[resp_mat]][, resp_col]))) {
      levels(Mlist$refs[[k]])[which(levels(Mlist$refs[[k]]) != Mlist$refs[[k]])]
    }


    trafos <- paste_trafos(Mlist, varname = k,
                           index = ifelse(resp_mat == 'Ml', 'j', 'i'))

    modeltype <- switch(Mlist$models[k],
                        lm = 'glm',
                        glm_gaussian_identity = 'glm',
                        glm_gaussian_log = 'glm',
                        glm_gaussian_inverse = 'glm',
                        glm_binomial_logit = 'glm',
                        glm_binomial_probit = 'glm',
                        glm_binomial_log = 'glm',
                        glm_binomial_cloglog = 'glm',
                        glm_logit = 'glm',
                        glm_probit = 'glm',
                        glm_gamma_inverse = 'glm',
                        glm_gamma_identity = 'glm',
                        glm_gamma_log = 'glm',
                        glm_poisson_log = 'glm',
                        glm_poisson_identity = 'glm',
                        lognorm = 'glm',
                        beta = 'glm',
                        lmm = 'glmm',
                        glmm_gaussian_identity = 'glmm',
                        glmm_gaussian_log = 'glmm',
                        glmm_gaussian_inverse = 'glmm',
                        glmm_binomial_logit = 'glmm',
                        glmm_binomial_probit = 'glmm',
                        glmm_binomial_log = 'glmm',
                        glmm_binomial_cloglog = 'glmm',
                        glmm_logit = 'glmm',
                        glmm_probit = 'glmm',
                        glmm_gamma_inverse = 'glmm',
                        glmm_gamma_identity = 'glmm',
                        glmm_gamma_log = 'glmm',
                        glmm_poisson_log = 'glmm',
                        glmm_poisson_identity = 'glmm',
                        glmm_lognorm = 'glmm',
                        clm = 'clm',
                        clmm = 'clmm',
                        mlogit = 'mlogit',
                        mlogitmm = 'mlogitmm',
                        coxph = 'coxph',
                        survreg = 'survreg',
                        JM = 'JM')

    family <- switch(Mlist$models[k],
                     lm = 'gaussian',
                     glm_gaussian_identity = 'gaussian',
                     glm_gaussian_log = 'gaussian',
                     glm_gaussian_inverse = 'gaussian',
                     glm_binomial_logit = 'binomial',
                     glm_binomial_probit = 'binomial',
                     glm_binomial_log = 'binomial',
                     glm_binomial_cloglog = 'binomial',
                     glm_logit = 'binomial',
                     glm_probit = 'binomial',
                     glm_gamma_inverse = 'Gamma',
                     glm_gamma_identity = 'Gamma',
                     glm_gamma_log = 'Gamma',
                     glm_poisson_log = 'poisson',
                     glm_poisson_identity = 'poisson',
                     lognorm = 'lognorm',
                     beta = 'beta',
                     lmm = 'gaussian',
                     glmm_gaussian_identity = 'gaussian',
                     glmm_gaussian_log = 'gaussian',
                     glmm_gaussian_inverse = 'gaussian',
                     glmm_binomial_logit = 'binomial',
                     glmm_binomial_probit = 'binomial',
                     glmm_binomial_log = 'binomial',
                     glmm_binomial_cloglog = 'binomial',
                     glmm_logit = 'binomial',
                     glmm_probit = 'binomial',
                     glmm_gamma_inverse = 'Gamma',
                     glmm_gamma_identity = 'Gamma',
                     glmm_gamma_log = 'Gamma',
                     glmm_poisson_log = 'poisson',
                     glmm_poisson_identity = 'poisson',
                     glmm_lognorm = 'lognorm',
                     clm = NULL,
                     clmm = NULL,
                     mlogit = NULL,
                     mlogitmm = NULL,
                     coxph = NULL,
                     survreg = NULL,
                     JM = NULL)

    link <- switch(Mlist$models[k],
                   lm = 'identity',
                   glm_gaussian_identity = 'identity',
                   glm_gaussian_log = 'log',
                   glm_gaussian_inverse = 'inverse',
                   glm_binomial_logit = 'logit',
                   glm_binomial_probit = 'probit',
                   glm_binomial_log = 'log',
                   glm_binomial_cloglog = 'cloglog',
                   glm_logit = 'logit',
                   glm_probit = 'probit',
                   glm_gamma_inverse = 'inverse',
                   glm_gamma_identity = 'identity',
                   glm_gamma_log = 'log',
                   glm_poisson_log = 'log',
                   glm_poisson_identity = 'identity',
                   lognorm = 'identity',
                   beta = 'identity',
                   lmm = 'identity',
                   glmm_gaussian_identity = 'identity',
                   glmm_gaussian_log = 'log',
                   glmm_gaussian_inverse = 'inverse',
                   glmm_binomial_logit = 'logit',
                   glmm_binomial_probit = 'probit',
                   glmm_binomial_log = 'log',
                   glmm_binomial_cloglog = 'log',
                   glmm_logit = 'logit',
                   glmm_probit = 'probit',
                   glmm_gamma_inverse = 'inverse',
                   glmm_gamma_identity = 'identity',
                   glmm_gamma_log = 'log',
                   glmm_poisson_log = 'log',
                   glmm_poisson_identity = 'identity',
                   glmm_lognorm = 'identity',
                   clm = NULL,
                   clmm = NULL,
                   mlogit = NULL,
                   mlogitmm = NULL,
                   coxph = NULL,
                   survreg = NULL,
                   JM = NULL)

    list(
      varname = if (modeltype %in% c('survreg', 'coxph')) {
        paste0(c('surv', Mlist$outcomes$outnams[[k]]), collapse = "_")
      } else {k},
      modeltype = modeltype,
      family = family,
      link = link,
      resp_mat = resp_mat,
      resp_col = resp_col,
      dummy_cols = dummy_cols,
      categories = categories,
      ncat = length(levels(Mlist$refs[[k]])),
      lp = lp,
      parelmts = parelmts,
      scale_pars = scale_pars,
      index = if (resp_mat == 'Ml') c('j', 'i') else 'i',
      parname = ifelse(k %in% names(Mlist$fixed), 'beta', 'alpha'),
      hc_list = Mlist$hc_list[[k]],
      trafos = trafos,
      trunc = trunc[[k]],
      ppc = FALSE,
      shrinkage = NULL,
      N = Mlist$N,
      Ntot = Mlist$Ntot
    )
  }, simplify = FALSE)
}
