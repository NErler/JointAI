#' Summary of an JointAI object
#' @param object an object of class JointAIObject
#' @inheritParams coda::window.mcmc
#' @param quantiles posterior quantiles
#' @export
summary.JointAI <- function(object, start = NULL, end = NULL, thin = NULL,
                                  quantiles = c(0.025, 0.975)) {

  if (is.null(object$sample))
    error("No mcmc sample.")


  if (is.null(start))
    start <- start(object$sample)

  if (is.null(end))
    end <- end(object$sample)

  if (is.null(thin))
    thin <- thin(object$sample)

  MCMC <- do.call(rbind,
                  window(object$sample,
                          start = start,
                          end = end,
                          thin = thin))


  hc_list <- object$Mlist$hc_list

  coefs <- rbind(
    if (!is.null(object$Mlist$Xc))
      cbind(paste0("beta[", object$K["Xc", 1]:object$K["Xc", 2], "]"),
            colnames(object$Mlist$Xc)),
    if (!is.null(hc_list))
      cbind(unlist(sapply(names(hc_list), function(x)
        paste0("beta[", object$K[x, 1]:object$K[x, 2], "]"))),
        unlist(lapply(hc_list, function(x) {
          names(x)[which(attr(x, "matrix") %in% c("Xc", "Z"))]
        }))),
    if (!is.null(object$Mlist$Xic))
      cbind(paste0("beta[", object$K["Xic", 1]:object$K["Xic", 2], "]"),
            colnames(object$Mlist$Xic)),
    if (!is.null(object$Mlist$Xl))
      cbind(paste0("beta[", object$K["Xl", 1]:object$K["Xl", 2], "]"),
            colnames(object$Mlist$Xl)),
    if (!is.null(object$Mlist$Xil))
      cbind(paste0("beta[", object$K["Xil", 1]:object$K["Xil", 2], "]"),
            colnames(object$Mlist$Xil))
  )


  coefnam <- colnames(MCMC)

  coefnam[match(coefs[, 1], coefnam)] <- coefs[, 2]

  statnames <- c("Mean", "SD", paste0(quantiles * 100, "%"))
  stats <- matrix(nrow = length(colnames(MCMC)),
                  ncol = length(statnames),
                  dimnames = list(coefnam, statnames))

  stats[, "Mean"] <- apply(MCMC, 2, mean)
  stats[,  "SD"] <- apply(MCMC, 2, sd)
  stats[, -c(1:2)] <- t(apply(MCMC, 2, quantile, quantiles))

  out <- list()
  out$start <- start
  out$end <- end
  out$thin <- thin
  out$nchain <- nchain(object$sample)
  out$stats <- stats

  class(out) <- "summary.JointAI"
  return(out)
}


#' @rdname summary.JointAI
#' @export
print.summary.JointAI <- function(x, digits = max(3, .Options$digits - 3)) {
  cat("\n", "Iterations = ", x$start, ":", x$end, "\n", sep = "")
  cat("Thinning interval =", x$thin, "\n")
  cat("Number of chains =", x$nchain, "\n")
  cat("Sample size per chain =", (x$end - x$start)/x$thin +
        1, "\n\n")
  # cat("\n1. Empirical mean and standard deviation for each variable,")
  # cat("\n   plus standard error of the mean:\n\n")
  cat("Posterior summary:\n\n")
  print(x$stats, digits = digits)
  cat("\n")
  invisible(x)
}