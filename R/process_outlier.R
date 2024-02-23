#' @name process_outlier
#'
#' @title identify and process outliers
#'
#' @description Function to identify outliers and draw plots
#'
#' @param dataset a data frame
#'
#' @return list of occupations that have outliers and outlier visualization
#'
#' @export

year_input <- function(){
  year_input <- readline(prompt = "Enter year:")
  return(year_input)
}
job_title_number_input <- function(){
  selected_noc_title_number <- as.numeric(readline(prompt = "select one job, input job row number \n"))
  return(selected_noc_title_number)
}
process_outlier <- function(dataset){
  dataset$occupation <- tolower(dataset$occupation)
  outliers_df <- dataset |>
    dplyr::group_by(occupation) |>
    dplyr::reframe(
      low_wage_outlier_score = outliers::scores(low_wage, type='iqr'),
      high_wage_outlier_score = outliers::scores(high_wage, type='iqr'),
      median_wage_outlier_score = outliers::scores(median_wage, type='iqr')
    ) |>
    dplyr::ungroup()

  # outliers_df%>%
  #   filter(!(low_wage_outlier_score==0 & median_wage_outlier_score==0 & high_wage_outlier_score==0))
  outlier_jobs <- data.frame(
    unique(outliers_df |>
             dplyr::filter(!(low_wage_outlier_score==0 & median_wage_outlier_score==0 & high_wage_outlier_score==0)) |>
             dplyr::select(occupation)
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

  zero_data_percent <- selected_outlier_df |>
    dplyr::select(-occupation) |>
    dplyr::mutate_all(~ifelse(.==0, "Non-outlier", "Outlier")) |>
    tidyr::gather(key='category', value='value') |>
    dplyr::group_by(category, value) |>
    dplyr::summarise(percentage=dplyr::n()/nrow(selected_outlier_df)*100)
  percent_plot <- ggplot2::ggplot(zero_data_percent, ggplot2::aes(x=category, y=percentage, fill=value))+
    ggplot2::geom_bar(stat='identity')+
    ggplot2::labs(title='Percentage of Outliers')+
    ggplot2::scale_y_continuous(labels=scales::percent_format(scale = 1)) +
    ggplot2::scale_fill_manual(values = c("white" = "white", "Outlier" = "blue"))
  print(percent_plot)

  #now draw a grid like plot
  outlier_dist <- selected_outlier_df |>
    dplyr::select(-occupation) |>
    dplyr::mutate(row_number = 1:dplyr::n())  |>
    tidyr::gather(key = "category", value = "value", -row_number)

  # Convert zero and non-zero values to factors for coloring
  outlier_dist$color <- ifelse(outlier_dist$value == 0, "white", "blue")
  # Create a grid-like plot
  grid_plot <- ggplot2::ggplot(outlier_dist, ggplot2::aes(x = category, y = row_number, fill = color)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_manual(values = c("white", "skyblue")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text = element_text(size = 8),
          axis.title = element_blank(),
          legend.position = "none") +
    ggplot2::labs(title = "Grid Representation of Outlier Values According to IQR Score",
         x = "Category",
         y = "Row Number")
  print(grid_plot)
}
identify_outliers <- function(x){
  iqr_score <- outliers::scores(x, type = "iqr")
  return(iqr_score)
}
