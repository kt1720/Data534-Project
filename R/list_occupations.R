#' List Occupations Matching a Keyword in a Dataset
#' 
#' This function takes a wage dataset and a keyword as input and returns a list of unique occupations that match the provided keyword. 
#' The comparison is case-insensitive.
#'
#' @param dataset A tibble or data frame containing the wage dataset.
#' @param str A character string representing the keyword to match against occupations.
#'
#' @return A character vector containing unique occupations that match the provided keyword. If no matches are found, a message is returned indicating so.
#'
#' @export
#'
#' @examples
#' # List occupations containing the keyword "engineer"
#' \dontrun{
#' engineer_occupations <- list_occupations(dataset = your_dataset, str = "engineer")
#'
#' # List occupations containing the keyword "data"
#' data_occupations <- list_occupations(dataset = your_dataset, str = "data")
#'
#' # Handle no matches
#' no_matches <- list_occupations(dataset = your_dataset, str = "nonexistent")
#' # This will return a message indicating that there are no matching occupations.
#' }

list_occupations <- function(dataset, str){
  occupations <- grep(str, unique(dataset$occupation), ignore.case = T, value = T)
  if(length(occupations) == 0){
    return("There is no occupation that matches the input provided.")
  }
  return(occupations)
}