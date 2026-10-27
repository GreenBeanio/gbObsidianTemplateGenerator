# Replacer The main Replacer class

Replacer The main Replacer class

## Active bindings

- `contents`:

  A list of `ReplaceTerm` instances

## Methods

### Public methods

- [`Replacer$new()`](#method-Replacer-initialize)

- [`Replacer$addTerms()`](#method-Replacer-addTerms)

- [`Replacer$makeReplacement()`](#method-Replacer-makeReplacement)

- [`Replacer$clone()`](#method-Replacer-clone)

------------------------------------------------------------------------

### `Replacer$new()`

Initialize a new `Replacer` object

#### Usage

    Replacer$new(contents)

#### Arguments

- `contents`:

  A list of `ReplaceTerm` instances

- `description`:

  contents A `ReplaceTerm` or a list of `ReplaceTerm` instances

#### Returns

A new `Replacer` object

------------------------------------------------------------------------

### `Replacer$addTerms()`

Adds a replacement terms to the contents

#### Usage

    Replacer$addTerms(terms)

#### Arguments

- `terms`:

  A `ReplaceTerm` or a list of `ReplaceTerm` instances

------------------------------------------------------------------------

### `Replacer$makeReplacement()`

Makes a list of the search term and the replacement string

#### Usage

    Replacer$makeReplacement()

#### Returns

A list of search_term-replacement

------------------------------------------------------------------------

### `Replacer$clone()`

The objects of this class are cloneable with this method.

#### Usage

    Replacer$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
