# Outcomes that do not vary within the grouping of their random effects

A model with random effects for a grouping variable needs an outcome
that varies within the groups. An outcome that is constant within the
groups (e.g., a variable on the level of the subjects with `(1 | id)`)
has one value per group, and its random effects for this grouping cannot
be estimated. Without this check, the JAGS model had an empty linear
predictor (JAGS error) or, for multinomial mixed models, no covariates
and no random effects at all.

## Usage

``` r
check_outcome_varies_within_groups(fixed, random, data)
```

## Arguments

- fixed:

  named list of fixed effects formulas.

- random:

  list of random effects formulas, with the same names as `fixed`
  (elements can be `NULL`).

- data:

  the data.

## Value

`NULL`, invisibly; called for the error.

## Details

Survival outcomes are not checked: in survival models with time-varying
covariates, the random-effects part specifies the subjects. Missing
values of the outcome are ignored.
