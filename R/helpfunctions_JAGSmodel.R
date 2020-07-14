# help functions ---------------------------------------------------------------
tab <- function(times = 2) {
  # creates a vector of spaces to facilitate indentation

  tb <- " "
  paste(rep(tb, times), collapse = "")
}


add_dashes <- function(x, width = 95) {
  # add separation lines between sub-models in JAGS model for readability
  # - x: name of the sub-model

  paste(x, paste0(rep('-', 80 - nchar(x)), collapse = ''))
}


add_linebreaks <- function(string, indent, width = 90) {
  # add linebreaks to a string, breaking it after a "+" sign
  # - string: the linear predictor string to be broken
  # - indent: in case of a linebreak, how much should the new line be indented?
  # - width: output width

  if (is.null(string)) {
    return(NULL)
  }

  # identify position of "+"
  m <- gregexpr(" \\+ ", string)[[1]]

  # if there is no "+", return the original string
  if (all(m < 0)) {
    return(string)
  }

  # calculate the lengths of the sub-strings
  len <- c(as.numeric(m)[1], diff(c(as.numeric(m), nchar(string))))


  # check how many sub-strings (and the indent) can be combined until reaching
  # the maximal width, and create a string of ' + ' (no break) and
  # ' +\n' (break) to be pasted in afterwards
  # (there is probably a more elegant way to do this)
  i <- 1
  br <- c()
  while (i < length(len)) {
    cs <- cumsum(len[i:length(len)])
    nfit <- max(1, which(cs <= (width - indent)))
    br <- c(
      br, rep(" + ", nfit - 1),
      if ((i + nfit - 1) < length(len)) paste0(" +\n", tab(indent))
    )
    i <- i + nfit
  }

  paste0(strsplit(string, " \\+ ")[[1]], c(br, ""), collapse = "")
}



# linear predictors ------------------------------------------------------------
paste_linpred <- function(parname, parelmts, matnam, index, cols, scale_pars,
                          isgk = FALSE) {
  # paste a regular linear predictor
  # - parname: name of the parameter, e.g. "beta"
  # - parelmts: vector specifying which elements of the parameter vector are
  #             to be used, e.g. c(1,2,3,6,8,4)
  # - matnam: name of the design matrix, e.g. "M_lvlone" or "M_ID"
  # - index: character sting specifying the index to be used, e.g. "i" or "ii"
  # - cols: index of the columns of the design matrix to be used,
  #         e.g. c(1, 4, 2, 10)
  # - scale_pars: a matrix with row names according to the columns of the
  #               design matrix and columns 'center' and 'scale'.
  #               Contains NA if a variable should not be scaled
  #               (could also be NULL instead of a matrix)
  # - isgk: logical indicator of this is for within the Gauss-Kronrod quadrature

  paste(
    paste_scaling(x = paste_data(matnam, index, cols, isgk),
                  rows = cols,
                  scale_pars = scale_pars,
                  scalemat = paste0('sp', matnam)
    ),
    paste_coef(parname, parelmts),
    sep = " * ", collapse = " + ")
}

# * linpred help functions -----------------------------------------------------
paste_data <- function(matnam, index, col, isgk = FALSE) {
  # create a (vector of) data element(s) of a linear predictor, e.g. "X[i, 3]"
  # if isgk = TRUE, the suffix "gk" will be added to "matname"
  # - matnam: the name of the design matrix
  # - index: the index to be used, e.g. "i" or "ii"
  # - col: the column (or vector of columns) of the design matrix
  # - isgk: is this whithin the Gauss-Kronrod quadrature?

  paste0(matnam, ifelse(isgk, "gk", ''), "[", index, ", ", col,
         ifelse(isgk, ", k]", "]"))
}


paste_coef <- function(parname, parelmts) {
  # create a (vector of) coefficient element(s) of a linear predictor,
  # e.g. beta[3]
  # - parname: the name of the parameter, e.g. "alpha" or "beta"
  # - parelmts: vector of integers giving the elements of the parameter to be
  #             used

  paste0(parname, '[', parelmts, ']')
}


paste_scaling <- function(x, rows, scale_pars, scalemat) {
  # identify if a data element of a linear predictor should be scaled (based
  # on whether scaling parameters are given) and obtain the scaling trafo
  # string
  # - x: vector of expressions to scale
  # - row: the row number(s) of the matrix containing the scaling parameters
  # - scale_pars: scaling matrix
  # - scalemat: name of the scaling matrix in JAGS, e.g. "spM_ID"

  if (is.null(scale_pars)) {
    x
  } else {
    ifelse(rowSums(is.na(scale_pars[rows, ])) > 0,
           x,
           paste_scale(x, row = rows, scalemat = scalemat)
    )
  }
}


paste_scale <- function(x, row, scalemat) {
  # create a (vector of) scaling transformation(s) for the data element(s) of a
  # linear predictor
  # - x: term that will be scaled (or vector of terms)
  # - row: the row number(s) of the matrix containing the scaling parameters
  # - scalemat: the name of the matrix containing the scaling parameters,
  #             e.g. "spM_lvlone" or "spM_ID"
  #             The matrix is assumed to have columns "center" and "scale".

  paste0("(", x, " - ", scalemat, "[", row, ", 1])/", scalemat,
         "[", row, ", 2]")
}






