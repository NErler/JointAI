#' JointAI: Joint Analysis and Imputation of Missing Values
#'
#' The JointAI package performs simultaneous imputation and inference for
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
#' versions (\code{\link[stats]{lm}}, \code{\link[stats]{glm}} and
#' \code{\link[nlme]{lme}}).
#'
#'
#' Results can be summarized and printed with \code{\link{summary.JointAI}},
#' and visualized using
#' \code{\link{traceplot}} or \code{\link{densplot}}.
#'
#'
#' @section Evaluation and export:
#' Two criteria for evaluation of convergence and precision of the posterior
#' estimate are available:
#' \code{\link{GR_crit}} and \code{\link{MC_error}}
#'
#' Imputed data can be exported to SPSS data using \code{\link{get_MIdat}}.
#'
#'
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