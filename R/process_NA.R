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



