# Check that no outcome is used in more than one model formula

A variable can only be the outcome of one model (JAGS needs a directed
acyclic graph, and a copy of an outcome would count its information
twice). Gives an error when

1.  two parametric survival outcomes (`survreg`) have the same survival
    times (competing risks are not supported),

2.  the same variable (time, event indicator or other outcome) is used
    on the left hand side of more than one model formula,

3.  two different outcomes (other than event indicators) have identical
    values, e.g., a copy of an outcome.

## Usage

``` r
check_duplicate_outcomes(outcomes)
```

## Arguments

- outcomes:

  list produced by `extract_outcome_data()`; uses the elements
  `outcomes` (a named list of data.frames, one per model formula; for
  survival outcomes the columns are time and event indicator) and
  `fixed` (the formulas, with attribute `"type"`)

## Value

`NULL` (invisibly); called for the error.

## Details

Event indicators are compared by name only, so that, e.g., two survival
outcomes without censoring are possible.

Proportional hazards models (`coxph`, `JM`) may share the survival time:
with time-varying covariates, several survival outcomes are only
possible with the same time variable (`reformat_longsurvdata()` and
`get_data_list()` expect one), and with mutually exclusive event types
this gives a cause-specific hazards model. A shared time variable is
counted only once in checks 2 and 3. To be revisited when competing
risks are implemented
([`Surv()`](https://nerler.github.io/JointAI/reference/Surv.md) with an
event indicator with more than two values).
