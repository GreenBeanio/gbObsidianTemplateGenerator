temp_dir <- tempdir()
output_path <- createYear(input_date = test_time,
                         output_dir = temp_dir,
                         unique_timestamp = test_time,
                         author = "Test User")
loaded_file <- readr::read_file(output_path[[1]])
saveRDS(loaded_file,
        file = testthat::test_path("testdata", "create_year.rda"))
unlink(temp_dir)
