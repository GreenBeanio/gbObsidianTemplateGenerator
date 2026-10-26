Templater <- R6::R6Class(
  #' A class to hold the replacer
  "Templater",
  private = list(
    .replacer = Replacer,
    .template = character(),
    .processed = FALSE
  ),
  active = list(
    replacer = \(value) {
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
    initialize = \(replacer, template) {
      self$replacer <- replacer
      self$template <- template
    },
    process = \() {
      #' Processes the template
      if(!private$.processed) {
        replacer <- self$replacer$makeReplacement()
        for(ind in seq_along(replacer)) {
          private$.template <- stringr::str_replace_all(private$.template,
                                                        names(replacer)[ind],
                                                        replacer[[ind]])
        }
      }
      return(private$.template)
    }
  )
)
