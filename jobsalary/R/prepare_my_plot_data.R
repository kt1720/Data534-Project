library(tidyr)
preparing_data <- function(data) {
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

processing_data <- function(records2019, records2020, records2021, records2022, records2023){
  r2023=preparing(records2023)
  r2022=preparing(records2022)
  r2021=preparing(records2021)
  r2020=preparing(records2020)
  r2019=preparing(records2019)
  #r_list <- list(r2019, r2020, r2021, r2022, r2023)
  #column_names_table <- get_column_names_table(r2019, r2020, r2021, r2022, r2023)
  colnames(r2019) <- colnames(r2022) <- colnames(r2021) <- colnames(r2020) <- colnames(r2023)
#####column names identical now

#####combine dataframes horizontally
  r<-rbind(r2023,r2022,r2021,r2020,r2019)

# use separate_rows of 'tidyr' library to split the reference_period
  r$reference_period <- gsub("(\\d+)-(\\d+)-(\\d+)", "\\1-\\3", r$reference_period)
  df_split <- separate_rows(r, reference_period, sep = "-")
  ###get all annual wage data
  df <- df_split%>%
    rowwise()%>%
    mutate(across(contains('wage_salaire'), ~ifelse(annual_wage_flag_salaire_annuel==0, .*2080, .)))%>%
    select(-annual_wage_flag_salaire_annuel)%>%
    arrange(reference_period)
  colnames(df)[colnames(df)=='_id'] <- 'id'
  df <- na.omit(df)
  
  # no duplicates now
  df_unique <- df%>%
    distinct(prov, er_name, er_code_code_re, reference_period, noc_title_eng, id, .keep_all = TRUE)
  return(df_unique)
}
###here got unique data#####


identify_outliers <- function(x){
  iqr_score <- outliers::scores(x, type = "iqr")
  return(iqr_score)
}

show_outlier_noc <- function(df_unique){
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
print("These noc titles have outliers:", capture.output(outlier_noc), "\n")
}

remove_outliers <- function(df_unique){
df_without_outliers <- df_unique%>%
  group_by(noc_title_eng)%>%
  filter(
    !identify_outliers(low_wage_salaire_minium)>0|
      !identify_outliers(high_wage_salaire_maximal)>0|
      !identify_outliers(median_wage_salaire_median)>0
  )%>%
  ungroup()
return(df_without_outliers)
}
#####now get pure df, data all set