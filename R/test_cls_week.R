ObsidianWeek <- R6::R6Class(
  #' Class for generating weekly template files
  "ObsidianWeek",
  inherit = ObsidianNote,
  public = list(
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
    processSelf = \(vars, child_res) {
      #' Process Self
      #' vars: A list of strings for title, creation_date, timestamp, output, template, and obsidian_replacer
      #' child_res: Takes a list of child headers and file paths
      #' Exports needed templates
      #' Returns a list of the header name and the corresponding file path
      # Load template and replace the constant variables
      obsidian_replacement <- obsidianMetadataReplace(
        title = vars$title,
        creation_date = vars$creation_date,
        unique_timestamp = vars$timestamp,
        author = self$author)
      day_replacement <- ReplaceTerm$new(search_term = "Days")
      day_replacement$contents <-
        makeHeaderFromList(vals = child_res,
                           template = vars$template,
                           term = day_replacement$makeSearch(),
                           trailing_mode = FALSE,
                           trailing_final = FALSE)
      template <- removeHeaderLever(template = vars$template,
                                    term = day_replacement$makeSearch())
      replacer <- Replacer$new(c(obsidian_replacement, day_replacement))
      template <- Templater$new(replacer = replacer, template = template)$process()
      # Write the file and add to output
      readr::write_file(template, vars$output[[1]])
      output_list <- list()
      output_list[[names(vars$output)[1]]] <- vars$output[[1]]
      return(output_list)
    },
    processChild = \() {
      #' Process Child
      #' Runs child class
      #' Returns a list of the header name and the corresponding file paths from the child
      # Prevent the week starting in the previous year
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
    processTitle = \() {
      #' Processes the title
      #' Returns a string
      c_week <- lubridate::isoweek(self$input_date)
      c_year <- lubridate::year(self$input_date)
      return(glue::glue("{c_year}_{c_week |> stringr::str_pad(2, 'left', '0')}"))
    },
    processOutput = \(vars) {
      #' Processes the output path
      #' Takes an additional list with the following strings:
      #'  - title
      #'  - creation_date
      #'  - timestamp
      #' Returns a list with the header as the name and the path as the value
      c_week <- lubridate::isoweek(self$input_date)
      month_week <- lubridate::isoweek(lubridate::floor_date(self$input_date, unit = "month"))

      output_name <- glue::glue("Week {c_week - month_week + 1}")
      cur_output_dir <- file.path(self$output_dir, "1_Weekly Notes",
                                  lubridate::year(self$input_date))
      if(!dir.exists(cur_output_dir)) {
        # Recursion could be somewhat annoying if you put in the wrong input directory
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
