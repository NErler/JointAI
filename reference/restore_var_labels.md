# Restore variable labels

Restore variable labels

## Usage

``` r
restore_var_labels(data, var_labels)
```

## Arguments

- data:

  a `data.frame`

- var_labels:

  a named list of variable labels (the `"label"` attributes of the
  variables in the original data, `NULL` if there was none)

## Value

`data`, where variables that lost their `"label"` attribute have it
again
