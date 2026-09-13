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
  # This variable will change depending on the month that calls it, which is what I want
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
  # Prevent the week starting in the previous year
  w_day <- lubridate::wday(input_date, week_start = 1)
  if(w_day != 1) {
    first_monday <- input_date - lubridate::days(w_day) + 1
  } else {
    first_monday <- input_date
  }
  if(lubridate::year(first_monday) == lubridate::year(input_date)) {
    input_date <- first_monday
  } else {
    input_date <- input_date - lubridate::days(lubridate::mday(input_date) - 1)
  }
  # If it's the first year of the month the end date is different
  end_date <- lubridate::Date()
  w_day <- lubridate::wday(input_date, week_start = 1)
  if(w_day != 1) {
    end_date <- input_date + lubridate::days(7 - w_day)
  } else {
    end_date <- input_date + lubridate::weeks(1)
  }
  # Prevent the week ending in the subsequent year
  if(lubridate::year(end_date) != lubridate::year(input_date)) {
    m_day <- as.numeric(lubridate::mday(end_date))
    end_date <- end_date - lubridate::days(m_day)
  }
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