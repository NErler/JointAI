# Extract multiple imputed datasets from an object of class JointAI

This function returns a dataset containing multiple imputed datasets
stacked onto each other (i.e., long format; optionally including the
original, incomplete data).  
These data can be automatically exported to SPSS (as a .txt file
containing the data and a .sps file containing syntax to generate a .sav
file). For the export function the
[**foreign**](https://CRAN.R-project.org/package=foreign) package needs
to be installed.

## Usage

``` r
get_MIdat(object, m = 10, include = TRUE, start = NULL, minspace = 50,
  seed = NULL, export_to_SPSS = FALSE, resdir = NULL, filename = NULL)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- m:

  number of imputed datasets

- include:

  should the original, incomplete data be included? Default is `TRUE`.

- start:

  the first iteration of interest (see
  [`window.mcmc`](https://rdrr.io/pkg/coda/man/window.mcmc.html))

- minspace:

  minimum number of iterations between iterations to be chosen as
  imputed values (to prevent strong correlation between imputed datasets
  in the case of high autocorrelation of the MCMC chains).

- seed:

  optional seed value

- export_to_SPSS:

  logical; should the completed data be exported to SPSS?

- resdir:

  optional; directory for results. If unspecified and
  `export_to_SPSS = TRUE` the current working directory is used.

- filename:

  optional; file name (without ending). If unspecified and
  `export_to_SPSS = TRUE` a name is generated automatically.

## Value

A `data.frame` in which the original data (if `include = TRUE`) and the
imputed datasets are stacked onto each other.  
The variable `Imputation_` indexes the imputation, while `.rownr` links
the rows to the rows of the original data. In cross-sectional datasets
the variable `.id` is added as subject identifier.

## Note

In order to be able to extract (multiple) imputed datasets the imputed
values must have been monitored, i.e., `imps = TRUE` had to be specified
in the argument `monitor_params` in [`*_imp`](model_imp.md).

## See also

[`plot_imp_distr`](plot_imp_distr.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# fit a model and monitor the imputed values with
# monitor_params = c(imps = TRUE)

mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF,
              monitor_params = c(imps = TRUE), n.iter = 100)

# Example 1: without export to SPSS
MIs <- get_MIdat(mod, m = 3, seed = 123)



# Example 2: with export for SPSS
# (here: to the temporary directory "temp_dir")

temp_dir <- tempdir()
MIs <- get_MIdat(mod, m = 3, seed = 123, resdir = temp_dir,
                 filename = "example_imputation",
                 export_to_SPSS = TRUE)

} # }
```
