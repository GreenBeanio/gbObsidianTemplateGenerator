#' createMonth
#'
#' Creates a monthly template
#'
#' @param input_date A date object to create a template for
#' (Default: Sys.Date())
#' @param template_dir A directory with the "Month.md" template file to process
#' (Default: system.file("extdata", "Templates", package = "gbObsidianTemplateGenerator"))
#' @param output_dir A directory to output the processed templates to
#' (Default: here::here())
#' @param author The name of the author for the file
#' (Default: Sys.info()[["user"]])
#' @param template_pre  An optional prefix on your "Month.md" file to use a
#' different template
#' (Default: "")
#' @param unique_timestamp A time object to use as the file's unique time stamp
#' (Default: Sys.time())
#' @param header_func The function to use to process the links in the template
#' (Default: makeObsidianFilePath)
#'
#' @returns
#' A list with the Month of the quarter the key and the path to the exported file
#' as the value.
#'
#' @section Additional Information:
#' This function will export the processed file and return the path to the
#' processed file. If a file already exists the path will be returned but the
#' existing file will not be overwritten.
#'
#' @examples
#' \dontrun{
#' createMonth()
#' }
#'
#' @importFrom glue glue
#' @importFrom readr read_file
#' @importFrom lubridate month isoweek year ceiling_date floor_date wday days weeks
#' @importFrom purrr map flatten map2_vec
#' @export
createMonth <- \(input_date = Sys.Date(),
                 template_dir = system.file("extdata", "Templates",
                                            package = "gbObsidianTemplateGenerator"),
                 output_dir = here::here(),
                 author = Sys.info()[["user"]],
                 template_pre = "",
                 unique_timestamp = Sys.time(),
                 header_func = makeObsidianFilePath) {
  # All of these parameters could be a parameter object... but it's fine...
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Month.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
  input_date <- lubridate::date(input_date)
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
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp, author)
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
    first_monday <- start_month_day + lubridate::days(start_day_off)
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
                                        author = author,
                                        template_pre = template_pre,
                                        unique_timestamp = unique_timestamp,
                                        header_func = header_func)) |>
    purrr::flatten() |>
    header_func()
  loaded_template <- replaceHeaderLinks(
    list(Weeks = c_weeks),
    c("Weeks", paste0("Week ", 1:6)),
    loaded_template)
  # Write the file and add to output
  readr::write_file(loaded_template, c_output)
  output_list[[output_name]] <- c_output
  return(output_list)
}
