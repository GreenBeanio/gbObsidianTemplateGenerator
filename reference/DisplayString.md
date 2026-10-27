# DisplayString A class for displaying strings

DisplayString A class for displaying strings

## Super classes

[`Term`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/Term.md)
-\>
[`DisplayTerm`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/DisplayTerm.md)
-\> `DisplayString`

## Active bindings

- `contents`:

  A vector of replacement strings

## Methods

### Public methods

- [`DisplayString$new()`](#method-DisplayString-initialize)

- [`DisplayString$makeText()`](#method-DisplayString-makeText)

- [`DisplayString$addTerms()`](#method-DisplayString-addTerms)

- [`DisplayString$clone()`](#method-DisplayString-clone)

Inherited methods

- [`DisplayTerm$getSeparators()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerm.html#method-DisplayTerm-getSeparators)
- [`DisplayTerm$trailing()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerm.html#method-DisplayTerm-trailing)

------------------------------------------------------------------------

### `DisplayString$new()`

Initialize a new `DisplayString` object

#### Usage

    DisplayString$new(
      contents,
      separators = 0,
      trailing_mode = FALSE,
      separator = "\n"
    )

#### Arguments

- `contents`:

  The contents of the `DisplayString`

- `separators`:

  How many separators to use between the contents

- `trailing_mode`:

  If the contents should be trailed by the separtors

- `separator`:

  The separating characters (typically `\\n`)

#### Returns

A new `DisplayString` object

------------------------------------------------------------------------

### `DisplayString$makeText()`

Generates the string to insert

#### Usage

    DisplayString$makeText()

#### Returns

The display text

------------------------------------------------------------------------

### `DisplayString$addTerms()`

Adds a terms terms to the contents

#### Usage

    DisplayString$addTerms(terms)

#### Arguments

- `terms`:

  A character or a vector of character objects Adds a terms terms to the
  contents

------------------------------------------------------------------------

### `DisplayString$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DisplayString$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
