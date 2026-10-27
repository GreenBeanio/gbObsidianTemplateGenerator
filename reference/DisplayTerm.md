# DisplayTerm Base class for `DisplayTerm` classes

DisplayTerm Base class for `DisplayTerm` classes

## Super class

[`Term`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/Term.md)
-\> `DisplayTerm`

## Active bindings

- `separators`:

  The number of separators to use when joining the contents

- `trailing_mode`:

  If the item should be followed by the separators

- `separator`:

  The separating characters (typically `\\n`) Initialize a new
  `DisplayTerm` object

## Methods

### Public methods

- [`DisplayTerm$new()`](#method-DisplayTerm-initialize)

- [`DisplayTerm$makeText()`](#method-DisplayTerm-makeText)

- [`DisplayTerm$getSeparators()`](#method-DisplayTerm-getSeparators)

- [`DisplayTerm$trailing()`](#method-DisplayTerm-trailing)

- [`DisplayTerm$addTerms()`](#method-DisplayTerm-addTerms)

- [`DisplayTerm$clone()`](#method-DisplayTerm-clone)

------------------------------------------------------------------------

### `DisplayTerm$new()`

#### Usage

    DisplayTerm$new(
      contents,
      separators = 2,
      trailing_mode = TRUE,
      separator = "\n"
    )

#### Arguments

- `contents`:

  The contents of the `DisplayTerm`

- `separators`:

  How many separators to use between the contents

- `trailing_mode`:

  If the contents should be trailed by the separtors

- `separator`:

  The separating characters (typically `\\n`)

#### Returns

A new `DisplayTerm` object

------------------------------------------------------------------------

### `DisplayTerm$makeText()`

Makes a string from the contents

#### Usage

    DisplayTerm$makeText()

------------------------------------------------------------------------

### `DisplayTerm$getSeparators()`

Gets the separator to use

#### Usage

    DisplayTerm$getSeparators()

#### Returns

The separator characters

------------------------------------------------------------------------

### `DisplayTerm$trailing()`

Applies the trailing to the string

#### Usage

    DisplayTerm$trailing(content)

#### Arguments

- `content`:

  A list or vector of characters

#### Returns

The processed text

------------------------------------------------------------------------

### `DisplayTerm$addTerms()`

Adds more terms to the contents

#### Usage

    DisplayTerm$addTerms(terms)

#### Arguments

- `terms`:

  Item to add to the contents

------------------------------------------------------------------------

### `DisplayTerm$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DisplayTerm$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
