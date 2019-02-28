
get_subset <- function(object, subset, keep_aux = FALSE, warn = TRUE) {
  subset <- as.list(subset)

  if (length(subset) == 0 & !as.list(object$monitor_params)$analysis_main)
    return(object$MCMC)

  if (length(subset) == 0 & as.list(object$monitor_params)$analysis_main)
    subset <- c(analysis_main = TRUE)

  if (!length(subset) == 0 && is.null(as.list(subset)$analysis_main))
    subset$analysis_main <- FALSE

  s <- do.call(get_params, c(object, object$Mlist, subset))

  repl <- sapply(s, function(r) {
    if (grepl("^beta$", r)) {
      get_coef_names(object$Mlist, object$K)[, 2]
    } else if (!r %in% colnames(object$MCMC[[1]]) & any(grepl(r, colnames(object$MCMC[[1]])))) {
      grep(paste0(r, "\\[[[:digit:]]+\\]"), colnames(object$MCMC[[1]]), value = TRUE)
    }
  }, simplify = FALSE)

  for (i in seq_along(repl)) {
    if (!is.null(repl[[i]])) {
      s <- append(s, repl[[i]], after = match(names(repl)[i], s))
      s <- s[-match(names(repl)[i], s)]
    }
  }

  sub <- unique(s[s %in% colnames(object$MCMC[[1]])])
  if (!keep_aux)
    sub <- sub[!sub %in% get_aux(object)]

  if (length(sub) == 0)
    sub <- colnames(object$MCMC[[1]])

  return(object$MCMC[, sub, drop = FALSE])
}

