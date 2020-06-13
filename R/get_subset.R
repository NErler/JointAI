
get_subset <- function(object, subset, warn = TRUE, mess = TRUE) {

  if (identical(subset, FALSE))
    return(object$MCMC)

  subset <- as.list(subset)

  if (length(subset) == 0 & !as.logical(as.list(object$monitor_params)$analysis_main))
    return(object$MCMC)

  if (length(subset) == 0 & as.logical(as.list(object$monitor_params)$analysis_main))
    subset <- c(analysis_main = TRUE)

  if (!length(subset) == 0 && is.null(as.list(subset)$analysis_main))
    subset$analysis_main <- FALSE


  Mlist_new <- object$Mlist
  Mlist_new$ppc <- as.list(subset)$ppc

  s <- do.call(get_params, c(list(Mlist = Mlist_new, info_list = object$info_list),
                             subset, mess = mess))

  sub <- unique(unlist(
    c(
      sapply(paste0("^", s, "\\["), grep, colnames(object$MCMC[[1]]), value = TRUE),
      colnames(object$MCMC[[1]])[na.omit(sapply(s, match, table = colnames(object$MCMC[[1]])))]
  )
  ))


  if (length(sub) == 0) sub <- colnames(object$MCMC[[1]])

  return(object$MCMC[, sub, drop = FALSE])
}

