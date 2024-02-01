library(plotly)
library(sf)
library(rnaturalearth)

map <- function(dataset, year, job){
  if(length(year) == 1){
    map_ca <- ne_states(country = "Canada", returnclass = "sf") %>%
      rename(province = gn_name) %>%
      select(Province, postal, region, geometry) %>%
      
  }
}