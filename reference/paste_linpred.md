# Write a linear predictor

Construct a linear predictor from parameter names and indices, the name
of the data matrix and corresponding columns, and apply scaling to the
data if necessary.

## Usage

``` r
paste_linpred(parname, parelmts, matnam, index, cols, scale_pars,
  isgk = FALSE)
```

## Arguments

- parname:

  character string; name fo the parameter (e.g., "beta")

- parelmts:

  integer vector; indices of the parameter vector to be used; should
  have the same length as `cols`

- matnam:

  character string; name of the data matrix

- index:

  character string; name of the index (e.g., "i" or "ii")

- cols:

  integer vector; indices of the columns of `matname`, should have the
  same length as `parlemts`

- scale_pars:

  matrix with row names according to the column names of `matname` and
  columns "center" and "scale"; or NULL

- isgk:

  logical; is this linear predictor within the Gauss-Kronrod quadrature?
