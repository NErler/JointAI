# Convert a survival outcome to a model name

A helper function that converts the "name of a survival model" (the
`"Surv(time, status)"` specification) into a valid variable name so that
it can be used in the JAGS model syntax.

## Usage

``` r
clean_survname(x)
```

## Arguments

- x:

  a character string or vector of character strings

## Examples

``` r
clean_survname("Surv(eventtime, event != 'censored')")
#> Surv(eventtime, event != 'censored') 
#>                    "Srv_vnttm_vnt_c" 
```
