# Check for missing values in grouping variables

Checks if any grouping variable contains missing values (`NA` or `NaN`)
and throws an error if so. Used within
[`get_groups()`](https://nerler.github.io/JointAI/reference/get_groups.md).

## Usage

``` r
check_na_groupings(groups)
```

## Arguments

- groups:

  a list of integer "id" variables

## Value

`NULL`; throws an error if missing values are found in any grouping
variable
