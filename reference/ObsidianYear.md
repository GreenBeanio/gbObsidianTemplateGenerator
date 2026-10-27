# ObsidianYear Class for generating anually template files

ObsidianYear Class for generating anually template files

## Super class

[`ObsidianNote`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/ObsidianNote.md)
-\> `ObsidianYear`

## Methods

### Public methods

- [`ObsidianYear$new()`](#method-ObsidianYear-initialize)

- [`ObsidianYear$processSelf()`](#method-ObsidianYear-processSelf)

- [`ObsidianYear$processChild()`](#method-ObsidianYear-processChild)

- [`ObsidianYear$processTitle()`](#method-ObsidianYear-processTitle)

- [`ObsidianYear$processOutput()`](#method-ObsidianYear-processOutput)

- [`ObsidianYear$clone()`](#method-ObsidianYear-clone)

Inherited methods

- [`ObsidianNote$getTemplate()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-getTemplate)
- [`ObsidianNote$process()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-process)
- [`ObsidianNote$processVariables()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/html/ObsidianNote.html#method-ObsidianNote-processVariables)

------------------------------------------------------------------------

### `ObsidianYear$new()`

Initialize a new `ObsidianYear` object

#### Usage

    ObsidianYear$new(
      output_dir = here::here(),
      file_name = "Year.md",
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

A new `ObsidianYear` object

------------------------------------------------------------------------

### `ObsidianYear$processSelf()`

Processes the template for the current object level

#### Usage

    ObsidianYear$processSelf(vars, child_res)

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

### `ObsidianYear$processChild()`

Processes the child template object

#### Usage

    ObsidianYear$processChild()

#### Returns

A list of the header name and the corresponding file paths from the
child Runs child class

------------------------------------------------------------------------

### `ObsidianYear$processTitle()`

Processes the title

#### Usage

    ObsidianYear$processTitle()

#### Returns

The title as a character

------------------------------------------------------------------------

### `ObsidianYear$processOutput()`

Processes the output location

#### Usage

    ObsidianYear$processOutput(vars)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp

#### Returns

The output path as a character

------------------------------------------------------------------------

### `ObsidianYear$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ObsidianYear$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
