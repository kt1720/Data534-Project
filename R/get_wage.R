#' Access to Canadian wage data in Canada open data through the CKAN API
#' 
library(tidyverse)
library(httr2)

get_wage <- function(dataset, api_key=Sys.getenv("CKAN_API_KEY")){
  if(!valid_api_key(api_key)){
    stop(paste("No API key set yet. To set your API key, try running the command Sys.setenv(CKAN_API_KEY = ***). Replace *** with your API key, from your user account on the CKAN site."))
  }
  req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
  result <- req %>%
    req_headers(Authorization = api_key) %>%
    req_body_json(list(
      resource_id = id[1], #'ff45366b-1c17-4862-8325-f6e7797c7c56',
      limit = 45000, 
      filters = list(ER_Name = list("Newfoundland and Labrador", "New Brunswick", "Quebec", "Ontario", 
                                    "Manitoba", "Alberta", "British Columbia", "Yukon Territory", "Northwest Territories",
                                    "Nunavut", "Prince Edward Island", "Saskatchewan", "Nova Scotia")))
    ) %>%
    req_perform() %>%
    resp_body_json()