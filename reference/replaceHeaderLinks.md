# replaceHeaderLinks

Replaces a replacement keywords in a template with headers and links

## Usage

``` r
replaceHeaderLinks(header_values, possible_header_values, template)
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

[`replaceHeaderLinksGroup()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/replaceHeaderLinksGroup.md)

[`replaceHeaderLinksSingle()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/replaceHeaderLinksSingle.md)

Other replaceHeaderLinks:
[`replaceHeaderLinksGroup()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/replaceHeaderLinksGroup.md),
[`replaceHeaderLinksSingle()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/replaceHeaderLinksSingle.md)

## Examples

``` r
if (FALSE) { # \dontrun{
replaceHeaderLinks <- replaceHeaderLinks(
  header_values = list(
    `Weeks` = list(
      `Week 1` = "test_file_1.md",
      `Week 2` = "test_file_2.md",
      `Week 3` = "test_file_3.md",
      `Week 4` = "test_file_4.md"),
    `Daily Quote` = "test_file_5.md"),
 possible_header_values = c("Weeks", "Daily Quote", paste0("Week ", 1:4)),
 template = readr::read_file(system.file(
                              "inst", "extdata",
                              "Templates", "Year.md",
                              package = "gbObsidianTemplateGenerator")))
} # }
```
