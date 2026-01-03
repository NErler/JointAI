# Write the data element of a linear predictor

Write the data element of a linear predictor

## Usage

``` r
paste_data(matnam, index, col, isgk = FALSE)
```

## Arguments

- matnam:

  characters string; name of the data matrix

- index:

  character string; the index (e.g., "i", or "ii")

- col:

  integer vector; the indices of the columns in `matnam`

- isgk:

  logical; is this for within the Gauss-Kronrod quadrature?

## Value

A vector of character strings of the form `M_id[i, 3]` or
`M_id[i, 3, k]`.
