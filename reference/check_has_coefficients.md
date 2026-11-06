# Sub-models without regression coefficients

The JAGS models of the types `glm`, `glmm`, `mlogit` and `mlogitmm` need
at least one regression coefficient (the loop over the priors of the
coefficients would otherwise run from `Inf` to `-Inf`). This is not the
case for a model without an intercept and without covariates, e.g.
`y ~ 0` or `y ~ 0 + (1 | id)`.

## Usage

``` r
check_has_coefficients(parelmts, varname)
```

## Arguments

- parelmts:

  the parameter elements of the model (list per design matrix, as
  returned by `get_parelmts()`).

- varname:

  name of the outcome of the model.

## Value

`NULL`, invisibly; called for the error.

## Details

Stops with an informative error if the model has no regression
coefficients.
