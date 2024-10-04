#' Loads a TCGA cohort
#'
#' @description Loads a user mentioned TCGA cohort into global enviornment
#' @param study Study names to load. Use  \code{\link{tcga_available}} to see available options.
#' @param source Can be \code{MC3} or \code{Firehose}. Default \code{MC3}
#' It will be useful if you want to operate multiple \code{MAF}s.
#' @import maftools data.table
#' @examples
#' tcga_load(study = "LAML") #Loads TCGA LAML cohort
#' @export
#' @seealso \code{\link{tcga_available}}
#'
tcga_load = function(study = NULL, source = "MC3"){
  
  
  if(is.null(study)){
    stop("Please provide a study name. Use tcga_available() for available cohorts.")
  }
  
  source = match.arg(arg = source, choices = c("MC3", "Firehose", "CCLE"))
  
  study = toupper(x = study)
  cohorts = system.file('extdata', 'cohorts.txt', package = 'TCGAmutations')
  cohorts = data.table::fread(file = cohorts)
  cohorts_like = cohorts[Study_Abbreviation %like% study]
  cohorts = cohorts[Study_Abbreviation %in% study]
  
  if(nrow(cohorts) == 0){
    if(nrow(cohorts_like) > 0){
        stop("Could not find the requested datasets!\n Did you mean: ", paste(cohorts_like$Study_Abbreviation, collapse = ", "), "\nUse tcga_available() for available cohorts.")
      }else{
        stop("Could not find the requested datasets!\nUse tcga_available() for available cohorts.")    
      }
    
  }
  
  if(source == "MC3"){
    study.dat = system.file('extdata/MC3/', paste0(cohorts$Study_Abbreviation, ".RDs"), package = 'TCGAmutations')
    study.dat = setdiff(study.dat, "")
    if(length(study.dat) == 0){
      stop("Could not find the requested cohorts in ", source)
    }
    doi = rep("https://doi.org/10.1016/j.cels.2018.03.002", nrow(cohorts))
  }else if(source == "Firehose"){
    warning("Use Firehose data at your own risk. MAF and clinical data has not been updated in a long time. It is strongly suggested to use the default `MC3` cohort")
    study.dat = system.file('extdata/Firehose/', paste0(cohorts$Study_Abbreviation, ".RDs"), package = 'TCGAmutations')
    study.dat = setdiff(study.dat, "")
    if(length(study.dat) == 0){
      stop("Could not find the requested cohorts in ", source)
    }
    doi = cohorts$Firehose
    doi = unlist(data.table::tstrsplit(x = doi, spli = "\\[", keep = 2))
    doi = gsub(pattern = "\\]$", replacement = "", x = doi)
  }else{
    study.dat = system.file('extdata/CCLE/', paste0(cohorts$Study_Abbreviation, ".RDs"), package = 'TCGAmutations')
    study.dat = setdiff(study.dat, "")
    if(length(study.dat) == 0){
      stop("Could not find the requested cohorts in ", source)
    }
    doi = cohorts$CCLE
    doi = unlist(data.table::tstrsplit(x = doi, spli = "\\[", keep = 2))
    doi = gsub(pattern = "\\]$", replacement = "", x = doi)
  }
  
  if (length(study.dat) > 1) {
    mafs = lapply(seq_along(study.dat), function(i){
      message("Loading ", cohorts$Study_Abbreviation[i], ". Please cite: ", doi[i], " for reference")
      readRDS(file = study.dat[i])
    })
    names(mafs) = cohorts$Study_Abbreviation
  }else{
    message("Loading ", cohorts$Study_Abbreviation, ". Please cite: ", doi, " for reference")
    mafs = readRDS(file = study.dat)
  }
  
  mafs
}
