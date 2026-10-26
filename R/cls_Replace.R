Matcher <- R6::R6Class(
  #' A class to hold the characters to mark contents
  "Matcher",
  private = list(
    .matchers = list()
  ),
  active = list(
    left = \(value) {
      #' The left boundary
      if(missing(value)) {
        return(private$.matchers[[1]])
      }
      checkmate::assertCharacter(value, min.len = 1, names = "unnamed")
      private$.matchers[[1]] <- value
    },
    right = \(value) {
      #' The right boundary
      if(missing(value)) {
        return(private$.matchers[[2]])
      }
      checkmate::assertCharacter(value, min.len = 1, names = "unnamed")
      private$.matchers[[2]] <- value
    }
  ),
  public = list(
    initialize = \(left = "\\{", right = "\\}") {
      self$left <- left
      self$right <- right
    }
  )
)

ReplaceTerm <- R6::R6Class(
  #' Base class for replacement terms
  "ReplaceTerm",
  inherit = Term,
  private = list(
    .search_term = character(1),
    .matcher = Matcher
  ),
  active = list(
    contents = \(value) {
      #' A DisplayTerm instance
      if(missing(value)) {
        return(private$.contents)
      }
      checkmate::assertClass(value, classes = "DisplayTerm")
      private$.contents <- value
    },
    search_term = \(value) {
      #' The search term
      if(missing(value)) {
        return(private$.search_term)
      }
      checkmate::assertCharacter(value, len = 1)
      private$.search_term <- value
    },
    matcher = \(value) {
      #' The Matcher for the term
      if(missing(value)) {
        return(private$.matcher)
      }
      checkmate::assertClass(value, classes = "Matcher")
      private$.matcher <- value
    }
  ),
  public = list(
    initialize = \(search_term, contents, matcher) {
      super$initialize(contents)
      self$search_term <- search_term
      if(missing(matcher)) {
        self$matcher <- Matcher$new()
      } else {
        self$matcher <- matcher
      }
    },
    makeReplacement = \() {
      #' Makes a replacement string to insert into the MD document
      return(self$contents$makeString())
    },
    makeSearch = \() {
      #' Gets the regex match
      return(paste0(self$matcher$left, self$search_term, self$matcher$right))
    }
  )
)

Replacer <- R6::R6Class(
  #' Base class for replacement terms
  "Replacer",
  private = list(
    .contents = list()
  ),
  active = list(
    contents = \(value) {
      #' A list of ReplaceTerm instances
      if(missing(value)) {
        return(private$.contents)
      }
      checkmate::assertList(value, types = "ReplaceTerm", min.len = 1, names = "unnamed")
      private$.contents <- value
    }
  ),
  public = list(
    initialize = \(contents) {
      # This used to extend the Term, but I don't want it to since it's
      # really a container not a term
      self$contents <- contents
    },
    makeReplacement = \() {
      #' Makes a list of the search term and the replacement string
      out_list <- list()
      for(term_ind in seq_along(self$contents)) {
        out_list[[self$contents[[term_ind]]$makeSearch()]] <-
          self$contents[[term_ind]]$makeReplacement()
      }
      return(out_list)
    }
  )
)
