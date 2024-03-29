% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/JointAI.R
\name{bs}
\alias{bs}
\title{B-Spline Basis for Polynomial Splines}
\usage{
bs(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
  Boundary.knots = range(x), warn.outside = TRUE)
}
\arguments{
\item{x}{the predictor variable.  Missing values are allowed.}

\item{df}{degrees of freedom; one can specify \code{df} rather than
    \code{knots}; \code{bs()} then chooses \code{df-degree} (minus one
    if there is an intercept) knots at suitable quantiles of \code{x}
    (which will ignore missing values).  The default, \code{NULL},
    takes the number of inner knots as \code{length(knots)}.  If that is
    zero as per default, that corresponds to \code{df = degree - intercept}.}

\item{knots}{the \emph{internal} breakpoints that define the
    spline.  The default is \code{NULL}, which results in a basis for
    ordinary polynomial regression.  Typical values are the mean or
    median for one knot, quantiles for more knots.  See also
    \code{Boundary.knots}.}

\item{degree}{degree of the piecewise polynomial---default is \code{3} for
    cubic splines.}

\item{intercept}{if \code{TRUE}, an intercept is included in the
    basis; default is \code{FALSE}.}

\item{Boundary.knots}{boundary points at which to anchor the B-spline
    basis (default the range of the non-\code{\link{NA}} data).  If both
    \code{knots} and \code{Boundary.knots} are supplied, the basis
    parameters do not depend on \code{x}.  Data can extend beyond
    \code{Boundary.knots}.}

\item{warn.outside}{\code{\link{logical}} indicating if a
    \code{\link{warning}} should be signalled in case some \code{x} values
    are outside the boundary knots.}
}
\description{
This function just calls \code{bs()} from the
\href{https://CRAN.R-project.org/package=splines}{\strong{splines}}
package.
}
\keyword{internal}
