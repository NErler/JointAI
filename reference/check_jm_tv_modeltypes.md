# Model types of the time-varying covariates of a joint model

The integral over the hazard in a joint model is approximated with
Gauss-Kronrod quadrature. The models of the time-varying covariates that
are needed for it are written once more for the quadrature points
(`gkmodel_in_jm()`). This is only implemented for the model types `glmm`
and `clmm`; for others (`mlogitmm`, i.e., unordered factors with more
than two categories, also complete ones) the JAGS model could not be set
up.

## Usage

``` r
check_jm_tv_modeltypes(tv_info)
```

## Arguments

- tv_info:

  named list with the model information of the time-varying covariates
  (the element `tv_vars` of the model information of the survival part);
  each element has the element `modeltype`.

## Value

`NULL`, invisibly; called for the error.

## Details

Stops with an informative error if a time-varying covariate has another
model type.
