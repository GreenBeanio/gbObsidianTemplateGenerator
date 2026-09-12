#####
#####
#####
createYear <- \(input_date, template, unique_timestamp = Sys.time()) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  # This is probably wasteful if looping. Should load this once.
  loaded_template <- readr::read_file(template)
  c_year <- lubridate::year(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- as.character(c_year)
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- c_title
  c_output <- file.path(
    output_dir, 
    glue::glue("{c_title} Yearly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  new_template <- loaded_template
  new_template <- new_template |>
    stringr::str_replace_all("\\{title\\}", c_title) |>
    stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
    stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
  # Run the quarterly results to get the needed links
  quarter_dates <- c(
    lubridate::make_date(c_year, 1, 1),
    lubridate::make_date(c_year, 4, 1),
    lubridate::make_date(c_year, 7, 1),
    lubridate::make_date(c_year, 10, 1))
  quarters <- purrr::map(quarter_dates, 
                         \(x) createQuarter(x, 
                                            file.path(template_dir, 
                                                      "Quarter.md"),
                                            unique_timestamp)) |> 
    purrr::flatten() |>
    purrr::map(\(x) x |> basename() |> htmltools::urlEncodePath())
  new_template <- new_template |>
    stringr::str_replace_all("\\{Quarter 1\\}", glue::glue("[Quarter 1]({quarters[['Quarter 1']]})")) |>
    stringr::str_replace_all("\\{Quarter 2\\}", glue::glue("[Quarter 2]({quarters[['Quarter 2']]})")) |>
    stringr::str_replace_all("\\{Quarter 3\\}", glue::glue("[Quarter 3]({quarters[['Quarter 3']]})")) |>
    stringr::str_replace_all("\\{Quarter 4\\}", glue::glue("[Quarter 4]({quarters[['Quarter 4']]})"))
  # Write the file and add to output
  readr::write_file(new_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}

#####
#####
#####
createQuarter <- \(input_date, template, unique_timestamp = Sys.time()) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  # This is probably wasteful if looping. Should load this once.
  loaded_template <- readr::read_file(template)
  c_quarter <- lubridate::quarter(input_date)
  c_year <- lubridate::year(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- glue::glue("{c_year}_{c_quarter}")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- glue::glue("Quarter {c_quarter}")
  c_output <- file.path(
    output_dir, 
    glue::glue("{c_title} Quarterly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  new_template <- loaded_template
  new_template <- new_template |>
    stringr::str_replace_all("\\{title\\}", c_title) |>
    stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
    stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
  # Run the monthly results to get the needed links
  ###########
  ###########
  ###########
  # Write the file and add to output
  readr::write_file(new_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}

#####
#####
#####
createMonth <- \(input_date, template, unique_timestamp = Sys.time()) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  # This is probably wasteful if looping. Should load this once.
  loaded_template <- readr::read_file(template)
  c_month <- lubridate::month(input_date)
  c_year <- lubridate::year(input_date)
  quarter_month <- lubridate::month(lubridate::floor_date(input_date, unit = "quarter"))
  output_list <- list()
  # Get the constant variables
  c_title <- glue::glue("{c_year}_{c_month}")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- glue::glue("Month {c_month - quarter_month + 1}")
  c_output <- file.path(
    output_dir, 
    glue::glue("{c_title} Monthly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  new_template <- loaded_template
  new_template <- new_template |>
    stringr::str_replace_all("\\{title\\}", c_title) |>
    stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
    stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
  # Run the monthly results to get the needed links
  ###########
  ###########
  ###########
  # Write the file and add to output
  readr::write_file(new_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}

#####
#####
#####
createWeek <- \(input_date, template, unique_timestamp = Sys.time()) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  # This is probably wasteful if looping. Should load this once.
  loaded_template <- readr::read_file(template)
  c_week <- lubridate::week(input_date)
  c_year <- lubridate::year(input_date)
  month_week <- lubridate::week(lubridate::floor_date(input_date, unit = "month"))
  output_list <- list()
  # Get the constant variables
  c_title <- glue::glue("{c_year}_{c_week}")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- glue::glue("Week {c_week - month_week + 1}")
  c_output <- file.path(
    output_dir, 
    glue::glue("{c_title} Weekly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  new_template <- loaded_template
  new_template <- new_template |>
    stringr::str_replace_all("\\{title\\}", c_title) |>
    stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
    stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
  # Run the daily results to get the needed links
  ###########
  ###########
  ###########
  # Write the file and add to output
  readr::write_file(new_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}

#####
#####
#####
createDay <- \(input_date, template, unique_timestamp = Sys.time()) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  # This is probably wasteful if looping. Should load this once.
  loaded_template <- readr::read_file(template)
  input_date <- lubridate::date(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- strftime(input_date, "%Y_%m_%d")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- as.character(lubridate::wday(input_date, label = TRUE, 
                                              abbr = FALSE, week_start = 1))
  output_file <- file.path(
    output_dir, 
    glue::glue("{c_title} Daily Note u-{c_unique_timestamp}.md"))
  if(file.exists(output_file)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- output_file
    return(output_list)
  }
  # Load template and replace the constant variables
  new_template <- loaded_template
  new_template <- new_template |>
    stringr::str_replace_all("\\{title\\}", c_title) |>
    stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
    stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
  # Write the file and add to output
  readr::write_file(new_template, output_file)
  output_list[[output_name]] <- output_file
  return(output_list)
}