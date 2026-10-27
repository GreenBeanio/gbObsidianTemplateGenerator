#' Term
#' Base class for Term classes
#' @export
Term <- R6::R6Class(
  "Term",
  private = list(
    .contents = list()
  ),
  active = list(
    #' @field contents The contents of the `Term`
    contents = \(value) {
      #' The contents method (must be overridden by children)
      stop("Inherited Term class must implement contents")
    }
  ),
  public = list(
    #' @description Initialize a new ObsidianNote object
    #' @param contents The contents of the `Term`
    #' @return A new `Term` object
    initialize = \(contents) {
      self$contents <- contents
    }
  )
)
