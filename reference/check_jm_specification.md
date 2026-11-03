# Check the specification of a joint model

A joint model needs subjects with repeated measurements and something
that changes over time in the survival part. This function

- stops if the survival outcome is on the level of the observations:
  without a random effects structure, there is no grouping, and each row
  of the data would be one subject, with time-varying covariates used as
  baseline covariates;

- stops if there is nothing longitudinal at all, i.e., no time-varying
  term in the survival part and no longitudinal model (this is a
  proportional hazards model);

- gives a warning for a time-varying covariate in the survival part with
  an automatically added model, which only has a random intercept and so
  may not describe the change of the covariate over time well enough for
  a joint model;

- gives a warning if the only time-varying terms in the survival part
  are effects of baseline covariates that change with time, and there is
  no longitudinal model. (It does not point to
  [`coxph_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md),
  which currently stops with an error for a term with the time
  variable.)

- gives a warning for a sub-model whose outcome is neither in the
  survival part nor a covariate in another sub-model, because this
  outcome is assumed to be independent of the survival outcome.

## Usage

``` r
check_jm_specification(info_list, Mlist, warn = TRUE)
```

## Arguments

- info_list:

  list of model information, from `get_model_info()`

- Mlist:

  list of model information, as created by `divide_matrices()`

- warn:

  logical; should the warnings be given?

## Value

`NULL`, invisibly; called for its errors and warnings.
