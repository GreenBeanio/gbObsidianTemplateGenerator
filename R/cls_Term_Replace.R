#' Matcher
#' A class to hold the characters to mark contents
#' @importFrom checkmate assertCharacter
#' @export
Matcher <- R6::R6Class(
  "Matcher",
  private = list(
    .matchers = list()
  ),
  active = list(
    #' @field left The Characters to indicate the left boundary of the search term
    left = \(value) {
      if(missing(value)) {
        return(private$.matchers[[1]])
      }
      checkmate::assertCharacter(value, min.len = 0, names = "unnamed")
      private$.matchers[[1]] <- value
    },
    #' @field right The Characters to indicate the right boundary of the search term
    right = \(value) {
      if(missing(value)) {
        return(private$.matchers[[2]])
      }
      checkmate::assertCharacter(value, min.len = 0, names = "unnamed")
      private$.matchers[[2]] <- value
    }
  ),
  public = list(
    #' @description Initialize a new `Matcher` object
    #' @param left The characters to indicate the left boundary of the search term
    #' @param right The Characters to indicate the right boundary of the search term
    #' @return A new `Matcher` object
    initialize = \(left = "\\{", right = "\\}") {
      self$left <- left
      self$right <- right
    }
  )
)

#' ReplaceTerm
#' Base class for replacement terms
#' @importFrom checkmate assertClass assertCharacter
#' @export
ReplaceTerm <- R6::R6Class(
  "ReplaceTerm",
  inherit = Term,
  private = list(
    .search_term = character(1),
    .matcher = Matcher
  ),
  active = list(
    #' @field  contents A `DisplayTerm` instance
    contents = \(value) {
      if(missing(value)) {
        return(private$.contents)
      }
      checkmate::assertClass(value, classes = "DisplayTerm")
      private$.contents <- value
    },
    #' @field search_term The search term
    search_term = \(value) {
      if(missing(value)) {
        return(private$.search_term)
      }
      checkmate::assertCharacter(value, len = 1)
      private$.search_term <- value
    },
    #' @field matcher The `Matcher` for the term
    matcher = \(value) {
      if(missing(value)) {
        return(private$.matcher)
      }
      checkmate::assertClass(value, classes = "Matcher")
      private$.matcher <- value
    }
  ),
  public = list(
    #' @description Initialize a new `ReplaceTerm` object
    #' @param search_term The search term
    #' @param contents A `DisplayTerm` instance
    #' @param matcher The `Matcher` for the term
    #' @return A new `ReplaceTerm` object
    initialize = \(search_term, contents, matcher) {
      if(missing(contents)) {
        contents <- DisplayNone$new()
      }
      super$initialize(contents)
      self$search_term <- search_term
      if(missing(matcher)) {
        self$matcher <- Matcher$new()
      } else {
        self$matcher <- matcher
      }
    },
    #' @description Makes a replacement string to insert into the MD document
    #' @returns The text to replace matches with
    makeReplacement = \() {
      return(self$contents$makeText())
    },
    #' @description Makes a replacement string to insert into the MD document
    #' @returns The regex match to search for
    makeSearch = \() {
      return(paste0(self$matcher$left, self$search_term, self$matcher$right))
    }
  )
)

#' Replacer
#' The main Replacer class
#' @importFrom checkmate assertList
#' @export
Replacer <- R6::R6Class(
  "Replacer",
  private = list(
    .contents = list()
  ),
  active = list(
    #' @field contents A list of `ReplaceTerm` instances
    contents = \(value) {
      if(missing(value)) {
        return(private$.contents)
      }
      if(!is.list(value)) {
        value <- list(value)
      }
      checkmate::assertList(value, types = "ReplaceTerm",
                            min.len = 0, names = "unnamed")
      private$.contents <- value
    }
  ),
  public = list(
    #' @description Initialize a new `Replacer` object
    #' @param description contents A `ReplaceTerm` or a list of `ReplaceTerm` instances
    #' @returns A new `Replacer` object
    initialize = \(contents) {
      if(missing(contents)) {
        contents <- list()
      }
      self$contents <- contents
    },
    #' @description Adds a replacement terms to the contents
    #' @param terms A `ReplaceTerm` or a list of `ReplaceTerm` instances
    addTerms = \(terms) {
      checkmate::assertList(terms, types = "ReplaceTerm",
                            min.len = 1, names = "unnamed")
      # Not checking for duplicate terms or anything right now
      private$.contents <- c(private$.contents, terms)
      return(invisible(self))
    },
    #' @description Makes a list of the search term and the replacement string
    #' @returns A list of search_term-replacement
    makeReplacement = \() {
      out_list <- list()
      for(term_ind in seq_along(self$contents)) {
        out_list[[self$contents[[term_ind]]$makeSearch()]] <-
          self$contents[[term_ind]]$makeReplacement()
      }
      return(out_list)
    }
  )
)
