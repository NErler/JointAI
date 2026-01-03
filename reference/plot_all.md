# Visualize the distribution of all variables in the dataset

This function plots a grid of histograms (for continuous variables) and
bar plots (for categorical variables) and labels it with the proportion
of missing values in each variable.

## Usage

``` r
plot_all(data, nrow = NULL, ncol = NULL, fill = grDevices::grey(0.8),
  border = "black", allNA = FALSE, idvars = NULL, xlab = "",
  ylab = "frequency", ...)
```

## Arguments

- data:

  a `data.frame` (or a `matrix`)

- nrow:

  optional; number of rows in the plot layout; automatically chosen if
  unspecified

- ncol:

  optional; number of columns in the plot layout; automatically chosen
  if unspecified

- fill:

  colour the histograms and bars are filled with

- border:

  colour of the borders of the histograms and bars

- allNA:

  logical; if `FALSE` (default) the proportion of missing values is only
  given for variables that have missing values, if `TRUE` it is given
  for all variables

- idvars:

  name of the column that specifies the multi-level grouping structure

- xlab, ylab:

  labels for the x- and y-axis

- ...:

  additional parameters passed to
  [`barplot`](https://rdrr.io/r/graphics/barplot.html) and
  [`hist`](https://rdrr.io/r/graphics/hist.html)

## See also

Vignette: [Visualizing Incomplete
Data](https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html)

## Examples

``` r
op <- par(mar = c(2,2,3,1), mgp = c(2, 0.6, 0))
plot_all(wideDF)

par(op)
```
