## CHANGES IN VERSION 0.3.0 

- `tcga_load()` returns the MAF object instead of loading into environment
- For TCGA MC3 cohort - TCGA barcodes are retained as is (i.e, full names and not just first 12 chars) with corresponding `sample type` annotations in clinical data. Issue [#8](https://github.com/PoisonAlien/TCGAmutations/issues/8)
