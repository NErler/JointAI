# help functions ---------------------------------------------------------------
tab <- function(times = 2) {
  tb <- " "
  paste(rep(tb, times), collapse = "")
}

add_linebreaks <- function(string, indent, width = 85) {
  # string: the linear predictor string to be broken
  # indent: in case of a linebreak, how much should the new line be indented?
  # width: output width

  if (is.null(string))
    return(NULL)

  m <- gregexpr(" \\+ ", string)[[1]]
  if (all(m < 0))
    return(string)

  len <- c(as.numeric(m)[1], diff(c(as.numeric(m), nchar(string))))

  i <- 1
  br <- c()
  while(i < length(len)) {
    cs <- cumsum(len[i:length(len)])
    nfit <- max(1, which(cs <= (width - indent)))
    br <- c(br, rep(' + ', nfit - 1),
            if ((i + nfit - 1) < length(len)) paste0(' +\n', tab(indent)))
    i <- i + nfit
  }

  paste0(strsplit(string, " \\+ ")[[1]], c(br, ''), collapse = '')
}


# pasting linear predictors ----------------------------------------------------
paste_linpred <- function(parname, parelmts, matnam, index, cols, scale_pars, isgk = FALSE) {
  # parname: name of the parameter, e.g. "beta"
  # parelmts: vector specifying which elements of the parameter vector are to be
  #           used, e.g. c(1,2,3,6,8,4)
  # matnam: name or the design matrix, e.g. "Ml" or "Mc"
  # index: character sting specifying the index to be used, e.g. "i" or "j"
  # cols: index of the columns of the design matrix to be used, e.g. c(1, 4, 2, 10)
  # scale_pars: a matrix with rownames according to the columns of the design matrix
  #             and columns 'center' and 'scale'. Contains NA if a variable should
  #             not be scaled (could also be NULL instead of a matrix)

  paste(
    paste_scaling(x = paste_data(matnam, index, cols, isgk),
                  rows = cols,
                  scale_pars = scale_pars,
                  scalemat = paste0('sp', matnam)
    ),
    paste_coef(parname, parelmts),
    sep = " * ", collapse = " + ")
}

paste_scale <- function(x, row, scalemat) {
  # x: term that will be scaled (or vector of terms)
  # row: the row number(s) of the matrix containing the scaling parameters
  # scalemat: the name of the matrix containing the scaling parameters, e.g. "spMl" or "spMc"
  paste0("(", x, " - ", scalemat, "[", row, ", 1])/", scalemat, "[", row, ", 2]")
}

paste_scaling <- function(x, rows, scale_pars, scalemat) {
  # x: vector of expressions to scale
  # row: the row number(s) of the matrix containing the scaling parameters
  # scale_pars: scaling matrix
  # scalemat: name of the scaling matrix in JAGS

  if (is.null(scale_pars)) {
    x
  } else {
    ifelse(rowSums(is.na(scale_pars[rows, ])) > 0,
           x,
           paste_scale(x, row = rows, scalemat = scalemat)
    )
  }
}

paste_data <- function(matnam, index, col, isgk = FALSE) {
  # matnam: the name of the design matrix
  # index: the index to be used, e.g. "i" or "j"
  # col: the column (or vector of columns) of the design matrix
  # isgk: is this whithin the Gauss-Kronrod quadrature?
  paste0(matnam, ifelse(isgk, "gk", ''), "[", index, ", ", col,
         ifelse(isgk, ", k]", "]"))
}

paste_coef <- function(parname, parelmts) {
  # parname: the name of the parameter, e.g. "alpha" or "beta"
  # parelmts: vector of integers giving the elements of the parameter to be used
  paste0(parname, '[', parelmts, ']')
}


# pasting random effects -------------------------------------------------------

