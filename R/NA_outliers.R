library(outliers)
library(knitr)
library("VIM")
library(dplyr)
library(ggplot2)
process_NA <- function(dataset){
  if(any(is.na(dataset))==TRUE){
    missing_counts <- colSums(is.na(dataset))
    missing_counts_table <- data.frame(NA_Counts = missing_counts)
    kable(missing_counts_table)
    VIM::aggr(dataset, prop=T)
    matrixplot(dataset)
    dataset <- na.omit(dataset)
    return(dataset)
  }
  else{
    print("No missing values detected")
  }
}
#new_dataset <- process_NA(dataset)
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

process_outlier(new_dataset)
# library(tidyr)
# data_long <- gather(outliers_df, key='variable', y='value')
# ggplot(data_long)+
#   aes(x=variable, y=value, fill=variable)+
#   geom_bar(stat = 'identity', position='dodge')

