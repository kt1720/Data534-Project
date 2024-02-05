#' process_outlier.R
#'
#' identify and process outliers
#'
#' @author Jade Yu
#' @date 2024-02-01
#'
#' Function to identify outliers and draw plots
#'
#' @param dataset a data frame
#' 
#' @return list of occupations that have outliers and outlier visualization
#'
#' @export
library(outliers)
library(knitr)
library("VIM")
library(dplyr)
library(ggplot2)
library(scales)
# source("average_median_bar_plot.R", encoding = 'UTF-8')
year_input <- function(){
  year_input <- readline(prompt = "Enter year:")
  return(year_input)
}
job_title_number_input <- function(){
  selected_noc_title_number <- as.numeric(readline(prompt = "select one job, input job row number \n"))
  return(selected_noc_title_number)
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
  outlier_jobs <- data.frame(
    unique(outliers_df%>%
             filter(!(low_wage_outlier_score==0 & median_wage_outlier_score==0 & high_wage_outlier_score==0))%>%
             select(occupation)
    )
  )
  cat("There are outliers in these occupations:", capture.output(as.list(outlier_jobs)), "\n")
  #print(outlier_jobs)
 
  {
  job_title_number <- job_title_number_input()
  }
  selected_job <- outlier_jobs[job_title_number,]
  cat("You have chosen:", selected_job, "\n")# "Accommodation Service Managers"
  selected_outlier_df <- outliers_df[outliers_df$occupation==selected_job, ]
  
  zero_data_percent <- selected_outlier_df%>%
    select(-occupation)%>%
    mutate_all(~ifelse(.==0, "Non-outlier", "Outlier"))%>%
    gather(key='category', value='value')%>%
    group_by(category, value)%>%
    summarise(percentage=n()/nrow(selected_outlier_df)*100)
  percent_plot <- ggplot(zero_data_percent, aes(x=category, y=percentage, fill=value))+
    geom_bar(stat='identity')+
    labs(title='Percentage of Outliers')+
    scale_y_continuous(labels=scales::percent_format(scale = 1))
  print(percent_plot)
  
  #now draw a grid like plot
  outlier_dist <- selected_outlier_df %>%
    select(-occupation)%>%
    mutate(row_number = 1:n()) %>%
    gather(key = "category", value = "value", -row_number)
  
  # Convert zero and non-zero values to factors for coloring
  outlier_dist$color <- ifelse(outlier_dist$value == 0, "white", "blue")
  # Create a grid-like plot
  grid_plot <- ggplot(outlier_dist, aes(x = category, y = row_number, fill = color)) +
    geom_tile() +
    scale_fill_manual(values = c("white", "skyblue")) +
    theme_minimal() +
    theme(axis.text = element_text(size = 8),
          axis.title = element_blank(),
          legend.position = "none") +
    labs(title = "Grid Representation of Outlier Values According to IQR Score",
         x = "Category",
         y = "Row Number")
  print(grid_plot)
}
identify_outliers <- function(x){
  iqr_score <- outliers::scores(x, type = "iqr")
  return(iqr_score)
}

  
