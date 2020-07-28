------------------------------------------------------------------------

## TCGAmutations - An R data package for TCGA somatic mutations

------------------------------------------------------------------------

### Introduction
`TCGAmutations` is an R data package containing somatic mutations from TCGA cohorts. This is particularly useful for those working with mutation data from TCGA studies - where most of the time is spent on searching various databases, downloading, compiling and tidying up the data before even the actual analysis is started. This package tries to mitigate the issue by providing pre-compiled, curated somatic mutations from 33 TCGA cohorts along with relevant clinical information for all sequenced samples.

### Data sources
There are two sources from which MAF files were compiled:

  * [Broad Firehose](http://firebrowse.org/)
  * [TCGA MC3](https://gdc.cancer.gov/about-data/publications/mc3-2017)

### Installation

```r
BiocManager::install("PoisonAlien/TCGAmutations")
```

### TCGA cohorts

`tcga_available()` function lists the available cohorts along with the source, sample size and DOI for citation.

```r
>TCGAmutations::tcga_available()
    Study_Abbreviation  MC3  Firehose
 1:                ACC   92  62 [dx.doi.org/10.7908/C1610ZNC]
 2:               BLCA  411 395 [dx.doi.org/10.7908/C1MW2GGF]
 3:               BRCA 1020 978 [dx.doi.org/10.7908/C1TB167Z]
 4:               CESC  289 194 [dx.doi.org/10.7908/C1MG7NV6]
 5:               CHOL   36  35 [dx.doi.org/10.7908/C1K936V8]
 6:               COAD  404 367 [dx.doi.org/10.7908/C1DF6QJD]
 7:               DLBC   37  48 [dx.doi.org/10.7908/C1X066DK]
 8:               ESCA  184 185 [dx.doi.org/10.7908/C1BV7FZC]
 9:                GBM  390 283 [dx.doi.org/10.7908/C1XG9QGN]
10:               HNSC  507 511 [dx.doi.org/10.7908/C18C9VM5]
11:               KICH   66  66 [dx.doi.org/10.7908/C1765DQK]
12:               KIRC  369 476 [dx.doi.org/10.7908/C10864RM]
13:               KIRP  281 282 [dx.doi.org/10.7908/C19C6WTF]
14:               LAML  140 193 [dx.doi.org/10.7908/C1D21X2X]
15:                LGG  511 516 [dx.doi.org/10.7908/C1MC8ZDF]
16:               LIHC  363 373 [dx.doi.org/10.7908/C128070B]
17:               LUAD  515 533 [dx.doi.org/10.7908/C17P8XT3]
18:               LUSC  485 178 [dx.doi.org/10.7908/C1X34WXV]
19:               MESO   82                              <NA>
20:                 OV  411 466 [dx.doi.org/10.7908/C1736QC5]
21:               PAAD  177 126 [dx.doi.org/10.7908/C1513XNS]
22:               PCPG  179 179 [dx.doi.org/10.7908/C13T9GN0]
23:               PRAD  497 498 [dx.doi.org/10.7908/C1Z037MV]
24:               READ  149 122 [dx.doi.org/10.7908/C1S46RDB]
25:               SARC  236 247 [dx.doi.org/10.7908/C137785M]
26:               SKCM  466 290 [dx.doi.org/10.7908/C1J67GCG]
27:               STAD  439 393 [dx.doi.org/10.7908/C1C828SM]
28:               TGCT  129 147 [dx.doi.org/10.7908/C1S1820D]
29:               THCA  492 496 [dx.doi.org/10.7908/C16W99KN]
30:               THYM  123 120 [dx.doi.org/10.7908/C15T3JZ6]
31:               UCEC  530 248 [dx.doi.org/10.7908/C1C828T2]
32:                UCS   57  57 [dx.doi.org/10.7908/C1PC31W8]
33:                UVM   80  80 [dx.doi.org/10.7908/C1S1821V]
34:            Unknown   77                              <NA>
    Study_Abbreviation  MC3                          Firehose
```

### Usage

There are only two commands 

   * `tcga_available()` - Lists the avaibale cohorts in the package
   * `tcga_load()` - Takes a cohort name and returns the corresponding MAF object 

Example: Loading TCGA `LUAD` cohort. Note that by default MAF from MC3 study is returned

```r
> TCGAmutations::tcga_load(study = "LUAD")
Loading LUAD. Please cite: https://doi.org/10.1016/j.cels.2018.03.002 for reference
An object of class  MAF 
                        ID summary    Mean Median
 1:             NCBI_Build      NA      NA     NA
 2:                 Center      NA      NA     NA
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

Change `source` argument to Firehose for MAF files from Broad Firehose
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


## Non-TCGA/external cohorts

I am also compiling non-TCGA MAF files from pulished studies. Please open an [issue](https://github.com/PoisonAlien/TCGAmutations/issues) if you have any particular publication in mind that you want me to include in the package.

## References

Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines
Kyle Ellrott, Matthew H. Bailey, Gordon Saksena, et. al. Cell Syst. 2018 Mar 28; 6(3): 271–281.e7. https://doi.org/10.1016/j.cels.2018.03.002
  
