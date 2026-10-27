# DisplayTerms A class for holding multiple `DisplayTerm` objects

DisplayTerms A class for holding multiple `DisplayTerm` objects

## Super classes

[`Term`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/Term.md)
-\>
[`DisplayTerm`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/DisplayTerm.md)
-\> `DisplayTerms`

## Active bindings

- `contents`:

  A vector of replacement `DisplayTerm` classes

## Methods

### Public methods

- [`DisplayTerms$new()`](#method-DisplayTerms-initialize)

- [`DisplayTerms$makeText()`](#method-DisplayTerms-makeText)

- [`DisplayTerms$addTerms()`](#method-DisplayTerms-addTerms)

- [`DisplayTerms$clone()`](#method-DisplayTerms-clone)

Inherited methods

- [`DisplayTerm$getSeparators()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerm.html#method-DisplayTerm-getSeparators)
- [`DisplayTerm$trailing()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerm.html#method-DisplayTerm-trailing)

------------------------------------------------------------------------

### `DisplayTerms$new()`

Initialize a new `DisplayTerms` object

#### Usage

    DisplayTerms$new(
      contents,
      separators = 2,
      trailing_mode = TRUE,
      separator = "\n"
    )

#### Arguments

- `contents`:

  The contents of the `DisplayTerms`

- `separators`:

  How many separators to use between the contents

- `trailing_mode`:

  If the contents should be trailed by the separtors

- `separator`:

  The separating characters (typically `\\n`)

#### Returns

A new `DisplayTerms` object

------------------------------------------------------------------------

### `DisplayTerms$makeText()`

Generates the string to insert

#### Usage

    DisplayTerms$makeText()

#### Returns

The display text

------------------------------------------------------------------------

### `DisplayTerms$addTerms()`

Adds a terms terms to the contents

#### Usage

    DisplayTerms$addTerms(terms)

#### Arguments

- `terms`:

  A `DisplayTerm` or a list of `DisplayTerm` objects

------------------------------------------------------------------------

### `DisplayTerms$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DisplayTerms$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
