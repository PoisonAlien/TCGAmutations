------------------------------------------------------------------------

## TCGAmutations - An R data package for TCGA somatic mutations

------------------------------------------------------------------------

### Introduction
TCGAmutations is an R data package containing somatic mutations from TCGA cohorts. This is particularly useful for those working with mutation data from TCGA studies - where most of the time is spent on searching various databases, downloading, compiling and tidying up the data before even the actual analysis is started. This package tries to mitigate the issue by providing pre-compiled, curated somatic mutations from 32 TCGA cohorts along with relevant clinical information for all sequenced samples.

### Installation

```{r, eval=FALSE}
devtools::install_github(repo = "PoisonAlien/TCGAmutations")
```

#Requirements

Only dependency is Bioconductor package [maftools](http://www.bioconductor.org/packages/release/bioc/html/maftools.html) and all TCGA cohorts are stored as MAF objects. You can install stable version of maftools package from Bioconductor if you do not have it installed already.

```{r, eval=FALSE}
source("https://bioconductor.org/biocLite.R")
biocLite("maftools")
```

Or you can install it from GitHub for developmental version.

```{r, eval=FALSE}
devtools::install_github(repo = "PoisonAlien/maftools")
```
