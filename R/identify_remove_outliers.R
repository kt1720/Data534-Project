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
