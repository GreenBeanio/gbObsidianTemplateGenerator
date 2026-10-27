# Matcher A class to hold the characters to mark contents

Matcher A class to hold the characters to mark contents

## Active bindings

- `left`:

  The Characters to indicate the left boundary of the search term

- `right`:

  The Characters to indicate the right boundary of the search term

## Methods

### Public methods

- [`Matcher$new()`](#method-Matcher-initialize)

- [`Matcher$clone()`](#method-Matcher-clone)

------------------------------------------------------------------------

### `Matcher$new()`

Initialize a new `Matcher` object

#### Usage

    Matcher$new(left = "\\{", right = "\\}")

#### Arguments

- `left`:

  The characters to indicate the left boundary of the search term

- `right`:

  The Characters to indicate the right boundary of the search term

#### Returns

A new `Matcher` object

------------------------------------------------------------------------

### `Matcher$clone()`

The objects of this class are cloneable with this method.

#### Usage

    Matcher$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
