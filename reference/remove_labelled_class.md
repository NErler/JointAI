# Remove the labelled class from a vector

Remove the labelled class from a vector

## Usage

``` r
remove_labelled_class(x)
```

## Arguments

- x:

  a vector of class `"labelled"` or `"haven_labelled"`

## Value

`x` without the labelled classes (and without classes that only describe
the base type), so that e.g. a numeric vector is plain numeric again;
other attributes are kept
