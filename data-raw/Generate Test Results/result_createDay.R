temp_dir <- tempdir()
output_path <- createDay(input_date = test_time,
                         output_dir = temp_dir,
                         unique_timestamp = test_time)
loaded_file <- readr::read_file(output_path[[1]])
saveRDS(loaded_file,
        file = testthat::test_path("testdata", "create_day.rda"))
unlink(temp_dir)
