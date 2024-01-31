valid_api_key <- function(api_key){
  !is.null(api_key) && is.character(api_key) && length(api_key) == 36
}