author <- ReplaceTermString$new("author", c("Monday.md",
                                            "Tuesday.md",
                                            "Wednesday.md"))
days <- ReplaceTermHeader$new("days",
                              list("Monday" = "x",
                                   "Tuesday" = "y",
                                   "Wednesday" = "z"),
                              2)
# days$generateReplacement()
y <- Terms$new()
y$addTerm(author)
y$addTerm(days)
y$termsList()
y$getTerms()
y$getMatcher()

#readr::read_file(here::here("inst", "extdata", "Week.md"))
