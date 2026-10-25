# Convert labelled variables

Variables of class `"labelled"` (Hmisc, haven \< 2.0.0) or
`"haven_labelled"` (haven \>= 2.0.0), e.g., from data imported from
SPSS, are converted:

- Variables with value labels (attribute `"labels"`) become unordered
  factors. Observed values without a label become levels named by their
  value; labels of values that do not occur in the data are not used.

- Variables without value labels keep their values; only the labelled
  class is removed.

## Usage

``` r
convert_labelled(data, allvars, mess = TRUE, ref_data = NULL)
```

## Arguments

- data:

  a `data.frame`

- allvars:

  vector of names of the variables used in the model

- mess:

  logical, if `TRUE` a message lists the variables that were converted
  to factors

- ref_data:

  optional `data.frame` with the reference factor levels

## Value

the `data.frame` with the converted variables

## Details

The variable label (attribute `"label"`) is kept. SPSS user-defined
missing values (class `"haven_labelled_spss"`) are not treated as
missing.

When `ref_data` is given (e.g., the data of a fitted model, when `data`
is new data for prediction), factors get the levels of the corresponding
factor in `ref_data`, and values without such a level become `NA` (with
a warning).
