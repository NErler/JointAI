# (Re-)create the fixtures and the expected results of the post-processing
# functions. Only run this with the maintainer's approval. Run from the package
# root:
#   Rscript tests/testthat/fixtures/make_fixtures.R            # everything
#   Rscript tests/testthat/fixtures/make_fixtures.R expected   # only results
#
# "expected" keeps the stored fitted models and only (re-)creates the expected
# results (e.g. after adding a new type of result to fixture_results()).
# The cases are defined in tests/testthat/helper-fixtures.R.

what <- commandArgs(TRUE)[1]
if (is.na(what)) {
  what <- "all"
}

devtools::load_all(".", quiet = TRUE)
# as in the tests (testthat sets this option): error messages stored as
# expected results use straight quotes
options(useFancyQuotes = FALSE)
source(file.path("tests", "testthat", "helper-golden.R"))
source(file.path("tests", "testthat", "helper-fixtures.R"))

fix_dir <- file.path("tests", "testthat", "fixtures")
exp_dir <- file.path(fix_dir, "expected")
dir.create(exp_dir, showWarnings = FALSE, recursive = TRUE)

cases <- fixture_cases()

if (what == "all") {
  data <- golden_data()
  for (k in names(cases)) {
    message("Fitting fixture ", k)
    saveRDS(
      fixture_fit(cases[[k]], data),
      file.path(fix_dir, paste0(k, ".rds")),
      version = 2
    )
  }
  saveRDS(
    list(
      created = Sys.time(),
      git_commit = tryCatch(
        system("git rev-parse --short HEAD", intern = TRUE),
        error = function(e) NA_character_
      ),
      JointAI_version = as.character(packageVersion("JointAI")),
      R_version = R.version.string,
      platform = R.version$platform,
      rjags_version = as.character(packageVersion("rjags")),
      JAGS_version = as.character(rjags::jags.version())
    ),
    file.path(fix_dir, "info.rds"),
    version = 2
  )
}

results <- fixture_results()
for (k in names(cases)) {
  fit <- readRDS(file.path(fix_dir, paste0(k, ".rds")))
  for (type in names(results)) {
    message("Expected ", type, " for ", k)
    saveRDS(
      results[[type]](fit),
      file.path(exp_dir, paste0(k, "_", type, ".rds")),
      version = 2
    )
  }
}
