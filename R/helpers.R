valid_api_key <- function(api_key){
  !is.null(api_key) && is.character(api_key) && length(api_key) == 36
}

translate_dataset <- function(dataset){
  dataset <- as.character(dataset)
  transaltions <- c("2012" = "5fd8d9f2-008f-41a6-a200-1a0253a4d9b5",
                    "2013" = "c4bcd5c4-9b04-4bb8-8067-f5484a69e592",
                    "2014" = "ff3ea4e1-896f-4fa2-8754-c8a9f83c89b0",
                    "2015" = "7215dbfa-8e5c-417c-8c95-0a916eaedcc1",
                    "2016" = "2a1fe964-7d3f-4337-a454-ef346db5609a",
                    "2019" = "3abae67c-78a7-4e06-b2b2-fe9870100381",
                    "2020" = "c2db20d5-92bc-40d2-aa9f-6c868badc0b9",
                    "2021" = "74a2d523-9760-415e-b722-8a237ab649db",
                    "2022" = "8d49f430-6dfd-4122-a18d-b0868381f0e6",
                    "2023" = "ff45366b-1c17-4862-8325-f6e7797c7c56")
  if(dataset %in% names(translations)) dataset = as.character(translations[dataset])
  return(dataset)
}

get_wage_single_year <- function(year, api_key){
  dataset <- translate_dataset(year)
  req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
  result <- req %>%
    req_headers(Authorization = api_key) %>%
    req_body_json(list(
      resource_id = dataset,
      limit = 45000, 
      filters = list(ER_Name = list("Newfoundland and Labrador", "New Brunswick", "Quebec", "Ontario", 
                                    "Manitoba", "Alberta", "British Columbia", "Yukon Territory", "Northwest Territories",
                                    "Nunavut", "Prince Edward Island", "Saskatchewan", "Nova Scotia")))
    ) %>%
    req_perform() %>%
    resp_body_json()
  
  return(result)
}