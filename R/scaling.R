#' calculate scaled data matrix
#' @param X a matrix
#' @param scale_vars a vector of variable names or FALSE
#' @param scale_pars a matrix of scaling parameters or FALSE or NULL
#' @export

scaled_data.matrix <- function(X, scale_vars, scale_pars) {
  if (any(scale_pars == F, scale_vars == F))
    scale_pars <- scale_vars <- F

  if (is.matrix(scale_pars)) {
    if (any(colnames(X) %in% colnames(scale_pars))) {
      X[, colnames(scale_pars)] <-
        sapply(colnames(scale_pars),
               function(x) (x - scale_pars["center", x])/scale_pars["scale", x]
        )
    }
  } else {
    if (is.null(scale_pars) & any(colnames(X) %in% scale_vars)) {
      scale_pars <- list()
      for (i in scale_vars[scale_vars %in% colnames(X)]) {
        scv <- scale(X[, i])
        X[, i] <- scv
        scale_pars[[i]] <- c(center = attr(scv, "scaled:center"),
                             scale = attr(scv, "scaled:scale"))
      }
    } else {
      scale_pars <- NULL
    }

  }
  return(list(X = data.matrix(X), scale_pars = scale_pars))
}



get_scaling <- function(Mlist, scale_pars = NULL) {
  # if (is.null(scale_pars)) {
  #   scale_vars <- Mlist$scale_vars
  # }
  refs <- Mlist$refs

  scaled_dat <- sapply(Mlist[!sapply(Mlist, is.null) &
                               names(Mlist) %in% c("Xc", "Xl", "Z")],
                       scaled_data.matrix, scale_vars = Mlist$scale_vars,
                       scale_pars = scale_pars,
                       simplify = FALSE)


  scale_pars <- as.data.frame(lapply(scaled_dat, "[[", 2))

  if (nrow(scale_pars) > 0) {
    names(scale_pars) <- unlist(lapply(lapply(scaled_dat, "[[", 2), names))


    scale_terms1 <- attr(terms(fixed), "factors")[names(scale_pars), , drop = F]
    scale_terms2 <- attr(terms(fixed), "factors")[, which(colSums(scale_terms1) > 0), drop = F]
    scale_terms2 <- scale_terms2[which(rowSums(scale_terms2) > 0), , drop = F]
    scale_terms3 <- scale_terms2

    for (i in 1:nrow(scale_terms3)) {
      invin.col <- which(scale_terms2[i, , drop = F] == 1)
      invin.row <- which(rowSums(scale_terms2[, invin.col, drop = F]) > 0)
      scale_terms3[invin.row, i] <- 1
    }

    add_scale <- unique(unlist(dimnames(scale_terms2)))
    add_scale <- add_scale[which(!add_scale %in% colnames(scale_pars))]
    # for (x in add_scale) {
    #   # nams <- names(which(scale_terms1[, x] == 1))
    #   scale_pars["scale", x] <- 1 #prod(scale_pars["scale", nams])
    #   scale_pars["center", x] <- 0#-prod(scale_pars["center", nams])
    # }

    new_names <- names(refs)[!names(refs) %in% colnames(scale_pars)]
    for (k in unlist(sapply(new_names, get_dummies, refs))) {
      scale_pars[c("center", "scale"), k] <- c(0, 1)
    }

  } else {
    scale_pars <- NULL
  }

  return(list(scaled_matrices = lapply(scaled_dat, "[[", 1),
              scale_pars = scale_pars)
  )
}



get_dummies <- function(x, refs) {
  lvls <- levels(refs[[x]])[levels(refs[[x]]) != refs[[x]]]
  paste0(x, lvls)
}

#
# new_names <- colnames(attr(terms(fixed), "factors"))[
#   colnames(attr(terms(fixed), "factors")) %in% rownames(attr(terms(fixed), "factors")) &
#     !colnames(attr(terms(fixed), "factors")) %in% names(scale_pars)]
#
#
