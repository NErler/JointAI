# Values of a covariate for one group, per iteration

Values of a covariate for one group, per iteration

## Usage

``` r
group_covariate_values(cov_shift, g, lvl, groups, MCMC, data_list)
```

## Arguments

- cov_shift:

  element of the output of
  [`ranef_covariate_shift()`](https://nerler.github.io/JointAI/reference/ranef_covariate_shift.md)
  (with `matrix` and `col`).

- g:

  integer; the group (row of the random effects).

- lvl:

  grouping level of the random effects.

- groups:

  `data.frame` of grouping information (`Mlist$groups`; one row per row
  of the lowest level).

- MCMC:

  MCMC sample (matrix); contains the imputed values of the covariate if
  they were monitored (columns `<matrix>[<row>,<col>]`).

- data_list:

  data list passed to JAGS.

## Value

Vector with one value per iteration: the observed value, the imputed
values, or `NA` if the value is missing and the imputed values were not
monitored.
