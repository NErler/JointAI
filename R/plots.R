#' Traceplots
#' @param object object
#' @export
traceplot <- function(object, ...) {
  UseMethod("traceplot", object)
}



#' @rdname traceplot
#' @export
traceplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL, subset = "main",
                              nrow = NULL, ncol = NULL, ...) {

  prep <- plot_prep(object, start = start, end = end, thin = thin, subset = subset,
                    nrow = nrow, ncol = ncol)


  par(mfrow = c(prep$nrow, prep$ncol), mar = c(3.2, 2.5, 2, 1), mgp = c(2, 0.6, 0),
      ask = prep$ask)

  for (i in 1:nvar(prep$MCMC)) {
    matplot(as.array(prep$MCMC)[, i, ], type = "l", xlab = "Iterations", ylab = "",
            main = colnames(prep$MCMC[[1]])[i], ...)
  }
}


#' Densplots
#' @param object object
#' @export
densplot <- function(object, ...) {
  UseMethod("densplot", object)
}



#' @rdname densplot
#' @export
densplot.JointAI <- function(object, start = NULL, end = NULL, thin = NULL, subset = "main",
                             vlines = NULL, nrow = NULL, ncol = NULL, ...) {

  prep <- plot_prep(object, start = start, end = end, thin = thin, subset = subset,
                    nrow = nrow, ncol = ncol)


  par(mfrow = c(prep$nrow, prep$ncol), mar = c(3, 3, 2, 1), mgp = c(2, 0.6, 0),
      ask = prep$ask)
  for (i in 1:ncol(prep$MCMC[[1]])) {
    dens <- lapply(prep$MCMC[, i], density)
    vline_range <- if (is.list(vlines[[1]])) {
      lapply(lapply(vlines, "[[", "v"), "[", i)
    }else{
      vlines$v
    }
    plot(NULL,
         xlim = range(lapply(dens, "[[", "x"), vline_range),
         ylim = range(lapply(dens, "[[", "y")),
         main = colnames(prep$MCMC[[1]])[i],
         xlab = "", ylab = "density"
    )

    for (j in 1:length(prep$MCMC)) {
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




plot_prep <- function(object, start = NULL, end = NULL, thin = NULL, subset = NULL,
                      nrow = NULL, ncol = NULL) {
  if (is.null(start))
    start <- start(object$sample)

  if (is.null(end))
    end <- end(object$sample)

  if (is.null(thin))
    thin <- thin(object$sample)

  MCMC <- window(object$sample, start = start, end = end, thin = thin)
  time <- time(MCMC)

  coefs <- get_coef_names(object$Mlist, object$K)
  nams <- colnames(MCMC[[1]])
  nams[match(coefs[, 1], nams)] <- coefs[, 2]

  for (i in 1:length(MCMC)) {
    colnames(MCMC[[i]]) <- nams
  }

  scale_pars <- object$scale_pars
  if (!is.null(scale_pars)) {
    # re-scale parameters
    MCMC <- as.mcmc.list(lapply(MCMC, function(i) {
      as.mcmc(sapply(colnames(i), JointAI:::rescale, fixed2 = object$Mlist$fixed2, scale_pars = scale_pars,
                     MCMC = i, refs = object$Mlist$refs))
    }))
  }

  if (!is.null(subset)) {
    MCMC <- get_subset(subset, MCMC, object)

    # if (any(subset == "main")) {
    #   subset <- subset[which(subset != "main")]
    #   subset <- sapply(subset, function(i) {
    #     if (is.na(match(i, colnames(MCMC[[1]])))) {
    #       colnames(MCMC[[1]])[as.numeric(i)]
    #     } else {
    #       i
    #     }
    #   })
    #
    #   subset <- append(subset[which(subset != "main")], coefs[, 2], after = 0)
    #   if (object$analysis_type == "lm" |
    #       (object$analysis_type == "glm" &
    #        attr(object$analysis_type, "family") %in% c("Gamma", "gaussian"))) {
    #     subset <- c(subset, paste0("sigma_", names(object$Mlist$y)))
    #   }
    #   if (object$analysis_type == "lme") {
    #     subset <- c(subset,
    #                 paste0("sigma_", names(object$Mlist$y)),
    #                 grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC[[1]]), value = T))
    #   }
    # }
    # MCMC <- MCMC[, subset]
  }



  ask <- ncol(MCMC[[1]]) > 30

  if (is.null(nrow)) {
    if (is.null(ncol)) {
      nrow <- floor(sqrt(ncol(MCMC[[1]])))
    } else {
      nrow <- ceiling(ncol(MCMC[[1]])/ncol)
    }
  }

  if (is.null(ncol))
    ncol <- ceiling(ncol(MCMC[[1]])/nrow)

  if (ask) {
    nrow = 5
    ncol = 6
  }

  return(list(MCMC = MCMC, ask = ask, nrow = nrow, ncol = ncol,
              thin = thin, time = time, subset = subset))
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