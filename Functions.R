#####
#####
#####
createYear <- \(input_date, 
                template_dir,
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
  c_output <- file.path(
    output_dir, 
    glue::glue("{c_title} Yearly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp)
  # Run the quarterly results to get the needed links
  quarter_dates <- c(
    lubridate::make_date(c_year, 1, 1),
    lubridate::make_date(c_year, 4, 1),
    lubridate::make_date(c_year, 7, 1),
    lubridate::make_date(c_year, 10, 1))
  quarters <- purrr::map(quarter_dates, 
                         \(x) createQuarter(input_date =  x,
                                            template_dir = template_dir,
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

#####
#####
#####
createQuarter <- \(input_date, 
                   template_dir,
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
  c_output <- file.path(
    output_dir, 
    glue::glue("{c_title} Quarterly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp)
  # Run the months
  start_month <- lubridate::month(lubridate::floor_date(input_date, unit = "quarter"))
  month_dates <- c(
    lubridate::make_date(c_year, start_month, 1),
    lubridate::make_date(c_year, start_month + 1, 1),
    lubridate::make_date(c_year, start_month + 2, 1))
  c_months <- purrr::map(month_dates, 
                         \(x) createMonth(input_date =  x,
                                          template_dir = template_dir,
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

#####
#####
#####
createMonth <- \(input_date, 
                 template_dir,
                 template_pre = "",
                 unique_timestamp = Sys.time(), 
                 header_func = makeObsidianFilePath) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Month.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
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
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp)
  # Run the weeks
  start_month_day <- lubridate::floor_date(input_date, unit = "month")
  start_week <- lubridate::isoweek(start_month_day)
  end_week <- lubridate::isoweek(lubridate::ceiling_date(input_date, 
                                                         unit = "month") - 
                                   lubridate::days(1))
  week_count <- end_week - start_week + 1
  start_day_off <- (start_month_day |> lubridate::wday(week_start = 1)) - 1
  first_week_day <- start_month_day - lubridate::days(start_day_off)
  week_dates <- purrr::map2_vec(1:week_count, first_week_day,
                                \(c_wk, sd) sd + lubridate::weeks(c_wk - 1))
  c_weeks <- purrr::map(week_dates, 
                        \(x) createWeek(input_date =  x,
                                        template_dir = template_dir,
                                        template_pre = template_pre,
                                        unique_timestamp = unique_timestamp,
                                        header_func = header_func)) |> 
    purrr::flatten() |>
    header_func()
  loaded_template <- replaceHeaderLinks(
    quarters,
    paste0("Week ", 1:length(c_weeks)),
    loaded_template)
  # Write the file and add to output
  readr::write_file(loaded_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}

#####
#####
#####
createWeek <- \(input_date, 
                template_dir,
                template_pre = "",
                unique_timestamp = Sys.time(), 
                header_func = makeObsidianFilePath) {
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Week.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
  c_week <- lubridate::isoweek(input_date)
  c_year <- lubridate::year(input_date)
  # Need to modify this to be special since one month it could be week 1 and in another it could be week 5,  etc.
  # Probably best to handle this based on the input from the month actually.
  # Huh, I may need to sadly add another parameter to the week for this.
  # That or handle it differently for the weeks since they are variable unlike
  # the other parameters.
  # Huh, damn there's also the issue with if it's the first or last month of the
  # year the weeks aren't guaranteed to be "full".
  month_week <- lubridate::isoweek(lubridate::floor_date(input_date, unit = "month"))
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
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp)
  # Run the quarterly results to get the needed links
  quarter_dates <- c(
    lubridate::make_date(c_year, 1, 1),
    lubridate::make_date(c_year, 4, 1),
    lubridate::make_date(c_year, 7, 1),
    lubridate::make_date(c_year, 10, 1))
  quarters <- purrr::map(quarter_dates, 
                         \(x) createQuarter(input_date =  x,
                                            template_dir = template_dir,
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

#####
#####
#####
createDay <- \(input_date, 
               template_dir,
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
  output_file <- file.path(
    output_dir, 
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