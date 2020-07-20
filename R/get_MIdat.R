#' Extract multiple imputed datasets from an object of class JointAI
#'
#' This function returns a dataset containing multiple imputed datasets stacked
#' onto each other (i.e., long format; optionally including the original,
#' incomplete data).\cr
#' These data can be automatically exported to SPSS (as a .txt file containing
#' the data and a .sps file containing syntax to generate a .sav file).
#' For the export function the
#' \href{https://CRAN.R-project.org/package=foreign}{\strong{foreign}} package
#'  needs to be installed.
#'
#' @inheritParams sharedParams
#' @param m number of imputed datasets
#' @param include should the original, incomplete data be included? Default is
#'                \code{TRUE}.
#' @param minspace minimum number of iterations between iterations to be chosen
#'                 as imputed values (to prevent strong correlation between
#'                 imputed datasets in the case of high autocorrelation of the
#'                 MCMC chains).
#' @param seed optional seed value
#' @param export_to_SPSS logical; should the completed data be exported to SPSS?
#' @param resdir optional; directory for results. If unspecified and
#'               \code{export_to_SPSS = TRUE} the current working directory is
#'               used.
#' @param filename optional; file name (without ending). If unspecified and
#'                 \code{export_to_SPSS = TRUE} a name is generated
#'                 automatically.
#'
#' @return A \code{data.frame} in which the original data (if
#'         \code{include = TRUE}) and the imputed datasets are stacked onto
#'         each other.\cr
#'         The variable \code{Imputation_} indexes the imputation, while
#'         \code{.rownr} links the rows to the rows of the original data.
#'         In cross-sectional datasets the
#'         variable \code{.id} is added as subject identifier.
#'
#' @section Note:
#' In order to be able to extract (multiple) imputed datasets the imputed values
#' must have been monitored, i.e., \code{imps = TRUE} had to be specified in the
#' argument \code{monitor_params} in \code{\link[JointAI:model_imp]{*_imp}}.
#'
#' @seealso \code{\link{plot_imp_distr}}
#'
#' @examples
#' # fit a model and monitor the imputed values with
#' # monitor_params = c(imps = TRUE)
#'
#' mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF,
#'               monitor_params = c(imps = TRUE), n.iter = 100)
#'
#' # Example 1: without export to SPSS
#' MIs <- get_MIdat(mod, m = 3, seed = 123)
#'
#'
#' \dontrun{
#' # Example 2: with export for SPSS
#' # (here: to the temporary directory "temp_dir")
#'
#' temp_dir <- tempdir()
#' MIs <- get_MIdat(mod, m = 3, seed = 123, resdir = temp_dir,
#'                  filename = "example_imputation",
#'                  export_to_SPSS = TRUE)
#'
#' }
#'
#' @export
#'

get_MIdat <- function(object, m = 10, include = TRUE,
                      start = NULL, minspace = 50, seed = NULL,
                      export_to_SPSS = FALSE,
                      resdir = NULL, filename = NULL) {

  if (!"foreign" %in% rownames(installed.packages()))
    errormsg("This function requires the 'foreign' package to be installed.")

  if (is.null(object$MCMC))
    errormsg("The object does not contain any MCMC samples.")

  # set seed value if provided
  if (!is.null(seed)) {
    set_seed(seed)
  }


  # extract original data and add
  # - column with row numbers (needed for plot_imp_distr())
  # - an id variable if there is none
  DF <- object$data
  DF$.rownr <- seq_len(nrow(DF))
  if (length(object$Mlist$groups) < 2) DF$.id <- seq_len(nrow(DF))


  # extract variable levels
  Mlvls <- object$Mlist$Mlvls

  # names of variables that were imputed
  vars <- intersect(names(object$models), names(DF)[colSums(is.na(DF)) > 0])

  # get a summary of the relevant characteristics of the imputed variables
  varinfo <- lapply(object$info_list[vars], function(x) {
    data.frame(varname = x$varname,
               modeltype = x$modeltype,
               family = ifelse(!is.null(x$family), x$family, NA),
               stringsAsFactors = FALSE)
  })

  if (is.null(start)) {
    start <- start(object$MCMC)
  } else {
    start <- max(start, start(object$MCMC))
  }

  MCMC <- do.call(rbind, window(object$MCMC, start = start))


  # randomly draw which iterations should be used as imputation
  if (nrow(MCMC) / minspace < m)
    errormsg("The total number of iterations (%s) is too small to select %s
             iterations with spacing of >= %s.", nrow(MCMC), m, minspace)

  cand_iters <- seq(from = sample.int(minspace, size = 1), to = nrow(MCMC),
                    by = minspace)
  imp_iters <- sort(sample(cand_iters, size = m))


  # reduce MCMC to the relevant rows
  MCMC <- MCMC[imp_iters, , drop = FALSE]

  # prepare a list of copies of the original data
  df_list <- list()
  for (i in 1:(m + 1)) {
    df_list[[i]] <- cbind("Imputation_" = i - 1, DF)
  }


  for (i in vars) {
    impval <- NULL

    # identify the names of the columns in MCMC corresponding to variable i
    pat <- paste0(Mlvls[i], "\\[[[:digit:]]*,",
                  match(i, colnames(object$data_list[[Mlvls[i]]])),
                  "\\]")

    if (!any(grepl(pat, colnames(MCMC))))
      errormsg("I cannot find imputed values for %s. Did you monitor them?",
               dQuote(i))

    impval <- MCMC[, grep(pat, colnames(MCMC), value = TRUE), drop = FALSE]

    if (length(impval) > 0) {
      rownrs <- gsub(",[[:digit:]]*\\]", "",
                     gsub("^[[:print:]]*\\[", "", colnames(impval)))

      for (j in (1:m) + 1) {
        iv <- impval[j - 1, na.omit(match(
          object$Mlist$groups[[gsub("M_", "", Mlvls[i])]],
          as.numeric(rownrs)
        ))]

        if (is.factor(df_list[[j]][, i])) {
          df_list[[j]][is.na(df_list[[j]][, i]), i] <-
            factor(iv, labels = levels(df_list[[j]][, i]),
                   levels = seq_along(levels(df_list[[j]][, i])) -
                     as.numeric(length(levels(df_list[[j]][, i])) == 2)
                   )
        } else {
          df_list[[j]][is.na(df_list[[j]][, i]), i] <- iv
        }
      }
    }
  }


  if (!include)
    df_list <- df_list[-1]

  # build dataset --------------------------------------------------------------
  imp_df <- do.call(rbind, df_list)

  if (is.null(resdir))
    resdir <- getwd()

  if (is.null(filename))
    filename <- paste0("JointAI-imputation_", Sys.Date())

  if (export_to_SPSS == TRUE) {
    foreign::write.foreign(imp_df,
                           file.path(resdir, paste0(filename, ".txt")),
                           file.path(resdir, paste0(filename, ".sps")),
                           package = "SPSS"
    )
  }

  return(imp_df)
}
