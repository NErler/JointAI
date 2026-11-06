# Check and normalise the specification of the parameters to monitor

`monitor_params` may be a named list or a named vector. When logical
values and parameter names are combined with
[`c()`](https://rdrr.io/r/base/c.html), the logical values become
character strings (`"TRUE"`, `"FALSE"`), and a vector of parameter names
in `other` is split into elements with the names `other1`, `other2`, ...
(#114). This function converts both forms to the same named list, and
stops with an informative error for names that are not parameter groups
of `get_params()`.

## Usage

``` r
check_monitor_params(monitor_params, argname = "monitor_params")
```

## Arguments

- monitor_params:

  named list or vector specifying which parameters should be monitored
  (see
  [`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)),
  or `NULL`; also the argument `subset` of the output functions

- argname:

  character string; the name of the argument, used in the error messages
  (`"monitor_params"` or `"subset"`)

## Value

a named list with one element per parameter group: `TRUE` or `FALSE` (or
as given, e.g. `NULL`) for the parameter groups, and a character vector
of parameter names for `other`

## Details

used in
[`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`add_samples()`](https://nerler.github.io/JointAI/reference/add_samples.md)
and `get_subset()` (2026-11-06)
