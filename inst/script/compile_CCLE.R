#Compile CCLE MAF and relevant clinical data

# NOTE: Below data is 2024Q2 release (DepMap Public 24Q2)

model = data.table::fread(input = "https://depmap.org/portal/data_page/?tab=allData&releasename=DepMap%20Public%2024Q2&filename=Model.csv")
op = data.table::fread(input = "https://depmap.org/portal/data_page/?tab=allData&releasename=DepMap%20Public%2024Q2&filename=OmicsProfiles.csv")
maf = data.table::fread(input = "https://depmap.org/portal/data_page/?tab=allData&releasename=DepMap%20Public%2024Q2&filename=OmicsSomaticMutationsMAFProfile.maf")

#OmicsSomaticMutationsMAFProfile.maf MAF file with samples denoted by ProfileID

#OmicsProfiles.csv has ProfileID -> ModelID mappings
#Model.csv has ModelID -> cell line annotations

#Merge OmicsProfiles.csv and Model.csv to asseble complete annotations

model = merge(model, op, by = "ModelID")
tsb_idx = which(colnames(model) == "ProfileID")
colnames(model)[tsb_idx] = "Tumor_Sample_Barcode"

#A single ModelID representing an unique cell line can map to two distinct ProfileIDs in MAF. This is due to the same cell line being profiled by multiple sequencing assays.
#E.g: Below cell line MJ has two entries in MAF becuase of WGS and WES
# model[ModelID %in% "ACH-000077"][,.(ModelID, ProfileID, CellLineName, Datatype)]
# ModelID ProfileID CellLineName Datatype
# 1: ACH-000077 PR-0H05VY           MJ      wgs
# 2: ACH-000077 PR-30iCKx           MJ      wes

m = maftools::read.maf(maf = "~/Downloads/OmicsSomaticMutationsMAFProfile.maf", clinicalData = model, removeDuplicatedVariants = FALSE)

saveRDS(object = m, file = "inst/extdata/MC3/2024Q2.RDs")

#Update cohort list
cohorts = data.table::fread(input = "inst/extdata/cohorts.txt")
details = data.table::data.table(Study_Abbreviation = "CCLE_2024Q2", Study_Name = "CCLE", CCLE = "2427 [https://doi.org/10.25452/figshare.plus.25880521.v1]")
cohorts = data.table::rbindlist(l = list(cohorts, details), use.names = TRUE, fill = TRUE)
data.table::fwrite(cohorts, file = "inst/extdata/cohorts.txt", sep = "\t")