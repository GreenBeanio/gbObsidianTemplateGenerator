Templater <- R6::R6Class(
  #' A class to hold the replacers
  "Templater",
  private = list(
    .replacer = Replacer,
    .template = character(),
    .processed = FALSE
  ),
  active = list(
    replacers = \(value) {
      #' A Replacer instance
      if(missing(value)) {
        return(private$.replacer)
      }
      checkmate::assertClass(value, classes = "Replacer")
      private$.replacer <- value
    },
    template = \(value) {
      #' The template (a character object)
      if(missing(value)) {
        return(private$.template)
      }
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      private$.processed <- FALSE
      private$.template <- value
    }
  ),
  public = list(
    initialize = \(replacers, template) {
      self$replacers <- replacers
      self$template <- template
    },
    process = \() {
      #' Processes the template
      if(!private$.processed) {
        replacers <- self$replacers$makeReplacement()
        for(ind in seq_along(replacers)) {
          private$.template <- stringr::str_replace_all(private$.template,
                                                        names(replacers)[ind],
                                                        replacers[[ind]])
        }
      }
      return(private$.template)
    }
  )
)
