# Calculate the sum of the computational duration of a JointAI object

Calculate the sum of the computational duration of a JointAI object

## Usage

``` r
sum_duration(object, by = NULL)
```

## Arguments

- object:

  object of class `JointAI`

- by:

  optional grouping information; options are `NULL` (default) to
  calculate the sum over all chains and runs and both the adaptive and
  sampling phase, `"run"` to get the duration per run, `"phase"` to get
  the sum over all chains and runs per phase, `"chain"` to get the sum
  per chain over both phases and all runs, `"phase and run"` to get the
  sum over all chains, separately per phase and run.
