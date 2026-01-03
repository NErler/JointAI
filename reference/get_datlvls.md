# Determine grouping level of data

For each column in a `data.frame`-like object, identify the hierarchical
level as the highest grouping level from `groups_df` for which the
column is identical for all members of every group.

## Usage

``` r
get_datlvls(data, groups_df)
```

## Arguments

- data:

  a `data.frame`

- groups_df:

  the `data.frame` of (integer) grouping vectors of length `nrow(data)`.

## Value

A named character vector of length `ncol(data)`. Each element is the
name of the grouping level at which the corresponding data column is
constant.

## See also

`get_grouping_levels`
