test_that("createDay", {
  temp_dir <- file.path(tempdir(), "Ouput")
  dir.create(temp_dir)
  output_path <- createDay(input_date = test_time,
                           output_dir = temp_dir,
                           unique_timestamp = test_time,
                           author = "Test User")
  test_result <- readr::read_file(output_path[[1]])
  loaded_file <- readRDS(testthat::test_path("testdata", "create_day.rda"))
  testthat::expect_equal(test_result, loaded_file)
  unlink(temp_dir, recursive = TRUE, force = TRUE)
})
