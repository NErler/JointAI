# Fixed-effects terms in the means of the random effects

With hierarchical centring, the mean of a random effect contains fixed
effects: the intercept and covariates of the level (random intercept),
the coefficient of the random-slope variable and its cross-level
interactions (random slopes).

## Usage

``` r
ranef_mean_terms(lvl_info, data_list)
```

## Arguments

- lvl_info:

  hierarchical-centring information of one grouping level (element of
  `hc_list$hcvars` of a sub-model).

- data_list:

  data list passed to JAGS (for the names of design-matrix columns).

## Value

`data.frame` with one row per term: `rd_effect` (the random effect whose
mean contains the term), `coef_term` (column name of the term, to find
its coefficient), `w` (column name of the covariate the coefficient is
multiplied with; `NA` for a constant, i.e. the intercept or the
coefficient of the random-slope variable itself), and `w_matrix` and
`w_col` (data matrix and column number of `w`; `NA` for a constant).
