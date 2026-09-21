# Contributing

## Requirements

You will need at least R version 4.3.0.

1.  Clone this repository
2.  Use
    [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html)
    to install all the needed packages

## Tools

- `devtools::document()` for building documentation
- `devtools::load_all()` for loading the package locally
- `devtools::check()` for checking the package
- `devtools::test()` for running the tests in the package
- `devtools::test_coverage()` for testing code coverage
- `usethis::use_package()` for adding any new packages
- [`renv::install()`](https://rstudio.github.io/renv/reference/install.html)
  for installing any new packages
- [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html)
  for saving any new packages to the lock file
- `usethis::use_version()` for incrementing versions

## Contributing

- New functions must have unit tests
- Unit tests should match the structure of the source code
- All unit tests must pass
- All functions must be documented with roxygen2
- Code must match the existing code base. Mainly just the basics:
  - variables: snake_case
  - functions: camelCase
  - classes: PascalCase
  - constants: SNAKE_CASE
  - Descriptive names
  - Code should aim to be self-documenting, but I’m more fond of
    comments than many others are
  - Functions should be focused on a sole responsibility while having as
    few lines as possible and as few parameters as possible
  - Aim for readability and maintainability over arcane forms of
    cleverness
- Any usage of GenAI must have Co-authored-by trailers in the commits
  - GenAI additions are not appreciated
- Pull requests and issues can be made
  - I would prefer if would reach out to me first. Given that this is
    just a little personal project I would be hesitant to allow
    additional contributions. I would lean towards creating your own
    forked version instead.
  - I’m a pretty chill guy. If you do open any Issues or Pull Requests
    just don’t be a dick about.
