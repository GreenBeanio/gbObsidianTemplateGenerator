test_that("obsidianMetadataReplace", {
  obsidian_metadata_replace <- obsidianMetadataReplace(
    template = readr::read_file(system.file("extdata",
                                           "Templates", "Day.md",
                                           package = "gbObsidianTemplateGenerator")),
    title = strftime(test_time, "%Y_%m_%d"),
    creation_date = strftime(test_time, "%Y-%m-%d"),
    unique_timestamp = strftime(test_time, "%Y%m%d%H%M%S"),
    author = "Test User")
  loaded_file <- readRDS(testthat::test_path("testdata", "obsidian_metadata_replace.rda"))
  testthat::expect_equal(obsidian_metadata_replace, loaded_file)
})

test_that("makeObsidianFilePath", {
  make_obsidian_file_path <- makeObsidianFilePath(
    list_of_paths = list(
      `Quarter 1` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_1 Quarterly Note u-00000000000000.md",
      `Quarter 2` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_2 Quarterly Note u-00000000000000.md",
      `Quarter 3` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_3 Quarterly Note u-00000000000000.md",
      `Quarter 4` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_4 Quarterly Note u-00000000000000.md"))
  loaded_file <- readRDS(testthat::test_path("testdata", "make_obsidian_file_path.rda"))
  testthat::expect_equal(make_obsidian_file_path, loaded_file)
})

test_that("replaceHeaderLinksGroup", {
  replace_header_links_group <- replaceHeaderLinksGroup(
    header_values = list(
      Weeks = list(
        `Week 1` = "test_file_1.md",
        `Week 2` = "test_file_2.md",
        `Week 3` = "test_file_3.md",
        `Week 4` = "test_file_4.md")),
    possible_header_values = c("Weeks", paste0("Week ", 1:4)),
    template = readr::read_file(system.file("extdata",
                                           "Templates", "Month.md",
                                           package = "gbObsidianTemplateGenerator")))
  loaded_file <- readRDS(testthat::test_path("testdata", "replace_header_links_group.rda"))
  testthat::expect_equal(replace_header_links_group, loaded_file)
})

test_that("replaceHeaderLinksSingle", {
  replace_header_links_single <- replaceHeaderLinksSingle(
    header_values = list(
      `Quarter 1` = "test_file_1.md",
      `Quarter 2` = "test_file_2.md",
      `Quarter 3` = "test_file_3.md",
      `Quarter 4` = "test_file_4.md"),
    possible_header_values = paste0("Quarter ", 1:4),
    template = readr::read_file(system.file("extdata",
                                           "Templates", "Year.md",
                                           package = "gbObsidianTemplateGenerator")))
  loaded_file <- readRDS(testthat::test_path("testdata", "replace_header_links_single.rda"))
  testthat::expect_equal(replace_header_links_single, loaded_file)
})

test_that("replaceHeaderLinks", {
  replace_header_links <- replaceHeaderLinks(
    header_values = list(
      Weeks = list(
        `Week 1` = "test_file_1.md",
        `Week 2` = "test_file_2.md",
        `Week 3` = "test_file_3.md",
        `Week 4` = "test_file_4.md"),
      `Daily Poem` = "daily_poem.md"),
    possible_header_values = c("Weeks", "Daily Poem", paste0("Week ", 1:4)),
    template = readr::read_file(system.file("extdata",
                                           "Templates", "Month.md",
                                           package = "gbObsidianTemplateGenerator")))
  loaded_file <- readRDS(testthat::test_path("testdata", "replace_header_links.rda"))
  testthat::expect_equal(replace_header_links, loaded_file)
})
