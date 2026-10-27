test_that("ObsidianMonth", {
  temp_dir <- file.path(tempdir(), "Ouput")
  dir.create(temp_dir)
  output_path <- ObsidianMonth$new(
    input_date = lubridate::date(test_time),
    output_dir = temp_dir,
    unique_timestamp = test_time,
    author = "Test User")$process()[[1]]
  test_result <- readr::read_file(output_path[[1]])
  loaded_file <- readRDS(testthat::test_path("testdata", "ObsidianMonth.rds"))
  testthat::expect_equal(test_result, loaded_file)
  unlink(temp_dir, recursive = TRUE, force = TRUE)
})
