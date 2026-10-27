ObsidianDay <- R6::R6Class(
  #' Class for generating daily template files
  "ObsidianDay",
  inherit = ObsidianNote,
  public = list(
    initialize = \(output_dir = here::here(),
                   file_name = "Day.md",
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
      template <- Templater$new(
        replacer = Replacer$new(vars$obsidian_replacer),
        template = vars$template)$process()
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
      return(list())
    },
    processTitle = \() {
      #' Processes the title
      #' Returns a string
      c_tz <- lubridate::tz(self$unique_timestamp)
      return(strftime(self$input_date, "%Y_%m_%d", tz = c_tz))
    },
    processOutput = \(vars) {
      #' Processes the output path
      #' Takes an additional list with the following strings:
      #'  - title
      #'  - creation_date
      #'  - timestamp
      #' Returns a list with the header as the name and the path as the value
      output_name <- as.character(lubridate::wday(self$input_date, label = TRUE,
                                                  abbr = FALSE, week_start = 1))
      cur_output_dir <- file.path(
        self$output_dir, "0_Daily Notes", lubridate::year(self$input_date),
        lubridate::month(self$input_date) |> stringr::str_pad(2, 'left', '0'))
      if(!dir.exists(cur_output_dir)) {
        # Recursion could be somewhat annoying if you put in the wrong input directory
        dir.create(cur_output_dir, recursive = TRUE)
      }
      output_file <- file.path(
        cur_output_dir,
        glue::glue("{vars$title} Daily Note u-{vars$timestamp}.md"))
      out_list <- list()
      out_list[[output_name]] <- output_file
      return(out_list)
    }
  )
)
