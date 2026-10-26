#' makeObsidianFilePath
#'
#' Extracts the file names from the passed paths for Obsidian to use for links
#'
#' @param list_of_paths A list of paths to process
#'
#' @returns
#' A list of modified paths (in this case just the file names)
#'
#' @section Additional Information:
#' Obsidian allows you to use unique file names for links instead of needing
#' relative or absolute paths to the files. This function extracts just the
#' unique file names needed. This allows you to reorganize the file in any
#' way you desire without needing to update the references.
#'
#' @examples
#' \dontrun{
#' makeObsidianFilePath(
#'   list_of_paths = list(
#'     `Quarter 1` = "/home/.../2026_1 Quarterly Note u-00000000000000.md",
#'     `Quarter 2` = "/home/.../2026_2 Quarterly Note u-00000000000000.md",
#'     `Quarter 3` = "/home/.../2026_3 Quarterly Note u-00000000000000.md",
#'     `Quarter 4` = "/home/.../2026_4 Quarterly Note u-00000000000000.md"))
#' }
#'
#' @importFrom purrr map
#' @importFrom htmltools urlEncodePath
#' @export
makeObsidianFilePath <- \(list_of_paths) {
  return(
    list_of_paths |>
      purrr::map(\(x) x |>
                   basename() |>
                   htmltools::urlEncodePath()))
}

#' obsidianMetadataReplace
#'
#' Return a list of ReplaceTerm objects
#'
#' @param title The title of the document
#' @param creation_date The date the document is being generated on
#' @param unique_timestamp The unique time stamp to assign to the file
#' @param author The author of the file
#'
#' @returns
#' The template with the metadata replaced
#'
#' @section Additional Information:
#' The keywords in the template are defined between \{name\} brackets with the
#' same names as the parameters
#'
#' @examples
#' \dontrun{
#' obsidianMetadataReplace(
#'   template = readr::read_file(system.file("inst", "extdata", "Day.md",
#'                              package = "gbObsidianTemplateGenerator")),
#'   title = strftime(Sys.time(), "%Y_%m_%d"),
#'   creation_date = strftime(Sys.time(), "%Y-%m-%d"),
#'   unique_timestamp = strftime(Sys.time(), "%Y%m%d%H%M%S"),
#'   author = Sys.info()["user"])
#' }
#'
#' @importFrom stringr str_replace_all
#' @export
obsidianMetadataReplace <- \(title,
                             creation_date,
                             unique_timestamp,
                             author) {
  return(
    list(
      ReplaceTerm$new(search_term = "title",
                      contents = DisplayString$new(
                        contents = title)),
      ReplaceTerm$new(search_term = "creation_date",
                      contents = DisplayString$new(
                        contents = creation_date)),
      ReplaceTerm$new(search_term = "unique_timestamp",
                      contents = DisplayString$new(
                        contents = unique_timestamp)),
      ReplaceTerm$new(search_term = "author",
                      contents = DisplayString$new(
                        contents = author))
      )
    )
}

listToHeader <- \(vals, level, trailing_final = FALSE) {
  out_list <- list()
  trailing <- TRUE
  for(ind in seq_along(vals)) {
    if(!trailing_final && ind == length(vals)) {
      trailing <- FALSE
    }
    out_list[[ind]] <-
      DisplayHeader$new(header = names(vals)[ind],
                        level = level,
                        link = vals[[ind]],
                        trailing_mode = trailing)
  }
  return(out_list)
}

findHeaderLevels <- \(template, term) {
  header_level <- stringr::str_match(
    template,
    paste0("(?<newlines>\\\n{1,2})(?<level>[#]{0,6})(?:[ ]*",
           term,")(?:\\\n{1,2})"))
  if(is.na(header_level[1, 1])) {
    return(NULL)
  } else {
    return(unname(nchar(header_level[1, 3])))
  }
}

removeHeaderLever <- \(template, term) {
  template <- stringr::str_replace_all(
    template,
    paste0("(?<=\\\n{1,2})([#]{0,6}[ ]*",term,")(?=\\\n{1,2})"), term)
  return(template)
}

makeHeaderFromList <- \(vals = vals,
                        template = template,
                        term = term,
                        trailing_mode = FALSE,
                        trailing_final = FALSE) {
  header_level <- findHeaderLevels(template = template,
                                   term = term)
  if(is.null(header_level)) {
    return(NULL)
  }
  return(
    DisplayTerms$new(
      contents = listToHeader(vals =  vals,
                              level = header_level,
                              trailing_final = trailing_final),
      trailing_mode = trailing_mode))
}
