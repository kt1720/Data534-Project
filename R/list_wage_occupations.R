list_wage_occupations <- function(dataset, str){
  return(grep(str, unique(dataset$occupation), ignore.case = T, value = T))
}