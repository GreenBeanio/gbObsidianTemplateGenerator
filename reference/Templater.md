# Templater A class to process a template

Templater A class to process a template

## Active bindings

- `replacer`:

  A `Replacer` instance

- `template`:

  A character template Initialize a new `Templater` object

## Methods

### Public methods

- [`Templater$new()`](#method-Templater-initialize)

- [`Templater$process()`](#method-Templater-process)

- [`Templater$clone()`](#method-Templater-clone)

------------------------------------------------------------------------

### `Templater$new()`

#### Usage

    Templater$new(replacer, template)

#### Arguments

- `replacer`:

  A `Replacer` instance

- `template`:

  A character template

#### Returns

A new `Templater` object

------------------------------------------------------------------------

### `Templater$process()`

Processes the template

#### Usage

    Templater$process(force = FALSE)

#### Arguments

- `force`:

  Force processing a template even if it has already been processed

#### Returns

The processed character template

------------------------------------------------------------------------

### `Templater$clone()`

The objects of this class are cloneable with this method.

#### Usage

    Templater$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
