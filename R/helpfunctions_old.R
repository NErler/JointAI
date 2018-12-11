


# # Find position of variable names in a vector of variable names
# find_positions <- function(nams1, nams2) {
#   nams1 <- gsub("^", "\\^", nams1, fixed = TRUE)
#   vals <- c(glob2rx(nams1), glob2rx(paste0(nams1, ":*")),
#             glob2rx(paste0("*:", nams1)))
#   out <- unique(unlist(lapply(vals, grep, x = nams2)))
#   out
# }
#

# prep_name <- function(nam) {
#   glob2rx(gsub("^", "\\^", nam, fixed = TRUE))
# }





# # Function to find the names of columns in the model matrix that involve
# # continuous covariates (and hence may need to be scaled)
# # for now not used
# find_continuous <- function(fixed, DF, contr = NULL) {
#   # remove left side of formula
#   fmla <- as.formula(sub("[[:print:]]*\\~", "~",
#                          deparse(fixed, width.cutoff = 500)))
#
#   # check which variables involved are continuous
#   is_continuous <- !sapply(DF[, all.vars(fmla)], is.factor)
#
#   elmts <- attr(terms(fmla), "term.labels")
#
#   fixed_c <- as.formula(
#     paste("~",
#           paste(elmts[unique(unlist(sapply(names(is_continuous)[is_continuous],
#                                            grep, elmts)))],
#                 collapse = " + ")
#     )
#   )
#
#   colnames(model.matrix(fixed_c, DF, contrasts.arg = contr)[, -1L , drop = FALSE])
# }
#
#
# # Function to find the names of columns in the model matrix that involve
# # continuous covariates (and hence may need to be scaled) - only main effects
# find_continuous_main <- function(fixed, DF) {
#   # remove left side of formula
#   fmla <- as.formula(sub("[[:print:]]*\\~", "~",
#                          deparse(fixed, width.cutoff = 500)))
#
#   # check which variables involved are continuous
#   is_continuous <- !sapply(model.frame(fmla, DF), is.factor)
#   # Note: does this have to be so complicated? can't I just take the columns of DF???
#
#   names(is_continuous)[is_continuous]
# }



# # Split an * in a formula into + and :
# split_interaction <- function(x) {
#   elmts <- strsplit(x, "[*]")[[1]]
#   paste(c(elmts, paste(elmts, collapse = ":")), collapse = " + ")
# }
#



# # define family weibull
# weibull <- function(link = 'log') {
#   structure(list(family = "weibull", link = 'log'),
#             class = "family")
# }
#
# ordinal <- function(link = 'identity') {
#   structure(list(family = "ordinal", link = 'identity'),
#             class = "family")
# }
#
# # # define family coxph
# # #' @export
# # prophaz <- function(link = 'log') {
# #   structure(list(family = "prophaz", link = 'log'),
# #             class = "family")
# # }

# #' @export
# logit <- function(x) {
#   log(x/(1-x))
# }
