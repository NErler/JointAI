# Columns that are scaled but must not be centred

Centring a covariate moves part of its effect into a parameter that
takes the role of an intercept: the intercept, the thresholds (ordinal
models), the baseline hazard (proportional hazards models), or a random
intercept. Where there is no such parameter, centring changes the model
(#66). These columns are only scaled:

- all covariates of a sub-model without intercept (that is not an
  ordinal or proportional hazards model);

- the random-slope variables of a grouping level without random
  intercept;

- in a cross-level interaction `w:z` in the mean of a random slope
  (`get_slope_interactions()`): `z` if the main effect of `w` is not in
  the model, and `w` if the main effect of `z` is not in the model (the
  product of the centred variables contains `c_z * w` and `c_w * z`).

## Usage

``` r
get_uncentred_columns(info_list, Mlist)
```

## Arguments

- info_list:

  list with the model information of each sub-model
  (`get_model_info()`).

- Mlist:

  list of data matrices and related information (`divide_matrices()`).

## Value

Character vector of column names.

## Details

A column is used by all sub-models, so it is not centred if one of them
needs this.
