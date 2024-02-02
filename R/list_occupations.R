list_occupations <- function(dataset, str){
  occupations <- grep(str, unique(dataset$occupation), ignore.case = T, value = T)
  if(length(occupations) == 0){
    return("There is no occupation that matches the input provided.")
  }
  return(occupations)
}