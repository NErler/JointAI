
# get the model dimension (number of parameters per design matrix for the
# different levels) for a single model
get_1model_dim <- function(lp_cols, modeltype, ncat, lp_nonprop) {

  # prepare matrix to save parameter indices in
  K <- matrix(NA,
              nrow = length(lp_cols),
              ncol = 2,
              dimnames = list(names(lp_cols), c("start", "end")))

  # identify the number of linear predictors
  # (multiple if the model is a multinomial model)
  nlp <- if (modeltype %in% c("mlogit", "mlogitmm")) ncat - 1 else 1

  if (length(lp_cols) > 0)
    for (i in names(lp_cols)) {
      if (modeltype %in% c("clm", "clmm")) {
        # for ordinal models, the number of parameter is the number of columns
        # given in lp_cols plus extra parameters for the non-proportional
        # effects (which are already included in lp_cols once, therefore ncat -
        # 2)
        K[i, ] <- c(1, length(lp_cols[[i]]) + length(lp_nonprop[[i]]) *
                      (ncat - 2)) + max(c(K, 0), na.rm = TRUE)
      } else {
        K[i, ] <- c(1, nlp * length(lp_cols[[i]])) + max(c(K, 0), na.rm = TRUE)
      }
    }
  K
}


# get the model dimension (number of parameters per design matrix for the
# different levels) for a list of models
get_model_dim <- function(lp_cols, Mlist) {
  if (!is.list(lp_cols))
    errormsg("%s is not a list, but I expected a list!", dQuote("lp_cols"))

    Klist <- sapply(names(lp_cols), function(i) {
      get_1model_dim(lp_cols = lp_cols[[i]], modeltype = Mlist$models[i],
                     ncat = length(levels(Mlist$refs[[i]])),
                     lp_nonprop = Mlist$lp_nonprop[[i]])
    }, simplify = FALSE)

    for (i in seq_along(Klist)[-1]) {
      Klist[[i]] <- Klist[[i]] + max(Klist[[i - 1]], na.rm = TRUE)
    }

    Klist
}
