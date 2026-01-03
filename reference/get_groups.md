# Get grouping information

A helper function that generates grouping information from a data.frame
and a character vector with the names of grouping variables. In all
cases, the level "lvlone" is added to indicate the lowest level of the
data (i.e., each observation is its own group).

## Usage

``` r
get_groups(idvars, data)
```

## Arguments

- idvars:

  a character vector with the names of grouping variables

- data:

  a data.frame

## Value

a list with grouping information for each grouping level: each element
is a vector of length `nrow(data)` with the group membership indices of
each observation for the corresponding grouping level.
