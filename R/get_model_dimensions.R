# Determine number of fixed effects / regression coefficients in the analysis model
# @param ncols, named list specifying the column numbers of the matrices Xc,
#        Xic, Xl and Xil
# @param hc_list named vector or list specifying hierarchical centering
#        structure (see \code{\link{get_hc_list}})
# @return a matrix specifying the range of regression coefficients per
#         component of the analysis model
# @note Auxiliary variables are treated the same way as variables that are
#       actually in the model.
# @export
get_model_dim <- function(ncols, hc_list){

  K <- matrix(NA, nrow = 4 + length(hc_list), ncol = 2,
              dimnames = list(c("Xc", "Xic", names(hc_list), "Xl", "Xil"),
                              c("start", "end")))

  K["Xc", ] <- cumsum(c(1, ncols$Xc - 1))
  if (!is.null(ncols$Xic)) K["Xic", ] <- c(1, ncols$Xic) + max(K, na.rm = T)
  if (!is.null(hc_list)) {
    for (i in 1:length(hc_list)) {
    K[names(hc_list)[i], ] <-
      if (length(hc_list[[i]]) > 0) {
        c(1, max(1, sum(attr(hc_list[[i]], "matrix") %in% c("Xc", "Z"), na.rm = T))) +
          max(K, na.rm = T)
      } else {
        c(NA, NA)
      }
    }
  }
  if (!is.null(ncols$Xl)) K["Xl", ] <- c(1, ncols$Xl) + max(K, na.rm = T)
  if (!is.null(ncols$Xil)) K["Xil", ] <- c(1, ncols$Xil) + max(K, na.rm = T)
  return(K)
}




# Determine positions of incomplete variables in the data matrices
# @param meth named vector specifying the imputation methods and ordering of
#        the imputation models
# @param Mlist a named list with the entries "Xc", "Xic", "Xl", "Xil", "Z"
# @return a list?
# @export
get_imp_pos <- function(meth, Mlist){
  if (is.null(meth)) return(NULL)

  refs <- Mlist$refs
  trafos <- Mlist$trafos
  Xc <- Mlist$Xc
  Xic <- Mlist$Xic
  Xl <- Mlist$Xl
  Xil <- Mlist$Xil
  Z <- Mlist$Z

  # positions of the variables in the cross-sectional data matrix Xc
  pos_Xc <- sapply(names(meth), function(x) {
    nams <- if (x %in% names(refs)) {
      paste0(x, levels(refs[[x]])[levels(refs[[x]]) != refs[[x]]])
    } else if (x %in% trafos$var) {
      trafos$Xc_var[trafos$var == x]
    } else {
      x
    }
    setNames(match(nams, colnames(Xc)), nams)
  }, simplify = F)
  # pos_Xc <- sapply(names(meth), match_positions, DF, colnames(Xc), simplify = F)

  # positions of the interaction variables in the cross-sectional matrix Xic
  if (!is.null(Xic)) {
    spl.names.Xic <- strsplit(colnames(Xic), split = "[:|*]")
    pos_Xic <- lapply(spl.names.Xic, sapply, match, colnames(Xc))
    names(pos_Xic) <- colnames(Xic)
  } else {
    pos_Xic <- NULL
  }

  # positions of the interaction variables in the longitudinal matrix Xil
  if (!is.null(Xil)) {
    spl.names.Xil <- strsplit(colnames(Xil), split = "[:|*]")

    pos_Xil <- lapply(spl.names.Xil, sapply, function(i) {
      na.omit(sapply(list(colnames(Xc),
                          colnames(Xl),
                          colnames(Z)), match, x = i))
    })
    names(pos_Xil) <- colnames(Xil)
  } else {
    pos_Xil <- NULL
  }

    return(list(pos_Xc = pos_Xc,
                pos_Xic = pos_Xic,
                pos_Xil = pos_Xil,
                cat_pos = NULL))
}


# Determine number of parameters in the imputation models
# @param meth named vector specifying the imputation methods and ordering of
#        the imputation models
# @param pos_Xc a list containing the positions of the incomplete variables in Xc
# @return a matrix specifying the range of regression coefficients per
#         imputation model
# @export
get_imp_dim <- function(meth, pos_Xc){
  if (is.null(meth)) return(NULL)

  # number of regression coefficients in the imputation models
  n_imp_coef <- numeric(length(meth))
  names(n_imp_coef) <- names(meth)

  for (i in 1:length(meth)) {
    n_imp_coef[names(meth)[i]] <-
      min(pos_Xc[[names(meth)[i]]]) - 1 - as.numeric(meth[i] == "cumlogit")
    if (meth[i] == "multilogit") {
      n_imp_coef <- append(x = n_imp_coef,
                           values = rep(n_imp_coef[names(meth)[i]],
                                        length(pos_Xc[[names(meth)[i]]]) - 1),
                           after = which(names(n_imp_coef) == names(meth)[i]))
      names(n_imp_coef)[which(names(n_imp_coef) == names(meth[i]))] <-
        names(pos_Xc[[i]])
    }
  }

  K_imp <- matrix(ncol = 2, nrow = length(n_imp_coef), data = NA,
                  dimnames = list(names(n_imp_coef), c("start", "end")))
  K_imp[,2] <- cumsum(n_imp_coef)
  K_imp[,1] <- c(0, cumsum(n_imp_coef))[1:(length(n_imp_coef))] + 1

  return(K_imp = K_imp)
}

