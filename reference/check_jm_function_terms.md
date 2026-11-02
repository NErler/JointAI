# Functions of several variables in the survival part of a joint model

In the time-varying part of the linear predictor of the survival part of
a joint model, the value of a column is written in terms of one variable
(see `paste_linpred_jm()`), which, for example, is replaced by its
expected value for the association type `"underl.value"`. A function of
several variables (e.g., `I(age * chol)`) that is part of `M_lvlone`
because at least one of the variables is time-varying is therefore not
possible. Functions of several baseline variables are not concerned.

## Usage

``` r
check_jm_function_terms(lp_cols, trafos)
```

## Arguments

- lp_cols:

  named integer vector: the columns of `M_lvlone` in the linear
  predictor of the survival model (names are the column names).

- trafos:

  data.frame with information on the transformations, with the columns
  `colname`, `fct` and `var` (`Mlist$fcts_all`), or `NULL`.

## Value

`NULL`, invisibly; called for the error.

## Details

Stops with an informative error if there is such a term.
