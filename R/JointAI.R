#' JointAI: Joint Analysis and Imputation of Incomplete Data
#'
#' The \strong{JointAI} package performs simultaneous imputation and inference
#' for incomplete or complete data under the Bayesian framework.
#' Models for incomplete covariates, conditional on other covariates,
#' are specified automatically and modelled jointly with the analysis model.
#' MCMC sampling is performed in \href{https://mcmc-jags.sourceforge.io/}{'JAGS'}
#' via the R package
#' \href{https://CRAN.R-project.org/package=rjags}{\strong{rjags}}.
#'
#'
#' @section Main functions:
#' \strong{JointAI} provides the following main functions that facilitate
#' analysis with different models:
#' \itemize{
#' \item \code{\link{lm_imp}} for linear regression
#' \item \code{\link{glm_imp}} for generalized linear regression
#' \item \code{\link{betareg_imp}} for regression using a beta distribution
#' \item \code{\link{lognorm_imp}} for regression using a log-normal
#'                                   distribution
#' \item \code{\link{clm_imp}} for (ordinal) cumulative logit models
#' \item \code{\link{mlogit_imp}} for multinomial models
#'
#' \item \code{\link{lme_imp}} or \code{\link{lmer_imp}} for linear mixed models
#' \item \code{\link{glme_imp}} or \code{\link{glmer_imp}} for generalized
#'                                 linear mixed models
#' \item \code{\link{betamm_imp}} for mixed models using a beta distribution
#' \item \code{\link{lognormmm_imp}} for mixed models using a log-normal
#'                                   distribution
#' \item \code{\link{clmm_imp}} for (ordinal) cumulative logit mixed models
#'
#' \item \code{\link{survreg_imp}} for parametric (Weibull) survival models
#' \item \code{\link{coxph_imp}} for (Cox) proportional hazard models
#' \item \code{\link{JM_imp}} for joint models of longitudinal and survival data
#' }
#'
#' As far as possible, the specification of these functions is analogous to the
#' specification of widely used functions for the analysis of complete data,
#' such as
#' \code{\link[stats]{lm}}, \code{\link[stats]{glm}},
#' \code{\link[nlme]{lme}} (from the package
#' \href{https://CRAN.R-project.org/package=nlme}{\strong{nlme}}),
#' \code{\link[survival]{survreg}} (from the package
#' \href{https://CRAN.R-project.org/package=survival}{\strong{survival}}) and
#' \code{\link[survival]{coxph}} (from the package
#' \href{https://CRAN.R-project.org/package=survival}{\strong{survival}}).
#'
#' Computations can be performed in parallel to reduce computational time,
#' using the package \pkg{future},
#' the argument \code{shrinkage} allows the user to impose a penalty on the
#' regression coefficients of some or all models involved,
#' and hyper-parameters can be changed via the argument \code{hyperpars}.
#'
#'
#' To obtain summaries of the results, the functions
#' \code{\link[JointAI:summary.JointAI]{summary()}},
#' \code{\link[JointAI:summary.JointAI]{coef()}} and
#' \code{\link[JointAI:summary.JointAI]{confint()}} are available, and
#' results can be visualized with the help of
#' \code{\link[JointAI:traceplot]{traceplot()}} or
#' \code{\link[JointAI:densplot]{densplot()}}.
#'
#' The function \code{\link[JointAI:predict.JointAI]{predict()}} allows
#' prediction (including credible intervals) from \code{JointAI} models.
#'
#'
#' @section Evaluation and export:
#' Two criteria for evaluation of convergence and precision of the posterior
#' estimate are available:
#' \itemize{
#' \item \code{\link{GR_crit}} implements the Gelman-Rubin criterion
#'       ('potential scale reduction factor') for convergence
#' \item \code{\link{MC_error}} calculates the Monte Carlo error to evaluate
#'       the precision of the MCMC sample
#' }
#'
#' Imputed data can be extracted (and exported to SPSS) using
#' \code{\link[JointAI:get_MIdat]{get_MIdat()}}.
#' The function \code{\link[JointAI:plot_imp_distr]{plot_imp_distr()}} allows
#' visual comparison of the distribution of observed and imputed values.
#'
#' @section Other useful functions:
#' \itemize{
#' \item \code{\link{parameters}} and \code{\link{list_models}} to gain
#'       insight in the specified model
#' \item \code{\link{plot_all}} and \code{\link{md_pattern}} to visualize the
#'       distribution of the data and the missing data pattern
#' }
#'
#' @section Vignettes:
#' The following vignettes are available
#' \itemize{
#' \item \href{https://nerler.github.io/JointAI/articles/MinimalExample.html}{\emph{Minimal Example}}:\cr
#' A minimal example demonstrating the use of
#'                            \code{\link{lm_imp}},
#'                            \code{\link{summary.JointAI}},
#'                            \code{\link{traceplot}}
#'                            and \code{\link{densplot}}.
#' \item \href{https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html}{\emph{Visualizing Incomplete Data}}:\cr
#' Demonstrations of the options in \code{\link{plot_all}} (plotting histograms
#' and bar plots for all variables in the data)  and \code{\link{md_pattern}}
#' (plotting or printing the missing data pattern).
#'
#' \item \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html}{\emph{Model Specification}}:\cr
#' Explanation and demonstration of all parameters that are required or optional
#' to specify the model structure in \code{\link{lm_imp}},
#' \code{\link{glm_imp}} and \code{\link{lme_imp}}.
#' Among others, the functions \code{\link{parameters}},
#' \code{\link{list_models}} and \code{\link{set_refcat}} are used.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{\emph{Parameter Selection}}:\cr
#'       Examples on how to select the parameters/variables/nodes
#'       to follow using the argument \code{monitor_params} and the
#'       parameters/variables/nodes displayed in the \code{\link{summary}},
#'       \code{\link{traceplot}}, \code{\link{densplot}} or when using
#'       \code{\link{GR_crit}} or \code{\link{MC_error}}.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/MCMCsettings.html}{\emph{MCMC Settings}}:\cr
#'       Examples demonstrating how to set the arguments controlling settings
#'       of the MCMC sampling,
#'       i.e., \code{n.adapt}, \code{n.iter}, \code{n.chains}, \code{thin},
#'        \code{inits}.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/AfterFitting.html}{\emph{After Fitting}}:\cr
#'       Examples on the use of functions to be applied after the model has
#'       been fitted, including \code{\link{traceplot}}, \code{\link{densplot}},
#'       \code{\link{summary}}, \code{\link{GR_crit}}, \code{\link{MC_error}},
#'       \code{\link{predict}}, \code{\link{predDF}} and
#'       \code{\link{get_MIdat}}.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/TheoreticalBackground.html}{\emph{Theoretical Background}}:\cr
#'       Explanation of the statistical method implemented in \strong{JointAI}.
#'}
#' @references
#' Erler NS, Rizopoulos D, Lesaffre EMEH (2021).
#' "JointAI: Joint Analysis and Imputation of Incomplete Data in R."
#' _Journal of Statistical Software_, *100*(20), 1-56.
#' \doi{10.18637/jss.v100.i20}.
#'
#' Erler, N.S., Rizopoulos, D., Rosmalen, J., Jaddoe, V.W.V.,
#' Franco, O. H., & Lesaffre, E.M.E.H. (2016).
#' Dealing with missing covariates in epidemiologic studies: A comparison
#' between multiple imputation and a full Bayesian approach.
#' \emph{Statistics in Medicine}, 35(17), 2955-2974.
#' \doi{10.1002/sim.6944}
#'
#' Erler, N.S., Rizopoulos D., Jaddoe, V.W.V., Franco, O.H. & Lesaffre, E.M.E.H. (2019).
#' Bayesian imputation of time-varying covariates in linear mixed models.
#' \emph{Statistical Methods in Medical Research}, 28(2), 555–568.
#' \doi{10.1177/0962280217730851}
#'
#' @import graphics
#' @import utils
#' @import stats
#' @importFrom rjags coda.samples jags.model
#' @import future
#' @import mathjaxr
#' @importFrom splines bs ns
#'
#' @docType package
#' @name JointAI
NULL