# paste rd. effects into JAGSmodel ---------------------------------------------

# used in JAGSmodels that use random effects (2020-06-10)
paste_rdslope_lp <- function(info, isgk = FALSE) {
  # Create a list of lists containing the linear predictors of the random
  # effects (slopes + interactions with slopes, no random intercept here).
  # The list has an element per grouping level, which contains a list per
  # variable for which a random slope is specified.
  # - info: element of info_list, containing all the info necessary to write
  #         the JAGS sub-model for a given variable

  # if there are no random effects in this model (hc_list is NULL), return NULL
  if (is.null(info$hc_list)) return(NULL)


  # for each of the grouping levels for which there are random effects do:
  sapply(names(info$hc_list$hcvars), function(lvl) {

    # name of the corresponding data matrix
    mat <- paste0("M_", lvl)

    # identify variables for which a random slope needs to be specified on the
    # current grouping level and variables which have an interaction with one
    # of these random slope variables
    rds <- info$hc_list$hcvars[[lvl]]$rd_slope_coefs
    rdsi <- info$hc_list$hcvars[[lvl]]$rd_slope_interact_coefs


    sapply(unique(names(rds), names(rdsi)), function(x) {

      rds_rdsi_vec <- c(
        # random slope coefficients (if rds[[x]] == NULL there are no random
        # slope coefficients on this level)
        if (!is.null(rds[[x]])) {
          # If there are no coefficients (= no fixed effect, only random
          # effect), the mean of the random effect is 0, otherwise it is a
          # linear predictor
          if (!all(is.na(rds[[x]]$parelmts))) {
            paste_coef(parname = info$parname,
                       parelmts = rds[[x]]$parelmts)
          } else {
            '0'
          }
        },

        # interactions with random slope (if rdsi[[x]] == NULL there are no
        # variables that have an interaction with a random slope variable)
        if (!is.null(rdsi[[x]])) {
          if (!all(is.na(rdsi[[x]]$parelmts))) {
            # write the product from the scaled data part and the corresponding
            # regression coefficients
            paste(
              paste_scaling(x = paste_data(matnam = rdsi[[x]]$matrix,
                                           index = info$index[lvl],
                                           col = rdsi[[x]]$cols, isgk),
                            rows = rdsi[[x]]$cols,
                            scale_pars = info$scale_pars[[mat]],
                            scalemat = paste0('sp', mat)
              ),
              paste_coef(parname = info$parname,
                         parelmts = rdsi[[x]]$parelmts),
              sep = " * ")
          }
        }
      )

      # combine the random slope and random slope interaction part into a
      # linear predictor
      paste(rds_rdsi_vec, collapse = " + ")

    }, simplify = FALSE)
  }, simplify = FALSE)
}


# used in JAGSmodels that use random effects (2020-06-10)
paste_rdintercept_lp <- function(info) {
  # returns a list with an element per grouping level, containing the linear
  # predictor (or 0) which is the mean of the random intercept distribution
  # - info: element of info_list, containing all the info necessary to write
  #         the JAGS sub-model for a given variable

  # if there are no random effects in this model (hc_list = NULL), return NULL
  if (is.null(info$hc_list)) return(NULL)

  # for each of the grouping levels for which there are random effects do:
  sapply(names(info$hc_list$hcvars), function(lvl) {

    # name of the corresponding data matrix
    mat <- paste0("M_", lvl)

    # identify variables that should be part of the linear predictor for the
    # random intercept on this level
    x <- info$hc_list$hcvars[[lvl]]$rd_intercept_coefs

    # if there are parameter elements in this linear predictor, create a
    # linear predictor, otherwise the mean of the random effect distribution
    # should be 0
    if (length(x$parelmts) > 0) {
      paste_linpred(parname = info$parname,
                    parelmts = x$parelmts,
                    matnam = unique(x$mat),
                    index = info$index[lvl],
                    cols = x$cols,
                    scale_pars = info$scale_pars[[mat]],
                    isgk = FALSE)
    } else if (attr(info$hc_list$hcvars[[lvl]], 'rd_intercept')) {
      "0"
    } else {
      NULL
    }
  }, simplify = FALSE)
}



