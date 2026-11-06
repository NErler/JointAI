# Write the arguments of `Surv()` on the left-hand side without names

The names of the survival time and event variables are taken from the
position of the arguments of
[`Surv()`](https://nerler.github.io/JointAI/reference/Surv.md)
(`idSurv()`), and the name of the outcome from the text of the left-hand
side. Named arguments, e.g. `Surv(time = futime, event = status)` or
`Surv(futime, time2 = status)`, are therefore rewritten to
`Surv(futime, status)`. This is only done for right-censored data, i.e.,
the arguments `time` and, optionally, `time2` or `event`; other
combinations are left unchanged (and give an error later on).

## Usage

``` r
unname_surv_args(fixed)
```

## Arguments

- fixed:

  a formula or a list of formulas (other elements, e.g. `NULL`, are
  returned unchanged)

## Value

`fixed`, with the left-hand side
[`Surv()`](https://nerler.github.io/JointAI/reference/Surv.md) written
with unnamed arguments where it had named arguments
