run_vignette <- function(vignette_name) {
  rmd_name <- file.path("vignettes", paste0(vignette_name, ".Rmd"))
  knitr::knit(
    file.path("vignettes", paste0(vignette_name, ".Rmd.orig")),
    output = rmd_name
  )

  txt <- readLines(rmd_name)
  txt <- sub(
    "date: replace_with_today",
    paste0("date: ", format(Sys.Date(), "%B %d, %Y")),
    txt
  )
  writeLines(txt, rmd_name)

  if (dir.exists(file.path("vignettes", paste0("figures_", vignette_name)))) {
    unlink(
      file.path("vignettes", paste0("figures_", vignette_name)),
      recursive = TRUE
    )
    file.rename(
      from = paste0("figures_", vignette_name),
      to = paste0("vignettes/figures_", vignette_name)
    )
  }
}

# After fitting 56s ------------------------------------------------------------
run_vignette("AfterFitting")

# MCMC settings 8s -------------------------------------------------------------
# can be run directly

# Model Specification 9s -------------------------------------------------------
run_vignette("ModelSpecification")

# Minimal Example 10s ----------------------------------------------------------
run_vignette("MinimalExample")


# Selecting Parameters 17s -----------------------------------------------------
run_vignette("SelectingParameters")

# Visualizing Incomplete Data --------------------------------------------------
# can be run directly
