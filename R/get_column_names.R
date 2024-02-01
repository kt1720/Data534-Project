records_list <- list(records2019, records2020, records2021, records2022, records2023)
get_column_names_table <- function(records_list){
  max_length <- 0
  for(i in seq_along(records_list)){
    max_length <- max(max_length, length(records_list[[i]]))
  }
  column_names_table <- data.frame()
  column_names_list <- list()
  for(i in seq_along(records_list)){
    c <- c(colnames(records_list[[i]]), rep(NA, max_length-length(records_list[[i]])))
    column_names_list[[i]]<- c
  }
  column_names_table<- as.data.frame(column_names_list, col.names = c('2019', '2020', '2021', '2022', '2023'))
  return(column_names_table)
}
column_names_table <- get_column_names_table(records_list)
column_names_table