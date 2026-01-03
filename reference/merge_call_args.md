# Merge call arguments with default formals

Merge call arguments with default formals

## Usage

``` r
merge_call_args(formals, call, sframe)
```

## Arguments

- formals:

  List of formal arguments for `*_imp()`.

- call:

  The matched call from `*_imp()` as returned by
  [`match.call()`](https://rdrr.io/r/base/match.call.html).

- sframe:

  The environment within `*_imp()` (obtained from
  `sys.frame(sys.nframe())`)

## Value

A list of arguments combining defaults and user-specified values.

## Note

Helper function for [prep_arglist](prep_arglist.md).
