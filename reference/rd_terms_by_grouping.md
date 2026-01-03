# Extract terms by grouping variables from a formula

This function takes a formula as input, extracts terms that are
associated with grouping variables, and organizes them by grouping
variable.

## Usage

``` r
rd_terms_by_grouping(formula)
```

## Arguments

- formula:

  a `formula` object

## Value

a named list of one-sided formulas, where each name corresponds to a
grouping variable and the formula contains all terms associated with
that grouping variable.
