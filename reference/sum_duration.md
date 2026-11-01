# Calculate the sum of the computational duration of a JointAI object

Calculate the sum of the computational duration of a JointAI object

## Usage

``` r
sum_duration(object, by = c("all", "phase", "run", "chain", "phase and run",
  "run and phase"))
```

## Arguments

- object:

  object of class `JointAI`

- by:

  grouping; one of `"all"` (default) to calculate the sum over all
  chains and runs and both the adaptive and sampling phase, `"phase"` to
  get the sum over all chains and runs per phase, `"run"` to get the
  duration per run (over both phases), `"chain"` to get the sum per
  chain over both phases and all runs, `"phase and run"` (or
  `"run and phase"`) to get the sum over all chains, separately per
  phase and run. `NULL` (the default in earlier versions) is the same as
  `"all"`.

## Value

The duration(s), as `difftime`: for `by = "all"` a single value; for
`"phase"` a list with elements `adapt` and `sample`; for `"run"` a named
vector with one value per run; for `"chain"` a named vector with one
value per chain (a single value `total` when the chains were not run in
parallel); for `"phase and run"` a list with elements `adapt` and
`sample`, each a named vector with one value per run.

## Examples

``` r
# \donttest{
mod <- lm_imp(y ~ C1 + C2, data = wideDF, n.iter = 100, mess = FALSE)

sum_duration(mod)
#> Time difference of 0.01379323 secs
sum_duration(mod, by = "phase")
#> $adapt
#> Time difference of 0.008395672 secs
#> 
#> $sample
#> Time difference of 0.005397558 secs
#> 
# }
```
