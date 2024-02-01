#' This is a sample function
#'
#' @param type A choice using "overall" or "specific"
#' @param provs a value or vector about province
#' @param positions a value or vector about job type
#' @return One or two plot
#' @examples
#' trend("overall")


trend<-function(type,provs=c("ON","BC"),positions=c("Data_entry_clerks")){ #set some default values
  # check package "tidyverse","patchwork"
  if (!requireNamespace("tidyverse", quietly = TRUE)) {
    install.packages("tidyverse")
  }
  if (!requireNamespace("patchwork", quietly = TRUE)) {
    install.packages("patchwork")
  }
  
  library(tidyverse) 
  library(patchwork)
  #get overview of all the dataset
  if (type=="overall"){
    boxplot<-records %>% 
      group_by(year,prov) %>%
      ggplot() +
      #see the distribution around the nation
      geom_boxplot(aes(x = year, y = median_wage_salaire_median)) +
      #see the density and values of different province
      geom_jitter(aes(x = year, y = median_wage_salaire_median,col=prov), width = 0.2)
    
    
    lineplot<-records%>%
      group_by(year,prov) %>%
      #calculate the mean value to draw the trend plot
      summarize(mean_average=mean(median_wage_salaire_median,na.rm=TRUE),count=n()) %>% 
      ggplot() +
      #set group=1 to connect every point with line
      geom_line(aes(x=year,y=mean_average,col=prov,group = 1))+
      #make plot more clear
      theme_minimal()
    #combine them
    boxplot+lineplot}
  #customerized plot
  else if (type=="specific"){
    
    line<-records%>%
      #choose the province and type of jobs selected
      filter(prov %in% provs ,noc_title %in% positions ) %>% 
      ggplot() +
      #use col to distinguish type of job and facet to province
      geom_line(aes(x=year,y=median_wage_salaire_median,col=noc_title))+
      facet_grid(~prov)+
      theme_minimal()
    plot(line)
  }
  
}

