#' Fitted object of class 'JointAI'
#'
#' An object returned by one of the main functions
#' \code{\link[JointAI:model_imp]{*_imp}}.
#'
#' @name JointAIObject
#'
#' @return
#' \item{\code{analysis_type}}{\code{lm}, \code{glm}, \code{clm}, \code{lme},
#'                             \code{glme}, \code{clmm}, \code{survreg} or
#'                             \code{coxph} (with attributes
#'                             \code{family} and \code{link} for GLM-type
#'                             models}
#' \item{\code{formula}}{The formula used in the (analysis) model.}
#' \item{\code{data}}{original (incomplete, but pre-processed) data}
#' \item{\code{models}}{named vector specifying the the types of all sub-models}
#' \item{\code{fixed}}{a list of the fixed effects formulas of the sub-model(s)
#'                     for which the use had specified a formula}
#' \item{\code{random}}{a list of the random effects formulas of the
#'                      sub-model(s) for which the use had specified a formula}
#' \item{\code{Mlist}}{a list (for internal use) containing the data and
#'                     information extracted from the data and model formulas,
#'                     split up into
#'       \itemize{
#'         \item a named vector identifying the levels (in the hierarchy)
#'               of all variables (\code{Mlvls})
#'         \item a vector of the id variables that were extracted from the
#'               random effects formulas (\code{idvar})
#'         \item a list of grouping information for each grouping level of the
#'               data (\code{groups})
#'         \item a named vector identifying the hierarchy of the grouping levels
#'               (\code{group_lvls})
#'         \item a named vector giving the number of observations on each
#'               level of the hierarchy (\code{N})
#'         \item the name of the time variable (only for survival models with
#'               time-varying covariates) (\code{timevar})
#'         \item a formula of auxiliary variables (\code{auxvars})
#'         \item a list specifying the reference categories and dummy variables
#'               for all factors involved in the models (\code{refs})
#'         \item a list of linear predictor information (column numbers per
#'               design matrix) for all sub-models (\code{lp_cols})
#'         \item a list identifying information for interaction terms found in
#'               the model formulas (\code{interactions})
#'         \item a \code{data.frame} containing information on transformations
#'               of incomplete variables (\code{trafos})
#'         \item a \code{data.frame} containing information on transformations
#'               of all variables (\code{fcts_all})
#'         \item a logical indicator if parameter for posterior predictive
#'               checks should be monitored (\code{ppc}; not yet used)
#'         \item a vector specifying if shrinkage of regression coefficients
#'               should be performed, and if so for which models and what type
#'               of shrinkage (\code{shrinkage})
#'         \item the number of degrees of freedom to be used in the spline
#'               specification of the baseline hazard in proportional hazards
#'               survival models (\code{df_basehaz})
#'         \item a list of matrices, one per level of the data, specifying
#'               centring and scaling parameters for the data
#'               (\code{scale_pars})
#'         \item a list containing information on the outcomes (mostly relevant
#'               for survival outcomes; \code{outcomes})
#'         \item a list of terms objects, needed to be able to build correct
#'               design matrices for the Gauss-Kronrod quadrature when, for
#'               example, splines are used to model time in a joint model
#'               (\code{terms_list})
#'}}
#' \item{\code{par_index_main}}{a list of matrices specifying the indices of the
#' regression coefficients for each of the main models per design matrix}
#' \item{\code{par_index_other}}{a list of matrices specifying the indices of
#' regression coefficients for each covariate model per design matrix}
#' \item{\code{jagsmodel}}{The JAGS model as character string.}
#' \item{\code{mcmc_settings}}{a list containing MCMC sampling related
#'                             information with elements
#'      \describe{
#'      \item{\code{modelfile}: }{path and name of the JAGS model file}
#'      \item{\code{n.chains}: }{number of MCMC chains}
#'      \item{\code{n.adapt}: }{number of iterations in the adaptive phase}
#'      \item{\code{n.iter}: }{number of iterations in the MCMC sample}
#'      \item{\code{variable.names}: }{monitored nodes}
#'      \item{\code{thin}: }{thinning interval of the MCMC sample}
#'      \item{\code{inits}: }{a list containing the initial values that were
#'                            passed to \strong{rjags}}
#'      }}
#' \item{\code{monitor_params}}{the named list of parameter groups to be
#'                              monitored}
#' \item{\code{data_list}}{list with data that was passed to \strong{rjags}}
#' \item{\code{hyperpars}}{a list containing the values of the hyper-parameters
#'                         used}
#' \item{\code{info_list}}{a list with information used to write the imputation
#'                         model syntax}
#' \item{\code{coef_list}}{a list relating the regression coefficient vectors
#'                         used in the JAGS model to the names of the
#'                         corresponding covariates}
#' \item{\code{model}}{the JAGS model (an object of class 'jags', created by
#'                     \bold{rjags})}
#' \item{\code{sample}}{MCMC sample on the sampling scale (included only if
#'                      \code{keep_scaled_sample = TRUE})}
#' \item{\code{MCMC}}{MCMC sample, scaled back to the scale of the data}
#' \item{\code{comp_info}}{a list with information on the computational setting
#'                         (\code{start_time}: date and time the calculation was
#'                         started, \code{duration}: computational time of the
#'                         model adaptive and sampling phase,
#'                         \code{JointAI_version}: package version,
#'                         \code{R_version}: the \code{R.version.string},
#'                         \code{parallel}: whether parallel computation was used,
#'                         \code{workers}: if parallel computation was used, the
#'                         number of workers)}
#' \item{\code{fitted.values}}{fitted/predicted values (if available)}
#' \item{\code{residuals}}{residuals (if available)}
#' \item{\code{call}}{the original call}
#'
NULL
