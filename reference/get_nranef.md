# Extract the number of random effects

This function extracts the number of random effects per variable and
grouping level from the provided random effects formulas.

## Usage

``` r
get_nranef(random, data)
```

## Arguments

- random:

  a random effect formula or list of random effects formulas

- data:

  a `data.frame`

## Value

a list of named vectors of the numbers of random effects per variable,
were each list element refers to a (hierarchical) grouping level.
