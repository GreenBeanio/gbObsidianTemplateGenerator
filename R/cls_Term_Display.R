#' DisplayTerm
#' Base class for `DisplayTerm` classes
#' @importFrom checkmate assertNumeric assertLogical assertCharacter assertVector
#' @export
DisplayTerm <- R6::R6Class(
  "DisplayTerm",
  inherit = Term,
  private = list(
    .separators = integer(),
    .trailing_mode = logical(),
    .separator = character()
  ),
  active = list(
    #' @field separators The number of separators to use when joining the contents
    separators = \(value) {
      if(missing(value)) {
        return(private$.separators)
      }
      checkmate::assertNumeric(value, len = 1, lower = 0, names = "unnamed")
      private$.separators <- as.integer(value)
    },
    #' @field trailing_mode If the item should be followed by the separators
    trailing_mode = \(value) {
      if(missing(value)) {
        return(private$.trailing_mode)
      }
      checkmate::assertLogical(value, len = 1, names = "unnamed")
      private$.trailing_mode <- value
    },
    #' @field separator The separating characters (typically `\\n`)
    separator = \(value) {
      if(missing(value)) {
        return(private$.separator)
      }
      checkmate::assertCharacter(value, min.len = 0,
                                 max.len = 1, names = "unnamed")
      private$.separator <- value
    }
  ),
  public = list(
    #' Initialize a new `DisplayTerm` object
    #' @param contents The contents of the `DisplayTerm`
    #' @param separators How many separators to use between the contents
    #' @param trailing_mode If the contents should be trailed by the separtors
    #' @param separator The separating characters (typically `\\n`)
    #' @return A new `DisplayTerm` object
    initialize = \(contents, separators = 2,
                   trailing_mode = TRUE, separator = "\n") {
      super$initialize(contents)
      self$separators <- separators
      self$trailing_mode <- trailing_mode
      self$separator <- separator
    },
    #' @description Makes a string from the contents
    makeText = \() {
      stop("Inherited DisplayTerm must implement makeText")
    },
    #' @description Gets the separator to use
    #' @returns The separator characters
    getSeparators = \() {
      return(paste(rep(self$separator, self$separators), collapse = ""))
    },
    #' @description Applies the trailing to the string
    #' @param content A list or vector of characters
    #' @returns The processed text
    trailing = \(content) {
      if(private$.trailing_mode) {
        return(paste0(content, self$getSeparators()))
      }
      return(content)
    },
    #' @description Adds more terms to the contents
    #' @param terms Item to add to the contents
    addTerms = \(terms) {
      stop("Inherited DisplayTerm class must implement addTerms")
    }
  )
)

#' DisplayString
#' A class for displaying strings
#' @importFrom checkmate assertCharacter assertVector
#' @export
DisplayString <- R6::R6Class(
  "DisplayString",
  inherit = DisplayTerm,
  active = list(
    #' @field contents A vector of replacement strings
    contents = \(value) {
      if(missing(value)) {
        return(private$.contents)
      }
      if(!is.vector(value)) {
        value <- c(value)
      }
      checkmate::assertVector(value, min.len = 0, names = "unnamed")
      checkmate::assertCharacter(value)
      private$.contents <- value
    }
  ),
  public = list(
    #' @description Initialize a new `DisplayString` object
    #' @param contents The contents of the `DisplayString`
    #' @param separators How many separators to use between the contents
    #' @param trailing_mode If the contents should be trailed by the separtors
    #' @param separator The separating characters (typically `\\n`)
    #' @return A new `DisplayString` object
    initialize = \(contents, separators = 0,
                   trailing_mode = FALSE, separator = "\n") {
      if(missing(contents)) {
        contents <- character()
      }
      super$initialize(contents = contents,
                       separators = separators,
                       trailing_mode = trailing_mode,
                       separator = separator)
    },
    #' @description Generates the string to insert
    #' @returns The display text
    makeText = \() {
      body <- paste(self$contents, collapse = self$getSeparators())
      return(self$trailing(body))
    },
    #' @description Adds a terms terms to the contents
    #' @param terms A character or a vector of character objects
    addTerms = \(terms) {
      #' Adds a terms terms to the contents
      if(!is.vector(terms)) {
        terms <- c(terms)
      }
      checkmate::assertVector(value, min.len = 1, names = "unnamed")
      checkmate::assertCharacter(value)
      self$contents <- c(private$.contents, terms)
      return(invisible(self))
    }
  )
)

#' DisplayNone
#' A class for displaying nothing
#' @export
DisplayNone <- R6::R6Class(
  "DisplayNone",
  inherit = DisplayTerm,
  active = list(
    #' @field contents An empty character
    contents = \(value) {
      private$.contents <- ""
    }
  ),
  public = list(
    #' @description Initialize a new `DisplayNone` object
    #' @return A new `DisplayNone` object
    initialize = \() {
      super$initialize(contents = NULL,
                       separators = 0,
                       trailing_mode = FALSE,
                       separator = "")
    },
    #' @description Generates the string to insert
    #' @returns The display text
    makeText = \() {
      return(self$trailing(self$contents))
    },
    #' @description Adds **NOTHING**
    #' @param terms A `DisplayTerm` or a list of `DisplayTerm` objects
    addTerms = \(terms) {
      #Nothing!
      return(invisible(self))
    }
  )
)

