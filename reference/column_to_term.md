# The term in the model formula that a column of a design matrix belongs to

A function with several columns (e.g., `ns(chol, df = 2)`, with the
columns `ns(chol, df = 2)1` and `ns(chol, df = 2)2`) is one term. Any
other column is its own term.

## Usage

``` r
column_to_term(columns, trafos)
```

## Arguments

- columns:

  character vector of column names

- trafos:

  data.frame with information on the transformations, with the columns
  `colname` and `fct` (`Mlist$fcts_all`), or `NULL`

## Value

A character vector with the term of each column.
