#' ObsidianQuarter
#' Class for generating quarterly template files
#' @importFrom here here
#' @importFrom lubridate make_date year month floor_date quarter
#' @importFrom readr write_file
#' @importFrom glue glue
#' @export
ObsidianQuarter <- R6::R6Class(
  "ObsidianQuarter",
  inherit = ObsidianNote,
  public = list(
    #' @description Initialize a new `ObsidianQuarter` object
    #' @param file_name The file name of the template
    #' @param output_dir The directory to export to
    #' @param input_date The date of the file
    #' @param author The author name
    #' @param template_dir The directory with the templates
    #' @param header_func The function to process header links (takes a list of name-link)
    #' @param unique_timestamp A unique time to uniquely name files
    #' @return A new `ObsidianQuarter` object
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
    #' @description Processes the template for the current object level
    #' @param vars A list of strings for title, creation_date, timestamp, output, and template
    #' @param child_res Takes a list of child headers and file paths
    #' @returns A list of the header name and the corresponding file path
    #' Exports needed templates
    processSelf = \(vars, child_res) {
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
      replacer <- Replacer$new(c(vars$obsidian_replacer, month_list))
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
    #' @description Processes the title
    #' @returns The title as a character
    processTitle = \() {
      c_quarter <- lubridate::quarter(self$input_date)
      c_year <- lubridate::year(self$input_date)
      return(glue::glue("{c_year}_{c_quarter}"))
    },
    #' @description Processes the output location
    #' @param vars A list of strings for title, creation_date, timestamp
    #' @returns The output path as a character
    processOutput = \(vars) {
      c_quarter <- lubridate::quarter(self$input_date)
      output_name <- glue::glue("Quarter {c_quarter}")
      cur_output_dir <- file.path(self$output_dir, "3_Quarterly Notes", lubridate::year(self$input_date))
      if(!dir.exists(cur_output_dir)) {
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
