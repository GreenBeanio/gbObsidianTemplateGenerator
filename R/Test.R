newLines <- \(amount) {
  if(amount < 1) {
    return("")
  }
  return(paste(rep("\n", amount), collapse = ""))
}

Term <- R6::R6Class(
  #' A class to hold a replacement keyword in a MD document
  "Term",
  private = list(
    .search_term = character(1),
    .replacements = list(),
    .new_lines = integer()
  ),
  active = list(
    search_term = \(value) {
      #' The search term
      if(missing(value)) {
       return(private$.search_term)
      }
      checkmate::assertCharacter(value, len = 1)
      private$.search_term <- value
    },
    replacements = \(value) {
      #' The replacements variable (must be overridden by children)
      stop("Inherited Term class must implement replacements")
    },
    new_lines = \(value) {
      #' The number of new lines to use when joining text
      if(missing(value)) {
        return(private$.new_lines)
      }
      checkmate::assertNumeric(value, len = 1)
      private$.new_lines <- as.integer(value)
    }

  ),
  public = list(
    initialize = \(search_term, replacements, new_lines) {
      self$search_term <- search_term
      self$replacements <- replacements
      self$new_lines <- new_lines
    },
    getTerm = \() {
      #' Returns the list of replacements
      c_list <- list()
      c_list[[self$search_term]] <- self$replacements
      return(c_list)
    },
    generateReplacement = \() {
      #' Generates the replacement string to insert
      stop("Inherited Term class must implement replacements")
    }
  )
)

TermString <- R6::R6Class(
  #' A class to hold replacement headers
  "TermString",
  inherit = Term,
  # private = list(
  #   .search_term = character(1),
  #   .replacements = list()
  # ),
  active = list(
    replacements = \(value) {
      #' A vector of replacement strings
      if(missing(value)) {
        return(private$.replacements)
      }
      checkmate::assertVector(value, min.len = 1, names = "unnamed")
      checkmate::assertCharacter(value)
      private$.replacements <- value
    }
  ),
  public = list(
    initialize = \(search_term, replacements, new_lines = 0) {
      super$initialize(search_term, replacements, new_lines)
    },
    generateReplacement = \() {
      #' Generates the replacement string to insert
      return(paste(self$replacements, collapse = newLines(self$new_lines)))
    }
  )
)

TermHeader <- R6::R6Class(
  #' A class to hold replacement headers
  "TermHeader",
  inherit = Term,
  private = list(
    .base_level = integer(1)
  ),
  active = list(
    replacements = \(value) {
      #' A list of replacement strings
      if(missing(value)) {
        return(private$.replacements)
      }
      checkmate::assertList(value, min.len = 1, names = "named")
      private$.replacements <- value
    },
    base_level = \(value) {
      #' An integer for the base level of the replacement header
      if(missing(value)) {
        return(private$.base_level)
      }
      checkmate::assertNumeric(value, len = 1, names = "unnamed")
      private$.base_level <- as.integer(value)
    }
  ),
  public = list(
    initialize = \(search_term, replacements, base_level, new_lines = 2) {
      super$initialize(search_term, replacements, new_lines)
      self$base_level <- base_level
    },
    generateReplacement = \() {
      #' Generates the replacement string to insert
      out <- c()
      clp <- newLines(self$new_lines)
      for(cur_ind in seq_along(self$replacements)) {
        out[cur_ind] <-
          paste0(
            paste(rep('#',self$base_level), collapse = ""), " ",
            names(self$replacements)[cur_ind],
            clp,
            ifelse(self$replacements[cur_ind] != "",
                   paste0(self$replacements[cur_ind],
                          ifelse(cur_ind == length(self$replacements),
                                 "",
                                 clp)),
                   self$replacements[cur_ind]))
      }
      return(paste(out, collapse = ""))
    }
  )
)

TermMatcher <- R6::R6Class(
  #' A class to hold the characters to mark replacements
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
      #' Combined Term object replacements as a list
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

author <- TermString$new("author", c("Monday.md",
                                     "Tuesday.md",
                                     "Wednesday.md"))
days <- TermHeader$new("days",
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
