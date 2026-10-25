TermMatcher <- R6::R6Class(
  #' A class to hold the characters to mark contents
  "TermMatcher",
  private = list(
    .matchers = list()
  ),
  public = list(
    initialize = \(left = "{", right = "}") {
      checkmate::assertCharacter(left, min.len = 1, names = "unnamed")
      checkmate::assertCharacter(right, min.len = 1, names = "unnamed")
      private$.matchers <- list(left, right)
    },
    left = \() {
      # Gets the left boundary
      return(private$.matchers[[1]])
    },
    right = \() {
      # Gets the right boundary
      return(private$.matchers[[2]])
    }#,
    # getMatcher = \() {
    #   return(c(private$.matchers[[1]], private$.matchers[[2]]))
    # }
  )
)

Terms <- R6::R6Class(
  #' A class to hold multiple Term instances
  "Terms",
  private = list(
    .terms = list(),
    .matcher = TermMatcher
  ),
  public = list(
    initialize = \(matcher) {
      if(missing(matcher)) {
        matcher <- TermMatcher$new()
      }
      private$.matcher <- matcher
    },
    addTerm = \(term) {
      #' Adds a Term to the class
      #' This will NOT overwrite an existing term
      checkmate::assertClass(term, "Term")
      c_name <- names(term$getTerm())
      if(!is.null(names(private$.terms)) && c_name %in% names(private$.terms)) {
        warning(glue::glue("{c_name} already in terms"))
        return(invisible(self))
      }
      private$.terms[[c_name]] <- term
      return(invisible(self))
    },
    removeTerm = \(term) {
      #' Removes a Term from the class
      #' This does NOT check if the Term is in the class
      checkmate::assertClass(term, "Term")
      c_name <- names(term$getTerm())
      private$.terms[[c_name]] <- NULL
      return(invisible(self))
    },
    modifyTerm = \(term) {
      #' Modifies an existing Term in the class
      #' This will add the Term if it doesn't exist
      checkmate::assertClass(term, "Term")
      c_name <- names(term$getTerm())
      private$.terms[[c_name]] <- term
      return(invisible(self))
    },
    termsList = \() {
      #' Combined Term object contents as a list
      cur <- list()
      for(term in private$.terms) {
        cur <- append(cur, term$getTerm())
      }
      return(cur)
    },
    getTerms = \() {
      #' Gets the term objects
      return(private$.terms)
    },
    getMatcher = \() {
      #' Gets the matcher
      return(private$.matcher)
    }
  )
)

author <- ReplaceTermString$new("author", c("Monday.md",
                                     "Tuesday.md",
                                     "Wednesday.md"))
days <- ReplaceTermHeader$new("days",
                       list("Monday" = "x",
                            "Tuesday" = "y",
                            "Wednesday" = "z"),
                       2)
# days$generateReplacement()
y <- Terms$new()
y$addTerm(author)
y$addTerm(days)
y$termsList()
y$getTerms()
y$getMatcher()

#readr::read_file(here::here("inst", "extdata", "Week.md"))
