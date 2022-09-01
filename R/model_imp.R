#' Joint Analysis and Imputation of incomplete data
#'
#' Main analysis functions to estimate different types of models using MCMC
#' sampling, while imputing missing values.
#'
#' @md
#' @param formula a two sided model formula (see \code{\link[stats]{formula}})
#'                or a list of such formulas; (more details below).
#' @param fixed a two sided formula describing the fixed-effects part of the
#'              model (see \code{\link[stats]{formula}})
#' @param random only for multi-level models:
#'               a one-sided formula of the form \code{~x1 + ... + xn | g},
#'               where \code{x1 + ... + xn} specifies the model for the random
#'               effects and \code{g} the grouping variable
#' @param data a \code{data.frame} containing the original data
#'             (more details below)
#' @param family only for \code{glm_imp} and \code{glmm_imp}/\code{glmer_imp}:
#'               a description of the distribution and link function to
#'               be used in the model. This can be a character string naming a
#'               family function, a family function or the result of a call to
#'               a family function. (For more details see below and
#'               \code{\link[stats]{family}}.)
#' @param rd_vcov character string or list specifying the structure of the
#'                random effects variance covariance matrix, see details below.
#' @param monitor_params named list or vector specifying which parameters
#'                       should be monitored (more details below)
#' @param inits optional; specification of initial values in the form of a list
#'              or a function (see \code{\link[rjags]{jags.model}}).
#'              If omitted, starting values for the random number generator are
#'              created by \strong{JointAI}, initial values are then generated
#'              by JAGS.
#'              It is an error to supply an initial value for an observed node.
#' @inheritParams sharedParams
#' @param auxvars optional; one-sided formula of variables that should be used
#'                as predictors in the imputation procedure (and will be imputed
#'                if necessary) but are not part of the analysis model(s).
#'                For more details with regards to the behaviour with
#'                non-linear effects see the vignette on
#'                [Model Specification](https://nerler.github.io/JointAI/articles/ModelSpecification.html#auxvars)
#' @param models optional; named vector specifying the types of models for
#'               (incomplete) covariates.
#'               This arguments replaces the argument \code{meth} used in
#'               earlier versions.
#'               If \code{NULL} (default) models will be determined
#'               automatically based on the class of the respective columns of
#'               \code{data}.
#' @param refcats optional; either one of \code{"first"}, \code{"last"},
#'                \code{"largest"} (which sets the category for all categorical
#'                variables) or a named list specifying which category should
#'                be used as reference category per categorical variable.
#'                Options are the category label, the category number,
#'                or one of "first" (the first category),
#'                "last" (the last category) or "largest" (chooses the category
#'                with the most observations).
#'                Default is "first". If reference categories are specified for
#'                a subset of the categorical variables the default will be
#'                used for the remaining variables.
#'                (See also \code{\link{set_refcat}})
#' @param df_basehaz degrees of freedom for the B-spline used to model the
#'                   baseline hazard in proportional hazards models
#'                  (\code{coxph_imp} and \code{JM_imp})
#' @param shrinkage optional; either a character string naming the shrinkage
#'                  method to be used for regression coefficients in all models
#'                  or a named vector specifying the type of shrinkage to be
#'                  used in the models given as names.
#' @param rev optional character vector; vector of ordinal outcome variable
#'            names for which the odds should be reversed, i.e.,
#'            \eqn{logit(y\le k)} instead of \eqn{logit(y > k)}.
#' @param nonprop optional named list of one-sided formulas specifying
#'                covariates that have non-proportional effects in cumulative
#'                logit models. These covariates should also be part of the
#'                regular model formula, and the names of the list should be
#'                the names of the ordinal response variables.
#' @param ... additional, optional arguments
#'            \describe{
#'            \item{`trunc`}{named list specifying limits of truncation for the
#'                 distribution of the named incomplete variables (see the
#'                 vignette
#'                 \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html#functions-with-restricted-support}{ModelSpecification})}
#'            \item{`hyperpars`}{list of hyper-parameters, as obtained by
#'                 \code{\link{default_hyperpars}()}}
#'            \item{`scale_vars`}{named vector of (continuous) variables that
#'                 will be centred and scaled (such that mean = 0 and sd = 1)
#'                 when they enter a linear predictor to improve
#'                 convergence of the MCMC sampling. Default is that all
#'                 numeric variables and integer variables with >20 different
#'                 values will be scaled.
#'                 If set to \code{FALSE} no scaling will be done.}
#'            \item{`custom`}{named list of JAGS model chunks (character strings)
#'                 that replace the model for the given variable.}
#'            \item{`append_data_list`}{list that will be appended to the list
#'                 containing the data that is passed to **rjags**
#'                 (`data_list`). This may be necessary if additional data /
#'                 variables are needed for custom (covariate) models.}
#'            \item{`progress.bar`}{character string specifying the type of
#'                 progress bar. Possible values are "text" (default), "gui",
#'                 and "none" (see \code{\link[rjags]{update}}). Note: when
#'                 sampling is performed in parallel it is not possible to
#'                 display a progress bar.}
#'            \item{`quiet`}{logical; if \code{TRUE} then messages generated by
#'                 \strong{rjags} during compilation as well as the progress bar
#'                 for the adaptive phase will be suppressed,
#'                 (see \code{\link[rjags]{jags.model}})}
#'            \item{`keep_scaled_mcmc`}{should the "original" MCMC sample (i.e.,
#'                 the scaled version returned by \code{coda.samples()}) be
#'                 kept? (The MCMC sample that is re-scaled to the scale of the
#'                 data is always kept.)}
#'            \item{`modelname`}{character string specifying the name of the
#'                  model file (including the ending, either .R or .txt). If
#'                  unspecified a random name will be generated.}
#'            \item{`modeldir`}{directory containing the model file or directory
#'                 in which the model file should be written. If unspecified a
#'                 temporary directory will be created.}
#'            \item{`overwrite`}{logical; whether an existing model file with
#'                 the specified \code{<modeldir>/<modelname>} should be
#'                 overwritten. If set to \code{FALSE} and a model already
#'                 exists, that model will be used. If unspecified (\code{NULL})
#'                 and a file exists, the user is asked for input on how to
#'                 proceed.}
#'            \item{`keep_model`}{logical; whether the created JAGS model file
#'                 should be saved or removed from (\code{FALSE}; default) when
#'                 the sampling has finished.}
#' }
#'
#' @name model_imp
#'
#' @return An object of class \link[=JointAIObject]{JointAI}.
#'
#'
#'
#' @details # Model formulas
#' ## Random effects
#' It is possible to specify multi-level models as it is done in the package
#' \href{https://CRAN.R-project.org/package=nlme}{\pkg{nlme}},
#' using `fixed` and `random`, or as it is done in the package
#' \href{https://CRAN.R-project.org/package=lme4}{\pkg{lme4}},
#' using `formula` and specifying the random effects in brackets:
#' ```{r}
#' formula = y ~ x1 + x2 + x3 + (1 | id)
#' ```
#' is equivalent to
#' ```{r, eval = FALSE}
#' fixed = y ~ x1 + x2 + x3, random = ~ 1|id
#' ```
#'
#' ## Multiple levels of grouping
#' For multiple levels of grouping the specification using `formula`
#' should be used. There is no distinction between nested and crossed random
#' effects, i.e., `... + (1 | id) + (1 | center)` is treated the same as
#' `... + (1 | center/id)`.
#'
#' ## Nested vs crossed random effects
#' The distinction between nested and crossed random effects should come from
#' the levels of the grouping variables, i.e., if \code{id} is nested in
#' \code{center}, then there cannot be observations with the same \code{id}
#' but different values for \code{center}.
#'
#' ## Modelling multiple models simultaneously & joint models
#' To fit multiple main models at the same time, a \code{list} of \code{formula}
#' objects can be passed to the argument \code{formula}.
#' Outcomes of one model may be contained as covariates in another model and
#' it is possible to combine models for variables on different levels,
#' for example:
#' ```{r}
#' formula = list(y ~ x1 + x2 + x3 + x4 + time + (time | id),
#'                      x2 ~ x3 + x4 + x5)
#' ```
#'
#' This principle is also used for the specification of a joint model for
#' longitudinal and survival data.
#'
#' Note that it is not possible to specify multiple models for the same outcome
#' variable.
#'
#' ### Random effects variance-covariance structure
#' (Note: This feature is new and has not been fully tested yet.)
#'
#' By default, a block-diagonal structure is assumed for the variance-covariance
#' matrices of the random effects in models with random effects. This means that
#' per outcome and level random effects are assumed to be correlated, but
#' random effects of different outcomes are modelled as independent.
#' The argument `rd_vcov` allows the user specify different assumptions about
#' these variance-covariance matrices. Implemented structures are `full`,
#' `blockdiag` and `indep` (all off-diagonal elements are zero).
#'
#' If `rd_vcov` is set to one of these options, the structure is assumed for
#' all random effects variance-covariance matrices.
#' Alternatively, it is possible to specify a named list of vectors, where
#' the names are the structures and the vectors contain the names of the
#' response variables which are included in this structure.
#'
#' For example, for a multivariate mixed model with five outcomes
#' `y1`, ..., `y5`, the specification could be:
#' ```{r}
#' rd_vcov = list(blockdiag = c("y1", "y2"),
#'                full = c("y3", "y4"),
#'                indep = "y5")
#' ```
#' This would entail that the random effects for `y3` and `y4` are assumed to
#' be correlated (within and across outcomes),
#' random effects for `y1` and `y2` are assumed to be correlated within each
#' outcome, and the random effects for `y5` are assumed to be independent.
#'
#'
#' It is possible to have multiple sets of response variables for which separate
#' full variance-covariance matrices are used, for example:
#' ```{r}
#' rd_vcov = list(full = c("y1", "y2", "y5"),
#'                full = c("y3", "y4"))
#' ```
#'
#' In models with multiple levels of nesting, separate structures can be
#' specified per level:
#' ```{r}
#' rd_vcov = list(id = list(blockdiag = c("y1", "y2"),
#'                          full = c("y3", "y4"),
#'                          indep = "y5"),
#'               center = "indep")
#' ```
#'
#'
#' ## Survival models with frailties or time-varying covariates
#' Random effects specified in brackets can also be used to indicate a
#' multi-level structure in survival models, as would, for instance be needed
#' in a multi-centre setting, where patients are from multiple hospitals.
#'
#' It also allows to model time-dependent covariates in a proportional
#' hazards survival model (using \code{coxph_imp}), also in combination with
#' additional grouping levels.
#'
#' In time-dependent proportional hazards models,
#' last-observation-carried-forward is used to fill in missing values in the
#' time-varying covariates, and to determine the value of the covariate at the
#' event time. Preferably, all time-varying covariates should be measured at
#' baseline (`timevar = 0`). If a value for a time-varying covariate needs to be
#' filled in and there is no previous observation, the next observation will be
#' carried backward.
#'
#'
#' ## Differences to basic regression models
#' It is not possible to specify transformations of outcome variables, i.e.,
#' it is not possible to use a model formula like
#' ```{r, eval = FALSE}
#' log(y) ~ x1 + x2 + ...
#' ```
#' In the specific case of a transformation with the natural logarithm,
#' a log-normal model can be used instead of a normal model.
#'
#' Moreover, it is not possible to use `.` to indicate that all variables in a
#' `data.frame` other than the outcome variable should be used as covariates.
#' I.e., a formula `y ~ .` is not valid in **JointAI**.
#'
#'
#' @details # Data structure
#' For multi-level settings, the data must be in long format, so that repeated
#' measurements are recorded in separate rows.
#'
#' For survival data with time-varying covariates (\code{coxph_imp} and
#' \code{JM_imp}) the data should also be in long format. The
#' survival/censoring times and event indicator variables must be stored in
#' separate variables in the same data and should be constant across all rows
#' referring to the same subject.
#'
#' During the pre-processing of the data the survival/censoring times will
#' automatically be merged with the observation times of the  time-varying
#' covariates (which must be supplied via the argument \code{timevar}).
#'
#' It is possible to have multiple time-varying covariates, which do not
#' have to be measured at the same time points, but there can only be one
#' \code{timevar}.
#'
#'
#'
#'
#' @details # Distribution families and link functions
#' \tabular{ll}{
# \emph{family} \tab \emph{link}\cr
#' \code{gaussian} \tab with links: \code{identity}, \code{log}\cr
#' \code{binomial} \tab with links: \code{logit}, \code{probit}, \code{log},
#'                                  \code{cloglog}\cr
#' \code{Gamma}    \tab with links: \code{inverse}, \code{identity},
#'                                  \code{log}\cr
#' \code{poisson}  \tab with links: \code{log}, \code{identity}
#' }
#'
#'
#'
#'
#' @details # Imputation methods / model types
#' Implemented model types that can be chosen in the argument \code{models}
#' for baseline covariates (not repeatedly measured) are:
#' \tabular{ll}{
#' \code{lm} \tab linear (normal) model with identity link
#'                (alternatively: \code{glm_gaussian_identity}); default for
#'                continuous variables\cr
#' \code{glm_gaussian_log} \tab linear (normal) model with log link\cr
#' \code{glm_gaussian_inverse} \tab linear (normal) model with inverse link\cr
#' \code{glm_logit} \tab logistic model for binary data
#'                       (alternatively: \code{glm_binomial_logit});
#'                       default for binary variables\cr
#' \code{glm_probit} \tab probit model for binary data
#'                       (alternatively: \code{glm_binomial_probit})\cr
#' \code{glm_binomial_log} \tab binomial model with log link\cr
#' \code{glm_binomial_cloglog} \tab binomial model with complementary
#'                                  log-log link\cr
#' \code{glm_gamma_inverse} \tab gamma model with inverse link for skewed
#'                               continuous data\cr
#' \code{glm_gamma_identity} \tab gamma model with identity link for skewed
#'                                continuous data\cr
#' \code{glm_gamma_log} \tab gamma model with log link for skewed continuous
#'                           data\cr
#' \code{glm_poisson_log} \tab Poisson model with log link for count data\cr
#' \code{glm_poisson_identity} \tab Poisson model with identity link for count
#'                                  data\cr
#' \code{lognorm} \tab log-normal model for skewed continuous data\cr
#' \code{beta} \tab beta model (with logit link) for skewed continuous
#'                  data in (0, 1)\cr
#' \code{mlogit} \tab multinomial logit model for unordered categorical
#'                    variables;
#'                    default for unordered factors with >2 levels\cr
#' \code{clm} \tab cumulative logit model for ordered categorical variables;
#'                 default for ordered factors\cr
#' }
#'
#' For repeatedly measured variables the following model types are available:
#' \tabular{ll}{
#' \code{lmm} \tab linear (normal) mixed model with identity link
#'                (alternatively: \code{glmm_gaussian_identity});
#'                default for continuous variables\cr
#' \code{glmm_gaussian_log} \tab linear (normal) mixed model with log link\cr
#' \code{glmm_gaussian_inverse} \tab linear (normal) mixed model with
#'                                   inverse link\cr
#' \code{glmm_logit} \tab logistic mixed model for binary data
#'                       (alternatively: \code{glmm_binomial_logit});
#'                       default for binary variables\cr
#' \code{glmm_probit} \tab probit model for binary data
#'                       (alternatively: \code{glmm_binomial_probit})\cr
#' \code{glmm_binomial_log} \tab binomial mixed model with log link\cr
#' \code{glmm_binomial_cloglog} \tab binomial mixed model with complementary
#'                                   log-log link\cr
#' \code{glmm_gamma_inverse} \tab gamma mixed model with inverse link for
#'                                skewed continuous data\cr
#' \code{glmm_gamma_identity} \tab gamma mixed model with identity link for
#'                                 skewed continuous data\cr
#' \code{glmm_gamma_log} \tab gamma mixed model with log link for skewed
#'                            continuous data\cr
#' \code{glmm_poisson_log} \tab Poisson mixed model with log link for
#'                              count data\cr
#' \code{glmm_poisson_identity} \tab Poisson mixed model with identity link for
#'                                   count data\cr
#' \code{glmm_lognorm} \tab log-normal mixed model for skewed covariates\cr
#' \code{glmm_beta} \tab beta mixed model for continuous data in (0, 1)\cr
#' \code{mlogitmm} \tab multinomial logit mixed model for unordered categorical
#'                    variables;
#'                    default for unordered factors with >2 levels\cr
#' \code{clmm} \tab cumulative logit mixed model for ordered factors;
#'                  default for ordered factors
#' }
#'
#' When models are specified for only a subset of the variables for which a
#' model is needed, the default model choices (as indicated in the tables)
#' are used for the unspecified variables.
#'
#'
#'
#'
#' @details # Parameters to follow (`monitor_params`)
#' See also the vignette:
#' \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}\cr
#'
#' Named vector specifying which parameters should be monitored. This can be
#' done either directly by specifying the name of the parameter or indirectly
#' by one of the key words selecting a set of parameters.
#' Except for \code{other}, in which parameter names are specified directly,
#' parameter (groups) are just set as \code{TRUE} or \code{FALSE}.
#'
#' Models are divided into two groups, the main models, which are the models
#' for which the user has explicitly specified a formula (via \code{formula}
#' or \code{fixed}), and all other models, for which models were specified
#' automatically.
#'
#'
#' If left unspecified, \code{monitor_params = c("analysis_main" = TRUE)}
#' will be used.
#'
#'
#' \tabular{ll}{
#' \strong{name/key word} \tab \strong{what is monitored}\cr
#' \code{analysis_main} \tab \code{betas} and \code{sigma_main}, \code{tau_main}
#'                           (for beta regression) or \code{shape_main}
#'                           (for parametric survival models), \code{gamma_main}
#'                           (for cumulative logit models),
#'                           code{D_main} (for multi-level models) and
#'                           \code{basehaz} in proportional hazards models)\cr
#' \code{analysis_random} \tab \code{ranef_main}, \code{D_main},
#'                             \code{invD_main}, \code{RinvD_main}\cr
#' \code{other_models} \tab \code{alphas}, \code{tau_other}, \code{gamma_other},
#'                      \code{delta_other}\cr
#' \code{imps} \tab imputed values\cr
#' \code{betas} \tab regression coefficients of the main analysis model\cr
#' \code{tau_main} \tab precision of the residuals from the main analysis
#'                      model(s)\cr
#' \code{sigma_main} \tab standard deviation of the residuals from the main
#'                        analysis model(s)\cr
#' \code{gamma_main} \tab intercepts in ordinal main model(s)\cr
#' \code{delta_main} \tab increments of ordinal main model(s)\cr
#' \code{ranef_main} \tab random effects from the main analysis model(s)
#'                        \code{b}\cr
#' \code{D_main} \tab covariance matrix of the random effects from the
#'                    main model(s)\cr
#' \code{invD_main} \tab inverse(s) of \code{D_main}\cr
#' \code{RinvD_main} \tab matrices in the priors for \code{invD_main}\cr
#' \code{alphas} \tab regression coefficients in the covariate models\cr
#' \code{tau_other} \tab precision parameters of the residuals from
#'                       covariate models\cr
#' \code{gamma_other} \tab intercepts in ordinal covariate models\cr
#' \code{delta_other} \tab increments of ordinal intercepts\cr
#' \code{ranef_other} \tab random effects from the other  models \code{b}\cr
#' \code{D_other} \tab covariance matrix of the random effects from the
#'                     other models\cr
#' \code{invD_other} \tab inverses of \code{D_other}\cr
#' \code{RinvD_other} \tab matrices in the priors for \code{invD_other}\cr
#' \code{other} \tab additional parameters
#' }
#'
#' **For example:**\cr
#' \code{monitor_params = c(analysis_main = TRUE, tau_main = TRUE,
#' sigma_main = FALSE)}
#' would monitor the regression parameters \code{betas} and the
#' residual precision \code{tau_main} instead of the residual standard
#' deviation \code{sigma_main}.
#'
#' For a linear model, \code{monitor_params = c(imps = TRUE)} would monitor
#' \code{betas}, and \code{sigma_main} (because \code{analysis_main = TRUE} by
#' default) as well as the imputed values.
#'
#'
#' \loadmathjax
#'
#' @section Cumulative logit (mixed) models:
#' In the default setting for cumulative logit models, i.e, `rev = NULL`, the
#' odds for a variable \mjeqn{y}{ascii} with \mjeqn{K}{ascii} ordered categories
#' are defined as \mjdeqn{\log\left(\frac{P(y_i > k)}{P(y_i \leq k)}\right) =
#' \gamma_k + \eta_i, \quad k = 1, \ldots, K-1,}{ascii} where
#' \mjeqn{\gamma_k}{ascii} is a category specific intercept and
#' \mjeqn{\eta_i}{ascii} the subject specific linear predictor.
#'
#' To reverse the odds to \mjdeqn{\log\left(\frac{P(y_i \leq k)}{P(y_i >
#' k)}\right) = \gamma_k + \eta_i, \quad k = 1, \ldots, K-1,}{ascii} the name of
#' the response variable has to be specified in the argument `rev`, e.g., `rev =
#' c("y")`.
#'
#' By default, proportional odds are assumed and only the intercepts differ
#' per category of the ordinal response. To allow for non-proportional odds,
#' i.e.,
#' \mjdeqn{\log\left(\frac{P(y_i > k)}{P(y_i \leq k)}\right) =
#' \gamma_k + \eta_i + \eta_{ki}, \quad k = 1, \ldots, K-1,}{ascii}
#' the argument `nonprop` can be specified. It takes a one-sided formula or
#' a list of one-sided formulas. When a single formula is supplied, or a
#' unnamed list with just one element, it is assumed that the formula
#' corresponds to the main model.
#' To specify non-proportional effects for linear predictors in models for
#' ordinal covariates, the list has to be named with the names of the
#' ordinal response variables.
#'
#' For example, the following three specifications are equivalent and assume a
#' non-proportional effect of `C1` on `O1`, but `C1` is assumed to have a
#' proportional effect on the incomplete ordinal covariate `O2`:
#' ```{r, eval = FALSE}
#' clm_imp(O1 ~ C1 + C2 + B2 + O2, data = wideDF, nonprop = ~ C1)
#' clm_imp(O1 ~ C1 + C2 + B2 + O2, data = wideDF, nonprop = list(~ C1))
#' clm_imp(O1 ~ C1 + C2 + B2 + O2, data = wideDF, nonprop = list(O1 = ~ C1))
#' ```
#'
#' To specify non-proportional effects on `O2`, a named list has to be provided:
#' ```{r, eval = FALSE}
#' clm_imp(O1 ~ C1 + C2 + B2 + O2 + B1, data = wideDF,
#'         nonprop = list(O1 = ~ C1,
#'                        O2 = ~ C1 + B1))
#' ```
#' The variables for which a non-proportional effect is assumed also have to be
#' part of the regular model formula.
#'
#'
#'
#' @section Custom model parts:
#' (Note: This feature is experimental and has not been fully tested yet.)
#'
#' Via the argument `custom` it is possible to provide custom sub-models that
#' replace the sub-models that are automatically generated by **JointAI**.
#'
#' Using this feature it is, for instance, possible to use the value of
#' a repeatedly measured variable at a specific time point as covariate in
#' another model. An example would be the use of "baseline" cholesterol
#' (`chol` at `day = 0`) as covariate in a survival model.
#'
#' First, the variable `chol0` is added to the `PBC` data.
#' For most patients the value of cholesterol at baseline is observed, but not
#' for all. It is important that the data has a row with `day = 0` for each
#' patient.
#'
#' ```{r, eval = FALSE}
#' PBC <- merge(PBC,
#'              subset(PBC, day == 0, select = c("id", "chol")),
#'              by = "id", suffixes = c("", "0"))
#' ```
#'
#' Next, the custom piece of JAGS model syntax needs to be specified.
#' We loop here only over the patients for which the baseline cholesterol
#' is missing.
#'
#' ```{r, eval = FALSE}
#' calc_chol0 <- "
#' for (ii in 1:28) {
#'   M_id[row_chol0_id[ii], 3] <- M_lvlone[row_chol0_lvlone[ii], 1]
#'   }"
#' ```
#'
#' To be able to run the model with the custom imputation "model" for baseline
#' cholesterol we need to provide the numbers of the rows in the data matrices
#' that contain the missing values of baseline cholesterol and the rows that
#' contain the imputed cholesterol at `day = 0`:
#' ```{r, eval = FALSE}
#' row_chol0_lvlone <- which(PBC$day == 0 & is.na(PBC$chol0))
#' row_chol0_id <- match(PBC$id, unique(PBC$id))[row_chol0_lvlone]
#' ```
#' Then we pass both the custom sub-model and the additional data to the
#' analysis function `coxph_imp()`. Note that we explicitly need to specify
#' the model for `chol`.
#'
#' ```{r, eval = FALSE}
#' coxph_imp(list(Surv(futime, status != "censored") ~ age + sex + chol0,
#'                chol ~ age + sex + day + (day | id)),
#'           no_model = "day", data = PBC,
#'           append_data_list = list(row_chol0_lvlone = row_chol0_lvlone,
#'                                   row_chol0_id = row_chol0_id),
#'           custom = list(chol0 = calc_chol0))
#' ```
#'
#'
#'
#' @section Note:
#' ## Coding of variables:
#' The default covariate (imputation) models are chosen based on the
#' \code{class} of each of the variables, distinguishing between \code{numeric},
#' \code{factor} with two levels, unordered \code{factor} with >2 levels and
#' ordered \code{factor} with >2 levels.\cr
#'
#' When a continuous variable has only two different values it is
#' assumed to be binary and its coding and default (imputation) model will be
#' changed accordingly. This behaviour can be overwritten specifying a model
#' type via the argument \code{models}.\cr
#'
#' Variables of type \code{logical} are automatically converted to unordered
#' factors.\cr
#'
#' ### Contrasts
#' **JointAI** version \mjeqn{\geq}{ascii} 1.0.0 uses the globally (via
#' `options("contrasts")`) specified contrasts. However, for incomplete
#' categorical variables, for which the contrasts need to be re-calculated
#' within the JAGS model, currently only `contr.treatment` and `contr.sum` are
#' possible. Therefore, when an in complete ordinal covariate is used and the
#' default contrasts (`contr.poly()`) are set to be used for ordered factors, a
#' warning message is printed and dummy coding (`contr.treatment()`) is used for
#' that variable instead.
#'
#'
#'
#'
#' ## Non-linear effects and transformation of variables:
#' \strong{JointAI} handles non-linear effects, transformation of covariates
#' and interactions the following way:\cr
#' When, for instance, a model formula contains the function \code{log(x)} and
#' \code{x} has missing values, \code{x} will be imputed and used in the linear
#' predictor of models for which no formula was specified,
#' i.e., it is assumed that the other variables have a linear association with
#' \code{x}. The \code{log()} of the observed and imputed values of
#' \code{x} is calculated and used in the linear predictor of the main
#' analysis model.\cr
#'
#' If, instead of using \code{log(x)} in the model formula, a pre-calculated
#' variable \code{logx} is used, this variable is imputed directly
#' and used in the linear predictors of all models, implying that
#' variables that have \code{logx} in their linear predictors have a linear
#' association with \code{logx} but not with \code{x}.\cr
#'
#' When different transformations of the same incomplete variable are used in
#' one model it is strongly discouraged to calculate these transformations
#' beforehand and supply them as different variables.
#' If, for example, a model formula contains both \code{x} and \code{x2} (where
#' \code{x2} = \code{x^2}), they are treated as separate variables and imputed
#' with separate models. Imputed values of \code{x2} are thus not equal to the
#' square of imputed values of \code{x}.
#' Instead, \code{x} and \code{I(x^2)} should be used in the model formula.
#' Then only \code{x} is imputed and \code{x^2} is calculated from the imputed
#' values of \code{x} internally.
#'
#' The same applies to interactions involving incomplete variables.
#'
#'
#'
#'
#' ## Sequence of models:
#' Models generated automatically (i.e., not mentioned in `formula` or `fixed`
#' are specified in a sequence based on the level of the outcome of the
#' respective model in the multi-level hierarchy and within each level
#' according to the number of missing values.
#' This means that level-1 variables have all level-2, level-3, ... variables
#' in their linear predictor, and variables on the highest level only have
#' variables from the same level in their linear predictor.
#' Within each level, the variable with the most missing values has the most
#' variables in its linear predictor.
#'
#'
#'
#' ## Not (yet) possible:
#' \itemize{
#' \item prediction (using \code{predict}) conditional on random effects
#' \item the use of splines for incomplete variables
#' \item the use of (or equivalents for) \code{\link[survival]{pspline}},
#'       or \code{\link[survival]{strata}} in survival models
#' \item left censored or interval censored data
#' }
#'
#'
#'
#'
#' @seealso \code{\link{set_refcat}},
#'          \code{\link{traceplot}}, \code{\link{densplot}},
#'          \code{\link{summary.JointAI}}, \code{\link{MC_error}},
#'          \code{\link{GR_crit}},
#'          \code{\link{predict.JointAI}}, \code{\link{add_samples}},
#'          \code{\link{JointAIObject}}, \code{\link{add_samples}},
#'          \code{\link{parameters}}, \code{\link{list_models}}
#'
#' Vignettes
#' * \href{https://nerler.github.io/JointAI/articles/MinimalExample.html}{Minimal Example}
#' * \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html}{Model Specification}
#' * \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' * \href{https://nerler.github.io/JointAI/articles/MCMCsettings.html}{MCMC Settings}
#' * \href{https://nerler.github.io/JointAI/articles/AfterFitting.html}{After Fitting}
#' * \href{https://nerler.github.io/JointAI/articles/TheoreticalBackground.html}{Theoretical Background}
#'
#'
#'
#' @examples
#' # Example 1: Linear regression with incomplete covariates
#' mod1 <- lm_imp(y ~ C1 + C2 + M1 + B1, data = wideDF, n.iter = 100)
#'
#'
#' # Example 2: Logistic regression with incomplete covariates
#' mod2 <- glm_imp(B1 ~ C1 + C2 + M1, data = wideDF,
#'                 family = binomial(link = "logit"), n.iter = 100)
#'
#' \dontrun{
#'
#' # Example 3: Linear mixed model with incomplete covariates
#' mod3 <- lme_imp(y ~ C1 + B2 + c1 + time, random = ~ time|id,
#'                 data = longDF, n.iter = 300)
#'
#'
#' # Example 4: Parametric Weibull survival model
#' mod4 <- survreg_imp(Surv(time, status) ~ age + sex + meal.cal + wt.loss,
#'                     data = survival::lung, n.iter = 100)
#'
#'
#' # Example 5: Proportional hazards survival model
#' mod5 <- coxph_imp(Surv(time, status) ~ age + sex + meal.cal + wt.loss,
#'                     data = survival::lung, n.iter = 200)
#'
#' # Example 6: Joint model for longitudinal and survival data
#' mod6 <- JM_imp(list(Surv(futime, status != 'censored') ~ age + sex +
#'                     albumin + copper + trig + (1 | id),
#'                     albumin ~ day + age + sex + (day | id)),
#'                     timevar = 'day', data = PBC, n.iter = 100)
#'
#' # Example 7: Proportional hazards  model with a time-dependent covariate
#' mod7 <- coxph_imp(Surv(futime, status != 'censored') ~ age + sex + copper +
#'                   trig + stage + (1 | id),
#'                   timevar = 'day', data = PBC, n.iter = 100)
#'
#'
#'
#' # Example 8: Parallel computation
#' # If no strategy how the "future" should be handled is specified, the
#' # MCMC chains are run sequentially.
#' # To run MCMC chains in parallel, a strategy can be specified using the
#' # package \pkg{future} (see ?future::plan), for example:
#' future::plan(future::multisession, workers = 4)
#' mod8 <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 500, n.chains = 8)
#' mod8$comp_info$future
#' # To re-set the strategy to sequential computation, the sequential strategy
#' # can be specified:
#' future::plan(future::sequential)
#'
#' }
#'
NULL

