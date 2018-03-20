# Extract id variable from random effects formula
extract_id <- function(random) {
  idmatch <- regexpr(pattern = "[[:print:]]*\\|[[:space:]]*",
                     deparse(random, width.cutoff = 500))
  if (idmatch > 0) {
    id <- unlist(regmatches(deparse(random, width.cutoff = 500),
                            idmatch, invert = T))
    id <- id[id != ""]
  } else {
    id <- NULL
  }

  if (is.null(id) & !is.null(random))
    warning('No "id" variable could be identified. I will assume that all observations are independent.',
            call. = F, immediate. = T)
  return(id)
}


# Extract outcome variable from fixed effects formula
extract_y <- function(fixed) {
  if (!inherits(fixed, "formula")) {
    fixed <- as.formula(fixed)
  }
  y <- sub("[[:space:]]*\\~[[:print:]]*", "",
           deparse(fixed, width.cutoff = 500))
  if (y == "" | is.na(y) | is.null(y)) {
    stop("Unable to extract the outcome variable.")
  }
  return(y)
}


# Remove grouping from formula
remove_grouping <- function(fmla){
  if (is.null(fmla)) return(NULL)

  fmla2 <- sub("[[:space:]]*\\|[[:print:]]*", "",
               deparse(fmla, width.cutoff = 500))
  if (class(fmla) == "formula") {
    as.formula(fmla2)
  } else {
    fmla2
  }
}



#' Check if a variable is time-varying
#' @param x a vector, the variable to be tested
#' @param idvar a vector specifying a grouping
#' @keywords internal
#' @return a logical value
check_tvar <- function(x, idvar) {
  !all(sapply(split(x, idvar),
              function(z) all(z == z[1], na.rm = T)
  )
  )
}


# Find position of variable names in a vector of variable names
find_positions <- function(nams1, nams2) {
  nams1 <- gsub("^", "\\^", nams1, fixed = TRUE)
  vals <- c(glob2rx(nams1), glob2rx(paste0(nams1, ":*")),
            glob2rx(paste0("*:", nams1)))
  out <- unique(unlist(lapply(vals, grep, x = nams2)))
  out
}



# Find the position(s) of a variable in a model matrix
match_positions <- function(varname, DF, colnams) {
  if (is.factor(DF[, varname])) {
    contr <- list("contr.treatment")
    names(contr) <- varname
  } else {
    contr <- NULL
  }

  matches <- match(colnames(model.matrix(formula(paste("~", varname)),
                                         DF,
                                         contrasts.arg = contr))[-1L],
                   colnams)
  names(matches) <- colnams[matches]
  return(if (any(!is.na(matches))) matches)
}



prep_name <- function(nam) {
  glob2rx(gsub("^", "\\^", nam, fixed = T))
}

# Generate pattern (used in get_hc_list)
gen_pat <- function(nam) {
  nam <- gsub("^", "\\^", nam, fixed = T)
  glob2rx(c(nam,
            paste0("*:", nam),
            paste0(nam, ":*")), trim.head = T)
}

# Find names in a vector of names (used in get_hc_list)
grep_names <- function(nams1, nams2){
  res <- unique(unlist(sapply(nams1, grep, nams2, value = T, simplify = F)))
  if (length(res) > 0) res
}


