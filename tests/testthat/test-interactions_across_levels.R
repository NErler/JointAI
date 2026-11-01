# The model re-calculates interaction terms that involve incomplete variables,
# on the lowest level of the variables in the interaction. Variables of a higher
# level are linked via group_<level>, which has one entry per row of the data.
# The loop runs over the units of the lowest level of the interaction, so unless
# that is "lvlone", the index has to be translated to a row with pos_<level>.

# a single interaction, in the structure of Mlist$interactions
make_interaction <- function(interterm, elmts) {
  structure(list(interterm = interterm, elmts = elmts), has_NAs = TRUE)
}

test_that("paste_interactions() links the levels via the rows of the data", {
  group_lvls <- c(region = 4, center = 3, id = 2, lvlone = 1)
  n <- c(region = 2, center = 5, id = 40, lvlone = 150)

  interactions <- list(
    # lowest level: the index is already a row
    "x:u" = make_interaction(
      interterm = c(M_lvlone = 3),
      elmts = c(M_lvlone = 1, M_id = 2)
    ),
    # subject level, one level higher
    "x:z" = make_interaction(
      interterm = c(M_id = 2),
      elmts = c(M_id = 1, M_center = 2)
    ),
    # subject level, two levels higher
    "x:r" = make_interaction(
      interterm = c(M_id = 3),
      elmts = c(M_id = 1, M_region = 2)
    ),
    # center level, one level higher
    "z:r" = make_interaction(
      interterm = c(M_center = 3),
      elmts = c(M_center = 2, M_region = 2)
    ),
    # all elements on the same level
    "x:w" = make_interaction(
      interterm = c(M_id = 5),
      elmts = c(M_id = 1, M_id = 4)
    ),
    # three elements on different levels
    "x:z:r" = make_interaction(
      interterm = c(M_id = 6),
      elmts = c(M_id = 1, M_center = 2, M_region = 2)
    )
  )

  model_text <- paste(
    paste_interactions(interactions, group_lvls = group_lvls, n = n),
    collapse = "\n"
  )

  expected <- c(
    "M_lvlone[i, 3] <- M_lvlone[i, 1] * M_id[group_id[i], 2]",
    "M_id[ii, 2] <- M_id[ii, 1] * M_center[group_center[pos_id[ii]], 2]",
    "M_id[ii, 3] <- M_id[ii, 1] * M_region[group_region[pos_id[ii]], 2]",
    "M_center[iii, 3] <- M_center[iii, 2] * M_region[group_region[pos_center[iii]], 2]",
    "M_id[ii, 5] <- M_id[ii, 1] * M_id[ii, 4]",
    paste0(
      "M_id[ii, 6] <- M_id[ii, 1] * M_center[group_center[pos_id[ii]], 2] * ",
      "M_region[group_region[pos_id[ii]], 2]"
    )
  )

  for (line in expected) {
    expect_true(grepl(line, model_text, fixed = TRUE), info = line)
  }
})


test_that("an interaction across levels uses the values of the right center", {
  skip_on_cran()

  # subjects with different numbers of rows, whose order is not related to the
  # centers, so that row number and subject number lead to different centers
  set.seed(2)
  n_id <- 20
  subjects <- data.frame(
    id = seq_len(n_id),
    center = sample(rep(1:4, length.out = n_id))
  )
  subjects$z <- c(0.1, 1.8, 2.0, -4.6)[subjects$center]
  subjects$x <- rnorm(n_id)
  subjects$x[c(3, 8, 15)] <- NA
  dat <- subjects[rep(seq_len(n_id), times = 2 + seq_len(n_id) %% 3), ]
  dat$y <- rnorm(nrow(dat))

  mod <- lme_imp(
    y ~ x * z + (1 | id) + (1 | center),
    data = dat,
    n.adapt = 5,
    n.iter = 5,
    seed = 1,
    mess = FALSE,
    monitor_params = list(other = "M_id")
  )

  # the interaction term has to be the product of x and z of the same subject,
  # in each iteration
  x_col <- match("x", colnames(mod$data_list$M_id))
  inter_col <- match("x:z", colnames(mod$data_list$M_id))
  mcmc <- as.matrix(mod$MCMC)

  for (i in seq_len(n_id)) {
    x <- mcmc[, sprintf("M_id[%d,%d]", i, x_col)]
    inter <- mcmc[, sprintf("M_id[%d,%d]", i, inter_col)]
    expect_equal(
      unname(inter),
      unname(x) * subjects$z[i],
      info = paste("subject", i)
    )
  }
})
