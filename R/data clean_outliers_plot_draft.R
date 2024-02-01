library(httr2)
library(tidyr)
library(dplyr)
library(broom)
library(outliers)
library(ggplot2)
library(roxygen2)
req <- request("https://open.canada.ca/data/en/api/action/datastore_search_sql")
result <- req %>%
  req_headers(Authorization = "d5bd1125-a95f-4ad0-9c2e-7a7735113c73") %>%
  req_body_json(list(
    sql = "SELECT * FROM \"ff45366b-1c17-4862-8325-f6e7797c7c56\" Where \"Low_Wage_Salaire_Minium\" is not null ")) %>%
req_perform %>%
  resp_body_json
result$result$records
records2023 = as.data.frame(do.call(rbind, result$result$records))

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
######dataframes `records_year` request complete
records_list <- list(records2019, records2020, records2021, records2022, records2023)
get_column_names_table <- function(records_list){
max_length <- 0
for(i in seq_along(records_list)){
  max_length <- max(max_length, length(records_list[[i]]))
}
column_names_table <- data.frame()
column_names_list <- list()
for(i in seq_along(records_list)){
  c <- c(colnames(records_list[[i]]), rep(NA, max_length-length(records_list[[i]])))
  column_names_list[[i]]<- c
}
column_names_table<- as.data.frame(column_names_list, col.names = c('2019', '2020', '2021', '2022', '2023'))
return(column_names_table)
}
column_names_table <- get_column_names_table(records_list)
column_names_table


# data preparing for each of the data frames from `records2019` to `records 2022`
preparing <- function(data) {
  # make all column names to lower cases
  names(data) <- tolower(names(data))
  # data wrangling
  data <-
    data |>
    as_tibble() |>
    unnest(everything()) |>
    #contains("average_wage_salaire_moyen"), only 2022 and 2023 have such columns
    select("low_wage_salaire_minium", "high_wage_salaire_maximal", "prov", contains("er_name"), "data_source_e", "er_code_code_re", "median_wage_salaire_median", "annual_wage_flag_salaire_annuel", "reference_period", "_id", contains("noc_title")& !contains('fra')) |>
    mutate(across(contains("wage"), as.numeric))

  return(data)
}
r2023=preparing(records2023)
r2022=preparing(records2022)
r2021=preparing(records2021)
r2020=preparing(records2020)
r2019=preparing(records2019)

r_list <- list(r2019, r2020, r2021, r2022, r2023)
column_names_table <- get_column_names_table(r_list)
colnames(r2019) <- colnames(r2022) <- colnames(r2021) <- colnames(r2020) <- colnames(r2023)
#####column names identical now

#####combine dataframes horizontally
r<-rbind(r2023,r2022,r2021,r2020,r2019)

# use separate_rows of 'tidyr' library to split the reference_period
r$reference_period <- gsub("(\\d+)-(\\d+)-(\\d+)", "\\1-\\3", r$reference_period)
df_split <- separate_rows(r, reference_period, sep = "-")
# for the reference period is not necessarily the start of the year, I will not use the code below
#df_split$reference_period <- as.Date(paste0(df_split$reference_period, "-01-01"))
#df_split$reference_period <- as.Date(df_split$reference_period)



# for annual_wage_flag_salaire_annuel==0, calculate yearly wages by multiply by 2080
get_df_annual_wage <- function(df_split){
  df <- df_split%>%
  rowwise()%>%
  mutate(across(contains('wage_salaire'), ~ifelse(annual_wage_flag_salaire_annuel==0, .*2080, .)))%>%
  select(-annual_wage_flag_salaire_annuel)%>%
  arrange(reference_period)
return(df)
}
df <- get_df_annual_wage(df_split)

##### explorotary data analysis
#check missing values
any(is.na(df))
colSums(is.na(df))
df <- na.omit(df)
colnames(df)[colnames(df)=='_id'] <- 'id'
colnames(df)
#check er_name and er_code period
unique(df$er_name)#87
unique(df$er_code_code_re)#86
# reason: two economic regions called Northeast, one in ON, one in BC, thus groupby(prov, er_code) necessary
unique(df[df$er_name=='Northeast', 'prov'])

