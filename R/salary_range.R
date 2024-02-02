salary_range <- function(dataset, job, prov){
  prov <- translate_province(prov)
  dataset %>%
    filter(occupation == job & province == prov) %>%
    summarize(minimum_salary = mean(low_wage), maximum_salary = mean(high_wage))
}