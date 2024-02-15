------------------------------------------------------------------------

## TCGAmutations - An R data package for TCGA somatic mutations

------------------------------------------------------------------------

### Introduction
`TCGAmutations` is an R data package containing somatic mutations from TCGA cohorts. This is particularly useful for those working with mutation data from TCGA studies - where most of the time is spent on searching various databases, downloading, compiling and tidying up the data before even the actual analysis is started. This package tries to mitigate the issue by providing pre-compiled, curated somatic mutations from 33 TCGA cohorts along with relevant clinical information for all sequenced samples.


### Installation

```r
BiocManager::install("PoisonAlien/TCGAmutations")
```

### TCGA cohorts

`tcga_available()` function lists the available cohorts along with the source, sample size and DOI for citation.

```r
>TCGAmutations::tcga_available()
 Study_Abbreviation   MC3                          Firehose
                <char> <int>                            <char>
 1:                ACC    92  62 [dx.doi.org/10.7908/C1610ZNC]
 2:               BLCA   411 395 [dx.doi.org/10.7908/C1MW2GGF]
 3:               BRCA  1026 978 [dx.doi.org/10.7908/C1TB167Z]
 4:               CESC   291 194 [dx.doi.org/10.7908/C1MG7NV6]
 5:               CHOL    36  35 [dx.doi.org/10.7908/C1K936V8]
 6:               COAD   406 367 [dx.doi.org/10.7908/C1DF6QJD]
 7:               DLBC    37  48 [dx.doi.org/10.7908/C1X066DK]
 8:               ESCA   185 185 [dx.doi.org/10.7908/C1BV7FZC]
 9:                GBM   400 283 [dx.doi.org/10.7908/C1XG9QGN]
10:               HNSC   509 511 [dx.doi.org/10.7908/C18C9VM5]
11:               KICH    66  66 [dx.doi.org/10.7908/C1765DQK]
12:               KIRC   370 476 [dx.doi.org/10.7908/C10864RM]
13:               KIRP   282 282 [dx.doi.org/10.7908/C19C6WTF]
14:               LAML   140 193 [dx.doi.org/10.7908/C1D21X2X]
15:                LGG   525 516 [dx.doi.org/10.7908/C1MC8ZDF]
16:               LIHC   365 373 [dx.doi.org/10.7908/C128070B]
17:               LUAD   517 533 [dx.doi.org/10.7908/C17P8XT3]
18:               LUSC   485 178 [dx.doi.org/10.7908/C1X34WXV]
19:               MESO    82                                  
20:                 OV   411 466 [dx.doi.org/10.7908/C1736QC5]
21:               PAAD   178 126 [dx.doi.org/10.7908/C1513XNS]
22:               PCPG   184 179 [dx.doi.org/10.7908/C13T9GN0]
23:               PRAD   498 498 [dx.doi.org/10.7908/C1Z037MV]
24:               READ   150 122 [dx.doi.org/10.7908/C1S46RDB]
25:               SARC   239 247 [dx.doi.org/10.7908/C137785M]
26:               SKCM   468 290 [dx.doi.org/10.7908/C1J67GCG]
27:               STAD   439 393 [dx.doi.org/10.7908/C1C828SM]
28:               TGCT   134 147 [dx.doi.org/10.7908/C1S1820D]
29:               THCA   500 496 [dx.doi.org/10.7908/C16W99KN]
30:               THYM   123 120 [dx.doi.org/10.7908/C15T3JZ6]
31:               UCEC   531 248 [dx.doi.org/10.7908/C1C828T2]
32:                UCS    57  57 [dx.doi.org/10.7908/C1PC31W8]
33:                UVM    80  80 [dx.doi.org/10.7908/C1S1821V]
    Study_Abbreviation   MC3                          Firehose
```

### Usage

There are only two commands 

   * `tcga_available()` - Lists the available cohorts in the package
   * `tcga_load()` - Takes a cohort name and returns the corresponding MAF object 

