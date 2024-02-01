#' Access to Canadian wage data in Canada open data through the CKAN API
#' 
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
