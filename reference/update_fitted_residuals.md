# Set the fitted values and residuals of a JointAI object

Calculates the fitted values and (working) residuals from the current
MCMC sample of the object. If they cannot be calculated (e.g., because
there is no sample or the regression coefficients are not monitored),
they are removed from the object, so that no values from an earlier
sample remain.

## Usage

``` r
update_fitted_residuals(object)
```

## Arguments

- object:

  object of class `JointAI` (or the object that is being created in
  [`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
  and
  [`add_samples()`](https://nerler.github.io/JointAI/reference/add_samples.md)).

## Value

`object` with the updated elements `fitted.values` and `residuals`.
