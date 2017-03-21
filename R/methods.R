#' Traceplots
#' @export
traceplot.JointAI <- function(x, start = NULL, end = NULL, thin = NULL, subset = NULL) {

  coefs <- get_coef_names(x$Mlist, x$K)
  MCMC <- x$sample
  nams <- colnames(MCMC[[1]])
  nams[match(coefs[, 1], nams)] <- coefs[, 2]

  for (i in 1:length(MCMC)) {
    colnames(MCMC[[i]]) <- nams
    # [na.omit(match(coefs[, 1], colnames(MCMC[[i]])))] <-
    #   coefs[na.omit(match(colnames(MCMC[[i]]), coefs[, 1])), 2]
  }


  if (!is.null(subset)) {
    if (subset == "main") {
      subset <- coefs[, 2]
      if (x$analysis_type == "lm" |
          (x$analysis_type == "glm" &
           attr(x$analysis_type, "family") %in% c("Gamma", "gaussian"))) {
        subset <- c(subset, paste0("sigma_", names(x$Mlist$y)))
      }
      if (x$analysis_type == "lme") {
        subset <- c(subset,
                    paste0("sigma_", names(x$Mlist$y)),
                    grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC[[1]]), value = T))
      }
    }
    MCMC <- MCMC[, subset]
  }


  if (is.null(start))
    start <- start(x$sample)

  if (is.null(end))
    end <- end(x$sample)

  if (is.null(thin))
    thin <- thin(x$sample)



  ask <- ncol(MCMC[[1]]) > 30

  nrow <- floor(sqrt(ncol(MCMC[[1]])))
  ncol <- ceiling(ncol(MCMC[[1]])/nrow)

  if (ask) {
    nrow = 5
    ncol = 6
  }

  par(mfrow = c(nrow, ncol), mar = c(3, 3, 2, 1), mgp = c(2, 0.6, 0), ask = ask)
  coda::traceplot(window(MCMC, start = start, end = end, thin = thin))
}


#' Traceplot
#' @export
traceplot <- function(x, ...) {
  UseMethod("traceplot", x)
}



# #' Coefplot
# #' @export
# coefplot <- function(x, ...) {
#   UseMethod("coefplot", x)
# }
#
# coef.plot.JointAI <- function(x, start = NULL, end = NULL, thin = NULL,
#                               subset = NULL) {
#   MCMC <- if (!is.null(subset)) {
#     x$sample[, subset]
#   } else {
#     MCMC <- x$sample
#   }
#
#   if (is.null(start))
#     start <- start(x$sample)
#
#   if (is.null(end))
#     end <- end(x$sample)
#
#   if (is.null(thin))
#     thin <- thin(x$sample)
#
#
#   nams <- get_coef_names(x$Mlist, x$K)
#
#   for (i in 1:length(MCMC)) {
#     colnames(MCMC[[i]])[na.omit(match(nams[, 1], colnames(MCMC[[i]])))] <-
#       nams[na.omit(match(colnames(MCMC[[i]]), nams[, 1])), 2]
#   }
#
#
#
# }