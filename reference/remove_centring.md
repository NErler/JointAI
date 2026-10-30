# Scale columns without centring them

Sets the centre of the given columns to 0 and their scale to the root
mean square (as `scale(x, center = FALSE)`), calculated, like the other
scaling parameters, from one value per group of the level of the data
matrix (the data matrices in `Mlist` have one row per group). Columns
that are not scaled at all are not changed.

## Usage

``` r
remove_centring(scale_pars, columns, Mlist)
```

## Arguments

- scale_pars:

  list of `data.frame`s of scaling parameters, one per data matrix
  (`Mlist$scale_pars`).

- columns:

  character vector of column names
  ([`get_uncentred_columns()`](https://nerler.github.io/JointAI/reference/get_uncentred_columns.md)).

- Mlist:

  list of data matrices and related information (`divide_matrices()`).

## Value

`scale_pars` with the changed rows.
