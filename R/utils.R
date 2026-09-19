#' replaceHeaderLinks
#'
#' Replaces a replacement keywords in a template with headers and links
#'
#' @param header_values A list (or named character vector) where the key
#' (or name) is the header keyword and the value is the replacement link
#' @param possible_header_values A vector of all possible headers to check for
#' @param template A loaded template file as a character string
#' (such as from readr::read_file)
#'
#' @returns
#' The template with the possible_header_values replaced from the header_values
#'
#' @section Additional Information:
#'
#' \itemize{
#' \item{If a possible_header_values exists in the template but is not in the
#' header_values parameter it will be replaced with the possible_header_values
#' without a link}
#' \item{If a possible_header_values exists in the template but and is in the
#' header_values parameter it will be replaced with the possible_header_values}
#' \item{If a value exists in the header_values parameter that does not exist
#' in the possible_header_values parameter it will not be replaced}
#' }
#'
#' @examples
#' \dontrun{
#' replaceHeaderLinks <- replaceHeaderLinks(
#'   header_values = list(
#'     `Quarter 1` = "test_file_1.md",
#'     `Quarter 2` = "test_file_2.md",
#'     `Quarter 3` = "test_file_3.md",
#'     `Quarter 4` = "test_file_4.md"),
#'  possible_header_values = paste0("Quarter ", 1:4),
#'  template = readr::read_file(system.file(
#'                               "inst", "extdata",
#'                               "Templates", "Year.md",
#'                               package = "gbObsidianTemplateGenerator")))
#' }
#'
#' @importFrom stringr str_replace_all
#' @importFrom glue glue
#' @export
replaceHeaderLinks <- \(header_values, possible_header_values, template) {
  for(check_header in possible_header_values) {
    cur_replace <- paste0("\\{",check_header,"\\}")
    if(check_header %in% names(header_values)) {
      template <- template |>
        stringr::str_replace_all(
          cur_replace,
          glue::glue("[{check_header}]({header_values[[check_header]]})"))
    } else {
      template <- template |>
        stringr::str_replace_all(
          cur_replace,
          check_header)
    }
  }
  return(template)
}

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
#'     `Quarter 1` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_1 Quarterly Note u-00000000000000.md",
#'     `Quarter 2` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_2 Quarterly Note u-00000000000000.md",
#'     `Quarter 3` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_3 Quarterly Note u-00000000000000.md",
#'     `Quarter 4` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_4 Quarterly Note u-00000000000000.md"))
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
#' Replaces obsidian metadata in the templates
#'
#' @param template A loaded template file as a character string
#' (such as from readr::read_file)
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
obsidianMetadataReplace <- \(template,
                             title,
                             creation_date,
                             unique_timestamp,
                             author) {
  # This could use a parameter object instead, but 5 parameters is ok...
  return(template |>
           stringr::str_replace_all("\\{title\\}", title) |>
           stringr::str_replace_all("\\{creation_date\\}", creation_date) |>
           stringr::str_replace_all("\\{unique_timestamp\\}", unique_timestamp) |>
           stringr::str_replace_all("\\{author\\}", author))
}
