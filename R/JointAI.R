#' JointAI: Joint Analysis and Imputation of Incomplete Data
#'
#' The \strong{JointAI} package performs simultaneous imputation and inference for
#' incomplete data using the Bayesian framework.
#' Distributions of incomplete variables, conditional on other covariates,
#' are specified automatically and modeled jointly with the analysis model.
#' MCMC sampling is performed in \href{http://mcmc-jags.sourceforge.net}{'JAGS'}
#' via the R package \href{https://CRAN.R-project.org/package=rjags}{\strong{rjags}}.
#'
#'
#' @section Main functions:
#' The package has the following main functions that allow analysis in different
#' settings:
#' \itemize{
#' \item \code{\link{lm_imp}} for linear regression
#' \item \code{\link{glm_imp}} for generalized linear regression
#' \item \code{\link{clm_imp}} for cumulative logit models
#' \item \code{\link{lme_imp}} for linear mixed models
#' \item \code{\link{glme_imp}} for generalized linear mixed models
#' \item \code{\link{clmm_imp}} for cumulative logit mixed models
#' \item \code{\link{survreg_imp}} for parametric (Weibull) survival models
#' \item \code{\link{coxph_imp}} for Cox proportional hazard models
#' }
#'
#' As far as possible, the specification of these functions is analogue to the
#' specification of their complete data versions
#' \code{\link[stats]{lm}}, \code{\link[stats]{glm}},
#' \code{\link[ordinal]{clm}} (from the package \href{https://CRAN.R-project.org/package=ordinal}{\strong{ordinal}}),
#' \code{\link[nlme]{lme}} (from the package \href{https://CRAN.R-project.org/package=nlme}{\strong{nlme}}),
#' \code{\link[ordinal:clmmOld]{clmm2}} (from the package \href{https://CRAN.R-project.org/package=ordinal}{\strong{ordinal}}),
#' \code{\link[survival]{survreg}} (from the package \href{https://CRAN.R-project.org/package=survival}{\strong{survival}}) and
#' \code{\link[survival]{coxph}} (from the package \href{https://CRAN.R-project.org/package=survival}{\strong{survival}}).
#'
#'
#' Results can be summarized and printed with \code{\link{summary.JointAI}},
#' \code{\link{coef.JointAI}} and \code{\link{confint.JointAI}},
#' and visualized using
#' \code{\link{traceplot}} or \code{\link{densplot}}.
#' The function \code{\link{predict.JointAI}} allows prediction (including credible intervals)
#' from \code{JointAI} models.
#'
#'
#' @section Evaluation and export:
#' Two criteria for evaluation of convergence and precision of the posterior
#' estimate are available:
#' \itemize{
#' \item \code{\link{GR_crit}} implements the Gelman-Rubin criterion ('potential scale reduction factor') for convergence
#' \item \code{\link{MC_error}} calculates the Monte Carlo error to evaluate the precision of the MCMC sample
#' }
#'
#' Imputed data can be extracted (and exported to SPSS) using \code{\link{get_MIdat}}.
#' The function \code{\link{plot_imp_distr}} allows visual comparison of the
#' distribution of observed and imputed values.
#'
#' @section Other useful functions:
#' \itemize{
#' \item \code{\link{parameters}} and \code{\link{list_impmodels}} to gain
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
#'      and barplots for all variables in the data)  and \code{\link{md_pattern}}
#'      (plotting or printing the missing data pattern).
#'
#' \item \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html}{\emph{Model Specification}}:\cr
#' Explanation and demonstration of all parameters that are required or optional
#' to specify the model structure in \code{\link{lm_imp}}, \code{\link{glm_imp}}
#' and \code{\link{lme_imp}}.
#' Among others, the functions \code{\link{parameters}}, \code{\link{list_impmodels}},
#' \code{\link{get_imp_meth}} and \code{\link{set_refcat}} are used.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{\emph{Parameter Selection}}:\cr
#' Examples on how to select the parameters/variables/nodes
#'                                 to follow using the argument \code{monitor_params}
#'                                 and the parameters/variables/nodes displayed
#'                                 in the \code{\link{summary}}, \code{\link{traceplot}},
#'                                 \code{\link{densplot}} or when using
#'                                 \code{\link{GR_crit}} or \code{\link{MC_error}}.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/MCMCsettings.html}{\emph{MCMC Settings}}:\cr
#' Examples demonstrating how to set the arguments controlling settings of the MCMC sampling,
#' i.e., \code{n.adapt}, \code{n.iter}, \code{n.chains}, \code{thin}, \code{inits}.
#'
#' \item \href{https://nerler.github.io/JointAI/articles/AfterFitting.html}{\emph{After Fitting}}:\cr
#' Examples on the use of functions to be applied after the model has been fitted,
#' including \code{\link{traceplot}}, \code{\link{densplot}}, \code{\link{summary}},
#' \code{\link{GR_crit}}, \code{\link{MC_error}}, \code{\link{predict}},
#' \code{\link{predDF}} and \code{\link{get_MIdat}}.
#'}
#' @references Erler, N.S., Rizopoulos, D., Rosmalen, J., Jaddoe, V.W.V.,
#' Franco, O. H., & Lesaffre, E.M.E.H. (2016).
#' Dealing with missing covariates in epidemiologic studies: A comparison
#' between multiple imputation and a full Bayesian approach.
#' \emph{Statistics in Medicine}, 35(17), 2955-2974.
#' doi: \href{https://doi.org/10.1002/sim.6944}{10.1002/sim.6944}
#'
#' Erler, N.S., Rizopoulos D., Jaddoe, V.W.V., Franco, O.H. & Lesaffre, E.M.E.H. (2019).
#' Bayesian imputation of time-varying covariates in linear mixed models.
#' \emph{Statistical Methods in Medical Research}, 28(2), 555–568.
#' doi: \href{https://doi.org/10.1177/0962280217730851}{10.1177/0962280217730851}
#'
#' @import graphics
#' @import coda
#' @import utils
#' @import rjags
#' @import stats
#'
#'
#' @docType package
#' @name JointAI
NULL


