# Convert a variable with value labels to a factor

Convert a variable with value labels to a factor

## Usage

``` r
labelled_to_factor(x, levels = NULL)
```

## Arguments

- x:

  a labelled vector with attribute `"labels"` (a named vector of values)

- levels:

  optional character vector of factor levels. If `NULL`, the levels are
  the (labels of the) observed values, sorted by value.

## Value

an unordered factor with the value labels as levels, keeping the
`"label"` attribute of `x`
