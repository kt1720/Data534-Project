

##this is for checking duplicate row, can opt not for using this
get_duplicated_rows <- function(df){
  duplicated_rows <- df%>%
    group_by(prov, er_name, er_code_code_re, reference_period, noc_title_eng, id)%>%
    mutate(duplicate_count=n())%>%
    filter(duplicate_count>1)
  return(duplicated_rows)
}