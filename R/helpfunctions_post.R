# get_subset <- function(subset, MCMC, object) {
#   if (any(subset != "analysis_main")) {
#     subset <- subset[which(subset != "analysis_main")]
#
#     if (inherits(MCMC, "mcmc.list")) {
#       subset <- sapply(subset, function(i) {
#         if (is.na(match(i, colnames(MCMC[[1]])))) {
#           colnames(MCMC[[1]])[as.numeric(i)]
#         } else {
#           i
#         }
#       })
#     } else {
#       subset <- sapply(subset, function(i) {
#         if (is.na(match(i, colnames(MCMC))) & i != "analysis_main") {
#           colnames(MCMC)[as.numeric(i)]
#         } else {
#           i
#         }
#       })
#     }
#   }
#
#   if (any(subset == "analysis_main")) {
#     coefs <- get_coef_names(object$Mlist, object$K)
#
#     subset <- append(subset[which(subset != "analysis_main")], coefs[, 2], after = 0)
#     if (!is.null(object$Mlist$auxvars))
#       subset <- subset[-which(subset %in% c(object$Mlist$auxvars,
#                                             unlist(lapply(object$Mlist$refs[object$Mlist$auxvars],
#                                                           attr, "dummies"))))]
#
#     if (object$analysis_type == "lm" |
#         (object$analysis_type == "glm" &
#          attr(object$analysis_type, "family") %in% c("Gamma", "gaussian"))) {
#       subset <- c(subset, paste0("sigma_", names(object$Mlist$y)))
#     }
#     if (object$analysis_type == "lme") {
#       subset <- c(subset,
#                   paste0("sigma_", names(object$Mlist$y)),
#                   grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = TRUE))
#     }
#   }
#   return(MCMC[, subset, drop = FALSE])
# }

get_subset <- function(object, subset, call_orig, warn = TRUE) {
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

  if (length(sub) == 0)
    sub <- colnames(object$MCMC[[1]])
  # stop(gettextf("None of the parameters selected by 'subset' is in the MCMC sample %s." ,
  #               dQuote(call_orig$object)), call. = FALSE)

  # if (any(!s %in% colnames(object$MCMC[[1]]))) {
  #   if (warn)
  #   warning(paste0("No MCMC samples found for ",
  #                  paste("'", s[!s %in% colnames(object$MCMC[[1]])], "'",
  #                        sep = "", collapse = ", "), "."), immediate. = TRUE)
  # }

  return(object$MCMC[, sub])
}

computeP <- function(x) {
    above <- mean(x > 0)
    below <- mean(x < 0)
    2 * min(above, below)
}
