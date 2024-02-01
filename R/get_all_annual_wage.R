get_df_annual_wage <- function(df_split){
  df <- df_split%>%
    rowwise()%>%
    mutate(across(contains('wage_salaire'), ~ifelse(annual_wage_flag_salaire_annuel==0, .*2080, .)))%>%
    select(-annual_wage_flag_salaire_annuel)%>%
    arrange(reference_period)
  return(df)
}
df <- get_df_annual_wage(df_split)