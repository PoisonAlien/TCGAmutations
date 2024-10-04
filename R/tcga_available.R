#' Prints available TCGA datasets
#'
#' @description Prints available TCGA cohorts
#' @examples
#' tcga_available()
#' @export
#' @seealso \code{\link{tcga_load}}
tcga_available = function(){
  cohorts = system.file('extdata', 'cohorts.txt', package = 'TCGAmutations')
  cohorts = data.table::fread(input = cohorts)
  cohorts$Firehose = cohorts$Firehose |> data.table::tstrsplit(split = " ", keep = 1) |> unlist()
  cohorts$CCLE = cohorts$CCLE |> data.table::tstrsplit(split = " ", keep = 1) |> unlist()
  cohorts$n_samples = cohorts[,.(MC3, Firehose, CCLE)] |> apply(1, paste, collapse = "|")
  cohorts$source = "MC3|Firehose|CCLE"
  cohorts[,.(Study_Abbreviation, source, n_samples)]
}
