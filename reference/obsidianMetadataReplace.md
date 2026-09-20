# obsidianMetadataReplace

Replaces obsidian metadata in the templates

## Usage

``` r
obsidianMetadataReplace(
  template,
  title,
  creation_date,
  unique_timestamp,
  author
)
```

## Arguments

- template:

  A loaded template file as a character string (such as from
  readr::read_file)

- title:

  The title of the document

- creation_date:

  The date the document is being generated on

- unique_timestamp:

  The unique time stamp to assign to the file

- author:

  The author of the file

## Value

The template with the metadata replaced

## Additional Information

The keywords in the template are defined between {name} brackets with
the same names as the parameters

## Examples

``` r
if (FALSE) { # \dontrun{
obsidianMetadataReplace(
  template = readr::read_file(system.file("inst", "extdata", "Day.md",
                             package = "gbObsidianTemplateGenerator")),
  title = strftime(Sys.time(), "%Y_%m_%d"),
  creation_date = strftime(Sys.time(), "%Y-%m-%d"),
  unique_timestamp = strftime(Sys.time(), "%Y%m%d%H%M%S"),
  author = Sys.info()["user"])
} # }
```
