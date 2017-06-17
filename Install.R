#!/usr/bin/env Rscript

#' Makes sure the R_LIBS_USER directory is installed
#' R_LIBS_USER is set when R is executed
dir.create(Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)

#' installs packages which are not yet installed
#' @param pkg list of package names
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg,
                     dependencies = TRUE,
                     repos = "https://cran.rstudio.com")
  sapply(pkg, require, character.only = TRUE)
}

### install base packages
base_packages <- c(
  "devtools",
  "tidyverse",
  "reshape2"
)
ipak(base_packages)

### install tools from github
devtools::install_github("klutometis/roxygen")  # for package generation
