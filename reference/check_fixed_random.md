# Check whether fixed or formula contains a random effects specification

Checks if the objects provided to the `formula` and `fixed` arguments
contain a random effects specification. This function is used in random
effects models. In case the combined fixed and random effects formula is
part of the `fixed` element, it is moved into the `formula` element.

## Usage

``` r
check_fixed_random(arglist)
```

## Arguments

- arglist:

  A list containing 'fixed', 'random', and 'formula' elements.

## Value

The updated arglist.arglist
