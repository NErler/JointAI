#' Extract multiple imputed datasets
#'
#' Creates a dataset containing multiple imputed datasets stacked onto each other
#' (i.e., long format).
#' These data can be automatically exported to SPSS (i.e., a .txt file containing the data and a
#' .sps file containing syntax to generate a .sav file). For the export function
#' the \href{https://CRAN.R-project.org/package=foreign}{\strong{foreign}} package needs to be installed.
#' @inheritParams sharedParams
#' @param m number of imputed datasets
#' @param include should the original, incomplete data be included?
#' @param seed optional seed
#' @param export_to_SPSS logical; should the completed data be exported to SPSS?
#' @param resdir optional directory for results (if unspecified and
#'               \code{export_to_SPSS = TRUE} the current working directory is used)
#' @param filename optional file name (without ending; if unspecified and
#'                 \code{export_to_SPSS = TRUE} a name is generated automatically)
#'
#' @return A dataframe containing the imputed values (and original data) stacked.
#'        The variable \code{Imputation_} identifies the imputations.
#'        In cross-sectional datasets the
#'        variable \code{.imp} is added as subject identifier.
#' @examples
#' # fit a model and monitor the imputed values with monitor_params = c(imps = TRUE)#'
#' mod <- lm_imp(y~C1 + C2 + M2, data = wideDF, monitor_params = c(imps = TRUE), n.iter = 100)
#'
#' # Example 1: without export to SPSS
#' MIs <- get_MIdat(mod, m = 3, seed = 123)
#'
#' \dontrun{
#' # Example 2: with export for SPSS (here: to the temporary directory "temp_dir")
#' temp_dir <- tempdir()
#' MIs <- get_MIdat(mod, m = 3, seed = 123, resdir = temp_dir,
#'                  filename = "example_imputation",
#'                  export_to_SPSS = TRUE)
#'
#' }
#' @export
#'
get_MIdat <- function(object, m = 10, include = TRUE,
                      start = NULL, seed = NULL,
                      export_to_SPSS = FALSE,
                      resdir = NULL, filename = NULL){

  if (is.null(object$meth))
    stop("This JointAI object did not impute any values.")

  if (!"foreign" %in% rownames(installed.packages()))
    stop("This function requires the 'foreign' package to be installed.")

  if (!is.null(seed))
    set.seed(seed)

  DF <- object$data
  if (object$analysis_type %in% c("lme", "glme")) {
    DFlong <- DF

    id <- extract_id(object$random)
    groups <- if (!is.null(id)) {
      DFlong[, id]
    }
    tvar <- apply(DFlong, 2, check_tvar, groups)
    DF <- DFlong[match(unique(DFlong[, id]), DFlong[, id]), names(tvar)[!tvar]]
  } else {
    DF$.id <- 1:nrow(DF)
  }

  meth <- object$meth

  if (is.null(start)) {
    start <- start(object$sample)
  } else {
    start <- max(start, start(object$sample))
  }

  MCMC <- do.call(rbind, window(object$sample, start = start))
  if (nrow(MCMC) < m)
    stop("The number of imputations must be chosen to be less than or",
         gettextf("equal to the number of MCMC samples (= %s).",
                  nrow(MCMC)))


  # randomly draw which iterations should be used as imputation
  imp.iters <- sort(sample.int(nrow(MCMC), size = m))

  # reduce MCMC to relevant rows
  MCMC <- MCMC[imp.iters, , drop = FALSE]

  DF_list <- list()
  for (i in 1:(m + 1)) {
    DF_list[[i]] <- cbind("Imputation_" = i - 1, DF)
  }

  for (i in seq_along(meth)) {
    impval <- NULL
    # imputation by linear regression --------------------------------------------------------
    if (meth[i] %in% c("norm", "lognorm", "gamma", "beta")) {
      if (names(meth[i]) %in% colnames(object$data_list$Xtrafo)) {
        pat <- paste0("Xtrafo\\[[[:digit:]]*,",
                      match(names(meth)[i], colnames(object$data_list$Xtrafo)),
                      "\\]")
      } else {
        pat <- paste0("Xc\\[[[:digit:]]*,",
                      match(names(meth)[i], colnames(object$data_list$Xc)),
                      "\\]")
      }

      impval <- MCMC[, grep(pat, colnames(MCMC), value = TRUE)]
      if (!is.null(object$scale_pars)) {
        impval <- impval * object$scale_pars["scale", names(meth)[i]]  +
          object$scale_pars["center", names(meth)[i]]
      }

      if (length(impval) > 0) {
        rownrs <- gsub(",[[:digit:]]*\\]", "",
                       gsub("[[:alpha:]]*\\[", "", colnames(impval)))

        for (j in (1:m) + 1) {
          DF_list[[j]][is.na(DF_list[[j]][, names(meth)[i]]), names(meth)[i]] <-
            impval[j - 1, order(as.numeric(rownrs))]
        }
      }
    }
    # imputation by binary regression --------------------------------------------------------
    if (meth[i] %in% c("logit")) {
      pat <- paste0("Xc\\[[[:digit:]]*,",
                    match(attr(object$Mlist$refs[[names(meth)[i]]], "dummies"),
                          colnames(object$data_list$Xc)),
                    "\\]")
      impval <- MCMC[, grep(pat, colnames(MCMC), value = TRUE), drop = FALSE]

      if (length(impval) > 0) {
        rownrs <- gsub(",[[:digit:]]*\\]", "",
                       gsub("[[:alpha:]]*\\[", "", colnames(impval)))

        for (j in (1:m) + 1) {
          vec <- as.numeric(DF_list[[j]][, names(meth)[i]]) - 1
          vec[is.na(vec)] <- impval[j - 1, order(as.numeric(rownrs))]
          vec <- as.factor(vec)
          levels(vec) <- levels(DF_list[[j]][, names(meth)[i]])
          DF_list[[j]][, names(meth)[i]] <- vec
        }
      }
    }

    # imputation of categorical variables ----------------------------------------------------
    if (meth[i] %in% c("cumlogit", "multilogit")) {
      pat <- paste0("Xcat\\[[[:digit:]]*,",
                    match(names(meth)[i], colnames(object$data_list$Xcat)),
                    "\\]")
      impval <- MCMC[, grep(pat, colnames(MCMC), value = TRUE)]

      if (length(impval) > 0) {
        rownrs <- gsub(",[[:digit:]]*\\]", "",
                       gsub("[[:alpha:]]*\\[", "", colnames(impval)))

        for (j in (1:m) + 1) {
          vec <- as.numeric(DF_list[[j]][, names(meth)[i]])
          vec[is.na(vec)] <- impval[j - 1, order(as.numeric(rownrs))]
          if (meth[i] == "cumlogit") {
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


  if (!include)
    DF_list <- DF_list[-1]

# build dataset --------------------------------------------------------------------------
  if (object$analysis_type %in% c("lme", "glme")) {
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

  if (export_to_SPSS == TRUE) {
    foreign::write.foreign(impDF,
               file.path(resdir, paste0(filename, ".txt")),
               file.path(resdir, paste0(filename, ".sps"))
    )
  }

  return(impDF)
}
