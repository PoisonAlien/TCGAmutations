#' Loads a TCGA cohort
#'
#' @description Loads a user mentioned TCGA cohort into global enviornment
#' @param study a study name to load. Use  \code{\link{tcga_available}} to see available options.
#' @param source Can be \code{MC3} or \code{Firehose}. Default \code{MC3}
#' @import maftools
#' @examples
#' tcga_load(study = "LAML") #Loads TCGA LAML cohort
#' @export
#' @seealso \code{\link{tcga_available}}
#'
tcga_load = function(study = NULL, source = "MC3"){

  if(is.null(study)){
    stop("Please provide a study name. Use tcga_available() to see available cohorts.")
  }

  study = toupper(x = study)

  if(source == "MC3"){
    study.dat = system.file('extdata/MC3/', paste0(study, ".RDs"), package = 'TCGAmutations')
    doi = "https://doi.org/10.1016/j.cels.2018.03.002"
  }else if(source == "Firehose"){
    study.dat = system.file('extdata/Firehose/', paste0(study, ".RDs"), package = 'TCGAmutations')
    if(study.dat != ""){
      cohorts = system.file('extdata', 'cohorts.txt', package = 'TCGAmutations')
      cohorts = data.table::fread(input = cohorts, data.table = FALSE)
      doi = cohorts[cohorts$Study_Abbreviation %in% study, "Firehose"]
      doi = unlist(data.table::tstrsplit(x = doi, spli = "\\[", keep = 2))
      doi = gsub(pattern = "\\]$", replacement = "",
                 x = doi)
    }
  }else{
    stop("source can only be MC3 or Firehose")
  }


  if(study.dat == ""){
    stop(study, " not available. Use tcga_available() to see available cohorts.")
  } else{
    message(paste0("Successfully loaded TCGA ", study, "!"))
    #message(paste0("See MAF object tcga_", tolower(study)))
    message(paste0("Please cite ", doi , " for MAF source."))
    return(readRDS(file = study.dat))
  }
}
