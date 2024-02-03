#' average_median_bar_plot.R
#'
#' draw plot of a chosen year and occupation
#'
#' @author Jade Yu
#' @date 2024-02-01
#'
#' Function to draw plots
#'
#' @param new_dataset a data frame
#' 
#' @return plots
#'
#' @export

library(ggplot2)
library(dplyr)
year_input <- function(){
  year_input <- readline(prompt = "Enter year:")
  return(year_input)
}
job_title_number_input <- function(){
  selected_noc_title_number <- as.numeric(readline(prompt = "select one job, input job row number \n"))
  return(selected_noc_title_number)
}
average_median_bar_plot <- function(new_dataset){
  year_input <- year_input()
  df_plot <- new_dataset%>%
    filter(as.character(year(year))==year_input)
  noc_list <- unique(df_plot$occupation)
  #noc_list
  noc_list_output <- capture.output(noc_list)
  cat("Job list includes:", noc_list_output, "\n")
  #kable(noc_list_output)

  job_title_number <- job_title_number_input()
  
  selected_noc_title <- as.character(noc_list[[job_title_number]])
  data_by_selected_noc <- df_plot[df_plot$occupation==selected_noc_title, ]
  average_median <- aggregate(median_wage ~ province, data=data_by_selected_noc, FUN = mean)
  ggplot(average_median)+
    aes(x=province, y=median_wage)+
    geom_bar(stat = 'identity', fill ='skyblue')+
    labs(title = paste("Average median salaries of", selected_noc_title,"of year", year_input, sep=' '),
         x="Province",
         y="Average Median Salaries",
    )
}

#average_median_bar_plot(new_dataset)