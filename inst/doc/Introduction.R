## ---- eval=FALSE---------------------------------------------------------
#  source("https://bioconductor.org/biocLite.R")
#  biocLite("maftools")

## ---- eval=FALSE---------------------------------------------------------
#  devtools::install_github(repo = "PoisonAlien/maftools")

## ------------------------------------------------------------------------
library(maftools)
library(TCGAmutations)

TCGAmutations::tcga_available()

## ------------------------------------------------------------------------
TCGAmutations::tcga_load(study = "LAML")

#Typing tcga_laml prints summary of the object
tcga_laml_mc3

## ------------------------------------------------------------------------
#Shows sample summary
getSampleSummary(x = tcga_laml_mc3)

#Shows gene summary
getGeneSummary(x = tcga_laml_mc3)

#Clinical data; printing only first ten columns for display convenience
getClinicalData(x = tcga_laml_mc3)[1:10, 1:10]

## ------------------------------------------------------------------------
sessionInfo()