.onLoad <- function(libname, pkgname) {
  rjags::load.module("glm", quiet = TRUE)
  message("This is new software. Please report any bugs to the package maintainer.")
}


utils::globalVariables(c("i", "value", "chain", "iteration"))


#' Parameters used by several functions in JointAI.
#' @param object object inheriting from class 'JointAI'
#' @param no_model names of variables for which no model should be specified.
#'                 Note that this is only possible for completely observed
#'                 variables and may imply assumptions of independence between
#'                 the excluded variable and incomplete variables.
#' @param subset subset of parameters/variables/nodes (columns in the MCMC sample).
#'               Uses the same logic as the argument \code{monitor_params} in
#'               \code{\link{lm_imp}}, \code{\link{glm_imp}}, \code{\link{clm_imp}},
#'               \code{\link{lme_imp}}, \code{\link{glme_imp}}, \code{\link{survreg_imp}}
#'               and \code{\link{coxph_imp}}.
#' @param start the first iteration of interest (see \code{\link[coda]{window.mcmc}})
#' @param end the last iteration of interest (see \code{\link[coda]{window.mcmc}})
#' @param thin thinning interval (see \code{\link[coda]{window.mcmc}})
#' @param nrow,ncol optional number of rows and columns in the plot layout;
#'                  automatically chosen if unspecified
#' @param use_ggplot logical; Should ggplot be used instead of the base graphics?
#' @param warn logical; should warnings be given? Default is
#'             \code{TRUE}. Note: this applies only to warnings
#'             given directly by \strong{JointAI}.
#' @param mess logical; should messages be given? Default is
#'             \code{TRUE}. Note: this applies only to messages
#'             given directly by \strong{JointAI}.
#' @param xlab,ylab labels for the x- and y-axis
#' @param use_level logical; should the multi-level structure be taken into account?
#'        This requires specification of the argument \code{idvar}.
#' @param idvar name of the column that specifies the multi-level grouping structure
#' @param keep_aux logical; Should constant effects of auxiliary variables be kept in the output?
#' @param ridge logical; should the parameters of the main model be penalized using ridge regression? Default is \code{FALSE}
#' @param parallel logical; should the chains be sampled using parallel computation? Default is \code{FALSE}
#' @param ncores number of cores to use for parallel computation; if left empty all except two cores will be used
#' @param seed optional seed value for reproducibility
#' @param ppc logical: should monitors for posterior predictive checks be set? (not yet used)
#' @name sharedParams
NULL





# define family weibull
weibull <- function(link = 'log') {
  structure(list(family = "weibull", link = 'log'),
            class = "family")
}

ordinal <- function(link = 'identity') {
  structure(list(family = "ordinal", link = 'identity'),
            class = "family")
}

# define family coxph
prophaz <- function(link = 'log') {
  structure(list(family = "prophaz", link = 'log'),
            class = "family")
}
