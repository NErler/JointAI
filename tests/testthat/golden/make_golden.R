# (Re-)create the golden master files for test-golden_master.R.
#
# Only run this with the maintainer's approval: it overwrites the reference
# results. Run from the package root:
#   Rscript tests/testthat/golden/make_golden.R        # all cases
#   Rscript tests/testthat/golden/make_golden.R new    # only new cases
#   Rscript tests/testthat/golden/make_golden.R lm_intercept lme_nested
#
# "new" only creates the files of cases that do not have a file yet and leaves
# the existing files unchanged (e.g. after adding cases to golden_cases()).
# With case names, only these files are re-created (recorded in info.rds).
# The cases and the data are defined in tests/testthat/helper-golden.R.

args <- commandArgs(TRUE)
what <- if (length(args) == 0) "all" else args
named <- !identical(what, "all") && !identical(what, "new")

devtools::load_all(".", quiet = TRUE)
source(file.path("tests", "testthat", "helper-golden.R"))

golden_dir <- file.path("tests", "testthat", "golden")
data <- golden_data()
cases <- golden_cases()

if (named) {
  unknown <- setdiff(what, names(cases))
  if (length(unknown) > 0) {
    stop("Unknown case(s): ", paste(unknown, collapse = ", "))
  }
  cases <- cases[what]
} else if (identical(what, "new")) {
  cases <- cases[
    !file.exists(file.path(golden_dir, paste0(names(cases), ".rds")))
  ]
} else {
  # remove files of cases that no longer exist
  old <- setdiff(
    list.files(golden_dir, pattern = "\\.rds$"),
    c(paste0(names(cases), ".rds"), "info.rds")
  )
  file.remove(file.path(golden_dir, old))
}

for (k in names(cases)) {
  message("Creating golden master for ", k)
  saveRDS(
    golden_fit(cases[[k]], data),
    file.path(golden_dir, paste0(k, ".rds")),
    version = 2,
    compress = "xz"
  )
}

# where and with which versions the files were created; for "new" and named
# cases, this is added to the existing information
created <- list(
  created = Sys.time(),
  git_commit = tryCatch(
    system("git rev-parse --short HEAD", intern = TRUE),
    error = function(e) NA_character_
  ),
  JointAI_version = as.character(packageVersion("JointAI")),
  R_version = R.version.string,
  platform = R.version$platform,
  rjags_version = as.character(packageVersion("rjags"))
)
info <- if (identical(what, "new")) {
  info <- readRDS(file.path(golden_dir, "info.rds"))
  info$added <- c(info$added, list(c(created, list(cases = names(cases)))))
  info
} else if (named) {
  info <- readRDS(file.path(golden_dir, "info.rds"))
  info$recreated <- c(
    info$recreated,
    list(c(created, list(cases = names(cases))))
  )
  info
} else {
  created
}
saveRDS(
  info,
  file.path(golden_dir, "info.rds"),
  version = 2,
  compress = "xz"
)
