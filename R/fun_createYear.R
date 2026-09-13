#####
#####
#####
createYear <- \(input_date, 
                template_dir,
                output_dir,
                author = Sys.info[["user"]],
                template_pre = "",
                unique_timestamp = Sys.time(), 
                header_func = makeObsidianFilePath) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Year.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
  c_year <- lubridate::year(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- as.character(c_year)
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- c_title
  cur_output_dir <- file.path(output_dir, "4_Yearly Notes")
  if(!dir.exists(cur_output_dir)) {
    # Recursion could be somewhat annoying if you put in the wrong input directory
    dir.create(cur_output_dir, recursive = TRUE)
  }
  c_output <- file.path(
    cur_output_dir, 
    glue::glue("{c_title} Yearly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp, author)
  # Run the quarterly results to get the needed links
  quarter_dates <- c(
    lubridate::make_date(c_year, 1, 1),
    lubridate::make_date(c_year, 4, 1),
    lubridate::make_date(c_year, 7, 1),
    lubridate::make_date(c_year, 10, 1))
  quarters <- purrr::map(quarter_dates, 
                         \(x) createQuarter(input_date =  x,
                                            template_dir = template_dir,
                                            output_dir = output_dir,
                                            author = author,
                                            template_pre = template_pre,
                                            unique_timestamp = unique_timestamp,
                                            header_func = header_func)) |> 
    purrr::flatten() |>
    header_func()
  loaded_template <- replaceHeaderLinks(
    quarters,
    paste0("Quarter ", 1:4),
    loaded_template)
  # Write the file and add to output
  readr::write_file(loaded_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}