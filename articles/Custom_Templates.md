# Custom Templates

## Overview

It is possible to create your own templates and even extend the
abilities of the template system.

The system relies on 3 components:

- [Terms](#Terms)
- [Replacer](#Replacer-Sec)
- [Templater](#Templater)

## Terms

There are several classes that make up the terms section:

- (DisplayTerm)\[#DisplayTerm\]
- (DisplayString)\[#DisplayString\]
- (DisplayNone)\[#DisplayNone\]
- (DisplayTerms)\[#DisplayTerms\]
- (DisplayHeader)\[#DisplayHeader\]

### DisplayTerm

This is the base class that you can extend to create subclasses for
custom processing.

These classes need the following methods implemented:

- active:
  - `contents(value)`: Implement logic to only allow in your desired
    data types
- public:
  - `makeText`: The main method that turns the contents into the
    replacement string
  - `initialize`: Initialization of the subclass
    - You only need to add this if you want to pass different defaults
  - `addTerms(terms)`: Implement logic to add more terms to an existing
    instance

This class has the following parameters:

- `contents`: The contents of the class, which will depend on your
  implementation
- `separators`: How many separators should be used when processing the
  contents
- `trailing_mode`: If the processed string should be appended with the
  separators
- `separator`: The separator characters to use when joining or trailing
  the text

There are also several helper methods:

- `getSeparators()`: Gets the separate string to use
  - Typically used to combine the multiple objects in the `contents`
- `trailing(content)`: Takes a character and handles applying trailing
  to it

For example, this is the implementation of
[DisplayString](#DisplayString):

``` r

#' DisplayString
#' A class for displaying strings
#' @importFrom checkmate assertCharacter assertVector
#' @export
DisplayString <- R6::R6Class(
  "DisplayString",
  inherit = DisplayTerm,
  active = list(
    #' @field contents A vector of replacement strings
    contents = \(value) {
      if(missing(value)) {
        return(private$.contents)
      }
      if(!is.vector(value)) {
        value <- c(value)
      }
      checkmate::assertVector(value, min.len = 0, names = "unnamed")
      checkmate::assertCharacter(value)
      private$.contents <- value
    }
  ),
  public = list(
    #' @description Initialize a new `DisplayString` object
    #' @param contents The contents of the `DisplayString`
    #' @param separators How many separators to use between the contents
    #' @param trailing_mode If the contents should be trailed by the separtors
    #' @param separator The separating characters (typically `\\n`)
    #' @return A new `DisplayString` object
    initialize = \(contents, separators = 0,
                   trailing_mode = FALSE, separator = "\n") {
      if(missing(contents)) {
        contents <- character()
      }
      super$initialize(contents = contents,
                       separators = separators,
                       trailing_mode = trailing_mode,
                       separator = separator)
    },
    #' @description Generates the string to insert
    #' @returns The display text
    makeText = \() {
      body <- paste(self$contents, collapse = self$getSeparators())
      return(self$trailing(body))
    },
    #' @description Adds a terms terms to the contents
    #' @param terms A character or a vector of character objects
    addTerms = \(terms) {
      #' Adds a terms terms to the contents
      if(!is.vector(terms)) {
        terms <- c(terms)
      }
      checkmate::assertVector(value, min.len = 1, names = "unnamed")
      checkmate::assertCharacter(value)
      self$contents <- c(private$.contents, terms)
      return(invisible(self))
    }
  )
)
```

### DisplayString

`DisplayString` is the basic class to handle creating text. It simply
just takes a `character` or a vector of `character`s.

`DisplayString`s are created like:

``` r

ex_c <- DisplayString$new(
  contents = c("Line 1", "Line 2", "Line 3"),
  separators = "2",
  trailing_mode = FALSE,
  separator = "\n")
ex_text <- ex_c$makeText()
```

### DisplayNone

`DisplayNone` is the basic class to handle not displaying anything.

This class has no parameters and will return an empty character.

`DisplayNone`s are created like:

``` r

ex_n <- DisplayNone$new()
```

### DisplayTerms

`DisplayTerms` is the class that holds multiple different
[DisplayTerm](#DisplayTerm) objects. This is the class that you would
use to combine multiple types of [DisplayTerm](#DisplayTerm) objects
into one replacement.

`DisplayNone`s are created like:

``` r

ex_n <- DisplayTerms$new(contents = list(ex_c, ex_n))
```

### DisplayHeader

`DisplayHeader` is the class that creates headers and holds
[DisplayTerm](#DisplayTerm) objects.

This class has the following additional parameters:

- `header`: The title for the header
- `level`: The level of the header
- `link`: The link for the header, if there is one

The `contents` are [DisplayTerm](#DisplayTerm) objects, meaning that you
can combine the generated text with any other
[DisplayTerm](#DisplayTerm) classes.

`DisplayHeader`s are created like:

``` r

ex_h <- DisplayHeader$new(
  header = "Cool Header",
  level = 2,
  contents = ex_n,
  link = "cool_file.md")
```

There are also several helper functions in this package when it comes to
headers.

- `makeHeaderFromList`: This is a function that will search a template
  for a term, find the heading level for it, and create a
  [DisplayHeader](#DisplayHeader)
- `listToHeader`: This function is wrapped by `makeHeaderFromList` and
  turns a list into a [DisplayHeader](#DisplayHeader)
- `findHeaderLevels`: This function is wrapped by `makeHeaderFromList`
  and uses regex to find the header level of the term
- `removeHeaderLever`: This function can be used to remove the
  corresponding header levels from a loaded template so that the
  replacement can work properly
- `makeObsidianFilePath`: This will change a file path to just the file
  name for better usage with Obsidian.

## Replacer

The replacer consists of 3 parts:

- [Matcher](#Matcher)
- [ReplaceTerm](#ReplaceTerm)
- [Replacer](#Replacer)

### Matcher

The `Matcher` is what character wrap the term in your template.

Keep in mind that regex is used to search for matches in the template.
For that reason remember that you need to have regex safe characters and
be safe for R escaping as well.

For example, `{word}` for regex would be `\{word\}`, but for R you will
want to use `\\{word\\}`.

There are only 2 parameters:

- `left`
- `right`

`Matcher`s are created like:

``` r

matcher <- Matcher$new(left = "\\{", right = "\\}")
```

### ReplaceTerm

The `ReplaceTerm` is the object that is actually used in the matching.
It consists of:

- `contents`: A [DisplayTerm](#DisplayTerm) object
- `search_term`: A search term in the template
- `matcher`: A [Matcher](#Matcher) object

`ReplaceTerm`s are created like:

``` r

r_days <- ReplaceTerm$new(search_term = "Days",
                          contents = days,
                          matcher = matcher)
```

### Replacer

The `Replacer` is the object that contains all of the `ReplaceTerm`
objects to use processing your template.

These objects only have one parameter:

- `contents`: [ReplaceTerm](#ReplaceTerm) object or list of
  [ReplaceTerm](#ReplaceTerm)

`Replacer`s are created like:

``` r

replacer <- Replacer$new(contents = r_days)
```

You can also add more terms to an existing `Replacer` with `addTerms`.

``` r

replacer$addTerms(list(r_weeks, r_months))
```

A list of the corresponding regex and replacement strings can be
extracted with `makeReplacement`.

``` r

replacer$makeReplacement()
```

## Templater

The `Templater` class is very simple, only having two parameters:

- `replacer`: A [`Replacer`](#Replacer) object
- `template`: A loaded character template.

All you have to do is to do is create and call the `Templater` like
this:

``` r

template <- Templater$new(replacer = replacer, 
                          template = template)$process()
```

By running `process` you will modify the stored `template` in place.

The template will only be processed on the intitial `process` call. On
subsequent calls it will just return the stored template. This can be
overridden if you pass the `force` parameter as `TRUE`.

You can also insert a new `template` or `replacer` and they next
`process` call will process the template again.
