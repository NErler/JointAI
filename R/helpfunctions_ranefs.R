#
# # function per outcome model and per random effects grouping:
#
# hc_helper <- function(lp, random, data, interactions, Mnam, Mlvls) {
#   # make the design matrices
#   Z <- model.matrix(random, data)
#
#   # identify interactions from fixed
#   inters <- interactions[names(interactions) %in% lp]
#
#   # identify if there are elements of interaction in Z
#   inZ <- if (length(inters) > 0)
#     sapply(colnames(Z), function(x)
#       lapply(lapply(inters, attr, 'elements'), `%in%`, x), simplify = FALSE)
#
#   sapply(colnames(Z), function(x) {
#     list(# if the ranom effect is in the fixed effects, find the column of the design matrix
#       main = if (x %in% names(Mlvls)) setNames(match(x, Mnam[[Mlvls[x]]]), Mlvls[x]),
#       # if the random effect is not in the fixed effects, return 0
#       # } else 0,
#
#       interact = if (any(unlist(inZ[[x]]))) {
#         w <- sapply(inZ[[x]], any)
#         inters[w]
#       }
#     )
#   }, simplify = FALSE)
# }
#
#
#
# HC <- function(varname, lvl, Mlist, data) {
#
#   lvls <- colSums(!identify_level_relations(Mlist$groups))
#
#   if (!varname %in% names(Mlist$random)) {
#     clus <- names(lvls)[lvls > lvls[gsub("M_", "", Mlist$Mlvls[varname])]]
#     newrandom <- sapply(clus, function(x) ~ 1)
#   } else {
#     newrandom <- remove_grouping(Mlist$random[[varname]])
#   }
#
#   # for each random effects formula:
#   hc <- if (!is.null(newrandom)) {
#       sapply(names(newrandom)[lvls[names(newrandom)] > lvls[lvl]], function(i) {
#         matname <- paste0("M_", i)
#
#         hc_helper(Mlist$lp_cols[[varname]], random = newrandom[[i]], data = data,
#                   interactions = Mlist$interactions,
#                   Mnam = sapply(Mlist$M, colnames), Mlvls = Mlist$Mlvls)
#       }, simplify = FALSE)
#     }
#   return(hc)
# }
#
#
#
#
# get_hc_info_helper <- function(hc_list, info) {
#   hcinfo <- list()
#   allcoefs <- c()
#
#   for (ranefnam in names(hc_list)) {
#     # for each random (slope) effect, do:
#
#     if (ranefnam != "(Intercept)") {
#       hc <- hc_list[[ranefnam]]
#
#       # main effects in the random effects design matrix
#       # (coefficients go into mu_b, b is multiplied with the column of M)
#       main_effect <- list(matrix = names(hc$main),
#                           column = unname(hc$main),
#                           coef_nr = if (length(names(hc$main)) > 0) {
#                             info$parelmts[[names(hc$main)]][ranefnam]
#                           }
#       )
#
#       # interactions of fixed effects with random effects variables
#       # (if baseline: coefficient and variable inside mu_b;
#       #  if lonitudinal: interaction with random effect treated as standard
#       #  longitudinal variable and is added separately)
#       interact_effect <- if (!is.null(hc$interact))
#         sapply(hc$interact, function(k) {
#           # for each interaction with this random (slope) effect, do:
#
#           # find which of the elements of the interaction is not the random effect
#           elmts <- k$elmts[which(attr(k, 'elements') != ranefnam)]##########################################################
#
#           coefnr <- if (names(k$interterm) == 'Mc')
#             info$parelmts$Mc[match(k$interterm, info$lp$Mc)]
#           else if (names(k$interterm) == 'Ml')
#             info$parelmts$Ml[match(k$interterm, info$lp$Ml)]
#
#
#           list(
#             matrix = names(elmts),
#             column = unname(elmts),
#             coef_nr = coefnr
#           )
#         }, simplify = FALSE)
#
#       hcinfo[[ranefnam]] <- list(main_effect = main_effect,
#                                  interact_effect = interact_effect[
#                                    !sapply(interact_effect, "[[", 'coef_nr') %in% allcoefs]
#       )
#       allcoefs <- c(allcoefs, sapply(interact_effect, "[[", 'coef_nr'))
#     }}
#
#   hcinfo
# }
#
#
#
# get_hc_info <- function(info) {
#
#   if (is.null(info$hc_list))
#     return(NULL)
#
#   sapply(info$hc_list, get_hc_info_helper, info = info)
# }
#
#
#
#
#
#
# organize_hc_parelmts <- function(hc_info, info) {
#   # find which parameter elements are used in the hierarchical centering
#   # specification of the random slopes
#
#   in_rdslope <- unlist(sapply(names(info$parelmts), function(h) {
#     sapply(hc_info[[gsub('M_', '', h)]], function(k) {
#       c(# coefficients of fixed effects that are also random effects:
#         k$main_effect$coef_nr,
#         # coefficients of baseline fixed effects that have interaction with rd. effects
#         sapply(k$interact_effect, "[[", "coef_nr")[
#           sapply(k$interact_effect, "[[", "matrix") %in% h]
#       )
#     })
#   }))
#
#   # parameter elements left for the baseline covariates
#   in_b0 <- sapply(names(info$hc_list), function(x) {
#     which(!info$parelmts[[paste0("M_", x)]] %in% in_rdslope)
#   }, simplify = FALSE)
#
#   # parameter elements left for the longitudinal covariates,
#   # added to the "Zb" part of the linear predictor
#   notin_b <- sapply(info$parelmts[!names(info$parelmts) %in% paste0("M_", names(info$hc_list))],
#                     function(x)
#                       which(!x %in% in_rdslope), simplify = FALSE)
#
#   return(list(in_b0 = in_b0, notin_b = notin_b, in_rdslope = in_rdslope))
# }
#


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


