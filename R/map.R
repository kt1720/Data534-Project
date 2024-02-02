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
  }
}