# Term <- R6::R6Class(
#   "Term",
#   private = list(
#     search_term = character(1),
#     replacements = list()
#   ),
#   public = list(
#     initialize = \(search_term, replacements) {
#       # c_warnings <- ""
#       # if(!is.character(search_term) || length(search_term) != 1) {
#       #   c_warnings <- paste(c_warnings,
#       #                       "Invalid search_term",
#       #                       sep = "\n")
#       # }
#       # if(!is.list(replacements) || length(replacements) != 0) {
#       #   c_warnings <- paste(c_warnings,
#       #                       "Invalid replacements",
#       #                       sep = "\n")
#       # }
#       # if(nchar(c_warnings) != 0) {
#       #   stop(c_warnings)
#       # }
#       # private$replacements <- replacements
#       # private$replacements <- replacements
#
#       checkmate::assert_character(search_term, len = 1)
#       private$search_term <- search_term
#
#       checkmate::assert_list(replacements, min.len = 1)
#       private$replacements <- replacements
#     },
#     getTerm = \() {
#       c_list <- list()
#       c_list[[private$search_term]] <- private$replacements
#       return(c_list)
#     }
#   )
# )

Term <- R6::R6Class(
  "Term",
  private = list(
    .search_term = character(1),
    .replacements = list()
  ),
  active = list(
    search_term = \(value) {
      if(missing(value)) {
       return(private$.search_term)
      }
      checkmate::assert_character(value, len = 1)
      private$.search_term <- value
    },
    replacements = \(value) {
      if(missing(value)) {
        return(private$.replacements)
      }
      checkmate::assert_list(value, min.len = 1)
      private$.replacements <- value
    }
  ),
  public = list(
    initialize = \(search_term, replacements) {
      self$search_term <- search_term
      self$replacements <- replacements
    },
    getTerm = \() {
      c_list <- list()
      c_list[[self$search_term]] <- self$replacements
      return(c_list)
    }
    )
)

x <- Term$new("author", list("Monday" = "Monday.md"))
x$getTerm()

Term <- R6::R6Class(
  "Terms",
  private = list(
    terms = list()
  ),
  public = list(
    initialize = \() {},

    addTerm = \(term) {
      checkmate::assert_class(term, "Term")
      c_name <- names(term$getTerm())

      # if(c_name %in% names(private$terms)) {
      #   # I would throw an error (stop), but exception handling in R kind of
      #   # blows so just a warning
      #   warning(glue::glue("{c_name} already in terms"))
      #   return(invisible(self))
      # }

      if(!is.null(names(private$terms)) &&
         checkmate::check_names(c_name, subset.of = names(private$terms))) {
        # I would throw an error (stop), but exception handling in R kind of
        # blows so just a warning
        warning(glue::glue("{c_name} already in terms"))
        return(invisible(self))
      }

      private$terms[[c_name]] <- term
      return(invisible(self))
    },

    removeTerm = \(term) {
      checkmate::assert_class(term, "Term")
      c_name <- names(term$getTerm())
      private$terms[[c_name]] <- NULL
      return(invisible(self))
    },

    modifyTerm = \(term) {
      checkmate::assert_class(term, "Term")
      c_name <- names(term$getTerm())
      private$terms[[c_name]] <- term
      return(invisible(self))
    },

    viewTerms = \() {
      print(names(private$terms))
    }
    )
)

y <- Term$new()
y$addTerm(x)
y$addTerm(x)
y$removeTerm(x)
y$modifyTerm(x)
y$viewTerms()

z <- y$clone()
y$removeTerm(x)
y$viewTerms()
z$viewTerms()
