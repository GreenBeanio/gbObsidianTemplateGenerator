test_that("createQuarter", {
  temp_dir <- tempdir()
  output_path <- createQuarter(input_date = test_time,
                               output_dir = temp_dir,
                               unique_timestamp = test_time)
  test_result <- readr::read_file(output_path[[1]])
  loaded_file <- readRDS(testthat::test_path("testdata", "create_quarter.rda"))
  testthat::expect_equal(test_result, loaded_file)
  unlink(temp_dir)
})
