#' ObsidianYear
#' Class for generating anually template files
#' @importFrom here here
#' @importFrom lubridate make_date year
#' @importFrom readr write_file
#' @importFrom glue glue
#' @export
ObsidianYear <- R6::R6Class(
  "ObsidianYear",
  inherit = ObsidianNote,
  public = list(
    #' @description Initialize a new `ObsidianYear` object
    #' @param file_name The file name of the template
    #' @param output_dir The directory to export to
    #' @param input_date The date of the file
    #' @param author The author name
    #' @param template_dir The directory with the templates
    #' @param header_func The function to process header links (takes a list of name-link)
    #' @param unique_timestamp A unique time to uniquely name files
    #' @return A new `ObsidianYear` object
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
    #' @description Processes the template for the current object level
    #' @param vars A list of strings for title, creation_date, timestamp, output, and template
    #' @param child_res Takes a list of child headers and file paths
    #' @returns A list of the header name and the corresponding file path
    #' Exports needed templates
    processSelf = \(vars, child_res) {
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
    #' @description Processes the child template object
    #' @returns A list of the header name and the corresponding file paths from the child
    #' Runs child class
    processChild = \() {
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
    #' @description Processes the title
    #' @returns The title as a character
    processTitle = \() {
      return(as.character(lubridate::year(self$input_date)))
    },
    #' @description Processes the output location
    #' @param vars A list of strings for title, creation_date, timestamp
    #' @returns The output path as a character
    processOutput = \(vars) {
      cur_output_dir <- file.path(self$output_dir, "4_Yearly Notes")
      if(!dir.exists(cur_output_dir)) {
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
