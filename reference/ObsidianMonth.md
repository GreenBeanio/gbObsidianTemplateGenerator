# ObsidianMonth Class for generating monthly template files

ObsidianMonth Class for generating monthly template files

## Super class

[`ObsidianNote`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/ObsidianNote.md)
-\> `ObsidianMonth`

## Methods

### Public methods

- [`ObsidianMonth$new()`](#method-ObsidianMonth-initialize)

- [`ObsidianMonth$processSelf()`](#method-ObsidianMonth-processSelf)

- [`ObsidianMonth$processChild()`](#method-ObsidianMonth-processChild)

- [`ObsidianMonth$processTitle()`](#method-ObsidianMonth-processTitle)

- [`ObsidianMonth$processOutput()`](#method-ObsidianMonth-processOutput)

- [`ObsidianMonth$clone()`](#method-ObsidianMonth-clone)

Inherited methods

- [`ObsidianNote$getTemplate()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-getTemplate)
- [`ObsidianNote$process()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-process)
- [`ObsidianNote$processVariables()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-processVariables)

------------------------------------------------------------------------

### `ObsidianMonth$new()`

Initialize a new `ObsidianMonth` object

#### Usage

    ObsidianMonth$new(
      output_dir = here::here(),
      file_name = "Month.md",
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

A new `ObsidianMonth` object

------------------------------------------------------------------------

### `ObsidianMonth$processSelf()`

Processes the template for the current object level

#### Usage

    ObsidianMonth$processSelf(vars, child_res)

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

### `ObsidianMonth$processChild()`

Processes the child template object

#### Usage

    ObsidianMonth$processChild()

#### Returns

A list of the header name and the corresponding file paths from the
child Runs child class

------------------------------------------------------------------------

### `ObsidianMonth$processTitle()`

Processes the title

#### Usage

    ObsidianMonth$processTitle()

#### Returns

The title as a character

------------------------------------------------------------------------

### `ObsidianMonth$processOutput()`

Processes the output location

#### Usage

    ObsidianMonth$processOutput(vars)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp

#### Returns

The output path as a character

------------------------------------------------------------------------

### `ObsidianMonth$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ObsidianMonth$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