#' Create a Survival Object
#'
#' This function just calls \code{Surv()} from the
#' \href{https://CRAN.R-project.org/package=survival}{\strong{survival}}
#' package.
#'
#' @inheritParams survival::Surv
#' @export
#' @keywords internal
Surv <- survival::Surv



#' Generate a Basis Matrix for Natural Cubic Splines
#'
#' This function just calls \code{ns()} from the
#' \href{https://CRAN.R-project.org/package=splines}{\strong{splines}}
#' package.
#'
#' @inheritParams splines::ns
#' @export
#' @keywords internal
ns <- splines::ns


#' B-Spline Basis for Polynomial Splines
#'
#' This function just calls \code{bs()} from the
#' \href{https://CRAN.R-project.org/package=splines}{\strong{splines}}
#' package.
#'
#' @inheritParams splines::bs
#' @export
#' @keywords internal
# bs <- splines::bs

bs <- function(x, df = NULL, knots = NULL, degree = 3, intercept = FALSE,
               Boundary.knots = range(x), warn.outside = TRUE) {

  defargs <- formals(splines::bs)
  args <- sapply(names(defargs), function(k)
    get(k), simplify = FALSE)

  do.call(splines::bs, args)
}



.onLoad <- function(libname, pkgname) {
  rjags::load.module("glm", quiet = TRUE)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Please report any bugs to the package maintainer (https://github.com/NErler/JointAI/issues)."
  )
}