paste_rdslope_lp <- function(hc_info, info) {
  if (is.null(hc_info))
    return(NULL)

  lapply(hc_info, function(k) {

    if (is.na(k$main_effect$coef_nr)) {
      # if there is no corresponding fixed effect, the mean of the
      # random effect distribution is 0:
      "0"
    } else {
      paste0(
        c(# main effects part: only coefficient
          paste_coef(info$parname, k$main_effect$coef_nr),

          if (!is.null(k$interact_effect) &&
              any(sapply(k$interact_effect, "[[", "matrix") %in% 'Mc')) {
            # interaction part (baseline covs): coefficient * variable
            cols <- Filter(Negate(is.null),
                           lapply(k$interact_effect, function(x) {
                             if (any(x$matrix %in% 'Mc'))
                               x$column[x$matrix %in% 'Mc']
                           }))

            matnam <- Filter(Negate(is.null),
                             lapply(k$interact_effect, function(x) {
                               if (any(x$matrix %in% 'Mc'))
                                 x$matrix[x$matrix %in% 'Mc']
                             }))

            coefnrs <- Filter(Negate(is.null),
                              lapply(k$interact_effect, function(x) {
                                if (any(x$matrix %in% 'Mc'))
                                  x$coef_nr
                              }))

            paste(
              paste_coef(info$parname, coefnrs),
              mapply(function(x, col) {
                paste0(
                  paste_scaling(x = x,
                                scale_pars = info$scale_pars$Mc,
                                rows = col,
                                scalemat = 'spMc'
                  ), collapse = " * ")
              }, x = sapply(cols, paste_data, matnam = "Mc", index = "i"),
              col = cols),
              sep = " * ")

          }
        ), collapse = " + ") # add up main * interaction
    }
  })
}


paste_rdintercept_lp <- function(info, in_b0) {
  if (length(in_b0) > 0) {
  paste_linpred(parname = info$parname,
                parelmts = info$parelmts$Mc[in_b0],
                matnam = "Mc",
                index = info$index[2],
                cols = info$lp$Mc[in_b0],
                scale_pars = info$scale_pars$Mc[in_b0, ],
                isgk = FALSE)
  } else {
    "0"
  }
}


paste_mu_b <- function(rdintercept, rdslopes, varname, index) {
  paste0(c(
    # random intercept
    paste0(tab(4),
      paste_data(matnam = paste0("mu_b_", varname), index = index, col = 1),
      " <- ",
      add_linebreaks(rdintercept,
                     indent = 4 + 5 + nchar(varname) + 1 + nchar(index) + 8)
    ),
    if (length(rdslopes) > 0) {
      # random slopes
      paste0(
        tab(4),
        paste_data(matnam = paste0("mu_b_", varname), index = index,
                   col = seq_along(rdslopes) + 1),
        " <- ",
        sapply(rdslopes, add_linebreaks,
               indent = 4 + 5 + nchar(varname) + 1 + nchar(index) + 8)
      )
    }), collapse = "\n"
  )
}

paste_Zpart <- function(info, index, hc_info, notin_b, isgk = FALSE) {
  matnam <- unlist(lapply(lapply(hc_info, "[[", 'main_effect'), "[[", 'matrix'))
  cols <- unlist(lapply(lapply(hc_info, "[[", 'main_effect'), "[[", 'column'))

  rdindex <- if (isgk) index else paste0("group[", index, "]")

  paste(c(
    # random intercept
    paste_data(matnam = paste0("b_", info$varname), index = rdindex, col = 1),

    # random slopes
    if (length(matnam) > 0) {
      pastedat <- paste_data(matnam = paste0(matnam, if (isgk) "gk"),
                             index = c('Ml' = index,
                                       'Mc' = paste0("group[", index, "]"))[matnam],
                             col = paste0(cols, if (isgk) ", k"))
      paste(
        paste_data(matnam = paste0("b_", info$varname), index = rdindex,
                   col = seq_along(matnam) + 1),
        mapply(function(x, rows, scale_pars, scalemat) {
          paste_scaling(
            x = x,
            rows = rows,
            scale_pars = scale_pars,
            scalemat = scalemat
          )
        }, x = pastedat, rows = cols, scale_pars = info$scale_pars[matnam],
        scalemat = paste0('sp', matnam)),
        sep = " * "
      )},
    if (length(info$parelmts$Ml[notin_b]) > 0)
      paste_linpred(parname = info$parname,
                    parelmts = info$parelmts$Ml[notin_b],
                    matnam = "Ml",
                    index = index,
                    cols = info$lp$Ml[notin_b],
                    scale_pars = info$scale_pars$Ml,
                    isgk = isgk)),
    collapse = " + ")
}

# Joint model ------------------------------------------------------------------

paste_obsvalue <- function(matname, index, column, isgk, ...) {
  if (isgk)
    paste0(matname, "gk[", index, ", ", column, ", k]")
  else
    paste0(matname, "[survrow[", index, "], ", column, "]")
}

