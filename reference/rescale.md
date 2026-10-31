# Transform the MCMC sample back to the scale of the original data

Continuous covariates are centred and scaled before they are passed to
JAGS (see `get_scale_pars()`). After sampling, all parameters that
depend on this scaling are transformed back, so that they refer to the
original variables: the regression coefficients, thresholds of ordinal
models and coefficients of the baseline hazard
([`rescale_coefs()`](https://nerler.github.io/JointAI/reference/rescale_coefs.md)),
and the random effects and their variance-covariance matrices
([`rescale_ranefs()`](https://nerler.github.io/JointAI/reference/rescale_ranefs.md)).

## Usage

``` r
rescale(MCMC, coefs, scale_pars, info_list, data_list, groups)
```

## Arguments

- MCMC:

  MCMC sample of one chain (`mcmc` object or matrix), on the scale used
  in JAGS.

- coefs:

  `data.frame` with one row per regression coefficient
  (`do.call(rbind, get_coef_names(info_list))`).

- scale_pars:

  `data.frame` of scaling parameters (columns `center` and `scale`, one
  row per design-matrix column, named by the column;
  `do.call(rbind, unname(Mlist$scale_pars))`). `NA` means not scaled.

- info_list:

  list with the model info of each sub-model.

- data_list:

  data list passed to JAGS (for the names of design-matrix columns).

- groups:

  list of grouping information (`Mlist$groups`; for the number of groups
  per level).

## Value

Matrix with the same columns as `MCMC`, on the original scale.

## Details

Used by
[`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
and
[`add_samples()`](https://nerler.github.io/JointAI/reference/add_samples.md),
and by the package remiod (frozen: the arguments and the returned object
must not change).
