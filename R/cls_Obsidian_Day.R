#' ObsidianDay
#' Class for generating daily template files
#' @importFrom here here
#' @importFrom lubridate tz month year wday
#' @importFrom stringr str_pad
#' @importFrom readr write_file
#' @importFrom glue glue
#' @export
ObsidianDay <- R6::R6Class(
  "ObsidianDay",
  inherit = ObsidianNote,
  public = list(
    #' @description Initialize a new `ObsidianDay` object
    #' @param file_name The file name of the template
    #' @param output_dir The directory to export to
    #' @param input_date The date of the file
    #' @param author The author name
    #' @param template_dir The directory with the templates
    #' @param header_func The function to process header links (takes a list of name-link)
    #' @param unique_timestamp A unique time to uniquely name files
    #' @return A new `ObsidianDay` object
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
    #' @description Processes the template for the current object level
    #' @param vars A list of strings for title, creation_date, timestamp, output, and template
    #' @param child_res Takes a list of child headers and file paths
    #' @returns A list of the header name and the corresponding file path
    #' Exports needed templates
    processSelf = \(vars, child_res) {
      template <- Templater$new(
        replacer = Replacer$new(vars$obsidian_replacer),
        template = vars$template)$process()
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
      return(list())
    },
    #' @description Processes the title
    #' @returns The title as a character
    processTitle = \() {
      c_tz <- lubridate::tz(self$unique_timestamp)
      return(strftime(self$input_date, "%Y_%m_%d", tz = c_tz))
    },
    #' @description Processes the output location
    #' @param vars A list of strings for title, creation_date, timestamp
    #' @returns The output path as a character
    processOutput = \(vars) {
      output_name <- as.character(lubridate::wday(self$input_date, label = TRUE,
                                                  abbr = FALSE, week_start = 1))
      cur_output_dir <- file.path(
        self$output_dir, "0_Daily Notes", lubridate::year(self$input_date),
        lubridate::month(self$input_date) |> stringr::str_pad(2, 'left', '0'))
      if(!dir.exists(cur_output_dir)) {
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
