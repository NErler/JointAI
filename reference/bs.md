# B-Spline Basis for Polynomial Splines

This function just calls `bs()` from the
[**splines**](https://CRAN.R-project.org/package=splines) package.

## Usage

``` r
bs(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
  Boundary.knots = range(x), warn.outside = TRUE)
```

## Arguments

- x:

  the predictor variable. Missing values are allowed.

- df:

  degrees of freedom; one can specify `df` rather than `knots`; `bs()`
  then chooses `df-degree` (minus one if there is an intercept) knots at
  suitable quantiles of `x` (which will ignore missing values). The
  default, `NULL`, takes the number of inner knots as `length(knots)`.
  If that is zero as per default, that corresponds to
  `df = degree - intercept`.

- knots:

  the *internal* breakpoints that define the spline. The default is
  `NULL`, which results in a basis for ordinary polynomial regression.
  Typical values are the mean or median for one knot, quantiles for more
  knots. See also `Boundary.knots`.

- degree:

  degree of the piecewise polynomial—default is `3` for cubic splines.

- intercept:

  if `TRUE`, an intercept is included in the basis; default is `FALSE`.

- Boundary.knots:

  boundary points at which to anchor the B-spline basis (default the
  range of the non-[`NA`](https://rdrr.io/r/base/NA.html) data). If both
  `knots` and `Boundary.knots` are supplied, the basis parameters do not
  depend on `x`. Data can extend beyond `Boundary.knots`.

- warn.outside:

  [`logical`](https://rdrr.io/r/base/logical.html) indicating if a
  [`warning`](https://rdrr.io/r/base/warning.html) should be signalled
  in case some `x` values are outside the boundary knots.