length(unique(df$id))# 28109
unique(df$reference_period)#2016-2022
unique(df$noc_title_eng)#600
#too many titles, outliers per noc visualized infeasible

##### check duplicates and delete them
get_duplicated_rows <- function(df){
  duplicated_rows <- df%>%
  group_by(prov, er_name, er_code_code_re, reference_period, noc_title_eng, id)%>%
  mutate(duplicate_count=n())%>%
  filter(duplicate_count>1)
  return(duplicated_rows)
}
duplicates_check <- get_duplicated_rows(df)

# no duplicates now
df_unique <- df%>%
  distinct(prov, er_name, er_code_code_re, reference_period, noc_title_eng, id, .keep_all = TRUE)
duplicates_check <- get_duplicated_rows(df_unique)

##### outliers identify function
#  For the "iqr" type, all values lower than first and greater than third quartile is considered, and difference between them and nearest quartile divided by IQR are calculated. For the values between these quartiles, scores are always equal to zero.
identify_outliers <- function(x){
  iqr_score <- outliers::scores(x, type = "iqr")
  return(iqr_score)
}
outliers_df <- df_unique%>%
  group_by(noc_title_eng)%>%
  summarise(
    low_wage_salaire_minium_outlier_score = identify_outliers(low_wage_salaire_minium),
    high_wage_salaire_maximal_outlier_score = identify_outliers(high_wage_salaire_maximal),
    median_wage_salaire_median_outlier_score = identify_outliers(median_wage_salaire_median)
  )%>%
  ungroup()

outliers_df%>%
  filter(low_wage_salaire_minium_outlier_score>0 & median_wage_salaire_median_outlier_score>0 & high_wage_salaire_maximal_outlier_score>0)
outlier_noc <- unique(outliers_df%>%
         filter(low_wage_salaire_minium_outlier_score>0 & median_wage_salaire_median_outlier_score>0 & high_wage_salaire_maximal_outlier_score>0)%>%
         select(noc_title_eng))
cat("These noc titles have outliers:", capture.output(outlier_noc), "\n")

# outliers removed
df_without_outliers <- df_unique%>%
  group_by(noc_title_eng)%>%
  filter(
    !identify_outliers(low_wage_salaire_minium)>0|
      !identify_outliers(high_wage_salaire_maximal)>0|
      !identify_outliers(median_wage_salaire_median)>0
  )%>%
  ungroup()

# example: trying to figure out plots here
df_2022_test <- df_without_outliers%>%
  filter(reference_period==2022)
noc_list <- as.list(unique(df_2022_test$noc_title_eng))
print(noc_list[[1]])
# print(noc_list)
selected_noc_title <- noc_list[[1]]
data_by_selected_noc <- df_2022_test[df_2022_test$noc_title_eng==selected_noc_title, ]
average_median <- aggregate(median_wage_salaire_median ~ prov, data=data_by_selected_noc, FUN = mean)
title_text <- paste('Average Median salaries of', selected_noc_title)
ggplot(average_median)+
  aes(x=prov, y=median_wage_salaire_median)+
  geom_bar(stat = 'identity', fill='skyblue')+
  labs(x='province', y='average of median annual salary', title = title_text)

##### plot function
average_median_bar_plot <- function(){
  year_input <- readline(prompt = "Enter year:")
  df_plot <- df_unique%>%
    filter(reference_period==year_input)
  noc_list <- as.list(unique(df_plot$noc_title_eng))
  noc_list_output <- capture.output(noc_list)
  cat("Job list include:", noc_list_output, "\n")
  selected_noc_title_number <- as.numeric(readline(prompt = "select one noc, input noc number \n"))
  selected_noc_title <- noc_list[[selected_noc_title_number]]
  data_by_selected_noc <- df_plot[df_plot$noc_title_eng==selected_noc_title, ]
  average_median <- aggregate(median_wage_salaire_median ~ prov, data=data_by_selected_noc, FUN = mean)
  ggplot(average_median)+
    aes(x=prov, y=median_wage_salaire_median)+
    geom_bar(stat = 'identity', fill ='skyblue')+
    labs(title = paste("Average median salaries of", selected_noc_title,"of year", year_input, sep=' '),
         x="Province",
         y="average median salaries",
    )
}
average_median_bar_plot()