paste_underlvalue <- function(covname, index, isgk, ...) {
  if (isgk)
    paste0("mugk_", covname, "[", index, ", k]")
  else
    paste0('mu_', covname, "[survrow[", index, "]]")
}

paste_association <- function(covnames, matname, index, columns, assoc_type, isgk) {
  mapply(function(assoc_type, covname, matname, column, index, isgk) {
    paste_ass <- switch(assoc_type,
                        "obs.value" = paste_obsvalue,
                        "underl.value" = paste_underlvalue)
    paste_ass(covname = covname,
              matname = matname,
              index = index,
              column = column,
              isgk = isgk)
  }, assoc_type = assoc_type, covname = covnames, matname = matname, column = columns,
  MoreArgs = list(index = index, isgk = isgk)
  )
}


paste_linpred_JM <- function(parname, parelmts, matnam, index, cols, scale_pars,
                             assoc_type, covnames, isgk = FALSE) {
  # parname: name of the parameter, e.g. "beta"
  # parelmts: vector specifying which elements of the parameter vector are to be
  #           used, e.g. c(1,2,3,6,8,4)
  # matnam: name or the design matrix, e.g. "Ml" or "Mc"
  # index: character sting specifying the index to be used, e.g. "i" or "j"
  # cols: index of the columns of the design matrix to be used, e.g. c(1, 4, 2, 10)
  # scale_pars: a matrix with rownames according to the columns of the design matrix
  #             and columns 'center' and 'scale'. Contains NA if a variable should
  #             not be scaled (could also be NULL instead of a matrix)


  pastedat <- paste_association(covnames = covnames, matname = matnam,
                                index = index, columns = cols,
                                assoc_type = assoc_type, isgk = isgk)

  paste(
    paste_scaling(x = pastedat,
                  rows = cols,
                  scale_pars = scale_pars,
                  scalemat = paste0('sp', matnam)
    ),
    paste_coef(parname, parelmts),
    sep = " * ", collapse = " + ")
}





# * random effects specifications ------------------------------------------------
ranef_priors <- function(nranef, varname) {
  invD_distr <- if (nranef == 1) {
    "dgamma(shape_diag_RinvD, rate_diag_RinvD)"
  } else {
    paste0("dwish(RinvD_", varname, "[ , ], KinvD_", varname, ")")
  }

  paste0("\n",
         if (nranef > 1) {
           paste0(
             tab(), "for (k in 1:", nranef, "){", "\n",
             tab(4), "RinvD_", varname, "[k, k] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)", "\n",
             tab(), "}", "\n")
         },
         tab(), "invD_", varname, "[1:", nranef, ", 1:", nranef,"] ~ ", invD_distr, "\n",
         tab(), "D_", varname, "[1:", nranef,", 1:", nranef, "] <- inverse(invD_", varname, "[ , ])"
  )
}

# paste other model parts ------------------------------------------------------
paste_dummies <- function(categories, dest_mat, dest_col, dummy_cols, index, ...){
  mapply(function(dummy_cols, categories) {
    paste0(tab(4), dest_mat, "[", index, ", ", dummy_cols, "] <- ifelse(", dest_mat,
           "[", index, ", ",
           dest_col, "] == ", categories, ", 1, 0)")
  }, dummy_cols, categories)
}

paste_interactions <- function(interactions, N, Ntot) {

  interactions <- interactions[sapply(interactions, "attr", "has_NAs")]

  interlong <- sapply(interactions, function(x)
    any(names(unlist(unname(x))) %in% 'Ml'))

  paste0(
    if (any(interlong)) {
      paste0(
        tab(),
        "for (j in 1:", Ntot, ") {\n",
        paste0(
          sapply(interactions[interlong], function(x) {
            paste0(tab(4),
                   paste_data(names(x$interterm), index = "j", col = x$interterm),
                   " <- ",
                   paste0(paste_data(names(x$elmts),
                                     index = ifelse(names(x$elmts) == 'Ml', 'j', 'group[j]'),
                                     x$elmts), collapse = " * ")
            )
          }), collapse = "\n"),
        "\n", tab(), "}\n")
    },
    if (any(!interlong)) {
      paste0(tab(),
             "for (i in 1:", N, ") {\n",
             paste0(
               sapply(interactions[!interlong], function(x) {
                 paste0(tab(4),
                        paste_data(names(x$interterm), index = "i", x$interterm),
                        " <- ",
                        paste0(paste_data(names(x$elmts), index = "i", x$elmts),
                               collapse = " * ")
                 )
               }), collapse = "\n"),
             "\n", tab(), "}\n")
    }
  )
}