utils::globalVariables(c("i", "value", "chain", "iteration"))


#' Parameters used by several functions in JointAI
#' @param object object inheriting from class 'JointAI'
#' @param no_model optional; vector of names of variables for which no model
#'                 should be specified.
#'                 Note that this is only possible for completely observed
#'                 variables and implies the assumptions of independence between
#'                 the excluded variable and the incomplete variables.
#' @param timevar name of the variable indicating the time of the measurement of
#'                a time-varying covariate in a proportional hazards survival
#'                model (also in a joint model).
#'                The variable specified in
#'                "timevar" will automatically be added to "no_model".
#' @param assoc_type named vector specifying the type of the association used
#'                   for a time-varying covariate in the linear predictor of the
#'                   survival model when using a "JM" model.
#'                   Implemented options are "underl.value"
#'                   (linear predictor; default for covariates modelled using a
#'                   Gaussian, Gamma, beta or log-normal distribution)
#'                   covariates) and "obs.value" (the observed/imputed value;
#'                   default for covariates modelled using other distributions).
#' @param subset subset of parameters/variables/nodes (columns in the MCMC
#'               sample). Follows the same principle as the argument
#'               \code{monitor_params} in
#'               \code{\link[JointAI:model_imp]{*_imp}}.
#' @param exclude_chains optional vector of the index numbers of chains that
#'                       should be excluded
#' @param start the first iteration of interest
#'              (see \code{\link[coda]{window.mcmc}})
#' @param end the last iteration of interest
#'            (see \code{\link[coda]{window.mcmc}})
#' @param n.adapt number of iterations for adaptation of the MCMC samplers
#'                (see \code{\link[rjags]{adapt}})
#' @param n.iter number of iterations of the MCMC chain (after adaptation;
#'               see \code{\link[rjags]{coda.samples}})
#' @param n.chains number of MCMC chains
#' @param quiet logical; if \code{TRUE} then messages generated by
#'              \strong{rjags} during compilation as well as the progress bar
#'              for the adaptive phase will be suppressed,
#'              (see \code{\link[rjags]{jags.model}})
#' @param progress.bar character string specifying the type of
#'                 progress bar. Possible values are "text" (default), "gui",
#'                 and "none" (see \code{\link[rjags]{update}}). Note: when
#'                 sampling is performed in parallel it is not possible to
#'                 display a progress bar.
#' @param thin thinning interval (integer; see \code{\link[coda]{window.mcmc}}).
#'             For example, \code{thin = 1} (default) will keep the MCMC samples
#'             from all iterations; \code{thin = 5} would only keep every 5th
#'             iteration.
#' @param nrow optional; number of rows in the plot layout;
#'                  automatically chosen if unspecified
#' @param ncol optional; number of columns in the plot layout;
#'                  automatically chosen if unspecified
#' @param use_ggplot logical; Should ggplot be used instead of the base
#'                   graphics?
#' @param warn logical; should warnings be given? Default is
#'             \code{TRUE}.
#' @param mess logical; should messages be given? Default is
#'             \code{TRUE}.
#' @param xlab,ylab labels for the x- and y-axis
#' @param idvars name of the column that specifies the multi-level grouping
#'               structure
#' @param seed optional; seed value (for reproducibility)
#' @param ppc logical: should monitors for posterior predictive checks be
#'                     set? (not yet used)
#' @param rd_vcov optional character string or list (of lists or character
#'                strings) specifying the structure of the variance covariance
#'                matrix/matrices of the random effects for multivariate
#'                mixed models. Options are  `"full`, `"blockdiag"` (default)
#'                and `"indep"`. Different structures can be specified per
#'                grouping level (in multi-level models with more than two
#'                levels) by specifying a list with elements per grouping
#'                level. To specify different structures for different
#'                outcomes, a list (maybe nested in the list per grouping
#'                level) can be specified. This list should have the type
#'                of structure as names and contain vectors of variable
#'                names that belong to the respective structure.
#' @name sharedParams
NULL

