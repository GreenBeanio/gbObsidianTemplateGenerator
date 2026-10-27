# DisplayHeader A class for holding other `DisplayTerm` objects to create headers

DisplayHeader A class for holding other `DisplayTerm` objects to create
headers

## Super classes

[`Term`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/Term.md)
-\>
[`DisplayTerm`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/DisplayTerm.md)
-\>
[`DisplayTerms`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/DisplayTerms.md)
-\> `DisplayHeader`

## Active bindings

- `header`:

  The header value

- `level`:

  An integer for the base level of the replacement header

- `link`:

  A link for the header

## Methods

### Public methods

- [`DisplayHeader$new()`](#method-DisplayHeader-initialize)

- [`DisplayHeader$makeText()`](#method-DisplayHeader-makeText)

- [`DisplayHeader$clone()`](#method-DisplayHeader-clone)

Inherited methods

- [`DisplayTerm$getSeparators()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerm.html#method-DisplayTerm-getSeparators)
- [`DisplayTerm$trailing()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerm.html#method-DisplayTerm-trailing)
- [`DisplayTerms$addTerms()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/DisplayTerms.html#method-DisplayTerms-addTerms)

------------------------------------------------------------------------

### `DisplayHeader$new()`

Initialize a new `DisplayHeader` object

#### Usage

    DisplayHeader$new(
      header,
      level,
      contents,
      link = "",
      trailing_mode = TRUE,
      separators = 2,
      separator = "\n"
    )

#### Arguments

- `header`:

  The name for the header

- `level`:

  The level of the header

- `contents`:

  The contents of the `DisplayHeader`

- `link`:

  The link for the header, if there is one

- `trailing_mode`:

  If the contents should be trailed by the separtors

- `separators`:

  How many separators to use between the contents

- `separator`:

  The separating characters (typically `\\n`)

#### Returns

A new `DisplayHeader` object

------------------------------------------------------------------------

### `DisplayHeader$makeText()`

Generates the string to insert

#### Usage

    DisplayHeader$makeText()

#### Returns

The display text

------------------------------------------------------------------------

### `DisplayHeader$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DisplayHeader$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
