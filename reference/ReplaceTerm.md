# ReplaceTerm Base class for replacement terms

ReplaceTerm Base class for replacement terms

## Super class

[`Term`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/Term.md)
-\> `ReplaceTerm`

## Active bindings

- `contents`:

  A `DisplayTerm` instance

- `search_term`:

  The search term

- `matcher`:

  The `Matcher` for the term

## Methods

### Public methods

- [`ReplaceTerm$new()`](#method-ReplaceTerm-initialize)

- [`ReplaceTerm$makeReplacement()`](#method-ReplaceTerm-makeReplacement)

- [`ReplaceTerm$makeSearch()`](#method-ReplaceTerm-makeSearch)

- [`ReplaceTerm$clone()`](#method-ReplaceTerm-clone)

------------------------------------------------------------------------

### `ReplaceTerm$new()`

Initialize a new `ReplaceTerm` object

#### Usage

    ReplaceTerm$new(search_term, contents, matcher)

#### Arguments

- `search_term`:

  The search term

- `contents`:

  A `DisplayTerm` instance

- `matcher`:

  The `Matcher` for the term

#### Returns

A new `ReplaceTerm` object

------------------------------------------------------------------------

### `ReplaceTerm$makeReplacement()`

Makes a replacement string to insert into the MD document

#### Usage

    ReplaceTerm$makeReplacement()

#### Returns

The text to replace matches with

------------------------------------------------------------------------

### `ReplaceTerm$makeSearch()`

Makes a replacement string to insert into the MD document

#### Usage

    ReplaceTerm$makeSearch()

#### Returns

The regex match to search for

------------------------------------------------------------------------

### `ReplaceTerm$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ReplaceTerm$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
