# Wrap a data element of a linear predictor in scaling syntax

Identifies if a data element of a linear predictor should be scaled
(based on whether scaling parameters are given) and then calls
[`paste_scale()`](https://nerler.github.io/JointAI/reference/paste_scale.md).

## Usage

``` r
paste_scaling(x, rows, scale_pars, scalemat)
```

## Arguments

- x:

  vector of character strings; to be scaled, typically matrix columns

- rows:

  integer vector; row numbers of the matrix containing the scaling
  information

- scale_pars:

  matrix containing the scaling information, with columns "center" and
  "scale"

- scalemat:

  the name of the scaling matrix in the JAGS model (e.g. "spM_id")

## Details

Calls
[`paste_scale()`](https://nerler.github.io/JointAI/reference/paste_scale.md)
on each element of `x`.
