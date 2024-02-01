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