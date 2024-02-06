#' @name process_NA
#'
#' @title identify and process missing values
#'
#' @description Function to identify NAs and draw plots
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
library(outliers)
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



