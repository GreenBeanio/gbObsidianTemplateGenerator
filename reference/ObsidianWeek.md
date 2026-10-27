# ObsidianWeek Class for generating weekly template files

ObsidianWeek Class for generating weekly template files

## Super class

[`ObsidianNote`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/ObsidianNote.md)
-\> `ObsidianWeek`

## Methods

### Public methods

- [`ObsidianWeek$new()`](#method-ObsidianWeek-initialize)

- [`ObsidianWeek$processSelf()`](#method-ObsidianWeek-processSelf)

- [`ObsidianWeek$processChild()`](#method-ObsidianWeek-processChild)

- [`ObsidianWeek$processTitle()`](#method-ObsidianWeek-processTitle)

- [`ObsidianWeek$processOutput()`](#method-ObsidianWeek-processOutput)

- [`ObsidianWeek$clone()`](#method-ObsidianWeek-clone)

Inherited methods

- [`ObsidianNote$getTemplate()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-getTemplate)
- [`ObsidianNote$process()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-process)
- [`ObsidianNote$processVariables()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-processVariables)

------------------------------------------------------------------------

### `ObsidianWeek$new()`

Initialize a new `ObsidianWeek` object

#### Usage

    ObsidianWeek$new(
      output_dir = here::here(),
      file_name = "Week.md",
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

A new `ObsidianWeek` object

------------------------------------------------------------------------

### `ObsidianWeek$processSelf()`

Processes the template for the current object level

#### Usage

    ObsidianWeek$processSelf(vars, child_res)

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

### `ObsidianWeek$processChild()`

Processes the child template object

#### Usage

    ObsidianWeek$processChild()

#### Returns

A list of the header name and the corresponding file paths from the
child Runs child class

------------------------------------------------------------------------

### `ObsidianWeek$processTitle()`

Processes the title

#### Usage

    ObsidianWeek$processTitle()

#### Returns

The title as a character

------------------------------------------------------------------------

### `ObsidianWeek$processOutput()`

Processes the output location

#### Usage

    ObsidianWeek$processOutput(vars)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp

#### Returns

The output path as a character

------------------------------------------------------------------------

### `ObsidianWeek$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ObsidianWeek$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
