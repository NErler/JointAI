#' Fitted object of class JointAI
#'
#' An object returned by one of the functions \code{\link{lm_imp}()},
#' \code{\link{glm_imp}()} or \code{\link{lme_imp}()}.
#'
#' @name JointAIObject
#'
#' @return
#' \item{\code{analysis_type}}{\code{lm}, \code{glm} or \code{lme}, with attributes
#'                             \code{family} and \code{link}}
#' \item{\code{data}}{the original dataset}
#' \item{\code{meth}}{named vector specifying imputation methods and sequence}
#' \item{\code{fixed}}{supplied fixed effects structure}
#' \item{\code{random}}{supplied random effects structure}
#' \item{\code{Mlist}}{a list of matrices that contain the data split up into
#'        outcome (y), cross-sectional main effects (Xc), cross-sectional interactions (Xic),
#'        longitudinal main effects (Xl), longitudinal interactions (Xil),
#'        categorical incomplete variables (Xcat), transformed cross-sectional
#'        variables (Xtrafo), random effects design matrix (Z),
#'        the vector of variables to be scaled (scale_vars), reference values
#'        and dummies for categorical variables (refs), specification for
#'        transformations (trafos), specification for hierarchical centering (hc_list),
#'        vector of auxiliary variables (auxvars), grouping specification (groups),
#'        updated fixed effects structure (fixed2), names of updated design matrix
#'        (X2_names)}
#' \item{\code{refcats}}{A list naming the reference categories for all categorical covariates.}
#' \item{\code{K}}{matrix specifying the indices of the regression coefficients
#' that are related to different parts of the model}
#' \item{\code{K_imp}}{matrix specifying the indices of regression coefficients
#' for the imputation models relating to different covariates}
#' \item{\code{mcmc_settings}}{a list with elements
#'      \describe{
#'      \item{\code{MCMCpackage}}{which package has been used (at the moment only JAGS is implemented)}
#'      \item{\code{modelfile}}{name and path of JAGS model file}
#'      \item{\code{n.chains}}{number of MCMC chains}
#'      \item{\code{n.adapt}}{number of iterations in the adaptive phase}
#'      \item{\code{n.iter}}{number of iterations in the MCMC sample}
#'      \item{\code{variable.names}}{monitored nodes}
#'      \item{\code{thin}}{thinning of the MCMC sample}
#'      \item{\code{inits}}{a list containing the inital values that were used}
#'      }}
#' \item{\code{data_list}}{list with data that was passed to JAGS}
#' \item{\code{scale_pars}}{matrix with parameters used to center and scale the continuous variables}
#' \item{\code{hyperpars}}{a list containing the values of the hyperparameters used}
#' \item{\code{model}}{JAGS model}
#' \item{\code{sample}}{MCMC sample (Note: if continuous variables have been scaled
#' during the sampling, the posterior sample here is on the scaled scale, not on
#' the original scale.)}
#' \item{\code{MCMC}}{if scaling was done: MCMC sample, scaled back to original scale}
#' \item{\code{time}}{the computational time used for the sampling (adaptive phase + sampling)}
#' \item{\code{call}}{the original call}
#'

NULL
