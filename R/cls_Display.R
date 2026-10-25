DisplayTerm <- R6::R6Class(
  #' Base class for display terms
  "DisplayTerm",
  inherit = Term,
  private = list(
    .new_lines = integer()
  ),
  active = list(
    new_lines = \(value) {
      #' The number of new lines to use when joining text
      if(missing(value)) {
        return(private$.new_lines)
      }
      checkmate::assertNumeric(value, len = 1, lower = 0, names = "unnamed")
      private$.new_lines <- as.integer(value)
    }
  ),
  public = list(
    initialize = \(contents, new_lines) {
      super$initialize(contents)
      self$new_lines <- new_lines
    },
    makeString = \() {
      #' Makes a string
      stop("Inherited DisplayTerm must implement makeString")
    },
    newLines = \() {
      return(paste(rep("\n", self$new_lines), collapse = ""))
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
      return(paste(self$contents, collapse = newLines(self$new_lines)))
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
      super$initialize(list(), 0)
    },
    makeString = \() {
      #' Generates the string to insert
      return("")
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
          paste0(cur, self$newLines(self$new_lines))
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
    .link = character(),
    .trailing_mode = character()
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
    },
    trailing_mode = \(value) {
      #' How to handle trailing
      if(missing(value)) {
        return(private$.trailing_mode)
      }
      value <- tolower(value)
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      checkmate::assertSubset(value, choices = c("auto", "trail",
                                                          "none"))
      private$.trailing_mode <- value
    }
  ),
  public = list(
    initialize = \(contents, header, header_level, link = "",
                   trailing_mode = "auto", new_lines = 2) {
      super$initialize(contents, new_lines)
      self$header <- header
      self$header_level <- header_level
      self$link <- link
      self$trailing_mode <- trailing_mode
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
      if(self$trailing_mode == "trail" ||
         (self$trailing_mode == "auto" && contents != "")) {
        header <-
          paste0(header, self$newLines(), contents)
      }
      return(header)
    }
  )
)
