# author <- ReplaceTermString$new("author", c("Monday.md",
#                                             "Tuesday.md",
#                                             "Wednesday.md"))
# days <- ReplaceTermHeader$new("days",
#                               list("Monday" = "x",
#                                    "Tuesday" = "y",
#                                    "Wednesday" = "z"),
#                               2)
# # days$generateReplacement()
# y <- Terms$new()
# y$addTerm(author)
# y$addTerm(days)
# y$termsList()
# y$getTerms()
# y$getMatcher()
#
# #readr::read_file(here::here("inst", "extdata", "Week.md"))
#

z <- DisplayHeader$new(
  contents = list(
    DisplayHeader$new(
      contents = list(DisplayNone$new()),
      header = "Second",
      header_level = 3,
      link = "Top-Header")),
  header = "Top Header",
  header_level = 2,
  new_lines = 2)
z$makeString()