paste_lp_Zpart <- function(info, isgk = FALSE) {
  # write the random effects part of the linear predictor of the analysis
  # model
  # - info: element of info_list, containing all the info necessary to write
  #         the JAGS sub-model for a given variable
  # - isgk: logical indicator whether the output is in the Gauss-Kronrod
  #         quadrature


  # if there are no random effects (hc_list = NULL), return NULL
  if (is.null(info$hc_list)) return(NULL)


  # identify grouping level of the outcome
  resplvl <- gsub("M_", "", info$resp_mat[length(info$resp_mat)])


  # for all grouping levels above or equal to the outcome level do:
  Zlp <- sapply(
    names(info$group_lvls)[info$group_lvls >= info$group_lvls[resplvl]],
    function(lvl) {
      # find the correct specification of the index. This depends on the level
      # of the outcome, but also on the current grouping level, whether the
      # outcome is on the lowest level (lvlone) or not, and if the output is
      # used in the GK-quadrature
      index <- get_index(lvl, resplvl, indices = info$index,
                         surv_lvl = info$surv_lvl, isgk = isgk)


      # generate the random intercept part to enter the linear predictor of
      # the outcome.
      rdi <- if (isTRUE(attr(info$hc_list$hcvars[[lvl]], "rd_intercept"))) {
        paste_data(matnam = paste0("b_", info$varname, "_", lvl),
                   index = index,
                   col = 1)
      }

      # generate the random slope part to enter the linear predictor of
      # the outcome
      rds <- get_rds(info$hc_list$hcvars[[lvl]]$rd_slope_coefs,
                     lvl = lvl,
                     varname = info$varname,
                     index = index,
                     out_index = if (!isgk) info$index[[resplvl]] else index,
                     has_rdintercept = attr(info$hc_list$hcvars[[lvl]],
                                            'rd_intercept'),
                     scale_pars = info$scale_pars,
                     isgk = isgk)


      # write the syntax for other longitudinal variables
      other <- if (!is.null(info$hc_list$othervars[[lvl]])) {
          paste_other(othervars = info$hc_list$othervars[[lvl]],
                      parname = info$parname, index = index,
                      scale_pars = info$scale_pars[[paste0("M_", lvl)]],
                      scale_mat = paste0("spM_", lvl), isgk = isgk)
      }

      # combine random intercept and slope
      rdis <- if (any(!is.null(rdi), !is.null(rds))) {
        paste0(unlist(Filter(Negate(is.null),
                             list(rdi = rdi, rds = rds))),
               collapse = ' + ')
      }

      Filter(Negate(is.null),
             list(rdis = rdis, other = other)
      )
    }, simplify = FALSE)

  if (any(!sapply(Zlp, is.null))) {
    apply(as.data.frame(unlist(Zlp, recursive = FALSE)),
          1, paste0, collapse = " + ")
  } else {
    "0"
  }
}



write_nonprop <- function(info, isgk = FALSE) {
  # if there are no random effects (hc_list = NULL), return NULL
  if (is.null(info$hc_list)) return(NULL)

  # identify grouping level of the outcome
  resplvl <- gsub("M_", "", info$resp_mat[length(info$resp_mat)])


  # for all grouping levels above or equal to the outcome level do:
  nonprop <- sapply(
    names(info$group_lvls)[info$group_lvls >= info$group_lvls[resplvl]],
    function(lvl) {
      # find the correct specification of the index. This depends on the level
      # of the outcome, but also on the current grouping level, whether the
      # outcome is on the lowest level (lvlone) or not, and if the output is
      # used in the GK-quadrature
      index <- get_index(lvl, resplvl, indices = info$index,
                         surv_lvl = info$surv_lvl, isgk = isgk)


      if (!is.null(info$hc_list$nonprop[[lvl]])) {
        paste_other(othervars = info$hc_list$nonprop[[lvl]],
                    parname = info$parname, index = index,
                    scale_pars = info$scale_pars[[paste0("M_", lvl)]],
                    scale_mat = paste0("spM_", lvl), isgk = isgk)
      }
  }, simplify = FALSE)


  apply(as.data.frame(nonprop), 1, paste0, collapse = " + ")
}


get_index <- function(lvl, resplvl, indices, surv_lvl, isgk = FALSE) {
  # Find the correct specification of the index. This depends on the level of
  # the response of the sub-model (resplvl), but also on the current grouping
  # level (lvl), whether the response is on the lowest level (lvlone) or not,
  # and if the output is used in the GK-quadrature.
  # - lvl: the current level
  # - resplvl: level of the response variable
  # - indices: vector of indices per level
  # - surv_lvl: level of the survival outcome; relevant for a survival model
  #             with time-dependent covariate
  # - isgk: is the output used within the Gauss-Kronrod quadrature?

  if (!isgk & resplvl == 'lvlone') {
    # if the outcome is the lowest level and not in GK, use
    # - the index of the outcome level if the random effect is on the same
    #   level
    # - the element of "group" of the random effects level at the index
    #   position if the random effect is on a higher level
    if (lvl == resplvl) {
      indices[resplvl]
    } else {
      paste0('group_', lvl, "[", indices[resplvl], "]")
    }
  } else if (!isgk & lvl == resplvl) {
    # if the outcome is not on the lowest level, but the  random effect has
    # the same level as the outcome and we're not in the quadrature part,
    # use the index of the outcome level
    indices[[resplvl]]
  } else if (!isgk) {
    # if the outcome is not on the lowest level and the random effect is on
    # a different level, and we're not in the quadrature part, use group
    # (relating rd. effect level to lvlone), indexed by the position of
    # the outcome level (position in lvlone that corresponds to the
    # current index value)
    paste0('group_', lvl, "[",
           "pos_", resplvl, "[", indices[resplvl], "]]")
  } else if (isgk & (lvl == surv_lvl | lvl == 'lvlone')) {
    # if we are in the quadrature part, and the random effects
    # level is either the same as the outcome level or the lowest
    # level, use the index of the level of the survival outcome
    indices[surv_lvl]
  } else if (isgk) {
    # if we are in the quadrature part and the random effects level is not
    # the same as the outcome level and not the lowest level, use group and
    # pos to relate the level of the survival outcome and the level of the
    # random effect, via lvlone
    paste0('group_', lvl, "[",
           "pos_", surv_lvl, "[", indices[surv_lvl], "]]")
  }
}



