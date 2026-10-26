DisplayTerm <- R6::R6Class(
  #' Base class for display terms
  "DisplayTerm",
  inherit = Term,
  private = list(
    .new_lines = integer(),
    .trailing_mode = logical()
  ),
  active = list(
    new_lines = \(value) {
      #' The number of new lines to use when joining text
      if(missing(value)) {
        return(private$.new_lines)
      }
      checkmate::assertNumeric(value, len = 1, lower = 0, names = "unnamed")
      private$.new_lines <- as.integer(value)
    },
    trailing_mode = \(value) {
      #' How to handle trailing
      if(missing(value)) {
        return(private$.trailing_mode)
      }
      checkmate::assertLogical(value, len = 1, names = "unnamed")
      private$.trailing_mode <- value
    }
  ),
  public = list(
    initialize = \(contents, new_lines = 2, trailing_mode = TRUE) {
      super$initialize(contents)
      self$new_lines <- new_lines
      self$trailing_mode <- trailing_mode
    },
    makeString = \() {
      #' Makes a string
      stop("Inherited DisplayTerm must implement makeString")
    },
    newLines = \() {
      #' Gets the string of new lines to use
      return(paste(rep("\n", self$new_lines), collapse = ""))
    },
    trailing = \(content) {
      #' Gets the content after trailing logic
      if(private$.trailing_mode) {
        return(paste0(content, self$newLines()))
      }
      return(content)
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
      checkmate::assertVector(value, min.len = 1, names = "unnamed")
      checkmate::assertCharacter(value)
      private$.contents <- value
    }
  ),
  public = list(
    makeString = \() {
      #' Generates the string to insert
      body <- paste(self$contents, collapse = self$newLines())
      return(self$trailing(body))
    }
  )
)

DisplayNone <- R6::R6Class(
  #' A class to display nothing
  "DisplayNone",
  inherit = DisplayTerm,
  active = list(
    contents = \(value) {
      #' A vector of replacement strings
      if(missing(value)) {
        return(private$.contents)
      }
      private$.contents <- value
    }
  ),
  public = list(
    initialize = \() {
      super$initialize(contents = list(),
                       new_lines = 0,
                       trailing_mode = FALSE)
    },
    makeString = \() {
      #' Generates the string to insert
      return(self$trailing(""))
    }
  )
)

DisplayTerms <- R6::R6Class(
  #' Base class for displaying other DisplayTerms
  "DisplayTerm",
  inherit = DisplayTerm,
  active = list(
    contents = \(value) {
      #' A vector of replacement DisplayTerm classes
      if(missing(value)) {
        return(private$.contents)
      }
      checkmate::assertList(value, types = "DisplayTerm",
                            min.len = 1, names = "unnamed")
      private$.contents <- value
    }
  ),
  public = list(
    makeString = \() {
      #' Makes a string
      out_list <- c()
      for(cur_ind in seq_along(self$contents)) {
        cur <- self$contents[[cur_ind]]$makeString()
        if(cur_ind != length(self$contents)) {
          paste0(cur, self$newLines())
        }
        out_list[cur_ind] <- cur
      }
      return(paste(out_list, collapse = ""))
    }
  )
)

DisplayHeader <- R6::R6Class(
  #' A class to hold replacement contents
  "DisplayHeader",
  inherit = DisplayTerms,
  private = list(
    .header = character(),
    .header_level = integer(1),
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
    header_level = \(value) {
      #' An integer for the base level of the replacement header
      if(missing(value)) {
        return(private$.header_level)
      }
      checkmate::assertNumeric(value, len = 1, names = "unnamed",
                               lower = 1, upper = 6)
      private$.header_level <- as.integer(value)
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
    initialize = \(contents, header, header_level, link = "",
                   trailing_mode = FALSE, new_lines = 2) {
      super$initialize(contents = contents,
                       new_lines = new_lines,
                       trailing_mode = trailing_mode)
      self$header <- header
      self$header_level <- header_level
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
          paste(rep('#',self$header_level), collapse = ""), " ", header)
      contents <- super$makeString()
      if(contents != "") {
        header <-
          paste0(header, self$newLines(), contents)
      }
      header <- self$trailing(header)
      return(header)
    }
  )
)
