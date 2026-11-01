# The name of a deprecated function must be correct in the warning also if it is
# called via `lapply()`, as `melt_data.frame_list()` does; otherwise, R takes the
# name from the call ("FUN"). The deprecated functions are called with an
# argument that is not valid: only the warning is of interest, and it is the
# first thing they do.
deprecated_functions <- c(
  identify_level_relations = "get_grouping_levels",
  check_cluster = "get_groups",
  extract_id = "extract_grouping",
  check_varlevel = "get_datlvls",
  extract_lhs = "extract_lhs_string",
  extract_outcome = "extract_outcomes_list",
  melt_data.frame = "melt_data_frame"
)

for (old in names(deprecated_functions)) {
  test_that(paste("deprecation warning of", old), {
    message <- tryCatch(
      lapply(list(NULL), get(old)),
      warning = function(w) conditionMessage(w)
    )

    expect_match(message, paste0("'", old, "' is deprecated"), fixed = TRUE)
    expect_match(
      message,
      paste0("Use '", deprecated_functions[[old]], "' instead"),
      fixed = TRUE
    )
  })
}

test_that("melt_data.frame_list() names melt_data.frame() in its warning", {
  data_list <- list(a = data.frame(x = 1:2, y = 3:4))

  expect_warning(
    melt_data.frame_list(data_list, id.vars = "x"),
    "'melt_data.frame' is deprecated",
    fixed = TRUE
  )
})
