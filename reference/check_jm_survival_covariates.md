# Covariates in the survival part of a joint model

In a joint model, the survival outcome is linked to the longitudinal
outcomes through the covariates of the survival part. A survival part
without covariates (e.g., `Surv(time, status) ~ 1`, also with random
effects) is therefore not meaningful, and the model set-up would stop
with an uninformative error.

## Usage

``` r
check_jm_survival_covariates(formula)
```

## Arguments

- formula:

  a formula or a list of formulas, as given to
  [`JM_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md).

## Value

`NULL`, invisibly; called for the error.

## Details

Stops with an informative error if the fixed effects part of a survival
formula has no covariates. Other formulas are not concerned.
