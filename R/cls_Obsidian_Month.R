#' ObsidianMonth
#' Class for generating monthly template files
#' @importFrom here here
#' @importFrom lubridate wday days weeks isoweek floor_date ceiling_date Date month year
#' @importFrom stringr str_pad
#' @importFrom readr write_file
#' @importFrom glue glue
#' @export
ObsidianMonth <- R6::R6Class(
  "ObsidianMonth",
  inherit = ObsidianNote,
  public = list(
    #' @description Initialize a new `ObsidianMonth` object
    #' @param file_name The file name of the template
    #' @param output_dir The directory to export to
    #' @param input_date The date of the file
    #' @param author The author name
    #' @param template_dir The directory with the templates
    #' @param header_func The function to process header links (takes a list of name-link)
    #' @param unique_timestamp A unique time to uniquely name files
    #' @returns A new `ObsidianMonth` object
    initialize = \(output_dir = here::here(),
                   file_name = "Month.md",
                   input_date = Sys.Date(),
                   author = Sys.info()[["user"]],
                   template_dir = system.file(
                     "extdata", "Templates",
                     package = "gbObsidianTemplateGenerator"),
                   header_func = makeObsidianFilePath,
                   unique_timestamp = Sys.time()) {
      super$initialize(
        output_dir = output_dir,
        input_date = input_date,
        author = author,
        template_dir = template_dir,
        header_func = header_func,
        unique_timestamp = unique_timestamp,
        file_name = file_name)
    },
    #' @description Processes the template for the current object level
    #' @param vars A list of strings for title, creation_date, timestamp, output, and template
    #' @param child_res Takes a list of child headers and file paths
    #' @returns A list of the header name and the corresponding file path
    #' Exports needed templates
    processSelf = \(vars, child_res) {
      week_replacement <- ReplaceTerm$new(search_term = "Weeks")
      week_replacement$contents <-
        makeHeaderFromList(vals = child_res,
                           template = vars$template,
                           term = week_replacement$makeSearch(),
                           trailing_mode = FALSE,
                           trailing_final = FALSE)
      template <- removeHeaderLever(template = vars$template,
                                    term = week_replacement$makeSearch())
      replacer <- Replacer$new(c(vars$obsidian_replacer, week_replacement))
      template <- Templater$new(replacer = replacer, template = template)$process()
      # Write the file and add to output
      readr::write_file(template, vars$output[[1]])
      output_list <- list()
      output_list[[names(vars$output)[1]]] <- vars$output[[1]]
      return(output_list)
    },
    #' @description Processes the child template object
    #' @returns A list of the header name and the corresponding file paths from the child
    #' Runs child class
    processChild = \() {
      start_month_day <- lubridate::floor_date(self$input_date, unit = "month")
      start_week <- lubridate::isoweek(start_month_day)
      end_week <- lubridate::isoweek(lubridate::ceiling_date(self$input_date,
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
                           \(x) ObsidianWeek$new(
                             input_date = x,
                             output_dir = self$output_dir,
                             author = self$author,
                             template_dir = self$template_dir,
                             header_func = self$header_func,
                             unique_timestamp = self$unique_timestamp)$process()) |>
        purrr::flatten() |>
        self$header_func()
      return(c_weeks)
    },
    #' @description Processes the title
    #' @returns The title as a character
    processTitle = \() {
      c_month <- lubridate::month(self$input_date)
      c_year <- lubridate::year(self$input_date)
      return(glue::glue("{c_year}_{c_month |> stringr::str_pad(2, 'left', '0')}"))
    },
    #' @description Processes the output location
    #' @param vars A list of strings for title, creation_date, timestamp
    #' @returns The output path as a character
    processOutput = \(vars) {
      c_month <- lubridate::month(self$input_date)
      quarter_month <- lubridate::month(lubridate::floor_date(self$input_date, unit = "quarter"))
      output_name <- glue::glue("Month {c_month - quarter_month + 1}")
      cur_output_dir <- file.path(self$output_dir, "2_Monthly Notes", lubridate::year(self$input_date))
      if(!dir.exists(cur_output_dir)) {
        dir.create(cur_output_dir, recursive = TRUE)
      }
      c_output <- file.path(
        cur_output_dir,
        glue::glue("{vars$title} Monthly Note u-{vars$timestamp}.md"))
      out_list <- list()
      out_list[[output_name]] <- c_output
      return(out_list)
    }
  )
)
