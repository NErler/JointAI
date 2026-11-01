# Scaling parameters of design-matrix columns

Finds the rows by the exact column name. (Indexing the rows of a
`data.frame` with names, `scale_pars[columns, ]`, also accepts a partial
match: `"age"` would find the row `"age_sq"` if there is no row
`"age"`.)

## Usage

``` r
scale_pars_rows(scale_pars, columns)
```

## Arguments

- scale_pars:

  `data.frame` of scaling parameters (columns `center` and `scale`, one
  row per design-matrix column, named by the column).

- columns:

  character vector of column names.

## Value

`data.frame` with one row per element of `columns`, in that order; the
values are `NA` for a name that has no row in `scale_pars`.
