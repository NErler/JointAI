# Print the coefficients of non-proportional effects (used in `list_models()`)

Print the coefficients of non-proportional effects (used in
[`list_models()`](https://nerler.github.io/JointAI/reference/list_models.md))

## Usage

``` r
print_nonprop_regcoef(info, data_list, priors)
```

## Arguments

- info:

  the model information of the sub-model (an element of `info_list`);
  the coefficients are in the attribute `nonprop` of the elements of
  `info$parelmts`, with one element per category of the outcome (except
  the first).

- data_list:

  the data list passed to JAGS (for the hyper-parameters of the prior).

- priors:

  logical; should the prior be printed?

## Value

`NULL`, invisibly; called for the printed output.
