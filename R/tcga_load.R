#' Loads a TCGA cohort
#'
#' @description Loads a user mentioned TCGA cohort into global enviornment
#' @param study Study names to load. Use  \code{\link{tcga_available}} to see available options.
#' @param source Can be \code{MC3} or \code{Firehose}. Default \code{MC3}
#' @param reassign If `TRUE`, return a \code{MAF} object instread of loading data into global environment.
#' It will be usefull if you want to operate multiple \code{MAF}s.
#' @import maftools
#' @examples
#' tcga_load(study = "LAML") #Loads TCGA LAML cohort
#' @export
#' @seealso \code{\link{tcga_available}}
#'
tcga_load = function(study = NULL, source = "MC3", reassign = TRUE){

  if(is.null(study)){
    stop("Please provide a study name. Use tcga_available() to see available cohorts.")
  }

  study = toupper(x = study)
  if (length(study) > 1) {
    return(invisible(setNames(lapply(study, tcga_load, reassign = reassign), study)))
  }

  if(source == "MC3"){
    study.dat = system.file('extdata/MC3/', paste0(study, ".RData"), package = 'TCGAmutations')
    doi = "https://doi.org/10.1016/j.cels.2018.03.002"
  }else if(source == "Firehose"){
    study.dat = system.file('extdata/Firehose/', paste0(study, ".RData"), package = 'TCGAmutations')
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
    if (isFALSE(reassign)) {
      load(file = study.dat, verbose = TRUE, envir = .GlobalEnv)
      message(paste0("Successfully loaded TCGA ", study, "!"))
    } else {
      load(file = study.dat, verbose = FALSE, envir = environment())
    }
    #message(paste0("See MAF object tcga_", tolower(study)))
    message(paste0("Please cite ", doi , " for MAF source."))
  }

  maf <- ls(pattern = "tcga")
  if (length(maf) == 0) {
    return(invisible(NULL))
  } else {
    return(get(maf))
  }
}
