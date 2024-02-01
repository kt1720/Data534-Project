salary_range <- function(dataset, job, prov){
  dataset %>%
    filter(occupation == job & province == prov) %>%
    summarize(minimum_salary = mean(low_wage), maximum_salary = mean(high_wage))
}