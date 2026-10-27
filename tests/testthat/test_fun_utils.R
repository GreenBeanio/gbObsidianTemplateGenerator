test_that("makeObsidianFilePath", {
  make_obsidian_file_path <- makeObsidianFilePath(
    list_of_paths = list(
      `Quarter 1` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_1 Quarterly Note u-00000000000000.md",
      `Quarter 2` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_2 Quarterly Note u-00000000000000.md",
      `Quarter 3` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_3 Quarterly Note u-00000000000000.md",
      `Quarter 4` = "/home/test_user/Notes/0_Planning Notes/02_Quarterly Notes/2026_4 Quarterly Note u-00000000000000.md"))
  loaded_file <- readRDS(testthat::test_path("testdata", "makeObsidianFilePath.rds"))
  testthat::expect_equal(make_obsidian_file_path, loaded_file)
})
