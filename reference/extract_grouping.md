# Extract grouping variables from a (list of) formula(s)

Extracts the grouping variables (i.e., variables after `|`) from a model
formula or a list of such formulas

## Usage

``` r
extract_grouping(formula, warn = FALSE)
```

## Arguments

- formula:

  a `formula` object or a `list` of `formula` objects

- warn:

  does nothing

## Value

a vector of character strings containing the unique grouping variable
names found in any of the input formulas, or `NULL` if there is no
grouping found
