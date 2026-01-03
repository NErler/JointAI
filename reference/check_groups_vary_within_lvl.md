# Check if a grouping variable varies within another grouping variable

Check if a grouping variable varies within another grouping variable

## Usage

``` r
check_groups_vary_within_lvl(lvl, grouping_df)
```

## Arguments

- lvl:

  a vector defining a grouping level

- grouping_df:

  a `data.frame` with where each column contains the grouping indices of
  a hierarchical level (as obtained by `get_groups(...)`)

## Value

a named logical vector indicating for each grouping variable (column of
`grouping_df`) whether it varies within the grouping defined by `lvl`
