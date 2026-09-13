# Obsidian Template Generator

## Introduction

This is a tool meant to generate missing daily note templates for my Obsidian notes.

It is not very extensible.

The templates require fields to be replaced that are named inside of curly brackets.

Such as: `{title}`

## Template Fields

### Required Fields

All of the templates have these 3 fields inside of the Obsidian YAML headers:

- `{title}`: This is added to the title of the document
- `{creation_date}`: This is the date the file is generated on
- `{unique_timestamp}`: This is the unique time stamp that I use to guarantee files are unique even if they have the same title.
  - This is important because I use the Obsidian file names for linking instead of cumbersome relative or absolute paths.
  - In my documents the file name is constructed with `{title} u-{unique_timestamp}`.
    - Do note that the templates do have extra information added to the title.

### Year

The year has 4 fields:

- `{Quarter 1}`
- `{Quarter 2}`
- `{Quarter 3}`
- `{Quarter 4}`

### Quarter

The quarter has 3 fields:

- `{Month 1}`
- `{Month 2}`
- `{Month 3}`

### Month

The month has 6 fields:

- `{Week 1}`
- `{Week 2}`
- `{Week 3}`
- `{Week 4}`
- `{Week 5}`
- `{Week 6}`

There are 6 of these because that's the max amount of weeks a month can have.

This is annoying and I will probably just replace it with a single field and have
the code generate only the needed months.

### Week

The week has 7 fields:

- `{Monday}`
- `{Tuesday}`
- `{Wednesday}`
- `{Thursday}`
- `{Friday}`
- `{Saturday}`
- `{Sunday}`

This is another annoying one where I will probably replace it with a single
field.

### Day

The day has no additional fields.