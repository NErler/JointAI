# get_refs <- function(factors, refcats, DF = NULL) {
#
#   default <- "first"
#
#   if (is.null(refcats)) {
#     refcats <- rep(default, length(factors))
#     names(refcats) <- factors
#   } else {
#     if (length(refcats) == 1 & is.null(attr(refcats, "names"))) {
#       refcats <- setNames(rep(refcats, length(factors)), factors)
#     } else if (any(!factors %in% names(refcats))) {
#       add <- factors[!factors %in% names(refcats)]
#       refcats <- c(refcats,  setNames(rep(default, length(add)), add))
#     }
#   }
#
#   sapply(factors, function(x){
#     if (is.character(refcats[x]) & !refcats[x] %in% c("first", "largest")) {
#       refcats[x] <- match(refcats[x], levels(DF[, x]))
#     } else if (refcats[x] == 'first') {
#       refcats[x] <- 1
#     } else if (refcats[x] == 'largest') {
#       refcats[x] <- which.max(table(DF[, x]))
#     }
#     res <- factor(levels(DF[, x])[as.numeric(refcats[x])], levels(DF[, x]))
#     attr(res, "dummies") <- paste0(x, levels(res)[levels(res) != res])
#       res
#   }, simplify = F)
# }



get_refs <- function(factors, refcats, DF = NULL) {

  default <- "first"

  if (is.null(refcats)) {
    refcats <- rep(default, length(factors))
    names(refcats) <- factors
  } else {
    if (!is.list(refcats)) refcats <- as.list(refcats)
    if (length(refcats) == 1 & is.null(attr(refcats, "names"))) {
      refcats <- setNames(rep(refcats, length(factors)), factors)
    } else if (any(!factors %in% names(refcats))) {
      add <- factors[!factors %in% names(refcats)]
      refcats <- c(refcats,  setNames(rep(default, length(add)), add))
    }
  }

  sapply(factors, function(x){
    if (is.character(refcats[[x]]) & !refcats[[x]] %in% c("first", "largest")) {
      newrefcats <- match(refcats[[x]], levels(DF[, x]))
      if (is.na(newrefcats) & regexpr("^[[:digit:]]*$", refcats[[x]]) > 0) {
        refcats[[x]] <- as.numeric(refcats[[x]])
      } else {
        refcats[[x]] <- match(refcats[[x]], levels(DF[, x]))
      }
    } else if (refcats[[x]] == 'first') {
      refcats[[x]] <- 1
    } else if (refcats[[x]] == 'largest') {
      refcats[[x]] <- which.max(table(DF[, x]))
    }
    res <- factor(levels(DF[, x])[as.numeric(refcats[x])], levels(DF[, x]))
    attr(res, "dummies") <- paste0(x, levels(res)[levels(res) != res])
    res
  }, simplify = F)
}
