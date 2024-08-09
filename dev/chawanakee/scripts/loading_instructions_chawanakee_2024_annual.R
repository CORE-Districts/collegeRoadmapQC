chawanakee_loading_instructions <- function(path, filetype){

 data <- read.delim(egnytePath(path),sep=",",quote="\"")


  data <- data %>%
          mutate(across(everything(), as.character))
  return(data)

 }
