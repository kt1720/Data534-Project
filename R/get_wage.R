#' Access to Canadian wage data in Canada open data through the CKAN API
#' 
#' This function retrieves wage data from the Canada open data CKAN API. An API key is required for access, and users can provide a single year or a vector of years to retrieve data for multiple years. The function internally calls \code{get_wage_single_year} to fetch data for individual years.
#'
#' @param dataset A character string or vector of character strings representing the dataset identifier(s) for wage data.
#' @param api_key An API key for the CKAN API. Defaults to the value stored in the \code{CKAN_API_KEY} environment variable.
#'
#' @return A tibble containing the wage data for the specified year(s).
#'
#' @source Wages data is reproduced and distributed on
#' the Canada open data site and published by Employment and Social Development Canada
#' (Wages 2012; 2013; 2016; 2019; 2020; 2021; 2022; 2023).
#' 
#' @export
#'
#' @examples
#' # Retrieve wage data for a single year
#' \dontrun{
#' single_year_data <- get_wage(dataset = "2023", api_key = "your_api_key")
#'
#' # Retrieve wage data for multiple years
#' multiple_years_data <- get_wage(dataset = c("2020", "2021", "2022"), api_key = "your_api_key")
#'
#' # Use the default API key from the environment variable
#' default_key_data <- get_wage(dataset = "2023")
#'
#' # Handle API key error
#' invalid_key_data <- get_wage(dataset = "2023", api_key = "invalid_key")
#' # This will stop with an error message about the invalid API key.
#' }

library(tidyverse)
library(httr2)

get_wage <- function(dataset, api_key=Sys.getenv("CKAN_API_KEY")){
  if(!valid_api_key(api_key)){
    stop(paste("No API key set yet. To set your API key, try running the command Sys.setenv(CKAN_API_KEY = ***). Replace *** with your API key, from your user account on the CKAN site."))
  }
  if (is.vector(dataset)) {
    results <- lapply(dataset, function(year) {
      get_wage_single_year(year, api_key)
    })
    result <- do.call(rbind, results)
  } else {
    result <- get_wage_single_year(dataset, api_key)
  }
  return(result)
}
