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
