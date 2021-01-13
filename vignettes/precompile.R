# After fitting 56s ------------------------------------------------------------
knitr::knit("vignettes/AfterFitting.Rmd.orig",
            output = "vignettes/AfterFitting.Rmd")

if (dir.exists("vignettes/figures_AfterFitting")) {
  unlink("vignettes/figures_AfterFitting", recursive = TRUE)
}
file.rename(from = "figures_AfterFitting",
            to = "vignettes/figures_AfterFitting")



# MCMC settings 8s -------------------------------------------------------------
# knitr::knit("vignettes/MCMCsettings.Rmd.orig",
#             output = "vignettes/MCMCsettings.Rmd")
#
# file.rename(from = "figures_MCMCsettings",
#             to = "vignettes/figures_MCMCsettings")


# Model Specification 9s -------------------------------------------------------
knitr::knit("vignettes/ModelSpecification.Rmd.orig",
            output = "vignettes/ModelSpecification.Rmd")

if (dir.exists("vignettes/figures_ModelSpecification")) {
  unlink("vignettes/figures_ModelSpecification", recursive = TRUE)
}
file.rename(from = "figures_ModelSpecification",
            to = "vignettes/figures_ModelSpecification")


# Minimal Example 10s ----------------------------------------------------------
knitr::knit("vignettes/MinimalExample.Rmd.orig",
            output = "vignettes/MinimalExample.Rmd")

if (dir.exists("vignettes/figures_MinimalExample")) {
  unlink("vignettes/figures_MinimalExample", recursive = TRUE)
}
file.rename(from = "figures_MinimalExample",
            to = "vignettes/figures_MinimalExample")


# Selecting Parameters 17s -----------------------------------------------------
knitr::knit("vignettes/SelectingParameters.Rmd.orig",
            output = "vignettes/SelectingParameters.Rmd")

if (dir.exists("vignettes/figures_SelectingParameters")) {
  unlink("vignettes/figures_SelectingParameters", recursive = TRUE)
}
file.rename(from = "figures_SelectingParameters",
            to = "vignettes/figures_SelectingParameters")


# Visualizing Incomplete Data --------------------------------------------------
# knitr::knit("vignettes/VisualizingIncompleteData.Rmd.orig",
#             output = "vignettes/VisualizingIncompleteData.Rmd")
#
# file.rename(from = "figures_VisualizingIncompleteData",
#             to = "vignettes/figures_VisualizingIncompleteData")

