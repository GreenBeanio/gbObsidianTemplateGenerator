DisplayTerm <- R6::R6Class(
  #' Base class for display terms
  "DisplayTerm",
  inherit = Term,
  private = list(
    .separators = integer(),
    .trailing_mode = logical(),
    .separator = character()
  ),
  active = list(
    separators = \(value) {
      #' The number of separators to use when joining text
      if(missing(value)) {
        return(private$.separators)
      }
      checkmate::assertNumeric(value, len = 1, lower = 0, names = "unnamed")
      private$.separators <- as.integer(value)
    },
    trailing_mode = \(value) {
      #' How to handle trailing
      if(missing(value)) {
        return(private$.trailing_mode)
      }
      checkmate::assertLogical(value, len = 1, names = "unnamed")
      private$.trailing_mode <- value
    },
    separator = \(value) {
      #' Separator character
      if(missing(value)) {
        return(private$.separator)
      }
      checkmate::assertCharacter(value, min.len = 0,
                                 max.len = 1, names = "unnamed")
      private$.separator <- value
    }
  ),
  public = list(
    initialize = \(contents, separators = 2,
                   trailing_mode = TRUE, separator = "\n") {
      super$initialize(contents)
      self$separators <- separators
      self$trailing_mode <- trailing_mode
      self$separator <- separator
    },
    makeString = \() {
      #' Makes a string
      stop("Inherited DisplayTerm must implement makeString")
    },
    getSeparators = \() {
      #' Gets the string of new lines to use
      return(paste(rep(self$separator, self$separators), collapse = ""))
    },
    trailing = \(content) {
      #' Gets the content after trailing logic
      if(private$.trailing_mode) {
        return(paste0(content, self$getSeparators()))
      }
      return(content)
    },
    addTerms = \(terms) {
      #' Adds a terms terms to the contents
      stop("Inherited DisplayTerm class must implement addTerms")
    }
  )
)

DisplayString <- R6::R6Class(
  #' A class to hold string contents
  "DisplayString",
  inherit = DisplayTerm,
  active = list(
    contents = \(value) {
      #' A vector of replacement strings
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
    makeString = \() {
      #' Generates the string to insert
      body <- paste(self$contents, collapse = self$getSeparators())
      return(self$trailing(body))
    },
    addTerms = \(terms) {
      #' Adds a terms terms to the contents
      if(!is.vector(terms)) {
        terms <- c(terms)
      }
      checkmate::assertVector(value, min.len = 1, names = "unnamed")
      self$contents <- c(private$.contents, terms)
      return(invisible(self))
    }
  )
)

DisplayNone <- R6::R6Class(
  #' A class to display nothing
  "DisplayNone",
  inherit = DisplayTerm,
  active = list(
    contents = \(value) {
      #' Nothing!
      private$.contents <- ""
    }
  ),
  public = list(
    initialize = \() {
      super$initialize(contents = NULL,
                       separators = 0,
                       trailing_mode = FALSE,
                       separator = "")
    },
    makeString = \() {
      #' Generates the string to insert
      return(self$trailing(self$contents))
    },
    addTerms = \(terms) {
      #Nothing!
      return(invisible(self))
    }
  )
)

DisplayTerms <- R6::R6Class(
  #' Base class for displaying other DisplayTerms
  "DisplayTerms",
  inherit = DisplayTerm,
  active = list(
    contents = \(value) {
      #' A vector of replacement DisplayTerm classes
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
    makeString = \() {
      #' Makes a string
      out_list <- c()
      for(cur_ind in seq_along(self$contents)) {
        cur <- self$contents[[cur_ind]]$makeString()
        if(cur_ind != length(self$contents)) {
          paste0(cur, self$getSeparators())
        }
        out_list[cur_ind] <- cur
      }
      return(self$trailing(paste(out_list, collapse = "")))
    },
    addTerms = \(terms) {
      #' Adds a terms terms to the contents
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

DisplayHeader <- R6::R6Class(
  #' A class to hold replacement contents
  "DisplayHeader",
  inherit = DisplayTerms,
  private = list(
    .header = character(),
    .level = integer(1),
    .link = character()
  ),
  active = list(
    header = \(value) {
      #' The header value
      if(missing(value)) {
        return(private$.header)
      }
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      private$.header <- value
    },
    level = \(value) {
      #' An integer for the base level of the replacement header
      if(missing(value)) {
        return(private$.level)
      }
      checkmate::assertNumeric(value, len = 1, names = "unnamed",
                               lower = 1, upper = 6)
      private$.level <- as.integer(value)
    },
    link = \(value) {
      #' A link for the header
      if(missing(value)) {
        return(private$.link)
      }
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      private$.link <- value #|> htmltools::urlEncodePath()
    }
  ),
  public = list(
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
    makeString = \() {
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
      contents <- super$makeString()
      if(contents != "") {
        header <-
          paste0(header, self$getSeparators(), contents)
      }
      return(header)
    }
  )
)
