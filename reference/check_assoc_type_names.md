# Check the names in `assoc_type`

The names in `assoc_type` have to be terms in the survival part of a
joint model that have an association type, i.e., a time-varying
covariate or a function of it. Anything else (which would otherwise be
ignored) is an error. A function with several columns is one term, and
an interaction has no name of its own: it uses the association types of
its elements. With several survival outcomes, a name has to apply to one
of them. Does nothing if the model has no survival part of a joint
model.

## Usage

``` r
check_assoc_type_names(assoc_type, info_list, Mlist)
```

## Arguments

- assoc_type:

  named vector of association types, as given by the user, or `NULL`

- info_list:

  list of model information, from `get_model_info()`

- Mlist:

  list of model information, as created by `divide_matrices()`

## Value

`NULL`, invisibly; called for its error.
