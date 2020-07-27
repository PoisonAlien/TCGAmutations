#' Loads a TCGA cohort
#'
#' @description Loads a user mentioned TCGA cohort into global enviornment
#' @param study Study names to load. Use  \code{\link{tcga_available}} to see available options.
#' @param source Can be \code{MC3} or \code{Firehose}. Default \code{MC3}
#' It will be usefull if you want to operate multiple \code{MAF}s.
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

  source = match.arg(arg = source, choices = c("MC3", "Firehose"))

  study = toupper(x = study)
  cohorts = system.file('extdata', 'cohorts.txt', package = 'TCGAmutations')
  cohorts = data.table::fread(file = cohorts)
  cohorts = cohorts[cohorts$Study_Abbreviation %in% study]

  if(nrow(cohorts) == 0){
    stop("Could not find requested datasets!\nUse tcga_available() for available cohorts.")
  }

  if(source == "MC3"){
    study.dat = system.file('extdata/MC3/', paste0(cohorts$Study_Abbreviation, ".RDs"), package = 'TCGAmutations')
    doi = rep("https://doi.org/10.1016/j.cels.2018.03.002", nrow(cohorts))
  }else{
    study.dat = system.file('extdata/Firehose/', paste0(cohorts$Study_Abbreviation, ".RDs"), package = 'TCGAmutations')
    doi = cohorts$Firehose
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
