# Is a regression coefficient monitored?

Is a regression coefficient monitored?

## Usage

``` r
coef_is_monitored(coef, var_names)
```

## Arguments

- coef:

  name of the coefficient, e.g. `"alpha[3]"` (or `"beta"` for a single
  coefficient, as in `coef_list`).

- var_names:

  character vector of the parameters (nodes) to monitor.

## Value

`TRUE` if the coefficient is monitored, as the whole node (e.g.
`"alpha"`), as element (`"alpha[3]"`), or as part of a range of elements
(`"alpha[2:4]"`).
