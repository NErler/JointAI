# Complete the monitored parameters for transforming coefficients back

With scaled covariates, the coefficients are transformed back after
sampling (`rescale_coefs()`). The intercept, the thresholds (ordinal
models) and the coefficients of the baseline hazard (proportional
hazards models) of a sub-model take the centring of all its covariates,
and the coefficients of the variables in cross-level interactions are
corrected with the coefficients of the interactions. Therefore, if a
coefficient, a threshold or a coefficient of the baseline hazard of a
sub-model is monitored, all regression coefficients of that sub-model
are monitored (not those of other sub-models).

## Usage

``` r
complete_coef_monitoring(var_names, info_list, mess = TRUE)
```

## Arguments

- var_names:

  character vector of the parameters (nodes) to monitor, as passed to
  JAGS (`get_params()`).

- info_list:

  list with the model information of each sub-model
  (`get_model_info()`).

- mess:

  logical; show a message about the added parameters?

## Value

`var_names` with the parameters that need to be added.
