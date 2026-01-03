# Generate a Basis Matrix for Natural Cubic Splines

This function just calls `ns()` from the
[**splines**](https://CRAN.R-project.org/package=splines) package.

## Usage

``` r
ns(x, df = NULL, knots = NULL, intercept = FALSE,
  Boundary.knots = range(x))
```

## Arguments

- x:

  the predictor variable. Missing values are allowed.

- df:

  degrees of freedom. One can supply `df` rather than knots; `ns()` then
  chooses `df - 1 - intercept` knots at suitably chosen quantiles of `x`
  (which will ignore missing values). The default, `df = NULL`, sets the
  number of inner knots as `length(knots)`.

- knots:

  breakpoints that define the spline. The default is no knots; together
  with the natural boundary conditions this results in a basis for
  linear regression on `x`. Typical values are the mean or median for
  one knot, quantiles for more knots. See also `Boundary.knots`.

- intercept:

  if `TRUE`, an intercept is included in the basis; default is `FALSE`.

- Boundary.knots:

  boundary points at which to impose the natural boundary conditions and
  anchor the B-spline basis (default the range of the data). If both
  `knots` and `Boundary.knots` are supplied, the basis parameters do not
  depend on `x`. Data can extend beyond `Boundary.knots`