# Hierarchical centering structure
# @param X2_names vector of column names in the extended fixed effects design matrix
# @param Z_names vector of column names of the random effects design matrix
# @param Xc_names vector of column names of the matrix of baseline covariates
# @return A named list with an entry for each level of random effects, omitting
#         the random intercept. Each list entry is a named vector, where the
#         names represent the variable names of either the main effect of a
#         variable that is part of the random and fixed effects structure, or
#         the name of a variable that has an interaction with the variable for
#         which there is a random effect. The values represent the column
#         number of the respective matrix for the variable (for interaction terms
#         the column number of the variable that is not the respective
#         random effect). The attribute
#         "matrix" names the matrix (Z or Xc), and is NA when the variable
#         is not in either of the two matrices.
#
get_hc_list <- function(X2, Xc, Xic, Z, Xlong) {
  hc_vars <- hc_list <- if (ncol(Z) > 1) {
    lapply(sapply(colnames(Z)[-1], gen_pat, simplify = F),
           grep_names, colnames(X2))
  }
  for (i in 1:length(hc_vars)) {
    if (length(hc_vars[[i]]) > 0) {
      matchvars <- gsub(paste(gen_pat(names(hc_vars)[i]), collapse = "|"),
                        "", hc_vars[[i]])

      a <- sapply(
        apply(
          as.array(sapply(
            lapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), colnames),
            FUN = function(x) matchvars %in% x)), 1, which), names)


      a[matchvars == ""] <- "Z"
      a <- unlist(a)
      names(a) <- hc_vars[[i]]

      pos <- mapply(FUN = function(i, i_nam) {
        match(i_nam, lapply(list(Xc = Xc, Xic = Xic, Z = Z, Xlong = Xlong), colnames)[[i]])
      }, i = a, i_nam = matchvars)

      attr(pos, "matrix") <- a
      hc_list[[i]] <- pos
    }
  }
  return(hc_list)
}




capitalize <- function(string)
{
  capped <- grep("^[^A-Z]*$", string, perl = TRUE)
  substr(string[capped], 1, 1) <- toupper(substr(string[capped],
                                                 1, 1))
  return(string)
}



# Function to find the names of columns in the model matrix that involve
# continuous covariates (and hence may need to be scaled)
# for now not used
find_continuous <- function(fixed, DF, contr = NULL) {
  # remove left side of formula
  fmla <- as.formula(sub("[[:print:]]*\\~", "~",
                         deparse(fixed, width.cutoff = 500)))

  # check which variables involved are continuous
  is_continuous <- !sapply(DF[, all.vars(fmla)], is.factor)

  elmts <- attr(terms(fmla), "term.labels")

  fixed_c <- as.formula(
    paste("~",
          paste(elmts[unique(unlist(sapply(names(is_continuous)[is_continuous],
                                           grep, elmts)))],
                collapse = " + ")
    )
  )

  colnames(model.matrix(fixed_c, DF, contrasts.arg = contr)[, -1L , drop = F])
}


# Function to find the names of columns in the model matrix that involve
# continuous covariates (and hence may need to be scaled) - only main effects
find_continuous_main <- function(fixed, DF) {
  # remove left side of formula
  fmla <- as.formula(sub("[[:print:]]*\\~", "~",
                         deparse(fixed, width.cutoff = 500)))

  # check which variables involved are continuous
  is_continuous <- !sapply(model.frame(fmla, DF), is.factor)
  # Note: does this have to be so complicated? can't I just take the columns of DF???

  names(is_continuous)[is_continuous]
}



# Split an * in a formula into + and :
split_interaction <- function(x) {
  elmts <- strsplit(x, "[*]")[[1]]
  paste(c(elmts, paste(elmts, collapse = ":")), collapse = " + ")
}


