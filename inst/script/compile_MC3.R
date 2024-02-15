#Compile MC3 MAFs and relevant clinical data

#Download MAF
options(timeout = max(300, getOption("timeout")))
download.file(url = "https://api.gdc.cancer.gov/data/1c8cfe5f-e52d-41ba-94da-f15ea1337efc", destfile = "MC3.maf.gz")
download.file(url = "https://api.gdc.cancer.gov/data/1b5f413e-a8d1-4d10-92eb-7c4ae739ed81", destfile = "TCGA-CDR-SupplementalTableS1.xlsx")
download.file(url = "https://api.gdc.cancer.gov/data/0fc78496-818b-4896-bd83-52db1f533c5c", destfile = "clinical_PANCAN_patient_with_followup.tsv")

##Read in CDR (clinical data resource) file
tcga_cdr = readxl::read_xlsx(path = "TCGA-CDR-SupplementalTableS1.xlsx", sheet = 1)
data.table::setDT(x = tcga_cdr)
tcga_cdr = tcga_cdr[,2:ncol(tcga_cdr)] #No need of first column (index)
colnames(tcga_cdr)[3:ncol(tcga_cdr)] = paste0("CDR_", colnames(tcga_cdr)[3:ncol(tcga_cdr)]) #Add CDR_ prefix to column names to distinguish it from followup data

##MAF file
m = data.table::fread(input = "MC3.maf.gz")

#NOTE: Keep an eye on the FILTER column.
#Most duplicated variants are coming from tumors barcodes which have been compared to multiple control samples (as evident by Matched_Norm_Sample_Barcode).
# e.g: 12:5604050:TCGA-ZU-A8S4-01A-11D-A417-09:G:T has two normals  TCGA-ZU-A8S4-10A-01D-A41A-09 and TCGA-ZU-A8S4-11A-11D-A417-09
#There are no duplicated variants within PASS filtered variants which is good
#There are no PASS variants in LAML (weird!)
# There are 488 barcodes with more than one controls
multi_control_tsbs = m[,.N,.(Tumor_Sample_Barcode, Matched_Norm_Sample_Barcode)][,.N,Tumor_Sample_Barcode][N > 1, Tumor_Sample_Barcode]
length(multi_control_tsbs)

#Use the barcodes with the control in which the most variants identified (order by variants and remove the duplicated, N = 488)
#multi_control_tsbs = m[,.N,.(Tumor_Sample_Barcode, Matched_Norm_Sample_Barcode)][Tumor_Sample_Barcode %in% multi_control_tsbs][order(Tumor_Sample_Barcode, -N)]
#multi_control_tsbs = multi_control_tsbs[!duplicated(Tumor_Sample_Barcode)]
#m_multi_control_tsbs = m[Tumor_Sample_Barcode %in% multi_control_tsbs$Tumor_Sample_Barcode][Matched_Norm_Sample_Barcode %in% multi_control_tsbs$Matched_Norm_Sample_Barcode]

#barcodes with single barcodes (N = 9805)
#m_single_control_tsbs = m[!Tumor_Sample_Barcode %in% multi_control_tsbs$Tumor_Sample_Barcode]

#Merge
#m = data.table::rbindlist(l = list(m_single_control_tsbs, m_multi_control_tsbs), use.names = TRUE, fill = TRUE)

#Keep only minimal required columns to make the object size small
m = m[,.(Hugo_Symbol, Chromosome, Start_Position, End_Position, Variant_Classification, Variant_Type, Reference_Allele, Tumor_Seq_Allele2,
         Tumor_Sample_Barcode, Matched_Norm_Sample_Barcode, HGVSc, HGVSp_Short, Transcript_ID, Exon_Number,  t_ref_count, t_alt_count, n_ref_count, n_alt_count, IMPACT, ExAC_AF, IMPACT, FILTER)]


###TSB is in TCGA-02-0003-01A-01D-1490-08 format. Use first 12 chars which correspond to unique barcode per patient
m[,Tumor_Sample_Barcode_min := substr(Tumor_Sample_Barcode, 1, 12)]
m_tsbs = m[,.N,Tumor_Sample_Barcode] #How many barcodes: 10295
colnames(m_tsbs)[2] = "n_vars_all"
m_tsbs[,Tumor_Sample_Barcode_min := substr(Tumor_Sample_Barcode, 1, 12)]
m_tsbs[,.N,Tumor_Sample_Barcode_min][order(-N)] #How many unique barcodes: 10224 i.e, 71 barcodes have more than one tumor (maybe primary. metastatic or relapsed)