get_rds <- function(rd_slope_coefs, lvl, varname, index, out_index,
                    has_rdintercept = TRUE,
                    scale_pars, isgk = FALSE) {
  if (any(!sapply(rd_slope_coefs, is.null))) {
    # if there are any random slope variables for this random effect level,
    # do:
    sapply(seq_along(rd_slope_coefs), function(q) {

      rdsc <- rd_slope_coefs[[q]]

      # write the multiplication of the random slope with the corresponding
      # longitudinal variable ("b[i, 2] * M[i, 4]")
      paste(
        paste_data(matnam = paste0("b_", varname, "_", lvl),
                   index = index,
                   col = q + has_rdintercept),

        paste_scaling(
          paste_data(
            matnam = rdsc$matrix,
            index = out_index,
            col = rdsc$cols, isgk = isgk),
          rows = rdsc$cols,
          scale_pars = scale_pars[[unique(rdsc$matrix)]],
          scalemat = paste0("sp", unique(rdsc$matrix))),
        sep = ' * ')
    })
  }
}


# used in write_nonprop() (2020-07-09)
paste_other <- function(othervars, parname, index, scale_pars, scale_mat,
                        isgk = FALSE) {
  # write the syntax for other longitudinal variables
  #
  if (!is.data.frame(othervars)) {
    sapply(othervars, paste_o,
           parname = parname, index = index, scale_pars = scale_pars,
           scale_mat = scale_mat, isgk = isgk)
  } else {
    paste_o(othervars,
            parname = parname, index = index, scale_pars = scale_pars,
            scale_mat = scale_mat, isgk = isgk)
  }
}




# used in paste_other() (2020-07-09)
paste_o <- function(x, parname, index, scale_pars, scale_mat, isgk = FALSE) {
  # -x: a matrix with columns 'term', 'matrix', 'cols', 'parelmts',
  # - parname: characters string, e.g. "beta"
  # - index: character string, e.g., "i"
  # - scale_pars: a matrix of scaling parameters
  # - scale_mat: character string with the name of the scaling matrix that will
  #             be passed to JAGS
  # - isgk: logical: is the output being used inside the Gauss-Kronrod
  #         quadrature

  paste0(
    paste(
      paste_coef(parname = parname, parelmts = x$parelmts),
      paste_scaling(
        paste_data(matnam = x$matrix,
                   index = index,
                   col = x$cols,
                   isgk = isgk),
        rows = x$cols,
        scale_pars = scale_pars,
        scalemat = scale_mat),
      sep = " * " ),
    collapse = " + ")
}




# used in JAGSmodels that use random effects (2020-06-10)
write_ranefs <- function(lvl, info, rdintercept, rdslopes) {
  # This function writes the JAGSmodel part for the random effects
  # distribution (b ~ N(..., ...))
  # - lvl: the grouping level for the random effects
  # - info: element of info_list, containing all necessary information to
  #         write a JAGS sub-model for a given variable
  # - rdintercept: list of random intercept linear predictors as strings
  # - rdslopes: list of list of random slope linear predictors as strings

  # specify distribution for the random effects, based on their dimension
  norm.distr  <- if (info$nranef[lvl] < 2) {"dnorm"} else {"dmnorm"}

  # write the model part for the random effects distribution
  paste0(
    tab(), "for (", info$index[lvl], " in 1:", info$N[lvl], ") {", "\n",

    # distribution specification
    tab(4), "b_", info$varname, "_", lvl, "[", info$index[lvl], ", 1:",
    info$nranef[lvl], "] ~ ", norm.distr,
    "(mu_b_", info$varname, "_", lvl, "[", info$index[lvl], ", ], invD_",
    info$varname, "_", lvl, "[ , ])", "\n",

    # specification of the means structure of the random effects
    paste_mu_b(rdintercept[[lvl]], rdslopes[[lvl]],
               paste(info$varname, lvl, sep = "_"), info$index[lvl]),
    "\n",
    tab(), "}", "\n\n")
}


