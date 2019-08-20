
get_model_dim <- function(cols_main, hc_list){

  K <- matrix(NA,
              nrow = 4 + length(hc_list),
              ncol = 2,
              dimnames = list(c("Xc", "Xic", names(hc_list), "Xl", "Xil"),
                              c("start", "end")))

  if (length(cols_main$Xc) > 0) K["Xc", ] <- c(1, length(cols_main$Xc))
  if (length(cols_main$Xic) > 0) K["Xic", ] <- c(1, length(cols_main$Xic)) + max(c(K, 0), na.rm = TRUE)
  if (!is.null(hc_list)) {
    for (i in 1:length(hc_list)) {
      K[names(hc_list)[i], ] <-
        if (length(hc_list[[i]]) > 0) {
          nef <- sapply(hc_list[[i]], function(x) {
            mat <- attr(x, 'matrix')
            col <- attr(x, 'column')
            sum(col %in% cols_main[[mat]])
          })

          if (sum(nef) > 0) {
            c(1, sum(nef)) + max(c(K, 0), na.rm = TRUE)
          } else {
            c(NA, NA)
          }
        } else {
          c(NA, NA)
        }
    }
  }
  if (length(cols_main$Xl) > 0) K["Xl", ] <- c(1, length(cols_main$Xl)) + max(c(K, 0), na.rm = TRUE)
  if (length(cols_main$Xil) > 0) K["Xil", ] <- c(1, length(cols_main$Xil)) + max(c(K, 0), na.rm = TRUE)
  return(K)
}




# Determine positions of incomplete variables in the data matrices
get_imp_pos <- function(models, Mlist){

  if (is.null(models)) return(NULL)

  # positions of the variables in the cross-sectional data matrix Xc
  pos_Xc <- sapply(names(models), function(x) {
    nams <- if (x %in% names(Mlist$refs)) {
      paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) != Mlist$refs[[x]]])
    } else if (x %in% Mlist$trafos$var) {
      Mlist$trafos$X_var[Mlist$trafos$var == x]
    } else {
      x
    }
    setNames(match(make.names(nams), make.names(colnames(Mlist$Xc))), nams)
  }, simplify = FALSE)



  # positions of the longitudinal variables in the matrix Xl
  pos_Xl <- sapply(names(models), function(x) {
    nams <- if (x %in% names(Mlist$refs)) {
      paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) != Mlist$refs[[x]]])
    } else if (x %in% Mlist$trafos$var) {
      Mlist$trafos$X_var[Mlist$trafos$var == x]
    } else {
      x
    }
    setNames(match(make.names(nams), make.names(colnames(Mlist$Xl))), nams)
  }, simplify = FALSE)


  # positions of the interaction variables in the cross-sectional matrix Xic
  if (!is.null(Mlist$Xic)) {
    spl.names.Xic <- strsplit(colnames(Mlist$Xic), split = "[:|*]")
    pos_Xic <- lapply(spl.names.Xic, sapply, match, colnames(Mlist$Xc))
    names(pos_Xic) <- colnames(Mlist$Xic)
  } else {
    pos_Xic <- NULL
  }

  # positions of the interaction variables in the longitudinal matrix Xil
  if (!is.null(Mlist$Xil)) {
    spl.names.Xil <- strsplit(colnames(Mlist$Xil), split = "[:|*]")

    pos_Xil <- lapply(spl.names.Xil, sapply, function(i) {
      na.omit(sapply(list(colnames(Mlist$Xc),
                          colnames(Mlist$Xl),
                          colnames(Mlist$Z)), match, x = i))
    })
    names(pos_Xil) <- colnames(Mlist$Xil)
  } else {
    pos_Xil <- NULL
  }

  if (!is.null(Mlist$Z)) {
    pos_Z <- sapply(names(models), function(x) {
      nams <- if (x %in% names(Mlist$refs)) {
        paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) != Mlist$refs[[x]]])
      } else if (x %in% Mlist$trafos$var) {
        Mlist$trafos$X_var[Mlist$trafos$var == x]
      } else {
        x
      }
      setNames(match(make.names(nams), make.names(colnames(Mlist$Z))), nams)
    }, simplify = FALSE)
  } else {
    pos_Z <- NULL
  }

    return(list(pos_Xc = pos_Xc,
                pos_Xl = pos_Xl,
                pos_Xic = pos_Xic,
                pos_Xil = pos_Xil,
                pos_Z = pos_Z))
}


# Determine number of parameters in the imputation models
get_imp_dim <- function(models, imp_pos, Mlist){
  if (is.null(models)) return(NULL)

  # number of regression coefficients in the imputation models
  n_imp_coef <- numeric(length(models))
  names(n_imp_coef) <- names(models)

  mod_dum <- sapply(names(models), function(k) {
    if (k %in% names(Mlist$refs)) {
      attr(Mlist$refs[[k]], 'dummies')
    } else {
      k
    }
  }, simplify = FALSE)


  for (i in 1:length(models)) {
    if (models[i] %in% c('norm', 'lognorm', 'logit', 'gamma', 'beta', 'multilogit')) {
      n_imp_coef[names(models)[i]] <- max(1, min(imp_pos$pos_Xc[[names(models)[i]]]) - 1)
    }

    if (models[i] == 'cumlogit') {
      n_imp_coef[names(models)[i]] <- max(1, min(imp_pos$pos_Xc[[names(models)[i]]]) - 2)
    }

    if (models[i] == "multilogit") {
      n_imp_coef <- append(x = n_imp_coef,
                           values = rep(n_imp_coef[names(models)[i]],
                                        length(imp_pos$pos_Xc[[names(models)[i]]]) - 1),
                           after = which(names(n_imp_coef) == names(models)[i]))
      names(n_imp_coef)[which(names(n_imp_coef) == names(models[i]))] <-
        names(imp_pos$pos_Xc[[i]])
    }

    if (models[i] %in% c('lmm', 'glmm_lognorm', 'glmm_logit', 'glmm_gamma', 'glmm_poisson', 'clmm')) {

      # number of random effects
      nrf <- sum(unlist(
        lapply(Mlist$hc_list[!names(Mlist$hc_list) %in% unlist(mod_dum[i:length(mod_dum)])],
               function(x) sapply(x, attr, 'matrix'))) %in% c('Z', 'Xc'))

      Xlpos <- if (any(is.na(imp_pos$pos_Xl[[names(models)[i]]]))) {
        max(c(match(unlist(mod_dum[1:i]), colnames(Mlist$Xl)) + 1, 1), na.rm = T)
      } else {
        min(imp_pos$pos_Xl[[names(models)[i]]], na.rm = TRUE)
      }

      intercept <- ifelse(!models[i] %in% "clmm", 0,
                          ifelse(ncol(Mlist$Xc) == 1 & Xlpos == 1, 0, 1))

      n_imp_coef[names(models)[i]] <- max(1, ncol(Mlist$Xc) - intercept +
                                            Xlpos - 1 +
                                            nrf)
    }
  }

  K_imp <- matrix(ncol = 2, nrow = length(n_imp_coef), data = NA,
                  dimnames = list(names(n_imp_coef), c("start", "end")))
  K_imp[,2] <- cumsum(n_imp_coef)
  K_imp[,1] <- c(0, cumsum(n_imp_coef))[1:(length(n_imp_coef))] + 1

  return(K_imp = K_imp)
}

