#' JointAI: Joint Analysis and Imputation of Incomplete Data
#'
#' The \strong{JointAI} package performs simultaneous imputation and inference for
#' incomplete data using the Bayesian framework.
#' Distributions for incomplete variables are specified automatically and modeled
#' jointly with the analysis model.
#'
#'
#'
#' @section Main functions:
#' The package has three main functions, \code{\link{lm_imp}},
#' \code{\link{glm_imp}} and \code{\link{lme_imp}},
#' that allow analysis using linear regression, generalized linear regression
#' and linear mixed effects models. As far as possible, the specification of
#' the functions is the same as the specification of their complete data
#' versions \code{\link[stats]{lm}}, \code{\link[stats]{glm}} and
#' \code{\link[nlme]{lme}} (from the package
#' \href{https://CRAN.R-project.org/package=nlme}{\strong{nlme}}).
#'
#'
#' Results can be summarized and printed with \code{\link{summary.JointAI}},
#' and visualized using
#' \code{\link{traceplot}} or \code{\link{densplot}}.
#' The function \code{\link{predict.JointAI}} allows prediction (including credible intervals)
#' from \code{JointAI} models.
#'
#'
#' @section Evaluation and export:
#' Two criteria for evaluation of convergence and precision of the posterior
#' estimate are available:
#' \code{\link{GR_crit}} and \code{\link{MC_error}}.
#'
#' Imputed data can be extracted and exported to SPSS data using \code{\link{get_MIdat}}.
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
#'}
#' @references Erler, N. S., Rizopoulos, D., Rosmalen, J. V., Jaddoe,
#' V. W., Franco, O. H., & Lesaffre, E. M. (2016).
#' Dealing with missing covariates in epidemiologic studies: A comparison
#' between multiple imputation and a full Bayesian approach.
#' \emph{Statistics in Medicine}, 35(17), 2955-2974.
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
}


utils::globalVariables(c("Var1", "Var2", "iteration", "value", "chain"))

#' Parameters used by several functions in JointAI.
#' @param object object inheriting from class "JointAI"
#' @param subset subset of parameters/variables/nodes (columns in the MCMC sample).
#'               Uses the same logic as the argument \code{monitor_params} in
#'               \code{\link{lm_imp}}, \code{\link{glm_imp}} and \code{\link{lme_imp}}.
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
#'
#' @name sharedParams
NULL
