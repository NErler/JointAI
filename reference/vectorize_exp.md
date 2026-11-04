# Write `exp()` so that JAGS accepts a vector as its argument

In the quadrature part of a joint model, the underlying value of a
time-varying covariate is a vector (e.g., `mugk_x[ii, 1:15]`), but JAGS
does not accept a vector as argument of
[`exp()`](https://rdrr.io/r/base/Log.html). Each `exp(a)` is replaced by
`(exp(1)^(a))`, in which the outer parentheses keep the precedence of
the original function call. Used in `paste_linpred_jm()` and
`paste_jm_column()`.

## Usage

``` r
vectorize_exp(x)
```

## Arguments

- x:

  character string with (part of) a JAGS expression

## Value

The character string with all calls to
[`exp()`](https://rdrr.io/r/base/Log.html) replaced.
