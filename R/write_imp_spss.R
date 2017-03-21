#' Write imputed dataset to a .sav file
#' @param object JointAI object
#' @param m number of imputed datasets
#' @param seed optional seed
#' @param resdir optional directory for results
#' @param filename optional file name (without ending)
#' @param write_to_SPSS logical
#' @export
#'
write_imp_spss <- function(object, m = 10, seed = NULL, resdir = NULL, filename = NULL,
                           write_to_SPSS = T){

  if (is.null(object$meth))
    stop("This JointAI object did not impute any values.")

  if (!is.null(seed))
    set.seed(seed)

  DF <- object$data
  if (object$analysis_type == "lme") {
    DFlong <- DF

    id <- extract_id(object$random)
    groups <- if (!is.null(id)) {
      DFlong[, id]
    }
    tvar <- apply(DFlong, 2, check_tvar, groups)
    DF <- DFlong[match(unique(DFlong[, id]), DFlong[, id]), names(tvar)[!tvar]]
  }

  meth <- object$meth

  MCMC <- do.call(rbind, object$sample)
  if (nrow(MCMC) < m)
    stop(paste0("\nThe number of imputations must be chosen to be less than or equal to ",
                "the number of MCMC samples (= ", nrow(MCMC), ")."))


  # randomly draw which iterations should be used as imputation
  imp.iters <- sort(sample.int(nrow(MCMC), size = m))

  # reduce MCMC to relevant rows
  MCMC <- MCMC[imp.iters, , drop = F]

  DF_list <- list()
  for (i in 1:(m + 1)) {
    DF_list[[i]] <- cbind("Imputation_" = i - 1, DF)
  }

  for (i in seq_along(meth)) {
    impval <- NULL
    # imputation by linear regression --------------------------------------------------------
    if (meth[i] %in% c("norm")) {
      pat <- paste0("Xc\\[[[:digit:]]*,",
                    match(names(meth)[i], colnames(object$data_list$Xc)),
                    "\\]")

      impval <- MCMC[, grep(pat, colnames(MCMC), value = T)]
      impval <- impval * object$scale_pars["scale", names(meth)[i]]  +
        object$scale_pars["center", names(meth)[i]]

      if (length(impval) > 0) {
        for (j in (1:m) + 1) {
          DF_list[[j]][is.na(DF_list[[j]][, names(meth)[i]]), names(meth)[i]] <-
            impval[j - 1, ]
        }
      }
    }
    # imputation by binary regression --------------------------------------------------------
    if (meth[i] %in% c("logit")) {
      pat <- paste0("Xc\\[[[:digit:]]*,",
                    match(attr(object$Mlist$refs[[names(meth)[i]]], "dummies"),
                          colnames(object$data_list$Xc)),
                    "\\]")
      impval <- MCMC[, grep(pat, colnames(MCMC), value = T), drop = F]

      if (length(impval) > 0) {
        for (j in (1:m) + 1) {
          vec <- as.numeric(DF_list[[j]][, names(meth)[i]]) - 1
          vec[is.na(vec)] <- impval[j - 1, ]
          vec <- as.factor(vec)
          levels(vec) <- levels(DF_list[[j]][, names(meth)[i]])
          DF_list[[j]][, names(meth)[i]] <- vec
        }
      }
    }

    # imputation of categorical variables ----------------------------------------------------
    if (meth[i] %in% c("ordinal", "multinomial")) {
      pat <- paste0("Xcat\\[[[:digit:]]*,",
                    match(names(meth)[i], colnames(object$data_list$Xcat)),
                    "\\]")
      impval <- MCMC[, grep(pat, colnames(MCMC), value = T)]

      if (length(impval) > 0) {
        for (j in (1:m) + 1) {
          vec <- as.numeric(DF_list[[j]][, names(meth)[i]])
          vec[is.na(vec)] <- impval[j - 1, ]
          if (meth[i] == "ordinal") {
            vec <- as.ordered(vec)
          }else{
            vec <- as.factor(vec)
          }
          levels(vec) <- levels(DF_list[[j]][, names(meth)[i]])
          DF_list[[j]][, names(meth)[i]] <- vec
        }
      }
    }
  }


# build dataset --------------------------------------------------------------------------
  if (object$analysis_type == "lme") {
    DF_list_long <- lapply(DF_list, function(x) {
      DFlong[, colnames(x)] <- x[groups, ]
      DFlong
    })
    impDF <- do.call(rbind, DF_list_long)
  } else {
    impDF <- do.call(rbind, DF_list)
  }


  if (is.null(resdir))
    resdir <- getwd()

  if (is.null(filename))
    filename <- paste0("JointAI-imputation_", Sys.Date())

  if (write_to_SPSS == T) {
    write_SPSS(impDF,
               file.path(resdir, paste0(filename, ".txt")),
               file.path(resdir, paste0(filename, ".sps"))
    )
  }

  return(impDF)
}
