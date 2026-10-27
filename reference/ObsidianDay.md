# ObsidianDay Class for generating daily template files

ObsidianDay Class for generating daily template files

## Super class

[`ObsidianNote`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/ObsidianNote.md)
-\> `ObsidianDay`

## Methods

### Public methods

- [`ObsidianDay$new()`](#method-ObsidianDay-initialize)

- [`ObsidianDay$processSelf()`](#method-ObsidianDay-processSelf)

- [`ObsidianDay$processChild()`](#method-ObsidianDay-processChild)

- [`ObsidianDay$processTitle()`](#method-ObsidianDay-processTitle)

- [`ObsidianDay$processOutput()`](#method-ObsidianDay-processOutput)

- [`ObsidianDay$clone()`](#method-ObsidianDay-clone)

Inherited methods

- [`ObsidianNote$getTemplate()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-getTemplate)
- [`ObsidianNote$process()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-process)
- [`ObsidianNote$processVariables()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-processVariables)

------------------------------------------------------------------------

### `ObsidianDay$new()`

Initialize a new `ObsidianDay` object

#### Usage

    ObsidianDay$new(
      output_dir = here::here(),
      file_name = "Day.md",
      input_date = Sys.Date(),
      author = Sys.info()[["user"]],
      template_dir = system.file("extdata", "Templates", package =
        "gbObsidianTemplateGenerator"),
      header_func = makeObsidianFilePath,
      unique_timestamp = Sys.time()
    )

#### Arguments

- `output_dir`:

  The directory to export to

- `file_name`:

  The file name of the template

- `input_date`:

  The date of the file

- `author`:

  The author name

- `template_dir`:

  The directory with the templates

- `header_func`:

  The function to process header links (takes a list of name-link)

- `unique_timestamp`:

  A unique time to uniquely name files

#### Returns

A new `ObsidianDay` object

------------------------------------------------------------------------

### `ObsidianDay$processSelf()`

Processes the template for the current object level

#### Usage

    ObsidianDay$processSelf(vars, child_res)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp, output, and
  template

- `child_res`:

  Takes a list of child headers and file paths

#### Returns

A list of the header name and the corresponding file path Exports needed
templates

------------------------------------------------------------------------

### `ObsidianDay$processChild()`

Processes the child template object

#### Usage

    ObsidianDay$processChild()

#### Returns

A list of the header name and the corresponding file paths from the
child Runs child class

------------------------------------------------------------------------

### `ObsidianDay$processTitle()`

Processes the title

#### Usage

    ObsidianDay$processTitle()

#### Returns

The title as a character

------------------------------------------------------------------------

### `ObsidianDay$processOutput()`

Processes the output location

#### Usage

    ObsidianDay$processOutput(vars)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp

#### Returns

The output path as a character

------------------------------------------------------------------------

### `ObsidianDay$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ObsidianDay$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
