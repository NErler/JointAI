# Check that model types given by the user fit the level of their variables

A variable below the highest level (it varies within the groups of a
grouping level) needs a model with random effects, a variable on the
highest level a model without random effects. With a type without random
effects, the model of a variable below the highest level would lose the
part of its linear predictor on the higher levels. Types that are not
known here are left to the later checks.

## Usage

``` r
check_model_type_level(models_user, var_ranks, max_rank)
```

## Arguments

- models_user:

  a named character vector with the model types given by the user
  (argument `models`)

- var_ranks:

  a named numeric vector with the rank of the level of each variable (as
  in
  [`get_grouping_levels()`](https://nerler.github.io/JointAI/reference/get_grouping_levels.md))

- max_rank:

  the rank of the highest level

## Value

nothing, but throws an error if a model type does not fit the level of
its variable

## Details

used in get_models (2026-11-07)
