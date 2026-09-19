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
#'     `Weeks` = list(
#'       `Week 1` = "test_file_1.md",
#'       `Week 2` = "test_file_2.md",
#'       `Week 3` = "test_file_3.md",
#'       `Week 4` = "test_file_4.md"),
#'     `Daily Quote` = "test_file_5.md"),
#'  possible_header_values = c("Weeks, "Daily Quote", paste0("Week ", 1:4)),
#'  template = readr::read_file(system.file(
#'                               "inst", "extdata",
#'                               "Templates", "Year.md",
#'                               package = "gbObsidianTemplateGenerator")))
#' }
#'
#' @seealso [replaceHeaderLinksGroup()]
#' @seealso [replaceHeaderLinksSingle()]
#' @family replaceHeaderLinks
#' @importFrom stringr str_replace_all
#' @importFrom glue glue
#' @importFrom purrr map_vec
#' @export
replaceHeaderLinks <- \(header_values, possible_header_values, template) {
  # Determine which header_values should be handled as is vs as a group
  length_list <- purrr::map_vec(header_values, length) > 1
  character_values <- header_values[!length_list]
  header_values <- header_values[length_list]
  # Handle the grouped header_values
  template <- replaceHeaderLinksGroup(
    header_values = header_values,
    possible_header_values = possible_header_values,
    template = template)
  # Handle the single header_values
  possible_header_values <- setdiff(possible_header_values, names(header_values))
  template <- replaceHeaderLinksSingle(
    header_values = character_values,
    possible_header_values = possible_header_values,
    template = template)
  return(template)
}

#' replaceHeaderLinksGroup
#'
#' Generates a group of headers and links to insert into a template
#'
#' @param header_values A list where the key (or name) is the group header
#' keyword and the value is a list with keys of new headers and their link
#' @param possible_header_values A vector of all possible headers to check for
#' @param template A loaded template file as a character string
#' (such as from readr::read_file)
#'
#' @returns
#' The template with the possible_header_values replaced with the generated
#' headers from the header_values
#'
#' @section Additional Information:
#' The possible_header_values needs to contain both the valid options for the
#' possible group names and the header names. Such that if you have a group
#' header in your template called "Weeks" and you want it to allow the values
#' "Week 1" through 'Week 5" then you need to include all of those values in
#' the possible_header_values vector. This is mainly done to easily allow
#' interoperability with \code{replaceHeaderLinksSingle}. If you need to
#' separate the possible_header_values for specific groups my suggestion would
#' be to run the function multiple times while adjusting possible_header_values.
#'
#' Unlike the \code{replaceHeaderLinksSingle} function this will not replace
#' unmatched possible_header_values with unlinked headers. Instead this will
#' only generate headers that are in the header_values and are in the
#' \code{possible_header_values}. If you need the headers to always be created
#' manually add them in your template and use \code{replaceHeaderLinksSingle}.
#'
#' In the event that no valid matches are found for the group the group will
#' be replaced with nothing. Meaning that the line will essentially be erased.
#'
#' @examples
#' \dontrun{
#' replaceHeaderLinks <- replaceHeaderLinksGroup(
#'   header_values = list(
#'     `Weeks` = list(
#'       `Week 1` = "test_file_1.md",
#'       `Week 2` = "test_file_2.md",
#'       `Week 3` = "test_file_3.md",
#'       `Week 4` = "test_file_4.md")),
#'  possible_header_values = c("Weeks", paste0("Week ", 1:4)),
#'  template = readr::read_file(system.file(
#'                               "inst", "extdata",
#'                               "Templates", "Year.md",
#'                               package = "gbObsidianTemplateGenerator")))
#' }
#'
#' @family replaceHeaderLinks
#' @importFrom stringr str_replace_all str_match
#' @importFrom glue glue
#' @export
replaceHeaderLinksGroup <- \(header_values, possible_header_values, template) {
  for(cur_header in intersect(names(header_values), possible_header_values)) {
    # Extract the header level and new lines used
    header_level <- stringr::str_match(
      template,
      paste0("(?<newlines>\\\n{1,2})(?<level>[#]{0,6})(?:[ ]*\\{",
             cur_header,
             "\\})(?:\\\n{1,2})"))
    # If there is no match skip to the next iteration
    if(is.na(header_level[1, 1])) {
      next
    }
    # Replace matched headers with their values
    new_lines <- header_level[1, "newlines"]
    header_level <- header_level[1, "level"]
    header_val <- ""
    if(!is.na(header_level)) {
      header_val <- paste0(header_level, " ")
    }
    new_lines_val <- "\n\n"
    if(!is.na(new_lines)) {
      new_lines_val <- new_lines
    }
    # Get only the valid nested names and use them
    cur_items <- header_values[[cur_header]]
    valid <- cur_items[names(cur_items) %in%
                         intersect(names(cur_items), possible_header_values)]
    # If there are no valid matches the line will essentially be erased
    new_headers <- ""
    if(length(valid) > 0) {
      new_headers <- glue::glue("{header_val}[{names(valid)}]({valid})")
      new_headers <- paste(new_headers, collapse = new_lines_val)
      new_headers <- paste0(new_lines_val, new_headers, new_lines_val)
    }
    # Update the template
    template <- template |>
      stringr::str_replace_all(
        paste0(
          "(?:\\\n{1,2})[#]{0,6}[ ]*\\{",
          cur_header,
          "\\}(?:\\\n{1,2})"),
        new_headers)
  }
  return(template)
}

#' replaceHeaderLinksSingle
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
#' replaceHeaderLinks <- replaceHeaderLinksSingle(
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
#' @family replaceHeaderLinks
#' @importFrom stringr str_replace_all
#' @importFrom glue glue
#' @export
replaceHeaderLinksSingle <- \(header_values, possible_header_values, template) {
  for(check_header in possible_header_values) {
    cur_replace <- paste0("\\{",check_header,"\\}")
    if(check_header %in% names(header_values)) {
      # Replace matching headers with their header_value match
      template <- template |>
        stringr::str_replace_all(
          cur_replace,
          glue::glue("[{check_header}]({header_values[[check_header]]})"))
    } else {
      # Replace unmatched possible_header_values with their name but no link
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