There are two sources from which MAF files were compiled:

  * [TCGA MC3](https://gdc.cancer.gov/about-data/publications/mc3-2017)
  * [Broad Firehose](http://firebrowse.org/)

### MC3

```r
> luad <- TCGAmutations::tcga_load(study = "LUAD")
Loading LUAD. Please cite: https://doi.org/10.1016/j.cels.2018.03.002 for reference
> luad
An object of class  MAF 
                        ID summary    Mean Median
                    <char>  <char>   <num>  <num>
 1:             NCBI_Build  GRCh37      NA     NA
 2:                 Center       .      NA     NA
 3:                Samples     517      NA     NA
 4:                 nGenes   17130      NA     NA
 5:        Frame_Shift_Del    4021   7.778      5
 6:        Frame_Shift_Ins    1185   2.292      1
 7:           In_Frame_Del     388   0.750      0
 8:           In_Frame_Ins      37   0.072      0
 9:      Missense_Mutation  133671 258.551    177
10:      Nonsense_Mutation   11074  21.420     13
11:       Nonstop_Mutation     179   0.346      0
12:            Splice_Site    4469   8.644      5
13: Translation_Start_Site     225   0.435      0
14:                  total  155249 300.288    202
```

### Firehose

Change `source` argument to `Firehose` for MAF files from [Broad Firehose](https://gdac.broadinstitute.org)

**WARNING:** Use Firehose data at your own risk. MAF data has not been updated in a long time. It is strongly suggested to use the default `MC3` cohort

```r
> TCGAmutations::tcga_load(study = "LUAD", source = "Firehose")
Loading LUAD. Please cite: dx.doi.org/10.7908/C17P8XT3 for reference
An object of class  MAF 
                   ID       summary    Mean Median
 1:        NCBI_Build            37      NA     NA
 2:            Center broad.mit.edu      NA     NA
 3:           Samples           533      NA     NA
 4:            nGenes         16515      NA     NA
 5:   Frame_Shift_Del          4018   7.538      5
 6:   Frame_Shift_Ins          1409   2.644      2
 7:      In_Frame_Del           526   0.987      1
 8:      In_Frame_Ins            74   0.139      0
 9: Missense_Mutation        119156 223.557    157
10: Nonsense_Mutation          9521  17.863     12
11:  Nonstop_Mutation           157   0.295      0
12:       Splice_Site          7675  14.400      9
13:             total        142536 267.422    187
```

Returned MAF objects can be passed to any functions from [maftools](https://bioconductor.org/packages/release/bioc/html/maftools.html) for visualization and analysis.


### Clinical data

Clinical data for MC3 are obtained from harmonized [clinical data resource](https://www.cell.com/cell/fulltext/S0092-8674(18)30229-0). Thanks to [@mitchellcheung8](https://github.com/mitchellcheung8) for pointing to the reference and the data source.


Recommendations for survival analysis (as suggested by the publication)


> Recommended use of the endpoints:	
> For clinical outcome endpoints, we recommend the use of `PFI` for progression-free interval, and `OS` for overall survival. Both endpoints are relatively accurate. Given the relatively short follow-up time, `PFI` is  preferred over `OS`. Detailed recommendations please refer to Table 3 in the accompanying paper.

Below are the column names for the event and the timepoint.

| endpoint                        | event column name | timepoint column name |
|---------------------------------|-------------------|-----------------------|
| PFI (Progression-free interval) | `CDR_PFI`           | `CDR_PFI.time`          |
| OS (Overall survival)           | `CDR_OS`           | `CDR_OS.time`           |
| DSS (Disease-specific survival) | `CDR_DSS`           | `CDR_DSS.time`          |
| DFI (Disease-free interval)     | `CDR_DFI`           | `CDR_DFI.time`         |

example usage for survival:

```r
#OS
maftools::mafSurvival(maf = brca, genes = c("TP53"), time = "CDR_OS.time", Status = "CDR_OS")

#PFI
maftools::mafSurvival(maf = brca, genes = c("TP53"), time = "CDR_PFI.time", Status = "CDR_PFI")
```

### FAQ

**Q:How did I compile the data?**

**A:**See [compile_MC3.R](https://github.com/PoisonAlien/TCGAmutations/tree/master/inst/script/compile_MC3.R) for the details.

**Q: Are there any non-TCGA/external cohorts**

**A:**Please open an [issue](https://github.com/PoisonAlien/TCGAmutations/issues) if you have any particular publication in mind that you want me to include in the package.

### References

For maftools

**_Maftools: efficient and comprehensive analysis of somatic variants in cancer. Mayakonda A, Lin DC, et. al. [Genome Research](http://www.genome.org/cgi/doi/10.1101/gr.239244.118)_**


For MC3 cohort

**_Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines. Kyle Ellrott, Matthew H. Bailey, Gordon Saksena, et. al. [Cell Syst](https://doi.org/10.1016/j.cels.2018.03.002)_**

For clinical data resource

**_An Integrated TCGA Pan-Cancer Clinical Data Resource to Drive High-Quality Survival Outcome Analytics.Liu, Jianfang et al. [Cell](https://doi.org/10.1016/j.cell.2018.02.052)_**

