# Interactions in the time-varying part of the survival model of a joint model

Selects the interaction terms among the time-varying columns of the
linear predictor of the survival part of a joint model, and checks that
all their elements are on the level of the time-varying covariates or on
the level of the survival outcome.

## Usage

``` r
get_jm_interactions(lp_cols, interactions, surv_mat)
```

## Arguments

- lp_cols:

  named integer vector: the columns of `M_lvlone` in the linear
  predictor of the survival model (names are the column names).

- interactions:

  list of interaction terms, as in `Mlist$interactions` (output of
  `match_interaction()`).

- surv_mat:

  name of the design matrix of the level of the survival outcome, e.g.,
  `"M_id"`.

## Value

A (possibly empty) named list: the elements of `interactions` that are
columns in `lp_cols`.
