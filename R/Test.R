Term <- R6::R6Class(
  #' A class to hold a replacement keyword in a MD document
  "Term",
  private = list(
    .search_term = character(1),
    .replacements = list()
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
      #' Handles the replacement logic (must be overridden by children)
      stop("Inherited Term class must implement replacements")
    }
  ),
  public = list(
    initialize = \(search_term, replacements) {
      self$search_term <- search_term
      self$replacements <- replacements
    },
    getTerm = \() {
      #' A method to return the list of replacements
      c_list <- list()
      c_list[[self$search_term]] <- self$replacements
      return(c_list)
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
      checkmate::assertVector(value, min.len = 1)
      checkmate::assertCharacter(value)
      private$.replacements <- value
    }
  ),
  public = list(
    # initialize = \(search_term, replacements) {
    #   super$intialize()
    # },
  )
)

author <- TermString$new("author", c("Monday.md",
                                     "Tuesday.md",
                                     "Wednesday.md"))
author$search_term
author$replacements
author$getTerm()

TermHeader <- R6::R6Class(
  #' A class to hold replacement headers
  "TermHeader",
  inherit = Term,
  active = list(
    replacements = \(value) {
      #' A list of replacement strings
      if(missing(value)) {
        return(private$.replacements)
      }
      checkmate::assertList(value, min.len = 1, names = "named")
      private$.replacements <- value
    }
  )
)

days <- TermHeader$new("days", list("Monday" = "Monday.md",
                                    "Tuesday" = "Tuesday.md",
                                    "Wednesday" = "Wednesday.md"))
days$search_term
days$replacements
days$getTerm()







Terms <- R6::R6Class(
  #' A class to hold multiple Term instances
  "Terms",
  private = list(
    terms = list()
  ),
  public = list(
    #initialize = \() {},
    addTerm = \(term) {
      #' Adds a Term to the class
      #' This will NOT overwrite an existing term
      checkmate::assertClass(term, "Term")
      c_name <- names(term$getTerm())
      if(!is.null(names(private$terms)) && c_name %in% names(private$terms)) {
        warning(glue::glue("{c_name} already in terms"))
        return(invisible(self))
      }
      private$terms[[c_name]] <- term
      return(invisible(self))
    },
    removeTerm = \(term) {
      #' Removes a Term from the class
      #' This does NOT check if the Term is in the class
      checkmate::assertClass(term, "Term")
      c_name <- names(term$getTerm())
      private$terms[[c_name]] <- NULL
      return(invisible(self))
    },
    modifyTerm = \(term) {
      #' Modifies an existing Term in the class
      #' This will add the Term if it doesn't exist
      checkmate::assertClass(term, "Term")
      c_name <- names(term$getTerm())
      private$terms[[c_name]] <- term
      return(invisible(self))
    },
    viewTerms = \() {
      #' Prints the Term keywords in the class
      print(names(private$terms))
    },
    getTerms = \() {
      #' Gets the combined Term objects in the class
      cur <- list()
      for(term in private$terms) {
        cur <- append(cur, term$getTerm())
      }
      return(cur)
    }
  )
)

author <- Term$new("author", list("Monday" = "Monday.md",
                                  "Tuesday" = "Tuesday.md",
                                  "Wednesday" = "Wednesday.md"))
author$getTerm()
date <- Term$new("date", list("date" = lubridate::ymd("2026-10-25")))
date$getTerm()

y <- Terms$new()
y$addTerm(author)
y$addTerm(date)
# y$viewTerms()
y$removeTerm(author)
# y$viewTerms()
date <- Term$new("date", list("date" = lubridate::ymd("2026-10-26")))
y$modifyTerm(date)
y$modifyTerm(author)
y$viewTerms()
y$getTerms()

readr::read_file(here::here("inst", "extdata", "Week.md"))