# used in write_ranefs() (2020-06-10)
paste_mu_b <- function(rdintercept, rdslopes, varname, index) {
  # write the mean structure of the random effects specification, i.e.
  # mu_b[i, 1] <- ...
  # mu_b[i, 2] <- ... etc.

  # - rdintercept: string of random intercept linear predictor (one string)
  # - rdslopes: list of random slope linear predictors (as strings)
  # - varname: name of the outcome variable of the current sub-model
  # - index: character string of the index, e.g. "i"

  # paste the random intercept part "mu_b_varname[i, 1] <- lin.predictor"
  #
  # The linear predictor part is indented by
  # - 4 general indent because inside for-loop
  # - 5 "mu_b_"
  # - the number of characters of the variable name
  # - 1 underscore
  # - the number of characters of the index
  # - 8 ", 1] <- "
  rdi <- if (length(rdintercept) > 0)
    paste0(tab(4),
           paste_data(matnam = paste0("mu_b_", varname), index = index,
                      col = 1),
           " <- ",
           add_linebreaks(rdintercept,
                          indent = 4 + 5 + nchar(varname) + 1 +
                            nchar(index) + 8)
    )

  # paste the rd. slope part, a vector of "mu_b_varname[i, k] <- lin.predictor"
  # or NULL if there are no random slopes
  #
  # The linear predictor part is indented by
  # - 4 general indent because inside for-loop
  # - 5 "mu_b_"
  # - the number of characters of the variable name
  # - 1 underscore
  # - the number of characters of the index
  # - 8 ", 1] <- "
  rds <- if (length(rdslopes) > 0) {
    paste0(
      tab(4),
      paste_data(matnam = paste0("mu_b_", varname), index = index,
                 col = seq_along(rdslopes) + as.numeric(length(rdi) > 0)),
      " <- ",
      sapply(rdslopes, add_linebreaks,
             indent = 4 + 5 + nchar(varname) + 1 + nchar(index) + 8)
    )
  }

  # combine the random intercept and random slope part
  paste0(c(rdi, rds), collapse = "\n")
}



# used in JAGSmodels that use random effects (2020-06-10)
ranef_priors <- function(nranef, varname) {
  # write prior distribution part for random effects variance parameters
  # - nranef: number/dimension of the random effects
  # - varname: name of the outcome of the sub-model


  # based on number of random effects, use Gamma or Wishart distribution
  # (Truncation in Gamma to prevent JAGS error when values get too small or
  # too large)
  invD_distr <- if (nranef == 1) {
    "dgamma(shape_diag_RinvD, rate_diag_RinvD)T(1e-16, 1e16)"
  } else {
    paste0("dwish(RinvD_", varname, "[ , ], KinvD_", varname, ")")
  }


  paste0("\n",
         if (nranef > 1) {
           paste0(
             tab(), "for (k in 1:", nranef, ") {", "\n",
             tab(4), "RinvD_", varname,
             "[k, k] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)", "\n",
             tab(), "}", "\n")
         },
         tab(), "invD_", varname, "[1:", nranef, ", 1:", nranef,"] ~ ",
         invD_distr, "\n",
         tab(), "D_", varname, "[1:", nranef,", 1:", nranef,
         "] <- inverse(invD_", varname, "[ , ])"
  )
}


# Joint model ------------------------------------------------------------------

