------------------------------------------------------------------------

## TCGAmutations - An R data package for TCGA somatic mutations

------------------------------------------------------------------------

### Introduction
TCGAmutations is an R data package containing somatic mutations from TCGA cohorts. This is particularly useful for those working with mutation data from TCGA studies - where most of the time is spent on searching various databases, downloading, compiling and tidying up the data before even the actual analysis is started. This package tries to mitigate the issue by providing pre-compiled, curated somatic mutations from 33 TCGA cohorts along with relevant clinical information for all sequenced samples.

### Data source
There are two sources from which MAF files were compiled:

  * [Broad Firehose](http://firebrowse.org/)
  * [TCGA MC3](https://gdc.cancer.gov/about-data/publications/mc3-2017)

### Installation

```r
devtools::install_github(repo = "PoisonAlien/TCGAmutations")
```

### Requirements

Only dependency is Bioconductor package [maftools](http://www.bioconductor.org/packages/release/bioc/html/maftools.html) and all TCGA cohorts are stored as MAF objects. You can install stable version of maftools package from Bioconductor if you do not have it installed already.

```r
source("https://bioconductor.org/biocLite.R")
biocLite("maftools")
```

Or you can install it from GitHub for developmental version.

```r
devtools::install_github(repo = "PoisonAlien/maftools")
```

## References

Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines
Kyle Ellrott, Matthew H. Bailey, Gordon Saksena, et. al. Cell Syst. 2018 Mar 28; 6(3): 271–281.e7. https://doi.org/10.1016/j.cels.2018.03.002
  
