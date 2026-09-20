# createMonth

Creates a monthly template

## Usage

``` r
createMonth(
  input_date = Sys.Date(),
  template_dir = system.file("extdata", "Templates", package =
    "gbObsidianTemplateGenerator"),
  output_dir = here::here(),
  author = Sys.info()[["user"]],
  template_pre = "",
  unique_timestamp = Sys.time(),
  header_func = makeObsidianFilePath
)
```

## Arguments

- input_date:

  A date object to create a template for (Default: Sys.Date())

- template_dir:

  A directory with the "Month.md" template file to process (Default:
  system.file("extdata", "Templates", package =
  "gbObsidianTemplateGenerator"))

- output_dir:

  A directory to output the processed templates to (Default:
  here::here())

- author:

  The name of the author for the file (Default: Sys.info()\["user"\])

- template_pre:

  An optional prefix on your "Month.md" file to use a different template
  (Default: "")

- unique_timestamp:

  A time object to use as the file's unique time stamp (Default:
  Sys.time())

- header_func:

  The function to use to process the links in the template (Default:
  makeObsidianFilePath)

## Value

A list with the Month of the quarter the key and the path to the
exported file as the value.

## Additional Information

This function will export the processed file and return the path to the
processed file. If a file already exists the path will be returned but
the existing file will not be overwritten.

## Examples

``` r
if (FALSE) { # \dontrun{
createMonth()
} # }
```
