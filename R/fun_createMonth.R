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
  c_title <- glue::glue("{c_year}_{c_month |> stringr::str_pad(2, 'left', '0')}")
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
  start_week_day <- start_month_day |> lubridate::wday(week_start = 1)
  start_day_off <- 0
  week_dates <- lubridate::Date()
  # This is mainly done to ensure the weekly function gets a starting date
  # from the current month. This correctly assigns the weeks in the template.
  if(start_week_day != 1) {
    start_day_off <- 7 - start_week_day + 1
    first_monday <- input_date + lubridate::days(start_day_off)
    week_dates <- purrr::map2_vec(1:(week_count-1), 
                                  first_monday,
                                  \(c_wk, sd) sd + lubridate::weeks(c_wk - 1))
    week_dates <- c(start_month_day, week_dates)
  } else {
    week_dates <- purrr::map2_vec(1:week_count, start_month_day,
                                  \(c_wk, sd) sd + lubridate::weeks(c_wk - 1))
  }
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