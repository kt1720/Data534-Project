#' @title A description of get_wage function.
#' @name trend
#' @description This is my function to plot the trend.
#' @param records The data user put in
#' @param type A choice using "overall" or "specific"
#' @param filte to remove the outliers
#' @param provs a value or vector about province
#' @param positions a value or vector about job type
#' @return One or two plot
#' @export
#' @examples
#' trend(get_wage(c("2012","2013","2014","2015","2016","2019","2020","2021","2022","2023")),type="overall")

# check package "tidyverse","patchwork"
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
if (!requireNamespace("patchwork", quietly = TRUE)) {
  install.packages("patchwork")
}
if (!requireNamespace("gridExtra", quietly = TRUE)) {
  install.packages("gridExtra")
}

library(tidyverse)
library(patchwork)
library(gridExtra)

trend<-function(records,type,filte=100000000,provs=c("Ontario","British Columbia"),positions=c("legislators")){ #set some default values
  positions<-tolower(positions)
  #get overview of all the dataset
  if (type=="overall"){
    boxplot<-records |>
      filter(median_wage<filte) |>
      group_by(year,province) |>
      ggplot2::ggplot(varwidth=TRUE) +
      #see the distribution around the nation
      ggplot2::geom_boxplot(aes(x = year, y = median_wage,col=province)) #varwidth = TRUE


    lineplot<-records |>
      filter(median_wage<filte) |>
      group_by(year,province) |>
      #calculate the mean value to draw the trend plot
      summarize(mean_average=mean(median_wage,na.rm=TRUE),count=n(),.groups="drop") |>
      ggplot2::ggplot() +
      #set group=1 to connect every point with line
      ggplot2::geom_line(aes(x=year,y=mean_average,col=province))+
      #make plot more clear
      ggplot2::theme_minimal()
    #combine them
    combined_plot <- grid.arrange(boxplot, lineplot, ncol = 2)
    #ggsave("overall_wage_trend.png", plot = combined_plot, width = 8, height = 6, dpi = 300)
    plot(combined_plot)}
  #customerized plot
  else if (type=="specific"){

    line<-records |>
      #choose the province and type of jobs selected
      mutate(occupation= tolower(occupation)) |>
      filter(province %in% provs ,occupation %in% positions, median_wage<filte) |>
      group_by(year,province,occupation) |>
      #calculate the mean value to draw the trend plot
      summarize(mean_average=mean(median_wage,na.rm=TRUE),count=n(),.groups="drop") |>
      ggplot2::ggplot() +
      #use col to distinguish type of job and facet to province
      ggplot2::geom_line(aes(x=year,y=mean_average,col=occupation))+
      ggplot2::geom_point(aes(x=year,y=mean_average,col=occupation))+
      ggplot2::facet_grid(~province)

    # point<-records%>%
    #   #choose the province and type of jobs selected
    #   filter(province %in% provs ,occupation %in% positions, median_wage<filte) %>%
    #   ggplot() +
    #   #use col to distinguish type of job and facet to province
    #   geom_point(aes(x=year,y=median_wage,col=occupation))+
    #   facet_grid(~province)+
    #   theme_minimal()

    #ggsave("special_wage_trend.png", plot = line, width = 8, height = 6, dpi = 300)
    plot(line)
  }

}

