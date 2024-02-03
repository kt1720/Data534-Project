#' Calculate Salary Range for a Specific Job and Province in a Dataset
#' 
#' This function calculates the salary range for a specific job and province in a given dataset. 
#' It filters the dataset based on the provided job title and province, 
#' then computes the average of the low and high wages to determine the salary range.
#'
#' @param dataset A tibble or data frame containing the wage dataset.
#' @param job A character string representing the job title for which to calculate the salary range.
#' @param prov A character string representing the province for which to calculate the salary range.
#'
#' @return A tibble summarizing the salary range with columns "minimum_salary" and "maximum_salary." 
#'         If no data is found for the specified job and province, NULL is returned.
#'         
#' @export
#'        
#' @examples
#' # Calculate salary range for the job "Software Engineers" in the province "Ontario"
#' software_dev_salary_range <- salary_range(dataset = your_dataset, job = "Software Engineers", prov = "Ontario")
#'
#' # Calculate salary range for the job "data scientists" in the province "British Columbia"
#' data_analyst_salary_range <- salary_range(dataset = your_dataset, job = "data scientists", prov = "British Columbia")
#'
#' # Handle no data found
#' no_data_range <- salary_range(dataset = your_dataset, job = "nonexistent job", prov = "Nonexistent Province")
#' # This will return NULL as no data is found for the specified job and province.

salary_range <- function(dataset, job, prov){
  prov <- translate_province(prov)
  dataset %>%
    filter(occupation == job & province == prov) %>%
    summarize(minimum_salary = mean(low_wage), maximum_salary = mean(high_wage))
}