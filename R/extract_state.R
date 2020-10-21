#' Return the current state of a 'JointAI' model
#'
#' @param object an object of class 'JointAI'
#' @param pattern vector of patterns to be matched with the names of the nodes
#'
#' @return A list with one element per chain of the MCMC sampler, containing the
#'         Returns the current state of the MCMC sampler (values of the last
#'         iteration) for the subset of nodes identified based on the pattern
#'         the user has specified.
#' @export
#'
extract_state <- function(object,
                          pattern = paste0("^",
                                           c("RinvD", "invD", "tau", "b"),
                                           "_")) {

  jags_model_type <- if (inherits(object$model, "list")) {
    "list"
  } else {
    "jags"
  }

  nodes <- unlist(
    lapply(pattern,
           grep,
           x = switch(jags_model_type,
                      "list" = names(object$model[[1]]$state()[[1]]),
                      "jags" = names(object$model$state()[[1]])
           ),
           value = TRUE)
  )

  switch(jags_model_type,
         "list" = lapply(object$model, function(mod) {
           mod$state()[[1]][nodes]
         }),
         "jags" = lapply(object$model$state(), function(chain) {
           chain[nodes]
         })
  )
}
