header_values <- list(
  `Week 1` = "week 1x",
  `Week 2` = "week 2x",
  `Week 3` = "week 3x",
  `Week 4` = "week 4x",
  `Week 5` = "week 5x",
  `Week 6` = "week 6x")
# possible_header_values <- paste0("Week ", 1:6)
# old_template <- readr::read_file(here::here("inst", "extdata", "Templates", "Month-Old.md"))
# new_template <- readr::read_file(here::here("inst", "extdata", "Templates", "Month.md"))
#
# processed_old <- replaceHeaderLinks(
#   header_values = header_values,
#   possible_header_values = possible_header_values,
#   template = old_template)

replaceHeaderLinksNested <- \(header_values, possible_header_values, template) {
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
    new_headers <- glue::glue("{header_val}[{names(valid)}]({valid})")
    new_headers <- paste(new_headers, collapse = new_lines_val)
    new_headers <- paste0(new_lines_val, new_headers, new_lines_val)
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

replaceHeaderLinks <- \(header_values, possible_header_values, template) {
  # Determine which header_values should be handled as is vs as a group
  length_list <- purrr::map_vec(header_values, length) > 1
  character_values <- header_values[!length_list]
  header_values <- header_values[length_list]
  # Handle the grouped header_values
  template <- replaceHeaderLinksNested(
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

processed_new <- replaceHeaderLinks(
  header_values = list(`Week` = header_values),
  possible_header_values = c(possible_header_values, "Weeks"),
  template = new_template)
