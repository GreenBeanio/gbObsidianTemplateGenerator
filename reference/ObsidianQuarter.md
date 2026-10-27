# ObsidianQuarter Class for generating quarterly template files

ObsidianQuarter Class for generating quarterly template files

## Super class

[`ObsidianNote`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/ObsidianNote.md)
-\> `ObsidianQuarter`

## Methods

### Public methods

- [`ObsidianQuarter$new()`](#method-ObsidianQuarter-initialize)

- [`ObsidianQuarter$processSelf()`](#method-ObsidianQuarter-processSelf)

- [`ObsidianQuarter$processChild()`](#method-ObsidianQuarter-processChild)

- [`ObsidianQuarter$processTitle()`](#method-ObsidianQuarter-processTitle)

- [`ObsidianQuarter$processOutput()`](#method-ObsidianQuarter-processOutput)

- [`ObsidianQuarter$clone()`](#method-ObsidianQuarter-clone)

Inherited methods

- [`ObsidianNote$getTemplate()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-getTemplate)
- [`ObsidianNote$process()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-process)
- [`ObsidianNote$processVariables()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-processVariables)

------------------------------------------------------------------------

### `ObsidianQuarter$new()`

Initialize a new `ObsidianQuarter` object

#### Usage

    ObsidianQuarter$new(
      output_dir = here::here(),
      file_name = "Quarter.md",
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

A new `ObsidianQuarter` object

------------------------------------------------------------------------

### `ObsidianQuarter$processSelf()`

Processes the template for the current object level

#### Usage

    ObsidianQuarter$processSelf(vars, child_res)

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

### `ObsidianQuarter$processChild()`

Processes the child template object

#### Usage

    ObsidianQuarter$processChild()

#### Returns

A list of the header name and the corresponding file paths from the
child Runs child class

------------------------------------------------------------------------

### `ObsidianQuarter$processTitle()`

Processes the title

#### Usage

    ObsidianQuarter$processTitle()

#### Returns

The title as a character

------------------------------------------------------------------------

### `ObsidianQuarter$processOutput()`

Processes the output location

#### Usage

    ObsidianQuarter$processOutput(vars)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp

#### Returns

The output path as a character

------------------------------------------------------------------------

### `ObsidianQuarter$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ObsidianQuarter$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
