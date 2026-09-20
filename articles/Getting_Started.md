# Getting Started

## Overview

gbObsidianTemplateGenerator is a R package for generating daily journal
like notes for Obsidian from tempaltes.

The primary advantage of this is to have pre-linked files.

## Installation

To install this package simply run the following:

``` r

pak::pkg_install("GreenBeanio/gbObsidianTemplateGenerator")
```

## Usage

The package has 5 main functions:

- [`createDay()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/createDay.md)
- [`createWeek()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/createWeek.md)
- [`createMonth()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/createMonth.md)
- [`createQuarter()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/createQuarter.md)
- [`createYear()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/createYear.md)

Each of these functions will generate their corresponding template as
well as all of the needed children.

The files get output to a specific file structure:

``` text
output_dir/
├── 0_Daily Notes/
│   ├── 2026/
│   │   ├── 01/
│   │   │   └── ...
│   │   ├── .../
│   │   │   └── ...
│   │   └── 12/
│   │       └── ...
│   └── .../
├── 1_Weekly Notes/
│   ├── 2026/
│   │   └── ...
│   └── .../
├── 2_Monthly Notes/
│   ├── 2026/
│   │   └── ...
│   └── .../
├── 3_Quarterly Notes/
│   ├── 2026/
│   │   └── ...
│   └── .../
└── 4_Yearly Notes/
    └── ...
```

For simplicity I will only show the an example for generating an entire
year.

At the simplest level all you would have to do is as follows:

``` r

createYear()
```

This would use the current date, the default templates from the package,
your current working directory as the output directory, and your
computer’s username as the author name.

A more realistic example would be:

``` r

createYear(
  template_dir = here::here("Obsidian-Templates"),
  output_dir = here::here("Obsidian-Vault", "Planning Notes"),
  author = "Garrett Johnson")
```

In this example you are using you are specifying a directory where you
have your custom templates, a directory to output the files to, and your
name.

It is important to note that if you use this script in an existing
directory it will not overwrite existing files and will instead skip
them. However, due to the nature of the `unique_timestamp` parameter
there is little to no chance of file names conflicting. This also means
that if you are attempting to generate missing dates from your notes
that it will most likely create duplicate days. I would personally
generate the needed range in a separate directory and then copy over the
needed generated files. You will likely need to slightly modify specific
notes to link to the existing files instead of the new files. This is a
small annoyance that should not be a common occurance.

I will now go into what templates are needed.

## Templates

The deafult templates can be found with:

``` r

system.file("extdata", "Templates", package = "gbObsidianTemplateGenerator")
```

***DO NOT*** attempt to modify the templates in the package installation
directly. Instead copy those templates and modify them, or create new
templates from scratch.

If you want to copy all of the templates you can do so with:

``` r

templates <- dir(system.file("extdata", "Templates", 
                             package = "gbObsidianTemplateGenerator"), 
                 pattern = "*.md", 
                 full.names = TRUE)
file.copy(from = templates,
          to = here::here("Templates"))
```

The sections of the templates that get replaced are wrapped in
[`{}`](https://rdrr.io/r/base/Paren.html) brackets.

All of the tempaltes contain the following varaibles that are used for
Obsidian metadata:

- `{title}`: This is added to the title of the document.
- `{creation_date}`: This is the date the file is generated on.
- `{unique_timestamp}`: This is the unique time stamp that is used to
  guarantee files are unique even if they have the same title.
- `{author}`: This is the name of who is using the template.

Additionally many of the templates have additional variables:

- Week
  - `{Days}`: This will be autopopulated with links to the daily notes
    within that week.
- Month
  - `{Weeks}`: This will be autopopulated with links to the weekly notes
    within that month
- Quarter
  - `{Month 1}`, `{Month 2}`, and `{Month 3}`: Will be linked to the
    corresponding months in that quarter.
- Year
  - `{Quarter 1}`, `{Quarter 2}`, `{Quarter 3}`, and `{Quarter 4}`: Will
    be linked to the corresponding quarters in that year.

Do note that you can omit any of these variables in your template, but
they are the variables intended to be used.

## Template Directory

These functions ***DO NOT*** take a single template file. Instead they
take a directory that is expected to have the corresponding templates
for their corresponding functions:

- `Day.md`
- `Week.md`
- `Month.md`
- `Quarter.md`
- `Year.md`

This is done to easily pass the location of the templates from the
parent to the child function.

There is an additional parameter named `template_pre`. This allows you
to store multiple versions of these templates in the same directory as
long as they are prefixed with the characters from `template_pre`. For
example, if you had a directory with `work-Day.md` and `personal-Day.md`
templates and set `template_pre = "work-` then the functions would use
the templates prefixed by `work-`. Be warned that there is no saftey
check to use the default template if there is not a matching template
with that prefix. A better solution would be to have seperate
directories for any custom templates, but both options will work.

## File Naming

The file names are constructed from the `{title}`, pre-programmed text,
and the `{unique_timestamp}`. This is done because Obsidian allows for
linking to files using file names. This allows your to use unique file
names instead of cumbersome relative or absolute paths. The advantage of
this is that you can reorganize your files manually at anytime without
breaking the pre-existing links.

The `{title}` variable will be determined by the function, but the
`{unique_timestamp}` variable comes from the time that you pass as the
`unique_timestamp` parameter into the function. There is little to no
reason to change this from being the default argument of
[`Sys.time()`](https://rdrr.io/r/base/Sys.time.html)

## Header Function

It is very unlikely that you will need to change the `header_func`
parameter. This parameter is assigned a function that is used to process
file paths into the link applied to the headers. By deafult this uses
the function
[`makeObsidianFilePath()`](https://greenbeanio.github.io/gbObsidianTemplateGenerator/reference/makeObsidianFilePath.md)
which simply extracts just the file name and extension and escapes the
text to be URL safe. This format is what Obsidian needs for unique file
name linking. If you however want to change what the link is simply pass
in another function that takes a list of named file paths and returns a
list of named file paths. This is easily accomplished by using
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html).
