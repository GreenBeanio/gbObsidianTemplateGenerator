# listToHeader

Return a list of `DisplayHeader` objects

## Usage

``` r
listToHeader(vals, level, trailing_final = FALSE)
```

## Arguments

- vals:

  A list consisting of names being headers and values being links

- level:

  The level of the header

- trailing_final:

  If the header should have trailing separators

## Value

A list of `DisplayHeader` objects

## Examples

``` r
if (FALSE) listToHeader(list("Day 1" = "meh_day.md", "Day 2" = "cool_day.md"), 2) # \dontrun{}
```
