ObsidianQuarter <- R6::R6Class(
  #' Class for generating weekly template files
  "ObsidianQuarter",
  inherit = ObsidianNote,
  public = list(
    initialize = \(output_dir = here::here(),
                   file_name = "Quarter.md",
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
      obsidian_replacement <- obsidianMetadataReplace(
        title = vars$title,
        creation_date = vars$creation_date,
        unique_timestamp = vars$timestamp,
        author = self$author)
      month_list <- list()
      for(ind in seq_along(child_res)) {
        replacer <- ReplaceTerm$new(search_term = paste0("Month ", ind))
        replacer$contents <- DisplayHeader$new(header = replacer$search_term,
                                               link = child_res[[ind]],
                                               level = findHeaderLevels(
                                                 template = vars$template,
                                                 term = replacer$makeSearch()),
                                               trailing_mode = FALSE)
        month_list[[ind]] <- replacer
        vars$template <- removeHeaderLever(template = vars$template,
                                      term = replacer$makeSearch())
      }
      replacer <- Replacer$new(c(obsidian_replacement, month_list))
      template <- Templater$new(replacer = replacer, template = vars$template)$process()
      readr::write_file(template, vars$output[[1]])
      output_list <- list()
      output_list[[names(vars$output)[1]]] <- vars$output[[1]]
      return(output_list)
    },
    processChild = \() {
      #' Process Child
      #' Runs child class
      #' Returns a list of the header name and the corresponding file paths from the child
      # Run the weeks
      # Run the months
      c_year <- lubridate::year(self$input_date)
      start_month <- lubridate::month(lubridate::floor_date(self$input_date,
                                                            unit = "quarter"))
      month_dates <- c(
        lubridate::make_date(c_year, start_month, 1),
        lubridate::make_date(c_year, start_month + 1, 1),
        lubridate::make_date(c_year, start_month + 2, 1))
      c_months <- purrr::map(month_dates,
                             \(x) ObsidianMonth$new(
                               input_date = x,
                               output_dir = self$output_dir,
                               author = self$author,
                               template_dir = self$template_dir,
                               header_func = self$header_func,
                               unique_timestamp = self$unique_timestamp)$process()) |>
        purrr::flatten() |>
        self$header_func()
      return(c_months)
    },
    processTitle = \() {
      #' Processes the title
      #' Returns a string
      c_quarter <- lubridate::quarter(self$input_date)
      c_year <- lubridate::year(self$input_date)
      return(glue::glue("{c_year}_{c_quarter}"))
    },
    processOutput = \(vars) {
      #' Processes the output path
      #' Takes an additional list with the following strings:
      #'  - title
      #'  - creation_date
      #'  - timestamp
      #' Returns a list with the header as the name and the path as the value
      c_quarter <- lubridate::quarter(self$input_date)
      output_name <- glue::glue("Quarter {c_quarter}")
      cur_output_dir <- file.path(self$output_dir, "3_Quarterly Notes", lubridate::year(self$input_date))
      if(!dir.exists(cur_output_dir)) {
        # Recursion could be somewhat annoying if you put in the wrong input directory
        dir.create(cur_output_dir, recursive = TRUE)
      }
      c_output <- file.path(
        cur_output_dir,
        glue::glue("{vars$title} Quarterly Note u-{vars$timestamp}.md"))
      out_list <- list()
      out_list[[output_name]] <- c_output
      return(out_list)
    }
  )
)
