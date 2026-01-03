# Create the scaling in a data element of a linear predictor

Create the scaling in a data element of a linear predictor

## Usage

``` r
paste_scale(x, row, scalemat)
```

## Arguments

- x:

  a character string

- row:

  integer; indicating the row of `scalemat` to be used

- scalemat:

  character string; name of the matrix containing the scaling
  information (e.g., "spM_lvlone"). This matrix is assumed to have
  columns "center" and "scale".

## Value

a character string of the form `(x - center)/scale`.
