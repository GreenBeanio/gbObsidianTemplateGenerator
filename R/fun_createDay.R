#' createDay
#'
#' Creates a daily template
#'
#' @param input_date A date object to create a template for
#' (Default: Sys.Date())
#' @param template_dir A directory with the "Day.md" template file to process
#' (Default: system.file("extdata", "Templates", package = "gbObsidianTemplateGenerator"))
#' @param output_dir A directory to output the processed templates to
#' (Default: here::here())
#' @param author The name of the author for the file
#' (Default: Sys.info()[["user"]])
#' @param template_pre  An optional prefix on your "Day.md" file to use a
#' different template
#' (Default: "")
#' @param unique_timestamp A time object to use as the file's unique time stamp
#' (Default: Sys.time())
#'
#' @returns
#' A list with the Day of the week as the key and the path to the exported file
#' as the value.
#'
#' @section Additional Information:
#' This function will export the processed file and return the path to the
#' processed file. If a file already exists the path will be returned but the
#' existing file will not be overwritten.
#'
#' @examples
#' \dontrun{
#' }
#'
#' @importFrom glue glue
#' @importFrom readr read_file
#' @importFrom lubridate date wday year month
#' @importFrom stringr str_pad
#' @export
createDay <- \(input_date = Sys.Date(),
               template_dir = system.file("extdata", "Templates",
                                          package = "gbObsidianTemplateGenerator"),
               output_dir = here::here(),
               author = Sys.info()[["user"]],
               template_pre = "",
               unique_timestamp = Sys.time(),
               header_func = makeObsidianFilePath) {
  # All of these parameters could be a parameter object... but it's fine...
  if(length(input_date) != 1) {
    stop("input_date needs a single date")
  }
  template_file <- "Day.md"
  if(template_pre != "") {
    template_file <- glue::glue("{template_pre}{template_file}")
  }
  loaded_template <- readr::read_file(file.path(template_dir, template_file))
  input_date <- lubridate::date(input_date)
  output_list <- list()
  # Get the constant variables
  c_title <- strftime(input_date, "%Y_%m_%d")
  c_creation_date <- strftime(unique_timestamp, "%Y-%m-%d")
  c_unique_timestamp <- strftime(unique_timestamp, "%Y%m%d%H%M%S")
  # Get the output path and check if it exists
  output_name <- as.character(lubridate::wday(input_date, label = TRUE,
                                              abbr = FALSE, week_start = 1))
  cur_output_dir <- file.path(
    output_dir, "0_Daily Notes", lubridate::year(input_date),
    lubridate::month(input_date) |> stringr::str_pad(2, 'left', '0'))
  if(!dir.exists(cur_output_dir)) {
    # Recursion could be somewhat annoying if you put in the wrong input directory
    dir.create(cur_output_dir, recursive = TRUE)
  }
  output_file <- file.path(
    cur_output_dir,
    glue::glue("{c_title} Daily Note u-{c_unique_timestamp}.md"))
  if(file.exists(output_file)) {
    # Skip if it exists to not accidentally overwrite previous modifications
    output_list[[output_name]] <- output_file
    return(output_list)
  }
  # Load template and replace the constant variables
  loaded_template <- loaded_template |>
    obsidianMetadataReplace(c_title, c_creation_date, c_unique_timestamp, author)
  # Write the file and add to output
  readr::write_file(loaded_template, output_file)
  output_list[[output_name]] <- output_file
  return(output_list)
}
