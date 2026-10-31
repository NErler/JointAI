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
extract_state <- function(
  object,
  pattern = paste0("^", c("RinvD", "invD", "tau", "b"), "_")
) {
  if (!inherits(object, "JointAI")) {
    errormsg("Use only with 'JointAI' objects.")
  }

  # [[ ]] instead of $, which would partially match the element "models"
  model <- object[["model"]]
  if (is.null(model)) {
    errormsg(
      "The object does not contain the JAGS model (it is only kept when the
      model is fitted with %s).",
      dQuote("n.adapt > 0")
    )
  }

  jags_model_type <- if (inherits(model, "list")) {
    "list"
  } else {
    "jags"
  }

  nodes <- unlist(
    lapply(
      pattern,
      grep,
      x = switch(
        jags_model_type,
        "list" = names(model[[1]]$state()[[1]]),
        "jags" = names(model$state()[[1]])
      ),
      value = TRUE
    )
  )

  switch(
    jags_model_type,
    "list" = lapply(model, function(mod) {
      mod$state()[[1]][nodes]
    }),
    "jags" = lapply(model$state(), function(chain) {
      chain[nodes]
    })
  )
}
