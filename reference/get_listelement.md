# Get an element of a list, return a default value if it does not exist

A small helper function to extract an element of a list and return a
default value if the element does not exist (i.e., is `NULL`).

## Usage

``` r
get_listelement(object, element, null_value = 0)
```

## Arguments

- object:

  a `list`

- element:

  the name of the element to extract (a character string)

- null_value:

  the value to return if the element does not exist

## Value

the value of `object[[element]]` or `null_value` if `object[[element]]`
is `NULL`
