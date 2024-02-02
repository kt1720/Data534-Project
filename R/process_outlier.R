library(outliers)
library(knitr)
library("VIM")
library(dplyr)
library(ggplot2)
identify_outliers <- function(x){
  iqr_score <- outliers::scores(x, type = "iqr")
  return(iqr_score)
}
process_outlier <- function(dataset){
  outliers_df <- dataset%>%
    group_by(occupation)%>%
    reframe(
      low_wage_outlier_score = scores(low_wage, type='iqr'),
      high_wage_outlier_score = scores(high_wage, type='iqr'),
      median_wage_outlier_score = scores(median_wage, type='iqr')
    )%>%
    ungroup()
  
  # outliers_df%>%
  #   filter(!(low_wage_outlier_score==0 & median_wage_outlier_score==0 & high_wage_outlier_score==0))
  outlier_jobs <- as.data.frame(
    unique(outliers_df%>%
             filter(!(low_wage_outlier_score==0 & median_wage_outlier_score==0 & high_wage_outlier_score==0))%>%
             select(occupation)
    )
  )
  cat("There are outliers in these occupations:")
  kable(outlier_jobs)
  
}

#process_outlier(new_dataset)