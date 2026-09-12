#####
#####
#####
createYear <- \(input_dates, template, unique_timestamp = Sys.time()) {
  loaded_template <- readr::read_file(template) #readLines(template)
  unique_years <- unique(lubridate::year(input_dates))
  output_list <- list()
  for(c_year in unique_years) {
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
      next
    }
    # Load template and replace the constant variables
    new_template <- loaded_template
    new_template <- new_template |>
      stringr::str_replace_all("\\{title\\}", c_title) |>
      stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
      stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
    # Run the quarterly results to get the needed links
    
    # Write the file and add to output
    readr::write_file(new_template, c_output)
    output_list[[output_name]] <- c_output
  }
  return(output_list)
}

#####
#####
#####
createQuarter <- \(input_dates, template, unique_timestamp = Sys.time()) {
  loaded_template <- readr::read_file(template)
  unique_quarters <- unique(lubridate::quarter(input_dates))
  c_year <- lubridate::year(input_dates[[1]])
  output_list <- list()
  for(c_quarter in unique_quarters) {
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
      next
    }
    # Load template and replace the constant variables
    new_template <- loaded_template
    new_template <- new_template |>
      stringr::str_replace_all("\\{title\\}", c_title) |>
      stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
      stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
    # Run the monthly results to get the needed links
    
    # Write the file and add to output
    readr::write_file(new_template, c_output)
    output_list[[output_name]] <- c_output
  }
  return(output_list)
}

#####
#####
#####
createMonth <- \(input_dates, template, unique_timestamp = Sys.time()) {
  loaded_template <- readr::read_file(template)
  unique_months <- unique(lubridate::month(input_dates))
  c_year <- lubridate::year(input_dates[[1]])
  month_start <- lubridate::month(lubridate::floor_date(input_dates[[1]], unit = "quarter"))
  output_list <- list()
  for(c_month in unique_months) {
    # Get the constant variables
    c_title <- glue::glue("{c_year}_{c_month}")
    c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
    c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
    # Get the output path and check if it exists
    output_name <- glue::glue("Month {c_month - month_start + 1}")
    c_output <- file.path(
      output_dir, 
      glue::glue("{c_title} Monthly Note u-{c_unique_timestamp}.md"))
    if(file.exists(c_output)) {
      # Skip if it exists to not accidentally overwrite previous modifications
      output_list[[output_name]] <- c_output
      next
    }
    # Load template and replace the constant variables
    new_template <- loaded_template
    new_template <- new_template |>
      stringr::str_replace_all("\\{title\\}", c_title) |>
      stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
      stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
    # Run the monthly results to get the needed links
    
    # Write the file and add to output
    readr::write_file(new_template, c_output)
    output_list[[output_name]] <- c_output
  }
  return(output_list)
}

#####
#####
#####
createWeek <- \(input_dates, template, unique_timestamp = Sys.time()) {
  loaded_template <- readr::read_file(template)
  unique_weeks <- unique(lubridate::week(input_dates))
  c_year <- lubridate::year(input_dates[[1]])
  # monthly_weeks <- lubridate::week(
  #   c(lubridate::floor_date(input_dates[[1]], unit = "month"),
  #     lubridate::ceiling_date(input_dates[[1]], unit = "month") - lubridate::days(1)))
  week_start <- lubridate::week(lubridate::floor_date(input_dates[[1]], unit = "month"))
  output_list <- list()
  for(c_week in unique_weeks) {
    # Get the constant variables
    c_title <- glue::glue("{c_year}_{c_week}")
    c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
    c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
    # Get the output path and check if it exists
    #output_name <- glue::glue("Week {c_week - monthly_weeks[1] + 1}")
    output_name <- glue::glue("Week {c_week - week_start + 1}")
    c_output <- file.path(
      output_dir, 
      glue::glue("{c_title} Weekly Note u-{c_unique_timestamp}.md"))
    if(file.exists(c_output)) {
      # Skip if it exists to not accidentally overwrite previous modifications
      output_list[[output_name]] <- c_output
      next
    }
    # Load template and replace the constant variables
    new_template <- loaded_template
    new_template <- new_template |>
      stringr::str_replace_all("\\{title\\}", c_title) |>
      stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
      stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
    # Run the daily results to get the needed links
    
    # Write the file and add to output
    readr::write_file(new_template, c_output)
    output_list[[output_name]] <- c_output
  }
  return(output_list)
}

#####
#####
#####
createDay <- \(input_dates, template, unique_timestamp = Sys.time()) {
  loaded_template <- readr::read_file(template)
  unique_days <- unique(lubridate::date(input_dates))
  output_list <- list()
  for(c_day in unique_days) {
    # Dates need to be turned back when iterating over for whatever reason
    c_day <- as.Date(c_day)
    # Get the constant variables
    c_title <- strftime(c_day, "%Y_%m_%d")
    c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
    c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
    # Get the output path and check if it exists
    output_name <- as.character(lubridate::wday(c_day, label = TRUE, 
                                                abbr = FALSE, week_start = 1))
    c_output <- file.path(
      output_dir, 
      glue::glue("{c_title} Daily Note u-{c_unique_timestamp}.md"))
    if(file.exists(c_output)) {
      # Skip if it exists to not accidentally overwrite previous modifications
      output_list[[output_name]] <- c_output
      next
    }
    # Load template and replace the constant variables
    new_template <- loaded_template
    new_template <- new_template |>
      stringr::str_replace_all("\\{title\\}", c_title) |>
      stringr::str_replace_all("\\{creation_date\\}", c_creation_date) |>
      stringr::str_replace_all("\\{unique_timestamp\\}", c_unique_timestamp)
    # Write the file and add to output
    readr::write_file(new_template, c_output)
    output_list[[output_name]] <- c_output
  }
  return(output_list)
}