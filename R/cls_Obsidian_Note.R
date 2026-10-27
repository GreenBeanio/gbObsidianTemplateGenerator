#' ObsidianNote
#' Base class for `ObsidianNote` classes
#' @importFrom checkmate assertCharacter assertDirectoryExists assertFileExists
#'  assertDate assertFunction assertPOSIXct
#' @importFrom lubridate Date tz
#' @importFrom here here
#' @importFrom readr read_file
#' @export
ObsidianNote <- R6::R6Class(
  "ObsidianNote",
  private = list(
    .output_dir = here::here(),
    .input_date = lubridate::Date(),
    .author = character(),
    .template_dir = character(),
    .header_func = NULL,
    .unique_timestamp = NULL,
    .file_name = character()
  ),
  active = list(
    #' @field output_dir The template directory
    output_dir = \(value) {
      if(missing(value)) {
        return(private$.output_dir)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 1, names = "unnamed")
      checkmate::assertDirectoryExists(value)
      private$.output_dir <- value
    },
    #' @field file_name The template file name
    file_name = \(value) {
      if(missing(value)) {
        return(private$.file_name)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 1, names = "unnamed")
      checkmate::assertFileExists(file.path(self$template_dir, value))
      private$.file_name <- value
    },
    #' @field input_date The input date
    input_date = \(value) {
      if(missing(value)) {
        return(private$.input_date)
      }
      checkmate::assertDate(value, len = 1)
      private$.input_date <- value
    },
    #' @field author The author
    author = \(value) {
      if(missing(value)) {
        return(private$.author)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 0, names = "unnamed")
      private$.author <- value
    },
    #' @field template_dir The template directory
    template_dir = \(value) {
      if(missing(value)) {
        return(private$.template_dir)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 1, names = "unnamed")
      checkmate::assertDirectoryExists(value)
      private$.template_dir <- value
    },
    #' @field header_func The header function
    header_func = \(value) {
      if(missing(value)) {
        return(private$.header_func)
      }
      checkmate::assertFunction(value)
      private$.header_func <- value
    },
    #' @field unique_timestamp The unique time stamp
    unique_timestamp = \(value) {
      if(missing(value)) {
        return(private$.unique_timestamp)
      }
      checkmate::assertPOSIXct(value, len = 1)
      private$.unique_timestamp <- value
    }
  ),
  public = list(
    #' @description Initialize a new ObsidianNote object
    #' @param file_name The file name of the template
    #' @param output_dir The directory to export to
    #' @param input_date The date of the file
    #' @param author The author name
    #' @param template_dir The directory with the templates
    #' @param header_func The function to process header links (takes a list of name-link)
    #' @param unique_timestamp A unique time to uniquely name files
    #' @return A new `ObsidianNote` object
    initialize = \(file_name,
                   output_dir = here::here(),
                   input_date = Sys.Date(),
                   author = Sys.info()[["user"]],
                   template_dir = system.file(
                     "extdata", "Templates",
                     package = "gbObsidianTemplateGenerator"),
                   header_func = makeObsidianFilePath,
                   unique_timestamp = Sys.time()) {
      self$output_dir <- output_dir
      self$input_date <- input_date
      self$author <- author
      self$template_dir <- template_dir
      self$header_func <-header_func
      self$unique_timestamp <- unique_timestamp
      self$file_name <- file_name
    },
    #' @description The main process method to call
    #' Exports needed templates
    #' @returns A list of the header name and the corresponding file path
    process = \() {
      vars <- self$processVariables()
      child_res <- self$processChild()
      if(file.exists(vars$output[[1]])) {
        # Skip if it exists to not accidentally overwrite previous modifications
        output_list <- list()
        output_list[[names(vars$output)[1]]] <- vars$output[[1]]
        return(output_list)
      }
      res <- self$processSelf(vars = vars,
                              child_res = child_res)
      return(res)
    },
    #' @description Processes variables used in other functions
    #' @returns A list with the following strings:
    #' - title: title for document
    #' - creation_date: date of the template
    #' - timestamp: unique timestamp
    #' - output: output file path
    #' - template: The loaded template
    #' - obsidian_replacer: The replacer for obsdiain metadata
    processVariables = \() {
      c_tz <- lubridate::tz(self$unique_timestamp)
      title <- self$processTitle()
      creation_date <- strftime(self$unique_timestamp, "%Y-%m-%d", tz = c_tz)
      timestamp <- strftime(self$unique_timestamp, "%Y%m%d%H%M%S", tz = c_tz)
      out_list <- list(title = title,
                       creation_date = creation_date,
                       timestamp = timestamp)
      out_list[["output"]] <- self$processOutput(out_list)
      out_list[["template"]] <- self$getTemplate()
      out_list[["obsidian_replacer"]] <- obsidianMetadataReplace(
        title = title,
        creation_date = creation_date,
        unique_timestamp = timestamp,
        author = self$author)
      return(out_list)
    },
    #' @description Processes the template for the current object level
    #' @param vars A list of strings for title, creation_date, timestamp, output, and template
    #' @param child_res Takes a list of child headers and file paths
    #' @returns A list of the header name and the corresponding file path
    #' Exports needed templates
    processSelf = \(vars, child_res) {
      stop("Inherited ObsidianNote class must implement processChildren")
    },
    #' @description Processes the child template object
    #' @returns A list of the header name and the corresponding file paths from the child
    #' Runs child class
    processChild = \() {
      stop("Inherited ObsidianNote class must implement processChildren")
    },
    #' @description Processes the title
    #' @returns The title as a character
    processTitle = \() {
      stop("Inherited ObsidianNote class must implement processTitle")
    },
    #' @description Processes the output location
    #' @param vars A list of strings for title, creation_date, timestamp
    #' @returns The output path as a character
    processOutput = \(vars) {
      stop("Inherited ObsidianNote class must implement processOutput")
    },
    #' @description Loads the template file
    #' @returns The template as a character
    getTemplate = \() {
      return(readr::read_file(file.path(self$template_dir, self$file_name)))
    }
  )
)
