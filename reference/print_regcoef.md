# Print the regression coefficients of a sub-model (used in `list_models()`)

Multinomial models have a set of coefficients per category (except the
reference category); they are listed per category, also when they are in
several design matrices (mixed models).

## Usage

``` r
print_regcoef(info, data_list, priors)
```

## Arguments

- info:

  the model information of the sub-model (an element of `info_list`).

- data_list:

  the data list passed to JAGS (for the hyper-parameters of the prior).

- priors:

  logical; should the prior be printed?

## Value

`NULL`, invisibly; called for the printed output.