get_hc_info <- function(varname, lvl, Mlist, data, parelmts, lp) {
  lvls <- Mlist$group_lvls

  # identify relevant levels (all higher levels)
  clus <- names(lvls)[lvls > lvls[lvl]]
  # if there is no random effects structur specified, assume random intercepts
  # at the appropriate levels
  newrandom <- if (is.null(Mlist$random[[varname]])) {
    sapply(clus, function(x) ~ 1)
  } else {
    remove_grouping(Mlist$random[[varname]])[clus]
  }

  hc_list <- sapply(clus, get_hc_list, newrandom = newrandom, data = data,
                    Mlist = Mlist, simplify = FALSE)

  orga_hc_parelmts(lvl, lvls, hc_list, parelmts, lp)
}


get_hc_list <- function(k, newrandom, data, Mlist) {
  Mlvls <- Mlist$Mlvls
  Mnam <- sapply(Mlist$M, colnames, simplify = FALSE)
  # column names of random effect design matrices per required level
  Znam <- colnames(model.matrix(newrandom[[k]], data))

  # check for involvement in interactions
  inters <- Mlist$interactions#[names(Mlist$interactions) %in% names(Mlist$lp_cols[[varname]][[paste0("M_", k)]])]

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

orga_hc_parelmts <- function(lvl, lvls, hc_list, parelmts, lp) {

  clus <- names(lvls)[lvls > lvls[lvl]]

  hcvars <- sapply(clus, function(k) {
    # if (any(names(hc_list[[k]]) != "(Intercept)")) {
      i <- names(hc_list[[k]])[names(hc_list[[k]]) != "(Intercept)"]

      rd_slope_coefs = sapply(i, function(ii) {
        data.frame(term = ii,
                   matrix = names(hc_list[[k]][[ii]]$main),
                   cols = hc_list[[k]][[ii]]$main,
                   parelmts = unname(parelmts[[names(hc_list[[k]][[ii]]$main)]][ii]),
                   stringsAsFactors = FALSE
        )
      }, simplify = FALSE)

      rd_slope_interact_coefs <- lapply(i, function(ii) {
        do.call(rbind, sapply(hc_list[[k]][[ii]]$interact, function(x) {
          data.frame(term = attr(x, 'interaction'),
                     matrix = names(x$elmts[attr(x, 'elements') != ii]),
                     cols = x$elmts[attr(x, 'elements') != ii],
                     parelmts = unname(parelmts[[names(x$interterm)]][attr(x, 'interaction')]),
                     stringsAsFactors = FALSE
          )
        }, simplify = FALSE))
      })

      elmts <- parelmts[[paste0("M_", k)]][
        !parelmts[[paste0("M_", k)]] %in% unlist(c(rd_slope_coefs, rd_slope_interact_coefs))]

      rd_intercept_coefs <- data.frame(
        term = names(elmts),
        matrix = paste0("M_", k),
        cols = lp[[paste0("M_", k)]][names(elmts)],
        parelmts = elmts,
        stringsAsFactors = FALSE
      )

      list(rd_intercept_coefs = rd_intercept_coefs,
           rd_slope_coefs = do.call(rbind, rd_slope_coefs),
           rd_slope_interact_coefs = do.call(rbind, rd_slope_interact_coefs)
      )

  }, simplify = FALSE)


  othervars <- sapply(names(lvls)[lvls < min(lvls[clus])], function(k) {

    othervars <- data.frame(term = names(parelmts[[paste0("M_", k)]]),
                            matrix = paste0("M_", k),
                            cols = lp[[paste0("M_", k)]],
                            parelmts = parelmts[[paste0("M_", k)]],
                            stringsAsFactors = FALSE)

    used <- sapply(lapply(hcvars, do.call, what = rbind), "[[", "parelmts")

    othervars <- othervars[!othervars$parelmts %in% unlist(used), ]

    if (all(dim(othervars) > 0))
      othervars
  }, simplify = FALSE)

  list(hcvars = hcvars, othervars = othervars)
}




