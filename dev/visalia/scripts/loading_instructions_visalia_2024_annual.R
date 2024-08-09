visalia_loading_instructions <- function(path, filetype){

 data <- readxl::read_xlsx(egnytePath(path),col_names = T,sheet = "1. Student Transcript")


  data <- data %>%
          mutate(across(everything(), as.character))
  return(data)

 }
