# ObsidianNote Base class for `ObsidianNote` classes

ObsidianNote Base class for `ObsidianNote` classes

## Active bindings

- `output_dir`:

  The template directory

- `file_name`:

  The template file name

- `input_date`:

  The input date

- `author`:

  The author

- `template_dir`:

  The template directory

- `header_func`:

  The header function

- `unique_timestamp`:

  The unique time stamp

## Methods

### Public methods

- [`ObsidianNote$new()`](#method-ObsidianNote-initialize)

- [`ObsidianNote$process()`](#method-ObsidianNote-process)

- [`ObsidianNote$processVariables()`](#method-ObsidianNote-processVariables)

- [`ObsidianNote$processSelf()`](#method-ObsidianNote-processSelf)

- [`ObsidianNote$processChild()`](#method-ObsidianNote-processChild)

- [`ObsidianNote$processTitle()`](#method-ObsidianNote-processTitle)

- [`ObsidianNote$processOutput()`](#method-ObsidianNote-processOutput)

- [`ObsidianNote$getTemplate()`](#method-ObsidianNote-getTemplate)

- [`ObsidianNote$clone()`](#method-ObsidianNote-clone)

------------------------------------------------------------------------

### `ObsidianNote$new()`

Initialize a new ObsidianNote object

#### Usage

    ObsidianNote$new(
      file_name,
      output_dir = here::here(),
      input_date = Sys.Date(),
      author = Sys.info()[["user"]],
      template_dir = system.file("extdata", "Templates", package =
        "gbObsidianTemplateGenerator"),
      header_func = makeObsidianFilePath,
      unique_timestamp = Sys.time()
    )

#### Arguments

- `file_name`:

  The file name of the template

- `output_dir`:

  The directory to export to

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

A new `ObsidianNote` object

------------------------------------------------------------------------

### `ObsidianNote$process()`

The main process method to call Exports needed templates

#### Usage

    ObsidianNote$process()

#### Returns

A list of the header name and the corresponding file path

------------------------------------------------------------------------

### `ObsidianNote$processVariables()`

Processes variables used in other functions

#### Usage

    ObsidianNote$processVariables()

#### Returns

A list with the following strings:

- title: title for document

- creation_date: date of the template

- timestamp: unique timestamp

- output: output file path

- template: The loaded template

- obsidian_replacer: The replacer for obsdiain metadata

------------------------------------------------------------------------

### `ObsidianNote$processSelf()`

Processes the template for the current object level

#### Usage

    ObsidianNote$processSelf(vars, child_res)

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

### `ObsidianNote$processChild()`

Processes the child template object

#### Usage

    ObsidianNote$processChild()

#### Returns

A list of the header name and the corresponding file paths from the
child Runs child class

------------------------------------------------------------------------

### `ObsidianNote$processTitle()`

Processes the title

#### Usage

    ObsidianNote$processTitle()

#### Returns

The title as a character

------------------------------------------------------------------------

### `ObsidianNote$processOutput()`

Processes the output location

#### Usage

    ObsidianNote$processOutput(vars)

#### Arguments

- `vars`:

  A list of strings for title, creation_date, timestamp

#### Returns

The output path as a character

------------------------------------------------------------------------

### `ObsidianNote$getTemplate()`

Loads the template file

#### Usage

    ObsidianNote$getTemplate()

#### Returns

The template as a character

------------------------------------------------------------------------

### `ObsidianNote$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ObsidianNote$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
