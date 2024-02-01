library(httr2)

req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
result <- req %>% 
  req_headers(Authorization = "d5bd1125-a95f-4ad0-9c2e-7a7735113c73") %>% 
  req_body_json(list(
    sql = "SELECT * FROM \"ff45366b-1c17-4862-8325-f6e7797c7c56\" Where \"Low_Wage_Salaire_Minium\" is not null ")) %>% 
req_perform %>% 
  resp_body_json
result$result$records
record2023 = as.data.frame(do.call(rbind, result$result$records))


req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
result <- req %>% 
  req_headers(Authorization = "d5bd1125-a95f-4ad0-9c2e-7a7735113c73") %>% 
  req_body_json(list(
    sql = "SELECT * FROM \"8d49f430-6dfd-4122-a18d-b0868381f0e6\"Where \"Low_Wage_Salaire_Minium\" is not null")) %>% 
  req_perform %>% 
  resp_body_json
result$result$records
records2022 = as.data.frame(do.call(rbind, result$result$records))


req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
result <- req %>% 
  req_headers(Authorization = "d5bd1125-a95f-4ad0-9c2e-7a7735113c73") %>% 
  req_body_json(list(
    sql = "SELECT * FROM  \"74a2d523-9760-415e-b722-8a237ab649db\" Where \"Low_Wage_Salaire_Minium\" is not null")) %>% 
  req_perform %>% 
  resp_body_json
result$result$records
records2021 = as.data.frame(do.call(rbind, result$result$records))

req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
result <- req %>% 
  req_headers(Authorization = "d5bd1125-a95f-4ad0-9c2e-7a7735113c73") %>% 
  req_body_json(list(
    sql = "SELECT * FROM  \"c2db20d5-92bc-40d2-aa9f-6c868badc0b9\" Where \"Low_Wage_Salaire_Minium\" is not null")) %>% 
  req_perform %>% 
  resp_body_json
result$result$records
records2020 = as.data.frame(do.call(rbind, result$result$records))

req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
result <- req %>% 
  req_headers(Authorization = "d5bd1125-a95f-4ad0-9c2e-7a7735113c73") %>% 
  req_body_json(list(
    sql = "SELECT * FROM  \"3abae67c-78a7-4e06-b2b2-fe9870100381\"  Where \"Low_Wage_Salaire_Minium\" is not null")) %>% 
  req_perform %>% 
  resp_body_json
result$result$records
records2019 = as.data.frame(do.call(rbind, result$result[["records"]]),)

preparing<-function(data){
  names(data)<-tolower(names(data))
  data<-data %>% 
    as_tibble() %>% 
    unnest(everything()) %>% 
    select(contains("noc_title"),prov,contains("wage_salaire"),reference_period) %>% 
    mutate_at(vars(contains("wage")),as.numeric)
  data
}

r2023=preparing(record2023)
r2022=preparing(records2022)
r2021=preparing(records2021)
r2020=preparing(records2020)
r2019=preparing(records2019)
