Term <- R6::R6Class(
  #' Base class for terms
  "Term",
  private = list(
    .contents = list()
  ),
  active = list(
    contents = \(value) {
      #' The contents method (must be overridden by children)
      stop("Inherited Term class must implement contents")
    }
  ),
  public = list(
    initialize = \(contents) {
      self$contents <- contents
    }
  )
)
