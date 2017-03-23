#' Traceplots
#' @param x object
#' @export
traceplot <- function(x, ...) {
  UseMethod("traceplot", x)
}



#' @rdname traceplot
#' @export
traceplot.JointAI <- function(x, start = NULL, end = NULL, thin = NULL, subset = NULL) {

  coefs <- get_coef_names(x$Mlist, x$K)
  MCMC <- x$sample
  nams <- colnames(MCMC[[1]])
  nams[match(coefs[, 1], nams)] <- coefs[, 2]

  for (i in 1:length(MCMC)) {
    colnames(MCMC[[i]]) <- nams
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



#' Densplots
#' @param x object
#' @export
densplot <- function(x, ...) {
  UseMethod("densplot", x)
}



#' @rdname densplot
#' @export
densplot.JointAI <- function(x, start = NULL, end = NULL, thin = NULL, subset = NULL,
                             vlines = NULL) {

  if (is.null(start))
    start <- start(x$sample)

  if (is.null(end))
    end <- end(x$sample)

  if (is.null(thin))
    thin <- thin(x$sample)

  MCMC <- window(x$sample, start = start, end = end, thin = thin)

  coefs <- get_coef_names(x$Mlist, x$K)
  nams <- colnames(MCMC[[1]])
  nams[match(coefs[, 1], nams)] <- coefs[, 2]

  for (i in 1:length(MCMC)) {
    colnames(MCMC[[i]]) <- nams
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


  ask <- ncol(MCMC[[1]]) > 30

  nrow <- floor(sqrt(ncol(MCMC[[1]])))
  ncol <- ceiling(ncol(MCMC[[1]])/nrow)

  if (ask) {
    nrow = 5
    ncol = 6
  }

  par(mfrow = c(nrow, ncol), mar = c(3, 3, 2, 1), mgp = c(2, 0.6, 0), ask = ask)
  for (i in 1:ncol(MCMC[[1]])) {
    dens <- lapply(MCMC[, i], density)
    vline_range <- if (is.list(vlines[[1]])) {
      lapply(lapply(vlines, "[[", "v"), "[", i)
    }else{
      lapply(vlines, "[", i)
    }
    plot(NULL,
         xlim = range(lapply(dens, "[[", "x"), vline_range),
         ylim = range(lapply(dens, "[[", "y")),
         main = colnames(MCMC[[1]])[i],
         xlab = "", ylab = "density"
    )

    for (j in 1:length(MCMC)) {
      lines(dens[[j]], col = j)
    }
    if (!is.null(vlines)) {
      for (l in 1:length(vlines)) {
        args <- if (is.list(vlines[[l]])) vlines[[l]] else vlines
        args$v <- args$v[i]
        do.call(abline, args)
      }
    }
  }
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