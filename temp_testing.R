source_file <- readr::read_file(here::here("inst",
                                           "extdata",
                                           "Templates",
                                           "Week.md"))

test_header <- DisplayHeader$new(
  contents = list(
    DisplayHeader$new(
      contents = list(DisplayNone$new(),
                      DisplayTerms$new(
                        contents =
                          list(
                            DisplayString$new(
                              contents = c("Hi there 1"),
                              trailing_mode = TRUE),
                            DisplayString$new(
                              contents = c("Hi there 2"),
                              trailing_mode = FALSE)
                          ))),
      header = "Second",
      header_level = 3,
      link = "Top-Header")),
  header = "Top Header",
  header_level = 2,
  trailing_mode = TRUE,
  new_lines = 2)
test_header$makeString()

test_string <-
  DisplayString$new(
    contents = c("Cool String", "So True")
  )
test_string$makeString()

test_replace_1 <- ReplaceTerm$new(
  search_term = "Days",
  contents = test_header)
test_replace_1$makeReplacement()
test_replace_1$makeSearch()

test_replace_2 <- ReplaceTerm$new(
  search_term = "title",
  contents = test_string)
test_replace_2$makeReplacement()

test_replace_terms <- Replacer$new(
  contents = list(test_replace_1, test_replace_2))
test_replace_terms$makeReplacement()

template <- Templater$new(
  replacers = test_replace_terms,
  template = source_file
)
res <- template$process()
