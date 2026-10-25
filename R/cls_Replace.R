ReplaceTerm <- R6::R6Class(
  #' Base class for replacement terms
  "ReplaceTerm",
  inherit = Term,
  private = list(
    .search_term = character(1)
  ),
  active = list(
    search_term = \(value) {
      #' The search term
      if(missing(value)) {
        return(private$.search_term)
      }
      checkmate::assertCharacter(value, len = 1)
      private$.search_term <- value
    }
  ),
  public = list(
    initialize = \(contents, search_term) {
      super$initialize(contents)
      self$search_term <- search_term
    },
    makeReplacement = \() {
      #' Makes a replacement string to insert into the MD document
      stop("Inherited ReplaceTerm class must implement makeReplacement")
    },
    getTerm = \() {
      #' Returns the list of contents
      c_list <- list()
      c_list[[self$search_term]] <- self$contents
      return(c_list)
    }
  )
)

ReplaceString <- R6::R6Class(
  #' A class to hold replacement strings
  "ReplaceString",
  inherit = ReplaceTerm,
  active = list(
    contents = \(value) {
      #' A vector of replacement strings
      if(missing(value)) {
        return(private$.contents)
      }
      checkmate::assertList(value, types = "DisplayString", min.len = 1, names = "unnamed")
      private$.contents <- value
    }
  ),
  public = list(
    makeReplacement = \() {
      #' Makes a replacement string to insert into the MD document
      return(private$.contents)
    }
  )
)

ReplaceHeader <- R6::R6Class(
  #' A class to hold replacement headers
  "ReplaceHeader",
  inherit = ReplaceTerm,
  active = list(
    contents = \(value) {
      #' A list of replacement strings
      if(missing(value)) {
        return(private$.contents)
      }
      checkmate::assertList(value, types = "DisplayHeader", min.len = 1, names = "unnamed")
      private$.contents <- value
    }
  ),
  public = list(
    makeReplacement = \() {
      #' Makes a replacement string to insert into the MD document
      return(private$.contents)
    }
  )
)
