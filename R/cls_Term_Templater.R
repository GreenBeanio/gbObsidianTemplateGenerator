#' Templater
#' A class to process a template
#' @importFrom checkmate assertClass assertCharacter
#' @export
Templater <- R6::R6Class(
  "Templater",
  private = list(
    .replacer = Replacer,
    .template = character(),
    .processed = FALSE
  ),
  active = list(
    #' @field replacer A `Replacer` instance
    replacer = \(value) {
      if(missing(value)) {
        return(private$.replacer)
      }
      checkmate::assertClass(value, classes = "Replacer")
      private$.replacer <- value
    },
    #' @field template A character template
    template = \(value) {
      if(missing(value)) {
        return(private$.template)
      }
      checkmate::assertCharacter(value, len = 1, names = "unnamed")
      private$.processed <- FALSE
      private$.template <- value
    }
  ),
  public = list(
    #' Initialize a new `Templater` object
    #' @param replacer A `Replacer` instance
    #' @param template A character template
    #' @return A new `Templater` object
    initialize = \(replacer, template) {
      self$replacer <- replacer
      self$template <- template
    },
    #' @description Processes the template
    #' @returns The processed character template
    process = \() {
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
