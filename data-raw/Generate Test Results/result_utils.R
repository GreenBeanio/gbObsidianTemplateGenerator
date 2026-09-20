obsidian_metadata_replace <- obsidianMetadataReplace(
  template = readr::read_file(here::here("inst", "extdata",
                                         "Templates", "Day.md")),
  title = strftime(test_time, "%Y_%m_%d"),
  creation_date = strftime(test_time, "%Y-%m-%d"),
  unique_timestamp = strftime(test_time, "%Y%m%d%H%M%S"),
  author = "Test User")
saveRDS(obsidian_metadata_replace,
        file = testthat::test_path("testdata", "obsidian_metadata_replace.rda"))

make_obsidian_file_path <- makeObsidianFilePath(
  list_of_paths = list(
    `Quarter 1` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_1 Quarterly Note u-00000000000000.md",
    `Quarter 2` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_2 Quarterly Note u-00000000000000.md",
    `Quarter 3` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_3 Quarterly Note u-00000000000000.md",
    `Quarter 4` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_4 Quarterly Note u-00000000000000.md"))
saveRDS(make_obsidian_file_path,
        file = testthat::test_path("testdata", "make_obsidian_file_path.rda"))

replace_header_links_group <- replaceHeaderLinksGroup(
  header_values = list(
    Weeks = list(
      `Week 1` = "test_file_1.md",
      `Week 2` = "test_file_2.md",
      `Week 3` = "test_file_3.md",
      `Week 4` = "test_file_4.md")),
  possible_header_values = c("Weeks", paste0("Week ", 1:4)),
  template = readr::read_file(here::here("inst", "extdata",
                                         "Templates", "Month.md")))
saveRDS(replace_header_links_group,
        file = testthat::test_path("testdata", "replace_header_links_group.rda"))

replace_header_links_single <- replaceHeaderLinksSingle(
  header_values = list(
    `Quarter 1` = "test_file_1.md",
    `Quarter 2` = "test_file_2.md",
    `Quarter 3` = "test_file_3.md",
    `Quarter 4` = "test_file_4.md"),
  possible_header_values = paste0("Quarter ", 1:4),
  template = readr::read_file(here::here("inst", "extdata",
                                         "Templates", "Year.md")))
saveRDS(replace_header_links_single,
        file = testthat::test_path("testdata", "replace_header_links_single.rda"))

replace_header_links <- replaceHeaderLinks(
  header_values = list(
    Weeks = list(
      `Week 1` = "test_file_1.md",
      `Week 2` = "test_file_2.md",
      `Week 3` = "test_file_3.md",
      `Week 4` = "test_file_4.md"),
    `Daily Poem` = "daily_poem.md"),
  possible_header_values = c("Weeks", "Daily Poem", paste0("Week ", 1:4)),
  template = readr::read_file(here::here("inst", "extdata",
                                         "Templates", "Month.md")))
saveRDS(replace_header_links,
        file = testthat::test_path("testdata", "replace_header_links.rda"))
