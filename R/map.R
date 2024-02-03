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

library(plotly)
library(sf)
library(rnaturalearth)

map <- function(dataset, job){
  if(length(unique(dataset$year)) == 1){
    map_ca <- ne_states(country = "Canada", returnclass = "sf") %>%
      rename(province = gn_name) %>%
      select(province, postal, region, geometry) %>%
      left_join(dataset, by = 'province') %>%
      filter(occupation == job) %>%
      ggplot() +
        geom_sf(aes(fill = median_wage, text = paste("Province: ", province)),
                color = "gray40") +
        geom_sf_text(aes(label = postal), size = 2) +
        scale_fill_gradient("Median salary", labels = scales::number, 
                            low = "#fee8c8", high = "#e34a33") +
        theme_void() +
        theme(panel.grid = element_blank(),
              axis.text = element_blank(),
              axis.ticks = element_blank(),
              plot.title = element_text(hjust=0.5,color="gray40", size=14),
              plot.subtitle = element_text(color="gray40", size = 10),
              legend.title	= element_text(color="grey35", size=9),
              legend.text	= element_text(color="grey35", size=9)) +
        labs(title = paste("Median salary of", job, "across Canada"),
             subtitle = paste("Year", dataset$year[1], '%Y'))
   ggplotly(map_ca, tooptip = "text") %>%
      layout(title = list(text = paste("Median salary of", job, "across Canada<br>",
                                       "<sup>Year", format(dataset$year[1], "%Y"), '</sup>')))
    # plot(my_plot)
  }
  else{
    map_data <- dataset %>%
      distinct(province, year) %>%
      expand(province, year) %>%
      left_join(dataset %>% filter(occupation == job) %>%
                  mutate(text = paste("Province:", province, "\nMedian wage:", median_wage)),
                by = c("province", "year"))
    ne_states(country = "Canada", returnclass = "sf") %>%
      rename(province = gn_name) %>%
      select(province, geometry) %>%
      left_join(map_data, by = "province") %>%
      plot_ly(stroke = I("black"), split = ~province, color = ~median_wage, 
              colors = viridis::inferno(99),
              text = ~text, showlegend = FALSE, hoveron = "fills", frame = ~year) %>%
      colorbar(title = "Median wage") %>%
      style(hoverlabel = list(bgcolor = "white")) %>%
      animation_slider(currentvalue = list(prefix="Year: ", font = list(color = "red"))) %>%
      layout(title = list(text = paste("Annual median salary of", job, "across Canada<br>")))
    # plot(map_data)
  }
}