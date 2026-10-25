# (Re-)create the golden master files for test-golden_master.R.
#
# Only run this with the maintainer's approval: it overwrites the reference
# results. Run from the package root:
#   Rscript tests/testthat/golden/make_golden.R
#
# The cases and the data are defined in tests/testthat/helper-golden.R.

devtools::load_all(".", quiet = TRUE)
source(file.path("tests", "testthat", "helper-golden.R"))

golden_dir <- file.path("tests", "testthat", "golden")
data <- golden_data()
cases <- golden_cases()

# remove files of cases that no longer exist
old <- setdiff(
  list.files(golden_dir, pattern = "\\.rds$"),
  c(paste0(names(cases), ".rds"), "info.rds")
)
file.remove(file.path(golden_dir, old))

for (k in names(cases)) {
  message("Creating golden master for ", k)
  saveRDS(
    golden_fit(cases[[k]], data),
    file.path(golden_dir, paste0(k, ".rds")),
    version = 3
  )
}

# where and with which versions the files were created
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
    rjags_version = as.character(packageVersion("rjags"))
  ),
  file.path(golden_dir, "info.rds"),
  version = 3
)
