#' Loads a TCGA cohort
#'
#' @description Loads a user mentioned TCGA cohort into global enviornment
#' @param study a study name to load. Use  \code{\link{tcga_available}} to see available options.
#' @import maftools
#' @examples
#' tcga_load(study = "LAML") #Loads TCGA LAML cohort
#' @export
#' @seealso \code{\link{tcga_available}}
#'
tcga_load = function(study = NULL){

  if(is.null(study)){
    stop("Please provide a study name. Use tcga_available() to see available cohorts.")
  }

  study = toupper(x = study)

  study.dat = system.file('extdata', paste0(study, ".RData"), package = 'TCGAmutations')

  if(study.dat == ""){
    stop(study, " not available. Use tcga_available() to see available cohorts.")
  } else{
    load(file = study.dat, verbose = TRUE, envir = .GlobalEnv)
    message(paste0("Successfully loaded TCGA ", study, "!"))
    message(paste0("See MAF object tcga_", tolower(study)))
  }
}
