# Interactions in the survival part of a joint model with unknown elements

An interaction term is only recognised as such (in `Mlist$interactions`)
when all its elements are columns of the design matrices. In the
time-varying part of the linear predictor of the survival part of a
joint model, the value of an interaction term is the product of its
elements (see `paste_jm_interaction()`), so that an interaction with an
element that is not a column is not possible. This happens

- for an interaction with a function of the time variable (e.g.,
  `chol:ns(day, df = 3)`) without the main effect of this function: as a
  workaround, the function can be added to the data with the argument
  `auxvars` (this does not change the models for incomplete covariates,
  because they already contain the time variable);

- for an interaction of a factor with a variable without the main effect
  of that variable (e.g., `sex + sex:day`): R
  ([`model.matrix()`](https://rdrr.io/r/stats/model.matrix.html)) then
  codes the interaction with all categories of the factor, also the
  reference category (`sexmale:day` and `sexfemale:day`), which is not a
  column of the design matrix. Together, these terms contain a main
  effect of the other variable, which, for the time variable or a
  function of it, cannot (or hardly) be distinguished from the baseline
  hazard.

## Usage

``` r
check_jm_unknown_interactions(lp_cols, interactions, design_cols, refs,
  timevar)
```

## Arguments

- lp_cols:

  named integer vector: the columns of `M_lvlone` in the linear
  predictor of the survival model (names are the column names).

- interactions:

  list of interaction terms, as in `Mlist$interactions` (output of
  `match_interaction()`).

- design_cols:

  character vector: the names of all columns of the design matrices.

- refs:

  list of reference category information (`Mlist$refs`).

- timevar:

  name of the time variable.

## Value

`NULL`, invisibly; called for the error.

## Details

Stops with an informative error if there is such an interaction.