##Pancan followup
pancan_followup = data.table::fread(input = "clinical_PANCAN_patient_with_followup.tsv")

##No. of unique patients in CDR file (11,160)
tcga_cdr[,.N,bcr_patient_barcode] |> nrow()

##No. of unique patients in followup file (10,956)
pancan_followup[,.N,bcr_patient_barcode] |> nrow()

##Common PIDs across both (10,951)
intersect(tcga_cdr[,.N,bcr_patient_barcode][,bcr_patient_barcode], pancan_followup[,.N,bcr_patient_barcode][,bcr_patient_barcode]) |> length()

##Exists in pancan_followup but missing from CDR (5 PIDs)
pancan_unique_barcodes = setdiff(y = tcga_cdr[,.N,bcr_patient_barcode][,bcr_patient_barcode], x = pancan_followup[,.N,bcr_patient_barcode][,bcr_patient_barcode])
length(pancan_unique_barcodes)

##Exists in CDR but missing from pancan_followup (209 PIDs)
cdr_unique_barcodes = setdiff(x = tcga_cdr[,.N,bcr_patient_barcode][,bcr_patient_barcode], y = pancan_followup[,.N,bcr_patient_barcode][,bcr_patient_barcode])
length(cdr_unique_barcodes)

##What are these 209 samples? (these are 200 from AML and 9 from CHOL)
tcga_cdr[bcr_patient_barcode %in% cdr_unique_barcodes][,.N,type]

##How many barcodes in MAF hare missing from CDR (77)
maf_unique_barcodes = setdiff(m_tsbs[,Tumor_Sample_Barcode_min], tcga_cdr[,bcr_patient_barcode])
length(maf_unique_barcodes)

##Merge CDR and TSB list from MAF
maf_cdr = merge(m_tsbs, tcga_cdr, by.x = "Tumor_Sample_Barcode_min", by.y = "bcr_patient_barcode", all.x = TRUE)
##Merge with followup data
maf_cdr = merge(maf_cdr, pancan_followup, by.x = "Tumor_Sample_Barcode_min", by.y = "bcr_patient_barcode", all.x = TRUE)
dim(maf_cdr)


cdr_split = split(maf_cdr, maf_cdr$type)

length(cdr_split) #33 cohorts
names(cdr_split)

temp = lapply(seq_along(cdr_split), function(idx){
  cohort = names(cdr_split)[idx]
  print(cohort)
  maf_anno = cdr_split[[idx]]
  cohort_m = m[Tumor_Sample_Barcode %in% maf_anno$Tumor_Sample_Barcode] |> maftools::read.maf(clinicalData = maf_anno, removeDuplicatedVariants = TRUE)
  temp_sum = cohort_m@summary[, summary]
  temp_sum[1:2] = c("GRCh37", paste0("MC3_", cohort))
  cohort_m@summary$summary = temp_sum
  saveRDS(object = cohort_m, file = paste0("inst/extdata/MC3/", cohort, ".RDs"))
})


#Update cohort sizes
cohorts = data.table::fread(input = "inst/extdata/cohorts.txt")
samp_sizes = lapply(cdr_split, nrow) |> unlist() |> data.frame() |> data.table::data.table(keep.rownames = TRUE)
colnames(samp_sizes) = c("Study_Abbreviation", "MC3_v2")
cohorts = merge(cohorts, samp_sizes, by = 'Study_Abbreviation')
cohorts$MC3 = cohorts$MC3_v2
cohorts$MC3_v2 = NULL
data.table::fwrite(x = cohorts, file = "inst/extdata/cohorts.txt", sep = "\t")

#Remove downloaded files
unlink(x = "clinical_PANCAN_patient_with_followup.tsv")
unlink(x = "TCGA-CDR-SupplementalTableS1.xlsx")
unlink(x = "MC3.maf.gz")

#TCGA CDR (clinical data resource) file contains the curated outcome data
#* A curated resource of the clinical annotations for TCGA data and provides recommendations for use of clinical endpoints
# *It is strongly recommended that this file be used for clinical elements and survival outcome data first; more details please see the TCGA-CDR paper(link is external).

#clinical_PANCAN_patient_with_followup.tsv contains over 700 columns of clinical information. However, some columns in CDR and this file are common

# CDR.xlsxl    ->    clinical_PANCAN_patient_with_followup.tsv
#----------------------------------------------------------------
# OS:vital_status
# last_contact_days_to:days_to_last_followup
# death_days_to:days_to_death
# age_at_initial_pathologic_diagnosis:age_at_initial_pathologic_diagnosis
