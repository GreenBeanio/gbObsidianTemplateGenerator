# makeHeaderFromList

Searches a template to create a list of `DisplayHeader` objects at their
desired header levels.

## Usage

``` r
makeHeaderFromList(
  vals = vals,
  template = template,
  term = term,
  trailing_mode = FALSE,
  trailing_final = FALSE
)
```

## Arguments

- vals:

  A list consisting of names being headers and values being links

- template:

  A character template to modify

- term:

  The regex term to search for as a header in the template

- trailing_mode:

  If you want the headers to have trailing

- trailing_final:

  If you want the final header to have trailing

## Value

Creates a list of `DisplayHeader` objects from a list and a template

## Examples

``` r
if (FALSE) makeHeaderFromList(
  list("Day 1" = "meh_day.md", "Day 2" = "cool_day.md"),
  "cool_template.md",
  "\\{Days\\}")
 # \dontrun{}
```
