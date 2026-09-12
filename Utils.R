#####
#####
#####
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