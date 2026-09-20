# replaceHeaderLinksSingle

Replaces a replacement keywords in a template with headers and links

## Usage

``` r
replaceHeaderLinksSingle(header_values, possible_header_values, template)
```

## Arguments

- header_values:

  A list (or named character vector) where the key (or name) is the
  header keyword and the value is the replacement link

- possible_header_values:

  A vector of all possible headers to check for

- template:

  A loaded template file as a character string (such as from
  readr::read_file)

## Value

The template with the possible_header_values replaced from the
header_values

## Additional Information

- If a possible_header_values exists in the template but is not in the
  header_values parameter it will be replaced with the
  possible_header_values without a link

- If a possible_header_values exists in the template but and is in the
  header_values parameter it will be replaced with the
  possible_header_values

- If a value exists in the header_values parameter that does not exist
  in the possible_header_values parameter it will not be replaced

## See also

Other replaceHeaderLinks:
[`replaceHeaderLinksGroup()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/replaceHeaderLinksGroup.md),
[`replaceHeaderLinks()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/replaceHeaderLinks.md)

## Examples

``` r
if (FALSE) { # \dontrun{
replaceHeaderLinks <- replaceHeaderLinksSingle(
  header_values = list(
    `Quarter 1` = "test_file_1.md",
    `Quarter 2` = "test_file_2.md",
    `Quarter 3` = "test_file_3.md",
    `Quarter 4` = "test_file_4.md"),
 possible_header_values = paste0("Quarter ", 1:4),
 template = readr::read_file(system.file(
                              "inst", "extdata",
                              "Templates", "Year.md",
                              package = "gbObsidianTemplateGenerator")))
} # }
```