model_imp <- function(formula = NULL, fixed = NULL, data, random = NULL,
                      family = NULL, df_basehaz = NULL,
                      rd_vcov = "blockdiag",
                      n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                      monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                      timevar = NULL, refcats = NULL,
                      models = NULL, no_model = NULL, trunc = NULL,
                      shrinkage = FALSE, custom = NULL,
                      nonprop = NULL, rev = NULL,
                      ppc = TRUE, seed = NULL, inits = NULL,
                      scale_vars = NULL, hyperpars = NULL,
                      modelname = NULL, modeldir = NULL,
                      keep_model = FALSE, overwrite = NULL,
                      quiet = TRUE, progress.bar = "text",
                      warn = TRUE, mess = TRUE,
                      keep_scaled_mcmc = FALSE,
                      analysis_type, assoc_type = NULL,
                      append_data_list = NULL, ...) {

  modimpcall <- as.list(match.call())[-1L]
  start_time <- Sys.time()

  # checks & warnings -------------------------------------------------------
  if (!is.null(formula) & is.null(fixed) & is.null(random)) {
    formula <- check_formula_list(formula)
    fixed <- split_formula_list(formula)$fixed
    random <- split_formula_list(formula)$random
  }

  # check if the arguments meth, n.cores or parallel are provided
  # (no longer used)
  args <- as.list(match.call())
  if (!is.null(args$meth))
    errormsg("The argument %s has been replaced by the argument %s.",
              dQuote("meth"), dQuote("models"))

  if (!is.null(args$parallel) | !is.null(args$n.cores)) {
    errormsg("The arguments %s and %s are no longer used. To perform the
             computation in parallel, specify future::plan().
             For an example, see ?model_imp.",
             dQuote("parallel"), dQuote("n.cores"))
  }


  # data pre-processing --------------------------------------------------------
  data <- check_data(data, fixed, random, auxvars, timevar, mess)


  # * divide matrices ----------------------------------------------------------
  Mlist <- divide_matrices(data, fixed, analysis_type = analysis_type,
                           random = random, models = models, auxvars = auxvars,
                           timevar = timevar, no_model = no_model,
                           scale_vars = scale_vars, refcats = refcats,
                           nonprop = nonprop, rev = rev,
                           warn = warn, mess = mess, ppc = ppc,
                           shrinkage = shrinkage, df_basehaz = df_basehaz,
                           rd_vcov = rd_vcov)

  # * model dimensions ---------------------------------------------------------
  par_index_main <- get_model_dim(Mlist$lp_cols[names(Mlist$lp_cols) %in%
                                     names(Mlist$fixed)],
                     Mlist = Mlist)
  par_index_other <- get_model_dim(Mlist$lp_cols[!names(Mlist$lp_cols) %in%
                                         names(Mlist$fixed)],
                         Mlist = Mlist)

  # * model info ---------------------------------------------------------------
  info_list <- get_model_info(Mlist, par_index_main = par_index_main,
                              par_index_other = par_index_other,
                              trunc = trunc, assoc_type = assoc_type,
                              custom = custom)

  # * data list ----------------------------------------------------------------
  data_list <- get_data_list(Mlist, info_list, hyperpars, append_data_list)

  # write model ----------------------------------------------------------------
  modelfile <- make_filename(modeldir = modeldir, modelname = modelname,
                             keep_model = keep_model, overwrite = overwrite,
                             mess = mess)

  if (!file.exists(modelfile) || (file.exists(modelfile) &
                                  attr(modelfile, "overwrite") == TRUE)) {
    write_model(info_list = info_list, Mlist = Mlist, modelfile = modelfile)
  }

  # initial values -------------------------------------------------------------
  inits <- get_initial_values(inits = inits, seed = seed, n_chains = n.chains,
                              warn = warn)

  # parameters to monitor ------------------------------------------------------
  if (any(grepl("^beta\\[", unlist(monitor_params))) &
      any(!is.na(unlist(Mlist$scale_pars)))) {

    monitor_params <- c(lapply(monitor_params, function(x) {
      if (any(grepl("^beta[", x, fixed = TRUE))) {
        x[-grep("^beta[", x, fixed = TRUE)]
      } else {
        x
      }
    }),
    betas = TRUE)

    if (mess)
      msg("Note: %s was set in %s because re-scaling of the effects of
             the regression coefficients in the main model(s) requires all
             of them to be monitored.",
          dQuote("betas = TRUE"), dQuote("monitor_params"))
  }

  var_names <- do.call(get_params, c(list(Mlist = Mlist, info_list = info_list,
                                          mess = mess),
                                     monitor_params))

  # run JAGS -----------------------------------------------------------------
  # Message if no MCMC sample will be produced.
  if (n.iter == 0) {
    if (mess)
      msg("Note: No MCMC sample will be created when n.iter is set to 0.")
  }

  jags_res <- run_parallel(n_adapt = n.adapt, n_iter = n.iter,
                           n_chains = n.chains, inits = inits, thin = thin,
                           data_list = data_list, var_names = var_names,
                           modelfile = modelfile, quiet = quiet,
                           progress_bar = progress.bar, mess = mess,
                           warn = warn)
  adapt <- jags_res$adapt
  mcmc <- jags_res$mcmc


  if (n.iter > 0 & !inherits(mcmc, "mcmc.list"))
    warnmsg("There is no mcmc sample. Something went wrong.")

  # post processing ------------------------------------------------------------
  if (n.iter > 0 & !is.null(mcmc) & !inherits(mcmc, "try-error")) {
    MCMC <- mcmc

    if (any(!vapply(Mlist$scale_pars, is.null, FUN.VALUE = logical(1)),
            !is.na(unlist(Mlist$scale_pars)))) {
      coefs <- try(get_coef_names(info_list))

      for (k in seq_len(length(MCMC))) {
        MCMC[[k]] <- coda::as.mcmc(
          rescale(MCMC[[k]],
                  coefs = do.call(rbind, coefs),
                  scale_pars = do.call(rbind, unname(Mlist$scale_pars)),
                  info_list = info_list,
                  data_list = data_list,
                  groups = Mlist$groups))
        attr(MCMC[[k]], "mcpar") <- attr(mcmc[[k]], "mcpar")
      }
    }
  }


  # prepare output -------------------------------------------------------------
  mcmc_settings <- list(modelfile = modelfile,
                        n.chains = n.chains,
                        n.adapt = n.adapt,
                        n.iter = n.iter,
                        variable.names = if (exists("var_names")) var_names,
                        thin = thin,
                        inits = inits,
                        seed = seed)

  fmla <- if (is.null(formula) & !is.null(fixed)) {
    combine_formula_lists(fixed, random, warn = warn)
  } else {
    formula
  }
  if (length(fmla) == 1L) {
    fmla <- fmla[[1]]
  }

  object <- structure(
    list(analysis_type = analysis_type,
         formula = fmla,
         data = Mlist$data,
         models = Mlist$models,
         fixed = Mlist$fixed,
         random = Mlist$random,
         Mlist = Mlist[setdiff(names(Mlist), c("data", "models",
                                               "fixed", "random",
                                               "M"))],
         par_index_main = par_index_main,
         par_index_other = par_index_other,
         jagsmodel = structure(readChar(modelfile,
                                        file.info(modelfile)$size),
                               class = "modelstring"),
         mcmc_settings = mcmc_settings,
         monitor_params = c(monitor_params,
                            if (!"analysis_main" %in% names(monitor_params))
                              setNames(TRUE, "analysis_main")),
         data_list = data_list,
         hyperpars = if (is.null(hyperpars)) default_hyperpars() else hyperpars,
         info_list = info_list,
         coef_list = get_coef_names(info_list),
         model = if (n.adapt > 0) adapt,
         sample = if (n.iter > 0 & !is.null(mcmc) & keep_scaled_mcmc) mcmc,
         MCMC = if (n.iter > 0 & !is.null(mcmc)) coda::as.mcmc.list(MCMC),
         comp_info = list(start_time = start_time,
                          duration = if (!is.null(jags_res)) {
                            duration_obj(
                              list("adapt" = jags_res$time_adapt,
                                   "sample" = jags_res$time_sample))
                          },
                          JointAI_version = packageVersion("JointAI"),
                          R_version = R.version.string,
                          parallel = if (!is.null(jags_res)) jags_res$parallel,
                          workers = if (isTRUE(jags_res$parallel))
                            jags_res$workers),
         call = modimpcall$thecall
    ), class = "JointAI")


  object$fitted.values <- try(fitted_values(object, mess = FALSE, warn = FALSE),
                              silent = TRUE)

  object$residuals <- try(residuals(object, type = "working", warn = FALSE),
                          silent = TRUE)

  if (inherits(object$fitted.values, "try-error"))
    object$fitted.values <- NULL
  if (inherits(object$residuals, "try-error"))
    object$residuals <- NULL

  if (inherits(adapt, "try-error"))
    class(object) <- "JointAI_errored"

  if (!attr(modelfile, "keep_model")) {
    file.remove(modelfile)
  }

  return(object)
}


