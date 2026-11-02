# Time-varying covariates with an association type in a joint model

Finds the columns of the linear predictor of the survival part of a
joint model that need an association type, and the variable each of them
belongs to.

## Usage

``` r
get_assoc_covars(lp, Mlist, tvars)
```

## Arguments

- lp:

  list per design matrix with the columns of the linear predictor (named
  vectors of column numbers)

- Mlist:

  list of model information, as created by `divide_matrices()`; used are
  `interactions`, `refs` and `fcts_all`

- tvars:

  character vector with the names of the time-varying covariates

## Value

A character vector with the names of the variables, named by the column
(for a factor: the name of the factor).

## Details

Interaction terms are replaced by their elements, so that a covariate
that is only part of an interaction also gets an association type. Dummy
variables are replaced by their factor. A function of several variables
(e.g., `I(age * trig)`) has one entry per variable, with the name of the
column repeated, so that names and variables stay aligned; those that
are not time-varying are then dropped.
