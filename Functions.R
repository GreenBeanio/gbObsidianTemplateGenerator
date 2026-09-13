#####
#####
#####
createYear <- \(input_date, 
                template_dir,
                output_dir,
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
                                            output_dir = output_dir,
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
                   output_dir,
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
                                          output_dir = output_dir,
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
                 output_dir,
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
  c_title <- glue::glue("{c_year}_{c_month |> stringr::str_pad(2, 'left', '0')}}")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- glue::glue("Month {c_month - quarter_month + 1}")
  cur_output_dir <- file.path(output_dir, "2_Monthly Notes", lubridate::year(input_date))
  if(!dir.exists(cur_output_dir)) {
    # Recursion could be somewhat annoying if you put in the wrong input directory
    dir.create(cur_output_dir, recursive = TRUE)
  }
  c_output <- file.path(
    cur_output_dir, 
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
                                        output_dir = output_dir,
                                        template_pre = template_pre,
                                        unique_timestamp = unique_timestamp,
                                        header_func = header_func)) |> 
    purrr::flatten() |>
    header_func()
  loaded_template <- replaceHeaderLinks(
    c_weeks,
    paste0("Week ", 1:6),#1:length(c_weeks)),
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
                output_dir,
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
  c_title <- glue::glue("{c_year}_{c_week |> stringr::str_pad(2, 'left', '0')}")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- glue::glue("Week {c_week - month_week + 1}")
  cur_output_dir <- file.path(output_dir, "1_Weekly Notes", lubridate::year(input_date))
  if(!dir.exists(cur_output_dir)) {
    # Recursion could be somewhat annoying if you put in the wrong input directory
    dir.create(cur_output_dir, recursive = TRUE)
  }
  c_output <- file.path(
    cur_output_dir, 
    glue::glue("{c_title} Weekly Note u-{c_unique_timestamp}.md"))
  if(file.exists(c_output)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- c_output
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |> 
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp)
  # Move start date to the first monday of the week
  w_day <- lubridate::wday(input_date, week_start = 1)
  w_offset <- w_day - 1
  m_day <- as.numeric(lubridate::mday(input_date))
  cur_offset <- min(w_offset, m_day - 1)
  if(cur_offset > 0) {
    input_date <- input_date - lubridate::days(cur_offset)
  }
  # Make sure the week doesn't go into the next month
  m_day <- as.numeric(lubridate::mday(input_date))
  end_mday <- lubridate::mday(input_date + lubridate::weeks(1))
  end_offset <- 6
  if(end_mday < m_day) {
    end_offset <- 7 - end_mday
  }
  end_date <- input_date + lubridate::days(end_offset)
  date_seq <- seq.Date(input_date, end_date, by = "day")
  # Get days
  w_days <- purrr::map(date_seq, 
                       \(x) createDay(input_date = x,
                                      template_dir = template_dir,
                                      output_dir = output_dir,
                                      template_pre = template_pre,
                                      unique_timestamp = unique_timestamp,
                                      header_func = header_func)) |> 
    purrr::flatten() |>
    header_func()
  loaded_template <- replaceHeaderLinks(
    w_days,
    weekdays(seq.Date(as.Date("2026-09-07"), by = "day", length.out = 7)),
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