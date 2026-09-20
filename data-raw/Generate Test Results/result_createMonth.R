temp_dir <- tempdir()
output_path <- createMonth(input_date = test_time,
                         output_dir = temp_dir,
                         unique_timestamp = test_time)
loaded_file <- readr::read_file(output_path[[1]])
saveRDS(loaded_file,
        file = testthat::test_path("testdata", "create_month.rda"))
unlink(temp_dir)
