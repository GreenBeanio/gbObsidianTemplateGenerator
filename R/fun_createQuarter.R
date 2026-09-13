#####
#####
#####
createQuarter <- \(input_date, 
                   template_dir,
                   output_dir,
                   author = Sys.info[["user"]],
                   template_pre = "",
                   unique_timestamp = Sys.time(), 
                   header_func = makeObsidianFilePath) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Quarter.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
  c_quarter <- lubridate::quarter(input_date)
  c_year <- lubridate::year(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- glue::glue("{c_year}_{c_quarter}")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- glue::glue("Quarter {c_quarter}")
  cur_output_dir <- file.path(output_dir, "3_Quarterly Notes", lubridate::year(input_date))
  if(!dir.exists(cur_output_dir)) {
    # Recursion could be somewhat annoying if you put in the wrong input directory
    dir.create(cur_output_dir, recursive = TRUE)
  }
  c_output <- file.path(
    cur_output_dir, 
    glue::glue("{c_title} Quarterly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp, author)
  # Run the months
  start_month <- lubridate::month(lubridate::floor_date(input_date, unit = "quarter"))
  month_dates <- c(
    lubridate::make_date(c_year, start_month, 1),
    lubridate::make_date(c_year, start_month + 1, 1),
    lubridate::make_date(c_year, start_month + 2, 1))
  c_months <- purrr::map(month_dates, 
                         \(x) createMonth(input_date =  x,
                                          template_dir = template_dir,
                                          output_dir = output_dir,
                                          author = author,
                                          template_pre = template_pre,
                                          unique_timestamp = unique_timestamp,
                                          header_func = header_func)) |> 
    purrr::flatten() |>
    header_func()
  loaded_template <- replaceHeaderLinks(
    c_months,
    paste0("Month ", 1:3),
    loaded_template)
  # Write the file and add to output
  readr::write_file(loaded_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}