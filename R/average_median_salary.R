average_median_bar_plot <- function(){
  year_input <- readline(prompt = "Enter year:")
  df_plot <- df_unique%>%
    filter(reference_period==year_input)
  noc_list <- as.list(unique(df_plot$noc_title_eng))
  noc_list_output <- capture.output(noc_list)
  cat("Job list include:", noc_list_output, "\n")
  selected_noc_title_number <- as.numeric(readline(prompt = "select one noc, input noc number \n"))
  selected_noc_title <- noc_list[[selected_noc_title_number]]
  data_by_selected_noc <- df_plot[df_plot$noc_title_eng==selected_noc_title, ]
  average_median <- aggregate(median_wage_salaire_median ~ prov, data=data_by_selected_noc, FUN = mean)
  ggplot(average_median)+
    aes(x=prov, y=median_wage_salaire_median)+
    geom_bar(stat = 'identity', fill ='skyblue')+
    labs(title = paste("Average median salaries of", selected_noc_title,"of year", year_input, sep=' '),
         x="Province",
         y="average median salaries",
    )
}
average_median_bar_plot()