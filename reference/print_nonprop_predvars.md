# Print the variables with non-proportional effects (used in `list_models()`)

In cumulative logit models, the effects of the variables given in
`nonprop` differ between the categories of the outcome.

## Usage

``` r
print_nonprop_predvars(info)
```

## Arguments

- info:

  the model information of the sub-model (an element of `info_list`);
  the variables are in the attribute `nonprop` of `info$lp`.

## Value

`NULL`, invisibly; called for the printed output.
