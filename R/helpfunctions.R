# Check if a variable is time-varying ------------------------------------------
#' Check if a variable is time-varying
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @keywords internal
#' @return a logical value
check_tvar <- function(x, idvar) {
  !all(sapply(split(x, idvar),
              function(z) all(z == z[1], na.rm = TRUE)
  ))
}


# Find the position(s) of a variable in a model matrix -------------------------
# * varname: the name to be matched
# * DF: data.frame containing varname
# * colnams: vector of column names of matrix in which varname is looked up
match_positions <- function(varname, DF, colnams) {

  # can probably be deleted since contr is changed globally in model_imp
  # if (is.factor(DF[, varname])) {
  #   contr <- list("contr.treatment")
  #   names(contr) <- varname
  # } else {
  #   contr <- NULL
  # }
  # XX <- model.matrix(formula(paste("~", varname)), DF, contrasts.arg = contr))[-1L]


  XX <- model.matrix(formula(paste("~", varname)), DF)[, -1L, drop = FALSE]
  matches <- match(colnames(XX), colnams)
  names(matches) <- colnams[matches]

  return(if (any(!is.na(matches))) matches)
}



# Hierarchical centering structure ---------------------------------------------
get_hc_list_old <- function(X2, Xc, Xic, Z, Z2, Xlong) {
  hc_vars <- hc_list <- if (ncol(Z2) > 1) {
    lapply(sapply(colnames(Z2)[-1], gen_pat, simplify = FALSE),
           grep_names, colnames(X2))
  }

  for (i in 1:length(hc_vars)) {
    if (length(hc_vars[[i]]) > 0) {
      matchvars <- gsub(paste(gen_pat(names(hc_vars)[i]), collapse = "|"),
                        "", hc_vars[[i]])

      a <- sapply(
        apply(
          as.array(sapply(
            lapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), colnames),
            FUN = function(x) matchvars %in% x)), 1, which), names)


      a[matchvars == ""] <- "Z"
      a <- unlist(a)
      names(a) <- hc_vars[[i]]

      pos <- mapply(FUN = function(i, i_nam) {
        match(i_nam, lapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), colnames)[[i]])
      }, i = a, i_nam = matchvars)

      attr(pos, "matrix") <- a
      hc_list[[i]] <- pos
    }
  }
  return(hc_list)
}

get_hc_list <- function(X2, Xc, Xic, Z, Z2, Xlong) {
  # find all occurences of the random effects variables in the the fixed effects
  rd_effect <- hc_names <- if (ncol(Z2) > 1) {
    lapply(sapply(colnames(Z2)[-1], gen_pat, simplify = FALSE),
           grep_names, colnames(X2))
  }

  for (i in 1:length(hc_names)) {
    if (length(hc_names[[i]]) > 0) {
      # identify which are interactions
      rd_effect[[i]] <- as.list(gsub(paste(gen_pat(names(hc_names)[i]), collapse = "|"),
                                     '', hc_names[[i]]))
      rd_effect[[i]][rd_effect[[i]] == ''] <- names(rd_effect)[i]

      for (k in seq_along(rd_effect[[i]])) {
        mat <- sapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), function(x){
          rd_effect[[i]][[k]] %in% colnames(x)
        })
        attr(rd_effect[[i]][[k]], 'matrix') <- names(mat[mat])
        attr(rd_effect[[i]][[k]], 'column') <- match(rd_effect[[i]][[k]],
                                                     colnames(get(names(mat)[mat])))
      }
      names(rd_effect[[i]]) <- hc_names[[i]]
    }
  }
  return(rd_effect)
}



# Generate pattern (used in get_hc_list) ---------------------------------------
gen_pat <- function(nam) {
  nam <- gsub("^", "\\^", nam, fixed = TRUE)
  glob2rx(c(nam,
            paste0("*:", nam),
            paste0(nam, ":*")), trim.head = TRUE)
}

# Find names in a vector of names (used in get_hc_list) ------------------------
grep_names <- function(nams1, nams2){
  res <- unique(unlist(sapply(nams1, grep, nams2, value = TRUE, simplify = FALSE)))
  if (length(res) > 0) res
}
