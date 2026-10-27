#' ObsidianWeek
#' Class for generating weekly template files
#' @importFrom here here
#' @importFrom lubridate wday days year Date mday weeks isoweek floor_date
#' @importFrom stringr str_pad
#' @importFrom readr write_file
#' @importFrom glue glue
#' @export
ObsidianWeek <- R6::R6Class(
  "ObsidianWeek",
  inherit = ObsidianNote,
  public = list(
    #' @description Initialize a new `ObsidianWeek` object
    #' @param file_name The file name of the template
    #' @param output_dir The directory to export to
    #' @param input_date The date of the file
    #' @param author The author name
    #' @param template_dir The directory with the templates
    #' @param header_func The function to process header links (takes a list of name-link)
    #' @param unique_timestamp A unique time to uniquely name files
    #' @return A new `ObsidianWeek` object
    initialize = \(output_dir = here::here(),
                   file_name = "Week.md",
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
      day_replacement <- ReplaceTerm$new(search_term = "Days")
      day_replacement$contents <-
        makeHeaderFromList(vals = child_res,
                           template = vars$template,
                           term = day_replacement$makeSearch(),
                           trailing_mode = FALSE,
                           trailing_final = FALSE)
      template <- removeHeaderLever(template = vars$template,
                                    term = day_replacement$makeSearch())
      replacer <- Replacer$new(c(vars$obsidian_replacer, day_replacement))
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
      w_day <- lubridate::wday(self$input_date, week_start = 1)
      if(w_day != 1) {
        first_monday <- self$input_date - lubridate::days(w_day) + 1
      } else {
        first_monday <- self$input_date
      }
      if(lubridate::year(first_monday) == lubridate::year(self$input_date)) {
        self$input_date <- first_monday
      } else {
        self$input_date <- self$input_date - lubridate::days(lubridate::mday(self$input_date) - 1)
      }
      # If it's the first year of the month the end date is different
      end_date <- lubridate::Date()
      w_day <- lubridate::wday(self$input_date, week_start = 1)
      if(w_day != 1) {
        end_date <- self$input_date + lubridate::days(7 - w_day)
      } else {
        end_date <- self$input_date + lubridate::weeks(1) - lubridate::days(1)
      }
      # Prevent the week ending in the subsequent year
      if(lubridate::year(end_date) != lubridate::year(self$input_date)) {
        m_day <- as.numeric(lubridate::mday(end_date))
        end_date <- end_date - lubridate::days(m_day)
      }
      date_seq <- seq.Date(self$input_date, end_date, by = "day")
      # Get days
      w_days <- purrr::map(date_seq,
                           \(x) ObsidianDay$new(
                             input_date = x,
                             output_dir = self$output_dir,
                             author = self$author,
                             template_dir = self$template_dir,
                             header_func = self$header_func,
                             unique_timestamp = self$unique_timestamp)$process()) |>
        purrr::flatten() |>
        self$header_func()
      return(w_days)
    },
    #' @description Processes the title
    #' @returns The title as a character
    processTitle = \() {
      c_week <- lubridate::isoweek(self$input_date)
      c_year <- lubridate::year(self$input_date)
      return(glue::glue("{c_year}_{c_week |> stringr::str_pad(2, 'left', '0')}"))
    },
    #' @description Processes the output location
    #' @param vars A list of strings for title, creation_date, timestamp
    #' @returns The output path as a character
    processOutput = \(vars) {
      c_week <- lubridate::isoweek(self$input_date)
      month_week <- lubridate::isoweek(lubridate::floor_date(self$input_date, unit = "month"))

      output_name <- glue::glue("Week {c_week - month_week + 1}")
      cur_output_dir <- file.path(self$output_dir, "1_Weekly Notes",
                                  lubridate::year(self$input_date))
      if(!dir.exists(cur_output_dir)) {
        dir.create(cur_output_dir, recursive = TRUE)
      }
      c_output <- file.path(
        cur_output_dir,
        glue::glue("{vars$title} Weekly Note u-{vars$timestamp}.md"))
      out_list <- list()
      out_list[[output_name]] <- c_output
      return(out_list)
    }
  )
)
