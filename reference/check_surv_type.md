# Check that a survival outcome is right-censored

Gives an error for any other type of
[`Surv()`](https://nerler.github.io/JointAI/reference/Surv.md) outcome,
because the models in JointAI assume right-censoring and use the first
column of the survival object as the time and the second as the event
indicator.

## Usage

``` r
check_surv_type(lhs, data)
```

## Arguments

- lhs:

  character string; the left hand side of a model formula. Anything that
  is not a call to
  [`Surv()`](https://nerler.github.io/JointAI/reference/Surv.md) is
  ignored.

- data:

  a `data.frame`; used to evaluate the argument `type`, in case it is
  not given as a character string.

## Value

`NULL`, invisibly; called for the error.

## Details

The type is derived from the call and not from
`attr(Surv(...), "type")`:
[`convert_variables()`](https://nerler.github.io/JointAI/reference/convert_variables.md)
turns a binary event indicator into a factor, and with a factor
[`Surv()`](https://nerler.github.io/JointAI/reference/Surv.md) ignores
`type` and returns "mright" or "mcounting".

## Note

Used in `extract_outcome_data()`.
