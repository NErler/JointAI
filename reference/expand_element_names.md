# Write out the elements of a range of elements

Write out the elements of a range of elements

## Usage

``` r
expand_element_names(element)
```

## Arguments

- element:

  a requested element or range of elements of a node, as given to JAGS
  (e.g., `"b_y_id[5,1:2]"`)

## Value

a character vector with one name per element, as JAGS names the columns
of the samples, with the first index varying fastest (e.g.,
`c("b_y_id[5,1]", "b_y_id[5,2]")`)
