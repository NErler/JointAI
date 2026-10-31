# Cross-level interactions in the means of random slopes

With hierarchical centring, an interaction of a covariate `w` of a
higher level with a random-slope variable `z` enters the mean of that
random slope, so that the JAGS model contains `beta * w * z` with `w`
and `z` scaled separately (not the scaled column `w:z`).

## Usage

``` r
get_slope_interactions(info_list, data_list)
```

## Arguments

- info_list:

  list with the model info of each sub-model (uses the random-effects
  information in `hc_list`).

- data_list:

  data list passed to JAGS (for the names of design-matrix columns).

## Value

`data.frame` with one row per such term: `outcome` (name of the outcome
as in `coefs`), `term` (column name of the interaction), `w` and `z`
(column names of the two variables); no rows if there are none.
