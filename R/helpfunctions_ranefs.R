


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
get_hc_info <- function(varname, lvl, Mlist, parelmts, lp) {

  # - varname: variable name (unabbreviated form) of the outcome of the current
  #            sub-model
  # - lvl: level of the outcome variable of the current sub-model
  # - Mlist: list of design matrices etc. (obtained from divide_matrices())
  # - parelmts: vector of parameter elements used in the current sub-model
  #             (from info_list)
  # - lp: linear predictor of the current sub-model (from info_list)


  lvls <- Mlist$group_lvls

  # identify relevant levels (all higher levels)
  clus <- names(lvls)[lvls > lvls[lvl]]

  # if there is no random effects structure specified, assume random intercepts
  # at the appropriate levels
  newrandom <- if (is.null(Mlist$random[[varname]])) {
    sapply(clus, function(x) ~ 1)
  } else {
    rd <- remove_grouping(Mlist$random[[varname]])
    if (all(clus %in% names(rd))) {
      rd[clus]
    } else {
      errormsg("Some grouping levels are missing from the random effects
               structure of %s.", dQuote(varname))
    }
  }

  if (length(newrandom) > 0) {
    hc_list <- sapply(clus, get_hc_list, newrandom = newrandom,
                      Mlist = Mlist, simplify = FALSE)

    orga_hc_parelmts(lvl, lvls, hc_list, parelmts, lp)
  }
}





# used in get_hc_info() (2020-06-11)
get_hc_list <- function(k, newrandom, Mlist) {
  # - k: vector with names of grouping levels used for the current sub-model
  # - newrandom: list of random effects formulas in the current sub-model
  # - Mlist: list of design matrices etc. (obtained from divide_matrices())

  Mlvls <- Mlist$Mlvls
  Mnam <- sapply(Mlist$M, colnames, simplify = FALSE)

  # column names of random effect design matrices per required level
  Znam <- colnames(model.matrix(newrandom[[k]], Mlist$data))

  # check for involvement in interactions
  inters <- Mlist$interactions

  # identify if there are elements of interaction in Z
  inZ <- if (length(inters) > 0)
    sapply(Znam, function(x)
      lapply(lapply(inters, attr, 'elements'), `%in%`, x), simplify = FALSE)

  sapply(Znam, function(x) {
    list(# if the ranom effect is in the fixed effects, find the column of the design matrix
      main = if (x %in% names(Mlvls)) setNames(match(x, Mnam[[Mlvls[x]]]), Mlvls[x]),

      interact = if (any(unlist(inZ[[x]]))) {
        w <- sapply(inZ[[x]], any)
        inters[w]
      }
    )
  }, simplify = FALSE)
}





# used in get_hc_info() (2020-06-11)
orga_hc_parelmts <- function(lvl, lvls, hc_list, parelmts, lp) {
  # - lvl: level of the outcome variable of the current sub-model
  # - lvls: grouping levels in the current sub-model
  # - hc_list: obtained from get_hc_list()
  # - parelmts: vector of parameter elements (from info_list)
  # - lp: linear predictor (from info_list)

  clus <- names(lvls)[lvls > lvls[lvl]]

  hcvars <- sapply(clus, function(k) {
      i <- names(hc_list[[k]])[names(hc_list[[k]]) != "(Intercept)"]

      rd_slope_coefs = sapply(i, function(ii) {

        pe <- unname(parelmts[[names(hc_list[[k]][[ii]]$main)]][ii])

        data.frame(term = ii,
                   matrix = names(hc_list[[k]][[ii]]$main),
                   cols = hc_list[[k]][[ii]]$main,
                   parelmts = ifelse(is.null(pe), NA, pe),
                   stringsAsFactors = FALSE
        )
      }, simplify = FALSE)

      rd_slope_interact_coefs <- sapply(i, function(ii) {
        do.call(rbind, sapply(hc_list[[k]][[ii]]$interact, function(x) {
          data.frame(term = attr(x, 'interaction'),
                     matrix = names(x$elmts[attr(x, 'elements') != ii]),
                     cols = x$elmts[attr(x, 'elements') != ii],
                     parelmts = unname(parelmts[[names(x$interterm)]][attr(x, 'interaction')]),
                     stringsAsFactors = FALSE
          )
        }, simplify = FALSE))
      }, simplify = FALSE)

      elmts <- parelmts[[paste0("M_", k)]][
        !parelmts[[paste0("M_", k)]] %in% rbind(do.call(rbind, rd_slope_coefs),
                                                do.call(rbind, rd_slope_interact_coefs))$parelmts]

      rd_intercept_coefs <- if (!is.null(elmts))
        data.frame(
          term = names(elmts),
          matrix = paste0("M_", k),
          cols = lp[[paste0("M_", k)]][names(elmts)],
          parelmts = elmts,
          stringsAsFactors = FALSE
      )

      structure(
        list(rd_intercept_coefs = rd_intercept_coefs,
             rd_slope_coefs = rd_slope_coefs,
             rd_slope_interact_coefs = rd_slope_interact_coefs
        ),
        'rd_intercept' = "(Intercept)" %in% names(hc_list[[k]])
      )
  }, simplify = FALSE)


  othervars <- sapply(names(lvls)[lvls < min(lvls[clus])], function(k) {

    othervars <- data.frame(term = names(parelmts[[paste0("M_", k)]]),
                            matrix = if (!is.null(lp[[paste0("M_", k)]])) paste0("M_", k),
                            cols = lp[[paste0("M_", k)]],
                            parelmts = parelmts[[paste0("M_", k)]],
                            stringsAsFactors = FALSE)


    collapsed <- lapply(lapply(hcvars, function(i) {
      lapply(i, function(j) {
        if (is.list(j) & !is.data.frame(j))
          do.call(rbind, j)
        else
          j
      })
    }), do.call, what = rbind)

    used <- lapply(collapsed, "[[", "parelmts")

    othervars <- othervars[!othervars$parelmts %in% unlist(used), ]

    if (all(dim(othervars) > 0))
      othervars
  }, simplify = FALSE)

  list(hcvars = hcvars, othervars = othervars)
}




