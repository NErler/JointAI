# Get info on main effects in a rd slope structure for a level and sub-model

Get info on main effects in a rd slope structure for a level and
sub-model

## Usage

``` r
hc_rdslope_info(hc_cols, parelmts)
```

## Arguments

- hc_cols:

  list of lists (one per random effect), each containing a list with
  elements "main" and "interact" that contain information on the column
  number and name of the design matrix for the random effects variables
  or variables interacting with them

- parelmts:

  list (per design matrix) of indices of the regression coefficients
  used for that sub-model (named with the corresponding column name of
  the design matrix)

## Value

a `data.frame` with columns

- `rd_effect`: name of the main random effect,

- `term`: the name of the random effect,

- `matrix`: the name of the design matrix,

- `cols`: the column index of the design matrix,

- `parelmts` (the index of the corresponding regression coefficient and
  one row per (main) random effect

## Details

Argument `hc_cols` should have the structure:

    list(
      "(Intercept)" = list(main = c(M_id = 1),
                           interact = NULL),
      time = list(main = c(M_lvlone = 4),
                  interact = list("C1:time" = list(interterm = c(M_lvlone = 6),
                                                   elmts = c(M_id = 2,
                                                             M_lvlone = 4)),
                                  "b21:time" = list(interterm = c(M_lvlone = 7),
                                                    elmts = c(M_lvlone = 3,
                                                              M_lvlone = 4))
                  )
      ),
      "I(time^2)" = list(main = c(M_lvlone = 5),
                         interact = NULL)
    )

Argument `parelmts` is a list of lists instead of a list of vectors in
case of a multinomial model or cumulative logit model with
non-proportional effects.
