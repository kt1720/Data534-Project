library(outliers)
#' process_NA.R
#'
#' identify and process missing values
#'
#' @author Jade Yu
#' @date 2024-02-01
#'
#' Function to identify NAs and draw plots
#'
#' @param dataset a data frame
#' 
#' @return a dataframe without missing values
#'
#' @export
library(knitr)
library("VIM")
library(dplyr)
library(ggplot2)
process_NA <- function(dataset){
  par(plt = c(0, 1, 0, 1))
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



