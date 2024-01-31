#' Access to Canadian wage data in Canada open data through the CKAN API
#' 
library(tidyverse)
library(httr2)

get_wage <- function(dataset, api_key=Sys.getenv("CKAN_API_KEY")){
  
}