paste_trafos <- function(Mlist, varname, index, isgk = FALSE) {

  trafos <- if (isgk) Mlist$fcts_all else Mlist$trafos

  if (!any(trafos$var %in% varname))
    return(NULL)

  trafolist <- sapply(which(trafos$var == varname), function(i) {
    x <- trafos[i, , drop = FALSE]

    if (!x$dupl) {
      dest_mat <- if (x$colname %in% colnames(Mlist$Mc)) 'Mc' else 'Ml'
      dest_col <- match(x$colname, colnames(Mlist[[dest_mat]]))

      if (!is.na(x$dupl_rows)) {
        xx <- trafos[c(i, unlist(x$dupl_rows)), ]
      } else {
        xx <- x
      }
      vars <- xx$var
      vars_mat <- ifelse(xx$var%in% colnames(Mlist$Mc), 'Mc', 'Ml')
      vars_cols <- sapply(seq_along(vars), function(k)
        match(xx$var[k], colnames(Mlist[[vars_mat[k]]]))
      )

      fct <- x$fct
      if (x$type == "I") {
        fct <- gsub("\\)$", "", gsub("^I\\(", "", fct))
      }

      for (k in seq_along(vars)) {

        if (any(vars_mat %in% "Ml") & vars_mat[k] %in% "Mc" & !isgk) {
          theindex <- paste0("group[", index, "]")
        } else {
          theindex <- index
        }

        fct <- if (vars_mat[k] %in% "Ml" & isgk) {
          gsub(paste0('\\b', vars[k], '\\b'),
                    paste0(vars_mat[k], "gk[", theindex, ", ",
                           vars_cols[k], ", k]"), fct)
        } else {
          gsub(paste0('\\b', vars[k], '\\b'),
               paste0(vars_mat[k], "[", theindex, ", ",
                      vars_cols[k], "]"), fct)
        }
      }

      paste0('\n\n', tab(4),
             dest_mat, if (isgk) "gk", "[", index, ", ", dest_col,
             if (isgk) ", k", "] <- ", fct, '\n')
    }
  })

  Filter(Negate(is.null), trafolist)
}


# specifications for GLMs (and GLMMs) ------------------------------------------
# * distribution ---------------------------------------------------------------
get_distr <- function(family, varname, index, isgk = FALSE) {
  if (is.null(family))
    return(NULL)

  switch(family,
         "gaussian" = paste0("dnorm(mu", if(isgk) "gk", "_", varname,
                             "[", index, if(isgk) ", k", "], tau_", varname, ")"),
         "binomial" = paste0("dbern(max(1e-16, min(1 - 1e-16, mu",
                             if(isgk) "gk", "_", varname,
                             "[", index, if(isgk) ", k", "])))"),
         "Gamma" = paste0("dgamma(shape", if(isgk) "gk", "_", varname,
                          "[", index, if(isgk) ", k", "], rate", if(isgk) "gk", "_",
                          varname, "[", index, if(isgk) ", k", "])"),
         "poisson" = paste0("dpois(max(1e-10, mu", if(isgk) "gk", "_", varname,
                            "[", index, if(isgk) ", k", "]))"),
         "lognorm" = paste0("dlnorm(mu", if(isgk) "gk", "_", varname, "[",
                            index, if(isgk) ", k", "], tau_", varname, ")"),
         "beta" = paste0("dbeta(shape1", if(isgk) "gk", "_", varname,
                         "[", index, if(isgk) ", k", "], shape2", if(isgk) "gk",
                         "_", varname, "[", index, if(isgk) ", k", "])T(1e-15, 1 - 1e-15)")
  )
}

