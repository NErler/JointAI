
get_subset <- function(object, subset, keep_aux = FALSE, warn = TRUE, mess = TRUE) {

  if (is.logical(subset) && !subset)
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

  s <- do.call(get_params, c(object, Mlist_new, subset, mess = mess))

  # if (object$analysis_type != "JM") {
  # repl <- sapply(s, function(r) {
  #   # if (grepl("^beta$", r)) {
  #     # get_coef_names(object$Mlist, object$K)[, 2]
  #   # } else
  #     if (!r %in% colnames(object$MCMC[[1]]) & any(grepl(paste0('^', r, '\\['), colnames(object$MCMC[[1]])))) {
  #     grep(paste0("^", r, "\\["), colnames(object$MCMC[[1]]), value = TRUE)
  #   }
  # }, simplify = FALSE)

  # for (i in seq_along(repl)) {
  #   if (!is.null(repl[[i]])) {
  #     s <- append(s, repl[[i]], after = match(names(repl)[i], s))
  #     s <- s[-match(names(repl)[i], s)]
  #   }
  # }

  sub <- unique(unlist(
    c(
      sapply(paste0("^", s, "\\["), grep, colnames(object$MCMC[[1]]), value = TRUE),
      colnames(object$MCMC[[1]])[na.omit(sapply(s, match, table = colnames(object$MCMC[[1]])))]
  )
  ))


  # sub <- unique(s[s %in% colnames(object$MCMC[[1]])])
  # } else {
  #   sub <- unlist(sapply(s, function(i)
  #     grep(i, colnames(object$MCMC[[1]]), value = TRUE, fixed = TRUE), simplify = FALSE))
  # }
  if (!keep_aux)
    sub <- sub[!sub %in% get_aux(object)]

  if (length(sub) == 0)
    sub <- colnames(object$MCMC[[1]])

  return(object$MCMC[, sub, drop = FALSE])
}