# Extract functions from formula
extract_fcts <- function(fixed, DF, complete = F) {
  log_pat <- "log\\([[:print:]]+\\)"
  I_pat <- "I\\([[:print:]]+\\)"
  exp_pat <- "exp\\([[:print:]]+\\)"
  sqrt_pat <- "sqrt\\([[:print:]]+\\)"
  spline_pat <- "[nb]s\\([[:print:]]+\\)"

  # pattern to extract variable(s) from function
  # var_pat <- "[[:print:]]+\\(.+\\)"
  var_pat <- "\\(.+\\)"


  # remove outcome from formula
  predictor <- as.formula(sub("[[:print:]]*\\~", "~",
                              deparse(fixed, width.cutoff = 500)))

  # split into elements
  elmts <- unique(unlist(strsplit(deparse(predictor, width.cutoff = 500), "[ ]*[+*~][ ]*")))
  elmts <- gsub("\\)$", "", gsub("^\\(", "", elmts))

  # find functions
  m <- gregexpr(pattern = "[[:alpha:]]*\\([^)]*\\)",
                text = deparse(predictor, width.cutoff = 500))
  fkts <- unlist(regmatches(deparse(predictor, width.cutoff = 500), m))


  m_log <- regexpr(log_pat, fkts)
  m_I <- regexpr(I_pat, fkts)
  m_exp <- regexpr(exp_pat, fkts)
  m_sqrt <- regexpr(sqrt_pat, fkts)
  # m_spline <- regexpr(spline_pat, fkts)


  log_fcts = regmatches(fkts, m_log)
  I_fcts = gsub("I\\(|\\)", "", regmatches(fkts, m_I))
  exp_fcts = regmatches(fkts, m_exp)
  sqrt_fcts = regmatches(fkts, m_sqrt)
  # spline_fcts = regmatches(fkts, m_spline)


  I_Xc_var <- regmatches(fkts, m_I)
  log_Xc_var <- log_fcts
  sqrt_Xc_var <- sqrt_fcts
  exp_Xc_var <- exp_fcts


  m_log <- regexpr(var_pat, log_fcts)
  m_I <- regexpr(var_pat, I_fcts)
  m_exp <- regexpr(var_pat, exp_fcts)
  m_sqrt <- regexpr(var_pat, sqrt_fcts)



  log_vars <- strsplit(gsub("[\\(\\)]", "", regmatches(log_fcts, m_log)),
                       "[ ]*[+\\-\\*/:][ ]*")
  I_vars <- strsplit(I_fcts, "[ ]*[+\\-\\*/:][ ]*|\\^[[:digit:]]*")
  exp_vars <- strsplit(gsub("[\\(\\)]", "", regmatches(exp_fcts, m_exp)),
                       "[ ]*[+\\-\\*/:][ ]*")
  sqrt_vars <- strsplit(gsub("[\\(\\)]", "", regmatches(sqrt_fcts, m_sqrt)),
                        "[ ]*[+\\-\\*/:][ ]*")


  for (q in seq_along(I_vars)) {
    for (k in seq_along(I_vars[[q]])) {
      if (!I_vars[[q]][k] %in% names(DF)) {
        if (inherits(try(eval(parse(text = I_vars[[q]][k]))), "try-error")) {
          stop(gettextf("Can not find %s.", dQuote(I_vars[[q]][k])))
        } else {
          I_vars[[q]] <- I_vars[[q]][-k]
        }
      }
    }
  }

  var_fcts <- as.data.frame(
    do.call(rbind,
            sapply(c("log", "I", "exp", "sqrt"), function(x) {
              if (length(get(paste0(x, "_vars"))) > 0) {
                cbind(var = unlist(get(paste0(x, "_vars"))),
                      Xc_var = rep(get(paste0(x, "_Xc_var")),
                                   sapply(get(paste0(x, "_vars")), length)),
                      fct = rep(get(paste0(x, "_fcts")),
                                sapply(get(paste0(x, "_vars")), length)),
                      type = x)
              }
            })
    ), stringsAsFactors = F)


  if (any(!var_fcts$var %in% names(DF)))
    stop(gettextf("Variable %s is unknown.",
                  dQuote(var_fcts$var[!var_fcts$var %in% names(DF)])))

  if (complete == F & nrow(var_fcts) > 0) {
    compl <- colSums(is.na(DF[, var_fcts$var, drop = F])) == 0
    partners <- sapply(var_fcts$Xc_var,
                       function(x) which(var_fcts$Xc_var %in% x), simplify = F)
    anymis <- sapply(partners, function(x) any(!compl[x]))
    var_fcts <- var_fcts[anymis, , drop = F]
  }

  if (any(unique(var_fcts$var) %in% elmts)) {
    add_vars <- intersect(unique(var_fcts$var), elmts)
    var_fcts <- rbind(var_fcts,
                      cbind(var = add_vars,
                            Xc_var = add_vars,
                            fct = paste0("I(", add_vars, ")"),
                            type = "identity")
    )
  }

  return(if (nrow(var_fcts) > 0) var_fcts)
}

