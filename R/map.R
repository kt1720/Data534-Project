#' Create an Interactive Map of Median Salaries for a Specific Job Across Canada
#' 
#' This function generates an interactive map showcasing the median salaries for a specific job across Canadian provinces. 
#' The map can handle both single-year and multi-year datasets, providing an insightful visualization of salary variations.
#'
#' @param dataset A tibble or data frame containing the wage dataset.
#' @param job A character string representing the job title for which to visualize the median salary on the map.
#'
#' @return An interactive map created using the Plotly library, allowing users to explore median salaries 
#'         for the specified job across different Canadian provinces and years.
#'         
#' @export
#'        
#' @examples
#' # Generate an interactive map for the job "Software Engineers" using a single-year dataset
#' single_year_map <- map(dataset = your_dataset, job = "Software Engineers")
#'
#' # Generate an interactive map for the job "Data Scientists" using a multi-year dataset
#' multi_year_map <- map(dataset = your_dataset_multi_year, job = "Data Scientists")

map <- function(dataset, job){
  if(!("sf" %in% utils::installed.packages())) {
    if (utils::menu(c("Install package", "I no longer want to run the map function"),
                    title= paste("The `sf` package is required to return the map. Would you like to install?")) == "1") {
      utils::install.packages("sf")
    }
  }
  if(!("rnaturalearth" %in% utils::installed.packages())) {
    if (utils::menu(c("Install package", "I no longer want to run the map function"),
                    title= paste("The `rnaturalearth` package is required to return the map. Would you like to install?")) == "1") {
      utils::install.packages("rnaturalearth")
    }
  }
  if(length(unique(dataset$year)) == 1){
    map_ca <- rnaturalearth::ne_states(country = "Canada", returnclass = "sf") |>
      dplyr::rename(province = gn_name) |>
      dplyr::select(province, postal, region, geometry) |>
      dplyr::left_join(dataset, by = 'province') |>
      dplyr::filter(occupation == job) |>
      ggplot2::ggplot() +
      ggplot2::geom_sf(ggplot2::aes(fill = median_wage, text = paste("Province: ", province)),
                       color = "gray40") +
      ggplot2::geom_sf_text(ggplot2::aes(label = postal), size = 2) +
      ggplot2::scale_fill_gradient("Median salary", labels = scales::number, 
                                   low = "#fee8c8", high = "#e34a33") +
      ggplot2::theme_void() +
      ggplot2::theme(panel.grid = ggplot2::element_blank(),
                     axis.text = ggplot2::element_blank(),
                     axis.ticks = ggplot2::element_blank(),
                     plot.title = ggplot2::element_text(hjust=0.5,color="gray40", size=14),
                     plot.subtitle = ggplot2::element_text(color="gray40", size = 10),
                     legend.title	= ggplot2::element_text(color="grey35", size=9),
                     legend.text	= ggplot2::element_text(color="grey35", size=9)) +
      ggplot2::labs(title = paste("Median salary of", job, "across Canada"),
                    subtitle = paste("Year", dataset$year[1], '%Y'))
    plotly::ggplotly(map_ca, tooptip = "text") |>
      plotly::layout(title = list(text = paste("Median salary of", job, "across Canada<br>",
                                               "<sup>Year", format(dataset$year[1], "%Y"), '</sup>')))
  }
  else{
    map_data <- dataset |>
      dplyr::distinct(province, year) |>
      tidyr::expand(province, year) |>
      dplyr::left_join(dataset |> dplyr::filter(occupation == job) |>
                         dplyr::mutate(text = paste("Province:", province, "\nMedian wage:", median_wage)),
                       by = c("province", "year"))
    rnaturalearth::ne_states(country = "Canada", returnclass = "sf") |>
      dplyr::rename(province = gn_name) |>
      dplyr::select(province, geometry) |>
      dplyr::left_join(map_data, by = "province") |>
      plotly::plot_ly(stroke = I("black"), split = ~province, color = ~median_wage, 
                      colors = viridis::inferno(99),
                      text = ~text, showlegend = FALSE, hoveron = "fills", frame = ~year) |>
      plotly::colorbar(title = "Median wage") |>
      plotly::style(hoverlabel = list(bgcolor = "white")) |>
      plotly::animation_slider(currentvalue = list(prefix="Year: ", font = list(color = "red"))) |>
      plotly::layout(title = list(text = paste("Annual median salary of", job, "across Canada<br>")))
  }
}
