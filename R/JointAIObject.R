#' Fitted object of class JointAI
#'
#' An object returned by one of the functions \code{\link{lm_imp}()},
#' \code{\link{glm_imp}()} or \code{\link{lme_imp}()}.
#'
#' @name JointAIObject
#'
#' @return
#' \item{\code{analysis_type}}{\code{lm}, \code{glm}, \code{lme}, \code{glme} or
#'                             \code{survreg} with attributes
#'                             \code{family} and \code{link}}
#' \item{\code{data}}{the original dataset}
#' \item{\code{meth}}{named vector specifying imputation methods and sequence}
#' \item{\code{fixed}}{supplied fixed effects structure}
#' \item{\code{random}}{supplied random effects structure}
#' \item{\code{Mlist}}{a list: containing the data, split up into
#'       \itemize{
#'         \item outcome (\code{y})
#'         \item cross-sectional main effects (\code{Xc})
#'         \item cross-sectional interactions (\code{Xic})
#'         \item longitudinal main effects (\code{Xl})
#'         \item longitudinal interactions (\code{Xil})
#'         \item categorical incomplete variables (\code{Xcat})
#'         \item transformed cross-sectional variables (\code{Xtrafo})
#'         \item random effects design matrix (\code{Z})
#'       }
#'       and other important specifications:
#'       \itemize{
#'         \item specification for transformations (\code{trafos})
#'         \item specification for hierarchical centering (\code{hc_list})
#'         \item reference values and dummies for categorical variables (\code{refs})
#'         \item vector of auxiliary variables (\code{auxvars})
#'         \item grouping specification (\code{groups})
#'         \item the vector of variables to be scaled (\code{scale_vars})
#'         \item updated fixed effects structure (\code{fixed2})
#'         \item list of names of covariates in the main analysis (\code{names_main})
#'       }}
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
#'      \item{\code{inits}}{a list containing the initial values that were used}
#'      }}
#' \item{\code{monitor_params}}{the list of parameter groups to be monitored}
#' \item{\code{data_list}}{list with data that was passed to JAGS}
#' \item{\code{scale_pars}}{matrix with parameters used to center and scale the continuous variables}
#' \item{\code{hyperpars}}{a list containing the values of the hyperparameters used}
#' \item{\code{imp_par_list}}{a list with parameters used to write the imputation model syntax}
#' \item{\code{model}}{JAGS model}
#' \item{\code{sample}}{MCMC sample (Note: if continuous variables have been scaled
#' during the sampling, the posterior sample here is on the scaled scale, not on
#' the original scale.)}
#' \item{\code{MCMC}}{if scaling was done: MCMC sample, scaled back to original scale}
#' \item{\code{time}}{the computational time used for the sampling (adaptive phase + sampling)}
#' \item{\code{call}}{the original call}
#'

NULL
