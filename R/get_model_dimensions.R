
get_1model_dim <- function(lp_cols, modeltype, ncat) {

  K <- matrix(NA,
              nrow = length(lp_cols),
              ncol = 2,
              dimnames = list(names(lp_cols),
                              c("start", "end")))

  nlp <- if (modeltype %in% c('mlogit', 'mlogitmm')) ncat - 1 else 1

  # if (length(lp_cols$Mc) > 0) K["Mc", ] <- c(1, nlp * length(lp_cols$Mc))
  if (length(lp_cols) > 0)
    for (i in names(lp_cols)) {
      K[i, ] <- c(1, nlp * length(lp_cols[[i]])) + max(c(K, 0), na.rm = TRUE)
    }
  K
}



get_model_dim <- function(lp_cols, Mlist) {
  if (!is.list(lp_cols))
    stop("lp_cols is not a list, but I expected a list!")

    Klist <- sapply(names(lp_cols), function(i) {
      get_1model_dim(lp_cols = lp_cols[[i]], modeltype = Mlist$models[i],
                     ncat = length(levels(Mlist$refs[[i]])))
    }, simplify = FALSE)

    for(i in seq_along(Klist)[-1]) {
      Klist[[i]] <- Klist[[i]] + max(Klist[[i-1]], na.rm = TRUE)
    }
    Klist
}

