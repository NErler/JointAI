# Names of the elements of a parameter vector in the MCMC sample

JAGS names the elements `name[1]`, `name[2]`, ..., but a vector of
length 1 just `name`.

## Usage

``` r
par_names(name, n)
```

## Arguments

- name:

  character string; name of the parameter vector

- n:

  integer; length of the parameter vector

## Value

Character vector of length `n` with the names of the elements.
