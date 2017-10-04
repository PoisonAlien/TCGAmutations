## ---- eval=FALSE---------------------------------------------------------
#  source("https://bioconductor.org/biocLite.R")
#  biocLite("maftools")

## ---- eval=FALSE---------------------------------------------------------
#  devtools::install_github(repo = "PoisonAlien/maftools")

## ------------------------------------------------------------------------
library(TCGAmutations)

tcga_available()

## ------------------------------------------------------------------------
tcga_load(study = "LAML")

#Typing tcga_laml prints summary of the object
tcga_laml

## ------------------------------------------------------------------------
#Shows sample summary
getSampleSummary(x = tcga_laml)

#Shows gene summary
getGeneSummary(x = tcga_laml)

#Clinical data; printing only first ten columns for display convenience
getClinicalData(x = tcga_laml)[1:10, 1:10]

## ------------------------------------------------------------------------
sessionInfo()

