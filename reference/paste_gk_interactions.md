# Write the interaction terms at the quadrature points of a joint model

Writes the JAGS syntax that calculates the interaction terms selected by
[`get_gk_interactions()`](https://nerler.github.io/JointAI/reference/get_gk_interactions.md)
in the design matrix at the quadrature points (`M_lvlonegk`), as the
product of their elements, for each quadrature point. Elements in
`M_lvlone` are taken from `M_lvlonegk`; elements on the level of the
survival outcome or above from their design matrix, for the current unit
of the survival outcome. Used in `jagsmodel_jm()`, inside the loop over
the units of the survival outcome.

## Usage

``` r
paste_gk_interactions(interactions, index, surv_lvl)
```

## Arguments

- interactions:

  named list of interaction terms (the element `gk_interactions` of the
  model information of the survival part).

- index:

  character string; the index of the level of the survival outcome,
  e.g., `"ii"`.

- surv_lvl:

  character string; the level of the survival outcome, e.g., `"id"`.

## Value

A character string with the JAGS syntax, or `NULL` if there are no
interaction terms.