paste_linpred_JM <- function(varname, parname, parelmts, matnam, index, cols,
                             scale_pars, assoc_type, covnames, isgk = FALSE) {
  # - varname: name of the survival outcome
  # - parname: name of the parameter, e.g. "beta"
  # - parelmts: vector specifying which elements of the parameter vector are
  #             to be used, e.g. c(1,2,3,6,8,4)
  # - matnam: name or the design matrix, e.g. "M_lvlone
  # - index: character sting specifying the index to be used, e.g. "i" or "j"
  # - cols: index of the columns of the design matrix to be used,
  #         e.g. c(1, 4, 2, 10)
  # - scale_pars: a matrix with rownames according to the columns of the design
  #               matrix and columns 'center' and 'scale'.
  #               Contains NA if a variable should not be scaled (could also be
  #               NULL instead of a matrix)
  # - assoc_type: vector of association types to be used for the time_varying
  #               covariates
  # - covnames: names of the time-varying covariates
  # - isgk: logical; indicating if the output is used inside the GK-quadrature
  #         part


  # get vector of association structure strings
  pastedat <- paste_association(varname = varname,
                                covnames = covnames, matname = matnam,
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


# used in paste_linpred_JM() (2020-06-10)
paste_association <- function(varname, covnames, matname, index, columns,
                              assoc_type, isgk) {

  # for each time-varying variable, paste the association structure
  # - varname: name of the survival outcome
  # - covnames: vector of names of the time-varying covariates
  # - matname: vector of names of the design matrix containing the time-varying
  #            covariate
  # - index: string specifying the index to be used, e.g. "i",
  # - columns: column numbers of the time-varying covariates in the design
  #            matrix
  # - assoc_type: vector of association types
  # - isgk: logical: is the output for within the quadrature part?

  mapply(function(varname, assoc_type, covname, matname, column, index, isgk) {
    paste_assoc <- switch(assoc_type,
                          "obs.value" = paste_obsvalue,
                          "underl.value" = paste_underlvalue)
    paste_assoc(varname = varname,
                covname = covname,
                matname = matname,
                index = index,
                column = column,
                isgk = isgk)
  }, varname = varname, assoc_type = assoc_type, covname = covnames,
  matname = matname, column = columns,
  MoreArgs = list(index = index, isgk = isgk)
  )
}


# used in paste_association() (2020-06-10)
paste_obsvalue <- function(varname, matname, index, column, isgk, ...) {
  # create the string referring to the observed value of a time-varying
  # variable in the linear predictor of the survival model
  # - varname: name of the survival outcome
  # - matname: name of the design matrix containing the time-varying covariate
  # - index: string specifying the index to be used, e.g. "i",
  # - column: column number of the time-varying covariate in the design matrix,
  # - isgk: logical: is the output for within the quadrature part?
  # - ...: for compatibility of syntax with other association structure type
  #        functions

  if (isgk) # "M_lvlonegk[i, 4, k]" in the GK-quadrature
    paste0(matname, "gk[", index, ", ", column, ", k]")
  else # "M_lvlone[srow_varname[i, k]" outside the quadrature
    paste0(matname, "[srow_", varname, "[", index, "], ", column, "]")
}


# used in paste_association() (2020-06-10)
paste_underlvalue <- function(varname, covname, index, isgk, ...) {
  # create the string referring to the underlying value of a time-varying
  # variable in the linear predictor of the survival model
  # - varname: name of the survival outcome
  # - covname: name of the time-varying covariates
  # - index: string specifying the index to be used, e.g. "i",
  # - isgk: logical: is the output for within the quadrature part?
  # - ...: for compatibility of syntax with other association structure type
  #        functions

  if (isgk) # "mugk_covname[i, k]"
    paste0("mugk_", covname, "[", index, ", k]")
  else # "mu_covname[srow_varname[i]]"
    paste0('mu_', covname, "[srow_", varname, "[", index, "]]")
}







# paste other model parts ------------------------------------------------------

# used in JAGSmodels with categorical outcomes (2020-06-16)
paste_dummies <- function(resp_mat, resp_col, dummy_cols, index, refs, ...) {
  # write the syntax assigning values to the dummies based on the values of a
  # categorical variable
  # - resp_mat: name of the design matrix containing the variable and dummies
  # - resp_col: column number of the categorical variable
  # - dummy_cols: column numbers of the dummy variables
  # - index: the index to be used, e.g. "i" or "ii"
  # - refs: reference level information (including contrasts matrix) obtained
  #         originally from Mlist$refs

  cmat <- attr(refs, "contr_matrix")
  categories <- seq_along(levels(refs)) - as.numeric(length(levels(refs)) == 2)

  paste0(tab(4), resp_mat, "[", index, ", ", dummy_cols, "] <- ifelse(",
         resp_mat, "[", index, ", ", resp_col, "] == ",
         categories[apply(cmat == 1, 2, which)], ", 1",
         if (attr(refs, 'contrasts') == 'contr.treatment') {
           ", 0)"
         } else if (attr(refs, 'contrasts') == 'contr.sum') {
           paste0(", ifelse(", resp_mat, "[", index, ", ", resp_col, "] == ",
                  refs, ", -1, 0))")
         } else {
           errormsg("It is currently not possible to use contrasts of type
                      %s for incomplete variables.",
                    dQuote(attr(refs, 'contrasts')))
         })
}





# used in write_model() (2020-06-11)
paste_interactions <- function(interactions, group_lvls, N) {
  #
  # - interactions: list with interaction information (names of matrices and
  #                 column numbers of the  interaction term and the elements
  #                 of the interaction, and the info if missing values are
  #                 infolved; obtained from Mlist)
  # - group_lvls: vector of order of the grouping levels
  # - N: vector of the number of observations per grouping level


  # determine which index should be used for each of the levels
  index <- setNames(sapply(seq_along(sort(group_lvls)),
                           function(k) paste0(rep('i', k), collapse = '')),
                    names(sort(group_lvls)))

  # select only those interactions in which incomplete variables are involved
  interactions <- interactions[sapply(interactions, "attr", "has_NAs")]

  # determine the minimal level for each interaction (this is the level on
  # which the interaction has to be calculated; observations from higher level
  # variables are then repeated to obtain a fitting vector)
  minlvl <- sapply(interactions, function(x) {
    lvls <- gsub("M_", "", unique(names(unlist(unname(x)))))
    lvls[which.min(group_lvls[lvls])]
  })

  paste0(
    # for each of the levels on which interactions have to be written:
    sapply(unique(minlvl), function(lvl) {
      paste0(
        tab(),
        "for (", index[lvl], " in 1:", N[lvl], ") {\n",
        paste0(
          sapply(interactions[which(minlvl == lvl)], function(x) {
            paste0(
              tab(4),
              paste_data(names(x$interterm), index = index[lvl],
                         col = x$interterm),
              " <- ",
              paste0(paste_data(
                names(x$elmts),
                index = ifelse(names(x$elmts) == paste0("M_", lvl),
                               index[lvl],
                               paste0(
                                 "group_",
                                 gsub("M_", "", names(x$elmts)),
                                 "[", index[lvl], "]"
                               )
                ),
                x$elmts
              ), collapse = " * ")
            )
          }),
          collapse = "\n"
        ),
        "\n", tab(), "}\n"
      )
    })
  )
}


# used in JAGSmodels (2020-06-11)
get_priordistr <- function(shrinkage, type, family = NULL, link = NULL,
                           parname) {
  # write specification fo the prior distribution for the regression parameters,
  # using the specified type of shrinkage (or no shrinkage)

  if (type %in% c('glm', 'glmm')) {
    type <- switch(family,
                   gaussian = 'norm',
                   binomial = 'binom',
                   Gamma = 'gamma',
                   poisson = 'poisson',
                   lognorm = 'norm',
                   beta = 'beta'
    )
  }


  if (is.null(shrinkage) | isFALSE(shrinkage)) {
    # no shrinkage
    paste0(
      tab(4), parname, "[k] ~ dnorm(mu_reg_", type,
      ", tau_reg_", type, ")", "\n"
    )
  } else if (shrinkage == "ridge") {
    # ridge shrinkage
    paste0(
      tab(4), parname, "[k] ~ dnorm(mu_reg_", type,
      ", tau_reg_", type, "_ridge_", parname, "[k])", "\n",
      tab(4), "tau_reg_", type, "_ridge_", parname, "[k] ~ dgamma(0.01, 0.01)",
      "\n"
    )
  } else {
    errormsg("Regularization of type %s is not implemented.", dQuote(shrinkage))
  }
}



# specifications for GLMs (and GLMMs) ------------------------------------------

# * distribution ---------------------------------------------------------------

# used in JAGSmodel_glm and JAGSmodel_glmm (2020-06-11)
get_distr <- function(family, varname, index, isgk = FALSE) {
  # write the outcome distribution model (right hand side) for a GLM(M)
  # JAGS model

  if (is.null(family))   return(NULL)

  switch(family,
         "gaussian" = paste0(
           "dnorm(mu", if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "], tau_", varname, ")"
         ),
         "binomial" = paste0(
           "dbern(max(1e-16, min(1 - 1e-16, mu",
           if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "])))"
         ),
         "Gamma" = paste0(
           "dgamma(shape", if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "], rate", if (isgk) "gk", "_",
           varname, "[", index, if (isgk) ", k", "])"
         ),
         "poisson" = paste0(
           "dpois(max(1e-10, mu", if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "]))"
         ),
         "lognorm" = paste0(
           "dlnorm(mu", if (isgk) "gk", "_", varname, "[",
           index, if (isgk) ", k", "], tau_", varname, ")"
         ),
         "beta" = paste0(
           "dbeta(shape1", if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "], shape2", if (isgk) "gk",
           "_", varname, "[", index, if (isgk) ", k", "])T(1e-15, 1 - 1e-15)"
         )
  )
}

# * link -----------------------------------------------------------------------

# used in JAGSmodel_glm and JAGSmodel_glmm (2020-06-11)
get_linkfun <- function(link) {
  # write the link function string for a GLM(M) JAGS model

  if (is.null(link)) return(NULL)

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

# * re-parametrization ---------------------------------------------------------

# used in JAGSmodel_glm and JAGSmodel_glmm (2020-06-11)
get_repar <- function(family, varname, index, isgk = FALSE) {
  # write the syntax to calculate the re-parametrization in GLM(M) JAGS model

  if (is.null(family)) return(NULL)

  switch(family,
         "gaussian" = NULL,
         "binomial" = NULL,
         "Gamma" = paste0('\n',
                          tab(4), "shape", if (isgk) "gk", "_", varname,
                          "[", index, if (isgk) ", k", "] <- pow(mu",
                          if (isgk) "gk", "_", varname, "[", index,
                          if (isgk) ", k", "], 2) / pow(sigma_", varname,
                          ", 2)",
                          "\n",
                          tab(4), "rate", if (isgk) "gk", "_", varname,
                          "[", index, if (isgk) ", k", "] <- mu",
                          if (isgk) "gk", "_", varname, "[", index,
                          if (isgk) ", k", "] / pow(sigma_", varname, ", 2)",
                          "\n\n"),
         "poisson" = NULL,
         'lognorm' = NULL,
         "beta" <- paste0(
           "\n",
           tab(4), "shape1", if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "] <- mu",
           if (isgk) "gk", "_", varname, "[", index,
           if (isgk) ", k", "] * tau_",
           varname, "\n",
           tab(4), "shape2", if (isgk) "gk", "_", varname,
           "[", index, if (isgk) ", k", "] <- (1 - mu", if (isgk) "gk", "_",
           varname, "[", index, if (isgk) ", k", "]) * tau_",
           varname, "\n\n"
         )
  )
}

# * prior for a second parameter -----------------------------------------------

# used in JAGSmodel_glm and JAGSmodel_glmm (2020-06-11)
get_secndpar <- function(family, varname) {
  # write syntax for second parameter (typically precision or variance) in
  # GLM(M) JAGS model

  if (is.null(family)) {
    return(NULL)
  }

  switch(family,
    "gaussian" = paste0(
      "\n",
      tab(), "tau_", varname, " ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
      tab(), "sigma_", varname, " <- sqrt(1/tau_", varname, ")"
    ),
    "binomial" = NULL,
    "Gamma" = paste0(
      "\n",
      tab(), "tau_", varname, " ~ dgamma(shape_tau_gamma, rate_tau_gamma)",
      "\n",
      tab(), "sigma_", varname, " <- sqrt(1/tau_", varname, ")"
    ),
    "poisson" = NULL,
    "lognorm" = paste0(
      "\n",
      tab(), "tau_", varname, " ~ dgamma(shape_tau_norm, rate_tau_norm)", "\n",
      tab(), "sigma_", varname, " <- sqrt(1/tau_", varname, ")"
    ),
    "beta" = paste0(
      "\n",
      tab(), "tau_", varname, " ~ dgamma(shape_tau_beta, rate_tau_beta)", "\n"
    )
  )
}


# used in JAGSmodel_glm and JAGSmodel_glmm (2020-06-11)
get_GLM_modelname <- function(family) {
  # obtain model name to be printed in JAGSmodel for GLM(M)

  if (is.null(family)) return(NULL)

  switch(family,
         "gaussian" = 'Normal',
         "binomial" = 'Binomial',
         "Gamma" = 'Gamma',
         "poisson" = 'Poisson',
         "lognorm" = 'Log-normal',
         "beta" = 'Beta'
  )
}


# used in JAGSmodel_glm and JAGSmodel_glmm (2020-06-11)
get_linkindent <- function(link) {
  # get number of characters that lines after a line break in the  linear
  # predictor of a GLM(M) JAGS model should be indented

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


# functions for ordinal models -------------------------------------------------
write_probs <- function(info, index, isgk = FALSE, indent = 4) {
  # syntax for probabilities, using min-max-trick for numeric stability
  # i.e., "p_O2[i, 2] <- psum_O2[i, 2] - psum_O2[i, 1]"

  .info = info
  .index = index
  .isgk = isgk

  probs <- sapply(2:(info$ncat - 1),
                  function(k, .info = info, .index = index, .isgk = isgk) {
                    paste0(tab(indent), paste_p(k), " <- ",
                           minmax(
                             if (isTRUE(.info$rev)) {
                               paste0(paste_ps(k), " - ", paste_ps(k - 1))
                             } else {
                               paste0(paste_ps(k - 1), " - ", paste_ps(k))
                             })
                    )
                  })


  paste0(tab(indent),
         paste_p(1), " <- ",
         if (isTRUE(info$rev)) {
           minmax(paste_ps(1))
         } else {
           paste0("1 - ", minmax(paste0("sum(", paste_p(2:info$ncat), ")")))
         },
         "\n",
         paste(probs, collapse = "\n"), "\n",
         tab(indent), paste_p(info$ncat), " <- ",
         if (isTRUE(info$rev)) {
           paste0("1 - ", minmax(paste0("sum(", paste_p(1:(info$ncat - 1)), ")")
                                 ))
         } else {
           minmax(paste_ps(info$ncat - 1))
         }
  )
}



write_logits <- function(info, index, nonprop = FALSE, isgk = FALSE,
                         indent = 4) {
  # syntax for logits, e.g., "logit(psum_O2[i, 1]) <- gamma_O2[1] + eta_O2[i]"

  logits <- sapply(1:(info$ncat - 1),
                   function(k,
                            .info = info,
                            .index = index,
                            .isgk = isgk) {
                     paste0(tab(indent), "logit(", paste_ps(k),
                            ") <- gamma_", info$varname, "[", k, "]",
                            " + eta_", info$varname,"[", index, "]",
                            if (nonprop) {
                              paste0(" + eta_", info$varname, "_", k,
                                     "[", index, "]")
                            })
                   })

  paste0(logits, collapse = "\n")
}


write_priors_clm <- function(info) {

  deltas <- sapply(1:(info$ncat - 2), function(k) {
    paste0(tab(), "delta_", info$varname, "[", k,
           "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
  })

  sign <- ifelse(isTRUE(info$rev), " + ", " - ")


  gammas <- sapply(1:(info$ncat - 1), function(k) {
    if (k == 1) {
      paste0(tab(), "gamma_", info$varname, "[", k,
             "] ~ dnorm(mu_delta_ordinal, tau_delta_ordinal)")
    } else {
      paste0(tab(), "gamma_", info$varname, "[", k, "] <- gamma_",
             info$varname, "[", k - 1, "]", sign, "exp(delta_", info$varname,
             "[", k - 1, "])")
    }
  })

  paste0(c(deltas, '', gammas), collapse = "\n")
}


# * helpfunctions --------------------------------------------------------------
paste_p <- function(nr, env = parent.frame()) {
  vn = env$.info$varname
  ind = env$.index
  gk = env$.isgk

  if (length(nr) > 1)
    nr <- paste0(min(nr), ":", max(nr))
  paste0("p", if (gk) "gk", "_", vn, "[", ind, ", ", nr, if (gk) ", k", "]")
}

paste_ps <- function(nr, env = parent.frame()) {
  vn = env$.info$varname
  ind = env$.index
  gk = env$.isgk

  paste0("psum", if (gk) "gk", "_", vn, "[", ind, ", ", nr, if (gk) ", k", "]")
}

minmax <- function(x, max = "1-1e-10", min = "1e-10") {
  paste0("max(", min, ", min(", max, ", ", x, "))")
}
