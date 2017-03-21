get_refs <- function(factors, refcats, DF = NULL) {

  if (is.null(refcats)) {
    refcats <- rep("largest", length(factors))
    names(refcats) <- factors
  } else if (refcats %in% c("first", "largest")) {
    refcats <- setNames(rep(refcats, length(factors)), factors)
  } else if (any(!factors %in% names(refcats))) {
    add <- factors[!factors %in% names(refcats)]
    refcats <- c(refcats,  setNames(rep("largest", length(add)), add))
  }

  sapply(factors, function(x){
    if (is.character(refcats[x]) & !refcats[x] %in% c("first", "largest")) {
      refcats[x] <- match(refcats[x], levels(DF[, x]))
    } else if (refcats[x] == 'first') {
      refcats[x] <- 1
    } else if (refcats[x] == 'largest') {
      refcats[x] <- which.max(table(DF[, x]))
    }
    res <- factor(levels(DF[, x])[as.numeric(refcats[x])], levels(DF[, x]))
    attr(res, "dummies") <- paste0(x, levels(res)[levels(res) != res])
      res
  }, simplify = F)
}