# * link -----------------------------------------------------------------------
get_linkfun <- function(link) {
  if (is.null(link))
    return(NULL)

  switch(link,
         "identity" = function(x) x,
         "logit"    = function(x) paste0("logit(", x, ")"),
         "probit"   = function(x) paste0("probit(", x, ")"),
         "log"      = function(x) paste0("log(", x, ")"),
         "cloglog"  = function(x) paste0("cloglog(", x, ")"),
         # "sqrt": JAGS does not know this link function
         # "cauchit is not available in JAGS
         "inverse"  = function(x)
           paste0(x, " <- 1/max(1e-10, inv_", x, ")", "\n",
                  tab(4), "inv_", x)
  )
}

# * reparametrization ----------------------------------------------------------
get_repar <- function(family, varname, index, isgk = FALSE) {
  if (is.null(family))
    return(NULL)

  switch(family,
         "gaussian" = NULL,
         "binomial" = NULL,
         "Gamma" = paste0(tab(4), "shape", if (isgk) "gk", "_", varname,
                          "[", index, if (isgk) ", k", "] <- pow(mu",
                          if (isgk) "gk", "_", varname, "[", index,
                          if (isgk) ", k", "], 2) / pow(sigma_", varname, ", 2)",
                          "\n",
                          tab(4), "rate", if (isgk) "gk", "_", varname,
                          "[", index, if (isgk) ", k", "] <- mu",
                          if (isgk) "gk", "_", varname, "[", index,
                          if (isgk) ", k", "] / pow(sigma_", varname, ", 2)", "\n"),
         "Poisson" = NULL,
         'lognorm' = NULL,
         'beta' = paste0(tab(4), "shape1", if (isgk) "gk", "_", varname,
                         "[", index, if (isgk) ", k", "] <- mu",
                         if (isgk) "gk", "_", varname, "[", index,
                         if (isgk) ", k", "] * tau_",
                         varname, "\n",
                         tab(4), "shape2", if (isgk) "gk", "_", varname,
                         "[", index, if (isgk) ", k", "] <- (1 - mu", if (isgk) "gk", "_",
                         varname, "[", index, if (isgk) ", k", "]) * tau_", varname, "\n")
  )
}

# * prior for a second parameter -----------------------------------------------
get_secndpar <- function(family, varname) {
  if (is.null(family))
    return(NULL)

  switch(family,
         "gaussian" = paste0("\n",
                             tab(), "tau_", varname ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
                             tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")"),
         "binomial" = NULL,
         "Gamma" = paste0("\n",
                          tab(), "tau_", varname ," ~ dgamma(shape_tau_gamma, rate_tau_gamma)", "\n",
                          tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")"),
         "poisson" = NULL,
         "lognorm" = paste0("\n",
                            tab(), "tau_", varname ," ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
                            tab(), "sigma_", varname," <- sqrt(1/tau_", varname, ")"),
         "beta" = paste0("\n",
                         tab(), "tau_", varname, " ~ dgamma(shape_tau_beta, rate_tau_beta)", "\n")
  )
}



get_GLM_modelname <- function(family) {
  if (is.null(family))
    return(NULL)

  switch(family,
         "gaussian" = 'Normal',
         "binomial" = 'Binomial',
         "Gamma" = 'Gamma',
         "poisson" = 'Poisson',
         "lognorm" = 'Log-normal',
         "beta" = 'Beta'
  )
}


get_linkindent <- function(link) {
  if (is.null(link)) 0
  else
    switch(link,
           identity = 0,
           logit = 7,
           probit = 8,
           log = 5,
           cloglog = 9,
           inverse = 4)
}



# * shrinkage ------------------------------------------------------------------
get_priordistr <- function(shrinkage, family, link, parname) {
  priorset <- switch(family,
                     gaussian = 'norm',
                     binomial = link,
                     Gamma = 'gamma',
                     poisson = 'poisson',
                     lognorm = 'norm',
                     beta = 'beta'
  )

  if (is.null(shrinkage)) {
    paste0(tab(4), parname, "[k] ~ dnorm(mu_reg_", priorset,
           ", tau_reg_", priorset, ")", "\n")
  } else if (shrinkage == 'ridge') {
    paste0(tab(4), parname, "[k] ~ dnorm(mu_reg_", priorset,
           ", tau_reg_", priorset , "_ridge[k])", "\n",
           tab(4), "tau_reg_", priorset, "_ridge[k] ~ dgamma(0.01, 0.01)", "\n")
  } else {
    stop(gettextf('Regularization of type %s is not implemented.', dQuote(shrinkage)),
         call. = FALSE)
  }
}

