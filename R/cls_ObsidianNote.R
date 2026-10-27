ObsidianNote <- R6::R6Class(
  #' Base class for Obsidian Notes
  "ObsidianNote",
  private = list(
    .input_date = lubridate::Date(),
    .author = character(),
    .child = list(),
    .template_dir = character(),
    .header_func = NULL,
    .unique_timestamp = POSIXct(),
    .file_name = character()
  ),
  active = list(
    file_name = \(value) {
      #' The template file name
      if(missing(value)) {
        return(private$.file_name)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 1, names = "unnamed")
      checkmate::assertFileExists(file.path(self$template_dir, value))
      private$.file_name <- value
    },
    child = \(value) {
      #' The child instance
      if(missing(value)) {
        return(private$.child)
      }
      checkmate::assertList(value, len = 0, types = "ObsidianNote", names = "unnamed")
      private$.child <- value
    },
    input_date = \(value) {
      #' The input date
      if(missing(value)) {
        return(private$.input_date)
      }
      checkmate::assertDate(value, len = 1)
      private$.input_date <- value
    },
    author = \(value) {
      #' The author
      if(missing(value)) {
        return(private$.author)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 0, names = "unnamed")
      private$.author <- value
    },
    template_dir = \(value) {
      #' The template directory
      if(missing(value)) {
        return(private$.template_dir)
      }
      checkmate::assertCharacter(value, len = 1, min.chars = 1, names = "unnamed")
      checkmate::assertDirectoryExists(value)
      private$.template_dir <- value
    },
    header_func = \(value) {
      #' The header function
      if(missing(value)) {
        return(private$.header_func)
      }
      checkmate::assertFunction(value)
      private$.header_func <- value
    },
    unique_timestamp = \(value) {
      #' The unique time stamp
      if(missing(value)) {
        return(private$.unique_timestamp)
      }
      checkmate::assertPOSIXct(value, len = 1)
      private$.unique_timestamp <- value
    }
  ),
  public = list(
    initialize = \(file_name,
                   child,
                   input_date = Sys.Date(),
                   author = Sys.info()[["user"]],
                   template_dir = system.file(
                     "extdata", "Templates",
                     package = "gbObsidianTemplateGenerator"),
                   header_func = makeObsidianFilePath,
                   unique_timestamp = Sys.time()) {
      self$input_date <- input_date
      self$author <- author
      self$template_dir <- template_dir
      self$header_func <-header_func
      self$unique_timestamp <- unique_timestamp
      self$file_name <- file_name
      if(missing(child)) {
        child <- list()
      }
      self$child <- child
    },
    process = \() {
      #' The main process method to call
      #' Exports needed templates
      #' Returns a list of the header name and the corresponding file path
      vars <- self$processVariables()
      child_res <- self$processChild()
      res <- self$processSelf(vars = vars,
                              child_res = child_res)
      return(res)
    }
    processVariables = \() {
      #' Returns a list with the following strings:
      #' - titleL title for document
      #' - creation_date: date of the tempalte
      #' - timestamp: unique timestamp
      #' - output: output file path
      c_tz <- lubridate::tz(self$unique_timestamp)
      creation_date <- self$processTitle()
      creation_date <- strftime(self$unique_timestamp, "%Y-%m-%d", tz = c_tz)
      timestamp <- strftime(self$unique_timestamp, "%Y%m%d%H%M%S", tz = c_tz)
      out_list <- list(title = c_title,
                       creation_date = c_creation_date,
                       timestamp = timestamp)
      out_list[["output"]] <- self$processOutput(out_list)
      return(out_list)
    },
    processSelf = \(vars, child_res) {
      #' Process Self
      #' vars: A list of strings for title, creation_date, timestamp, and output
      #' child_res: Takes a list of child headers and file paths
      #' Exports needed templates
      #' Returns a list of the header name and the corresponding file path
      stop("Inherited ObsidianNote class must implement processChildren")
    },
    processChild = \() {
      #' Process Child
      #' Runs child class
      #' Returns a list of the header name and the corresponding file paths from the child
      stop("Inherited ObsidianNote class must implement processChildren")
    },
    processTitle = \() {
      #' Processes the title
      #' Returns a string
      stop("Inherited ObsidianNote class must implement processTitle")
    },
    processOutput = \(vars) {
      #' Processes the output path
      #' Takes an additional list with the following strings:
      #'  - title
      #'  - creation_date
      #'  - timestamp
      #' Returns an output file path
      stop("Inherited ObsidianNote class must implement processOutput")
    }
  )
)
