------------------------------------------------------------------------

## TCGAmutations - An R data package for TCGA somatic mutations

------------------------------------------------------------------------

## Introduction
`TCGAmutations` is an R data package containing somatic mutations from CCLE and TCGA cohorts. This is particularly useful for those working with mutation data from TCGA studies - where most of the time is spent on searching various databases, downloading, compiling and tidying up the data before even the actual analysis is started. This package tries to mitigate the issue by providing pre-compiled, curated somatic mutations from 33 TCGA cohorts and 2427 cell line profiles from CCLE - along with relevant clinical information for all sequenced samples.


### Installation

```r
BiocManager::install("PoisonAlien/TCGAmutations")
```

### Usage

There are only two commands 

   * `tcga_available()` - Lists the available cohorts in the package
   * `tcga_load()` - Takes a cohort name and returns the corresponding MAF object 

There are sources from which MAF files were compiled:

  * [TCGA MC3](https://gdc.cancer.gov/about-data/publications/mc3-2017)
  * [Broad Firehose](http://firebrowse.org/)
  * [CCLE](https://depmap.org/portal/data_page/?tab=currentRelease)

## Cohorts

`tcga_available()` function lists the available cohorts along with the source and sample size.

```r
> tcga_available()
    Study_Abbreviation            source   n_samples
                <char>            <char>      <char>
 1:                ACC MC3|Firehose|CCLE    92|62|NA
 2:               BLCA MC3|Firehose|CCLE  411|395|NA
 3:               BRCA MC3|Firehose|CCLE 1026|978|NA
 4:               CESC MC3|Firehose|CCLE  291|194|NA
 5:               CHOL MC3|Firehose|CCLE    36|35|NA
 6:               COAD MC3|Firehose|CCLE  406|367|NA
 7:               DLBC MC3|Firehose|CCLE    37|48|NA
 8:               ESCA MC3|Firehose|CCLE  185|185|NA
 9:                GBM MC3|Firehose|CCLE  400|283|NA
10:               HNSC MC3|Firehose|CCLE  509|511|NA
11:               KICH MC3|Firehose|CCLE    66|66|NA
12:               KIRC MC3|Firehose|CCLE  370|476|NA
13:               KIRP MC3|Firehose|CCLE  282|282|NA
14:               LAML MC3|Firehose|CCLE  140|193|NA
15:                LGG MC3|Firehose|CCLE  525|516|NA
16:               LIHC MC3|Firehose|CCLE  365|373|NA
17:               LUAD MC3|Firehose|CCLE  517|533|NA
18:               LUSC MC3|Firehose|CCLE  485|178|NA
19:               MESO MC3|Firehose|CCLE    82|NA|NA
20:                 OV MC3|Firehose|CCLE  411|466|NA
21:               PAAD MC3|Firehose|CCLE  178|126|NA
22:               PCPG MC3|Firehose|CCLE  184|179|NA
23:               PRAD MC3|Firehose|CCLE  498|498|NA
24:               READ MC3|Firehose|CCLE  150|122|NA
25:               SARC MC3|Firehose|CCLE  239|247|NA
26:               SKCM MC3|Firehose|CCLE  468|290|NA
27:               STAD MC3|Firehose|CCLE  439|393|NA
28:               TGCT MC3|Firehose|CCLE  134|147|NA
29:               THCA MC3|Firehose|CCLE  500|496|NA
30:               THYM MC3|Firehose|CCLE  123|120|NA
31:               UCEC MC3|Firehose|CCLE  531|248|NA
32:                UCS MC3|Firehose|CCLE    57|57|NA
33:                UVM MC3|Firehose|CCLE    80|80|NA
34:        CCLE_2024Q2 MC3|Firehose|CCLE  NA|NA|2427
    Study_Abbreviation            source   n_samples
```

### TCGA cohorts

#### MC3

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

#### Firehose

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

### CCLE

All the somatic point mutations and indels called in the DepMap cell lines. 

Note that this object contains data from [DepMap 24Q2 Public](https://doi.org/10.25452/figshare.plus.25880521.v1) relase. Data was kindly formatted into MAF file and made available by DepMap project. See below _References_ for proper citation. 


```r
> ccle = tcga_load(study = "CCLE_2024Q2", source = "CCLE")
Loading CCLE_2024Q2. Please cite: https://doi.org/10.25452/figshare.plus.25880521.v1 for reference
> ccle
An object of class  MAF 
Index: <ID>
                        ID summary    Mean Median
                    <char>  <char>   <num>  <num>
 1:             NCBI_Build  GRCh38      NA     NA
 2:                 Center    <NA>      NA     NA
 3:                Samples    2427      NA     NA
 4:                 nGenes   19605      NA     NA
 5:        Frame_Shift_Del   52762  21.740      6
 6:        Frame_Shift_Ins   18349   7.560      2
 7:           In_Frame_Del    6250   2.575      2
 8:           In_Frame_Ins    1973   0.813      0
 9:      Missense_Mutation  776466 319.928    172
10:      Nonsense_Mutation   51593  21.258     10
11:       Nonstop_Mutation    1159   0.478      0
12:            Splice_Site   30655  12.631      7
13: Translation_Start_Site    1921   0.792      0
14:                  total  941128 387.774    202
```

Above MAF includes 1788 unqiue cell lines (from 2427 profiles) spanning 87 primary diseases. See `ccle@clinical.data` to learn more. 

Below are some helpful subset commands:

```r
#Get all AML cell lines
maftools::subsetMaf(maf = ccle, clinQuery = "DepmapModelType == 'AML'")

#Get all cell lines of cervical origin
maftools::subsetMaf(maf = ccle, clinQuery = "OncotreeLineage == 'Cervix'")

#Get HELA
maftools::subsetMaf(maf = ccle, clinQuery = "StrippedCellLineName == 'HELA'")

#Get cell lines with WGS
maftools::subsetMaf(maf = ccle, clinQuery = "Datatype == 'wgs'")
```


### FAQ

**Q:How did I compile the data?**

**A:**See [compile_MC3.R](https://github.com/PoisonAlien/TCGAmutations/tree/master/inst/script/compile_MC3.R) and [compile_CCLE.R](https://github.com/PoisonAlien/TCGAmutations/tree/master/inst/script/compile_CCLE.R) for the details.

**Q: Are there any non-TCGA/external cohorts**

**A:**Please open an [issue](https://github.com/PoisonAlien/TCGAmutations/issues) if you have any particular publication in mind that you want me to include in the package.

### References

For maftools

**_Maftools: efficient and comprehensive analysis of somatic variants in cancer. Mayakonda A, Lin DC, et. al. [Genome Research](http://www.genome.org/cgi/doi/10.1101/gr.239244.118)_**


For MC3 cohort

**_Scalable Open Science Approach for Mutation Calling of Tumor Exomes Using Multiple Genomic Pipelines. Kyle Ellrott, Matthew H. Bailey, Gordon Saksena, et. al. [Cell Syst](https://doi.org/10.1016/j.cels.2018.03.002)_**

For clinical data resource

**_An Integrated TCGA Pan-Cancer Clinical Data Resource to Drive High-Quality Survival Outcome Analytics.Liu, Jianfang et al. [Cell](https://doi.org/10.1016/j.cell.2018.02.052)_**

For CCLE 

Please cite the below figshare for the data:

**_DepMap, Broad (2024). DepMap 24Q2 Public. Figshare+. Dataset. https://doi.org/10.25452/figshare.plus.25880521.v1**_

Please cite the below If you’d like to cite The DepMap project:

**_Tsherniak A, Vazquez F, Montgomery PG, Weir BA, Kryukov G, Cowley GS, Gill S, Harrington WF, Pantel S, Krill-Burger JM, Meyers RM, Ali L, Goodale A, Lee Y, Jiang G, Hsiao J, Gerath WFJ, Howell S, Merkel E, Ghandi M, Garraway LA, Root DE, Golub TR, Boehm JS, Hahn WC. Defining a Cancer Dependency Map. Cell. 2017 Jul 27;170(3):564-576._**

