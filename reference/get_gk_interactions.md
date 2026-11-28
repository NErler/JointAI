# Interactions to calculate at the quadrature points of a joint model

In the survival part of a joint model, the models for the time-varying
covariates are written again for the quadrature points, with the design
matrix `M_lvlonegk`. In this matrix, the time-varying covariates (and
the columns calculated from them) are missing (`get_matgk()`) and
modelled or calculated in the JAGS model. This function selects the
interaction terms that have to be calculated there: the interactions
that are columns of `M_lvlone`, are used in the linear predictor of one
of these models, and have an element that is (calculated from) a
time-varying covariate modelled at the quadrature points. Their elements
must be on the lowest level, or on the level of the survival outcome or
above.

## Usage

``` r
get_gk_interactions(tv_info, interactions, trafos, refs, surv_mat, group_lvls)
```

## Arguments

- tv_info:

  list with the model information of the time-varying covariates at the
  quadrature points (the element `tv_vars` of the model information of
  the survival part), named by the covariates.

- interactions:

  list of interaction terms, as in `Mlist$interactions` (output of
  `match_interaction()`).

- trafos:

  data frame with information on the functions of variables
  (`Mlist$fcts_all`).

- refs:

  list with information on the reference categories of the factors
  (`Mlist$refs`).

- surv_mat:

  name of the design matrix of the level of the survival outcome, e.g.,
  `"M_id"`.

- group_lvls:

  named integer vector of the order of the grouping levels
  (`Mlist$group_lvls`).

## Value

A (possibly empty) named list: the elements of `interactions` to be
calculated at the quadrature points.
