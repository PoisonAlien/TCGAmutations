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
  cohorts
}
