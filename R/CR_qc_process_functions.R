library(googlesheets4)
library(googledrive)

CR_rename_columns <- function(file_path, district_name) {
  # Check file type and read the file
  if (grepl("\\.csv$", file_path)) {
    data <- read_delim(file_path,delim = ",",quote = "\"")
  } else if (grepl("\\.(xlsx|xls)$", file_path)) {
    data <- readxl::read_excel(file_path)
  } else {
    stop("Unsupported file type")
  }

  # Extract headers
  headers <- colnames(data)

  header_df <- data.frame(District_values = headers)

  #create_copy
  gs_copy <- drive_cp(file = as_id("1BGTkMniE6aEZ7RKq6N8hwMxsyPNwZ3cEQ-y9r6PXCRE"), path = as_id("1bwFZ00MeJ9J8ccDHooiIjIJKoty-hx6D"))

  # Save Google Sheet with new name
  new_name <- paste0(district_name, "_CR_column_values")
  drive_rename(gs_copy, new_name)

  # Write headers to the Google Sheet in the specified column
  range_write(ss = gs_copy, data = header_df, range = "xwalk!A2",col_names = FALSE)


  # Output the URL of the new Google Sheet
  cat("Google Sheet ID:", gs_copy$id, "\n")
}

CR_apply_column_names <- function(file_path, district_name) {

  parent_folder_id <- as_id("1bwFZ00MeJ9J8ccDHooiIjIJKoty-hx6D")

  new_file_name <- str_interp("${district_name}_CR_column_values")

  file <- drive_ls(as_id(parent_folder_id)) %>%
    filter(name == new_file_name) %>%
    pull(id) %>%
    as.character()

  crosswalk <- read_sheet(file,sheet="xwalk") %>%
    mutate(across(everything(),as.character))
  # Check file type and read the file
  if (grepl("\\.csv$", file_path)) {
    file <- read_csv(file_path)
  } else if (grepl("\\.(xlsx|xls)$", file_path)) {
    file <- readxl::read_excel(file_path)
  } else {
    stop("Unsupported file type")
  }


  for(colname in crosswalk[["CORE_Value"]]){
    new_name <- colname
    old_name <- crosswalk[["District_Value"]][which(crosswalk[["CORE_Value"]] == colname)]

    file <- file %>%
      mutate(!!new_name := !!as.name(old_name))

  }
  test <- file %>%
    select(crosswalk$CORE_Value)

  # Write the data back to a new CSV file
  location <- dirname(file_path)
  date <- Sys.time() %>%
    str_replace_all(":","_")
  new_file_name <- paste0(location,"/",district_name, "_CR_renamed_transcript_",date,".csv")
  write_csv(test,new_file_name)

  cat("File saved as:", new_file_name, "\n")
}

library(rmarkdown)

CR_generate_qc_report <- function(file_path, district_name) {

  file_title <- str_interp("${district_name}_CR_transcript_qc_report.html")

  template_path <- system.file(
    "rmarkdown/templates/qc_report/skeleton",
    "skeleton.Rmd",
    package = "collegeRoadmapQC")

  output_loc <- "qc_reports"

  render(template_path,
         output_file = file_title,
         output_dir = output_loc,
         params = list(
           district = district_name),
         output_format = "html_document")
}
