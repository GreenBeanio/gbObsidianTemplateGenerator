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

#####
#####
#####
makeObsidianFilePath <- \(list_of_paths) {
  return(
    list_of_paths |>
      purrr::map(\(x) x |> 
                   basename() |> 
                   htmltools::urlEncodePath())) 
}

#####
#####
#####
obsidianMetadataReplace <- \(template,
                             title,
                             creation_date,
                             unique_timestamp,
                             author) {
  return(template |>
           stringr::str_replace_all("\\{title\\}", title) |>
           stringr::str_replace_all("\\{creation_date\\}", creation_date) |>
           stringr::str_replace_all("\\{unique_timestamp\\}", unique_timestamp) |>
           stringr::str_replace_all("\\{author\\}", author))
}