#' @rdname model_imp
#' @export
lm_imp <- function(formula, data,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                   monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                   refcats = NULL,
                   models = NULL, no_model = NULL,
                   shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                   warn = TRUE, mess = TRUE,
                   ...) {


  if (missing(formula)) errormsg("No model formula specified.")

  arglist <- prep_arglist(analysis_type = "lm",
                          family = gaussian(),
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))


  do.call(model_imp, arglist)
}



#' @rdname model_imp
#' @export
glm_imp <- function(formula, family, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                    refcats = NULL,
                    models = NULL, no_model = NULL,
                    shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                    warn = TRUE, mess = TRUE,
                    ...) {

  if (missing(formula)) errormsg("No model formula specified.")
  if (missing(family))
    errormsg("The argument %s needs to be specified.", dQuote("family"))

  arglist <- prep_arglist(analysis_type = "glm",
                          family = family,
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
clm_imp <- function(formula, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                    refcats = NULL, nonprop = NULL, rev = NULL,
                    models = NULL, no_model = NULL,
                    shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                    warn = TRUE, mess = TRUE, ...) {

  if (missing(formula)) errormsg("No model formula specified.")

  arglist <- prep_arglist(analysis_type = "clm",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))


  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
lognorm_imp <- function(formula, data,
                        n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                        monitor_params = c(analysis_main = TRUE),
                        auxvars = NULL, refcats = NULL,
                        models = NULL, no_model = NULL,
                        shrinkage = FALSE, ppc = TRUE, seed = NULL,
                        inits = NULL, warn = TRUE, mess = TRUE, ...) {

  if (missing(formula)) errormsg("No model formula specified.")

  arglist <- prep_arglist(analysis_type = "lognorm",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))


  do.call(model_imp, arglist)
}



#' @rdname model_imp
#' @export
betareg_imp <- function(formula, data,
                        n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                        monitor_params = c(analysis_main = TRUE),
                        auxvars = NULL, refcats = NULL,
                        models = NULL, no_model = NULL,
                        shrinkage = FALSE, ppc = TRUE, seed = NULL,
                        inits = NULL, warn = TRUE, mess = TRUE, ...) {

  if (missing(formula)) errormsg("No model formula specified.")

  arglist <- prep_arglist(analysis_type = "beta",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
mlogit_imp <- function(formula, data,
                       n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                       monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                       refcats = NULL,
                       models = NULL, no_model = NULL,
                       shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                       warn = TRUE, mess = TRUE, ...) {

  if (missing(formula)) errormsg("No model formula specified.")

  arglist <- prep_arglist(analysis_type = "mlogit",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
lme_imp <- function(fixed, data, random,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                    refcats = NULL, rd_vcov = "blockdiag",
                    models = NULL, no_model = NULL,
                    shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                    warn = TRUE, mess = TRUE, ...) {

  arglist <- prep_arglist(analysis_type = "lme",
                          family = gaussian(),
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  arglist <- check_fixed_random(arglist)

  do.call(model_imp, arglist)
}



#' @rdname model_imp
#' @aliases lme_imp
#' @export
lmer_imp <- lme_imp


#' @rdname model_imp
#' @aliases glmer_imp
#' @export
glme_imp <- function(fixed, data, random, family,
                     n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                     monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                     refcats = NULL, rd_vcov = "blockdiag",
                     models = NULL, no_model = NULL,
                     shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                     warn = TRUE, mess = TRUE, ...) {

  if (missing(family))
    errormsg("The argument %s needs to be specified.", dQuote(family))

  arglist <- prep_arglist(analysis_type = "glme",
                          family = family,
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  arglist <- check_fixed_random(arglist)

  do.call(model_imp, arglist)

}


#' @rdname model_imp
#' @aliases glme_imp
#' @export
glmer_imp <- glme_imp




#' @rdname model_imp
#' @export
betamm_imp <- function(fixed, random, data,
                       n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                       monitor_params = c(analysis_main = TRUE),
                       auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag",
                       models = NULL, no_model = NULL,
                       shrinkage = FALSE, ppc = TRUE, seed = NULL,
                       inits = NULL, warn = TRUE, mess = TRUE, ...) {

  arglist <- prep_arglist(analysis_type = "glmm_beta",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  arglist <- check_fixed_random(arglist)

  do.call(model_imp, arglist)
}




#' @rdname model_imp
#' @export
lognormmm_imp <- function(fixed, random, data,
                          n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                          monitor_params = c(analysis_main = TRUE),
                          auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag",
                          models = NULL, no_model = NULL,
                          shrinkage = FALSE, ppc = TRUE, seed = NULL,
                          inits = NULL, warn = TRUE, mess = TRUE, ...) {

  arglist <- prep_arglist(analysis_type = "glmm_lognorm",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  arglist <- check_fixed_random(arglist)

  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
clmm_imp <- function(fixed, data, random,
                     n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                     monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                     refcats = NULL, nonprop = NULL, rev = NULL,
                     rd_vcov = "blockdiag",
                     models = NULL, no_model = NULL,
                     shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                     warn = TRUE, mess = TRUE, ...) {

  arglist <- prep_arglist(analysis_type = "clmm",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  arglist <- check_fixed_random(arglist)

  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
mlogitmm_imp <- function(fixed, data, random,
                         n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                         monitor_params = c(analysis_main = TRUE),
                         auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag",
                         models = NULL, no_model = NULL,
                         shrinkage = FALSE, ppc = TRUE, seed = NULL,
                         inits = NULL,
                         warn = TRUE, mess = TRUE, ...) {

  arglist <- prep_arglist(analysis_type = "mlogitmm",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  arglist <- check_fixed_random(arglist)

  do.call(model_imp, arglist)
}


#' @rdname model_imp
#' @export
survreg_imp <- function(formula, data,
                        n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                        monitor_params = c(analysis_main = TRUE),
                        auxvars = NULL, refcats = NULL,
                        models = NULL, no_model = NULL,
                        shrinkage = FALSE, ppc = TRUE, seed = NULL,
                        inits = NULL,
                        warn = TRUE, mess = TRUE, ...) {


  if (missing(formula)) errormsg("No model formula specified.")


  fmla <- if (is.list(formula)) {
    paste(deparse(formula[[1]], width.cutoff = 500), collapse = " ")
  } else {
    paste(deparse(formula, width.cutoff = 500) , collapse = " ")
  }
  if (!grepl("^Surv\\(", fmla)) {
    errormsg("For a survival model, the left hand side of the model formula
             should be a survival object (using %s).", dQuote("Surv()"))
  }

  arglist <- prep_arglist(analysis_type = "survreg",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))

  do.call(model_imp, arglist)
}



#' @rdname model_imp
#' @export
coxph_imp <- function(formula, data, df_basehaz = 6,
                      n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                      monitor_params = c(analysis_main = TRUE),  auxvars = NULL,
                      refcats = NULL,
                      models = NULL, no_model = NULL,
                      shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                      warn = TRUE, mess = TRUE, ...) {


  if (missing(formula)) errormsg("No model formula specified.")

  fmla <- if (is.list(formula)) {
    paste(deparse(formula[[1]], width.cutoff = 500), collapse = " ")
  } else {
    paste(deparse(formula, width.cutoff = 500), collapse = " ")
  }
  if (!grepl("^Surv\\(", fmla)) {
    errormsg("For a survival model, the left hand side of the model formula
             should be a survival object (using %s).", dQuote("Surv()"))
  }


  arglist <- prep_arglist(analysis_type = "coxph",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))


  do.call(model_imp, arglist)
}



#' @rdname model_imp
#' @export
JM_imp <- function(formula, data, df_basehaz = 6,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                   monitor_params = c(analysis_main = TRUE), auxvars = NULL,
                   timevar = NULL, refcats = NULL, rd_vcov = "blockdiag",
                   models = NULL, no_model = NULL,
                   assoc_type = NULL,
                   shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                   warn = TRUE, mess = TRUE, ...) {


  if (missing(timevar))
    errormsg("The name of the %s variable of the longitudinal outcome(s) must
             be specified via the argument %s.",
             dQuote("time"), dQuote("timevar"))

  if (!is.numeric(data[[timevar]]))
    errormsg("The time variable (specified via the argument %s) must
             be numeric.",
             dQuote("timevar"))


  if (missing(formula)) errormsg("No model formula specified.")

  fmla <- if (is.list(formula)) {
    paste(deparse(formula[[1]], width.cutoff = 500), collapse = " ")
  } else {
    paste(deparse(formula, width.cutoff = 500), collapse = " ")
  }
  if (!grepl("^Surv\\(", fmla)) {
    errormsg("For a survival model, the left hand side of the model formula
             should be a survival object (using %s).", dQuote("Surv()"))
  }


  arglist <- prep_arglist(analysis_type = "JM",
                          formals = formals(), call = match.call(),
                          sframe = sys.frame(sys.nframe()))


  do.call(model_imp, arglist)
}