#' DisplayTerms
#' A class for holding multiple `DisplayTerm` objects
#' @importFrom checkmate assertList
#' @export
DisplayTerms <- R6::R6Class(
  "DisplayTerms",
  inherit = DisplayTerm,
  active = list(
    #' @field contents A vector of replacement `DisplayTerm` classes
    contents = \(value) {
      if(missing(value)) {
        return(private$.contents)
      }
      if(!is.list(value)) {
        value <- list(value)
      }
      checkmate::assertList(value, types = "DisplayTerm",
                            min.len = 0, names = "unnamed")
      private$.contents <- value
    }
  ),
  public = list(
    #' @description Initialize a new `DisplayTerms` object
    #' @param contents The contents of the `DisplayTerms`
    #' @param separators How many separators to use between the contents
    #' @param trailing_mode If the contents should be trailed by the separtors
    #' @param separator The separating characters (typically `\\n`)
    #' @return A new `DisplayTerms` object
    initialize = \(contents, separators = 2,
                   trailing_mode = TRUE, separator = "\n") {
      if(missing(contents)) {
        contents <- list()
      }
      super$initialize(contents = contents,
                       separators = separators,
                       trailing_mode = trailing_mode,
                       separator = separator)
    },
    #' @description Generates the string to insert
    #' @returns The display text
    makeText = \() {
      out_list <- c()
      for(cur_ind in seq_along(self$contents)) {
        cur <- self$contents[[cur_ind]]$makeText()
        if(cur_ind != length(self$contents)) {
          paste0(cur, self$getSeparators())
        }
        out_list[cur_ind] <- cur
      }
      return(self$trailing(paste(out_list, collapse = "")))
    },
    #' @description Adds a terms terms to the contents
    #' @param terms A `DisplayTerm` or a list of `DisplayTerm` objects
    addTerms = \(terms) {
      if(!is.list(terms)) {
        terms <- list(terms)
      }
      checkmate::assertList(terms, types = "DisplayTerm",
                            min.len = 1, names = "unnamed")
      self$contents <- c(private$.contents, terms)
      return(invisible(self))
    }
  )
)

#' DisplayHeader
#' A class for holding other `DisplayTerm` objects to create headers
#' @importFrom checkmate assertCharacter assertNumeric
#' @importFrom glue glue
#' @export
DisplayHeader <- R6::R6Class(
  "DisplayHeader",
  inherit = DisplayTerms,
  private = list(
    .header = character(),
    .level = integer(1),
    .link = character()
  ),
  active = list(
    #' @field header The header value
    header = \(value) {
      if(missing(value)) {
        return(private$.header)
      }
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      private$.header <- value
    },
    #' @field level An integer for the base level of the replacement header
    level = \(value) {
      if(missing(value)) {
        return(private$.level)
      }
      checkmate::assertNumeric(value, len = 1, names = "unnamed",
                               lower = 1, upper = 6)
      private$.level <- as.integer(value)
    },
    #' @field link A link for the header
    link = \(value) {
      if(missing(value)) {
        return(private$.link)
      }
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      private$.link <- value #|> htmltools::urlEncodePath()
    }
  ),
  public = list(
    #' @description Initialize a new `DisplayHeader` object
    #' @param header The name for the header
    #' @param level The level of the header
    #' @param contents The contents of the `DisplayHeader`
    #' @param link The link for the header, if there is one
    #' @param separators How many separators to use between the contents
    #' @param trailing_mode If the contents should be trailed by the separtors
    #' @param separator The separating characters (typically `\\n`)
    #' @return A new `DisplayHeader` object
    initialize = \(header, level, contents, link = "",
                   trailing_mode = TRUE, separators = 2,
                   separator = "\n") {
      if(missing(contents)) {
        contents <- list()
      }
      super$initialize(contents = contents,
                       separators = separators,
                       trailing_mode = trailing_mode,
                       separator = separator)
      self$header <- header
      self$level <- level
      self$link <- link
    },
    #' @description Generates the string to insert
    #' @returns The display text
    makeText = \() {
      if(self$link != "") {
        header <- glue::glue("[{self$header}]({self$link})")
      } else {
        header <- self$header
      }
      header <-
        paste0(
          paste(rep('#',self$level), collapse = ""), " ", header)
      if(length(self$contents) == 0) {
        return(self$trailing(header))
      }
      contents <- super$makeText()
      if(contents != "") {
        header <-
          paste0(header, self$getSeparators(), contents)
      }
      return(header)
    }
  )
)
