# Prepare list of arguments for model_imp()

Prepare list of arguments for model_imp()

## Usage

``` r
prep_arglist(analysis_type, family = NULL, formals = formals(),
  call = match.call(), sframe = sys.frame(sys.nframe()))
```

## Arguments

- analysis_type:

  Type of analysis to be performed (from `*_imp()`)

- family:

  `family` object or character string specifying the error distribution
  and link function.

- formals:

  List of formal arguments for the function.

- call:

  The matched call as returned by
  [`match.call()`](https://rdrr.io/r/base/match.call.html).

- sframe:

  An environment (typically from `sys.frame(sys.nframe())`)

## Value

A list of arguments prepared for [`model_imp()`](model_imp.md),
including the analysis type, family, formulas, and other relevant
parameters.
