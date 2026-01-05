# Get grouping levels

A helper function that identifies the hierarchy of grouping variables.
It checks for each grouping level how many of the other grouping levels
it varies within and returns the ranked order of the grouping levels.

## Usage

``` r
get_grouping_levels(grouping_df)
```

## Arguments

- grouping_df:

  a `data.frame` of grouping ("id") variables, as obtained from
  [`get_groups()`](https://nerler.github.io/JointAI/reference/get_groups.md)

## Value

a named integer vector identifying the grouping hierarchy, where "1" is
the level of the individual observations and the largest number is the
highest grouping level. Crossed levels will have the same number.
