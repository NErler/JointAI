# Warn about unknown arguments of the `*_imp()` functions

Arguments of the `*_imp()` functions that are not arguments of
[`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
end up in the `...` of
[`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md),
where they are not used. A misspelled argument (e.g., `n.itre` instead
of `n.iter`) would otherwise be ignored silently (#114). A warning
rather than an error, so that existing code keeps running.

## Usage

``` r
warn_unknown_args(arg_names, known, warn = TRUE)
```

## Arguments

- arg_names:

  character vector; the names of the arguments that
  [`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
  was called with

- known:

  character vector; the names of the arguments that are used: the formal
  arguments of
  [`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
  and the elements that
  [`prep_arglist()`](https://nerler.github.io/JointAI/reference/prep_arglist.md)
  adds (`thecall`)

- warn:

  logical; if `FALSE`, no warning is given

## Value

`NULL` (invisibly); called for its warning

## Details

used in
[`model_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
(2026-11-06)
