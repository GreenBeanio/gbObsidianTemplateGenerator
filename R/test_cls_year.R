ObsidianYear <- R6::R6Class(
  #' Class for generating weekly template files
  "ObsidianYear",
  inherit = ObsidianNote,
  public = list(
    initialize = \(output_dir = here::here(),
                   file_name = "Year.md",
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
      quarter_list <- list()
      for(ind in seq_along(child_res)) {
        replacer <- ReplaceTerm$new(search_term = paste0("Quarter ", ind))
        replacer$contents <- DisplayHeader$new(header = replacer$search_term,
                                               link = child_res[[ind]],
                                               level = findHeaderLevels(
                                                 template = vars$template,
                                                 term = replacer$makeSearch()),
                                               trailing_mode = FALSE)
        quarter_list[[ind]] <- replacer
        vars$template <- removeHeaderLever(template = vars$template,
                                      term = replacer$makeSearch())
      }
      replacer <- Replacer$new(c(vars$obsidian_replacer, quarter_list))
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
      # Run the quarterly results to get the needed links
      c_year <- lubridate::year(self$input_date)
      quarter_dates <- c(
        lubridate::make_date(c_year, 1, 1),
        lubridate::make_date(c_year, 4, 1),
        lubridate::make_date(c_year, 7, 1),
        lubridate::make_date(c_year, 10, 1))
      quarters <- purrr::map(quarter_dates,
                             \(x) ObsidianQuarter$new(
                               input_date = x,
                               output_dir = self$output_dir,
                               author = self$author,
                               template_dir = self$template_dir,
                               header_func = self$header_func,
                               unique_timestamp = self$unique_timestamp)$process()) |>
        purrr::flatten() |>
        self$header_func()
      return(quarters)
    },
    processTitle = \() {
      #' Processes the title
      #' Returns a string
      return(as.character(lubridate::year(self$input_date)))
    },
    processOutput = \(vars) {
      #' Processes the output path
      #' Takes an additional list with the following strings:
      #'  - title
      #'  - creation_date
      #'  - timestamp
      #' Returns a list with the header as the name and the path as the value
      cur_output_dir <- file.path(self$output_dir, "4_Yearly Notes")
      if(!dir.exists(cur_output_dir)) {
        # Recursion could be somewhat annoying if you put in the wrong input directory
        dir.create(cur_output_dir, recursive = TRUE)
      }
      c_output <- file.path(
        cur_output_dir,
        glue::glue("{vars$title} Yearly Note u-{vars$timestamp}.md"))
      out_list <- list()
      out_list[[vars$title]] <- c_output
      return(out_list)
    }
  )
)
