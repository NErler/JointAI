


# input:
# - data
# - varname = k / varname = names(random)
# - Mlist$random
# - lvl = gsub("M_", "", info$resp_mat[length(info$resp_mat)])
# - lvls = Mlist$group_lvls (level relations)
# - parelmts (par elmts) parelmts = info$parelmts
# - Mlist$interactions

# - get random structure or make one if needed
# - find out if variables have random slopes or interactions with rd slope
# - sort parelmts in
#   - goes into rd intercept
#   - goes into rd slope: just beta or beta and data
#   - directly goes into linear predictor ("Z part")


# used in get_model1_info() (2020-06-11)
get_hc_info <- function(varname, resplvl, Mlist, parelmts, lp) {

  # - varname: variable name (unabbreviated form) of the outcome of the current
  #            sub-model
  # - resplvl: level of the response variable of the current sub-model,
  #            i.e., 'lvlone'
  # - Mlist: list of design matrices etc. (obtained from divide_matrices())
  # - parelmts: vector of parameter elements used in the current sub-model
  #             (from info_list)
  # - lp: linear predictor of the current sub-model (from info_list)


  all_lvls <- Mlist$group_lvls

  # identify relevant levels (all higher levels)
  lvls <- names(all_lvls)[all_lvls > all_lvls[resplvl]]

  # if there is no random effects structure specified, assume random intercepts
  # at the appropriate levels
  newrandom <- if (is.null(Mlist$random[[varname]])) {
    sapply(lvls, function(x) ~ 1)
  } else {
    rd <- remove_grouping(Mlist$random[[varname]])
    if (all(lvls %in% names(rd))) {
      rd[lvls]
    } else {
      errormsg("Some grouping levels are missing from the random effects
               structure of %s.", dQuote(varname))
    }
  }

  if (length(newrandom) > 0) {
    hc_list <- mapply(get_hc_list, lvl = lvls, rdfmla = newrandom,
                      MoreArgs = list(Mlist = Mlist), SIMPLIFY = FALSE)

    orga_hc_parelmts(resplvl, lvls, all_lvls = all_lvls, hc_list = hc_list,
                     parelmts = parelmts, lp = lp)
  }
}





# used in get_hc_info() (2020-06-11)
get_hc_list <- function(lvl, rdfmla, Mlist) {
  # - lvl: character string of a level of the hierarchy
  # - rdfmla: the random effects formula corresponding to level lvl for the
  #            current sub-model
  # - Mlist: list of design matrices etc. (obtained from divide_matrices())

  Mlvls <- Mlist$Mlvls
  Mnam <- sapply(Mlist$M, colnames, simplify = FALSE)

  contr_list <- lapply(Mlist$refs, attr, "contr_matrix")

  # column names of random effect design matrices per required level
  Znam <- colnames(
    model.matrix(rdfmla, Mlist$data,
                 contrasts.arg = contr_list[intersect(all_vars(rdfmla),
                                                      names(contr_list))]))

  # check for involvement in interactions
  inters <- Mlist$interactions

  # identify if there are elements of interaction in Z
  inZ <- if (length(inters) > 0)
    sapply(Znam, function(x)
      lapply(lapply(inters, attr, 'elements'), `%in%`, x), simplify = FALSE)

  structure(
    sapply(Znam, function(x) {
      list(
        # if the random effect is in the fixed effects, find the column of
        # the design matrix
        main = if (x %in% names(Mlvls))
          setNames(match(x, Mnam[[Mlvls[x]]]), Mlvls[x]),

        interact = if (any(unlist(inZ[[x]]))) {
          w <- sapply(inZ[[x]], any)
          inters[w]
        }
      )
    }, simplify = FALSE),
    intercept = attr(terms(rdfmla), 'intercept')
  )
}





# used in get_hc_info() (2020-06-11)
orga_hc_parelmts <- function(resplvl, lvls, all_lvls, hc_list, parelmts, lp) {
  # - resplvl: level of the outcome variable of the current sub-model
  # - lvls: grouping levels in the current sub-model
  # - hc_list: obtained from get_hc_list()
  # - parelmts: vector of parameter elements (from info_list)
  # - lp: linear predictor (from info_list)

  hcvars <- sapply(lvls, function(k) {
    # names of random slope variables
    rdsvars <- names(hc_list[[k]])[names(hc_list[[k]]) != "(Intercept)"]

    rd_slope_coefs <- sapply(rdsvars, function(ii) {
      # parameter elements pertaining to the level the random slope variable
      # is on
      elmts <- parelmts[[names(hc_list[[k]][[ii]]$main)]]

      if (is.list(elmts)) {
        data.frame(term = ii,
                   matrix = names(hc_list[[k]][[ii]]$main),
                   cols = hc_list[[k]][[ii]]$main,
                   parelmts = NA,
                   stringsAsFactors = FALSE
        )
      } else {
        data.frame(term = ii,
                   matrix = names(hc_list[[k]][[ii]]$main),
                   cols = hc_list[[k]][[ii]]$main,
                   parelmts = ifelse(is.null(elmts[ii]), NA, unname(elmts[ii])),
                   stringsAsFactors = FALSE
        )
      }
    }, simplify = FALSE)

    # variables interacting with a random slope variable
    rd_slope_interact_coefs <- sapply(rdsvars, function(ii) {
      if (any(sapply(parelmts, is.list))) {
        do.call(rbind, sapply(hc_list[[k]][[ii]]$interact, function(x) {
          data.frame(term = attr(x, 'interaction'),
                     matrix = names(x$elmts[attr(x, 'elements') != ii]),
                     cols = x$elmts[attr(x, 'elements') != ii],
                     parelmts = NA,
                     stringsAsFactors = FALSE
          )
        }, simplify = FALSE))
      } else {
        do.call(rbind, sapply(hc_list[[k]][[ii]]$interact, function(x) {
          data.frame(term = attr(x, 'interaction'),
                     matrix = names(x$interterm),
                     cols = x$interterm,
                     parelmts = unname(parelmts[[names(x$interterm)]][
                       attr(x, 'interaction')]),
                     stringsAsFactors = FALSE
          )
        }, simplify = FALSE))
      }
    }, simplify = FALSE)

    elmts <- parelmts[[paste0("M_", k)]][
      !parelmts[[paste0("M_", k)]] %in%
        rbind(do.call(rbind, rd_slope_coefs),
              do.call(rbind, rd_slope_interact_coefs))$parelmts]

    rd_intercept_coefs <- if (!is.null(elmts) &
                              attr(hc_list[[k]], 'intercept') == 1) {
      if (is.list(elmts) | length(elmts) == 0) {
        # in case of a multinomial mixed model, there should not be
        # hierarchical centring of the random intercept.
        # If we don't have any parameters in here (by setting NULL), they
        # will end up in "othervars".
        NULL
      } else {
        data.frame(
          term = names(elmts),
          matrix = paste0("M_", k),
          cols = lp[[paste0("M_", k)]][names(elmts)],
          parelmts = elmts,
          stringsAsFactors = FALSE
        )
      }
    }

    structure(
      list(rd_intercept_coefs = rd_intercept_coefs,
           rd_slope_coefs = rd_slope_coefs,
           rd_slope_interact_coefs = rd_slope_interact_coefs
      ),
      'rd_intercept' = "(Intercept)" %in% names(hc_list[[k]])
    )
  }, simplify = FALSE)



  collapsed <- lapply(lapply(hcvars, function(i) {
    lapply(i, function(j) {
      if (is.list(j) & !is.data.frame(j))
        do.call(rbind, j)
      else
        j
    })
  }), do.call, what = rbind)

  used <- lapply(collapsed, "[[", "parelmts")


  othervars <- sapply(
    names(all_lvls)[all_lvls <= min(all_lvls[lvls])], function(lvl) {

      other <- get_othervars_mat(lvl, parelmts, lp)
      nonprop <- get_othervars_mat(lvl, lapply(parelmts, 'attr', 'nonprop'),
                                   attr(lp, 'nonprop'))

      if (!inherits(other, 'list'))
        other <- other[!other$parelmts %in% unlist(used), ]

      list(
        other = if (all(dim(other) > 0))
          other,
        nonprop = nonprop
      )
    }, simplify = FALSE)

  list(hcvars = hcvars, othervars = lapply(othervars, "[[", "other"),
       nonprop = lapply(othervars, "[[", "nonprop"))
}


get_othervars_mat <- function(lvl, parelmts, lp) {

  pe <- parelmts[[paste0("M_", lvl)]]
  linpred <- lp[[paste0("M_", lvl)]]

  if (length(pe) == 0) {
    NULL
  } else if (is.list(pe)) {
    # pe is a list for multinomial logit models that have multiple linear
    # predictors with separate parameters.
    # In that case: return a list of data.frames
    lapply(pe, function(p) {
      data.frame(term = names(p),
                 matrix = if (!is.null(linpred)) paste0("M_", lvl),
                 cols = linpred[names(p)],
                 parelmts = p,
                 stringsAsFactors = FALSE)
    })
  } else {
    data.frame(term = names(pe),
               matrix = if (!is.null(linpred)) paste0("M_", lvl),
               cols = linpred,
               parelmts = pe,
               stringsAsFactors = FALSE)
  }
}
