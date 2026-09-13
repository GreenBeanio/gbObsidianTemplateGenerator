#####
#####
#####
createDay <- \(input_date, 
               template_dir,
               output_dir,
               template_pre = "",
               unique_timestamp = Sys.time(), 
               header_func = makeObsidianFilePath) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Day.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
  input_date <- lubridate::date(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- strftime(input_date, "%Y_%m_%d")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- as.character(lubridate::wday(input_date, label = TRUE, 
                                              abbr = FALSE, week_start = 1))
  cur_output_dir <- file.path(
    output_dir, "0_Daily Notes", lubridate::year(input_date),
    lubridate::month(input_date) |> stringr::str_pad(2, 'left', '0'))
  if(!dir.exists(cur_output_dir)) {
    # Recursion could be somewhat annoying if you put in the wrong input directory
    dir.create(cur_output_dir, recursive = TRUE)
  }
  output_file <- file.path(
    cur_output_dir, 
    glue::glue("{c_title} Daily Note u-{c_unique_timestamp}.md"))
  if(file.exists(output_file)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- output_file
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp)
  # Write the file and add to output
  readr::write_file(loaded_template, output_file)
  output_list[[output_name]] <- output_file
  return(output_list)
}